// Mosley asks to keep the old interactions:
/datum/interaction/lewd/thighspenis //name changed because it's more convenient to change this than the new code.
	name = "Thigh Smother (Penis)"
	description = "Smother them with your penis."
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH)
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_USER = CLIMAX_TARGET_MOUTH)
	message = list(
		"presses their weight down onto %TARGET%'s face, blocking their vision completely.",
		"forces their cock into %TARGET%'s face as they're stuck locked between their thighs.",
		"slips their cock into %TARGET%'s helpless mouth, keeping their shaft pressed hard into their face."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bj10.ogg',
		'modular_zzplurt/sound/interactions/bj3.ogg',
		'modular_zzplurt/sound/interactions/foot_wet1.ogg',
		'modular_zzplurt/sound/interactions/foot_dry3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 4
	target_pleasure = 0
	user_arousal = 6
	target_arousal = 2

/datum/interaction/lewd/thighsvagina //name changed because it's more convenient to change this than the new code.
	name = "Thigh Smother (Vagina)"
	description = "Smother them with your pussy."
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH)
	user_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_VAGINA)
	cum_target = list(CLIMAX_POSITION_USER = CLIMAX_TARGET_MOUTH)
	message = list(
		"presses their weight down onto %TARGET%'s face, blocking their vision completely.",
		"rides %TARGET%'s face, grinding their wet pussy all over it.",
		"grinds their pussy into %TARGET%'s face."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bj10.ogg',
		'modular_zzplurt/sound/interactions/bj3.ogg',
		'modular_zzplurt/sound/interactions/foot_wet1.ogg',
		'modular_zzplurt/sound/interactions/foot_dry3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 4
	target_pleasure = 0
	user_arousal = 6
	target_arousal = 2

// NEW SMOTHERING INTERACTIONS
/datum/interaction/lewd/thighs_penis
	name = "Thigh Smothering (Penis)"
	description = "Smother them with your penis."
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH)
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_USER = CLIMAX_TARGET_MOUTH)
	message = list(
		null
		)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bj10.ogg',
		'modular_zzplurt/sound/interactions/bj3.ogg',
		'modular_zzplurt/sound/interactions/foot_wet1.ogg',
		'modular_zzplurt/sound/interactions/foot_dry3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 4
	target_pleasure = 0
	user_arousal = 6
	target_arousal = 2

/datum/interaction/lewd/thighs_penis/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	// Check if smothering is enabled in preferences
	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(user) && !user.client && !SSinteractions.is_blacklisted(user)))
		return FALSE
	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return FALSE

	return TRUE

/datum/interaction/lewd/thighs_penis/act(mob/living/user, mob/living/target)
	message = null
	var/intent = resolve_intent_name(user) // ALL VALUES TO BE CHANGED TO STAFF DISCRETION.

	switch(intent)
		if("harm")
			// Deep/Intense smother
			target_pain = 6
			target_arousal = 14
			target_pleasure = 10
			user_arousal = 12
			user_pleasure = 8
			message = list(
				"grinds their hips down hard onto %TARGET%'s face, crushing their nose.",
				"presses their full weight onto %TARGET%'s face, blocking their airways.",
				"forces %TARGET%'s face into their crotch, smothering them completely.",
				"slams their crotch down onto %TARGET%'s face, crushing them.",
				"shoves their groin hard against %TARGET%'s face, cutting off all air.",
				"grinds their hips down forcefully onto %TARGET%'s face.",
				"presses their penis deep into %TARGET%'s face, smothering them.",
				"forces %TARGET%'s face into their groin, squeezing tight."
			)
		if("grab")
			// Moderate smother
			target_arousal = 12
			target_pleasure = 8
			user_arousal = 10
			user_pleasure = 6
			message = list(
				"wraps their legs around %TARGET%'s head and pulls them into their crotch.",
				"presses their thighs tight against %TARGET%'s face, smothering them.",
				"grinds their groin into %TARGET%'s face, blocking their airways.",
				"wraps their legs around %TARGET%'s head and squeezes tight.",
				"presses their hips against %TARGET%'s face firmly.",
				"pulls %TARGET%'s face into their crotch area.",
				"grinds their cock against %TARGET%'s face.",
				"wraps their thighs around %TARGET%'s head tightly."
			)
		else // help
			// Gentle smother
			message = list(
				"presses their weight down onto %TARGET%'s face, blocking their vision completely.",
				"gently lowers their hips onto %TARGET%'s face.",
				"carefully covers %TARGET%'s nose and mouth with their thighs.",
				"gently presses their groin against %TARGET%'s face.",
				"carefully lowers their hips onto %TARGET%'s face.",
				"gently covers %TARGET%'s face with their crotch.",
				"lays their hips over %TARGET%'s face carefully.",
				"gently settles their weight on %TARGET%'s face."
			)

	// Check for choke slut trait
	if(HAS_TRAIT(target, TRAIT_CHOKE_SLUT))
		if(intent == "harm")
			target_arousal += 10
			target_pleasure += 6
			to_chat(target, span_purple("You can barely breathe with their hips crushing your face... it's incredible!"))
		else
			target_arousal += 8
			target_pleasure += 4
			to_chat(target, span_purple("You can barely breathe with their thighs on your face... it's incredible!"))

	. = ..()

