/datum/interaction/lewd/knotting/knotfucking/knotride_pussy
	name = "Knotride (Vagina)"
	description = "Ride their knot with your pussy."
	user_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_VAGINA, CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_USER = ORGAN_SLOT_PENIS, CLIMAX_POSITION_TARGET = ORGAN_SLOT_VAGINA)
	message = list(
		"rides %TARGET%'s knot.",
		"forces %TARGET%'s knot into their pussy.",
		"pops %TARGET%'s knot in and out of their pussy.",
		"impales themself on %TARGET%'s cock."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 9
	target_pleasure = 9
	user_arousal = 12
	target_arousal = 12
	target_pain = 2

/datum/interaction/lewd/knotting/knotfucking/knotride_anus
	name = "Knotride (Anus)"
	description = "Ride their knot with your ass."
	user_required_parts = list(ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_TARGET = ORGAN_SLOT_ANUS)
	message = list(
		"rides %TARGET%'s knot with their ass.",
		"forces %TARGET%'s knot into their ass.",
		"pops %TARGET%'s knot in and out of their ass.",
		"impales their ass on %TARGET%'s cock."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 5
	target_pleasure = 8
	user_arousal = 9
	target_arousal = 11
	user_pain = 4
