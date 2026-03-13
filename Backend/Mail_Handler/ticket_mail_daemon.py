# Mail_Handler/ticket_mail_daemon.py

import json
import logging
import os
import re
import sys
import uuid
from datetime import datetime
from pathlib import Path
from typing import List, Optional

from dotenv import dotenv_values, load_dotenv
from markdownify import markdownify as md
from sqlalchemy import text

from core.mail_db import MailSessionLocal
from Mail_Handler.graph_utils import GraphClient, GraphConfig
from Mail_Handler.models import Kommunikation, KundenMitarbeiter, Vorgang
from Mail_Handler.ticket_utils import find_ticket_tag, generate_ticket_tag

# --------------------------------------------------------------------
# Bootstrap / Projekt-Setup
# --------------------------------------------------------------------

PROJECT_ROOT = Path(__file__).resolve().parents[1]
load_dotenv(PROJECT_ROOT / "settings.env", override=False)
load_dotenv(PROJECT_ROOT / ".env", override=False)
load_dotenv(PROJECT_ROOT / ".env.local", override=False)
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

# --------------------------------------------------------------------
# Logging
# --------------------------------------------------------------------

log = logging.getLogger("ticket_mail_daemon")
handler = logging.StreamHandler()
handler.setFormatter(logging.Formatter("[%(levelname)s] [%(name)s] %(message)s"))
log.addHandler(handler)
log.setLevel(logging.INFO)

# --------------------------------------------------------------------
# ENV / CONFIG
# --------------------------------------------------------------------

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
MAILBOX = require_cfg("MAILBOX")

GRAPH = "https://graph.microsoft.com/v1.0"

ATTACHMENTS_DIR = Path(
    (OFFICE.get("ATTACHMENTS_DIR") or os.getenv("ATTACHMENTS_DIR") or "./attachments").strip()
)
ATTACHMENTS_DIR.mkdir(parents=True, exist_ok=True)

INBOX_FOLDER_NAME = OFFICE.get("INBOX_FOLDER") or os.getenv("INBOX_FOLDER") or "Inbox"
PROCESSED_CATEGORY = (
    OFFICE.get("PROCESSED_CATEGORY") or os.getenv("PROCESSED_CATEGORY") or "Imported"
)
TICKET_DONE_FOLDER = (
    OFFICE.get("TICKET_DONE_FOLDER") or os.getenv("TICKET_DONE_FOLDER") or "Done"
)
TICKET_ERROR_FOLDER = (
    OFFICE.get("TICKET_ERROR_FOLDER") or os.getenv("TICKET_ERROR_FOLDER") or "Error"
)
REIMPORT_PROCESSED = (
    OFFICE.get("REIMPORT_PROCESSED_TICKET")
    or OFFICE.get("REIMPORT_PROCESSED")
    or os.getenv("REIMPORT_PROCESSED_TICKET")
    or os.getenv("REIMPORT_PROCESSED")
    or "false"
).lower() == "true"

DEFAULT_VORGANG_CREATOR_ID = (
    os.getenv("DEFAULT_VORGANG_CREATOR_ID") or os.getenv("TICKET_VORGANG_CREATOR_ID")
)

MEDIA_ROOT = Path(os.getenv("MEDIA_ROOT", PROJECT_ROOT / "media")).resolve()
MEDIA_ROOT.mkdir(parents=True, exist_ok=True)
MEDIA_PUBLIC_BASE = (
    os.getenv("MEDIA_PUBLIC_BASE") or "http://127.0.0.1:8000/media/"
).rstrip("/") + "/"

# --------------------------------------------------------------------
# Helper
# --------------------------------------------------------------------


def html_to_plain(html: str) -> str:
    try:
        return md(html, strip=["style"]).strip()
    except Exception:
        return re.sub(r"<[^>]+>", "", html or "").strip()


def _paths_relative_to(paths: List[Path], base: Path) -> List[str]:
    rels: List[str] = []
    for p in paths:
        try:
            rels.append(p.relative_to(base).as_posix())
        except Exception:
            rels.append(p.as_posix())
    return rels


