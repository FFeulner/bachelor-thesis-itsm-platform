# -------------------------------------------------------------------
# Datei: auth/models.py
# Beschreibung: Pydantic-Modelle für Token-Antwort und User-Payload.
# Besonderheit: Eindeutige Typisierung (EmailStr, Listen).
# -------------------------------------------------------------------

from pydantic import BaseModel, Field, field_validator
from typing import List

class CodePayload(BaseModel):

    code: str = Field(..., min_length=10)
    verifier: str = Field(..., min_length=43, max_length=128)

class RefreshPayload(BaseModel):

    refresh_token: str = Field(..., min_length=10)

    @field_validator("refresh_token")
    def check_token_not_null_string(cls, v):

        if v.strip().lower() == "null":
            raise ValueError("Ungültiger Refresh-Token")
        return v

class TokenResponse(BaseModel):

    id_token: str
    access_token: str
    refresh_token: str



class AuthValidationRequest(BaseModel):

    id_token: str
    access_token: str
    required_role: str = Field(..., alias="rolle")

class AuthValidationResponse(BaseModel):

    authorized: bool
    role_present: bool
