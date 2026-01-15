/datum/interaction/lewd/knotting/knotfucking
	knotfucking = TRUE

/datum/interaction/lewd/knotting/knotfucking/post_interaction(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/mob/living/btm
	if(cum_genital[CLIMAX_POSITION_USER] == CLIMAX_PENIS)
		//knot_try(user, target, CLIMAX_POSITION_USER, knotfucking)
		btm = target
	else if(cum_genital[CLIMAX_POSITION_TARGET] == CLIMAX_PENIS)
		//knot_try(target, user, CLIMAX_POSITION_TARGET, knotfucking)
		btm = user
	if(user.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No" || target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")
		if(btm.stat > UNCONSCIOUS) // Got damn, quit fucking yourself into a paste, top can keep going I guess
			btm.apply_damage(2, BRUTE)
	..()

/datum/interaction/lewd/knotting/knotfucking/knotfuck_pussy
	name = "Knotfuck"
	description = "Knotfuck their pussy."
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS, CLIMAX_POSITION_TARGET = CLIMAX_VAGINA)
	cum_target = list(CLIMAX_POSITION_USER = ORGAN_SLOT_VAGINA, CLIMAX_POSITION_TARGET = ORGAN_SLOT_PENIS)
	message = list(
		"pounds %TARGET%'s pussy with their %KNOT%.",
		"forces their %KNOT% deep into %TARGET%'s pussy.",
		"slams their %KNOT% in and out of %TARGET%'s cunt."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ1.ogg',
		'modular_zzplurt/sound/interactions/champ2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 10
	target_pleasure = 8
	user_arousal = 14
	target_arousal = 12
	target_pain = 3

/datum/interaction/lewd/knotting/knotfucking/knotfuck_anus
	name = "Anal Knotfuck"
	description = "Knotfuck their ass."
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_USER = ORGAN_SLOT_ANUS)
	message = list(
		"pounds %TARGET%'s ass with their %KNOT%.",
		"forces their %KNOT% deep into %TARGET%'s ass.",
		"slams their %KNOT% in and out of %TARGET%'s ass."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 8
	target_pleasure = 6
	user_arousal = 12
	target_arousal = 10
	target_pain = 6

/datum/interaction/lewd/knotting/knotfucking/knotfuck_mouth
	name = "Oral Knotfuck"
	description = "Knotfuck their mouth. (Warning: Causes oxygen damage)"
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH)
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_USER = CLIMAX_TARGET_MOUTH)
	message = list(
		"shoves their %KNOT% into %TARGET%'s throat, bulging their cheeks.",
		"chokes %TARGET% on their %KNOT%, cutting off their air supply.",
		"slams their %KNOT% in and out of %TARGET%'s mouth."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/oral1.ogg',
		'modular_zzplurt/sound/interactions/oral2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 7
	target_pleasure = 0
	user_arousal = 10
	target_arousal = 2
	target_pain = 7

/datum/interaction/lewd/knotting/knotfucking/knotfuck_mouth/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	if(user.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No" || target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")
		var/stat_before = target.stat
		target.adjust_oxy_loss(3)
		if(target.stat == UNCONSCIOUS && stat_before != UNCONSCIOUS)
			message = list("%TARGET% passes out on %USER%'s %KNOT%.")

/datum/interaction/lewd/knotting/knotfucking/knotfuck_nipple
	target_knotting_require = list(ORGAN_SLOT_NIPPLES)
	custom_slot = ORGAN_SLOT_NIPPLES
	name = "Nipple Knotfuck"
	description = "Knotfuck their nipple."
	interaction_requires = list(
		INTERACTION_REQUIRE_TARGET_TOPLESS
	)
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums all over %CAME_IN%'s nipple",
		"%CUMMING% shoots their load into %CAME_IN%'s breast",
		"%CUMMING% fills %CAME_IN%'s nipple with cum"
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_USER = list(
		"You cum all over %CAME_IN%'s nipple",
		"You shoot your load into %CAME_IN%'s breast",
		"You fill %CAME_IN%'s nipple with cum"
	))
	cum_partner_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums all over your nipple",
		"%CUMMING% shoots their load into your breast",
		"%CUMMING% fills your nipple with cum"
	))
	message = list(
		"fucks %TARGET%'s nipple",
		"slams their %KNOT% into %TARGET%'s breast",
		"pounds %TARGET%'s nipple",
		"thrusts deep into %TARGET%'s nipple"
	)
	user_messages = list(
		"You feel %TARGET%'s nipple squeezing your %KNOT%",
		"The warmth of %TARGET%'s breast envelops your shaft",
		"%TARGET%'s nipple feels amazing around your %KNOT%"
	)
	target_messages = list(
		"You feel %USER%'s %KNOT% stretching your nipple",
		"%USER%'s shaft pushes deep into your breast",
		"The warmth of %USER%'s %KNOT% fills your nipple"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 4
	target_pleasure = 2
	user_arousal = 7
	target_arousal = 4
	target_pain = 3
