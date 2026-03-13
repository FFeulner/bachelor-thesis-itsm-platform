# Datei: special_crud/mitarbeiterTeamRelation/routes.py
import json

from fastapi import APIRouter, Depends, HTTPException, Query, Request, Response
from sqlalchemy import select, exists, and_, literal
from sqlalchemy.orm import Session
import logging, time

from core.main_db import SessionLocal
from generic_crud.models import Base
from auth.roles import require_roles
from utils.change_tracker import write_change_entry

logger = logging.getLogger(__name__)

router = APIRouter(
    prefix="/api/teamMitarbeiterRelation",
    tags=["teamMitarbeiterRelation"],
    dependencies=[Depends(require_roles("admin"))],
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Automap
Mitarbeiter = Base.classes.mitarbeiter
Team        = Base.classes.team
JMT         = Base.classes.junction_mitarbeiter_team

# Rolle-Spaltenname robust ermitteln (mit/ohne Unterstrich)
ROLE_COL = getattr(JMT, "Rolle_RecID", None) or getattr(JMT, "RolleRecID", None)

@router.get("/{eid}")
def employee_team_partition(
    eid: str,
    filterTeam: str | None = Query(None, description="optional: Filter auf Team.Name"),
    db: Session = Depends(get_db),
    request: Request = ...,
):
    t0 = time.perf_counter()
    logger.debug("employee_team_partition called",
                 extra={"eid": eid, "filterTeam": filterTeam, "url": str(request.url)})

    # 404, wenn Mitarbeiter unbekannt
    if not db.get(Mitarbeiter, eid):
        logger.warning("Mitarbeiter nicht gefunden", extra={"eid": eid})
        raise HTTPException(status_code=404, detail="Mitarbeiter nicht gefunden")

    # --- Zugewiesene Teams inkl. Rolle (aus Junction)
    assigned_stmt = (
        select(
            Team.RecID.label("team_recid"),
            Team.Name.label("team_name"),
            Team.Rollenbeschreibung.label("team_rollenbeschreibung"),
            (ROLE_COL if ROLE_COL is not None else literal(None)).label("rolle_recid"),
        )
        .select_from(Team)
        .join(JMT, JMT.Team_RecID == Team.RecID)
        .where(JMT.Mitarbeiter_RecID == eid)
        .order_by(Team.Name)
    )
    if filterTeam:
        assigned_stmt = assigned_stmt.where(Team.Name.ilike(f"%{filterTeam}%"))

    assigned_rows = db.execute(assigned_stmt).all()
    logger.debug("assigned rows fetched", extra={"count": len(assigned_rows)})

    # Wichtig: Keys deckungsgleich mit FF-"team": RecID/Name/Rollenbeschreibung
    assigned = [
        {
            "team": {
                "RecID": r.team_recid,
                "Name": r.team_name,
                "Rollenbeschreibung": r.team_rollenbeschreibung,
            },
            "rolle_recid": r.rolle_recid,
        }
        for r in assigned_rows
    ]

    # --- Verfügbare Teams (NOT EXISTS auf Junction)
    sub = select(JMT.RecID).where(and_(JMT.Mitarbeiter_RecID == eid, JMT.Team_RecID == Team.RecID))
    available_stmt = (
        select(
            Team.RecID.label("recid"),
            Team.Name.label("name"),
            Team.Rollenbeschreibung.label("rollenbeschreibung"),
        )
        .select_from(Team)
        .where(~exists(sub))
        .order_by(Team.Name)
    )
    if filterTeam:
        available_stmt = available_stmt.where(Team.Name.ilike(f"%{filterTeam}%"))

    available_rows = db.execute(available_stmt).all()
    logger.debug("available rows fetched", extra={"count": len(available_rows)})

    # Ebenfalls mit RecID/Name/Rollenbeschreibung
    available = [
        {"RecID": r.recid, "Name": r.name, "Rollenbeschreibung": r.rollenbeschreibung}
        for r in available_rows
    ]

    dt_ms = round((time.perf_counter() - t0) * 1000, 2)
    logger.info("employee_team_partition ok",
                extra={"eid": eid, "assigned": len(assigned), "available": len(available), "ms": dt_ms})

    resp = {
        "employee_id": eid,
        "assigned": assigned,
        "available": available,
    }
    logger.debug(
        "employee_team_partition.response %s",
        json.dumps(resp, ensure_ascii=False, separators=(",", ":"))
    )
    return resp


@router.delete("/{team_id}/{mit_id}", status_code=204)
def admin_unassign_pair(
    team_id: str,
    mit_id: str,
    db: Session = Depends(get_db),
    admin = Depends(require_roles("admin")),
):
    logger.debug("admin_unassign_pair called", extra={"team_id": team_id, "mit_id": mit_id})

    jmt_obj = db.query(JMT).filter(
        JMT.Team_RecID == team_id,
        JMT.Mitarbeiter_RecID == mit_id
    ).first()

    if not jmt_obj:
        logger.warning("Zuordnung nicht gefunden", extra={"team_id": team_id, "mit_id": mit_id})
        raise HTTPException(404, detail="Zuordnung nicht gefunden")

    snapshot = {
        "RecID": jmt_obj.RecID,
        "Mitarbeiter_RecID": jmt_obj.Mitarbeiter_RecID,
        "Team_RecID": jmt_obj.Team_RecID,
        "Rolle_RecID": getattr(jmt_obj, "Rolle_RecID", None) if hasattr(jmt_obj, "Rolle_RecID")
                      else getattr(jmt_obj, "RolleRecID", None),
    }

    try:
        db.delete(jmt_obj)
        db.commit()
        logger.info("Zuordnung gelöscht", extra={"rec_id": snapshot["RecID"], "team_id": team_id, "mit_id": mit_id})
    except Exception:
        db.rollback()
        logger.error("Delete/Commit failed", exc_info=True, extra={"rec_id": snapshot["RecID"]})
        raise

    try:
        write_change_entry(
            table_name="junction_mitarbeiter_team",
            record_id=snapshot["RecID"],
            action="unlink",
            old_data=snapshot,
            new_data=None,
            user_sub=admin.get("sub", "unknown"),
            user_name=admin.get("name", "admin"),
        )
    except Exception:
        logger.error("write_change_entry failed", exc_info=True, extra={"rec_id": snapshot["RecID"]})

    return Response(status_code=204)
