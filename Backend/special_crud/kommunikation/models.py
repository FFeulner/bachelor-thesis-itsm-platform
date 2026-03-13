# kommunikation/models.py
from __future__ import annotations
import uuid
from typing import Optional
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy import String, Text, Date, DateTime, Boolean, ForeignKey
from sqlalchemy.types import TypeDecorator, CHAR

class BaseKom(DeclarativeBase):
    pass

class GUID(TypeDecorator):
    """DB-agnostischer UUID-Typ: MariaDB -> CHAR(36)."""
    impl = CHAR
    cache_ok = True

    def process_bind_param(self, value, dialect):
        if value is None:
            return None
        if isinstance(value, uuid.UUID):
            return str(value)
        return str(uuid.UUID(str(value)))

    def process_result_value(self, value, dialect):
        if value is None:
            return None
        return uuid.UUID(str(value))

class Kommunikation(BaseKom):
    __tablename__ = "kommunikation"

    recid: Mapped[uuid.UUID] = mapped_column("recid", GUID(), primary_key=True, default=uuid.uuid4)
    creator_id: Mapped[str] = mapped_column("creator_id", CHAR(36), nullable=False)

    vorgang_recid: Mapped[Optional[str]] = mapped_column("vorgang_recid", CHAR(36), ForeignKey("vorgang.recid"), nullable=True)
    firma_recid: Mapped[Optional[str]] = mapped_column("firma_recid", CHAR(36), ForeignKey("firma.recid"), nullable=True)
    kunden_mitarbeiter_recid: Mapped[Optional[str]] = mapped_column("kunden_mitarbeiter_recid", CHAR(36), ForeignKey("kunden_mitarbeiter.recid"), nullable=True)
    mitarbeiter_recid: Mapped[Optional[str]] = mapped_column("mitarbeiter_recid", CHAR(36), ForeignKey("mitarbeiter.recid"), nullable=True)

    mail_cc: Mapped[Optional[str]] = mapped_column(Text, nullable=True)  # Kommagetrennt
    richtung: Mapped[str] = mapped_column(String(20), default="outbound", nullable=False)
    betreff: Mapped[str] = mapped_column(Text, nullable=False)
    beschreibung_md: Mapped[str] = mapped_column("beschreibung_md", Text, nullable=False)
    typ: Mapped[str] = mapped_column(String(50), default="email", nullable=False)

    gelesen_am: Mapped[Optional[str]] = mapped_column(Date, nullable=True)
    gelesen_notwendig: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    versand_notwendig: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    versand_datum: Mapped[Optional[str]] = mapped_column(DateTime, nullable=True)