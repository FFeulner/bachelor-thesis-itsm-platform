# Mail_Handler/send_mail_daemon.py
# :contentReference[oaicite:0]{index=0}

# === Bootstrap: Umgebung & Pfade laden, bevor Projektmodule importiert werden ===
import html
import base64
import json
import logging
import os
import sys
from datetime import datetime
from pathlib import Path
from typing import List, Optional
from urllib.parse import urlparse

from dotenv import load_dotenv, dotenv_values
from sqlalchemy import and_, desc
from sqlalchemy.exc import SQLAlchemyError

try:
    import markdown
except Exception as e:
    raise SystemExit(
        "Python package 'markdown' fehlt. Installiere: pip install markdown pygments"
    ) from e


PROJECT_ROOT = Path(__file__).resolve().parents[1]
load_dotenv(PROJECT_ROOT / "settings.env", override=False)
load_dotenv(PROJECT_ROOT / ".env", override=False)
load_dotenv(PROJECT_ROOT / ".env.local", override=False)
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

# --- Logging konfigurieren ---
log = logging.getLogger("send_mail_daemon")
handler = logging.StreamHandler()
handler.setFormatter(logging.Formatter("[%(levelname)s] %(message)s"))
log.addHandler(handler)
log.setLevel(logging.INFO)

# --- Projekt-Imports (nachdem sys.path gesetzt ist) ---
from Mail_Handler.graph_utils import GraphClient, GraphConfig  # noqa: E402
from Mail_Handler.models import Kommunikation, Vorgang        # noqa: E402
from core.mail_db import MailSessionLocal                     # noqa: E402


# ---------------- ENV / CONFIG ----------------
HERE = Path(__file__).resolve().parent
ENV_PATH = HERE / "office.env"
OFFICE = dotenv_values(str(ENV_PATH)) if ENV_PATH.exists() else {}


def require_cfg(name: str) -> str:
    v = OFFICE.get(name) or os.getenv(name)
    if not v or not str(v).strip():
        raise SystemExit(f"{name} fehlt/leer in {ENV_PATH} (oder ENV)")
    return str(v).strip()


TENANT = require_cfg("TENANT_ID")
CLIENT_ID = require_cfg("CLIENT_ID")
CLIENT_SECRET = require_cfg("CLIENT_SECRET")
MAILBOX_SEND = require_cfg("MAILBOX_SEND")

GRAPH = "https://graph.microsoft.com/v1.0"

DEFAULT_FROM_EMAIL = os.getenv("DEFAULT_FROM_EMAIL", "").strip()
SIGNATURE_HTML = os.getenv("SIGNATURE_HTML", "").strip()
SIGNATURE_TEXT = os.getenv("SIGNATURE_TEXT", "").strip()

MEDIA_ROOT = Path(os.getenv("MEDIA_ROOT", PROJECT_ROOT / "media")).resolve()
MEDIA_ROOT.mkdir(parents=True, exist_ok=True)


# ---------------- Helper: Signatur & Body-Rendering ----------------
_MD_EXTENSIONS = [
    "extra",
    "sane_lists",
    "smarty",
    "nl2br",
    "fenced_code",
    "codehilite",
    "tables",
    "del",
]


def render_body_html(md_text: str) -> str:
    md_text = md_text or ""
    body = markdown.markdown(md_text, extensions=_MD_EXTENSIONS, output_format="html5")

    if SIGNATURE_HTML:
        body = f"{body}<br><br>{SIGNATURE_HTML}"
    elif SIGNATURE_TEXT:
        sig = markdown.markdown(
            SIGNATURE_TEXT or "", extensions=["nl2br"], output_format="html5"
        )
        body = f"{body}<br><br>{sig}"

    return body


# ---------------- Helper: Ticket-Tag-Generierung ----------------
def generate_ticket_tag_local(session) -> str:
    """
    Erzeugt einen eindeutigen Ticket-Tag im Format:
    TCK-YYYYMMDD-XXXXXXXX
    wobei XXXXXXXX ein Hex- oder Zahlenstring ist.
    """
    today = datetime.now().strftime("%Y%m%d")

    base = f"TCK-{today}-"
    last = (
        session.query(Vorgang)
        .filter(Vorgang.ticket_tag.like(f"{base}%"))
        .order_by(desc(Vorgang.ticket_tag))
        .first()
    )

    if last and last.ticket_tag:
        try:
            suffix = last.ticket_tag.split("-")[-1]
            num = int(suffix, 16)
            num += 1
        except Exception:
            num = 1
    else:
        num = 1

    tag = f"{base}{num:08X}"
    return tag


