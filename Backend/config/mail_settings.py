# config/mail_settings.py
from pathlib import Path
from dotenv import load_dotenv
from pydantic_settings import BaseSettings, SettingsConfigDict

# .env-Dateien früh in os.environ laden, damit pydantic sie findet
BASE = Path(__file__).resolve().parent.parent  # .../config -> Projektroot
load_dotenv(BASE / "settings.env", override=False)                 # Hauptsettings
load_dotenv(BASE / "Mail_Handler" / "office.env", override=False)  # optional

class MailSettings(BaseSettings):
    mail_db_url: str

    model_config = SettingsConfigDict(
        env_prefix="",            # direkte Namen wie mail_db_url
        case_sensitive=False,     # MAIL_DB_URL auch ok
    )

mail_settings = MailSettings()
