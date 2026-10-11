# -*- coding: utf-8 -*-
"""
Oviparity Quirk Implementation
Handles egg acquisition from sexual acts and egg laying mechanics.
"""

from __future__ import annotations

import asyncio
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from src.character import Character

# --------------------------------------------------------------------------- #
# Configuration constants (can be tweaked via settings or admin commands)
# --------------------------------------------------------------------------- #
# Base number of eggs received per successful insemination event
BASE_EGGS_PER_INSEMINATION = 1

# Minimum time (in seconds) required to lay a single egg
LAY_TIME_PER_EGG = 2  # Reduced from 10 seconds

# Cool‑down after laying an egg (seconds). Set to 0 for instant bulk laying.
POST_LAY_COOLDOWN = 0

# --------------------------------------------------------------------------- #
# Helper functions
# --------------------------------------------------------------------------- #
def _calculate_egg_gain(character: Character, insemination_type: str) -> int:
    """
    Calculate how many eggs the character should receive based on their
    pregnancy settings and the type of insemination that just occurred.

    Parameters
    ----------
    character: Character
        The character receiving the eggs.
    insemination_type: str
        One of ``'oral'``, ``'vaginal'``, ``'anal'`` indicating the source.

    Returns
    -------
    int
        Number of eggs to add (minimum 0).
    """
    # Retrieve the character's pregnancy settings.  If a setting is missing,
    # fall back to a sensible default (no extra eggs).
    settings = character.pregnancy_settings

    # Determine if this insemination type is enabled for egg gain.
    enabled_key = f"{insemination_type}_insemination"
    if not settings.get(enabled_key, False):
        return 0

    # ``chance`` is a percentage (0‑100) that scales the amount of eggs.
    # For example, a chance of 50 means the character receives half the base eggs.
    chance = settings.get("chance", 100)  # default 100 %
    try:
        chance = float(chance)
    except (TypeError, ValueError):
        chance = 100.0

    # Compute final egg count, ensuring we always round down to an integer.
    eggs = int(BASE_EGGS_PER_INSEMINATION * (chance / 100.0))
    return max(eggs, 0)


async def _lay_egg(character: Character) -> None:
    """
    Perform the actual egg‑laying animation and state update for a single egg.
    This respects the new ``LAY_TIME_PER_EGG`` and ``POST_LAY_COOLDOWN`` values.
    """
    # Simulate the time it takes to lay an egg.
    await asyncio.sleep(LAY_TIME_PER_EGG)

    # Remove one egg from the inventory.
    character.inventory.remove_item("egg", 1)

    # Trigger any side‑effects (e.g., notifications, achievements).
    await character.notify("You have laid an egg.")

    # Apply post‑lay cooldown if configured.
    if POST_LAY_COOLDOWN > 0:
        await asyncio.sleep(POST_LAY_COOLDOWN)


# --------------------------------------------------------------------------- #
# Public API
# --------------------------------------------------------------------------- #
async def on_insemination(character: Character, insemination_type: str) -> None:
    """
    Hook called by the core engine whenever the character receives an
    insemination event (oral, vaginal, anal).

    Parameters
    ----------
    character: Character
        The character that is being inseminated.
    insemination_type: str
        One of ``'oral'``, ``'vaginal'``, ``'anal'``.
    """
    eggs_to_add = _calculate_egg_gain(character, insemination_type)
    if eggs_to_add > 0:
        character.inventory.add_item("egg", eggs_to_add)
        await character.notify(f"You feel {eggs_to_add} new egg{'s' if eggs_to_add != 1 else ''} forming inside you.")


async def lay_all_eggs(character: Character) -> None:
    """
    Bulk‑lay all eggs currently stored in the character's inventory.
    The total time taken is ``LAY_TIME_PER_EGG`` multiplied by the number of
    eggs, but there is no per‑egg cooldown, making the process much faster
    than the previous implementation.
    """
    egg_count = character.inventory.get_quantity("egg")
    if egg_count == 0:
        await character.notify("You have no eggs to lay.")
        return

    await character.notify(f"You begin laying a clutch of {egg_count} eggs...")

    # Total time = LAY_TIME_PER_EGG * egg_count (no extra cooldown)
    await asyncio.sleep(LAY_TIME_PER_EGG * egg_count)

    # Remove all eggs at once.
    character.inventory.remove_item("egg", egg_count)

    await character.notify(f"You have successfully laid {egg_count} egg{'s' if egg_count != 1 else ''}.")


# Backwards compatibility: keep the old single‑egg command but route it through the new logic.
async def lay_egg(character: Character) -> None:
    """
    Legacy command kept for compatibility. Calls the new single‑egg routine.
    """
    await _lay_egg(character)
