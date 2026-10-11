# -*- coding: # -*- coding: utf-8 -*-
"""
Event handler for sexual activity.
Calls the oviparity hook when appropriate.
"""

from __future__ import annotations

import asyncio
from src.quirks.oviparity import on_insemination

async def handle_sexual_activity(event):
    """
    Called when a sexual act occurs.
    ``event`` is a dict containing at least:
        - ``type``: one of ``'oral'``, ``'vaginal'`, ``'anal'``
        - ``participants``: list of Character objects
    """
    # Determine which participant has the oviparity quirk.
    for participant in event.get("participants", []):
        if participant.has_quirk("oviparity"):
            # Pass the specific insemination type to the quirk logic.
            await on_insemination(participant, event["type"])
