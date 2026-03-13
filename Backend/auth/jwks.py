# -------------------------------------------------------------------
# Datei: auth/jwks.py
# Beschreibung: Holt und cached JSON Web Key Sets (JWKS) von Zitadel.
# Besonderheit:
# -------------------------------------------------------------------

import httpx
import logging
import asyncio
from datetime import datetime, timedelta
from typing import Dict, Any
from fastapi import HTTPException
from config.settings import settings

logger = logging.getLogger("auth")   # Logging unter dem Logger-Namen "auth"

_jwks_cache: Dict[str, Any] = {"jwks": None, "expires": None}
_jwks_lock = asyncio.Lock()

async def load_jwks() -> Dict[str, Any]:
    now = datetime.now()
    async with _jwks_lock:
        if _jwks_cache["jwks"] and _jwks_cache["expires"] and now < _jwks_cache["expires"]:
            logger.debug("JWKS aus Cache geladen (gültig bis %s)", _jwks_cache["expires"])
            return _jwks_cache["jwks"]
        else:
            if _jwks_cache["jwks"] is not None:
                logger.info("JWKS-Cache abgelaufen – lade neu")

        timeout = httpx.Timeout(5.0, connect=2.0)
        last_exc = None
        for attempt in range(3):
            try:
                async with httpx.AsyncClient(timeout=timeout, follow_redirects=False) as client:
                    resp = await client.get(settings.zitadel_jwks_url, headers={"Accept": "application/json"})
                    resp.raise_for_status()
                    jwks = resp.json()
                    _jwks_cache["jwks"] = jwks
                    _jwks_cache["expires"] = now + timedelta(hours=24)
                    logger.info("JWKS erfolgreich geladen (Versuch %s)", attempt + 1)
                    return jwks
            except (httpx.ConnectTimeout, httpx.ReadTimeout, httpx.RemoteProtocolError) as e:
                last_exc = e
                logger.warning("JWKS Versuch %s fehlgeschlagen: %s", attempt + 1, repr(e))
                await asyncio.sleep(0.5 * (2 ** attempt))
            except httpx.HTTPStatusError as e:
                logger.error("HTTP-Fehler beim Laden der JWKS: %s – %s", e.response.status_code, e.response.text)
                raise HTTPException(status_code=502, detail="Zitadel JWKS-Fehler")
            except Exception as e:
                logger.exception("Unbekannter Fehler beim Laden der JWKS: %s", e)
                raise HTTPException(status_code=500, detail="JWKS konnten nicht geladen werden")

        logger.error("JWKS fetch failed nach Retries: %s", repr(last_exc))
        raise HTTPException(status_code=503, detail="JWKS vorübergehend nicht verfügbar")

async def get_public_key(kid: str) -> Dict[str, Any]:
    """
    Sucht in den geladenen JWKS den Schlüssel mit der angegebenen Key ID (kid).
    Falls der Schlüssel nicht gefunden wird, wird der Cache invalidiert und
    ein erneutes Laden versucht. Kommt er danach immer noch nicht vor,
    wird eine HTTPException(500) geworfen.
    """
    logger.debug("Öffentlicher Schlüssel wird gesucht für kid: %s", kid)
    jwks = await load_jwks()

    # Im Cache nach dem Key suchen
    key = next((k for k in jwks.get("keys", []) if k.get("kid") == kid), None)
    if key:
        logger.debug("Passender Schlüssel direkt gefunden")
        return key

    # Schüssel nicht gefunden: Cache invalidieren und erneut laden
    logger.warning("Kein Schlüssel mit kid=%s im aktuellen JWKS – versuche erneutes Laden", kid)
    _jwks_cache["expires"] = datetime.now() - timedelta(seconds=1)  # Cache sofort ablaufen lassen
    jwks = await load_jwks()

    key = next((k for k in jwks.get("keys", []) if k.get("kid") == kid), None)
    if key:
        logger.info("Schlüssel nach erneutem Laden gefunden (kid=%s)", kid)
        return key

    # Immer noch kein Schlüssel -> kritischer Fehler
    logger.error("Schlüssel konnte nicht gefunden werden (kid=%s)", kid)
    raise HTTPException(status_code=500, detail="Kein passender Schlüssel gefunden")
