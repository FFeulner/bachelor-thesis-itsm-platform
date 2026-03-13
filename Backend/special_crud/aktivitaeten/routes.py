# special_crud/aktivitaeten/routes.py
from __future__ import annotations
import uuid
from datetime import datetime, timezone
from collections import defaultdict
from typing import Dict, Iterable, Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import Table, select
from sqlalchemy.orm import Session

from auth.roles import require_roles
from core.main_db import SessionLocal, engine
from generic_crud.models import Base as AutoBase  # Automap-Base (bestehende Tabellen)
from .models import Aktivitaet
from .schemas import AktivitaetCreate, AktivitaetOut

router = APIRouter(prefix="/api/aktivitaeten", tags=["aktivitaeten"])

# ---------------------------------------------------------------------------

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def _id_or_none(v: Optional[str]) -> Optional[str]:
    if v is None:
        return None
    if isinstance(v, str):
        v = v.strip()
        return v or None
    return str(v)

# ---------- Relative-Zeit (Deutsch) -----------------------------------------

def _parse_dt(value) -> Optional[datetime]:
    if value is None:
        return None
    if isinstance(value, datetime):
        return value
    if isinstance(value, str):
        try:
            # erlaubt ISO mit/ohne 'Z'
            v = value.replace("Z", "+00:00")
            return datetime.fromisoformat(v)
        except Exception:
            return None
    return None

def _relative_time_human(ts) -> str:
    """
    Gibt eine kurze deutsche Angabe zurück:
    'gerade eben', 'vor 45 Sekunden', 'vor 3 Minuten', 'vor 1 Stunde',
    'vor 2 Tagen', 'vor 3 Monaten', 'vor 1 Jahr', …
    """
    dt = _parse_dt(ts) or (ts if isinstance(ts, datetime) else None)
    if dt is None:
        return ""

    # auf naive UTC normalisieren
    if dt.tzinfo is not None:
        dt = dt.astimezone(timezone.utc).replace(tzinfo=None)
    now = datetime.utcnow()
    delta = now - dt
    seconds = int(delta.total_seconds())
    if seconds < 0:
        seconds = 0

    def fmt(n: int, sg: str, pl: str) -> str:
        return f"vor {n} {sg if n == 1 else pl}"

    if seconds < 45:
        return "gerade eben"
    if seconds < 90:
        return "vor 1 Minute"
    minutes = seconds // 60
    if minutes < 60:
        return fmt(minutes, "Minute", "Minuten")
    hours = minutes // 60
    if hours < 24:
        return fmt(hours, "Stunde", "Stunden")
    days = hours // 24
    if days < 30:
        return fmt(days, "Tag", "Tagen")
    months = days // 30
    if months < 12:
        return fmt(months, "Monat", "Monaten")
    years = months // 12
    return fmt(years, "Jahr", "Jahren")

# ---------- Label-Auflösung -------------------------------------------------

# Spaltenkandidaten (Betreff hat Prio 1)
ENTITY_LABEL_CANDIDATES = [
    "betreff",
    "nummer", "nr", "ticketnr", "ticket_nr", "vorgang_nr",
    "titel", "name", "bezeichnung", "kuerzel", "code",
]

ACTION_TEMPLATES: Dict[str, str] = {
    "zeit_buchen": "Der User {user} hat eine Leistung gebucht auf {entity}",
    "ticket_zeit_buchen": "Der User {user} hat eine Leistung gebucht auf das Ticket {entity}",
    "status_geaendert": "Der User {user} hat den Status von {entity} geändert: {content}",
    "kommentar_erstellt": "Der User {user} hat einen Kommentar auf {entity} erstellt",
    "anlage": "Der User {user} hat {entity} angelegt",
    "update": "Der User {user} hat {entity} bearbeitet",
    "delete": "Der User {user} hat {entity} gelöscht",
}

def _load_table(table_name: str) -> Optional[Table]:
    try:
        return Table(table_name, AutoBase.metadata, autoload_with=engine)
    except Exception:
        return None

def _best_col_name(table: Table) -> Optional[str]:
    cols = {c.name.lower(): c for c in table.c}
    for key in ENTITY_LABEL_CANDIDATES:
        if key in cols:
            return cols[key].name
    for c in table.c:
        t = str(c.type).upper()
        if "CHAR" in t or "VARCHAR" in t or "TEXT" in t:
            return c.name
    return None

