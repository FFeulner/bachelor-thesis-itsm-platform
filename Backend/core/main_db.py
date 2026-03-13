# -------------------------------------------------------------------
# Datei: core/main_db.py
# Beschreibung: Einrichtung der Audit-Datenbankverbindung (SQLAlchemy).
# Besonderheit: Separates SessionLocal für Audit-Trail.
# -------------------------------------------------------------------

from sqlalchemy import create_engine, MetaData
from sqlalchemy.orm import sessionmaker
from config.settings import settings

DATABASE_URL = settings.database_url
engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,
    pool_recycle=1800,
    pool_size=10,
    max_overflow=20,
    future=True,
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
metadata = MetaData()