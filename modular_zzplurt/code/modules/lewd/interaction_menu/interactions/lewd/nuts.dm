/datum/interaction/lewd/nuts
	name = "Nuts to Face"
	description = "Put your balls in their face."
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH)
	user_required_parts = list(ORGAN_SLOT_TESTICLES = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_USER = CLIMAX_TARGET_MOUTH)
	message = list(
		"grabs the back of %TARGET%'s head and pulls it into their crotch.",
		"jams their nutsack right into %TARGET%'s face.",
		"roughly grinds their fat nutsack into %TARGET%'s mouth.",
		"pulls out their saliva-covered nuts from %TARGET%'s violated mouth and then wipes off the slime onto their face.",
		"wedges a digit into the side of %TARGET%'s jaw and pries it open before using their other hand to shove their whole nutsack inside!",
		"stands with their groin inches away from %TARGET%'s face, then thrusting their hips forward and smothering %TARGET%'s whole face with their heavy ballsack."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/oral1.ogg',
		'modular_zzplurt/sound/interactions/oral2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 3
	target_pleasure = 0
	user_arousal = 5
	target_arousal = 2

/datum/interaction/lewd/nut_smack
	name = "Smack Nuts"
	description = "Smack their nuts."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	target_required_parts = list(ORGAN_SLOT_TESTICLES = REQUIRE_GENITAL_EXPOSED)
	message = list(
		"smacks %TARGET%'s nuts!",
		"slaps %TARGET%'s balls!",
		"gives %TARGET%'s testicles a slap!",
		"whacks %TARGET% right in the nuts!"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/slap.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = -10
	target_pain = 15
	user_arousal = 2
	target_arousal = 0

/datum/interaction/lewd/nut_smack/act(mob/living/user, mob/living/target)
	var/original_pleasure = target_pleasure
	if(HAS_TRAIT(target, TRAIT_MASOCHISM))
		target_pleasure = abs(original_pleasure) * 1.5 // Masochists get 50% more pleasure from the pain
	. = ..()
	target_pleasure = original_pleasure


// Ball/sac smothering interactions - smother target's face with testicles
/datum/interaction/lewd/ball_smother
	name = "Ball Smother"
	description = "Smother their face with your balls. (Warning: Causes oxygen damage)"
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH)
	user_required_parts = list(ORGAN_SLOT_TESTICLES = REQUIRE_GENITAL_EXPOSED)
	message = null
	target_arousal = 8
	target_pleasure = 6
	target_pain = 0
	user_arousal = 6
	user_pleasure = 6
	user_pain = 0
	sound_possible = list(
		'modular_zzplurt/sound/interactions/squelch1.ogg',
		'modular_zzplurt/sound/interactions/squelch2.ogg'
	)
	sound_range = 1
	sound_use = TRUE

/datum/interaction/lewd/ball_smother/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	// Check if smothering is enabled in preferences
	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(user) && !user.client && !SSinteractions.is_blacklisted(user)))
		return FALSE
	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return FALSE

	return TRUE

/datum/interaction/lewd/ball_smother/act(mob/living/user, mob/living/target)
	message = null
	var/intent = resolve_intent_name(user)

	switch(intent)
		if("harm")
			// Deep/Intense smother
			target_pain = 6
			target_arousal = 14
			target_pleasure = 12
			user_arousal = 12
			user_pleasure = 10
			message = list(
				"drops their heavy ballsack onto %TARGET%'s face, crushing their nose and blocking airways.",
				"presses their testicles hard against %TARGET%'s mouth and nose, smothering them.",
				"forces %TARGET%'s face into their balls, cutting off all air supply.",
				"shoves %TARGET%'s face deep into their ballsack, completely enveloping their head.",
				"forces %TARGET%'s face into their sac, squeezing tight around their head.",
				"wraps their heavy testicles around %TARGET%'s face, cutting off all air completely.",
				"grinds their massive ballsack over %TARGET%'s face, crushing their nose.",
				"presses their full nutsack weight onto %TARGET%'s face, smothering them completely."
			)
		if("grab")
			// Moderate smother
			target_arousal = 12
			target_pleasure = 10
			user_arousal = 10
			user_pleasure = 8
			message = list(
				"wraps their legs around %TARGET%'s head and pulls their balls over their face.",
				"presses their sac against %TARGET%'s nose and mouth, smothering them.",
				"grinds their balls over %TARGET%'s face, blocking their airways.",
				"pulls %TARGET%'s head deep into their ballsack, completely covering their face.",
				"wraps their legs around %TARGET%'s head and pushes them deep into their sac.",
				"grinds %TARGET%'s face deep into their testicles, cutting off all air.",
				"pulls %TARGET%'s face into their nutsack, pressing down tightly.",
				"wraps their thighs around %TARGET%'s head with their balls pressed against their face."
			)
		else // help
			// Gentle smother
			message = list(
				"gently lowers their balls onto %TARGET%'s face.",
				"carefully covers %TARGET%'s nose and mouth with their sac.",
				"lays their testicles over %TARGET%'s face, a warm smother.",
				"gently pushes %TARGET%'s face deep into their ballsack.",
				"carefully guides %TARGET%'s head into their sac, covering their face completely.",
				"lays %TARGET%'s face deep into their testicles, a warm enveloping smother.",
				"presses their weight down onto %TARGET%'s face with their balls.",
				"gently settles their nutsack over %TARGET%'s face."
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
			to_chat(target, span_purple("You can barely breathe with their balls on your face... it's incredible!"))

	. = ..()

/datum/interaction/lewd/ball_smother/post_interaction(mob/living/user, mob/living/target)
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
			message = list("%TARGET% passes out deep in %USER%'s ballsack.")
		else
			message = list("%TARGET% passes out under %USER%'s ballsack.")