def list_all_messages(
    gc: GraphClient,
    mailbox: str,
    folder: str,
    top: int = 25,
):
    folder_id = gc.find_or_create_folder(mailbox, folder)
    for msg in gc.iter_messages(
        mailbox,
        folder_id,
        select=["id", "subject", "hasAttachments", "internetMessageId"],
        orderby="receivedDateTime DESC",
        top=top,
    ):
        yield msg


def get_message_detail(gc: GraphClient, mailbox: str, msg_id: str) -> dict:
    params = {
        "$select": (
            "id,subject,body,conversationId,internetMessageId,"
            "categories,ccRecipients,from,toRecipients"
        )
    }
    return gc.get(f"/users/{mailbox}/messages/{msg_id}", params=params)


def download_attachments(
    gc: GraphClient,
    mailbox: str,
    msg_id: str,
    outdir: Path,
) -> List[Path]:
    return gc.download_attachments(mailbox, msg_id, outdir)


# --------------------------------------------------------------------
# Inline-Bilder direkt aus dem HTML extrahieren (data:image/...;base64,...)
# --------------------------------------------------------------------

IMG_SRC_RE = re.compile(r'<img\b[^>]*\bsrc=["\']([^"\']+)["\']', re.I)


def extract_inline_images_from_html(html: str, outdir: Path) -> List[Path]:
    """
    Sucht im HTML nach <img src="data:..."> und speichert diese
    als Dateien im outdir. Liefert die gespeicherten Pfade zurück.
    """
    outdir.mkdir(parents=True, exist_ok=True)
    saved: List[Path] = []

    if not html:
        return saved

    import base64
    import mimetypes
    from urllib.parse import unquote_to_bytes

    for idx, src in enumerate(IMG_SRC_RE.findall(html)):
        if not src:
            continue

        # Nur data:-URLs interessieren uns hier; andere (cid:, http) werden
        # entweder über Graph-Attachments oder bleiben einfach im Text-Link.
        if not src.startswith("data:"):
            continue

        # data:[<mime>][;base64],<payload>
        m = re.match(r"data:([^;,]+)?(;base64)?,(.*)", src, re.I | re.S)
        if not m:
            continue

        mime = (m.group(1) or "application/octet-stream").lower()
        is_b64 = bool(m.group(2))
        payload = m.group(3)

        try:
            if is_b64:
                blob = base64.b64decode(payload)
            else:
                blob = unquote_to_bytes(payload)
        except Exception as e:
            log.warning("[INLINE] Konnte data-URI nicht dekodieren: %s", e)
            continue

        ext = mimetypes.guess_extension(mime) or ".bin"
        fname = f"inline_{idx}{ext}"
        path = outdir / fname

        # Kollisionen vermeiden
        i = 1
        while path.exists():
            path = outdir / f"inline_{idx}_{i}{ext}"
            i += 1

        path.write_bytes(blob)
        saved.append(path)

    if saved:
        log.info("[INLINE] %s Inline-Bilder aus HTML extrahiert", len(saved))
    else:
        log.debug("[INLINE] Keine data:-Inline-Bilder im HTML gefunden.")

    return saved


# --------------------------------------------------------------------
# Firma über Domain finden (nur Lookup, kein Anlegen!)
# --------------------------------------------------------------------


