# -------------------------------------------------------------------
# Datei: utils/logger_setup.py
# Beschreibung: Initialisiert strukturiertes JSON-Logging für die App.
# Besonderheit: Dynamische Log-Level und stdout-Handler.
# -------------------------------------------------------------------

"""
Zentrales Logging-Setup für die FastAPI-App.

- Konsolen-Logging (stdout), optional JSON-Format
- Optional rotierende Logdateien (server.log, audit.log) via ENV toggelbar
- Idempotent (richtet Logger nur ein, wenn noch nicht konfiguriert)
- Uvicorn-Logger propagieren an Root → einheitliche Ausgabe
"""

import logging
import os
import sys
from logging.handlers import TimedRotatingFileHandler

try:
    # Optional: für JSON-Logs
    from pythonjsonlogger import jsonlogger
except Exception:  # modul nicht vorhanden? -> Fallback auf Textformat
    jsonlogger = None


def _level_from_env(default=logging.INFO) -> int:
    lvl = os.getenv("LOG_LEVEL", "")
    return getattr(logging, lvl.upper(), default)


def _bool_env(name: str, default: bool = False) -> bool:
    v = os.getenv(name)
    if v is None:
        return default
    return str(v).lower() in ("1", "true", "yes", "y", "on")


def setup_logging(
    level: int | None = None,
    json: bool | None = None,
    to_file: bool | None = None,
    log_dir: str | None = None,
    audit_to_file: bool | None = None,
) -> None:
    """
    Initialisiert das zentrale Logging. Aufruf so früh wie möglich (z. B. in main.py).

    Parameter (alle auch per ENV steuerbar):
      - level / ENV LOG_LEVEL: DEBUG/INFO/WARNING/ERROR/CRITICAL (Default: INFO)
      - json / ENV LOG_JSON: JSON-Format aktivieren (Default: False; wird ignoriert, falls python-json-logger fehlt)
      - to_file / ENV LOG_TO_FILE: File-Logging nach logs/server.log aktivieren (Default: False)
      - log_dir / ENV LOG_DIR: Zielordner für Logs (Default: "logs")
      - audit_to_file / ENV AUDIT_TO_FILE: audit.log zusätzlich schreiben (Default: folgt LOG_TO_FILE)

    Idempotent: falls bereits Handler am Root hängen und FORCE_LOGGING_INIT != 1, wird nichts erneut konfiguriert.
    """
    root = logging.getLogger()

    if root.handlers and not _bool_env("FORCE_LOGGING_INIT", False):
        return

    level = _level_from_env() if level is None else level
    use_json = _bool_env("LOG_JSON", json if json is not None else False)
    to_file = _bool_env("LOG_TO_FILE", to_file if to_file is not None else True)
    audit_to_file = _bool_env("AUDIT_TO_FILE", audit_to_file if audit_to_file is not None else to_file)
    log_dir = os.getenv("LOG_DIR", log_dir or "logs")

    root.setLevel(level)

    # Formatter
    if use_json and jsonlogger is not None:
        formatter = jsonlogger.JsonFormatter("%(asctime)s %(levelname)s %(name)s %(message)s")
    else:
        formatter = logging.Formatter("%(asctime)s %(levelname)s %(name)s: %(message)s")

    # Console → stdout
    sh = logging.StreamHandler(sys.stdout)
    sh.setFormatter(formatter)
    root.addHandler(sh)

    # Optional: File-Logging
    if to_file:
        os.makedirs(log_dir, exist_ok=True)
        fh = TimedRotatingFileHandler(
            filename=os.path.join(log_dir, "server.log"),
            when="midnight",
            backupCount=7,
            encoding="utf-8",
        )
        fh.setFormatter(formatter)
        root.addHandler(fh)

    # Uvicorn-Logger an Root propagieren (nicht hart löschen → vermeidet Dupes bei CLI-Logconfig)
    for name in ("uvicorn", "uvicorn.error", "uvicorn.access"):
        ul = logging.getLogger(name)
        ul.setLevel(level)
        ul.propagate = True

    # Audit-Logger (optional separate Datei)
    audit = logging.getLogger("audit")
    audit.setLevel(logging.INFO)
    audit.propagate = True  # solange keine eigene Datei

    if audit_to_file:
        os.makedirs(log_dir, exist_ok=True)
        ah = TimedRotatingFileHandler(
            filename=os.path.join(log_dir, "audit.log"),
            when="midnight",
            backupCount=30,
            encoding="utf-8",
        )
        ah.setFormatter(formatter)
        audit.addHandler(ah)
        audit.propagate = False  # verhindert Doppel-Logs, wenn eigene Datei aktiv


def get_logger(name: str) -> logging.Logger:
    """Kurzform zum Holen eines benannten Loggers."""
    return logging.getLogger(name)
