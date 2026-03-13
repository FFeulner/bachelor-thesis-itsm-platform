# -------------------------------------------------------------------
# Datei: auth/token.py
# Beschreibung: Verifiziert JWTs und extrahiert User-Payload.
# Besonderheit: Nutzt JWKS (Zitadel) + Offline (HS256 oder statischer Token).
# -------------------------------------------------------------------

import logging
from datetime import datetime, timedelta, timezone
from typing import Dict, Any, List, Optional

from jose import jwt, JWTError, ExpiredSignatureError
from fastapi import HTTPException, Header
from fastapi.security import OAuth2PasswordBearer

from config.settings import settings
from .jwks import get_public_key

# Logger für Auth-Vorgänge
logger = logging.getLogger("auth")
# Logger für Audit-Events
audit = logging.getLogger("audit")

# FastAPI OAuth2-Schema (wird standardmäßig für get_current_user genutzt)
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


# -------------------------
# Rollen extrahieren (Zitadel + Offline)
# -------------------------
def extract_roles(decoded: Dict[str, Any]) -> List[str]:
    """
    Unterstützt:
      - Zitadel: Claim 'urn:zitadel:iam:org:project:roles' (Dict -> Keys sind Rollen)
      - Offline: Claim 'roles' als Liste ["admin","user"]
    """
    # Zitadel
    roles_claim = decoded.get("urn:zitadel:iam:org:project:roles", None)
    if isinstance(roles_claim, dict):
        extracted = list(roles_claim.keys())
        logger.debug("Rollen extrahiert (zitadel-claim): %s", extracted)
        return extracted

    # Offline
    roles_list = decoded.get("roles", None)
    if isinstance(roles_list, list):
        extracted = [str(r) for r in roles_list if r]
        logger.debug("Rollen extrahiert (offline roles[]): %s", extracted)
        return extracted

    logger.debug("Keine Rollen gefunden")
    return []


# -------------------------
# Offline Token (Issue/Verify)
# -------------------------
def issue_offline_token(
    *,
    sub: str,
    email: str,
    roles: Optional[List[str]] = None,
    ttl_minutes: Optional[int] = None,
) -> str:
    now = datetime.now(timezone.utc)
    ttl = int(ttl_minutes or settings.offline_token_ttl_minutes)

    payload = {
        "iss": "offline",
        "aud": "offline",
        "sub": sub,
        "email": email,
        "roles": roles or settings.offline_default_roles,
        "iat": int(now.timestamp()),
        "exp": int((now + timedelta(minutes=ttl)).timestamp()),
    }
    return jwt.encode(payload, settings.offline_jwt_secret, algorithm="HS256")


def _verify_offline_token(token: str) -> Dict[str, Any]:
    # Statischer Token (z.B. Bearer dev)
    if token == settings.offline_static_token:
        return {
            "iss": "offline",
            "aud": "offline",
            "sub": settings.offline_default_sub,
            "email": settings.offline_default_email,
            "roles": settings.offline_default_roles,
        }

    # HS256 JWT
    try:
        return jwt.decode(
            token,
            settings.offline_jwt_secret,
            algorithms=["HS256"],
            options={"verify_aud": False, "verify_iss": False, "leeway": 60},
        )
    except ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Offline Token abgelaufen")
    except JWTError:
        raise HTTPException(status_code=401, detail="Offline Token ungültig")


def _looks_like_hs256(token: str) -> bool:
    """
    Prüft am Header ob alg=HS256 ist.
    Achtung: bei token="dev" knallt get_unverified_header -> dann False.
    """
    try:
        hdr = jwt.get_unverified_header(token)
        alg = (hdr.get("alg") or "").upper()
        return alg == "HS256"
    except Exception:
        return False


