# -------------------------------------------------------------------
# Datei: app/generic_crud/models.py
# Beschreibung: Automap-Base für dynamische CRUD-Tabellen mit
#               Whitelist & Auto-Write (alle nicht explizit
#               ausgeschlossenen Spalten sind beschreibbar).
# -------------------------------------------------------------------


from __future__ import annotations

import os
from typing import Dict, Set
from sqlalchemy import inspect
from sqlalchemy.ext.automap import automap_base
from core.main_db import engine, metadata

# ------------------------------------------------------------
# Whitelist-Konfiguration
#   - Ein leerer Dict-Eintrag {} bedeutet:
#       read  -> alle Spalten
#       sort  -> alle lesbaren Spalten
#       write -> Auto-Write (falls global aktiviert)
# ------------------------------------------------------------
ALLOWED_TABLES: Dict[str, Dict] = {
    "aktivitaeten": {},
    "cmdb": {},
    "deletion_queue": {},
    "firma": {},
    "kommunikation": {},
    "kunden-mitarbeiter": {},
    "mitarbeiter": {},
    "vorgang": {},
    "todo": {},
    "leistungen": {},




    # -------- Beispiele für feingranulare Steuerung --------
    # "tickets": {
    #     "read": {"id", "tenant_id", "status", "title", "created_at"},
    #     # sort leer -> alle aus read
    #     "sort": set(),
    #     # explizit nur diese Spalten schreibbar (kein Auto-Write für diese Tabelle):
    #     "write": {"status", "title"},
    #     # trotz Auto-Write stets read-only:
    #     "read_only_overrides": {"status_history"},
    # },
}



# ------------------------------------------------------------
# Auto-Write-Schalter & globale Write-Deny-Liste
# ------------------------------------------------------------
AUTO_WRITE_ENABLED: bool = os.getenv("CRUD_AUTO_WRITE_ENABLED", "true").lower() == "true"

_default_deny = {"id", "tenant_id", "created_at", "updated_at", "deleted_at"}
_env_deny = set(filter(None, (os.getenv("CRUD_DEFAULT_WRITE_DENY", "")).split(",")))
DEFAULT_WRITE_DENY: Set[str] = {s.strip() for s in (_default_deny | _env_deny)}

# ------------------------------------------------------------
# Reflection (nur Whitelist-Tabellen)
# ------------------------------------------------------------
insp = inspect(engine)
existing_tables = set(insp.get_table_names(schema=None))
whitelist_tables = [t for t in ALLOWED_TABLES.keys() if t in existing_tables]

# Nur erlaubte Tabellen reflektieren
metadata.reflect(bind=engine, only=whitelist_tables)

# Double-Check: entferne alles, was nicht ausdrücklich erlaubt ist
for name, table in list(metadata.tables.items()):
    if name not in ALLOWED_TABLES:
        metadata.remove(table)

Base = automap_base(metadata=metadata)
Base.prepare()

# ------------------------------------------------------------
# Auto-Defaults & Allowed-Metadaten
# ------------------------------------------------------------
def _all_columns(table_name: str) -> Set[str]:
    """Alle Spaltennamen der Tabelle (inkl. PK)."""
    return {c.name for c in metadata.tables[table_name].columns}

def _compute_write_columns(table_name: str, read_columns: Set[str]) -> Set[str]:
    """
    Auto-Write:
      - nimmt alle nicht-PK Spalten,
      - subtrahiert DEFAULT_WRITE_DENY und read_only_overrides,
      - beschränkt auf lesbare Spalten (read_columns), falls vorhanden.
    """
    table = metadata.tables[table_name]
    cols = {c.name for c in table.columns if not c.primary_key}
    per_table_ro = set(ALLOWED_TABLES.get(table_name, {}).get("read_only_overrides", set()))
    cols -= DEFAULT_WRITE_DENY
    cols -= per_table_ro
    return cols & read_columns if read_columns else cols

model_classes: Dict[str, type] = {}

for table_name in whitelist_tables:
    conf = ALLOWED_TABLES.get(table_name, {})

    # READ: leer/fehlend -> alle Spalten
    raw_read = conf.get("read")
    allowed_read: Set[str] = set(raw_read) if raw_read is not None else _all_columns(table_name)

    # SORT: leer/fehlend -> alle lesbaren Spalten
    raw_sort = conf.get("sort")
    allowed_sort: Set[str] = set(raw_sort) if raw_sort is not None else set(allowed_read)

    # WRITE:
    #   - fehlt & AUTO_WRITE_ENABLED -> Auto-Write
    #   - Set() (auch leer)         -> exakt dieses Set (leer = read-only)
    if conf.get("write") is None and AUTO_WRITE_ENABLED:
        allowed_write = _compute_write_columns(table_name, allowed_read)
    else:
        allowed_write = set(conf.get("write", set()))

    # Automap-Klasse holen
    try:
        orm_cls = getattr(Base.classes, table_name)
    except AttributeError:
        registry = {v.__table__.name: v for v in Base.classes}
        orm_cls = registry[table_name]

    # __allowed__-Metadaten anreichern (vom CRUD verwendet)
    setattr(
        orm_cls,
        "__allowed__",
        {"read": allowed_read, "write": allowed_write, "sort": allowed_sort},
    )
    model_classes[table_name] = orm_cls

# Öffentliche Exporte
__all__ = ["Base", "model_classes", "ALLOWED_TABLES", "DEFAULT_WRITE_DENY", "AUTO_WRITE_ENABLED"]