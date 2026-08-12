/datum/interaction/lewd/armpit_fuck
	name = "Armpit Fuck"
	description = "Fuck their armpit."
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_TOPLESS)
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums all over CAME_IN's armpit",
		"%CUMMING% shoots their load into CAME_IN's pit",
		"%CUMMING% covers CAME_IN's underarm in cum"
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_USER = list(
		"You cum all over %CAME_IN%'s armpit",
		"You shoot your load into %CAME_IN%'s pit",
		"You cover %CAME_IN%'s underarm in cum"
	))
	cum_partner_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums all over your armpit",
		"%CUMMING% shoots their load into your pit",
		"%CUMMING% covers your underarm in cum"
	))
	message = list(
		"fucks %TARGET%'s armpit",
		"slides their cock into %TARGET%'s underarm",
		"thrusts into %TARGET%'s pit",
		"pounds %TARGET%'s armpit"
	)
	user_messages = list(
		"You feel %TARGET%'s warm pit around your cock",
		"The softness of %TARGET%'s armpit feels good against your shaft",
		"%TARGET%'s underarm squeezes your cock nicely"
	)
	target_messages = list(
		"You feel %USER%'s cock rubbing in your armpit",
		"%USER%'s shaft slides against your underarm",
		"The warmth of %USER%'s cock presses into your pit"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 3
	target_pleasure = 0
	user_arousal = 5
	target_arousal = 2

/datum/interaction/lewd/armpit_lick
	name = "Lick Armpit"
	description = "Lick their armpit."
	interaction_requires = list(
		INTERACTION_REQUIRE_SELF_MOUTH,
		INTERACTION_REQUIRE_TARGET_TOPLESS
	)
	message = list(
		"licks %TARGET%'s armpit",
		"runs their tongue along %TARGET%'s underarm",
		"tastes %TARGET%'s pit",
		"plants their face in %TARGET%'s armpit"
	)
	user_messages = list(
		"You taste %TARGET%'s armpit",
		"The scent of %TARGET%'s pit fills your nose",
		"You savor the taste of %TARGET%'s underarm"
	)
	target_messages = list(
		"You feel %USER%'s tongue in your armpit",
		"%USER%'s wet tongue slides across your pit",
		"The warmth of %USER%'s mouth tingles your underarm"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ_fingering.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 3
	target_arousal = 3

// Mosley asked to keep the old interaction. here it is:
/datum/interaction/lewd/armpit_smother
	name = "Armpit Smother"
	description = "Press your armpit against their face."
	interaction_requires = list(
		INTERACTION_REQUIRE_TARGET_MOUTH,
		INTERACTION_REQUIRE_SELF_TOPLESS
	)
	message = list(
		"presses their armpit against %TARGET%'s face",
		"smothers %TARGET%'s face with their pit",
		"forces %TARGET%'s face into their underarm",
		"pins %TARGET%'s head under their arm"
	)
	user_messages = list(
		"You feel %TARGET%'s face pressed into your pit",
		"You hold %TARGET%'s head against your underarm",
		"You keep %TARGET%'s face buried in your armpit"
	)
	target_messages = list(
		"Your face is pressed into %USER%'s armpit",
		"%USER%'s underarm smothers your face",
		"Your nose fills with the scent of %USER%'s pit"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/squelch1.ogg',
		'modular_zzplurt/sound/interactions/squelch2.ogg',
		'modular_zzplurt/sound/interactions/squelch3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 0
	user_arousal = 3
	target_arousal = 3

// NEW SMOTHERING INTERACTION WITH OXY DAMAGE.
/datum/interaction/lewd/armpit_smother_v2
	name = "Armpit Smothering"
	description = "Press your armpit against their face. (Warning: Causes oxygen damage)"
	interaction_requires = list(
		INTERACTION_REQUIRE_TARGET_MOUTH,
		INTERACTION_REQUIRE_SELF_TOPLESS
	)
	message = null
	target_arousal = 6
	target_pleasure = 4
	target_pain = 0
	user_arousal = 4
	user_pleasure = 4
	user_pain = 0
	sound_possible = list(
		'modular_zzplurt/sound/interactions/squelch1.ogg',
		'modular_zzplurt/sound/interactions/squelch2.ogg',
		'modular_zzplurt/sound/interactions/squelch3.ogg'
	)
	sound_range = 1
	sound_use = TRUE

/datum/interaction/lewd/armpit_smother_v2/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	// Check if smothering is enabled in preferences
	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(user) && !user.client && !SSinteractions.is_blacklisted(user)))
		return FALSE
	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return FALSE

	return TRUE

/datum/interaction/lewd/armpit_smother_v2/act(mob/living/user, mob/living/target)
	message = null
	var/intent = resolve_intent_name(user)

	switch(intent)
		if("harm")
			// Deep/Intense smother
			target_pain = 4
			target_arousal = 10
			target_pleasure = 8
			user_arousal = 8
			user_pleasure = 6
			message = list(
				"presses their armpit hard against %TARGET%'s face, smothering them.",
				"forces %TARGET%'s face deep into their underarm, cutting off air.",
				"grinds their pit against %TARGET%'s face, blocking airways.",
				"presses their full weight down onto %TARGET%'s face with their armpit.",
				"shoves their armpit forcefully against %TARGET%'s face.",
				"crushes %TARGET%'s face under their arm tightly.",
				"presses their underarm hard over %TARGET%'s nose and mouth.",
				"forces %TARGET%'s face into their armpit aggressively."
			)
		if("grab")
			// Moderate smother
			target_arousal = 8
			target_pleasure = 6
			user_arousal = 6
			user_pleasure = 5
			message = list(
				"wraps their arm around %TARGET%'s head, pulling them into their pit.",
				"presses their armpit firmly against %TARGET%'s face.",
				"grinds their pit against %TARGET%'s face.",
				"wraps their arm around %TARGET%'s head tightly.",
				"presses their underarm against %TARGET%'s face firmly.",
				"pulls %TARGET%'s face into their armpit.",
				"holds %TARGET%'s head against their pit tightly.",
				"presses their arm over %TARGET%'s face."
			)
		else // help
			// Gentle smother
			message = list(
				"gently presses their armpit against %TARGET%'s face.",
				"carefully covers %TARGET%'s face with their pit.",
				"lays their underarm over %TARGET%'s face softly.",
				"gently wraps their arm around %TARGET%'s head.",
				"carefully lowers their arm onto %TARGET%'s face.",
				"gently places their pit over %TARGET%'s nose and mouth.",
				"softly presses their underarm against %TARGET%'s face.",
				"gently settles their armpit over %TARGET%'s face."
			)

	// Check for choke slut trait
	if(HAS_TRAIT(target, TRAIT_CHOKE_SLUT))
		if(intent == "harm")
			target_arousal += 10
			target_pleasure += 6
			to_chat(target, span_purple("You can barely breathe with their armpit crushing your face... it's amazing!"))
		else
			target_arousal += 8
			target_pleasure += 4
			to_chat(target, span_purple("You can barely breathe with their armpit on your face... it's incredible!"))

	. = ..()

/datum/interaction/lewd/armpit_smother_v2/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	var/stat_before = target.stat
	var/oxy_damage = 3

	// Set oxy damage based on intent
	switch(resolve_intent_name(user))
		if("harm")
			oxy_damage = 4
		if("grab")
			oxy_damage = 3
		else
			oxy_damage = 2

	// Always apply oxy damage up to 45
	if(target.get_oxy_loss() < 45)
		target.adjust_oxy_loss(oxy_damage)
	// Only apply additional damage if extmharm is enabled
	else if(user.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No" || target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")
		target.adjust_oxy_loss(oxy_damage)

	// Check if target just passed out
	if(target.stat == UNCONSCIOUS && stat_before != UNCONSCIOUS)
		message = list("%TARGET% passes out under %USER%'s armpit.")

/datum/interaction/lewd/armpit_pitjob
	name = "Give Pitjob"
	description = "Jerk them off with your armpit."
	interaction_requires = list(
		INTERACTION_REQUIRE_SELF_TOPLESS
	)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list(
		"%CUMMING% cums all over %CAME_IN%'s armpit",
		"%CUMMING% shoots their load into %CAME_IN%'s pit",
		"%CUMMING% covers %CAME_IN%'s underarm in cum"
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_TARGET = list(
		"%CUMMING% cums all over your armpit",
		"%CUMMING% shoots your load into your pit",
		"%CUMMING% covers your underarm in cum"
	))
	cum_partner_text_overrides = list(CLIMAX_POSITION_TARGET = list(
		"You cum all over %CAME_IN%'s armpit",
		"You shoot your load into %CAME_IN%'s pit",
		"You cover %CAME_IN%'s underarm in cum"
	))
	message = list(
		"works %TARGET%'s cock with their armpit",
		"squeezes %TARGET%'s shaft between their arm and chest",
		"jerks %TARGET% off with their pit",
		"pleasures %TARGET%'s cock with their underarm"
	)
	user_messages = list(
		"You feel %TARGET%'s cock throb in your armpit",
		"The warmth of %TARGET%'s shaft fills your pit",
		"You squeeze %TARGET%'s cock with your underarm"
	)
	target_messages = list(
		"%USER%'s warm pit strokes your cock",
		"Your shaft slides between %USER%'s arm and chest",
		"The softness of %USER%'s armpit feels amazing"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 3
	user_arousal = 2
	target_arousal = 5