# -------------------------
# Zitadel Verify (wie vorher)
# -------------------------
async def verify_token(token: str, access_token: str | None = None) -> Dict[str, Any]:
    """
    Verifiziert ein ID-Token (oder generisches Token) im Zitadel-Stil
    ODER im Offline/Hybrid Modus auch Offline Tokens.
    """
    mode = (settings.auth_mode or "zitadel").lower().strip()

    # Offline-only
    if mode == "offline":
        return _verify_offline_token(token)

    # Hybrid: HS256 oder dev -> offline direkt
    if mode == "hybrid":
        if token == settings.offline_static_token or _looks_like_hs256(token):
            return _verify_offline_token(token)

    # Zitadel (RS256)
    try:
        logger.debug("Token-Verifikation gestartet (zitadel)")
        hdr = jwt.get_unverified_header(token)
        kid = hdr.get("kid", "unbekannt")
        logger.debug("JWT Header gelesen, kid=%s", kid)

        pk = await get_public_key(kid)

        decoded = jwt.decode(
            token,
            pk,
            algorithms=["RS256"],
            audience=settings.client_id,
            issuer=f"https://{settings.zitadel_domain}",
            access_token=access_token,
        )

        user = decoded.get("email") or decoded.get("sub") or "unbekannt"
        logger.info("Token gültig – Benutzer: %s", user)
        audit.info(
            "event=token_verified user=%s status=valid",
            user,
            extra={"event": "token_verified", "user": user, "status": "valid"},
        )
        return decoded

    except ExpiredSignatureError:
        logger.warning("Token ist abgelaufen")
        audit.info(
            "event=token_expired status=failed",
            extra={"event": "token_expired", "status": "failed"},
        )
        raise HTTPException(status_code=401, detail="Token abgelaufen")

    except JWTError as e:
        # Hybrid Fallback: Zitadel fehlgeschlagen -> offline versuchen
        if mode == "hybrid":
            try:
                return _verify_offline_token(token)
            except HTTPException:
                pass

        logger.warning("Ungültiges Token: %s", str(e))
        audit.info(
            "event=token_invalid error=%s status=failed",
            str(e),
            extra={"event": "token_invalid", "status": "failed", "error": str(e)},
        )
        raise HTTPException(status_code=401, detail="Token ungültig")

    except Exception as e:
        logger.error("Fehler bei der Token-Verifikation: %s", str(e))
        audit.info(
            "event=token_error error=%s status=failed",
            str(e),
            extra={"event": "token_error", "status": "failed", "error": str(e)},
        )
        raise HTTPException(status_code=500, detail="Token-Verifikation fehlgeschlagen")


async def verify_access_token(token: str) -> dict:
    """
    Verifiziert Access Token (Zitadel) oder Offline im Hybrid/Offline Mode.
    """
    mode = (settings.auth_mode or "zitadel").lower().strip()

    if mode == "offline":
        return _verify_offline_token(token)

    if mode == "hybrid":
        if token == settings.offline_static_token or _looks_like_hs256(token):
            return _verify_offline_token(token)

    # Zitadel Access Token
    hdr = jwt.get_unverified_header(token)
    pk = await get_public_key(hdr["kid"])
    aud = str(settings.api_audience)
    decoded = jwt.decode(
        token,
        pk,
        algorithms=["RS256"],
        audience=aud,
        issuer=settings.zitadel_issuer,
        options={"verify_aud": True, "verify_iss": True, "leeway": 60},
    )
    return decoded


async def verify_id_token(idt: str, access_token: str | None = None) -> dict:
    """
    Verifiziert ID Token (Zitadel) oder Offline im Hybrid/Offline Mode.
    """
    mode = (settings.auth_mode or "zitadel").lower().strip()

    if mode == "offline":
        return _verify_offline_token(idt)

    if mode == "hybrid":
        if idt == settings.offline_static_token or _looks_like_hs256(idt):
            return _verify_offline_token(idt)

    hdr = jwt.get_unverified_header(idt)
    pk = await get_public_key(hdr["kid"])
    decoded = jwt.decode(
        idt,
        pk,
        algorithms=["RS256"],
        audience=[settings.client_id],
        issuer=settings.zitadel_issuer,
        options={"verify_aud": True, "verify_iss": True, "leeway": 60},
        access_token=access_token,
    )
    azp = decoded.get("azp")
    if azp and azp != settings.client_id:
        raise HTTPException(status_code=401, detail="azp mismatch")
    return decoded


async def get_current_user(authorization: str = Header(..., alias="Authorization")):
    token = authorization.removeprefix("Bearer ").strip()
    if not token:
        raise HTTPException(status_code=401, detail="missing bearer token")
    return await verify_access_token(token)
