# -------------------------------------------------------------------
# Datei: auth/roles.py
# Beschreibung: Rollenbasierte Zugriffs-Dependencies für FastAPI.
# Besonderheit: Prüft im Service-Layer auf erlaubte Rollen.
# -------------------------------------------------------------------

from fastapi import Depends, HTTPException, status
from .token import get_current_user, extract_roles

def require_roles(*required_roles: str):

    def role_dependency(user=Depends(get_current_user)):
        user_roles = extract_roles(user)
        if not any(role in user_roles for role in required_roles):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Zugriff verweigert. Erforderliche Rolle(n): {', '.join(required_roles)}",
            )
        return user
    return role_dependency
