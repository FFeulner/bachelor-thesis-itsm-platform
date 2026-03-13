# kommunikation/routes.py
from __future__ import annotations
import uuid
from typing import Iterable, List, Optional

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from auth.roles import require_roles  # Weg A => liefert user zurück
from core.main_db import SessionLocal, engine
from .models import BaseKom, Kommunikation
from .schemas import KommunikationCreate, KommunikationOut

router = APIRouter(
    prefix="/api/kommunikation",
    tags=["kommunikation"],
    dependencies=[Depends(require_roles("Enigma_User"))],  # Routerweit sichern
)

def init_kommunikation_tables() -> None:
    BaseKom.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def _dedup_emails(xs: Optional[Iterable[str]]) -> Optional[List[str]]:
    if not xs:
        return None
    seen, out = set(), []
    for x in xs:
        s = str(x).strip()
        if not s:
            continue
        key = s.lower()
        if key not in seen:
            seen.add(key)
            out.append(s)
    return out

def _get_creator(user) -> str:
    # hole sub aus Token und stelle sicher, dass es wie UUID aussieht
    sub = getattr(user, "sub", None) or (user.get("sub") if isinstance(user, dict) else None)
    if not sub:
        raise HTTPException(status_code=422, detail="JWT enthält keine 'sub'.")
    try:
        return str(uuid.UUID(str(sub)))
    except Exception:
        raise HTTPException(status_code=422, detail="'sub' ist keine gültige UUID.")

@router.post("/", response_model=KommunikationOut, status_code=status.HTTP_201_CREATED)
def create_kommunikation(
    payload: KommunikationCreate,
    user = Depends(require_roles("Enigma_User")),  # user-objekt bekommen
    db: Session = Depends(get_db),
):
    # Mindestens eine Zuordnung ODER CC muss gesetzt sein
    if not (payload.vorgang_recid or payload.firma_recid or payload.kunden_mitarbeiter_recid or payload.mitarbeiter_recid or (payload.cc and len(payload.cc) > 0)):
        raise HTTPException(status_code=422, detail="Mindestens eine Relation (vorgang/firma/kunden_mitarbeiter/mitarbeiter) ODER cc ist erforderlich.")

    cc_list = _dedup_emails([str(x) for x in (payload.cc or [])])
    cc_joined = ",".join(cc_list) if cc_list else None

    row = Kommunikation(
        creator_id=_get_creator(user),
        vorgang_recid=str(payload.vorgang_recid) if payload.vorgang_recid else None,
        firma_recid=str(payload.firma_recid) if payload.firma_recid else None,
        kunden_mitarbeiter_recid=str(payload.kunden_mitarbeiter_recid) if payload.kunden_mitarbeiter_recid else None,
        mitarbeiter_recid=str(payload.mitarbeiter_recid) if payload.mitarbeiter_recid else None,

        mail_cc=cc_joined,
        richtung=payload.richtung,
        betreff=payload.betreff.strip(),
        beschreibung_md=payload.beschreibung_md,
        typ=payload.typ,

        gelesen_notwendig=payload.gelesen_notwendig,
        versand_notwendig=payload.versand_notwendig,
    )
    db.add(row)
    db.commit()
    db.refresh(row)

    # Response: cc als Liste zurückgeben
    out = KommunikationOut(
        recid=row.recid,
        vorgang_recid=row.vorgang_recid,
        firma_recid=row.firma_recid,
        kunden_mitarbeiter_recid=row.kunden_mitarbeiter_recid,
        mitarbeiter_recid=row.mitarbeiter_recid,
        cc=(row.mail_cc.split(",") if row.mail_cc else []),
        betreff=row.betreff,
        beschreibung_md=row.beschreibung_md,
        richtung=row.richtung,
        typ=row.typ,
        versand_notwendig=row.versand_notwendig,
        gelesen_notwendig=row.gelesen_notwendig,
        versand_datum=(row.versand_datum.isoformat() if getattr(row, "versand_datum", None) else None),
    )
    return out