# -------------------------------------------------------------------
# Datei: auth/routes.py
# Beschreibung: Authentifizierungs-Endpunkte (Login, Me).
# Besonderheit: Zitadel + Offline/Hybrid Unterstützung.
# -------------------------------------------------------------------
from urllib.parse import urlencode

from fastapi import APIRouter, HTTPException, Request, Response
from pydantic import BaseModel
from jose import jwt

from .models import (
    CodePayload,
    RefreshPayload,
    TokenResponse,
    AuthValidationRequest,
    AuthValidationResponse
)
from .service import exchange_and_process_token
from .token import verify_token, extract_roles, issue_offline_token
from config.settings import settings

import logging

logger = logging.getLogger("auth")
audit = logging.getLogger("audit")

router = APIRouter(prefix="/api/auth", tags=["auth"])


class OfflineLoginPayload(BaseModel):
    email: str | None = None
    sub: str | None = None
    roles: list[str] | None = None


@router.post("/offline/login", response_model=TokenResponse)
async def offline_login(payload: OfflineLoginPayload):
    """
    Offline Login (für curl / FlutterFlow):
      POST /api/auth/offline/login
      { "email": "...", "sub": "...", "roles": ["admin"] }
    """
    mode = (settings.auth_mode or "zitadel").lower().strip()
    if mode not in {"offline", "hybrid"}:
        raise HTTPException(status_code=404, detail="Offline login ist deaktiviert")

    email = payload.email or settings.offline_default_email
    sub = payload.sub or settings.offline_default_sub
    roles = payload.roles or settings.offline_default_roles

    access = issue_offline_token(sub=sub, email=email, roles=roles)
    idt = issue_offline_token(sub=sub, email=email, roles=roles)

    logger.info("Offline login token issued for %s", email)
    audit.info(
        "event=login_success user=%s source=offline",
        email,
        extra={"event": "login_success", "user": email, "source": "offline"},
    )

    return TokenResponse(
        access_token=access,
        id_token=idt,
        refresh_token="",
        expires_in=settings.offline_token_ttl_minutes * 60,
    )


@router.post("/callback", response_model=TokenResponse)
async def auth_callback(payload: CodePayload):
    """
    Endpoint: /api/auth/callback
    - Zitadel: tauscht Code gegen Tokens
    - Offline: stubbt Tokens (damit man auch ohne Zitadel weiterkommt)
    """
    mode = (settings.auth_mode or "zitadel").lower().strip()

    # Offline / Hybrid shortcut: wenn code="offline" (oder offline mode)
    if mode == "offline" or (mode == "hybrid" and (payload.code or "").lower() == "offline"):
        access = issue_offline_token(
            sub=settings.offline_default_sub,
            email=settings.offline_default_email,
            roles=settings.offline_default_roles,
        )
        idt = issue_offline_token(
            sub=settings.offline_default_sub,
            email=settings.offline_default_email,
            roles=settings.offline_default_roles,
        )
        return TokenResponse(
            access_token=access,
            id_token=idt,
            refresh_token="",
            expires_in=settings.offline_token_ttl_minutes * 60,
        )

    logger.info("Auth-Callback aufgerufen (code=%s...)", payload.code[:6])

    response = await exchange_and_process_token({
        "grant_type": "authorization_code",
        "code": payload.code,
        "redirect_uri": settings.redirect_uri,
        "client_id": settings.client_id,
        "code_verifier": payload.verifier
    })

    try:
        claims = jwt.get_unverified_claims(response.id_token)
        user = claims.get("email") or claims.get("sub") or "unbekannt"
        logger.info("Login erfolgreich für Benutzer: %s", user)
        audit.info(
            "event=login_success user=%s source=callback",
            user,
            extra={"event": "login_success", "user": user, "source": "callback"}
        )
    except Exception as e:
        logger.warning("Konnte Benutzerinformationen nicht aus ID-Token lesen: %s", e)

    return response