def _resolve_entity_labels(db: Session, grouped: dict[str, set[str]]) -> dict[tuple[str, str], str]:
    """
    grouped: { 'ticket': {'<id1>','<id2>'}, ... }
    return : { ('ticket','<id1>'): 'Betreff/Nummer/…', ... }
    """
    result: dict[tuple[str, str], str] = {}
    for table_name, ids in grouped.items():
        id_list = [str(i) for i in ids if i]
        if not id_list:
            continue

        tbl = _load_table(table_name)
        if tbl is None:
            for rid in id_list:
                result[(table_name, rid)] = f"{table_name} {rid[:8]}"
            continue

        key_col = _best_col_name(tbl)
        if key_col is None:
            for rid in id_list:
                result[(table_name, rid)] = f"{table_name} {rid[:8]}"
            continue

        if "RecID" in tbl.c:
            pk_name = "RecID"
        elif "recid" in tbl.c:
            pk_name = "recid"
        else:
            pk_col = next((c for c in tbl.c if getattr(c, "primary_key", False)), None)
            pk_name = pk_col.name if pk_col is not None else None

        if pk_name is None:
            for rid in id_list:
                result[(table_name, rid)] = f"{table_name} {rid[:8]}"
            continue

        stmt = select(tbl.c[pk_name], tbl.c[key_col]).where(tbl.c[pk_name].in_(id_list))
        for row in db.execute(stmt).all():
            rid = str(row[0])
            label = str(row[1]) if row[1] is not None else rid[:8]
            result[(table_name, rid)] = label

    return result

def _resolve_user_names(db: Session, ids: Iterable[str]) -> dict[str, str]:
    try:
        Mitarbeiter = getattr(AutoBase.classes, "mitarbeiter")
    except Exception:
        return {i: (i[:8] if i else "Unbekannt") for i in ids}
    rows = (
        db.query(
            Mitarbeiter.RecID,
            getattr(Mitarbeiter, "Anzeigename", None),
            getattr(Mitarbeiter, "Vorname", None),
            getattr(Mitarbeiter, "Nachname", None),
            getattr(Mitarbeiter, "Name", None),
        )
        .filter(Mitarbeiter.RecID.in_(list(ids)))
        .all()
    )
    res: dict[str, str] = {}
    for recid, anzeigename, vor, nach, name in rows:
        if anzeigename:
            res[str(recid)] = str(anzeigename)
        elif vor or nach:
            res[str(recid)] = f"{vor or ''} {nach or ''}".strip()
        elif name:
            res[str(recid)] = str(name)
        else:
            res[str(recid)] = str(recid)[:8]
    return res

# ---------- Text-Baustein ----------------------------------------------------

def _format_text(row, user_name: str, entity_label: str) -> str:
    aktion_code = (row.aktion or "").strip()
    aktion_lc = aktion_code.lower()
    template = None

    if aktion_lc in ACTION_TEMPLATES:
        template = ACTION_TEMPLATES[aktion_lc]
    if not template:
        if "zeit" in aktion_lc and ("buchen" in aktion_lc or "gebucht" in aktion_lc):
            template = ACTION_TEMPLATES["zeit_buchen"]
        elif "status" in aktion_lc and ("änder" in aktion_lc or "geaend" in aktion_lc or "geändert" in aktion_lc):
            template = ACTION_TEMPLATES["status_geaendert"]
        elif "kommentar" in aktion_lc:
            template = ACTION_TEMPLATES["kommentar_erstellt"]
    if not template:
        template = "Der User {user} führte die Aktion '{action}' auf {entity} aus"

    base = template.format(
        user=user_name or "Unbekannt",
        entity=(entity_label or f"{row.entity_table or 'Objekt'} {str(row.entity_RecID or '')[:8]}"),
        content=(row.aktion_inhalt or "").strip(),
        action=aktion_code,
    )

    rel = _relative_time_human(row.timestamp)
    suffix_parts = []
    if aktion_code:
        suffix_parts.append(f"Aktion: {aktion_code}")
    if rel:
        suffix_parts.append(rel)

    return base if not suffix_parts else f"{base} — " + " — ".join(suffix_parts)

# ----------------------------- Endpoints ------------------------------------