/datum/interaction/lewd/thighs_penis/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	var/stat_before = target.stat
	var/oxy_damage = 3

	// Set oxy damage based on intent
	switch(resolve_intent_name(user))
		if("harm")
			oxy_damage = 5
		if("grab")
			oxy_damage = 4
		else
			oxy_damage = 3

	// Always apply oxy damage up to 45
	if(target.get_oxy_loss() < 45)
		target.adjust_oxy_loss(oxy_damage)
	// Only apply additional damage if extmharm is enabled
	else if(user.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No" || target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")
		target.adjust_oxy_loss(oxy_damage)
	// Check if target just passed out
	if(target.stat == UNCONSCIOUS && stat_before != UNCONSCIOUS)
		message = list("%TARGET% passes out under %USER%'s thighs.")


/datum/interaction/lewd/thighs_vagina
	name = "Thigh Smothering (Vagina)"
	description = "Smother them with your pussy."
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH)
	user_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_VAGINA)
	cum_target = list(CLIMAX_POSITION_USER = CLIMAX_TARGET_MOUTH)
	message = null
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bj10.ogg',
		'modular_zzplurt/sound/interactions/bj3.ogg',
		'modular_zzplurt/sound/interactions/foot_wet1.ogg',
		'modular_zzplurt/sound/interactions/foot_dry3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 4
	target_pleasure = 0
	user_arousal = 6
	target_arousal = 2

/datum/interaction/lewd/thighs_vagina/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	// Check if smothering is enabled in preferences
	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(user) && !user.client && !SSinteractions.is_blacklisted(user)))
		return FALSE
	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return FALSE

	return TRUE

/datum/interaction/lewd/thighs_vagina/act(mob/living/user, mob/living/target)
	message = null
	var/intent = resolve_intent_name(user)

	switch(intent)
		if("harm")
			// Deep/Intense smother
			target_pain = 6
			target_arousal = 14
			target_pleasure = 10
			user_arousal = 12
			user_pleasure = 8
			message = list(
				"grinds their hips down hard onto %TARGET%'s face, crushing their nose.",
				"presses their full weight onto %TARGET%'s face, blocking their airways.",
				"forces %TARGET%'s face into their crotch, smothering them completely.",
				"slams their wet pussy down onto %TARGET%'s face, grinding against them.",
				"shoves their groin hard against %TARGET%'s face, cutting off all air.",
				"grinds their hips down forcefully onto %TARGET%'s face.",
				"presses their pussy deep into %TARGET%'s face, smothering them.",
				"forces %TARGET%'s face into their wet slit, squeezing tight."
			)
		if("grab")
			// Moderate smother
			target_arousal = 12
			target_pleasure = 8
			user_arousal = 10
			user_pleasure = 6
			message = list(
				"wraps their legs around %TARGET%'s head and pulls them into their crotch.",
				"presses their thighs tight against %TARGET%'s face, smothering them.",
				"grinds their wet pussy into %TARGET%'s face, blocking their airways.",
				"wraps their legs around %TARGET%'s head and squeezes tight.",
				"presses their hips against %TARGET%'s face firmly.",
				"pulls %TARGET%'s face into their wet crotch area.",
				"grinds their slit against %TARGET%'s face.",
				"wraps their thighs around %TARGET%'s head tightly."
			)
		else // help
			// Gentle smother
			message = list(
				"presses their weight down onto %TARGET%'s face, blocking their vision completely.",
				"rides %TARGET%'s face, grinding their wet pussy all over it.",
				"grinds their pussy into %TARGET%'s face.",
				"gently presses their groin against %TARGET%'s face.",
				"carefully lowers their hips onto %TARGET%'s face.",
				"gently covers %TARGET%'s face with their wet slit.",
				"lays their hips over %TARGET%'s face carefully.",
				"gently settles their wet crotch on %TARGET%'s face."
			)

	// Check for choke slut trait
	if(HAS_TRAIT(target, TRAIT_CHOKE_SLUT))
		if(intent == "harm")
			target_arousal += 10
			target_pleasure += 6
			to_chat(target, span_purple("You can barely breathe with their wet slit covering your face... it's incredible!"))
		else
			target_arousal += 8
			target_pleasure += 4
			to_chat(target, span_purple("You can barely breathe with their thighs on your face... it's incredible!"))

	. = ..()