@router.post("/refresh", response_model=TokenResponse)
async def refresh_tokens(payload: RefreshPayload):
    """
    Endpoint: /api/auth/refresh
    - Zitadel: refresh flow
    - Offline: stubbt Tokens
    """
    mode = (settings.auth_mode or "zitadel").lower().strip()

    if mode == "offline":
        access = issue_offline_token(
            sub=settings.offline_default_sub,
            email=settings.offline_default_email,
            roles=settings.offline_default_roles,
        )
        idt = issue_offline_token(
            sub=settings.offline_default_sub,
            email=settings.offline_default_email,
            roles=settings.offline_default_roles,
        )
        return TokenResponse(
            access_token=access,
            id_token=idt,
            refresh_token="",
            expires_in=settings.offline_token_ttl_minutes * 60,
        )

    logger.info("Token-Refresh aufgerufen (refresh_token=%s...)", payload.refresh_token[:6])

    response = await exchange_and_process_token({
        "grant_type": "refresh_token",
        "refresh_token": payload.refresh_token,
        "client_id": settings.client_id
    })

    try:
        claims = jwt.get_unverified_claims(response.id_token)
        user = claims.get("email") or claims.get("sub") or "unbekannt"
        logger.info("Token erfolgreich erneuert für Benutzer: %s", user)
        audit.info(
            "event=token_refresh user=%s source=refresh",
            user,
            extra={"event": "token_refresh", "user": user, "source": "refresh"}
        )
    except Exception as e:
        logger.warning("Konnte Benutzerinformationen nicht aus ID-Token lesen: %s", e)

    return response


@router.post("/verify-role", response_model=AuthValidationResponse)
async def verify_role(payload: AuthValidationRequest):
    """
    Prüft ob required_role in den Rollen ist.
    Funktioniert jetzt für Zitadel UND Offline.
    """
    logger.info("Rollenprüfung gestartet")

    decoded = await verify_token(payload.id_token, access_token=payload.access_token)
    roles = extract_roles(decoded)
    user = decoded.get("email") or decoded.get("sub") or "unbekannt"

    logger.debug("Nutzer: %s, Gefundene Rollen: %s", user, roles)

    if not payload.required_role:
        logger.warning("Keine Rolle angegeben bei Anfrage von %s", user)
        audit.info(
            "event=role_check_failed user=%s reason=no_role_specified",
            user,
            extra={"event": "role_check_failed", "user": user, "reason": "no_role_specified"}
        )
        raise HTTPException(status_code=400, detail="Feld 'rolle' muss angegeben werden")

    if payload.required_role not in roles:
        logger.warning("Zugriff verweigert: Nutzer %s hat nicht die Rolle '%s'", user, payload.required_role)
        audit.info(
            "event=role_check_failed user=%s required_role=%s reason=missing_required_role",
            user,
            payload.required_role,
            extra={
                "event": "role_check_failed",
                "user": user,
                "required_role": payload.required_role,
                "reason": "missing_required_role"
            }
        )
        raise HTTPException(status_code=403, detail="Benötigte Rolle fehlt")

    logger.info("Zugriff erlaubt für Nutzer %s mit Rolle '%s'", user, payload.required_role)
    audit.info(
        "event=role_check_success user=%s required_role=%s",
        user,
        payload.required_role,
        extra={"event": "role_check_success", "user": user, "required_role": payload.required_role}
    )
    return AuthValidationResponse(authorized=True, role_present=True)


@router.post("/logout")
async def logout(request: Request, response: Response):
    mode = (settings.auth_mode or "zitadel").lower().strip()
    if mode == "offline":
        return {"logout_url": None}

    response.delete_cookie(
        key="__Host-zitadel.useragent",
        path="/",
        secure=True,
        httponly=True,
        samesite="none",
    )

    id_token = request.headers.get("x-id-token") or request.headers.get("X-ID-Token")

    params = {
        "post_logout_redirect_uri": str(settings.zitadel_post_logout),
    }
    if id_token:
        params["id_token_hint"] = id_token

    logout_url = f"{settings.zitadel_logout}?{urlencode(params)}"
    return {"logout_url": logout_url}
