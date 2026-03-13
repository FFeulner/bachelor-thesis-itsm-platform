# -------------------------------------------------------------------
# Datei: tests/test_auth_module.py
# Beschreibung: Unit-Tests für den Auth-Flow.
# Besonderheit: Simuliert JWKS-Response und Token-Verifikation.
# -------------------------------------------------------------------

import sys
import os
import pytest
from datetime import datetime, timedelta

# Stelle sicher, dass unser Projekt-Root im Pfad ist
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

import httpx
import jose
from jose import JWTError, ExpiredSignatureError
from fastapi import HTTPException, FastAPI
from fastapi.testclient import TestClient

import auth.jwks as jwks_mod
import auth.token as token_mod
import auth.service as service_mod
import auth.routes as routes_mod
from auth.models import CodePayload, RefreshPayload

# -- Fixtures ----------------------------------------------------------------

@pytest.fixture
def app():
    app = FastAPI()
    # Nur einmal Prefix in routes_mod.router, hier ohne zusätzlichen Prefix
    app.include_router(routes_mod.router)
    return app

@pytest.fixture
def client(app):
    return TestClient(app)



# -- JWKS-Tests --------------------------------------------------------------

@pytest.mark.asyncio
async def test_load_and_cache_jwks(monkeypatch):
    fake = {"keys": [{"kid": "k1", "kty": "RSA"}]}
    class Dummy:
        def raise_for_status(self): pass
        def json(self): return fake

    async def fake_get(self, url):
        return Dummy()

    # erster Aufruf lädt ins Cache
    monkeypatch.setattr(httpx.AsyncClient, "get", fake_get)
    out1 = await jwks_mod.load_jwks()
    assert out1 == fake
    assert jwks_mod._jwks_cache["jwks"] is fake

    # zweiter Aufruf nutzt Cache
    called = False
    async def should_not(self, url):
        nonlocal called
        called = True
        return Dummy()
    monkeypatch.setattr(httpx.AsyncClient, "get", should_not)

    out2 = await jwks_mod.load_jwks()
    assert out2 == fake
    assert called is False

@pytest.mark.asyncio
async def test_get_public_key_success_and_failure():
    # valid cache
    jwks_mod._jwks_cache.update({
        "jwks": {"keys":[{"kid":"xyz","kty":"RSA"}]},
        "expires": datetime.now() + timedelta(hours=1)
    })
    key = await jwks_mod.get_public_key("xyz")
    assert key["kid"] == "xyz"

    # invalid kid -> HTTPException 500
    with pytest.raises(HTTPException) as exc:
        await jwks_mod.get_public_key("none")
    assert exc.value.status_code == 500


# -- Token-Tests -------------------------------------------------------------

def test_extract_roles_various():
    assert set(token_mod.extract_roles({"urn:zitadel:iam:org:project:roles": {"a":{}, "b":{}}})) == {"a","b"}
    assert token_mod.extract_roles({}) == []

@pytest.mark.asyncio
async def test_verify_token_errors(monkeypatch):
    # stub get_public_key und get_unverified_header
    async def dummy_pk(kid): return "secret"
    monkeypatch.setattr(token_mod, "get_public_key", dummy_pk)
    monkeypatch.setattr(jose.jwt, "get_unverified_header", lambda t: {"kid":"k"})
    # 1) ExpiredSignatureError
    monkeypatch.setattr(jose.jwt, "decode", lambda *args, **kwargs: (_ for _ in ()).throw(ExpiredSignatureError()))
    with pytest.raises(HTTPException) as e1:
        await token_mod.verify_token("tok", access_token=None)
    assert e1.value.status_code == 401

    # 2) Generic JWTError
    monkeypatch.setattr(jose.jwt, "decode", lambda *args, **kwargs: (_ for _ in ()).throw(JWTError("boom")))
    with pytest.raises(HTTPException) as e2:
        await token_mod.verify_token("tok", access_token=None)
    assert e2.value.status_code == 401


# -- Service-Tests -----------------------------------------------------------

@pytest.mark.asyncio
async def test_exchange_and_process_token_success(monkeypatch):
    # Fake HTTP-Antwort
    tokens = {"id_token":"i","access_token":"a","refresh_token":"r"}
    class Dummy:
        def raise_for_status(self): pass
        def json(self): return tokens
    async def fake_post(self, url, data, headers):
        return Dummy()
    monkeypatch.setattr(httpx.AsyncClient, "post", fake_post)

    # stub verify_token und extract_roles in service_mod
    async def fake_verify(token, access_token=None):
        return {"sub":"u","urn:zitadel:iam:org:project:roles":{"R":{}}}
    monkeypatch.setattr(service_mod, "verify_token", fake_verify)
    monkeypatch.setattr(service_mod, "extract_roles", lambda d: ["R"])

    out = await service_mod.exchange_and_process_token({
        "grant_type":"authorization_code","code":"c","redirect_uri":"","client_id":"","code_verifier":"","scope":""
    })
    assert out.id_token == "i"
    assert out.roles == ["R"]


# -- Route-Tests -------------------------------------------------------------

def test_callback_and_refresh_endpoints(client, monkeypatch):
    fake = service_mod.TokenResponse(id_token="X", access_token="Y", refresh_token="Z", roles=["role"])
    async def fx(data): return fake
    # Patch der Service-Funktion in routes_mod
    monkeypatch.setattr(routes_mod, "exchange_and_process_token", fx)

    # callback
    res1 = client.post("/api/auth/callback", json={"code":"1"*10, "verifier":"v"*43})
    assert res1.status_code == 200
    assert res1.json()["id_token"] == "X"

    # refresh
    res2 = client.post("/api/auth/refresh", json={"refresh_token":"R"*10})
    assert res2.status_code == 200
    assert res2.json()["refresh_token"] == "Z"

def test_verify_role_endpoint(client, monkeypatch):
    # stub verify_token & extract_roles in routes_mod
    async def vt(idt, access_token): return {"sub":"user"}
    monkeypatch.setattr(routes_mod, "verify_token", vt)
    monkeypatch.setattr(routes_mod, "extract_roles", lambda d: ["admin"])

    # success
    r = client.post("/api/auth/verify-role", json={"id_token":"i","access_token":"a","rolle":"admin"})
    assert r.status_code == 200
    assert r.json() == {"authorized": True, "role_present": True}

    # missing 'rolle'
    r2 = client.post("/api/auth/verify-role", json={"id_token":"i","access_token":"a","rolle":""})
    assert r2.status_code == 400

    # wrong role
    r3 = client.post("/api/auth/verify-role", json={"id_token":"i","access_token":"a","rolle":"missing"})
    assert r3.status_code == 403
