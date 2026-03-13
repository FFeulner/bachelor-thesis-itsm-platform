# kommunikation/schemas.py
from typing import List, Optional, Literal
from uuid import UUID
from pydantic import BaseModel, EmailStr, Field

class KommunikationCreate(BaseModel):
    # Ziel-Relationen: mindestens eine davon ODER cc muss gesetzt sein
    vorgang_recid: Optional[UUID] = None
    firma_recid: Optional[UUID] = None
    kunden_mitarbeiter_recid: Optional[UUID] = None
    mitarbeiter_recid: Optional[UUID] = None

    cc: Optional[List[EmailStr]] = None
    betreff: str = Field(..., min_length=1)
    beschreibung_md: str = Field(..., min_length=1)

    richtung: Literal["inbound", "outbound"] = "outbound"
    typ: str = "email"
    versand_notwendig: bool = True
    gelesen_notwendig: bool = False

class KommunikationOut(BaseModel):
    recid: UUID
    vorgang_recid: Optional[str] = None
    firma_recid: Optional[str] = None
    kunden_mitarbeiter_recid: Optional[str] = None
    mitarbeiter_recid: Optional[str] = None

    cc: list[str] = []
    betreff: str
    beschreibung_md: str
    richtung: str
    typ: str
    versand_notwendig: bool
    gelesen_notwendig: bool
    versand_datum: Optional[str] = None

    class Config:
        from_attributes = True  # Pydantic v2