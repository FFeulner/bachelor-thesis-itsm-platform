# Mail_Handler/ticket_utils.py

import logging
import random
import re
import string
from datetime import datetime
from typing import List, Optional

from sqlalchemy.orm import Session

from Mail_Handler.models import Vorgang

log = logging.getLogger(__name__)

TICKET_RX = re.compile(r"\bTCK-\d{8}-[A-Z0-9]{8}\b", re.I)


def find_ticket_tag(
    subject: Optional[str],
    html: Optional[str],
    categories: Optional[List[str]],
) -> Optional[str]:
    """
    Sucht einen Ticket-Tag im Format TCK-YYYYMMDD-XXXXXXXX in
    Betreff, Body (HTML) oder Kategorien.
    """
    m = TICKET_RX.search(subject or "")
    if m:
        return m.group(0).upper()

    m = TICKET_RX.search(html or "")
    if m:
        return m.group(0).upper()

    if categories:
        for c in categories:
            m = TICKET_RX.search(c or "")
            if m:
                return m.group(0).upper()

    return None


def generate_ticket_tag(session: Session) -> str:
    """
    Erzeugt einen eindeutigen Ticket-Tag im Format:
    TCK-YYYYMMDD-XXXXXXXX (X = A-Z, 0-9)
    und prüft gegen bestehende Vorgänge.
    """
    date_part = datetime.utcnow().strftime("%Y%m%d")
    alphabet = string.ascii_uppercase + string.digits

    for _ in range(20):
        suffix = "".join(random.choice(alphabet) for _ in range(8))
        tag = f"TCK-{date_part}-{suffix}"
        exists = session.query(Vorgang).filter(Vorgang.ticket_tag == tag).first()
        if not exists:
            return tag

    raise RuntimeError(
        "Konnte nach mehreren Versuchen keinen eindeutigen Ticket-Tag erzeugen."
    )


def get_vorgang_by_ticket_tag(
    session: Session,
    tag: str,
) -> Optional[Vorgang]:
    if not tag:
        return None
    return session.query(Vorgang).filter(Vorgang.ticket_tag == tag).first()
