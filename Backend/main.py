# FastAPIProject/main.py

from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from starlette.responses import JSONResponse, Response
from starlette.middleware.trustedhost import TrustedHostMiddleware
from starlette.middleware.gzip import GZipMiddleware

# Auth
from fastapi import Depends
from auth.roles import require_roles

# eigene Settings/DB
from config.settings import settings
from core.main_db import engine  # für /readyz DB-Ping
from utils.logger_setup import setup_logging, get_logger
import logging

# ---------------- Logging ----------------#
setup_logging(
    level=getattr(logging, settings.log_level.upper(), logging.INFO),
    to_file=True,
    audit_to_file=True,
    log_dir="logs",
)

logger = logging.getLogger(__name__)
logger.info("FastAPI-Anwendung wird gestartet...")



# eigene Middlewares
from middlewares.request_id import RequestIdMiddleware
from middlewares.security_headers import SecurityHeadersMiddleware

# feste Router
from auth.routes import router as auth_router
from media.routes import media_router
from deletions.routes import router as deletions_router
from changes.routes import router as changes_router


from special_crud.aktivitaeten.routes import router as aktivitaeten_router

# ---- Dynamische CRUD-Erzeugung: Imports (robust) ----
try:
    # häufigster Pfad in deinem Projekt
    from generic_crud.models import Base
except Exception:  # fallback, falls deine Struktur anders ist
    Base = None

from generic_crud.routes import create_crud_router

# Rate Limiting (global)
from slowapi import Limiter
from slowapi.util import get_remote_address
from slowapi.middleware import SlowAPIMiddleware
from slowapi.errors import RateLimitExceeded

# Metrics
import time
from sqlalchemy import text as sql
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST


# -----------------------------------------------------------------------------
# App-Setup
# -----------------------------------------------------------------------------
APP_TITLE = getattr(settings, "APP_NAME", "Enigma API")
app = FastAPI(
    title=APP_TITLE,
    docs_url="/api/docs",
    openapi_url="/api/openapi.json",
)

# 1) Nur deine Domains zulassen
app.add_middleware(TrustedHostMiddleware, allowed_hosts=getattr(settings, "trusted_hosts", ["*"]))

# 2) Security-Header (Frontend: http://localhost:58726, Backend: http://127.0.0.1:8000 / http://localhost:8000)
app.add_middleware(
    SecurityHeadersMiddleware,
    csp=(
        "default-src 'none'; "
        # Frontend assets
        "style-src 'self' 'unsafe-inline'; "
        "script-src 'self'; "
        # Optional: Bilder vom Backend oder data-URLs
        "img-src 'self' data: "
        "http://127.0.0.1:8000 http://localhost:8000; "
        # API Calls (fetch/axios), SSE, ggf. WebSockets
        "connect-src 'self' "
        "http://127.0.0.1:8000 http://localhost:8000 "
        "ws://127.0.0.1:8000 ws://localhost:8000; "
    ),
    docs_csp=(
        "default-src 'none'; "
        "img-src 'self' data: "
        "http://127.0.0.1:8000 http://localhost:8000 "
        "https://fastapi.tiangolo.com; "
        "style-src 'self' 'unsafe-inline' "
        "https://cdn.jsdelivr.net https://unpkg.com https://cdnjs.cloudflare.com; "
        "script-src 'self' 'unsafe-inline' 'unsafe-eval' "
        "https://cdn.jsdelivr.net https://unpkg.com https://cdnjs.cloudflare.com; "
        "connect-src 'self' "
        "http://127.0.0.1:8000 http://localhost:8000 "
        "ws://127.0.0.1:8000 ws://localhost:8000; "
    ),
    hsts_max_age=31536000,
    hsts_preload=True,
    referrer_policy="no-referrer",
    cross_origin_opener_policy="same-origin",
    cross_origin_resource_policy="same-site",
)


# 3) Request-ID und GZip
app.add_middleware(RequestIdMiddleware)
app.add_middleware(GZipMiddleware, minimum_size=1024)

# 4) CORS (ohne "*")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)

# --- Rate Limiting: sicher (IP-basiert) ---
limiter = Limiter(key_func=get_remote_address, default_limits=["200/minute"])
app.state.limiter = limiter
app.add_middleware(SlowAPIMiddleware)

@app.exception_handler(RateLimitExceeded)
def _rl_handler(request, exc):
    return JSONResponse(
        {"detail": "rate limit exceeded"},
        status_code=429,
        headers={"Retry-After": str(getattr(exc, "period_remaining", 60))}
    )



# -----------------------------------------------------------------------------
# Static Mounts
# -----------------------------------------------------------------------------
# Media-Verzeichnis unter /media ausliefern (nur ÖFFENTLICH! Private Files über signierte Routen)
app.mount("/media", StaticFiles(directory=getattr(settings, "MEDIA_DIR", "media")), name="media")


# -----------------------------------------------------------------------------
# Router registrieren (statisch + dynamisch)
# -----------------------------------------------------------------------------
# feste Router
app.include_router(auth_router)
app.include_router(media_router)
app.include_router(deletions_router)
app.include_router(changes_router)
app.include_router(aktivitaeten_router)



# >>> WICHTIGER ABSCHNITT: DYNAMISCHES CRUD PRO TABELLE <<<
# Erzeugt für jede reflektierte ORM-Klasse einen eigenen CRUD-Router
if Base is not None and create_crud_router is not None:
    # Base.classes ist bei Automap das Mapping {tabellenname: ORM-Klasse}
    for table_name, orm_cls in Base.classes.items():
        app.include_router(
            create_crud_router(
                orm_cls,
                prefix=f"/api/dynamic_crud/{table_name}",
                tags=[table_name],
            )
        )
# (Falls Base oder create_crud_router nicht auflösbar sind, wird der Block einfach übersprungen.)


# -----------------------------------------------------------------------------
# Metrics & Health
# -----------------------------------------------------------------------------
REQ_COUNT = Counter("http_requests_total", "", ["method", "path", "status"])
REQ_LAT = Histogram("http_request_duration_seconds", "", ["path"])


@app.middleware("http")
async def _metrics(request: Request, call_next):
    start = time.perf_counter()
    resp = await call_next(request)
    try:
        status = str(resp.status_code)
    except Exception:
        status = "500"
    REQ_COUNT.labels(request.method, request.url.path, status).inc()
    REQ_LAT.labels(request.url.path).observe(time.perf_counter() - start)
    return resp


@app.get("/metrics", dependencies=[Depends(require_roles("admin"))])
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)


@app.get("/livez")
def livez():
    return {"ok": True}


@app.get("/readyz")
def readyz():
    # einfacher DB-Ping
    with engine.connect() as c:
        c.execute(sql("SELECT 1"))
    return {"ready": True}


# -----------------------------------------------------------------------------
# Einheitliche Exception-Handler
# -----------------------------------------------------------------------------
@app.exception_handler(RequestValidationError)
async def _validation_exc(request: Request, exc: RequestValidationError):
    return JSONResponse({"detail": "Validation failed", "errors": exc.errors()}, status_code=422)


@app.exception_handler(Exception)
async def _unhandled_exc(request: Request, exc: Exception):
    return JSONResponse({"detail": "Internal Server Error"}, status_code=500)




