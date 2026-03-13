# -------------------------------------------------------------------
# Datei: middlewares/request_payload_logger.py
# Zweck: JSON-Request-Payloads loggen (auch bei 422 vor dem Endpoint)
# -------------------------------------------------------------------
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from fastapi.exceptions import RequestValidationError
from starlette.types import Message
import json
import logging
from typing import Any
import os

logger = logging.getLogger("request")  # reicht; propagiert zu Root/Console

SENSITIVE_KEYS = {"authorization", "token", "id_token", "password", "secret"}

REDACT_FIELDS = {s.strip().lower() for s in os.getenv("REDACT_FIELDS", "password,token,authorization").split(",")}
ENABLE_BODY_LOG = os.getenv("ENABLE_BODY_LOG", "false").lower() == "true"

def _redact(o: Any):
    if isinstance(o, dict):
        return {k: ("***" if k.lower() in SENSITIVE_KEYS else _redact(v)) for k, v in o.items()}
    if isinstance(o, list):
        return [_redact(v) for v in o]
    return o

async def _set_body(request: Request, body: bytes):
    async def receive() -> Message:
        return {"type": "http.request", "body": body, "more_body": False}
    request._receive = receive  # Body wieder verfügbar machen

class RequestPayloadLoggerMiddleware(BaseHTTPMiddleware):

    def __init__(self, app, include_prefix: str = "/api/dynamic_crud/"):
        super().__init__(app)
        self.include_prefix = include_prefix

    async def dispatch(self, request: Request, call_next):
        # Nur relevante Pfade loggen
        should_log = request.url.path.startswith(self.include_prefix)

        # Body lesen & puffern
        body = await request.body()
        request.state.raw_body = body
        await _set_body(request, body)

        # Eingehenden Payload loggen (nur DEBUG, nur JSON)
        if should_log and logger.isEnabledFor(logging.DEBUG) and body:
            ctype = request.headers.get("content-type", "")
            if ctype.startswith("application/json"):
                try:
                    data = json.loads(body.decode("utf-8"))
                    logger.debug(
                        "REQ %s %s payload=%s",
                        request.method, request.url.path,
                        json.dumps(_redact(data), ensure_ascii=False),
                    )
                except Exception:
                    logger.debug("REQ %s %s raw=%r", request.method, request.url.path, body[:2048])


        try:
            response = await call_next(request)
            return response
        except RequestValidationError as exc:
            if should_log and logger.isEnabledFor(logging.DEBUG):
                try:
                    data = json.loads((request.state.raw_body or b"").decode("utf-8") or "{}")
                    logger.debug(
                        "422 %s %s payload=%s errors=%s",
                        request.method, request.url.path,
                        json.dumps(_redact(data), ensure_ascii=False),
                        exc.errors(),
                    )
                except Exception:
                    logger.debug(
                        "422 %s %s raw=%r errors=%s",
                        request.method, request.url.path,
                        (request.state.raw_body or b"")[:2048],
                        exc.errors(),
                    )

            raise
