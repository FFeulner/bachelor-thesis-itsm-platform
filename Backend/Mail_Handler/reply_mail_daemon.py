# Mail_Handler/reply_mail_daemon.py

# === Bootstrap: load project envs BEFORE any project imports ===
import base64
import json
import logging
import os
import re
import sys
import uuid
from datetime import datetime, timezone
from pathlib import Path
from typing import List, Optional

from dotenv import dotenv_values, load_dotenv
from markdownify import markdownify as md
from sqlalchemy import text
from sqlalchemy.exc import IntegrityError

# ---- Project root & sys.path zuerst setzen ----
PROJECT_ROOT = Path(__file__).resolve().parents[1]
load_dotenv(PROJECT_ROOT / "settings.env", override=False)
load_dotenv(PROJECT_ROOT / ".env", override=False)
load_dotenv(PROJECT_ROOT / ".env.local", override=False)
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

# --- Projekt-Imports (nachdem sys.path gesetzt ist) ---
from core.mail_db import MailSessionLocal  # noqa: E402
from core.main_db import SessionLocal as MainSession  # noqa: E402
from Mail_Handler.graph_utils import GraphClient, GraphConfig  # noqa: E402
from Mail_Handler.models import Kommunikation  # noqa: E402
from Mail_Handler.ticket_utils import find_ticket_tag  # noqa: E402

# ---------------- Logging ----------------
log = logging.getLogger("reply_mail_daemon")
handler = logging.StreamHandler()
handler.setFormatter(logging.Formatter("[%(levelname)s] %(message)s"))
log.addHandler(handler)
log.setLevel(logging.INFO)

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
MAILBOX_SEND = require_cfg("MAILBOX_SEND")  # Reply arbeitet auf Sende-Postfach

GRAPH = "https://graph.microsoft.com/v1.0"

REPLY_FOLDER_NAME = (
    OFFICE.get("REPLY_FOLDER") or os.getenv("REPLY_FOLDER") or "Inbox"
)
PROCESSED_CATEGORY = (
    OFFICE.get("REPLY_PROCESSED_CATEGORY")
    or os.getenv("REPLY_PROCESSED_CATEGORY")
    or "ReplyImported"
)
REIMPORT_PROCESSED = (
    OFFICE.get("REIMPORT_PROCESSED")
    or os.getenv("REIMPORT_PROCESSED")
    or "false"
).lower() == "true"
REPLY_DONE_FOLDER = (
    OFFICE.get("REPLY_DONE_FOLDER") or os.getenv("REPLY_DONE_FOLDER") or "Done"
)
REPLY_ERROR_FOLDER = (
    OFFICE.get("REPLY_ERROR_FOLDER") or os.getenv("REPLY_ERROR_FOLDER") or "Error"
)

# Media: lokaler Speicher + öffentliche Basis-URL
MEDIA_ROOT = Path(os.getenv("MEDIA_ROOT", PROJECT_ROOT / "media")).resolve()
MEDIA_ROOT.mkdir(parents=True, exist_ok=True)
MEDIA_PUBLIC_BASE = (
    os.getenv("MEDIA_PUBLIC_BASE") or "http://127.0.0.1:8000/media/"
).rstrip("/") + "/"


def _to_public_url(rel_path: str) -> str:
    rel = rel_path.lstrip("/\\")
    return f"{MEDIA_PUBLIC_BASE}{rel}"


# ---------------- Graph-Helper ----------------
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
            "categories,ccRecipients,from,toRecipients,receivedDateTime"
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


# ---------- Inline-Images aus HTML (data:image/...;base64,...) ----------
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

    import mimetypes
    from urllib.parse import unquote_to_bytes

    for idx, src in enumerate(IMG_SRC_RE.findall(html)):
        if not src:
            continue

        # Nur data:-URLs interessieren uns hier; andere (cid:, http) bleiben im Text.
        if not src.startswith("data:"):
            continue

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


