# -------------------------------------------------------------------
# Datei: auth/service.py
# Beschreibung: Service-Schicht für Token-Austausch und -Verarbeitung.
# Besonderheit: Trennt HTTP-Call und Business-Logik.
# -------------------------------------------------------------------

import httpx
import logging
from httpx import HTTPStatusError, ConnectTimeout, ReadTimeout
from jose import jwt
from fastapi import HTTPException
from .token import verify_token, extract_roles
from .models import TokenResponse
from config.settings import settings

logger = logging.getLogger("auth")   # Haupt-Logger für Auth-Operationen
audit = logging.getLogger("audit")   # Logger für Audit-Ereignisse

async def exchange_and_process_token(data: dict) -> TokenResponse:

    grant_type = data.get("grant_type", "unbekannt")
    preview = ""
    # Nur die ersten 6 Zeichen von Code/Refresh-Token für Logs verwenden
    if grant_type == "authorization_code":
        preview = data.get("code", "")[:6] + "..."
    elif grant_type == "refresh_token":
        preview = data.get("refresh_token", "")[:6] + "..."

    logger.info("Starte Token-Austausch (grant_type=%s, input=%s)", grant_type, preview)

    # Timeout setzen: max. 2 s Connect, max. 5 s Read
    timeout = httpx.Timeout(5.0, connect=2.0)
    try:
        async with httpx.AsyncClient(timeout=timeout) as client:
            resp = await client.post(
                settings.zitadel_token_url,
                data=data,
                headers={"Content-Type": "application/x-www-form-urlencoded"},
            )
        resp.raise_for_status()
        tokens = resp.json()
        logger.info("Token-Austausch erfolgreich (grant_type=%s)", grant_type)
    except ConnectTimeout as e:
        logger.error("Timeout (Connect) beim Token-Austausch: %s", e)
        raise HTTPException(status_code=504, detail="Timeout beim Token-Austausch")
    except ReadTimeout as e:
        logger.error("Timeout (Read) beim Token-Austausch: %s", e)
        raise HTTPException(status_code=504, detail="Timeout beim Token-Austausch")
    except HTTPStatusError as e:
        status = e.response.status_code
        # Versuche, Fehlerdetails aus JSON zu lesen, sonst aus dem Text
        try:
            error_detail = e.response.json()
        except Exception:
            error_detail = e.response.text

        if status in (401, 403):
            logger.warning(
                "Authentifizierungsfehler beim Token-Austausch: %s – %s", status, error_detail
            )
            raise HTTPException(status_code=401, detail="Authentifizierung fehlgeschlagen")
        elif 400 <= status < 500:
            logger.error(
                "Clientfehler beim Token-Austausch (%s): %s", status, error_detail
            )
            raise HTTPException(status_code=400, detail="Token-Austausch fehlgeschlagen")
        else:
            logger.critical(
                "Serverfehler von Zitadel (%s): %s", status, error_detail
            )
            raise HTTPException(status_code=502, detail="Zitadel-Fehler beim Token-Austausch")
    except Exception as e:
        logger.exception("Unerwarteter Fehler beim Token-Austausch: %s", e)
        raise HTTPException(status_code=500, detail="Interner Fehler beim Token-Austausch")

    # Extrahiere die einzelnen Token aus der Antwort
    id_token = tokens.get("id_token", "")
    access_token = tokens.get("access_token", "")
    refresh_token = tokens.get("refresh_token", "")


    # User für Audit-Log herauslesen (ID-Token unverified lesen)
    user = "unbekannt"
    try:
        claims = jwt.get_unverified_claims(id_token)
        user = claims.get("email") or claims.get("sub") or "unbekannt"
    except Exception:
        logger.debug("Konnte Benutzerinfo aus id_token nicht extrahieren")

    # Audit-Log schreiben (mit extra-Feldern für JSON-Logging)
    audit.info(
        "event=token_exchange user=%s grant_type=%s success=true",
        user,
        grant_type,
        extra={
            "event": "token_exchange",
            "user": user,
            "grant_type": grant_type,
            "success": True
        }
    )

    # Antwort-Objekt zurückgeben
    return TokenResponse(
        id_token=id_token,
        access_token=access_token,
        refresh_token=refresh_token,
    )

