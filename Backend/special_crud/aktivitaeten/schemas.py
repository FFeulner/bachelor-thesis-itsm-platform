from typing import Optional
from pydantic import BaseModel, Field, field_validator
from pydantic.config import ConfigDict  # pydantic v2

def _empty_to_none(v):
    if v is None:
        return None
    if isinstance(v, str):
        v = v.strip()
        return v or None
    return v

class AktivitaetCreate(BaseModel):
    mitarbeiter_recid: Optional[str] = None
    aktion: str = Field(..., min_length=1, max_length=255)
    aktion_inhalt: Optional[str] = None
    entity_recid: Optional[str] = None
    entity_table: Optional[str] = Field(None, max_length=36)

    # 🔹 JSON-Key & Attribut heißen "firma_RecID"
    firma_RecID: Optional[str] = None

    _norm = field_validator(
        "mitarbeiter_recid", "entity_recid", "firma_RecID", "aktion_inhalt", "entity_table",
        mode="before"
    )(lambda cls, v: _empty_to_none(v))

    model_config = ConfigDict(extra="ignore")

class AktivitaetOut(BaseModel):
    recid: str
    timestamp: str
    mitarbeiter_recid: Optional[str]
    aktion: str
    aktion_inhalt: Optional[str]
    entity_recid: Optional[str]
    entity_table: Optional[str]
    firma_RecID: Optional[str]
    text: str

    model_config = ConfigDict(from_attributes=True)
