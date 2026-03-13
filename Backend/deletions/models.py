# deletions/models.py
import uuid
from datetime import datetime

from sqlalchemy import Table, Column, String, Text, DateTime
from core.main_db import engine, metadata

DeletionQueue = Table(
    "deletion_queue",
    metadata,
    Column("id", String(36), primary_key=True, default=lambda: str(uuid.uuid4())),
    Column("tabellenname", String(255), nullable=False, index=True),
    Column("datensatz_id", String(255), nullable=False, index=True),   # z.B. RecID
    Column("grund", Text, nullable=True),
    Column("snapshot_json", Text, nullable=True),                      # JSON-String des Datensatzes
    Column("status", String(20), nullable=False, default="offen", index=True),  # offen|genehmigt|abgelehnt
    Column("angefordert_von", String(255), nullable=False),
    Column("angefordert_am", DateTime, nullable=False, default=datetime.utcnow),
    Column("geprueft_von", String(255), nullable=True),
    Column("geprueft_am", DateTime, nullable=True),
)

def ensure_queue_table():
    metadata.create_all(bind=engine, tables=[DeletionQueue])
