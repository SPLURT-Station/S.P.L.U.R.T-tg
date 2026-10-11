# -*- coding: utf-8 -*-
"""
Pregnancy Settings Module
Defines default pregnancy‑related settings for characters.
"""

from __future__ import annotations

from typing import Dict, Any

# --------------------------------------------------------------------------- #
# Default pregnancy settings
# --------------------------------------------------------------------------- #
DEFAULT_PREGNANCY_SETTINGS: Dict[str, Any] = {
    # Enable/disable egg gain from each insemination type.
    "oral_insemination": True,
    "vaginal_insemination": True,
    "anal_insemination": True,

    # Chance (percentage) that determines how many eggs are actually produced.
    # 100 means full egg production, 50 means half, etc.
    "chance": 100,

    # Additional visual settings (unchanged from original implementation)
    "visuals": {
        "pregnant": False,
        "stage": 0,
    },
}


class PregnancySettings:
    """
    Simple container for a character's pregnancy configuration.
    Allows easy read/write access while keeping a clear API.
    """

    def __init__(self, overrides: Dict[str, Any] | None = None):
        self._settings = DEFAULT_PREGNANCY_SETTINGS.copy()
        if overrides:
            self._settings.update(overrides)

    def get(self, key: str, default: Any = None) -> Any:
        return self._settings.get(key, default)

    def set(self, key: str, value: Any) -> None:
        self._settings[key] = value

    def as_dict(self) -> Dict[str, Any]:
        """Return a shallow copy suitable for serialization."""
        return self._settings.copy()


# Helper to expose settings directly on the Character instance.
def attach_to_character(character) -> None:
    """
    Attach a ``pregnancy_settings`` attribute to a ``Character`` instance.
    This is called during character creation.
    """
    if not hasattr(character, "pregnancy_settings"):
        character.pregnancy_settings = PregnancySettings().as_dict()
