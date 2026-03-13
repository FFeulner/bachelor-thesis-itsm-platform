# Mail_Handler/models.py

from datetime import datetime

from sqlalchemy.orm import declarative_base
from sqlalchemy import (
    Column,
    String,
    Text,
    Boolean,
    DateTime,
    Integer,
)
from sqlalchemy.sql import func

Base = declarative_base()


class Kommunikation(Base):
    __tablename__ = "kommunikation"

    rec_id = Column("RecID", String(36), primary_key=True)
    creator_id = Column("CreatorID", String(36), nullable=True)

    vorgang_rec_id = Column("Vorgang_RecID", String(36), nullable=True)
    firma_rec_id = Column("Firma_RecID", String(36), nullable=True)
    kunden_mitarbeiter_rec_id = Column("Kunden-Mitarbeiter_RecID", String(36), nullable=True)
    mitarbeiter_rec_id = Column("Mitarbeiter_RecID", String(36), nullable=True)
    projekt_rec_id = Column("Projekt_RecID", String(36), nullable=True)
    sop_rec_id = Column("SOP_RecID", String(36), nullable=True)

    mail_cc = Column("Mail_CC", Text, nullable=True)
    mail_to = Column("Mail_To", Text, nullable=True)
    attachment_pfade = Column("Attachment_Pfade", Text, nullable=True)

    richtung = Column("Richtung", String(50), nullable=False)  # 'Eingehend' / 'Ausgehend'
    betreff = Column("Betreff", Text, nullable=True)
    beschreibung_md = Column("Beschreibung_MD", Text, nullable=True)
    typ = Column("Typ", String(50), nullable=False, default="E-Mail")

    gelesen_am = Column("Gelesen_Am", DateTime, nullable=True)
    Gelesen_Notwendig = Column("Gelesen_Notwendig", Boolean, nullable=False, default=False)
    versand_notwendig = Column("Versand_Notwendig", Boolean, nullable=False, default=False)
    versand_datum = Column("Versand_Datum", DateTime, nullable=True)

    unzugeordnet = Column("Unzugeordnet", Boolean, nullable=False, default=True)

    ticket_tag = Column("Ticket_Tag", String(64), nullable=True)
    internet_message_id = Column("Internet_Message_ID", String(255), nullable=True)
    graph_msg_id = Column("Graph_Msg_ID", String(255), nullable=True)
    conversation_id = Column("Conversation_ID", String(255), nullable=True)

    # NEU: Reply-Ziel für Antworten
    reply_to_graph_id = Column("ReplyTo_Graph_ID", String(255), nullable=True)

    # ✅ WICHTIG: DB verlangt NOT NULL → Model setzt Default + server_default
    created_at = Column(
        "Created_at",
        DateTime,
        nullable=False,
        default=datetime.utcnow,
        server_default=func.now(),
    )

    internet_message_id = Column("Internet_Message_ID", String(255), nullable=True)
    graph_msg_id = Column("Graph_Msg_ID", String(255), nullable=True)
    conversation_id = Column("Conversation_ID", String(255), nullable=True)

    def __repr__(self) -> str:
        return f"<Kommunikation rec_id={self.rec_id} richtung={self.richtung!r} betreff={self.betreff!r}>"


class KundenMitarbeiter(Base):
    __tablename__ = "kunden-mitarbeiter"

    rec_id = Column("RecID", String(36), primary_key=True)
    firma_rec_id = Column("Firma_RecID", String(36), nullable=True)

    email = Column("E-Mail", String(255), nullable=True)

    def __repr__(self) -> str:
        return f"<KundenMitarbeiter rec_id={self.rec_id} email={self.email!r}>"


