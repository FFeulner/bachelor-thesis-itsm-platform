# -------------------------------------------------------------------
# Datei: changes/routes.py
# Beschreibung: Endpunkte zum Auslesen und Rückgängigmachen von Änderungen.
# Besonderheit: Verwendet separierte Sessions für Main- und Audit-DB.
# -------------------------------------------------------------------


from fastapi import APIRouter, HTTPException, Query, Depends
from sqlalchemy import Table, select, and_, update
from datetime import datetime
from typing import Optional, List
import json
import logging

from core.main_db import engine, metadata
from core.audit_db import audit_engine
from sqlalchemy import MetaData
from auth.token import get_current_user
from changes.models import ChangeLogEntry, RollbackResult

router = APIRouter(prefix="/changes", tags=["changes"])

audit_metadata = MetaData()
audit_metadata.reflect(bind=audit_engine)
data_metadata = metadata

logger = logging.getLogger("audit")


@router.get("/{table_name}", response_model=List[ChangeLogEntry])
def get_changes(
    table_name: str,
    action: Optional[str] = Query(None),
    user: Optional[str] = Query(None),
    field: Optional[str] = Query(None),
    record_id: Optional[str] = Query(None),
    from_time: Optional[datetime] = Query(None, alias="from"),
    to_time: Optional[datetime] = Query(None, alias="to"),
    current_user: dict = Depends(get_current_user),
):
    logger.info(
        f"Changes-GET: Tabelle={table_name}, Filter action={action}, user={user}, field={field}, record_id={record_id}, from={from_time}, to={to_time}, by={current_user.get('sub')}"
    )

    table = Table(f"{table_name}_changes", audit_metadata, autoload_with=audit_engine)
    conditions = []

    if action:
        conditions.append(table.c.action == action)
    if user:
        conditions.append(table.c.user.like(f"%{user}%"))
    if field:
        conditions.append(table.c.field == field)
    if record_id:
        conditions.append(table.c.record_id == record_id)  # <-- Filter nach record_id
    if from_time:
        conditions.append(table.c.timestamp >= from_time)
    if to_time:
        conditions.append(table.c.timestamp <= to_time)

    stmt = select(table).order_by(table.c.timestamp.desc())
    if conditions:
        stmt = stmt.where(and_(*conditions))

    with audit_engine.connect() as conn:
        result = conn.execute(stmt)
        results = [dict(row._mapping) for row in result]

    logger.info(f"Changes-GET: {len(results)} Einträge gefunden.")
    return results


@router.post("/{table_name}/rollback/{change_id}", response_model=RollbackResult)
def rollback_change(
    table_name: str,
    change_id: int,
    current_user: dict = Depends(get_current_user),
):
    logger.info(f"Rollback-POST: Tabelle={table_name}, Change-ID={change_id}, by={current_user.get('sub')}")

    # Lade die Audit- und die Daten-Tabelle
    change_table = Table(f"{table_name}_changes", audit_metadata, autoload_with=audit_engine)
    data_table = Table(table_name, data_metadata, autoload_with=engine)

    # Finde den gewünschten Änderungs-Eintrag per ID
    stmt = select(change_table).where(change_table.c.id == change_id)
    with audit_engine.connect() as audit_conn:
        result = audit_conn.execute(stmt).fetchone()
        if not result:
            logger.warning(f"Rollback-POST: Änderung {change_id} nicht gefunden")
            raise HTTPException(status_code=404, detail="Änderung nicht gefunden")

        change = dict(result._mapping)

    record_id = change["record_id"]
    field = change["field"]
    old_value = change["old_value"]

    try:
        old_value = json.loads(old_value)
    except Exception:
        pass  # Fallback: old_value bleibt als String

    # Dynamisch die Primärschlüssel-Spalte der Zieltabelle holen
    try:
        pk_column = list(data_table.primary_key.columns)[0]
    except IndexError:
        logger.error(f"Rollback-POST: Keine Primärschlüsselspalte in Tabelle {table_name}")
        raise HTTPException(status_code=500, detail="Primärschlüsselspalte nicht gefunden")

    logger.debug(f"Rollback: Setze {field}={old_value} in {table_name} wo {pk_column.key}={record_id}")

    # Update-Anweisung zum Zurücksetzen der Änderung
    update_stmt = (
        update(data_table)
        .where(pk_column == record_id)
        .values({field: old_value})
    )

    with engine.begin() as data_conn:
        data_conn.execute(update_stmt)

    # Neue Zeile im Audit-Log hinzufügen für das Rollback selbst
    rollback_entry = {
        "record_id": record_id,
        "action": "rollback",
        "field": field,
        "old_value": change["new_value"],  # das, was überschrieben wurde
        "new_value": old_value,
        "timestamp": datetime.utcnow(),
        "user": f"{current_user.get('name', 'unknown')} ({current_user.get('sub')})",
    }

    with audit_engine.begin() as audit_conn:
        audit_conn.execute(change_table.insert().values(**rollback_entry))

    message = f"Feld '{field}' von Eintrag {record_id} zurückgesetzt."
    logger.info(f"Rollback-POST: {message}")
    return RollbackResult(detail=message)