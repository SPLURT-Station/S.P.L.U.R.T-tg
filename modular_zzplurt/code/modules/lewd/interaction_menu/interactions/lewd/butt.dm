// Butt smothering interactions - smother target's face with butt
/datum/interaction/lewd/butt_smother
	name = "Butt Smother"
	description = "Smother their face with your butt. (Warning: Causes oxygen damage)"
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH)
	user_required_parts = list(ORGAN_SLOT_BUTT = REQUIRE_GENITAL_EXPOSED)
	message = null
	target_arousal = 6
	target_pleasure = 4
	target_pain = 0
	user_arousal = 4
	user_pleasure = 4
	user_pain = 0
	sound_possible = list(
		'modular_zzplurt/sound/interactions/squelch1.ogg',
		'modular_zzplurt/sound/interactions/squelch2.ogg'
	)
	sound_range = 1
	sound_use = TRUE

/datum/interaction/lewd/butt_smother/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	// Check if smothering is enabled in preferences
	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(user) && !user.client && !SSinteractions.is_blacklisted(user)))
		return FALSE
	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return FALSE

	return TRUE

/datum/interaction/lewd/butt_smother/act(mob/living/user, mob/living/target)
	message = null
	var/intent = resolve_intent_name(user)

	switch(intent)
		if("harm")
			// Deep/Intense smother
			target_pain = 6
			target_arousal = 12
			target_pleasure = 10
			user_arousal = 10
			user_pleasure = 8
			message = list(
				"drops their heavy butt onto %TARGET%'s face, crushing them with their weight.",
				"slams their ass down onto %TARGET%'s face, blocking all air.",
				"forces %TARGET%'s face deep into their butt, smothering them completely.",
				"shoves %TARGET%'s face deep into their ass, completely enveloping their head.",
				"wraps their heavy butt around %TARGET%'s face, cutting off all air completely.",
				"grinds their hips down hard onto %TARGET%'s face, crushing their nose.",
				"presses their full weight onto %TARGET%'s face, blocking their airways.",
				"forces %TARGET%'s face into their crotch, smothering them completely."
			)
		if("grab")
			// Moderate smother
			target_arousal = 10
			target_pleasure = 8
			user_arousal = 8
			user_pleasure = 6
			message = list(
				"grabs %TARGET%'s head and pulls it into their butt.",
				"presses their ass tight against %TARGET%'s face, limiting airflow.",
				"wraps their legs around %TARGET%'s head and smothering them with their butt.",
				"pulls %TARGET%'s head deep into their butt, completely covering their face.",
				"wraps their legs around %TARGET%'s head and pushes them deep into their ass.",
				"grinds %TARGET%'s face deep into their butt, cutting off all air.",
				"wraps their legs around %TARGET%'s head and pulls them into their crotch.",
				"presses their thighs tight against %TARGET%'s face, smothering them."
			)
		else // help
			// Gentle smother
			message = list(
				"gently lowers their butt onto %TARGET%'s face, covering it completely.",
				"carefully covers %TARGET%'s nose and mouth with their ass.",
				"lays their butt over %TARGET%'s face, a warm smother.",
				"gently pushes %TARGET%'s face deep into their butt.",
				"carefully guides %TARGET%'s head into their ass, covering their face completely.",
				"lays %TARGET%'s face deep into their butt, a warm enveloping smother.",
				"presses their weight down onto %TARGET%'s face, blocking their vision completely.",
				"gently lowers their hips onto %TARGET%'s face.",
				"carefully covers %TARGET%'s nose and mouth with their thighs."
			)

	// Check for choke slut trait
	if(HAS_TRAIT(target, TRAIT_CHOKE_SLUT))
		if(intent == "harm")
			target_arousal += 10
			target_pleasure += 6
			to_chat(target, span_purple("You can't breathe at all! It's so hot! You need more!"))
		else
			target_arousal += 8
			target_pleasure += 4
			to_chat(target, span_purple("You can barely breathe with their ass on your face... it's incredible!"))

	. = ..()

/datum/interaction/lewd/butt_smother/post_interaction(mob/living/user, mob/living/target)
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
		if(resolve_intent_name(user) == "harm")
			message = list("%TARGET% passes out deep in %USER%'s butt.")
		else
			message = list("%TARGET% passes out under %USER%'s butt.")
