# -------------------------------------------------------------------
# Datei: config/settings.py
# Beschreibung: Definiert globale Konfiguration per Pydantic BaseSettings.
# Besonderheit: Liest automatisch aus `.env`, validiert Log-Level und Origins.
# -------------------------------------------------------------------

from pydantic_settings import BaseSettings
from typing import List, Optional


#Zieht die Settings aus dem .env File
class Settings(BaseSettings):

    APP_NAME: str = "Enigma"



    # ---------------------------
    # Auth Mode
    # ---------------------------
    # "zitadel"  => nur Zitadel Tokens akzeptieren
    # "offline"  => nur Offline Tokens akzeptieren
    # "hybrid"   => beides akzeptieren
    auth_mode: str = "hybrid"

    # ---------------------------
    # ZITADEL / OIDC (bei dir weiterhin Pflicht)
    # ---------------------------
    zitadel_domain: str  # z. B. "example.zitadel.ch"
    zitadel_token_url: str  # z. B. "https://example.zitadel.ch/oauth/v2/token"
    zitadel_jwks_url: str  # z. B. "https://example.zitadel.ch/.well-known/jwks.json"
    client_id: str  # Client-ID der OIDC-Anwendung
    redirect_uri: str  # Redirect-URI für Callback (muss in Zitadel konfiguriert sein)
    zitadel_logout: str  # Logout URL
    zitadel_post_logout: str  # PostLogout

    api_audience: str
    zitadel_issuer: str

    # ---------------------------
    # Offline Auth (Defaults)
    # ---------------------------
    offline_jwt_secret: str = "change-me-dev-secret"
    offline_token_ttl_minutes: int = 60 * 24  # 24h
    offline_static_token: str = "dev"
    offline_default_email: str = "offline@example.local"
    offline_default_sub: str = "offline-user"
    offline_default_roles: List[str] = ["admin"]

    # ---------------------------
    # Frontend (für CORS)
    # ---------------------------
    frontend_origins: List[str]

    # Log-Konfiguration: "DEBUG", "INFO", "WARNING" etc. (Default: INFO)
    log_level: str = "DEBUG"

    #  Media/Uploads
    MEDIA_DIR: str = "./media"          # Zielverzeichnis für gespeicherte Dateien
    MAX_UPLOAD_MB: float = 15.0         # Upload Limit
    PUBLIC_BASE_URL: Optional[str] = None

    # Database Connection
    database_url: str
    audit_db_url: str

    mail_db_url: Optional[str] = None

    # download
    download_secret: str

    class Config:
        env_file = 'settings.env'
        env_file_encoding = "utf-8"


# Singleton-Instanz für alle Importe
settings = Settings()
