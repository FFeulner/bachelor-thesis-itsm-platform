# middlewares/security_headers.py

from typing import Optional

from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.types import ASGIApp


class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    def __init__(
        self,
        app: ASGIApp,
        *,
        csp: str,
        docs_csp: Optional[str] = None,
        hsts_max_age: int = 31536000,
        hsts_preload: bool = True,
        referrer_policy: str = "no-referrer",
        cross_origin_opener_policy: str = "same-origin",
        cross_origin_resource_policy: str = "same-site",
    ) -> None:
        super().__init__(app)
        self.csp = csp
        self.docs_csp = docs_csp or csp

        # Strict-Transport-Security
        hsts = f"max-age={hsts_max_age}; includeSubDomains"
        if hsts_preload:
            hsts += "; preload"
        self.hsts_header = hsts

        self.referrer_policy = referrer_policy
        self.coop = cross_origin_opener_policy
        self.corp = cross_origin_resource_policy

    async def dispatch(self, request: Request, call_next):
        response = await call_next(request)

        path = request.url.path

        # *** HIER wird entschieden, wann docs_csp verwendet wird ***
        if path.startswith(("/docs", "/redoc", "/openapi.json", "/api/docs", "/api/openapi.json")):
            response.headers["Content-Security-Policy"] = self.docs_csp
        else:
            response.headers["Content-Security-Policy"] = self.csp

        # Weitere Security-Header
        response.headers.setdefault("Strict-Transport-Security", self.hsts_header)
        response.headers.setdefault("Referrer-Policy", self.referrer_policy)
        response.headers.setdefault("Cross-Origin-Opener-Policy", self.coop)
        response.headers.setdefault("Cross-Origin-Resource-Policy", self.corp)

        return response
