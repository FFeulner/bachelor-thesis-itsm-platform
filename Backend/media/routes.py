# media.py
from fastapi import APIRouter, UploadFile, File, Form, HTTPException, Request, Query, Depends
from fastapi.responses import FileResponse
from pydantic import BaseModel
from typing import List, Optional
from pathlib import Path
from uuid import uuid4
from mimetypes import guess_type
import os, re
from .validation import validate_upload
import io

# <<< AUTH IMPORTS: verwendet dein bestehendes System >>>
from auth.token import get_current_user          # prüft das Bearer-Token
from auth.roles import require_roles             # rollenbasierter Guard

"""
Media-API:
- POST   /api/media/upload   (Multipart: 'file' ODER 'files[]', optional: form field 'folder' z.B. 'res/<RecID>')
- POST   /api/media/uploads  (alias, gleiches Verhalten)
- GET    /api/media/list     (?prefix=res&rec_id=<RecID>)
- DELETE /api/media/delete   (?path=res/<RecID>/<filename>)
- GET    /api/media/download (?path=.)
Statisches Serving in main.py: app.mount("/media", StaticFiles(directory=MEDIA_ROOT), name="media")
"""

# === Einstellungen ===
MEDIA_ROOT = Path(os.getenv("MEDIA_ROOT", "media")).resolve()
MEDIA_URL  = "/media"  # wird in main.py gemountet
MEDIA_ROOT.mkdir(parents=True, exist_ok=True)

# <<< Router mit Auth-Dependency für ALLE Routen >>>
media_router = APIRouter(
    prefix="/api/media",
    tags=["media"],
    dependencies=[Depends(require_roles("Enigma_User"))],
)

# ---- Regeln ----------------------------------------------------
ALLOWED_MIME_PREFIX = {"image/", "video/", "application/pdf"}
ALLOWED_EXTS = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg", ".mp4", ".pdf"}

_UUID_RX = re.compile(
    r"^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$",
    re.I
)

# ---- Hilfen ----------------------------------------------------
def _safe_dir_from_folder(folder: Optional[str]) -> Path:
    """
    Nimmt 'folder' wie 'res/<uuid>' entgegen und gibt den absoluten Zielordner zurück.
    Verhindert Path Traversal und erstellt den Ordner.
    Zusätzlich: erzwingt Schema 'res/<UUID>'.

    MINIMALE ERWEITERUNG:
    - erlaubt jetzt zusätzlich 'res/misc' als Fallback.
    """
    if not folder:
        return MEDIA_ROOT

    raw = folder.strip().lstrip("/\\")
    parts = [p for p in Path(raw).parts if p not in {"..", ".", ""}]

    # Vorher: nur res/<UUID>
    # Jetzt zusätzlich: res/misc erlauben
    if len(parts) != 2 or parts[0] != "res" or not (
        _UUID_RX.match(parts[1]) or parts[1] == "misc"
    ):
        raise HTTPException(
            status_code=400,
            detail="Ungültiger Zielordner. Erwartet: 'res/<UUID>' (oder 'res/misc')"
        )

    target = (MEDIA_ROOT / Path(*parts)).resolve()
    if MEDIA_ROOT not in target.parents and target != MEDIA_ROOT:
        raise HTTPException(status_code=400, detail="Ungültiger Zielpfad.")
    target.mkdir(parents=True, exist_ok=True)
    return target

def _safe_dir_from_prefix(prefix: Optional[str], rec_id: Optional[str]) -> Path:
    # Für Backwards-Compat, aber auch hier validieren
    p = (prefix or "res").strip()
    r = (rec_id or "").strip()
    if p != "res" or not _UUID_RX.match(r):
        raise HTTPException(
            status_code=400,
            detail="Ungültige Parameter. Verwende ?prefix=res&rec_id=<UUID>"
        )
    return _safe_dir_from_folder(f"{p}/{r}")

def _public_url(request: Request, rel_path: Path) -> str:
    base = str(request.base_url).rstrip("/")
    return f"{base}{MEDIA_URL}/{rel_path.as_posix()}"

class UploadItem(BaseModel):
    filename: str
    path: str          # relativer Pfad unterhalb /media
    url: str           # absolute URL
    content_type: str
    size: int

