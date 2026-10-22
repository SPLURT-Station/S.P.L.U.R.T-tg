/datum/interaction/lewd/knotting/knotfucking/knotride_pussy
	name = "Knotride (Vagina)"
	description = "Ride their knot with your pussy."
	user_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_VAGINA, CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_USER = ORGAN_SLOT_PENIS, CLIMAX_POSITION_TARGET = ORGAN_SLOT_VAGINA)
	message = list(
		"rides %TARGET%'s %KNOT%.",
		"forces %TARGET%'s %KNOT% into their pussy.",
		"pops %TARGET%'s %KNOT% in and out of their pussy.",
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
	user_pain = 2

/datum/interaction/lewd/knotting/knotfucking/knotride_anus
	name = "Knotride (Anus)"
	description = "Ride their knot with your ass."
	user_required_parts = list(ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_TARGET = ORGAN_SLOT_ANUS)
	message = list(
		"rides %TARGET%'s %KNOT% with their ass.",
		"forces %TARGET%'s %KNOT% into their ass.",
		"pops %TARGET%'s %KNOT% in and out of their ass.",
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

/datum/interaction/lewd/knotting/knotfucking/knotride_sheath
	user_knotting_require = list(ORGAN_SLOT_SLIT)
	name = "Knotride (Sheath)"
	description = "Ride their knot with your sheath."
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_USER = ORGAN_SLOT_PENIS, CLIMAX_POSITION_TARGET = CLIMAX_TARGET_SHEATH)
	message = list(
		"rides %TARGET%'s %KNOT% with their sheath.",
		"forces %TARGET%'s %KNOT% into their sheath.",
		"pops %TARGET%'s %KNOT% in and out of their sheath.",
		"docks their sheath onto %TARGET%'s cock."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 8
	target_pleasure = 9
	user_arousal = 11
	target_arousal = 12
	user_pain = 3

/datum/interaction/lewd/knotting/knotfucking/knotride_sheath/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return FALSE
	var/obj/item/organ/genital/penis/user_penis = user?.get_organ_slot(ORGAN_SLOT_PENIS)
	return user_penis?.sheath == SHEATH_NORMAL

/datum/interaction/lewd/knotting/knotfucking/knotride_slit
	user_knotting_require = list(ORGAN_SLOT_SLIT)
	name = "Knotride (Slit)"
	description = "Ride their knot with your slit."
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_USER = ORGAN_SLOT_PENIS, CLIMAX_POSITION_TARGET = CLIMAX_TARGET_SHEATH)
	message = list(
		"rides %TARGET%'s %KNOT% with their slit.",
		"forces %TARGET%'s %KNOT% into their slit.",
		"pops %TARGET%'s %KNOT% in and out of their slit.",
		"sinks their genital slit onto %TARGET%'s cock."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 8
	target_pleasure = 9
	user_arousal = 11
	target_arousal = 12
	user_pain = 3

/datum/interaction/lewd/knotting/knotfucking/knotride_slit/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return FALSE
	var/obj/item/organ/genital/penis/user_penis = user?.get_organ_slot(ORGAN_SLOT_PENIS)
	return user_penis?.sheath == SHEATH_SLIT