def _parse_graph_dt(s: Optional[str]) -> datetime:
    """
    Graph liefert z.B. '2025-11-20T10:15:30Z' oder mit Offset.
    Wir speichern UTC-aware datetime.
    """
    if not s:
        return datetime.now(timezone.utc)
    try:
        if s.endswith("Z"):
            s = s.replace("Z", "+00:00")
        dt = datetime.fromisoformat(s)
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        return dt.astimezone(timezone.utc)
    except Exception:
        return datetime.now(timezone.utc)


# --------- Vorgang-Lookup & Enrichment ----------
def _get_vorgang_by_ticket_tag(tag: Optional[str]) -> Optional[dict]:
    if not tag:
        return None
    try:
        with MainSession() as ms:
            res = ms.execute(
                text(
                    """
                SELECT
                    `RecID`                    AS recid,
                    `Firma_RecID`              AS firma_rec_id,
                    `Kunden-Mitarbeiter_RecID` AS kunden_mitarbeiter_rec_id,
                    `Mitarbeiter_RecID`        AS mitarbeiter_rec_id,
                    `Team_RecID`               AS team_rec_id,
                    `Ticket_Tag`               AS ticket_tag
                FROM `vorgang`
                WHERE `Ticket_Tag` = :tag
                LIMIT 1
            """
                ),
                {"tag": tag},
            )
            m = res.mappings().first()
            return dict(m) if m else None
    except Exception as e:
        log.warning("Vorgang-Lookup via ticket_tag fehlgeschlagen: %s", e)
        return None


def _apply_vorgang_to_row(row: Kommunikation, vg: dict) -> None:
    row.vorgang_rec_id = str(vg.get("recid"))
    row.firma_rec_id = vg.get("firma_rec_id")
    row.kunden_mitarbeiter_rec_id = vg.get("kunden_mitarbeiter_rec_id")
    row.mitarbeiter_rec_id = vg.get("mitarbeiter_rec_id")
    row.team_rec_id = vg.get("team_rec_id")
    row.unzugeordnet = False


