# generic_crud/routes.py
import re
from collections import defaultdict
from uuid import uuid4, UUID

from fastapi import APIRouter, HTTPException, Depends, Query, Response
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
from typing import Type, Any, List, Optional, Annotated, Union, Dict
from sqlalchemy import (
    String, Text, or_, select, insert, and_, inspect, func, text,
    Boolean, Integer, Float, DateTime, Date
)
from pydantic import create_model, BeforeValidator
from datetime import datetime
import json
import logging

from generic_crud.schemas import create_pydantic_model, map_column_type
from core.main_db import SessionLocal
from auth.token import get_current_user
from auth.roles import require_roles
from utils.change_tracker import write_change_entry
from deletions.models import DeletionQueue

from fastapi.encoders import jsonable_encoder

logger = logging.getLogger("crud")
audit = logging.getLogger("audit")

# Feldnamen nur als einfache Identifikatoren zulassen (kein SQL/Whitespace/Sonderzeichen)
FIELD_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")

# DoS-Bremsen für Filterlisten
MAX_VALUES_PER_FIELD = 50
MAX_VALUE_LENGTH = 256  # einzelne Filterwerte werden hart gekappt


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def _should_log_get_response() -> bool:
    import os
    v = os.getenv("CRUD_RESPONSE_LOG", "").strip().lower()
    if v in {"1", "true", "t", "yes", "y", "on"}:
        return True
    return logger.isEnabledFor(logging.INFO)

def _log_get_response(tag: str, data, *, max_items: int = 25, max_chars: int = 20_000) -> None:
    if not _should_log_get_response():
        return
    try:
        encoded = jsonable_encoder(data)
        if isinstance(encoded, list) and len(encoded) > max_items:
            encoded = {"_truncated": True, "_total": len(encoded), "_shown": max_items, "items": encoded[:max_items]}
        txt = json.dumps(encoded, ensure_ascii=False, default=str)
        if len(txt) > max_chars:
            txt = txt[:max_chars] + "…(truncated)"
        logger.info("GET_RESPONSE %s %s", tag, txt)
    except Exception as e:
        logger.warning("GET_RESPONSE %s (log failed): %s", tag, e)

# --- Helper für optionale Update-Validierung --------------------
def empty_to_none(v):

    if isinstance(v, str):
        s = v.strip()
        if s == "" or s.lower() in {"null", "none"}:
            return None
    return v


