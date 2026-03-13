# -------------------------------------------------------------------
# Datei: auth/models.py
# Beschreibung: Pydantic-Modelle für Token-Antwort und User-Payload.
# Besonderheit: Eindeutige Typisierung (EmailStr, Listen).
# -------------------------------------------------------------------

from pydantic import BaseModel, Field, field_validator
from typing import List

class CodePayload(BaseModel):
    """
    Payload für den Authorization-Code-Callback:
    - code: Authorization Code (min. 10 Zeichen, z. B. von Zitadel zurückgeliefert)
    - verifier: PKCE-Code-Verifier (min. 43, max. 128 Zeichen)
    """
    code: str = Field(..., min_length=10)
    verifier: str = Field(..., min_length=43, max_length=128)

class RefreshPayload(BaseModel):
    """
    Payload für den Token-Refresh:
    - refresh_token: Der Refresh-Token (min. 10 Zeichen).
      Ein String, der nur aus 'null' besteht, gilt als ungültig.
    """
    refresh_token: str = Field(..., min_length=10)

    @field_validator("refresh_token")
    def check_token_not_null_string(cls, v):
        # Verhindert, dass jemand den String "null" (egal in welcher Gross-/Kleinschreibung)
        # als validen Refresh-Token übergibt.
        if v.strip().lower() == "null":
            raise ValueError("Ungültiger Refresh-Token")
        return v

class TokenResponse(BaseModel):
    """
    Standardantwort nach erfolgreichem Token-Austausch:
    - id_token: Das JWT-Token (ID-Token)
    - access_token: Access Token für API-Aufrufe
    - refresh_token: Neuer Refresh-Token
    """
    id_token: str
    access_token: str
    refresh_token: str



class AuthValidationRequest(BaseModel):
    """
    Payload für die Rollenprüfung:
    - id_token: JWT-Token des Benutzers
    - access_token: Access Token (wird teilweise für Token-Binding gebraucht)
    - required_role: Die Rolle, die überprüft werden soll (alias 'rolle')
    """
    id_token: str
    access_token: str
    required_role: str = Field(..., alias="rolle")

class AuthValidationResponse(BaseModel):
    """
    Antwort auf die Rollenprüfung:
    - authorized: True, wenn der Nutzer die Rolle hat
    - role_present: True, wenn die Rolle gefunden wurde (identisch mit 'authorized' hier)
    """
    authorized: bool
    role_present: bool
