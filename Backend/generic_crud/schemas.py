# -------------------------------------------------------------------
# Datei: generic_crud/schemas.py
# Beschreibung: Generiert Pydantic-Schemas aus SQLAlchemy-Tabellen.
# -------------------------------------------------------------------

from typing import Dict, Any, Optional, List, Type, Annotated
from pydantic import BaseModel, create_model, BeforeValidator
from sqlalchemy import Column
from sqlalchemy.orm import DeclarativeMeta
import json

# Welche String/Text-Spalten enthalten in Wahrheit eine JSON-Liste?
JSON_LIST_FIELDS = {
    "Attachment_Pfade",   # -> List[str]
    # ggf. weitere Feldnamen hier ergänzen
}

# --- Converter/Validator -------------------------------------------------
def empty_to_none_any(v):
    """
    Konvertiert leere Eingaben ('' oder 'null' als String) zu None.
    Alles andere unverändert.
    """
    if v is None:
        return None
    if isinstance(v, str) and v.strip().lower() in ("", "null"):
        return None
    return v

def _dump_list_dict_to_str(v):
    """Write-Mode: erlaubt list/dict und wandelt nach JSON-String; sonst str(v)."""
    if v is None:
        return v
    if isinstance(v, (list, dict)):
        return json.dumps(v, ensure_ascii=False)
    return str(v)

def _parse_json_list(v):
    """Read-Mode: akzeptiert str/list/None und gibt List[str] zurück."""
    if v is None:
        return []
    if isinstance(v, list):
        return [str(x) for x in v]
    if isinstance(v, str):
        s = v.strip()
        # schon absolute URL einzeln?
        if s.startswith(("http://", "https://")) and not s.startswith("["):
            return [s]
        # JSON-Liste?
        try:
            data = json.loads(s)
            if isinstance(data, list):
                return [str(x) for x in data]
        except Exception:
            pass
        return [s] if s else []
    # Fallback
    return [str(v)]

# ------------------------------------------------------------------------

def map_column_type(col: Column, *, mode: str = "write") -> Any:
    """
    Ordnet einen SQLAlchemy Column-Type auf (python_typ, Pydantic-Default-Marker) zu.
    mode: "write"  -> Create/Update-Modelle (Strings dürfen list/dict annehmen und dumpen)
          "read"   -> Response-Modelle (bestimmte Felder als echte Listen zurückgeben)
    """
    sa_type = col.type
    from sqlalchemy.sql.sqltypes import Boolean, Integer, String, Float, DateTime, Date, Time, Text
    from sqlalchemy.dialects.mysql import TINYINT

    # MySQL TINYINT(1) -> bool
    if isinstance(sa_type, TINYINT) and getattr(sa_type, "display_width", 0) == 1:
        return (bool, ...)

    if isinstance(sa_type, Boolean):
        return (bool, ...)
    if isinstance(sa_type, Integer):
        return (int, ...)
    if isinstance(sa_type, Float):
        return (float, ...)
    if isinstance(sa_type, DateTime):
        from datetime import datetime
        return (datetime, ...)
    if isinstance(sa_type, Date):
        from datetime import date
        return (date, ...)
    if isinstance(sa_type, Time):
        from datetime import time
        return (time, ...)

    # String/Text: differenziere read/write
    if isinstance(sa_type, (String, Text)):
        # READ: bestimmte Felder als echte Liste zurückgeben
        if mode == "read" and col.name in JSON_LIST_FIELDS:
            ListType = Annotated[List[str], BeforeValidator(_parse_json_list)]
            return (ListType, ...)
        # WRITE: list/dict zulassen und als JSON-String speichern
        StrType = Annotated[str, BeforeValidator(_dump_list_dict_to_str)]
        return (StrType, ...)

    # Fallback
    return (str, ...)

# ------------------------------------------------------------------------

def create_pydantic_model(
    orm_cls: DeclarativeMeta,
    *,
    name: Optional[str] = None,
    include_primary_key: bool = True,
    exclude_fields: Optional[List[str]] = None
) -> Type[BaseModel]:
    """
    Erzeugt ein Pydantic-Model basierend auf den Spalten von `orm_cls`.
    - name: Name des Pydantic-Models
    - include_primary_key: PK mit aufnehmen (True) oder nicht (False)
    - exclude_fields: explizit auszuschließende Spaltennamen
    """
    exclude_fields = exclude_fields or []
    model_name = name or f"{orm_cls.__name__}Schema"
    fields: Dict[str, Any] = {}

    # Mode anhand des Modellnamens bestimmen:
    # In deinen Routen wird das Read-Modell mit "...Read" erzeugt.
    mode = "read" if (model_name.lower().endswith("read")) else "write"

    for col in orm_cls.__table__.columns:
        col_name = col.name

        # 1) Primärschlüssel ausschließen, wenn nicht gewünscht
        if not include_primary_key and col.primary_key:
            continue
        # 2) Explizit ausgeschlossene Felder überspringen
        if col_name in exclude_fields:
            continue

        # 3) Ermitteln, ob die Spalte ein Default hat (python- oder db-seitig)
        has_default = (col.default is not None) or (col.server_default is not None)

        # 4) Pydantic-Feldtyp finden (mit passendem Mode)
        py_type, _ = map_column_type(col, mode=mode)

        # 4a) Wenn DB-Default vorhanden → optional
        if has_default:
            if mode == "write":
                # leere Strings/'null' -> None
                FieldType = Annotated[Optional[py_type], BeforeValidator(empty_to_none_any)]
                fields[col_name] = (FieldType, None)
            else:
                fields[col_name] = (Optional[py_type], None)
            continue

        # 4b) Wenn Spalte nullable → optional
        if col.nullable:
            if mode == "write":
                FieldType = Annotated[Optional[py_type], BeforeValidator(empty_to_none_any)]
                fields[col_name] = (FieldType, None)
            else:
                fields[col_name] = (Optional[py_type], None)
            continue
        # 4c) Sonst: required Feld
        fields[col_name] = (py_type, ...)

    return create_model(model_name, **fields)  # type: ignore
