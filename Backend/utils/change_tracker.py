# -------------------------------------------------------------------
# Datei: utils/change_tracker.py
# Beschreibung: Aufzeichnen und Rückgängigmachen von Datenänderungen.
# Besonderheit: Nutzt Audit-DB und liefert Rollback-Logik.
# -------------------------------------------------------------------

import json
from datetime import datetime

from sqlalchemy import Table, Column, Integer, String, DateTime, Text, insert
from sqlalchemy.exc import SQLAlchemyError

from core.audit_db import audit_engine, AuditSessionLocal, AuditBase

# Gemeinsames Metadata verwenden, damit alles in dieselbe Meta-Registry kommt
metadata = AuditBase.metadata


def get_or_create_change_table(table_name: str) -> Table:
    """
    Liefert die Audit-Tabelle <table_name>_changes.
    Reflektiert zuerst (falls bereits vorhanden), erstellt ansonsten genau diese Tabelle.
    """
    audit_table_name = f"{table_name}_changes"

    # Schon im Metadata-Cache?
    if audit_table_name in metadata.tables:
        return metadata.tables[audit_table_name]

    # Versuche zu reflektieren (existiert evtl. bereits in der DB)
    try:
        Table(audit_table_name, metadata, autoload_with=audit_engine)
        return metadata.tables[audit_table_name]
    except Exception:
        # Neu anlegen
        table = Table(
            audit_table_name,
            metadata,
            Column("id", Integer, primary_key=True),
            Column("record_id", String(64), index=True),
            Column("action", String(50), index=True),
            Column("field", String(255), nullable=True),
            Column("old_value", Text, nullable=True),
            Column("new_value", Text, nullable=True),
            Column("timestamp", DateTime, default=datetime.utcnow, index=True),
            Column("user", String(255), nullable=True),
            extend_existing=True,
        )
        metadata.create_all(bind=audit_engine, tables=[table])
        return table


def write_change_entry(
    table_name: str,
    record_id: int,
    action: str,
    old_data: dict,
    new_data: dict | None,
    user_sub: str = "unknown",
    user_name: str = "unknown",
) -> None:
    """
    - update: pro geändertem Feld ein Eintrag (field != NULL)
    - delete / delete_request_rejected: EIN Eintrag mit komplettem Snapshot in old_value (field = NULL)
    - insert (optional): EIN Eintrag mit komplettem Snapshot in new_value (field = NULL)
    """
    session = AuditSessionLocal()
    try:
        table = get_or_create_change_table(table_name)
        entries: list[dict] = []

        if action == "update" and new_data is not None:
            for key, new_val in new_data.items():
                old_val = old_data.get(key)
                if old_val != new_val:
                    entries.append({
                        "record_id": str(record_id),
                        "action": action,
                        "field": key,
                        "old_value": json.dumps(old_val, ensure_ascii=False, default=str),
                        "new_value": json.dumps(new_val, ensure_ascii=False, default=str),
                        "timestamp": datetime.utcnow(),
                        "user": f"{user_name or user_sub}",
                    })

        elif action in {"delete"}:
            entries.append({
                "record_id": str(record_id),
                "action": action,
                "field": None,  # wichtig: EIN Eintrag für den gesamten Datensatz
                "old_value": json.dumps(old_data or {}, ensure_ascii=False, default=str),
                "new_value": None,
                "timestamp": datetime.utcnow(),
                "user": f"{user_name or user_sub}",
            })


        if entries:
            session.execute(insert(table), entries)
            session.commit()

    except SQLAlchemyError as e:
        print(f"Fehler beim Schreiben in Audit-Tabelle {table_name}: {e}")
        session.rollback()
    finally:
        session.close()
