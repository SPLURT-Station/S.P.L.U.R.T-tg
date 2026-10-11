# -*- coding: utf-8 -*-
"""
Command definitions for egg‑related actions.
"""

from __future__ import annotations

import asyncio

from src.quirks.oviparity import lay_egg, lay_all_eggs
from src.character import Character

async def cmd_lay_egg(ctx):
    """
    Legacy command: lay a single egg.
    """
    character = ctx.author
    await lay_egg(character)

async def cmd_lay_all(ctx):
    """
    New command: lay all eggs at once (bulk clutch).
    """
    character = ctx.author
    await lay_all_eggs(character)

# Register commands (the actual registration mechanism depends on the bot framework)
# Example for a generic command dispatcher:
def register_commands(dispatcher):
    dispatcher.register("layegg", cmd_lay_egg)
    dispatcher.register("layall", cmd_lay_all)
