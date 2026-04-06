// Hand/Paw Smothering interaction - dynamically uses paw or hand messages based on user's species
// Single datum handling both cases per user preference

/datum/interaction/lewd/hand_smother
	name = "Hand/Paw Smother"
	description = "Smother their face with your hands/paws. (Warning: Causes oxygen damage)"
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH) //so in theory someone without arms could still use this interaction, but this is the only fix I've found.
	message = null
	target_arousal = 4
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

/datum/interaction/lewd/hand_smother/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	// Check if smothering is enabled in preferences
	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(user) && !user.client && !SSinteractions.is_blacklisted(user)))
		return FALSE
	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return FALSE

	return TRUE

/datum/interaction/lewd/hand_smother/act(mob/living/user, mob/living/target)
	message = null
	var/intent = resolve_intent_name(user)
	var/is_paw_user = isfelinid(user) || ismammal(user) || iscanine(user) || istajaran(user) || isakula(user) // List of species that use paws instead of hands for smothering; can be expanded as needed

	if(!is_paw_user)
		switch(intent)
			if("harm")
				// Deep/Intense smother
				target_pain = 6
				target_arousal = 8
				target_pleasure = 8
				user_arousal = 4
				user_pleasure = 4
				message = list(
					"slams their hands over %TARGET%'s face, crushing their nose and sealing their mouth.",
					"presses their hands hard against %TARGET%'s mouth and nose, completely smothering them.",
					"forces %TARGET%'s face deep into their hands, cutting off all air.",
					"grinds their hands brutally over %TARGET%'s face, blocking every breath.",
					"clamps their hands tight around %TARGET%'s head, suffocating them completely.",
					"smashes %TARGET%'s face beneath their powerful hands.",
					"crushes %TARGET%'s airways under the weight of their hands.",
					"seals %TARGET%'s face completely with their unyielding hands."
				)
			if("grab")
				// Moderate smother
				target_arousal = 6
				target_pleasure = 6
				user_arousal = 3
				user_pleasure = 3
				message = list(
					"presses their hands firmly over %TARGET%'s nose and mouth.",
					"covers %TARGET%'s face with their hands, restricting their breathing.",
					"grinds their hands over %TARGET%'s face, smothering them steadily.",
					"pushes %TARGET%'s head deep into their hands, blocking most air.",
					"clamps their hands around %TARGET%'s face, making breathing difficult.",
					"forces %TARGET%'s face under their hands, heavy and suffocating.",
					"presses down with their hands, smothering %TARGET% completely.",
					"wraps their hands around %TARGET%'s head, cutting off most air."
				)
			else // help
				// Gentle smother
				message = list(
					"gently places their hands over %TARGET%'s face.",
					"carefully covers %TARGET%'s nose and mouth with their hands.",
					"lays their hands softly over %TARGET%'s face, warm smother.",
					"slowly presses their hands against %TARGET%'s face.",
					"guides %TARGET%'s face gently into their hands.",
					"settles their hands over %TARGET%'s face, soft and enveloping.",
					"rests their hands down onto %TARGET%'s face tenderly.",
					"covers %TARGET%'s face with their warm hands."
				)
	else
		switch(intent)
			if("harm")
				// Deep/Intense paw smother
				target_pain = 6
				target_arousal = 8
				target_pleasure = 8
				user_arousal = 4
				user_pleasure = 4
				message = list(
					"slams their meaty paws over %TARGET%'s face, claws digging in as they crush their nose.",
					"mashes their heavy paws against %TARGET%'s mouth and nose, fur smothering them completely.",
					"forces %TARGET%'s face deep into their paw pads, cutting off all air with brutal force.",
					"grinds their paws savagely over %TARGET%'s face, claws scraping as they suffocate them.",
					"clamps their powerful paws around %TARGET%'s head, suffocating with paw meat and fur.",
					"smashes %TARGET%'s face beneath their clawed paws, no escape from the smother.",
					"crushes %TARGET%'s airways under the weight of their massive paws.",
					"seals %TARGET%'s face completely with their feral paws, claws pinning them down."
				)
			if("grab")
				// Moderate paw smother
				target_arousal = 12
				target_pleasure = 10
				user_arousal = 10
				user_pleasure = 8
				message = list(
					"presses their thick paws firmly over %TARGET%'s nose and mouth, fur tickling.",
					"covers %TARGET%'s face with their meaty paws, restricting breath through the fur.",
					"grinds their paws steadily over %TARGET%'s face, paw pads smothering heavily.",
					"pushes %TARGET%'s head deep into their paws, fur and pads blocking most air.",
					"clamps their paws around %TARGET%'s face, making every breath a struggle.",
					"forces %TARGET%'s face under their heavy paws, warm fur enveloping them.",
					"presses down with their paws, smothering %TARGET% with paw meat.",
					"wraps their paws around %TARGET%'s head, fur suffocating them."
				)
			else // help
				// Gentle paw smother
				message = list(
					"gently places their soft paws over %TARGET%'s face.",
					"carefully covers %TARGET%'s nose and mouth with their fuzzy paws.",
					"lays their paws softly over %TARGET%'s face, warm fur smother.",
					"slowly presses their paws against %TARGET%'s face, pads caressing.",
					"guides %TARGET%'s face gently into their paws.",
					"settles their paws over %TARGET%'s face, soft fur enveloping.",
					"rests their paws down onto %TARGET%'s face tenderly.",
				"covers %TARGET%'s face with their warm, fuzzy paws."
				)

	// Check for choke slut trait (applies to both hands and paws)
	if(HAS_TRAIT(target, TRAIT_CHOKE_SLUT))
		if(intent == "harm")
			target_arousal += 10
			target_pleasure += 6
			to_chat(target, span_purple("You can't breathe at all under their hands/paws! It's so hot! You need more!"))
		else
			target_arousal += 8
			target_pleasure += 4
			to_chat(target, span_purple("You can barely breathe with their hands/paws on your face... it's incredible!"))

	. = ..()

/datum/interaction/lewd/hand_smother/post_interaction(mob/living/user, mob/living/target)
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
			message = list("%TARGET% passes out completely smothered under %USER%'s hand.")
		else
			message = list("%TARGET% passes out beneath %USER%'s hand.")