def find_firma_id_for_sender(session, sender_email: str) -> Optional[str]:
    """
    Domain aus E-Mail nehmen und mit Domains_email in firma vergleichen.

      Absender: 'tm@trinitynetworks.de'
      Domain  : 'trinitynetworks.de'
      Needle  : '@trinitynetworks.de'

    Domains_email Beispiele:
      '@trinitynetworks.de'
      '@kunde.de,@kunde-group.com'
    """
    if not sender_email or "@" not in sender_email:
        return None

    try:
        _, domain_full = sender_email.split("@", 1)
    except ValueError:
        return None

    domain_full = domain_full.strip().lower()
    if not domain_full:
        return None

    needle = f"@{domain_full}"
    log.info("[VORGANG] Domain-Check: email=%s domain=%s needle=%s", sender_email, domain_full, needle)

    sql = text(
        """
        SELECT `RecID`, `Domains_email`
        FROM `firma`
        WHERE `Domains_email` IS NOT NULL
          AND `Domains_email` <> ''
        """
    )

    try:
        rows = session.execute(sql).fetchall()
    except Exception as e:
        log.warning(
            "[VORGANG] Domain-Suche in `firma` fehlgeschlagen für %s: %s",
            sender_email,
            e,
        )
        return None

    for recid, domains_val in rows:
        if not domains_val:
            continue
        raw = str(domains_val)
        parts = re.split(r"[;,]", raw)
        parts_norm = [p.strip().lower() for p in parts if p.strip()]

        if needle in parts_norm:
            recid_str = str(recid)
            log.info(
                "[VORGANG] Firma-Match per Domain: email=%s needle=%s Domains_email=%r RecID=%s",
                sender_email,
                needle,
                raw,
                recid_str,
            )
            return recid_str

    log.info(
        "[VORGANG] Keine Firma für email=%s (needle=%s) in Domains_email gefunden.",
        sender_email,
        needle,
    )
    return None


# --------------------------------------------------------------------
# Vorgang-Erzeugung (nur Lookup, keine Auto-Creation)
# --------------------------------------------------------------------


def create_vorgang_for_mail(
    session,
    kom: Kommunikation,
    sender_email: Optional[str],
) -> None:
    """
    Legt einen Vorgang für eine Kommunikation an.

    Ablauf:
      1. Kunden-Mitarbeiter über E-Mail suchen.
      2. Wenn kein KM -> Firma über Domains_email ermitteln.
      3. Vorgang immer anlegen.
      4. Keine neuen Firmen / Kunden-Mitarbeiter erzeugen.
    """

    creator_id = kom.creator_id or DEFAULT_VORGANG_CREATOR_ID
    if not creator_id:
        creator_id = "00000000-0000-0000-0000-000000000000"
        log.warning(
            "[VORGANG] Weder Kommunikation.CreatorID noch DEFAULT_VORGANG_CREATOR_ID gesetzt, Fallback=%s",
            creator_id,
        )

    km = None
    firma_rec_id: Optional[str] = None

    if sender_email:
        email_norm = sender_email.strip().lower()
        log.info("[VORGANG] Suche Kunden-Mitarbeiter zu %r", email_norm)

        # 1) KM-Suche
        km = (
            session.query(KundenMitarbeiter)
            .filter(KundenMitarbeiter.email == email_norm)
            .first()
        )

        if km:
            log.info(
                "[VORGANG] Kunden-Mitarbeiter gefunden: RecID=%s, Firma_RecID=%s",
                km.rec_id,
                km.firma_rec_id,
            )
            firma_rec_id = km.firma_rec_id
        else:
            # 2) Firma-Suche via Domains_email
            log.info(
                "[VORGANG] Kein Kunden-Mitarbeiter gefunden, versuche Domain-Mapping über firma.Domains_email"
            )
            firma_rec_id = find_firma_id_for_sender(session, email_norm)
    else:
        log.info("[VORGANG] Kein Absender, Vorgang ohne Kunde/Firma (Felder bleiben leer).")

    km_rec_id: Optional[str] = km.rec_id if km else None

    # 3) Vorgang immer anlegen (Firma_RecID und KM_RecID dürfen None sein)
    vorgang_rec_id = str(uuid.uuid4())
    now = datetime.utcnow()

    vorgang_ticket_tag = kom.ticket_tag
    if not vorgang_ticket_tag:
        vorgang_ticket_tag = generate_ticket_tag(session)
        log.warning(
            "[VORGANG] Kommunikation %s hatte keinen Ticket_Tag, generiere neuen %s",
            kom.rec_id,
            vorgang_ticket_tag,
        )

    vorgang = Vorgang(
        rec_id=vorgang_rec_id,
        creator_id=creator_id,
        firma_rec_id=firma_rec_id,  # kann None sein
        kunden_mitarbeiter_rec_id=km_rec_id,
        mitarbeiter_rec_id=None,
        team_rec_id=None,
        ticket_tag=vorgang_ticket_tag,
        betreff=kom.betreff,
        beschreibung_md=kom.beschreibung_md,
        Notiz="",
        loesung="",
        feedback_geloest_durch_rec_id=None,
        eskaliert_am=None,
        nachweis_datum_eingang=now,
        nachweis_datum_eingang_durch_rec_id=None,
        nachweis_datum_priorisiert=None,
        nachweis_datum_priorisiert_durch_rec_id=None,
        nachweis_datum_angenommen=None,
        nachweis_datum_angenommen_durch_rec_id=None,
        nachweis_datum_geloest=None,
        nachweis_datum_geloest_durch_rec_id=None,
        nachweis_datum_geschlossen=None,
        nachweis_datum_geschlossen_durch_rec_id=None,
        nummer=None,
        status="Neu",
        priorisierung="3",
        quelle="e-mail",
        letzte_aenderung=now,
        wf_c_eskalation=False,
        wf_c_eskalation_last=None,
    )

    session.add(vorgang)
    session.flush()

    kom.vorgang_rec_id = vorgang_rec_id
    kom.firma_rec_id = firma_rec_id
    kom.kunden_mitarbeiter_rec_id = km_rec_id
    kom.unzugeordnet = False

    session.add(kom)
    session.commit()

    log.info(
        "[VORGANG] Neu %s (KM_RecID=%s, Firma_RecID=%s, Ticket_Tag=%s)",
        vorgang_rec_id,
        km_rec_id,
        firma_rec_id,
        vorgang_ticket_tag,
    )