@router.get("/", response_model=list[AktivitaetOut])
def list_aktivitaeten(
    limit: int = Query(50, ge=1, le=500),
    offset: int = Query(0, ge=0),
    entity_table: Optional[str] = Query(None),
    entity_recid: Optional[str] = Query(None),
    mitarbeiter_recid: Optional[str] = Query(None),

    # exakt wie in der DB & im Frontend
    firma_RecID: Optional[str] = Query(None),

    user = Depends(require_roles("Enigma_User")),
    db: Session = Depends(get_db),
):
    current_firma = _id_or_none(firma_RecID)
    if not current_firma:
        return []  # kein Firmenkontext -> leere Liste

    q = (
        db.query(Aktivitaet)
          .filter(Aktivitaet.firma_RecID == current_firma)
          .order_by(Aktivitaet.timestamp.desc())
    )
    if entity_table:
        q = q.filter(Aktivitaet.entity_table == entity_table)
    if entity_recid:
        q = q.filter(Aktivitaet.entity_RecID == _id_or_none(entity_recid))
    if mitarbeiter_recid:
        q = q.filter(Aktivitaet.mitarbeiter_RecID == _id_or_none(mitarbeiter_recid))

    rows = q.offset(offset).limit(limit).all()

    user_ids = {r.mitarbeiter_RecID for r in rows if r.mitarbeiter_RecID}
    user_names = _resolve_user_names(db, user_ids) if user_ids else {}

    grouped: dict[str, set[str]] = defaultdict(set)
    for r in rows:
        if r.entity_table and r.entity_RecID:
            grouped[r.entity_table].add(str(r.entity_RecID))
    labels = _resolve_entity_labels(db, grouped) if grouped else {}

    out: list[AktivitaetOut] = []
    for r in rows:
        uname = user_names.get(r.mitarbeiter_RecID or "", "Unbekannt")
        elabel = labels.get((r.entity_table or "", str(r.entity_RecID or "")), None)
        text = _format_text(r, uname, elabel or "")
        out.append(AktivitaetOut(
            recid=str(r.RecID),
            timestamp=str(r.timestamp),
            mitarbeiter_recid=r.mitarbeiter_RecID,
            aktion=r.aktion,
            aktion_inhalt=r.aktion_inhalt,
            entity_recid=r.entity_RecID,
            entity_table=r.entity_table,
            firma_RecID=r.firma_RecID,   # Ausgabe-Feld = DB-Schreibweise
            text=text,
        ))
    return out


@router.post("/", response_model=AktivitaetOut, status_code=status.HTTP_201_CREATED)
def create_aktivitaet(
    payload: AktivitaetCreate,
    user = Depends(require_roles("Enigma_User")),
    db: Session = Depends(get_db),
):
    current_firma = _id_or_none(payload.firma_RecID)
    if not current_firma:
        raise HTTPException(status_code=400, detail="firma_RecID ist erforderlich.")

    row = Aktivitaet(
        RecID=str(uuid.uuid4()),
        mitarbeiter_RecID=_id_or_none(payload.mitarbeiter_recid),
        aktion=payload.aktion.strip(),
        aktion_inhalt=(payload.aktion_inhalt or None),
        entity_RecID=_id_or_none(payload.entity_recid),
        entity_table=(payload.entity_table or None),
        firma_RecID=current_firma,
    )
    db.add(row)
    db.commit()
    db.refresh(row)

    uname = _resolve_user_names(db, [row.mitarbeiter_RecID] if row.mitarbeiter_RecID else []).get(
        row.mitarbeiter_RecID or "", "Unbekannt"
    )
    elabel = ""
    if row.entity_table and row.entity_RecID:
        elabel = _resolve_entity_labels(db, {row.entity_table: {row.entity_RecID}}).get(
            (row.entity_table, row.entity_RecID), ""
        )
    text = _format_text(row, uname, elabel)

    return AktivitaetOut(
        recid=row.RecID,
        timestamp=str(row.timestamp),
        mitarbeiter_recid=row.mitarbeiter_RecID,
        aktion=row.aktion,
        aktion_inhalt=row.aktion_inhalt,
        entity_recid=row.entity_RecID,
        entity_table=row.entity_table,
        firma_RecID=row.firma_RecID,
        text=text,
    )

@router.delete("/{recid}", status_code=status.HTTP_405_METHOD_NOT_ALLOWED)
def no_delete(recid: str):
    raise HTTPException(status_code=405, detail="Aktivitäten können nicht gelöscht werden.")