# ---------------- Haupt-Import ----------------
def run_reply_import() -> None:
    cfg = GraphConfig(
        tenant_id=TENANT,
        client_id=CLIENT_ID,
        client_secret=CLIENT_SECRET,
        base_url=GRAPH,
    )
    gc = GraphClient(cfg)
    session = MailSessionLocal()

    try:
        done_folder_id = gc.find_or_create_folder(MAILBOX_SEND, REPLY_DONE_FOLDER)
        error_folder_id = gc.find_or_create_folder(MAILBOX_SEND, REPLY_ERROR_FOLDER)

        for lite in list_all_messages(gc, MAILBOX_SEND, folder=REPLY_FOLDER_NAME):
            msg_id = lite["id"]
            subj_preview = (lite.get("subject") or "").replace("\n", " ")[:120]
            log.info("[PROC] msg=%s subj=%r", msg_id, subj_preview)

            try:
                detail = get_message_detail(gc, MAILBOX_SEND, msg_id)
                subject = detail.get("subject") or ""
                html = (detail.get("body") or {}).get("content") or ""
                categories = detail.get("categories") or []
                received_dt = _parse_graph_dt(detail.get("receivedDateTime"))

                if PROCESSED_CATEGORY in categories and not REIMPORT_PROCESSED:
                    log.info(
                        "[SKIP] msg=%s wegen Kategorie %r",
                        msg_id,
                        PROCESSED_CATEGORY,
                    )
                    try:
                        moved = gc.move_message(MAILBOX_SEND, msg_id, done_folder_id)
                        log.info("[MOVE] geskippt -> Done (neueMsgID=%s)", moved.get("id"))
                    except Exception as me:
                        log.warning("[MOVE] skip->Done fehlgeschlagen: %s", me)
                    continue

                body_markdown = html_to_plain(html)

                parsed_tag = find_ticket_tag(subject, html, categories)
                vg = _get_vorgang_by_ticket_tag(parsed_tag)

                rec_id = str(uuid.uuid4())

                folder_id_for_media = str(vg["recid"]) if vg else rec_id
                media_target_dir = MEDIA_ROOT / "res" / folder_id_for_media
                media_target_dir.mkdir(parents=True, exist_ok=True)

                att_paths: List[Path] = []

                # Alle Attachments (inkl. Inline-Images als fileAttachment) laden
                att_paths.extend(
                    download_attachments(gc, MAILBOX_SEND, msg_id, media_target_dir)
                )

                # Zusätzlich Inline-Bilder als data:image/... direkt aus dem HTML extrahieren
                att_paths.extend(
                    extract_inline_images_from_html(html, media_target_dir)
                )

                rel_paths = _paths_relative_to(att_paths, MEDIA_ROOT)
                url_list = [_to_public_url(p) for p in rel_paths]

                ticket_tag = vg.get("ticket_tag") if vg else (parsed_tag or "")

                row = Kommunikation(
                    rec_id=rec_id,
                    richtung="Eingehend",
                    typ="E-Mail",
                    vorgang_rec_id=str(vg["recid"]) if vg else None,
                    unzugeordnet=False if vg else True,
                    betreff=subject,
                    beschreibung_md=body_markdown,
                    ticket_tag=ticket_tag,
                    created_at=received_dt,  # DB verlangt NOT NULL
                    internet_message_id=detail.get("internetMessageId") or None,
                    graph_msg_id=detail.get("id") or None,
                    conversation_id=detail.get("conversationId") or None,
                    attachment_pfade=json.dumps(url_list, ensure_ascii=False),
                    Gelesen_Notwendig=True,
                )

                if vg:
                    _apply_vorgang_to_row(row, vg)

                session.add(row)
                session.commit()
                log.info(
                    "[DB] Insert OK -> Kommunikation.RecID=%s, Vorgang_RecID=%s",
                    rec_id,
                    row.vorgang_rec_id,
                )

                # Kategorie setzen
                try:
                    if PROCESSED_CATEGORY not in categories:
                        categories.append(PROCESSED_CATEGORY)
                    gc.patch(
                        f"/users/{MAILBOX_SEND}/messages/{msg_id}",
                        json={"categories": categories},
                    )
                except Exception as e:
                    log.warning("[CAT] Konnte Kategorie nicht setzen: %s", e)

                # In Done verschieben und NEUE ID in DB aktualisieren
                try:
                    moved = gc.move_message(MAILBOX_SEND, msg_id, done_folder_id)
                    new_id = moved.get("id")
                    if new_id and new_id != row.graph_msg_id:
                        row.graph_msg_id = new_id
                        session.add(row)
                        session.commit()
                    log.info("[MOVE] -> Done (neueMsgID=%s)", new_id)
                except Exception as me:
                    log.warning("[MOVE] -> Done fehlgeschlagen: %s", me)

            except IntegrityError as ie:
                session.rollback()
                log.exception("[DB] IntegrityError msg=%s: %s", msg_id, ie)
                try:
                    moved_err = gc.move_message(MAILBOX_SEND, msg_id, error_folder_id)
                    log.info("[MOVE] Reply msg=%s -> Error (neueMsgID=%s)", msg_id, moved_err.get("id"))
                except Exception as move_err:
                    log.warning("[MOVE] Reply msg=%s -> Error fehlgeschlagen: %s", msg_id, move_err)

            except Exception as e:
                session.rollback()
                log.exception(
                    "[ERR] Reply-Verarbeitung fehlgeschlagen msg=%s: %s",
                    msg_id,
                    e,
                )
                try:
                    moved_err = gc.move_message(MAILBOX_SEND, msg_id, error_folder_id)
                    log.info(
                        "[MOVE] Reply msg=%s -> Error (neueMsgID=%s)",
                        msg_id,
                        moved_err.get("id"),
                    )
                except Exception as move_err:
                    log.warning(
                        "[MOVE] Reply msg=%s -> Error fehlgeschlagen: %s",
                        msg_id,
                        move_err,
                    )

    finally:
        session.close()
        log.info("Fertig.")


if __name__ == "__main__":
    run_reply_import()
