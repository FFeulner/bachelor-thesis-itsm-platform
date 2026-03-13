# validation.py
import os, imghdr

MAX_FILE_BYTES = int(os.getenv("MAX_UPLOAD_MB", "20")) * 1024 * 1024
# Default-Endungen an deine API-Regeln angepasst
ALLOWED_EXT = set(
    s.strip().lower()
    for s in os.getenv("ALLOWED_EXT", "jpg,jpeg,png,gif,webp,svg,mp4,pdf").split(",")
)

def validate_upload(fileobj, filename: str):
    # Größe
    fileobj.seek(0, os.SEEK_END)
    size = fileobj.tell()
    fileobj.seek(0)
    if size > MAX_FILE_BYTES:
        raise ValueError("file too large")

    # Extension
    ext = ""
    if "." in filename:
        ext = filename.rsplit(".", 1)[-1].lower()
    if ext not in ALLOWED_EXT:
        raise ValueError("extension not allowed")

    # Simple Magic-Bytes bei Rasterbildern
    if ext in {"jpg", "jpeg", "png"}:
        head = fileobj.read(512)
        fileobj.seek(0)
        if not imghdr.what(None, h=head):
            raise ValueError("invalid image data")
