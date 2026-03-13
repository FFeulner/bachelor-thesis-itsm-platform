# deletions/routes.py
from datetime import datetime
import json

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select, update, delete as sa_delete
from sqlalchemy.orm import Session

from core.main_db import SessionLocal
from deletions.models import DeletionQueue
from auth.roles import require_roles
from generic_crud.models import Base

from utils.change_tracker import write_change_entry

import logging
logger = logging.getLogger("delete")

router = APIRouter(prefix="/api/deletion-queue", tags=["deletion-queue"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def _get_orm_cls_by_tabellenname(table_name: str):

    try:
        return getattr(Base.classes, table_name)
    except AttributeError:
        return None

@router.get("/", dependencies=[Depends(require_roles("admin"))])
def list_offene_markierungen(db: Session = Depends(get_db)):
    rows = db.execute(
        select(DeletionQueue)
        .where(DeletionQueue.c.status == "offen")
        .order_by(DeletionQueue.c.angefordert_am)
    ).mappings().all()
    return [dict(r) for r in rows]


@router.post("/{queue_id}/approve", dependencies=[Depends(require_roles("admin"))])
def approve_markierung(queue_id: str, db: Session = Depends(get_db), admin=Depends(require_roles("admin"))):
    item = db.execute(select(DeletionQueue).where(DeletionQueue.c.id == queue_id)).mappings().first()
    if not item:
        raise HTTPException(404, detail="Markierung nicht gefunden.")
    if item["status"] != "offen":
        raise HTTPException(409, detail=f"Markierung ist bereits '{item['status']}'.")

    orm_cls = _get_orm_cls_by_tabellenname(item["tabellenname"])
    if not orm_cls:
        raise HTTPException(400, detail=f"Tabelle '{item['tabellenname']}' ist nicht registriert.")


    pk_col = next(c for c in orm_cls.__table__.columns if c.primary_key)


    try:
        snapshot = json.loads(item.get("snapshot_json") or "{}")
    except Exception:
        snapshot = {}


    pk_col = next(c for c in orm_cls.__table__.columns if c.primary_key)


    try:
        snapshot = json.loads(item.get("snapshot_json") or "{}")
    except Exception:
        snapshot = {}


    target_id = item["datensatz_id"]
    try:
        if pk_col.type.python_type is int:
            target_id = int(target_id)
    except Exception:
        pass


    db.execute(sa_delete(orm_cls).where(getattr(orm_cls, pk_col.name) == target_id))


    db.execute(
        update(DeletionQueue)
        .where(DeletionQueue.c.id == queue_id)
        .values(status="genehmigt", geprueft_von=admin.get("name", "admin"), geprueft_am=datetime.utcnow())
    )
    db.commit()
    return {"status": "gelöscht", "tabellenname": item["tabellenname"], "datensatz_id": item["datensatz_id"]}



@router.post("/{queue_id}/reject", dependencies=[Depends(require_roles("admin"))])
def reject_markierung(queue_id: str, db: Session = Depends(get_db), admin=Depends(require_roles("admin"))):
    item = db.execute(select(DeletionQueue).where(DeletionQueue.c.id == queue_id)).mappings().first()
    if not item:
        raise HTTPException(404, detail="Markierung nicht gefunden.")
    if item["status"] != "offen":
        raise HTTPException(409, detail=f"Markierung ist bereits '{item['status']}'.")

    # Snapshot fürs Audit (optional, hilft bei Nachvollziehbarkeit)
    try:
        snapshot = json.loads(item.get("snapshot_json") or "{}")
    except Exception:
        snapshot = {}


    res = db.execute(sa_delete(DeletionQueue).where(DeletionQueue.c.id == queue_id))
    if res.rowcount == 0:
        raise HTTPException(404, detail="Markierung nicht gefunden oder bereits verarbeitet.")
    db.commit()


    write_change_entry(
        table_name=item["tabellenname"],
        record_id=item["datensatz_id"],
        action="delete_request_rejected",
        old_data=snapshot,
        new_data=None,
        user_sub=admin.get("sub", "unknown"),
        user_name=admin.get("name", "admin"),
    )

    # Log
    logger.info(
        "Deletion approved: queue_id=%s table=%s record=%s requested_by=%s reason=%s snapshot=%s",
        queue_id, item["tabellenname"], item["datensatz_id"], item.get("angefordert_von"), item.get("grund"),
        item.get("snapshot_json")
    )

    return {"status": "behalten"}