def create_crud_router(
    orm_cls: Type[Any],
    prefix: str | None = None,
    tags: List[str] | None = None,
    *,
    # Soft-Update-Strategie:
    # - "convert_empty" (Default): "" -> None, Typen bleiben erhalten
    # - "loose": akzeptiert alles (Optional[Any])
    # - "strict": ursprüngliches Verhalten
    soft_update_strategy: str = "convert_empty",
) -> APIRouter:

    router = APIRouter(
        prefix=prefix or f"/{orm_cls.__table__.name}",
        tags=tags or [orm_cls.__table__.name],
        dependencies=[Depends(require_roles("Enigma_User"))],
    )

    table = orm_cls.__table__
    pk_column = next((col for col in table.columns if col.primary_key), None)
    if pk_column is None:
        raise RuntimeError(f"Tabelle {table.name} hat keinen Primärschlüssel!")
    pk_python_type, _ = map_column_type(pk_column)
    pk_name = pk_column.name

    ResponseModel = create_pydantic_model(orm_cls, name=f"{orm_cls.__name__}Read", include_primary_key=True)
    CreateModel = create_pydantic_model(orm_cls, name=f"{orm_cls.__name__}Create", include_primary_key=False)

    # --- UpdateModel, mit optionaler Weichheit -------------------
    UpdateFields: dict = {}

    if soft_update_strategy not in {"convert_empty", "loose", "strict"}:
        raise ValueError("soft_update_strategy muss 'convert_empty', 'loose' oder 'strict' sein")

    for col in table.columns:
        if col.name == pk_name:
            continue

        if soft_update_strategy == "loose":
            # maximal tolerant: Optional[Any]
            UpdateFields[col.name] = (Optional[Any], None)

        elif soft_update_strategy == "convert_empty":
            # "" -> None VOR Typprüfung
            py_type, _default = map_column_type(col)
            FieldType = Annotated[Optional[py_type], BeforeValidator(empty_to_none)]
            UpdateFields[col.name] = (FieldType, None)

        else:  # "strict"
            py_type, _default = map_column_type(col)
            UpdateFields[col.name] = (Optional[py_type], None)

    UpdateModel = create_model(f"{orm_cls.__name__}Update", **UpdateFields)

    def _parse_bool(s: str) -> bool:
        s2 = s.strip().lower()
        if s2 in {"1", "true", "t", "yes", "y", "ja"}:
            return True
        if s2 in {"0", "false", "f", "no", "n", "nein"}:
            return False
        raise ValueError(f"Ungültiger Bool-Wert: {s!r}")

    def _cast_value_for_column(col, raw: str):

        t = col.type
        s = "" if raw is None else str(raw).strip()
        # UUID-Heuristik: Spaltenname ...RecID oder Typ enthält "uuid"
        if col.name.lower().endswith("recid") or "uuid" in str(t).lower():
            try:
                return str(UUID(s))
            except Exception as e:
                raise ValueError(f"Ungültige UUID für {col.name}: {raw!r}") from e
        try:
            if isinstance(t, Boolean):
                return _parse_bool(s)
            if isinstance(t, Integer):
                return int(s)
            if isinstance(t, Float):
                return float(s)
            if isinstance(t, DateTime):
                return datetime.fromisoformat(s)
            if isinstance(t, Date):
                return datetime.fromisoformat(s).date()
        except Exception as e:
            raise ValueError(f"Ungültiger Wert für {col.name}: {raw!r}") from e
        return s  # Default: String

    def _mk_fulltext_query(s: str) -> str:
        """ 'foo bar' -> '+foo* +bar*' (BOOLEAN MODE, Prefix-Matching, AND-verkettet) """
        tokens = re.findall(r"\w+", s)
        if not tokens:
            return ""
        return " ".join(f"+{t}*" for t in tokens)

    def _is_blank(x) -> bool:
        """True, wenn None, leerer String oder das Literal 'null' (case-insensitive)."""
        return x is None or (isinstance(x, str) and (x.strip() == "" or x.strip().lower() == "null"))

    def _to_int_or_default(value: Union[int, str, None], default: int) -> int:

        if _is_blank(value):
            return default
        try:
            return int(value)  # akzeptiert auch bereits int
        except (ValueError, TypeError):
            return default

    @router.get("/", response_model=List[ResponseModel])
    def read_all(
            response: Response,
            firmaRecID: Optional[str] = Query(None, description="ID der Firma (leer erlaubt)"),
            search: Optional[str] = Query(None, description="Suchbegriff (leer erlaubt)"),
            filter: Optional[List[str]] = Query(
                None,
                description="Mehrfach erlaubt. Syntax: feld:wert (z.B. Benutzer:Florian). Negation je Feld mit 'feld!:wert'"
            ),
            filter_contains: Optional[Union[bool, str]] = Query(
                False,
                description="Bei Textspalten: true = enthält (ILIKE %%wert%%), false = Gleichheit (case-insensitive)"
            ),
            # NEU: Felder/Spalten-Projektion
            fields: Optional[List[str]] = Query(
                None,
                description="Mehrfach erlaubt oder CSV pro Eintrag. Gibt nur diese Spalten zurück (lenient, allowlist 'read')."
            ),

            limit: Optional[Union[int, str]] = Query(None, description="Max. Einträge (leer/'null' werden ignoriert)"),
            offset: Optional[Union[int, str]] = Query(None, description="Offset (leer/'null' werden ignoriert)"),
            order_by: Optional[str] = Query(None),
            order_dir: Optional[str] = Query("asc"),
            search_mode: Optional[str] = Query("ilike"),
            db: Session = Depends(get_db),
    ):
        table = inspect(orm_cls).local_table
        where_clauses = []

        allowed = getattr(orm_cls, "__allowed__", {})
        readable = set(allowed.get("read", set()))
        sortable = set(allowed.get("sort", set()))

        # --- Normalisierung leerer Parameter ---
        firmaRecID = None if _is_blank(firmaRecID) else firmaRecID.strip()
        search = None if _is_blank(search) else search.strip()
        order_by = None if _is_blank(order_by) else order_by.strip()
        order_dir = (order_dir or "asc").strip() or "asc"
        search_mode = (search_mode or "ilike").strip() or "ilike"
        filter_contains = str(filter_contains).lower() in {"1", "true", "t", "yes", "y"} if isinstance(filter_contains,
                                                                                                       str) else bool(
            filter_contains)

        # Leere/blanke Filtereinträge verwerfen (ignorieren statt 4xx)
        filter = [f for f in (filter or []) if not _is_blank(f)]

        # --- Lenient Defaults für limit/offset ---
        LIMIT_DEFAULT = 1000
        OFFSET_DEFAULT = 0
        limit = _to_int_or_default(limit, LIMIT_DEFAULT)
        offset = _to_int_or_default(offset, OFFSET_DEFAULT)

        # --- Firmen-Filter ---
        if firmaRecID:
            where_clauses.append(getattr(orm_cls, "Firma_RecID") == firmaRecID)

        # --- valid columns (einmalig, auch für fields) ---
        valid_cols = {c.name: getattr(orm_cls, c.name) for c in table.columns}

        # --- Feld-Filter (robust & „lenient“) + Negation per Feldname (feld!:wert) ---
        if filter:
            from collections import defaultdict
            field_values = defaultdict(lambda: {"values": [], "neg": False})

            for raw in filter:
                if ":" not in raw:
                    continue
                col_name, value = raw.split(":", 1)
                col_name = (col_name or "").strip()
                value = (value or "").strip()
                if _is_blank(col_name) or _is_blank(value):
                    continue

                # Negation per Feld: "Status!:offen"
                is_neg = col_name.endswith("!")
                if is_neg:
                    col_name = col_name[:-1].strip()

                if not FIELD_RE.match(col_name):
                    continue
                if col_name not in valid_cols:
                    continue
                if readable and col_name not in readable:
                    continue

                parts = [x.strip()[:MAX_VALUE_LENGTH] for x in value.split(",") if not _is_blank(x)]
                if not parts:
                    continue
                if len(parts) > MAX_VALUES_PER_FIELD:
                    parts = parts[:MAX_VALUES_PER_FIELD]

                field_values[col_name]["values"].extend(parts)
                field_values[col_name]["neg"] = field_values[col_name]["neg"] or is_neg

            for col_name, payload in field_values.items():
                col = valid_cols[col_name]
                values = payload["values"]
                is_neg = payload["neg"]

                if isinstance(col.type, (String, Text)):
                    if not is_neg:
                        ors = [col.ilike(f"%{v}%") for v in values] if filter_contains else [col.ilike(v) for v in
                                                                                             values]
                        if ors:
                            where_clauses.append(or_(*ors))
                    else:
                        if filter_contains:
                            neg_conds = [~col.ilike(f"%{v}%") for v in values]
                        else:
                            neg_conds = [~col.ilike(v) for v in values]
                        if neg_conds:
                            where_clauses.append(or_(col.is_(None), and_(*neg_conds)))
                else:
                    if not is_neg:
                        ors = []
                        for v in values:
                            try:
                                ors.append(col == _cast_value_for_column(col, v))
                            except ValueError:
                                continue
                        if ors:
                            where_clauses.append(or_(*ors))
                    else:
                        casted = []
                        for v in values:
                            try:
                                casted.append(_cast_value_for_column(col, v))
                            except ValueError:
                                continue
                        if casted:
                            where_clauses.append(or_(col.is_(None), ~col.in_(casted)))

        # --- Suche ---
        string_cols = [c.name for c in table.columns if isinstance(c.type, (String, Text))]
        if search:
            mode = (search_mode or "ilike").lower()
            if mode == "fulltext" and string_cols:
                try:
                    cols_sql = ", ".join(f"{col}" for col in string_cols)
                    match_sql = f"MATCH({cols_sql}) AGAINST (:q IN BOOLEAN MODE)"
                    q = _mk_fulltext_query(search)
                    if q:
                        where_clauses.append(text(match_sql).bindparams(q=q))
                        response.headers["X-Search-Mode"] = "fulltext"
                        logger.info("FULLTEXT-Suche in %s nach %r über %d Spalten", table.name, search,
                                    len(string_cols))
                except Exception as e:
                    logger.warning("FULLTEXT fehlgeschlagen in %s, Fallback auf ILIKE: %s", table.name, e)
                    pattern = f"%{search}%"
                    where_clauses.append(or_(*[getattr(orm_cls, c).ilike(pattern) for c in string_cols]))
                    response.headers["X-Search-Mode"] = "ilike"
            else:
                pattern = f"%{search}%"
                where_clauses.append(or_(*[getattr(orm_cls, c).ilike(pattern) for c in string_cols]))
                response.headers["X-Search-Mode"] = "ilike"

        # --- NEU: fields normalisieren + allowlisten ---
        selected_names: List[str] = []
        if fields:
            raw_fields: List[str] = []
            for f in fields:
                if _is_blank(f):
                    continue
                # erlaubt CSV in einem Param
                raw_fields.extend([x.strip() for x in f.split(",") if not _is_blank(x)])

            for name in raw_fields:
                if name in valid_cols and (not readable or name in readable):
                    selected_names.append(name)

            # dedupe, order preserving
            seen = set()
            selected_names = [n for n in selected_names if not (n in seen or seen.add(n))]

        selected_cols = [valid_cols[n] for n in selected_names] if selected_names else None

        # --- Statement aufbauen ---
        if selected_cols:
            stmt = select(*selected_cols)
            response.headers["X-Fields"] = ",".join(selected_names)
        else:
            stmt = select(orm_cls)

        if where_clauses:
            stmt = stmt.where(and_(*where_clauses))

        # --- Sortierung ---
        order_dir_norm = (order_dir or "asc").lower()
        if order_dir_norm not in {"asc", "desc"}:
            order_dir_norm = "asc"
        if order_by and order_by in table.c.keys():
            if sortable and order_by not in sortable:
                logger.warning("order_by %r nicht erlaubt – wird ignoriert", order_by)
            else:
                try:
                    col = getattr(orm_cls, order_by)
                    stmt = stmt.order_by(col.desc() if order_dir_norm == "desc" else col.asc())
                except Exception as e:
                    logger.warning("Sortierung ignoriert (%s): %s", order_by, e)
        else:
            pk_cols = inspect(orm_cls).primary_key
            if pk_cols:
                stmt = stmt.order_by(*pk_cols)

        # --- Pagination ---
        stmt = stmt.limit(limit).offset(offset)

        # --- Total-Count ---
        count_stmt = select(func.count()).select_from(orm_cls)
        if where_clauses:
            count_stmt = count_stmt.where(and_(*where_clauses))
        total = db.execute(count_stmt).scalar() or 0

        # --- Ausführen ---
        if selected_cols:
            rows = db.execute(stmt).all()
            items = [dict(zip(selected_names, row)) for row in rows]
        else:
            items = db.execute(stmt).scalars().all()

        # --- Response-Header ---
        response.headers["X-Total-Count"] = str(total)
        response.headers["X-Limit"] = str(limit)
        response.headers["X-Offset"] = str(offset)
        if order_by:
            response.headers["X-Order-By"] = order_by
            response.headers["X-Order-Dir"] = order_dir_norm

        # WICHTIG: fields aktiv => ResponseModel umgehen
        if selected_cols:
            jr = JSONResponse(content=items)
            jr.headers.update(response.headers)
            return jr

        _log_get_response(f"{table.name} read_all", items)
        return items

    @router.get("/{item_id}", response_model=ResponseModel)
    def read_one(item_id: pk_python_type, db: Session = Depends(get_db)):
        logger.error("READ_ONE HIT %s %s", orm_cls.__table__.name, item_id)
        stmt = select(orm_cls).where(getattr(orm_cls, pk_name) == item_id)
        item = db.execute(stmt).scalar_one_or_none()
        logger.error("READ_ONE DB RESULT: %r", item)
        if not item:
            raise HTTPException(status_code=404, detail=f"{orm_cls.__name__} mit ID {item_id} nicht gefunden.")

        encoded = {
            col.name: getattr(item, col.name)
            for col in item.__table__.columns
        }
        logger.info("GET_RESPONSE vorgang read_one %s", encoded)


        return item



    @router.post("/", response_model=ResponseModel, status_code=201)
    def create_item(payload: CreateModel, db: Session = Depends(get_db), current_user=Depends(get_current_user)):

        obj_data = payload.dict(exclude_unset=True)

        # PK ermitteln
        pk_cols = inspect(orm_cls).primary_key
        if not pk_cols:
            raise HTTPException(status_code=500, detail=f"Tabelle {table.name} hat keinen Primärschlüssel (Mapping).")
        if len(pk_cols) > 1:
            raise HTTPException(status_code=400,
                                detail=f"Create für Tabelle {table.name} mit Composite-PK nicht unterstützt.")

        pk_col = pk_cols[0]
        pk_name_local = pk_col.name
        coltype_str = str(pk_col.type).lower()

        # Wurde PK explizit mitgeschickt?
        provided_pk = obj_data.get(pk_name_local)

        # Heuristiken zur PK-Generierung (kompatibel zur „alten“ Variante)
        def _looks_like_uuid_pk() -> bool:
            # 1) Spaltenname RecID → in vielen deiner Tabellen UUID-String
            if pk_name_local.lower().endswith("recid"):
                return True
            # 2) String-/Text-Spalte generell
            from sqlalchemy import String, Text
            if isinstance(pk_col.type, (String, Text)):
                return True
            # 3) Typtext enthält varchar/char(36)
            if "char(36)" in coltype_str or "varchar(36)" in coltype_str:
                return True
            return False

        def _db_generates_pk() -> bool:
            # INT mit AUTO_INCREMENT oder server_default darf leer bleiben
            from sqlalchemy import Integer
            autoinc = getattr(pk_col, "autoincrement", False)
            return isinstance(pk_col.type, Integer) and autoinc in (True, "auto") or pk_col.server_default is not None

        # Falls kein PK geliefert: automatisch setzen oder DB generieren lassen
        if not provided_pk:
            if _looks_like_uuid_pk():
                obj_data[pk_name_local] = str(uuid4())
            elif _db_generates_pk():
                pass  # DB generiert (INT AUTO_INCREMENT / DEFAULT)
            else:
                raise HTTPException(
                    status_code=400,
                    detail=(
                        f"Primärschlüssel '{pk_name_local}' wird weder automatisch generiert "
                        f"noch ist AUTO_INCREMENT/DEFAULT konfiguriert. "
                        f"Bitte PK im Payload setzen oder DB-Spalte entsprechend anpassen."
                    ),
                )
        else:
            # Wenn „UUID-ähnlich“, valide normalisieren
            if _looks_like_uuid_pk():
                try:
                    obj_data[pk_name_local] = str(UUID(str(provided_pk)))
                except Exception:
                    raise HTTPException(status_code=400, detail=f"Ungültiger Primärschlüssel-Wert für {pk_name_local}.")

        # Insert
        new_obj = orm_cls(**obj_data)
        db.add(new_obj)
        try:
            db.commit()
            db.refresh(new_obj)
        except Exception as e:
            db.rollback()
            msg = str(e.__cause__ or e)
            # Häufige Ursache: PK ohne Wert + kein AUTO_INCREMENT
            if "NULL identity key" in msg or "may not store NULL" in msg:
                raise HTTPException(
                    status_code=400,
                    detail=(
                        f"Insert fehlgeschlagen: Kein gültiger PK-Wert für '{pk_name_local}'. "
                        f"Entweder PK im Payload setzen oder AUTO_INCREMENT/DEFAULT in der DB konfigurieren."
                    ),
                )
            raise HTTPException(status_code=400, detail=f"Insert fehlgeschlagen: {msg}")

        logger.info(
            f"{orm_cls.__table__.name}: Neuer Eintrag erstellt: {pk_name_local}={getattr(new_obj, pk_name_local)}")
        audit.info(
            f"CREATE {orm_cls.__table__.name}: ID={getattr(new_obj, pk_name_local)} user={current_user.get('sub', '?')}")
        return new_obj

    @router.put("/{item_id}", response_model=ResponseModel)
    def update_item(
        item_id: pk_python_type,
        payload: UpdateModel,  # echtes Modell von oben
        db: Session = Depends(get_db),
        current_user=Depends(get_current_user),
    ):

        from logging import getLogger
        logger = getLogger("crud")

        logger.info(
            "UPDATE %s ID=%s RAW_PAYLOAD=%s",
            orm_cls.__table__.name,
            item_id,
            payload.model_dump(exclude_unset=False, exclude_none=False),
        )

        # Helper: welche Werte gelten als "leer" und werden ignoriert
        def _is_empty(v):
            # Hier geht es nur noch um "leere" Container.
            if isinstance(v, (list, tuple, set, dict)) and len(v) == 0:
                return True
            return False

        # Wichtig:
        # - exclude_unset=True -> nur Felder, die FlutterFlow wirklich geschickt hat
        # - exclude_none=True  -> alles, was durch empty_to_none zu None geworden ist, fliegt raus
        incoming = payload.dict(exclude_unset=True, exclude_none=True)

        valid_columns = {c.name for c in table.columns}

        # Nur echte Spalten und keine leeren Container
        filtered = {
            k: v
            for k, v in incoming.items()
            if k in valid_columns and not _is_empty(v)
        }

        if not filtered:
            raise HTTPException(status_code=400, detail="Keine nicht-leeren Felder zum Aktualisieren übergeben.")

        db_obj = db.query(orm_cls).filter(getattr(orm_cls, pk_name) == item_id).first()
        if not db_obj:
            raise HTTPException(status_code=404, detail=f"{orm_cls.__name__} mit ID {item_id} nicht gefunden.")

        # Snapshot alt
        old_data = {col.name: getattr(db_obj, col.name) for col in table.columns}

        # Nur echte Änderungen setzen
        changed_data = {}
        for field, new_value in filtered.items():
            if getattr(db_obj, field, object()) != new_value:
                setattr(db_obj, field, new_value)
                changed_data[field] = new_value

        if not changed_data:
            logger.info(f"{orm_cls.__table__.name}: Eintrag {item_id} – keine Änderungen erkannt.")
            return db_obj  # nichts zu tun

        db.commit()
        db.refresh(db_obj)

        write_change_entry(
            table_name=orm_cls.__table__.name,
            record_id=item_id,
            action="update",
            old_data=old_data,
            new_data=changed_data,  # nur tatsächliche Änderungen loggen
            user_sub=current_user.get("sub", "unknown"),
            user_name=current_user.get("name", "unknown"),
        )

        logger.info(f"{orm_cls.__table__.name}: Eintrag {item_id} aktualisiert.")
        audit.info(f"UPDATE {orm_cls.__table__.name}: ID={item_id} user={current_user.get('sub', '?')}")
        return db_obj

    # --- Markieren (statt hart löschen) ---
    class MarkDeletePayload(create_model("MarkDeletePayload", grund=(str | None, None))):
        ...

    @router.post("/{item_id}/mark-delete", status_code=201)
    def mark_for_deletion(
        item_id: pk_python_type,
        payload: MarkDeletePayload,
        db: Session = Depends(get_db),
        current_user=Depends(get_current_user),
    ):
        obj = db.execute(select(orm_cls).where(getattr(orm_cls, pk_name) == item_id)).scalar_one_or_none()

        if not obj:
            raise HTTPException(status_code=404, detail=f"{orm_cls.__name__} mit ID {item_id} nicht gefunden.")

        already = db.execute(
            select(DeletionQueue.c.id).where(
                and_(
                    DeletionQueue.c.tabellenname == table.name,
                    DeletionQueue.c.datensatz_id == str(item_id),
                    DeletionQueue.c.status == "offen",
                )
            )
        ).first()
        if already:
            raise HTTPException(status_code=409, detail="Eintrag ist bereits zum Löschen markiert.")

        snapshot = {col.name: getattr(obj, col.name) for col in table.columns}
        db.execute(
            insert(DeletionQueue).values(
                tabellenname=table.name,
                datensatz_id=str(item_id),
                grund=payload.grund,
                snapshot_json=json.dumps(snapshot, default=str),
                status="offen",
                angefordert_von=f"{current_user.get('name', 'unknown')}",
                angefordert_am=datetime.utcnow(),
            )
        )
        db.commit()
        return {"status": "offen", "tabellenname": table.name, "datensatz_id": str(item_id)}

    return router
