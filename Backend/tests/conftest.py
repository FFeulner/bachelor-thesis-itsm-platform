# -------------------------------------------------------------------
# Datei: tests/conftest.py
# Beschreibung: Pytest-Fixtures und JWKS-Cache-Reset.
# Besonderheit: Läuft automatisch vor und nach jedem Test.
# -------------------------------------------------------------------

import sys
import os
import pytest

# Projekt-Root ins Modul‐Suchpath aufnehmen
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

# Cache vor/nach jedem Test auf Defaults zurücksetzen
import auth.jwks as jwks_mod

@pytest.fixture(autouse=True)
def reset_jwks_cache():
    jwks_mod._jwks_cache.clear()
    jwks_mod._jwks_cache.update({"jwks": None, "expires": None})
    yield
    jwks_mod._jwks_cache.clear()
    jwks_mod._jwks_cache.update({"jwks": None, "expires": None})
