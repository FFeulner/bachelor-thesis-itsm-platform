# core/deps.py
from contextlib import contextmanager
from core.main_db import SessionLocal

def get_db():
    db = SessionLocal()
    try:
        yield db
        db.commit()
    except Exception:
        db.rollback()
        raise
    finally:
        db.close()