# ---- Endpunkte -------------------------------------------------
@media_router.post("/upload")
async def upload_files(
    request: Request,
    # Client-kompatibel: entweder 'file' ODER 'files'
    file: Optional[UploadFile] = File(None),
    files: Optional[List[UploadFile]] = File(None),
    # Flutter schickt den Zielordner als Formularfeld 'folder' (z. B. 'res/<RecID>')
    folder: Optional[str] = Form(None),
    # Backwards-Compat per Query
    prefix: Optional[str] = Query(None, description="Oberordner, z. B. 'res'"),
    rec_id: Optional[str] = Query(None, description="Unterordner (z. B. Vorgang_RecID)"),
    # <<< der eingeloggte User ist bei Bedarf verfügbar: >>>
    current_user: dict = Depends(get_current_user),
):
    # ——— Validierung: alte Struktur beibehalten, aber Stream danach resetten ———
    if file is not None:
        try:
            buf = io.BytesIO(await file.read())
            validate_upload(buf, file.filename or "")
            await file.seek(0)  # <<< wichtig: Stream resetten
        except ValueError as e:
            raise HTTPException(status_code=400, detail=str(e))

    if files:
        for _f in files:
            try:
                _buf = io.BytesIO(await _f.read())
                validate_upload(_buf, _f.filename or "")
                await _f.seek(0)  # <<< ebenfalls zurückspulen
            except ValueError as e:
                raise HTTPException(status_code=400, detail=str(e))

    # Zielordner wählen (bevorzugt 'folder', sonst prefix/rec_id) + validieren
    if folder:
        target_dir = _safe_dir_from_folder(folder)
    else:
        if not prefix or not rec_id:
            raise HTTPException(
                status_code=400,
                detail="Gib entweder 'folder' ODER 'prefix'+'rec_id' an."
            )
        target_dir = _safe_dir_from_prefix(prefix, rec_id)

    # Uploadliste zusammenstellen
    uploads: List[UploadFile] = []
    if file is not None:
        uploads.append(file)
    if files:
        uploads.extend(files)
    if not uploads:
        raise HTTPException(
            status_code=400,
            detail="Kein Datei-Upload gefunden (verwende Feld 'file' oder 'files')."
        )

    results: List[UploadItem] = []

    for f in uploads:
        # Content-Type robust bestimmen
        ctype = (f.content_type or "").lower()
        ext = Path(f.filename or "").suffix.lower()

        # Falls Browser nur octet-stream/leer sendet -> aus Dateiname raten
        if ctype in ("", "application/octet-stream"):
            guessed, _ = guess_type(f.filename or "")
            if guessed:
                ctype = guessed.lower()

        # Erlauben, wenn (a) Prefix passt ODER (b) octet-stream + erlaubte Endung
        if not (
            any(ctype.startswith(p) for p in ALLOWED_MIME_PREFIX)
            or (ctype == "application/octet-stream" and ext in ALLOWED_EXTS)
        ):
            raise HTTPException(
                status_code=415,
                detail=f"Nicht erlaubter Typ: {ctype or 'unbekannt'}"
            )

        # Datei speichern
        safe_ext = ext if ext in ALLOWED_EXTS else Path(f.filename or "").suffix[:20]
        new_name = f"{uuid4().hex}{safe_ext}"
        abs_path = (target_dir / new_name).resolve()

        size = 0
        with abs_path.open("wb") as out:
            while True:
                chunk = await f.read(1024 * 1024)
                if not chunk:
                    break
                size += len(chunk)
                out.write(chunk)
        await f.close()

        rel_path = abs_path.relative_to(MEDIA_ROOT)
        results.append(UploadItem(
            filename=new_name,
            path=rel_path.as_posix(),
            url=_public_url(request, rel_path),
            content_type=ctype or "application/octet-stream",
            size=size,
        ))

    # Single-File: flaches Objekt
    if len(results) == 1:
        one = results[0]
        return {
            "filename": one.filename,
            "path": one.path,
            "url": one.url,
            "content_type": one.content_type,
            "size": one.size,
        }
    # Multi-File: Liste
    return {"files": [r.dict() for r in results]}


