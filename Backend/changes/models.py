# -------------------------------------------------------------------
# Datei: changes/models.py
# Beschreibung: Pydantic-Modelle für Change-Logs und Rollback-Ergebnisse.
# Besonderheit: Klare Feldnamen und Typen für Audit-DB.
# -------------------------------------------------------------------

from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class ChangeLogEntry(BaseModel):
    id: int
    record_id: str
    action: str
    field: str
    old_value: Optional[str] = None
    new_value: Optional[str] = None
    timestamp: datetime
    user: Optional[str] = None

    class Config:
        from_attributes = True


class RollbackResult(BaseModel):
    detail: str
