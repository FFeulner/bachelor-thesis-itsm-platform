from __future__ import annotations
from typing import Optional
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy import CHAR, String, Text, DateTime, func

class BaseAkt(DeclarativeBase):
    pass

class Aktivitaet(BaseAkt):
    __tablename__ = "aktivitaeten"

    RecID: Mapped[str] = mapped_column("RecID", CHAR(36), primary_key=True)
    mitarbeiter_RecID: Mapped[Optional[str]] = mapped_column("mitarbeiter_RecID", CHAR(36), nullable=True)
    timestamp: Mapped[str] = mapped_column("timestamp", DateTime, server_default=func.now(), nullable=False)

    aktion: Mapped[str] = mapped_column(String(255), nullable=False)
    aktion_inhalt: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    entity_RecID: Mapped[Optional[str]] = mapped_column("entity_RecID", CHAR(36), nullable=True)
    entity_table: Mapped[Optional[str]] = mapped_column("entity_table", String(36), nullable=True)

    # 🔹 exakt wie in der DB
    firma_RecID: Mapped[Optional[str]] = mapped_column("firma_RecID", CHAR(36), nullable=True)
