export const CYBORG_CHARACTER_PREFS = new Set([
  'silicon_gender',
  'silicon_flavor_text',
  'silicon_flavor_text_nsfw',
  'headshot_silicon',
  'headshot_silicon_nsfw',
  'ooc_notes_silicon',
  'custom_species_silicon',
  'custom_species_lore_silicon',
  'silicon_penis_sprite',
  'silicon_sheath_sprite',
  'silicon_testicles_sprite',
  'silicon_vagina_sprite',
  'silicon_breasts_sprite',
]);

export function filterOutCyborgPrefs<T extends Record<string, unknown>>(prefs: T): T {
  return Object.fromEntries(
    Object.entries(prefs).filter(([key]) => !CYBORG_CHARACTER_PREFS.has(key)),
  ) as T;
}
