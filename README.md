# bachelor-thesis-itsm-platform

# Enigma lokal unter Windows in PyCharm starten

Diese Anleitung beschreibt, wie die Anwendung lokal auf einem Windows-System in **PyCharm** eingerichtet und gestartet wird.

---

## Voraussetzungen

Folgende Software sollte installiert sein:

- **PyCharm**
- **Python 3.12**
- **MySQL oder MariaDB**
- **Flutter**
- ein entpacktes Projektarchiv `bachelor-thesis-itsm-platform`

---

## Projektstruktur

Wichtige Ordner im Projekt:

- `Backend`  
  FastAPI-Backend

- `Frontend/ff_bachelor_arbeit`  
  Flutter-Web-Frontend

- `Database/bachelor-thesis-itsm-platform.sql`  
  SQL-Dump der Hauptdatenbank

- `Backend/Mail_Handler`  
  Mail-Automation für Microsoft 365 / Outlook

---

## 1. Projekt in PyCharm öffnen

1. Das ZIP-Archiv entpacken
2. In **PyCharm** den Ordner `bachelor-thesis-itsm-platform` öffnen
3. Für Backend-Arbeiten im Ordner `Backend` arbeiten
4. Für Frontend-Arbeiten im Ordner `Frontend/ff_bachelor_arbeit` arbeiten

---

## 2. Datenbanken anlegen

Für das lokale Setup werden zwei Datenbanken benötigt:

- `bachelordb`
- `changes_db`

Diese in MariaDB anlegen(zum Beispiel über die Software XAMPP):

```sql
CREATE DATABASE bachelordb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE changes_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Danach den SQL-Dump importieren:

- Datei: `Database/bachelor-thesis-itsm-platform.sql`
- Ziel-Datenbank: `bachelordb`

Die Datenbank `changes_db` bleibt zunächst leer.

---

## 3. Python-Interpreter in PyCharm einrichten

Im Ordner `Backend`:

1. **File**
2. **Settings**
3. **Project**
4. **Python Interpreter**
5. Neue **Virtual Environment** anlegen

Empfohlen wird **Python 3.12**.

Es ist sinnvoll, eine neue lokale virtuelle Umgebung zu erstellen und nicht die bereits mitgelieferte `.venv` zu übernehmen.

---

## 4. Backend-Bibliotheken installieren

Im PyCharm-Terminal in den Backend-Ordner wechseln:

```bash
cd Backend
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt
```

Falls `requirements.txt` wegen eines Encoding-Problems nicht funktioniert, die Datei in **UTF-8** speichern und den Befehl erneut ausführen:

```bash
pip install -r requirements.txt
```

---

## 5. Backend konfigurieren

Die Konfiguration befindet sich in:

```text
Backend/settings.env
```

Wichtige Werte prüfen bzw. anpassen:

```env
# Für lokal am einfachsten
auth_mode=offline

redirect_uri=http://localhost:58726/auth-redirect
frontend_origins='["http://localhost:58726","http://127.0.0.1:58726"]'

# Datenbankzugänge an dein lokales System anpassen
database_url=mysql+pymysql://root:DEIN_PASSWORT@127.0.0.1:3306/bachelordb
audit_db_url=mysql+pymysql://root:DEIN_PASSWORT@127.0.0.1:3306/changes_db
mail_db_url=mysql+pymysql://root:DEIN_PASSWORT@127.0.0.1:3306/bachelordb

