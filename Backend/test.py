# print_aud_inline.py
# pip install python-jose
from jose import jwt
from datetime import datetime, timezone

# >>> HIER DEIN TOKEN EINFÜGEN (mit oder ohne "Bearer " Präfix) <<<
ACCESS_TOKEN = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjMzOTM2NzQ1NzY0MDY3NzM3OSIsInR5cCI6IkpXVCJ9.eyJhdWQiOlsiMzE0OTEwOTA5NTA2MDYwMjkwIiwiMzE0OTEwODg0NzQyODIzOTM4Il0sImNsaWVudF9pZCI6IjMxNDkxMDkwOTUwNjA2MDI5MCIsImV4cCI6MTc1ODgyODA3MCwiaWF0IjoxNzU4Nzg0ODY0LCJpc3MiOiJodHRwczovL2FlZ2lzLnRyaW5pdHljbG91ZC5kZSIsImp0aSI6IlYyXzMzOTM4NDQwMjc0NjI3Nzg5MS1hdF8zMzkzODQ0MDI3NDYzNDM0MjciLCJuYmYiOjE3NTg3ODQ4NjQsInN1YiI6IjMxMDcxMzg4NDgyODc2MjExNSIsInVybjp6aXRhZGVsOmlhbTpvcmc6cHJvamVjdDozMTQ5MTA4ODQ3NDI4MjM5Mzg6cm9sZXMiOnsiRW5pZ21hX1VzZXIiOnsiMjk2MjQyOTA5NjAxMTM2NjQzIjoidHJpbml0eW5ldHdvcmtzLmRlIn0sImFkbWluIjp7IjI5NjI0MjkwOTYwMTEzNjY0MyI6InRyaW5pdHluZXR3b3Jrcy5kZSJ9fSwidXJuOnppdGFkZWw6aWFtOm9yZzpwcm9qZWN0OnJvbGVzIjp7IkVuaWdtYV9Vc2VyIjp7IjI5NjI0MjkwOTYwMTEzNjY0MyI6InRyaW5pdHluZXR3b3Jrcy5kZSJ9LCJhZG1pbiI6eyIyOTYyNDI5MDk2MDExMzY2NDMiOiJ0cmluaXR5bmV0d29ya3MuZGUifX19.CTsgp3ZFzq5QQnx53ksoW3_oQ1eu3Ff_w4S8-nex8Zdc0_h68D6Bzyy4W7xfjwSk9UaksjA7_L7uMj9kQrPeWAxCOQv42Jfxe1HoAWnTdB59XoXwrrlpIGLJ03B76ZCYvRlmRPc08aUYNgWx1IPnxR-XLgluF9bGLGDd9my5z07-3EW-r1Vb3WwteWgDtQc-6WrpVWdW6jZDrc-yjZcT_i75wB8AYJ9oLnXsQxmmkVwlvkHy9QFqA6Vhc4QGKVS9nXdbO0K6DKxLpkhVcd7hzq6hyz3ejc3NZBQfrYSQ_vb71xOvE5OGtk2un-NPpT8Z2YfvUXpij54SMD8xna4-yw"

def main():
    raw = ACCESS_TOKEN.strip()
    if raw.lower().startswith("bearer "):
        raw = raw[7:].strip()

    parts = raw.split(".")
    if len(parts) != 3:
        print("❌ Kein gültiges JWT (erwarte 3 Segmente: header.payload.signature).")
        print("Hinweis: Ist dein Access-Token evtl. 'opaque' oder wurde beim Kopieren abgeschnitten?")
        print(f"Segmente gezählt: {len(parts)}")
        return

    try:
        claims = jwt.get_unverified_claims(raw)  # nur lesen, keine Signaturprüfung
    except Exception as e:
        print(f"❌ Token konnte nicht gelesen werden: {e}")
        return

    aud = claims.get("aud")
    iss = claims.get("iss")
    sub = claims.get("sub")
    exp = claims.get("exp")

    exp_str = None
    if isinstance(exp, (int, float)):
        try:
            exp_str = datetime.fromtimestamp(int(exp), tz=timezone.utc).isoformat()
        except Exception:
            exp_str = str(exp)

    print("✅ Claims (unverified):")
    print(f"  aud: {aud!r}")
    print(f"  iss: {iss!r}")
    print(f"  sub: {sub!r}")
    if exp is not None:
        print(f"  exp: {exp}  ({exp_str})")

    print("\n→ Trage den exakten Wert von 'aud' in settings.api_audience ein.")
    print("  Falls 'aud' eine Liste ist: nimm den Eintrag, der deine API/Resource repräsentiert (nicht die SPA-Client-ID).")

if __name__ == "__main__":
    main()
