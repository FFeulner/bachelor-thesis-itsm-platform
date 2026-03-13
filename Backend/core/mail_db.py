# core/mail_db.py
from sqlalchemy import create_engine, MetaData
from sqlalchemy.orm import sessionmaker
from config.mail_settings import mail_settings

MAIL_DATABASE_URL = mail_settings.mail_db_url
mail_engine = create_engine(MAIL_DATABASE_URL, pool_pre_ping=True, future=True)
MailSessionLocal = sessionmaker(bind=mail_engine, autocommit=False, autoflush=False, future=True)
mail_metadata = MetaData()