class Vorgang(Base):
    __tablename__ = "vorgang"

    rec_id = Column("RecID", String(36), primary_key=True)
    creator_id = Column("CreatorID", String(36), nullable=True)

    firma_rec_id = Column("Firma_RecID", String(36), nullable=True)
    kunden_mitarbeiter_rec_id = Column("Kunden-Mitarbeiter_RecID", String(36), nullable=True)
    mitarbeiter_rec_id = Column("Mitarbeiter_RecID", String(36), nullable=True)
    team_rec_id = Column("Team_RecID", String(36), nullable=True)

    ticket_tag = Column("Ticket_Tag", String(64), nullable=True)

    betreff = Column("Betreff", Text, nullable=True)
    beschreibung_md = Column("Beschreibung_MD", Text, nullable=True)
    Notiz = Column("Notiz", Text, nullable=True)
    loesung = Column("Loesung", Text, nullable=True)

    feedback_geloest_durch_rec_id = Column("Feedback_geloest_durchRecID", String(36), nullable=True)
    eskaliert_am = Column("Eskaliert_am", DateTime, nullable=True)

    nachweis_datum_eingang = Column("Nachweis_Datum_Eingang", DateTime, nullable=True)
    nachweis_datum_eingang_durch_rec_id = Column("Nachweis_Datum_Eingang_durchRecID", String(36), nullable=True)
    nachweis_datum_priorisiert = Column("Nachweis_Datum_Priorisiert", DateTime, nullable=True)
    nachweis_datum_priorisiert_durch_rec_id = Column("Nachweis_Datum_Priorisiert_durchRecID", String(36), nullable=True)
    nachweis_datum_angenommen = Column("Nachweis_Datum_Angenommen", DateTime, nullable=True)
    nachweis_datum_angenommen_durch_rec_id = Column("Nachweis_Datum_Angenommen_durchRecID", String(36), nullable=True)
    nachweis_datum_geloest = Column("Nachweis_Datum_Geloest", DateTime, nullable=True)
    nachweis_datum_geloest_durch_rec_id = Column("Nachweis_Datum_Geloest_durchRecID", String(36), nullable=True)
    nachweis_datum_geschlossen = Column("Nachweis_Datum_Geschlossen", DateTime, nullable=True)
    nachweis_datum_geschlossen_durch_rec_id = Column("Nachweis_Datum_Geschlossen_durchRecID", String(36), nullable=True)

    nummer = Column("Nummer", Integer, nullable=True)
    status = Column("Status", String(32), nullable=False, default="Neu")
    priorisierung = Column("Priorisierung", String(8), nullable=False, default="3")
    quelle = Column("Quelle", String(64), nullable=False, default="e-mail")

    letzte_aenderung = Column("Letzte_Aenderung", DateTime, nullable=True)
    wf_c_eskalation = Column("WF_C_Eskalation", Boolean, nullable=False, default=False)
    wf_c_eskalation_last = Column("WF_C_Eskalation_last", DateTime, nullable=True)

    def __repr__(self) -> str:
        return f"<Vorgang rec_id={self.rec_id} ticket_tag={self.ticket_tag!r} status={self.status!r}>"


class Firma(Base):
    __tablename__ = "firma"

    rec_id = Column("RecID", String(36), primary_key=True)
    creator_id = Column("CreatorID", String(36), nullable=True)
    kundenvertrag_standard_rec_id = Column("kundenvertrag_standard_RecID", String(36), nullable=True)

    name = Column("Name", String(255), nullable=False)
    alias = Column("Alias", String(255), nullable=True)
    bueroware_rechnungsindikator = Column("Bueroware_Rechnungsindikator", String(255), nullable=True)
    service_zeitenid = Column("Service_zeitenID", String(36), nullable=True)

    hat_adminrechte = Column("Hat_Adminrechte", Boolean, nullable=False, default=False)
    status = Column("Status", String(16), nullable=False, default="aktiv")

    kuerzel = Column("Kuerzel", String(10), nullable=True)
    firma_farbe = Column("Firma_Farbe", String(6), nullable=True)

    lansweeperid = Column("LansweeperID", String(36), nullable=True)
    zabbixid = Column("ZabbixID", String(36), nullable=True)
    dattoid = Column("DattoID", String(36), nullable=True)
    wazuhid = Column("WazuhID", String(36), nullable=True)
    esetid = Column("EsetID", String(36), nullable=True)

    domains_email = Column("Domains_email", Text, nullable=True)
    betreuungsniveau = Column(
        "Betreuungsniveau",
        String(32),
        nullable=False,
        default="Keine Vereinbarung",
    )

    def __repr__(self) -> str:
        return f"<Firma rec_id={self.rec_id} name={self.name!r}>"