# Beliebiges Secret setzen
download_secret=irgendein_secret
```

### Hinweise

- Im Projekt steht aktuell `auth_mode=hybrid`. Für das lokale Starten ist `offline` in der Regel einfacher.
- Die Zugangsdaten müssen zu deiner lokalen MySQL- oder MariaDB-Installation passen.
- `frontend_origins` sollte den lokalen Frontend-Port enthalten.

---

## 6. Backend starten

Wichtig ist, dass das Backend aus dem Ordner `Backend` gestartet wird, damit `settings.env` korrekt gefunden wird.

```bash
cd Backend
uvicorn main:app --host 127.0.0.1 --port 8000 --reload
```

---

## 7. Backend testen

Nach dem Start im Browser folgende URLs prüfen:

```text
http://127.0.0.1:8000/livez
http://127.0.0.1:8000/readyz
```

Wenn alles korrekt eingerichtet ist, läuft das Backend.

---

## 8. Frontend konfigurieren

Die lokale Frontend-Konfiguration liegt in:

```text
Frontend/ff_bachelor_arbeit/assets/environment_values/environment.json
```

Für das lokale Setup sollte dort Folgendes stehen:

```json
{
  "apiURl": "http://127.0.0.1:8000",
  "zitadelRedirectUri": "http://localhost:58726/auth-redirect"
}
```

### Wichtig

Da das Frontend lokal mit Port `58726` gestartet wird, muss auch die Redirect-URL diesen Port verwenden.

---

## 9. Frontend starten

Im Ordner `Frontend/ff_bachelor_arbeit`:

```bash
cd Frontend/ff_bachelor_arbeit
flutter pub get
flutter run -d chrome --web-port 58726
```

---

## 10. Optional: Microsoft 365 / Outlook für den Mail-Handler einrichten

Wenn die Mail-Funktionen genutzt werden sollen, kann im Ordner `Backend/Mail_Handler` die Datei `office.env` angepasst werden.

Pfad:

```text
Backend/Mail_Handler/office.env
```

Dort können die Microsoft-365-Zugangsdaten und Mailbox-Einstellungen hinterlegt werden:

```env
TENANT_ID=
CLIENT_ID=
CLIENT_SECRET=
MAILBOX=
TARGET_FOLDER=done
ATTACHMENTS_DIR=./attachments
MOVE_MODE=move
MAILBOX_SEND=
MEDIA_PUBLIC_BASE=https://127.0.0.1:8000/media/
```

### Bedeutung der wichtigsten Felder

- `TENANT_ID`  
  Azure / Microsoft Entra Tenant-ID

- `CLIENT_ID`  
  App-Registrierung in Azure / Entra

- `CLIENT_SECRET`  
  Secret der App-Registrierung

- `MAILBOX`  
  Postfach, aus dem Mails gelesen werden

- `MAILBOX_SEND`  
  Postfach, über das gesendet werden soll

- `TARGET_FOLDER`  
  Zielordner nach erfolgreichem Import, zum Beispiel `done`

- `ATTACHMENTS_DIR`  
  Speicherort für Anhänge

- `MOVE_MODE`  
  Verhalten nach Verarbeitung, zum Beispiel `move`

- `MEDIA_PUBLIC_BASE`  
  Öffentliche Basis-URL für Medien und Anhänge

### Hinweis

Der Mail-Handler ist für das reine Starten von Backend und Frontend **nicht zwingend erforderlich**. Er ist nur nötig, wenn die Outlook- beziehungsweise O365-Mail-Automation lokal mitgenutzt werden soll.

---

## 11. Lokale URLs

Nach dem Start sind die Anwendungen unter folgenden Adressen erreichbar:

- **Backend:** `http://127.0.0.1:8000`
- **Frontend:** `http://localhost:58726`

---

## 12. Schnellstart

### Backend

```bash
cd Backend
pip install -r requirements.txt
uvicorn main:app --host 127.0.0.1 --port 8000 --reload
```

### Frontend

```bash
cd Frontend/ff_bachelor_arbeit
flutter pub get
flutter run -d chrome --web-port 58726
```

---

## 13. Typische Fehler

### Backend startet nicht

Mögliche Ursachen:

- falscher Startordner
- `settings.env` wird nicht gefunden
- MySQL oder MariaDB läuft nicht
- `bachelordb` wurde nicht importiert
- `changes_db` wurde nicht angelegt
- falsche Zugangsdaten in `settings.env`

### Frontend erreicht das Backend nicht

Mögliche Ursachen:

- falsche `apiURl` in `environment.json`
- falscher Redirect-Port
- Backend läuft nicht auf Port `8000`

### `pip install -r requirements.txt` schlägt fehl

Mögliche Ursachen:

- Python-Version passt nicht
- Encoding-Problem in `requirements.txt`
- virtuelle Umgebung wurde nicht korrekt aktiviert

### Mail-Handler funktioniert nicht

Mögliche Ursachen:

- `office.env` ist nicht befüllt
- falsche Microsoft-365-Zugangsdaten
- App-Registrierung in Azure / Entra fehlt
- `MEDIA_PUBLIC_BASE` zeigt auf eine falsche URL

---

## 14. Empfehlung für PyCharm

Für das Backend kann in PyCharm eine Run Configuration angelegt werden.

### Empfohlene Einstellungen

- **Module name:** `uvicorn`
- **Parameters:**  
  `main:app --host 127.0.0.1 --port 8000 --reload`
- **Working directory:**  
  `.../bachelor-thesis-itsm-platform/Backend`

So wird das Backend direkt korrekt aus PyCharm gestartet.

---

## 15. Zusammenfassung

Für das lokale Setup unter Windows in PyCharm ist die Reihenfolge wie folgt:

1. Datenbanken `bachelordb` und `changes_db` anlegen
2. SQL-Dump nach `bachelordb` importieren
3. Python-Venv im Ordner `Backend` anlegen
4. Backend-Abhängigkeiten installieren
5. `settings.env` anpassen
6. Backend starten
7. `environment.json` prüfen
8. Frontend mit Chrome auf Port `58726` starten
9. Optional `Backend/Mail_Handler/office.env` für O365 konfigurieren

Damit sollte das Projekt lokal lauffähig sein.

