# Enigma Docker Deploy


## 1. Projekt als ZIP laden und entpacken

Repository:
`https://github.com/FFeulner/bachelor-thesis-itsm-platform/tree/main`

1. Auf GitHub: `Code` -> `Download ZIP`
2. ZIP lokal entpacken
3. In den entpackten Ordner wechseln (z. B. `bachelor-thesis-itsm-platform-main`)

## 2. Voraussetzungen

- Docker Desktop (inkl. Docker Compose v2)

## 3. Deploy starten

Im Projektordner ausfuehren:

```bash
docker compose up --build -d
```

Hinweis: Beim ersten Start werden DB-Struktur und Testdaten aus
`Database/bachelor-thesis-itsm-platform.sql` importiert. Das kann einige Minuten dauern.

## 4. Aufruf im Browser

- Frontend: `http://localhost:58726`
- Backend: `http://localhost:8000`
- Healthcheck: `http://localhost:8000/livez`

## 5. Nützliche Befehle

Logs:

```bash
docker compose logs -f
```

Stoppen:

```bash
docker compose down
```

Komplett resetten (inkl. Datenbank-Volumes):

```bash
docker compose down -v
```
