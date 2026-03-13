# Mail_Handler/graph_utils.py

import base64
import logging
import random
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional

import msal
import requests

log = logging.getLogger(__name__)


@dataclass
class GraphConfig:
    tenant_id: str
    client_id: str
    client_secret: str
    scope: str = "https://graph.microsoft.com/.default"
    base_url: str = "https://graph.microsoft.com/v1.0"


def _sleep_backoff(attempt: int, cap: float = 30.0) -> None:
    """
    Exponential backoff + jitter.
    attempt beginnt bei 1.
    """
    delay = min(cap, 2 ** attempt)
    jitter = 0.7 + random.random() * 0.6  # 0.7..1.3
    time.sleep(delay * jitter)


class GraphClient:
    """
    Gemeinsamer Graph-Client für alle Daemons.
    - Verantwortlich für Token, HTTP-Requests, Retry-Logik und Folder-/Message-Helfer.
    """

    def __init__(self, cfg: GraphConfig) -> None:
        self.cfg = cfg

        # Hinweis: Das hier triggert noch keinen Network-Call,
        # aber später macht MSAL Discovery/Token-Calls über requests.
        self._app = msal.ConfidentialClientApplication(
            client_id=cfg.client_id,
            client_credential=cfg.client_secret,
            authority=f"https://login.microsoftonline.com/{cfg.tenant_id}",
        )

        self._session = requests.Session()

        # Token + Ablaufzeit (epoch seconds)
        self._token: Optional[str] = None
        self._token_expires_at: float = 0.0

        self._folder_cache: Dict[str, str] = {}

    # --------------------------------------------------
    # Token & HTTP
    # --------------------------------------------------

    def _make_url(self, url: str) -> str:
        if url.startswith("http://") or url.startswith("https://"):
            return url
        return self.cfg.base_url.rstrip("/") + url

    def _get_token(self, max_retries: int = 5) -> str:
        # Token noch gültig? (60s Puffer)
        if self._token and (time.time() < (self._token_expires_at - 60)):
            return self._token

        attempt = 0
        last_exc: Optional[BaseException] = None

        while True:
            attempt += 1
            try:
                res = self._app.acquire_token_for_client(scopes=[self.cfg.scope])
            except (requests.RequestException, OSError) as ex:
                last_exc = ex
                log.warning("Token fetch network error (attempt %s/%s): %s", attempt, max_retries, ex)
                if attempt >= max_retries:
                    raise
                _sleep_backoff(attempt)
                continue

            # Erfolg
            if "access_token" in res:
                self._token = res["access_token"]
                expires_in = res.get("expires_in") or 3599
                try:
                    expires_in = int(expires_in)
                except Exception:
                    expires_in = 3599
                self._token_expires_at = time.time() + expires_in
                return self._token

            # Transiente AAD/MSAL Fehler ggf. retryen
            err = (res.get("error") or "").lower()
            transient = err in {"temporarily_unavailable", "server_error"}  # typische transient errors
            if transient and attempt < max_retries:
                log.warning("Token fetch transient error (attempt %s/%s): %s", attempt, max_retries, res)
                _sleep_backoff(attempt)
                continue

            # Nicht transient / keine retries mehr
            if last_exc:
                raise RuntimeError(f"Token Error (and last exception: {last_exc}): {res}")
            raise RuntimeError(f"Token Error: {res}")

    def _request_with_retry(
        self,
        method: str,
        url: str,
        max_retries: int = 3,
        timeout: float | tuple[float, float] = (3.05, 30),  # (connect, read)
        **kwargs,
    ) -> requests.Response:
        full_url = self._make_url(url)
        attempt = 0

        while True:
            attempt += 1
            try:
                token = self._get_token()  # <- wichtig: Token-Call ist jetzt auch im Retry-Scope

                headers = kwargs.pop("headers", {}) or {}
                headers = dict(headers)  # copy
                headers.setdefault("Authorization", f"Bearer {token}")
                headers.setdefault("Accept", "application/json")
                if method.upper() in ("POST", "PATCH"):
                    headers.setdefault("Content-Type", "application/json")

                resp = self._session.request(
                    method=method,
                    url=full_url,
                    headers=headers,
                    timeout=timeout,
                    **kwargs,
                )

            except (requests.RequestException, OSError) as ex:
                log.warning(
                    "Graph request error (attempt %s/%s): %s %s - %s",
                    attempt,
                    max_retries,
                    method,
                    full_url,
                    ex,
                )
                # Token ggf. kaputt/halb geholt -> beim nächsten Versuch neu holen
                self._token = None
                self._token_expires_at = 0.0

                if attempt >= max_retries:
                    raise
                _sleep_backoff(attempt)
                continue

            if resp.status_code == 401:
                # Token ungültig -> neu holen und noch einmal versuchen
                self._token = None
                self._token_expires_at = 0.0
                if attempt >= max_retries:
                    resp.raise_for_status()
                    return resp
                time.sleep(1)
                continue

            if resp.status_code in (429, 500, 502, 503, 504):
                if attempt >= max_retries:
                    resp.raise_for_status()
                    return resp

                retry_after = resp.headers.get("Retry-After")
                delay = int(retry_after) if (retry_after or "").isdigit() else (2 ** attempt)
                log.warning(
                    "Graph returned %s, retrying in %s s (%s %s)",
                    resp.status_code,
                    delay,
                    method,
                    full_url,
                )
                time.sleep(delay)
                continue

            resp.raise_for_status()
            return resp

    def get(self, url: str, params: Optional[dict] = None) -> dict:
        resp = self._request_with_retry("GET", url, params=params)
        if resp.content:
            return resp.json()
        return {}

    def post(self, url: str, json: Optional[dict] = None) -> dict:
        resp = self._request_with_retry("POST", url, json=json)
        if resp.content:
            return resp.json()
        return {}

    def patch(self, url: str, json: Optional[dict] = None) -> dict:
        resp = self._request_with_retry("PATCH", url, json=json)
        if resp.content:
            return resp.json()
        return {}

    # --------------------------------------------------
    # Folder & Messages
    # --------------------------------------------------

    def list_root_folders(self, mailbox: str) -> List[dict]:
        data = self.get(f"/users/{mailbox}/mailFolders?$top=200")
        return data.get("value", [])

    # Alias für Kompatibilität mit bestehendem Code
    def _list_root_folders(self, mailbox: str) -> List[dict]:
        return self.list_root_folders(mailbox)

    def find_or_create_folder(self, mailbox: str, display_name: str) -> str:
        key = f"{mailbox}:{display_name}".lower().strip()
        if key in self._folder_cache:
            return self._folder_cache[key]

        target = display_name.lower().strip()
        for f in self.list_root_folders(mailbox):
            if (f.get("displayName") or "").lower().strip() == target:
                folder_id = f["id"]
                self._folder_cache[key] = folder_id
                return folder_id

        created = self.post(
            f"/users/{mailbox}/mailFolders",
            json={"displayName": display_name},
        )
        folder_id = created["id"]
        self._folder_cache[key] = folder_id
        log.info("[FOLDER] erstellt: %s für %s (%s)", display_name, mailbox, folder_id)
        return folder_id

    def ensure_folder(self, mailbox: str, display_name: str) -> str:
        return self.find_or_create_folder(mailbox, display_name)

    def move_message(self, mailbox: str, msg_id: str, dest_folder_id: str) -> dict:
        return self.post(
            f"/users/{mailbox}/messages/{msg_id}/move",
            json={"destinationId": dest_folder_id},
        )

    def iter_messages(
        self,
        mailbox: str,
        folder_id: str,
        select: Optional[Iterable[str]] = None,
        orderby: Optional[str] = None,
        top: int = 25,
    ) -> Iterable[dict]:
        params: Dict[str, str] = {"$top": str(top)}
        if select:
            params["$select"] = ",".join(select)
        if orderby:
            params["$orderby"] = orderby

        url = f"/users/{mailbox}/mailFolders/{folder_id}/messages"

        while True:
            data = self.get(url, params=params)
            for msg in data.get("value", []):
                yield msg
            next_link = data.get("@odata.nextLink")
            if not next_link:
                break
            url = next_link
            params = None  # ab jetzt ist alles im nextLink enthalten

    # --------------------------------------------------
    # Attachments
    # --------------------------------------------------

    def download_attachments(
        self,
        mailbox: str,
        msg_id: str,
        outdir: Path,
    ) -> List[Path]:
        """
        Lädt alle fileAttachments herunter – inkl. Inline-Bildern.
        Wichtig:
        - isInline wird NICHT gefiltert, damit eingebettete Bilder nicht verloren gehen.
        - Dateinamenskollisionen werden vermieden.
        """
        outdir.mkdir(parents=True, exist_ok=True)
        data = self.get(f"/users/{mailbox}/messages/{msg_id}/attachments")
        saved: List[Path] = []

        for att in data.get("value", []):
            # Nur echte Dateien (kein Item-/ReferenceAttachment)
            if att.get("@odata.type") != "#microsoft.graph.fileAttachment":
                continue

            is_inline = bool(att.get("isInline"))
            content_id = att.get("contentId")

            name = att.get("name") or "attachment.bin"
            content = att.get("contentBytes")
            if not content:
                continue

            try:
                blob = base64.b64decode(content)
            except Exception:
                log.exception("Attachment-Decode fehlgeschlagen msg=%s file=%s", msg_id, name)
                continue

            # Inline-Anhänge optional markieren, damit man sie erkennt
            if is_inline and not name.lower().startswith("inline_"):
                name = f"inline_{name}"

            path = outdir / name

            # Kollisionen vermeiden: wenn Datei schon existiert, durchnummerieren
            if path.exists():
                stem = path.stem
                suffix = path.suffix
                i = 1
                while path.exists():
                    path = outdir / f"{stem}_{i}{suffix}"
                    i += 1

            path.write_bytes(blob)
            saved.append(path)

            log.debug(
                "Attachment gespeichert msg=%s file=%s inline=%s contentId=%s",
                msg_id,
                path.name,
                is_inline,
                content_id,
            )

        return saved