# Alias-Endpunkt /uploads – gleiche Logik
@media_router.post("/uploads")
async def upload_files(
    request: Request,
    file: Optional[UploadFile] = File(None),
    files: Optional[List[UploadFile]] = File(None),
    folder: Optional[str] = Form(None),
    prefix: Optional[str] = Query(None, description="Oberordner, z. B. 'res'"),
    rec_id: Optional[str] = Query(None, description="Unterordner (z. B. Vorgang_RecID)"),
    current_user: dict = Depends(get_current_user),
):
    # ——— Validierung: alte Struktur beibehalten, aber Stream danach resetten ———
    if file is not None:
        try:
            buf = io.BytesIO(await file.read())
            validate_upload(buf, file.filename or "")
            await file.seek(0)
        except ValueError as e:
            raise HTTPException(status_code=400, detail=str(e))

    if files:
        for _f in files:
            try:
                _buf = io.BytesIO(await _f.read())
                validate_upload(_buf, _f.filename or "")
                await _f.seek(0)
            except ValueError as e:
                raise HTTPException(status_code=400, detail=str(e))

    if folder:
        target_dir = _safe_dir_from_folder(folder)
    else:
        if not prefix or not rec_id:
            raise HTTPException(status_code=400, detail="Gib entweder 'folder' ODER 'prefix'+'rec_id' an.")
        target_dir = _safe_dir_from_prefix(prefix, rec_id)

    uploads: List[UploadFile] = []
    if file is not None:
        uploads.append(file)
    if files:
        uploads.extend(files)
    if not uploads:
        raise HTTPException(status_code=400, detail="Kein Datei-Upload gefunden (verwende Feld 'file' oder 'files').")

    results: List[UploadItem] = []

    for f in uploads:
        ctype = (f.content_type or "").lower()
        ext = Path(f.filename or "").suffix.lower()

        if ctype in ("", "application/octet-stream"):
            guessed, _ = guess_type(f.filename or "")
            if guessed:
                ctype = guessed.lower()

        if not (
            any(ctype.startswith(p) for p in ALLOWED_MIME_PREFIX)
            or (ctype == "application/octet-stream" and ext in ALLOWED_EXTS)
        ):
            raise HTTPException(status_code=415, detail=f"Nicht erlaubter Typ: {ctype or 'unbekannt'}")

        safe_ext = ext if ext in ALLOWED_EXTS else Path(f.filename or "").suffix[:20]
        new_name = f"{uuid4().hex}{safe_ext}"
        abs_path = (target_dir / new_name).resolve()

        size = 0
        with abs_path.open("wb") as out:
            while True:
                chunk = await f.read(1024 * 1024)
                if not chunk:
                    break
                size += len(chunk)
                out.write(chunk)
        await f.close()

        rel_path = abs_path.relative_to(MEDIA_ROOT)
        results.append(UploadItem(
            filename=new_name,
            path=rel_path.as_posix(),
            url=_public_url(request, rel_path),
            content_type=ctype or "application/octet-stream",
            size=size,
        ))

    if len(results) == 1:
        one = results[0]
        return {
            "filename": one.filename,
            "path": one.path,
            "url": one.url,
            "content_type": one.content_type,
            "size": one.size,
        }
    return {"files": [r.dict() for r in results]}


@media_router.get("/list")
def list_media(
    request: Request,
    prefix: str = Query("res"),
    rec_id: Optional[str] = Query(None),
    current_user: dict = Depends(get_current_user),
):
    base = _safe_dir_from_prefix(prefix, rec_id)
    out = []
    for p in sorted(base.glob("*")):
        if p.is_file():
            rel = p.relative_to(MEDIA_ROOT)
            out.append({
                "filename": p.name,
                "path": rel.as_posix(),
                "url": _public_url(request, rel),
                "size": p.stat().st_size,
            })
    return out


@media_router.delete("/delete")
def delete_media(
    path: str = Query(..., description="Relativer Pfad unterhalb /media, z. B. res/<id>/file.jpg"),
    current_user: dict = Depends(get_current_user),
):
    abs_path = (MEDIA_ROOT / path).resolve()
    if MEDIA_ROOT not in abs_path.parents:
        raise HTTPException(status_code=400, detail="Ungültiger Pfad.")
    if not abs_path.exists() or not abs_path.is_file():
        raise HTTPException(status_code=404, detail="Datei nicht gefunden.")
    abs_path.unlink()
    return {"deleted": path}


@media_router.get("/download")
def download_media(
    path: str = Query(...),
    current_user: dict = Depends(get_current_user),
):
    abs_path = (MEDIA_ROOT / path).resolve()
    if MEDIA_ROOT not in abs_path.parents or not abs_path.is_file():
        raise HTTPException(status_code=404, detail="Datei nicht gefunden.")
    headers = {"Content-Disposition": f'attachment; filename="{abs_path.name}"'}
    return FileResponse(abs_path, headers=headers)