def ensure_row_ticket_tag(session, row: Kommunikation) -> str:
    """
    Stellt sicher, dass die gegebene Kommunikation einen Ticket_Tag hat.
    Falls der zugehörige Vorgang bereits einen Tag besitzt, wird dieser übernommen.
    Ansonsten wird ein neuer generiert und sowohl am Vorgang als auch an der Kommunikation gespeichert.
    """
    if row.ticket_tag:
        return row.ticket_tag

    tag: Optional[str] = None

    if row.vorgang_rec_id:
        vg = session.query(Vorgang).filter(Vorgang.rec_id == row.vorgang_rec_id).first()
        if vg and vg.ticket_tag:
            tag = vg.ticket_tag
        elif vg:
            tag = generate_ticket_tag_local(session)
            vg.ticket_tag = tag
            session.add(vg)

    if not tag:
        tag = generate_ticket_tag_local(session)

    row.ticket_tag = tag
    session.add(row)
    session.flush()
    log.info("[TAG] Ticket_Tag gesetzt RecID=%s: %s", row.rec_id, tag)
    return tag


# ---------------- Helper: Pfad- und Attachment-Helfer ----------------
def _map_ref_to_local(ref: str) -> Optional[Path]:
    """
    Mapped eine Pfad-Referenz aus der DB auf einen lokalen Dateipfad
    innerhalb von MEDIA_ROOT.

    NEU (minimal):
    - Wenn ref eine absolute Media-URL ist (.../media/<relpath>),
      wird der <relpath> extrahiert und lokal aufgelöst.
    - Sonst Logik wie vorher.
    """
    if not ref:
        return None
    s = ref.strip().strip('"').strip("'")  # falls Quotes drin sind

    # 1) Absolute URL -> nur dann mappen, wenn sie auf /media/ zeigt
    low = s.lower()
    if low.startswith("http://") or low.startswith("https://"):
        try:
            u = urlparse(s)
            # z.B. /media/res/<uuid>/file.png
            path = (u.path or "").lstrip("/")
            # wir akzeptieren NUR media-Pfade
            if path.startswith("media/"):
                rel = path[len("media/"):]  # -> res/<uuid>/file.png
                p = (MEDIA_ROOT / rel).resolve()
                return p
            return None
        except Exception:
            return None

    # 2) Relativ/absolut lokal wie vorher
    p = Path(s)
    if not p.is_absolute():
        p = MEDIA_ROOT / s
    return p.resolve()


def load_attachment_paths(row: Kommunikation) -> List[Path]:
    """
    Liest die in der Kommunikation hinterlegten Attachmentpfade und
    gibt eine Liste existierender Dateipfade zurück.
    """
    items: List[str] = []
    raw = getattr(row, "attachment_pfade", None)
    if raw:
        if raw.strip().startswith("["):
            try:
                parsed = json.loads(raw)
                if isinstance(parsed, list):
                    items = [str(x) for x in parsed if x]
            except Exception:
                items = []
        else:
            for part in raw.split(","):
                p = part.strip()
                if p:
                    items.append(p)

    paths: List[Path] = []
    for it in items:
        p = _map_ref_to_local(it)
        if p and p.exists():
            paths.append(p)
        else:
            if p:
                log.warning("[ATTACH] Datei existiert nicht %s", p)
    return paths


def build_file_attachments(paths: List[Path]) -> List[dict]:
    """
    Baut ein Array von Graph-FileAttachment Objekten aus lokalen Dateipfaden.
    """
    result: List[dict] = []
    for path in paths:
        try:
            with open(path, "rb") as f:
                content = f.read()
        except OSError as e:
            log.warning("[ATTACH] Kann Datei nicht lesen %s: %s", path, e)
            continue
        b64 = base64.b64encode(content).decode("ascii")
        result.append(
            {
                "@odata.type": "#microsoft.graph.fileAttachment",
                "name": path.name,
                "contentBytes": b64,
            }
        )
    return result


# ---------------- Helper: Graph-Message-Suche ----------------
def message_exists(gc: GraphClient, mailbox: str, msg_id: str) -> bool:
    try:
        gc.get(f"/users/{mailbox}/messages/{msg_id}", params={"$select": "id"})
        return True
    except Exception as e:
        log.debug("message_exists(%s) -> %s", msg_id, e)
        return False


