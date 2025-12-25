/// Ниже этого значения силы привода быть не может.
/// Даже при 1 урона он провибрирует с этой силой.
#define PLUG13_MASOCHISM_STRENGTH_MIN  PLUG13_STRENGTH_LOW

/// Выше этого значения силы привода быть не может.
/// При `PLUG13_MASOCHISM_STRENGTH_DAMAGE` и выше, будет именно эта сила.
#define PLUG13_MASOCHISM_STRENGTH_MAX  PLUG13_STRENGTH_MAX

/// Сколько урона должен получить игрок для ощущения
/// работы привода максимальной силы.
#define PLUG13_MASOCHISM_STRENGTH_DAMAGE 60

/// Ниже этого значения длительности привода быть не может.
/// Даже при 1 урона он будет работать именно столько.
#define PLUG13_MASOCHISM_DURATION_MIN  PLUG13_DURATION_TINY

/// Выше этого значения длительности привода быть не может.
/// При `PLUG13_MASOCHISM_DURATION_DAMAGE` и выше, будет эта длительность.
#define PLUG13_MASOCHISM_DURATION_MAX  PLUG13_DURATION_EXTRALONG

/// Сколько урона должен получить игрок для ощущения
/// работы привода максимальной длительности.
#define PLUG13_MASOCHISM_DURATION_DAMAGE 100

// При стандартном PLUG13_STRENGTH_MAX = 100%
// и стандартном PLUG13_DURATION_EXTRALONG = 5 секунд
// -  30 урона провибрируют на 50% в течение 1.5 сек
// -  60 урона провибрируют на 100% в течение 3 сек
// - 100 урона провибрируют на 100% в течение 5 сек

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