/datum/interaction/lewd/thighs_vagina/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	var/stat_before = target.stat
	var/oxy_damage = 3

	// Set oxy damage based on intent
	switch(resolve_intent_name(user))
		if("harm")
			oxy_damage = 5
		if("grab")
			oxy_damage = 4
		else
			oxy_damage = 3

	// Always apply oxy damage up to 45
	if(target.get_oxy_loss() < 45)
		target.adjust_oxy_loss(oxy_damage)
	// Only apply additional damage if extmharm is enabled
	else if(user.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No" || target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")
		target.adjust_oxy_loss(oxy_damage)
	// Check if target just passed out
	if(target.stat == UNCONSCIOUS && stat_before != UNCONSCIOUS)
		message = list("%TARGET% passes out under %USER%'s thighs.")


/datum/interaction/lewd/thighfuck
	name = "Thighfuck"
	description = "Fuck their thighs."
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_BOTTOMLESS)
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums all over %CAME_IN%'s thighs",
		"%CUMMING% shoots their load onto %CAME_IN%'s legs",
		"%CUMMING% covers %CAME_IN%'s thighs in cum"
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_USER = list(
		"You cum all over %CAME_IN%'s thighs",
		"You shoot your load onto %CAME_IN%'s legs",
		"You cover %CAME_IN%'s thighs in cum"
	))
	cum_partner_text_overrides = list(CLIMAX_POSITION_USER = list(
		"%CUMMING% cums all over your thighs",
		"%CUMMING% shoots their load onto your legs",
		"%CUMMING% covers your thighs in cum"
	))
	message = list(
		"fucks %TARGET%'s thighs",
		"slides their cock between %TARGET%'s legs",
		"thrusts between %TARGET%'s thighs",
		"pounds against %TARGET%'s legs"
	)
	user_messages = list(
		"You feel %TARGET%'s thighs squeezing your cock",
		"The warmth between %TARGET%'s legs feels amazing",
		"%TARGET%'s soft thighs feel great around your shaft"
	)
	target_messages = list(
		"You feel %USER%'s cock sliding between your thighs",
		"%USER%'s shaft rubs between your legs",
		"The warmth of %USER%'s cock presses against your thighs"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 4
	target_pleasure = 0
	user_arousal = 6
	target_arousal = 4

/datum/interaction/lewd/thighjob
	name = "Give Thighjob"
	description = "Pleasure them with your thighs."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_BOTTOMLESS)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list(
		"%CUMMING% cums all over %CAME_IN%'s thighs",
		"%CUMMING% shoots their load onto %CAME_IN%'s legs",
		"%CUMMING% covers %CAME_IN%'s thighs in cum"
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_TARGET = list(
		"%CUMMING% cums all over your thighs",
		"%CUMMING% shoots their load onto your legs",
		"%CUMMING% covers your thighs in cum"
	))
	cum_partner_text_overrides = list(CLIMAX_POSITION_TARGET = list(
		"You cum all over %CAME_IN%'s thighs",
		"You shoot your load onto %CAME_IN%'s legs",
		"You cover %CAME_IN%'s thighs in cum"
	))
	message = list(
		"squeezes %TARGET%'s cock between their thighs",
		"works %TARGET%'s shaft with their legs",
		"pleasures %TARGET% with their thighs",
		"rubs %TARGET%'s cock between their legs"
	)
	user_messages = list(
		"You feel %TARGET%'s cock throbbing between your thighs",
		"The warmth of %TARGET%'s shaft feels nice between your legs",
		"You squeeze %TARGET%'s cock with your thighs"
	)
	target_messages = list(
		"%USER%'s warm thighs squeeze your cock",
		"Your shaft slides between %USER%'s legs",
		"The softness of %USER%'s thighs feels amazing"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 4
	user_arousal = 4
	target_arousal = 6
