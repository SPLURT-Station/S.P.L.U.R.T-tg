/// The minimum strength the device can operate at.
/// Even with 1 damage, it will vibrate at this strength.
#define PLUG13_MASOCHISM_STRENGTH_MIN  PLUG13_STRENGTH_LOW

/// The maximum strength the device can operate at.
/// At `PLUG13_MASOCHISM_STRENGTH_DAMAGE` and above, this strength will be used.
#define PLUG13_MASOCHISM_STRENGTH_MAX  PLUG13_STRENGTH_MAX

/// How much damage the player must receive to feel
/// the device operating at maximum strength.
#define PLUG13_MASOCHISM_STRENGTH_DAMAGE 60

/// The minimum duration the device can operate for.
/// Even with 1 damage, it will operate for this long.
#define PLUG13_MASOCHISM_DURATION_MIN  PLUG13_DURATION_TINY

/// The maximum duration the device can operate for.
/// At `PLUG13_MASOCHISM_DURATION_DAMAGE` and above, this duration will be used.
#define PLUG13_MASOCHISM_DURATION_MAX  PLUG13_DURATION_EXTRALONG

/// How much damage the player must receive to feel
/// the device operating at maximum duration.
#define PLUG13_MASOCHISM_DURATION_DAMAGE 100

// With standard PLUG13_STRENGTH_MAX = 100%
// and standard PLUG13_DURATION_EXTRALONG = 5 seconds
// -  30 damage will vibrate at 50% for 1.5 sec
// -  60 damage will vibrate at 100% for 3 sec
// - 100 damage will vibrate at 100% for 5 sec

#define PLUG13_MASOCHISM_BRUTE_MOD    1
#define PLUG13_MASOCHISM_BURN_MOD     1
#define PLUG13_MASOCHISM_TOX_MOD      0.4
#define PLUG13_MASOCHISM_OXY_MOD      0.5
#define PLUG13_MASOCHISM_STAMINA_MOD  0.3
#define PLUG13_MASOCHISM_BRAIN_MOD    0

#define PLUG13_MASOCHISM_STRENGTH_RANGE (PLUG13_MASOCHISM_STRENGTH_MAX - PLUG13_MASOCHISM_STRENGTH_MIN)
#define PLUG13_MASOCHISM_DURATION_RANGE (PLUG13_MASOCHISM_DURATION_MAX - PLUG13_MASOCHISM_DURATION_MIN)

/mob/living/carbon/proc/plug13_damage_vibration(damage, damagetype)
	if (!client || !client.plug13.is_connected)
		return

	var/new_damage = damage
	switch(damagetype)
		if (BRUTE)   new_damage *= PLUG13_MASOCHISM_BRUTE_MOD
		if (BURN)    new_damage *= PLUG13_MASOCHISM_BURN_MOD
		if (TOX)     new_damage *= PLUG13_MASOCHISM_TOX_MOD
		if (OXY)     new_damage *= PLUG13_MASOCHISM_OXY_MOD
		if (STAMINA) new_damage *= PLUG13_MASOCHISM_STAMINA_MOD
		if (BRAIN)   new_damage *= PLUG13_MASOCHISM_BRAIN_MOD

	if (!new_damage)
		return

	var/strength_modifier = min(new_damage / PLUG13_MASOCHISM_STRENGTH_DAMAGE, 1)
	var/strength = (PLUG13_MASOCHISM_STRENGTH_RANGE * strength_modifier) + PLUG13_MASOCHISM_STRENGTH_MIN

	var/duration_modifier = min(new_damage / PLUG13_MASOCHISM_DURATION_DAMAGE, 1)
	var/duration = (PLUG13_MASOCHISM_DURATION_RANGE * duration_modifier) + PLUG13_MASOCHISM_DURATION_MIN

	client.plug13.send_emote(PLUG13_EMOTE_MASOCHISM, strength, duration)

/mob/living/carbon/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, exposed_wound_bonus, sharpness, attack_direction, attacking_item, wound_clothing)
	. = ..()
	if (!.)
		return

	plug13_damage_vibration(damage, damagetype)

/obj/item/bodypart/receive_damage(brute, burn, blocked, updating_health, forced, required_bodytype, wound_bonus, exposed_wound_bonus, sharpness, attack_direction, damage_source, wound_clothing)

	var/brute_diff = brute_dam
	var/burn_diff = burn_dam

	. = ..()
	if (!.)
		return

	brute_diff -= brute_dam
	burn_diff -= burn_dam

	if (brute_diff > 0)
		owner.plug13_damage_vibration(brute_diff, BRUTE)
	if (burn_diff > 0)
		owner.plug13_damage_vibration(burn_diff, BURN)

#undef PLUG13_MASOCHISM_DURATION_RANGE
#undef PLUG13_MASOCHISM_DURATION_DAMAGE
#undef PLUG13_MASOCHISM_DURATION_MAX
#undef PLUG13_MASOCHISM_DURATION_MIN
#undef PLUG13_MASOCHISM_STRENGTH_RANGE
#undef PLUG13_MASOCHISM_STRENGTH_DAMAGE
#undef PLUG13_MASOCHISM_STRENGTH_MAX
#undef PLUG13_MASOCHISM_STRENGTH_MIN
