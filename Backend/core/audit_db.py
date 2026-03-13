# -------------------------------------------------------------------
# Datei: core/audit_db.py
# Beschreibung: Einrichtung der primären Datenbankverbindung (SQLAlchemy).
# Besonderheit: Engine mit `pool_pre_ping=True` für höhere Ausfallsicherheit.
# -------------------------------------------------------------------


from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker
from config.settings import settings

audit_engine = create_engine(
    settings.audit_db_url,
    pool_pre_ping=True,
    pool_recycle=1800,
    pool_size=5,
    max_overflow=10,
    future=True,
)
AuditSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=audit_engine)
AuditBase = declarative_base()