# --------------------------------------------------------------------
# Haupt-Import
# --------------------------------------------------------------------


def run_ticket_import() -> None:
    cfg = GraphConfig(
        tenant_id=TENANT,
        client_id=CLIENT_ID,
        client_secret=CLIENT_SECRET,
        base_url=GRAPH,
    )
    gc = GraphClient(cfg)
    session = MailSessionLocal()

    try:
        done_folder_id = gc.find_or_create_folder(MAILBOX, TICKET_DONE_FOLDER)
        error_folder_id = gc.find_or_create_folder(MAILBOX, TICKET_ERROR_FOLDER)

        for lite in list_all_messages(gc, MAILBOX, folder=INBOX_FOLDER_NAME):
            msg_id = lite["id"]
            subj_preview = (lite.get("subject") or "").replace("\n", " ")[:120]
            log.info("[PROC] msg=%s subj=%r", msg_id, subj_preview)

            try:
                detail = get_message_detail(gc, MAILBOX, msg_id)
                subject = detail.get("subject") or ""
                html = (detail.get("body") or {}).get("content") or ""
                categories = detail.get("categories") or []

                if PROCESSED_CATEGORY in categories and not REIMPORT_PROCESSED:
                    log.info(
                        "[SKIP] msg=%s wegen Kategorie %r",
                        msg_id,
                        PROCESSED_CATEGORY,
                    )
                    try:
                        moved = gc.move_message(MAILBOX, msg_id, done_folder_id)
                        log.info(
                            "[MOVE] geskippt -> Done (neueMsgID=%s)", moved.get("id")
                        )
                    except Exception as me:
                        log.warning("[MOVE] skip->Done fehlgeschlagen: %s", me)
                    continue

                from_addr: Optional[str] = None
                _from = detail.get("from") or {}
                _from_email = (_from.get("emailAddress") or {}).get("address")
                if _from_email:
                    from_addr = _from_email.strip().lower()

                body_markdown = html_to_plain(html)
                mail_cc = (
                    ",".join(
                        [
                            a.get("emailAddress", {}).get("address") or ""
                            for a in (detail.get("ccRecipients") or [])
                            if a
                        ]
                    )
                    or None
                )

                rec_id = str(uuid.uuid4())
                created_at = datetime.utcnow()

                media_target_dir = MEDIA_ROOT / "res" / rec_id
                att_paths: List[Path] = []

                # 🔹 1) Alle Graph-Attachments (inkl. Inline=fileAttachment) holen –
                #     unabhängig von lite["hasAttachments"], da das bei reinen Inline-Bildern
                #     oft False ist.
                att_paths.extend(
                    download_attachments(gc, MAILBOX, msg_id, media_target_dir)
                )

                # 🔹 2) Zusätzlich data:-Inline-Bilder direkt aus dem HTML speichern
                att_paths.extend(
                    extract_inline_images_from_html(html, media_target_dir)
                )

                rel_paths = _paths_relative_to(att_paths, MEDIA_ROOT)
                url_list = [MEDIA_PUBLIC_BASE + p.lstrip("/\\") for p in rel_paths]

                ticket_tag = find_ticket_tag(subject, html, categories)
                if not ticket_tag:
                    ticket_tag = generate_ticket_tag(session)

                row = Kommunikation(
                    rec_id=rec_id,
                    creator_id=None,
                    vorgang_rec_id=None,
                    firma_rec_id=None,
                    kunden_mitarbeiter_rec_id=None,
                    mitarbeiter_rec_id=None,
                    projekt_rec_id=None,
                    sop_rec_id=None,
                    mail_cc=mail_cc,
                    mail_to=None,
                    attachment_pfade=json.dumps(url_list, ensure_ascii=False),
                    richtung="Eingehend",
                    betreff=subject,
                    beschreibung_md=body_markdown,
                    typ="E-Mail",
                    gelesen_am=None,
                    gelesen_notwendig=False,
                    versand_notwendig=False,
                    versand_datum=None,
                    unzugeordnet=True,
                    ticket_tag=ticket_tag,
                    created_at=created_at,
                    internet_message_id=detail.get("internetMessageId") or None,
                    graph_msg_id=detail.get("id") or None,
                    conversation_id=detail.get("conversationId") or None,
                )
                session.add(row)
                session.commit()
                log.info(
                    "[DB] Insert OK -> Kommunikation.RecID=%s Ticket_Tag=%s",
                    rec_id,
                    ticket_tag,
                )

                try:
                    create_vorgang_for_mail(session, row, from_addr)
                except Exception as ve:
                    session.rollback()
                    log.exception(
                        "[VORGANG] Fehler beim Anlegen für Kommunikation %s: %s",
                        rec_id,
                        ve,
                    )
                    # Fehler beim Vorgang -> gesamte Verarbeitung dieser Mail als Fehler behandeln
                    raise

                try:
                    categories.append(PROCESSED_CATEGORY)
                    gc.patch(
                        f"/users/{MAILBOX}/messages/{msg_id}",
                        json={"categories": categories},
                    )
                except Exception as e:
                    log.warning("[CAT] Konnte Kategorie nicht setzen: %s", e)

                try:
                    moved = gc.move_message(MAILBOX, msg_id, done_folder_id)
                    new_id = moved.get("id")
                    if new_id and new_id != row.graph_msg_id:
                        row.graph_msg_id = new_id
                        session.add(row)
                        session.commit()
                    log.info("[MOVE] -> Done (neueMsgID=%s)", new_id)
                except Exception as me:
                    log.warning("[MOVE] -> Done fehlgeschlagen: %s", me)

            except Exception as e:
                session.rollback()
                log.exception(
                    "[ERR] Verarbeitung fehlgeschlagen msg=%s: %s", msg_id, e
                )
                try:
                    moved_err = gc.move_message(MAILBOX, msg_id, error_folder_id)
                    log.info(
                        "[MOVE] msg=%s -> Error (neueMsgID=%s)",
                        msg_id,
                        moved_err.get("id"),
                    )
                except Exception as move_err:
                    log.warning(
                        "[MOVE] msg=%s -> Error fehlgeschlagen: %s",
                        msg_id,
                        move_err,
                    )

    finally:
        session.close()
        log.info("Fertig.")


if __name__ == "__main__":
    run_ticket_import()