def find_msg_id_by_internet_id(
    gc: GraphClient,
    mailbox: str,
    internet_id: Optional[str],
) -> Optional[str]:
    if not internet_id:
        return None

    val = internet_id.replace("'", "''")
    flt = f"internetMessageId eq '{val}'"
    try:
        res = gc.get(
            f"/users/{mailbox}/messages",
            params={
                "$select": "id,subject,internetMessageId",
                "$top": 1,
                "$filter": flt,
            },
        )
    except Exception as e:
        log.warning("find_msg_id_by_internet_id(%s) fehlgeschlagen: %s", internet_id, e)
        return None

    value = res.get("value") or []
    if not value:
        return None
    return value[0].get("id") or None


def find_reply_base_id(
    gc: GraphClient,
    session,
    row: Kommunikation,
) -> Optional[str]:
    """
    Versucht, eine geeignete Basis-Nachricht für eine echte Reply zu finden:
    1. reply_to_graph_id vom Datensatz (falls vorhanden)
       - falls Msg nicht mehr existiert, per internet_message_id im Postfach suchen
    2. letzte eingehende Kommunikation mit gleichem Ticket_Tag
       - deren graph_msg_id oder via internet_message_id auflösen
    """
    base_id = (getattr(row, "reply_to_graph_id", None) or "").strip() or None

    if base_id and not message_exists(gc, mailbox=MAILBOX_SEND, msg_id=base_id):
        resolved = find_msg_id_by_internet_id(
            gc,
            mailbox=MAILBOX_SEND,
            internet_id=getattr(row, "internet_message_id", None),
        )
        base_id = resolved or None

    if not base_id and getattr(row, "ticket_tag", None):
        vg = None
        if row.vorgang_rec_id:
            vg = (
                session.query(Vorgang)
                .filter(Vorgang.rec_id == row.vorgang_rec_id)
                .first()
            )

        if vg and vg.ticket_tag:
            incoming = (
                session.query(Kommunikation)
                .filter(
                    and_(
                        Kommunikation.richtung == "Eingehend",
                        Kommunikation.ticket_tag == vg.ticket_tag,
                    )
                )
                .order_by(desc(Kommunikation.rec_id))
                .first()
            )
            if incoming:
                base_id = (incoming.graph_msg_id or "").strip() or None
                if base_id and not message_exists(
                    gc, mailbox=MAILBOX_SEND, msg_id=base_id
                ):
                    resolved = find_msg_id_by_internet_id(
                        gc,
                        mailbox=MAILBOX_SEND,
                        internet_id=getattr(incoming, "internet_message_id", None),
                    )
                    base_id = resolved or None

    if base_id:
        log.info(
            "[REPLY] Basis-Nachricht gefunden RecID=%s -> MsgID=%s",
            row.rec_id,
            base_id,
        )
    else:
        log.info("[REPLY] Keine Basis-Nachricht gefunden RecID=%s", row.rec_id)

    return base_id


# ---------------- Versand: Neue Nachrichten & Replies ----------------
def send_new_message(
    gc: GraphClient,
    to_emails: List[str],
    cc_emails: List[str],
    subject: str,
    html_body: str,
    attachments: Optional[List[dict]] = None,
) -> str:
    """
    Sendet eine neue Nachricht über Graph und gibt die Message-ID zurück.
    """
    msg = {
        "message": {
            "subject": subject,
            "body": {"contentType": "HTML", "content": html_body},
            "toRecipients": [{"emailAddress": {"address": addr}} for addr in to_emails],
        },
        "saveToSentItems": True,
    }

    if cc_emails:
        msg["message"]["ccRecipients"] = [
            {"emailAddress": {"address": addr}} for addr in cc_emails
        ]

    if attachments:
        msg["message"]["attachments"] = attachments

    res = gc.post(f"/users/{MAILBOX_SEND}/sendMail", json=msg)
    return res.get("id") or ""


def send_reply_message(
    gc: GraphClient,
    base_id: str,
    html_body: str,
    attachments: Optional[List[dict]] = None,
) -> str:
    """
    Antwortet auf eine bestehende Nachricht (Reply).
    """
    draft = gc.post(
        f"/users/{MAILBOX_SEND}/messages/{base_id}/createReply",
        json={"comment": ""},
    )
    draft_id = draft.get("id")
    if not draft_id:
        raise RuntimeError("Konnte Draft-Reply nicht erstellen")

    gc.patch(
        f"/users/{MAILBOX_SEND}/messages/{draft_id}",
        json={"body": {"contentType": "HTML", "content": html_body}},
    )

    if attachments:
        for att in attachments:
            gc.post(
                f"/users/{MAILBOX_SEND}/messages/{draft_id}/attachments",
                json=att,
            )

    gc.post(f"/users/{MAILBOX_SEND}/messages/{draft_id}/send", json={})
    return draft_id


