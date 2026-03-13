# -------------------------------------------------------------------
# Datei: middlewares/audit_logger.py
# Beschreibung: Middleware zum Protokollieren aller Requests und Responses.
# Besonderheit: Schreibt strukturierte Logs mit Request- und User-ID.
# -------------------------------------------------------------------

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
import logging

# JSON-Audit-Logger
audit = logging.getLogger("audit")

class AuditMiddleware(BaseHTTPMiddleware):
    """
    Middleware, die nur Auth-bezogene Requests (Pfad enthält "auth")
    im Audit-Log (JSON) festhält.
    Protokolliert:
    - event: "auth_request"
    - path: angeforderter URL-Pfad
    - method: HTTP-Methode
    - ip: Client-IP (request.client.host)
    - status_code: HTTP-Status-Code der Antwort
    """
    async def dispatch(self, request: Request, call_next):
        # Anfrage verarbeiten lassen und Response zurückbekommen
        response = await call_next(request)

        ip = request.client.host if request.client else "unknown"
        path = request.url.path
        method = request.method

        # Nur Pfade loggen, die "auth" enthalten
        if "auth" in path:
            audit.info({
                "event": "auth_request",
                "path": path,
                "method": method,
                "ip": ip,
                "status_code": response.status_code
            })

        return response