# ---------------- Helper: E-Mail-Listen normalisieren ----------------
def _normalize_email_list(value) -> List[str]:
    """
    Nimmt eine String- oder Listenrepräsentation einer Empfängerliste
    und gibt eine Liste von E-Mail-Adressen zurück.
    """
    if not value:
        return []

    if isinstance(value, list):
        items = value
    else:
        s = str(value)
        if s.strip().startswith("["):
            try:
                parsed = json.loads(s)
                if isinstance(parsed, list):
                    items = parsed
                else:
                    items = [s]
            except Exception:
                items = [s]
        else:
            items = [p.strip() for p in s.split(",") if p.strip()]

    emails: List[str] = []
    for it in items:
        it = str(it).strip()
        if not it:
            continue
        emails.append(it)
    return emails


# ---------------- Hauptlogik: Versand-Queue verarbeiten ----------------
def process_send_queue() -> None:
    cfg = GraphConfig(
        tenant_id=TENANT,
        client_id=CLIENT_ID,
        client_secret=CLIENT_SECRET,
        base_url=GRAPH,
    )
    gc = GraphClient(cfg)
    session = MailSessionLocal()

    try:
        rows = (
            session.query(Kommunikation)
            .filter(
                and_(
                    Kommunikation.richtung == "Ausgehend",
                    Kommunikation.versand_notwendig.is_(True),
                    Kommunikation.versand_datum.is_(None),
                )
            )
            .order_by(Kommunikation.rec_id.asc())
            .all()
        )

        if not rows:
            log.info("Keine ausgehenden Nachrichten mit Versandbedarf gefunden.")
            return

        log.info("Starte Versand von %d ausgehenden Nachrichten.", len(rows))

        for row in rows:
            log.info(
                "[PROC] RecID=%s Ticket_Tag=%s Betreff=%r",
                row.rec_id,
                row.ticket_tag,
                (row.betreff or "")[:120],
            )

            try:
                ensure_row_ticket_tag(session, row)

                to_emails = _normalize_email_list(getattr(row, "mail_to", None))
                cc_emails = _normalize_email_list(getattr(row, "mail_cc", None))
                subject = (row.betreff or "").strip()

                html_body = render_body_html(getattr(row, "beschreibung_md", "") or "")

                if getattr(row, "ticket_tag", None):
                    tag_html = html.escape(row.ticket_tag)
                    html_body = (
                        f"{html_body}<br><br>"
                        f'<span style="color:#888;font-size:11px">Ticket-Tag: {tag_html}</span>'
                    )

                attachments = build_file_attachments(load_attachment_paths(row))

                base_id = find_reply_base_id(gc, session, row)

                if base_id:
                    msg_id = send_reply_message(
                        gc=gc,
                        base_id=base_id,
                        html_body=html_body,
                        attachments=attachments,
                    )
                else:
                    if not to_emails:
                        log.warning(
                            "[SKIP] RecID=%s: keine Empfänger (Mail_To) und keine Reply-Basis.",
                            row.rec_id,
                        )
                        row.versand_notwendig = False
                        session.add(row)
                        session.commit()
                        continue

                    msg_id = send_new_message(
                        gc=gc,
                        to_emails=to_emails,
                        cc_emails=cc_emails,
                        subject=subject,
                        html_body=html_body,
                        attachments=attachments,
                    )

                row.versand_datum = datetime.now()
                row.versand_notwendig = False
                row.graph_msg_id = msg_id or row.graph_msg_id
                session.add(row)
                session.commit()
                log.info("[OK] Versand erfolgreich RecID=%s MsgID=%s", row.rec_id, msg_id)

            except SQLAlchemyError as db_ex:
                session.rollback()
                log.exception(
                    "[DB] Fehler beim Aktualisieren RecID=%s: %s", row.rec_id, db_ex
                )
            except Exception as ex:
                session.rollback()
                log.exception("[ERR] Versand fehlgeschlagen RecID=%s: %s", row.rec_id, ex)
    finally:
        session.close()
        log.info("Versand-Durchlauf beendet.")


if __name__ == "__main__":
    process_send_queue()
