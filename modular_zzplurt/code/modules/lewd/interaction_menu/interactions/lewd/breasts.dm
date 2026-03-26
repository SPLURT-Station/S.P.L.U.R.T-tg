/datum/interaction/lewd/breastfeed
	name = "Breastfeed"
	description = "Breastfeed them."
	user_required_parts = list(ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_EXPOSED)
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH, INTERACTION_REQUIRE_SELF_HUMAN)
	additional_details = list(INTERACTION_MAY_CONTAIN_DRINK)
	message = list(
		"pushes their breasts against %TARGET%'s mouth, squirting their warm %MILK% into their mouth.",
		"fills %TARGET%'s mouth with warm, sweet %MILK% as they squeeze their boobs, panting.",
		"lets a large stream of their own abundant %MILK% coat the back of %TARGET%'s throat."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/oral1.ogg',
		'modular_zzplurt/sound/interactions/oral2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 2
	user_arousal = 3
	target_pleasure = 0
	target_arousal = 2

/datum/interaction/lewd/breastfeed/act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/genital/breasts/breasts = user.get_organ_slot(ORGAN_SLOT_BREASTS)
	if(!breasts?.internal_fluid_datum)
		return

	var/datum/reagent/milk = find_reagent_object_from_type(breasts.internal_fluid_datum)
	var/list/original_messages = message.Copy()
	var/chosen_message = pick(message)
	chosen_message = replacetext(chosen_message, "%MILK%", LOWER_TEXT(milk.name))
	message = list(chosen_message)
	. = ..()
	message = original_messages

/datum/interaction/lewd/breastfeed/post_interaction(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/obj/item/organ/genital/breasts/breasts = user.get_organ_slot(ORGAN_SLOT_BREASTS)
	if(breasts?.internal_fluid_datum)
		// Calculate milk amount based on how full the breasts are (0.5 to 2 multiplier)
		var/milk_multiplier = 0.5
		if(breasts.internal_fluid_maximum > 0)
			milk_multiplier = 0.5 + (1.5 * (breasts.reagents.total_volume / breasts.internal_fluid_maximum))

		var/transfer_amount = rand(1, 3 * milk_multiplier)
		var/datum/reagents/R = new(breasts.internal_fluid_maximum)
		breasts.reagents.trans_to(R, transfer_amount)
		R.trans_to(target, R.total_volume, transferred_by = user)
		qdel(R)

/datum/interaction/lewd/titgrope
	name = "Grope Breasts"
	description = "Grope their breasts."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	target_required_parts = list(ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_ANY)
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	message = list(
		"gently gropes %TARGET%'s breast.",
		"softly squeezes %TARGET%'s breasts.",
		"grips %TARGET%'s breasts.",
		"runs a few fingers over %TARGET%'s breast.",
		"delicately teases %TARGET%'s nipple.",
		"traces a touch across %TARGET%'s breast."
	)
	sound_possible = list('modular_zzplurt/sound/interactions/squelch1.ogg')
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	user_arousal = 2
	target_pleasure = 3
	target_arousal = 5

/datum/interaction/lewd/titgrope/act(mob/living/user, mob/living/target)
	var/obj/item/liquid_container
	var/list/original_messages = message.Copy()

	// Check for container
	var/obj/item/cached_item = user.get_active_held_item()
	if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
		liquid_container = cached_item
	else
		cached_item = user.pulling
		if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
			liquid_container = cached_item

	if(liquid_container)
		message = list("milks %TARGET%'s breasts into \the [liquid_container].")
		. = ..()
		message = original_messages
		return

	// Handle different intents
	switch(resolve_intent_name(user))
		if("harm")
			message = list(
				"aggressively gropes %TARGET%'s breast.",
				"grabs %TARGET%'s breasts.",
				"tightly squeezes %TARGET%'s breasts.",
				"slaps at %TARGET%'s breasts.",
				"gropes %TARGET%'s breasts roughly."
			)
		if("disarm")
			message = list(
				"playfully bats at %TARGET%'s breasts.",
				"teasingly gropes %TARGET%'s breasts.",
				"playfully squeezes %TARGET%'s breasts.",
				"mischievously fondles %TARGET%'s breasts.",
				"impishly teases %TARGET%'s nipples."
			)
		if("grab")
			message = list(
				"firmly grips %TARGET%'s breasts.",
				"possessively gropes %TARGET%'s breasts.",
				"eagerly kneads %TARGET%'s breasts.",
				"roughly fondles %TARGET%'s breasts.",
				"greedily squeezes %TARGET%'s breasts."
			)
	. = ..()
	message = original_messages

/datum/interaction/lewd/titgrope/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	var/obj/item/liquid_container

	var/obj/item/cached_item = user.get_active_held_item()
	if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
		liquid_container = cached_item
	else
		cached_item = user.pulling
		if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
			liquid_container = cached_item

	if(liquid_container)
		var/obj/item/organ/genital/breasts/breasts = target.get_organ_slot(ORGAN_SLOT_BREASTS)
		if(breasts?.internal_fluid_datum)
			// Calculate milk amount based on how full the breasts are (0.5 to 2 multiplier)
			var/milk_multiplier = 0.5
			if(breasts.internal_fluid_maximum > 0)
				milk_multiplier = 0.5 + (1.5 * (breasts.reagents.total_volume / breasts.internal_fluid_maximum))

			var/transfer_amount = rand(1, 3 * milk_multiplier)
			var/datum/reagents/R = new(breasts.internal_fluid_maximum)
			breasts.reagents.trans_to(R, transfer_amount)
			R.trans_to(liquid_container, R.total_volume, transferred_by = user)
			qdel(R)

	// Handle arousal effects based on intent
	var/intent = resolve_intent_name(user)
	if(intent != "harm" && prob(5 + target.arousal))
		var/list/arousal_messages
		switch(intent)
			if("help")
				arousal_messages = list(
					"%TARGET% shivers in arousal.",
					"%TARGET% moans quietly.",
					"%TARGET% breathes out a soft moan.",
					"%TARGET% gasps.",
					"%TARGET% shudders softly.",
					"%TARGET% trembles as hands run across bare skin."
				)
			if("disarm")
				arousal_messages = list(
					"%TARGET% playfully squirms.",
					"%TARGET% lets out a teasing giggle.",
					"%TARGET% bites their lip.",
					"%TARGET% wiggles teasingly.",
					"%TARGET% gives a flirtatious gasp."
				)
			if("grab")
				arousal_messages = list(
					"%TARGET% moans eagerly.",
					"%TARGET% presses into the touch.",
					"%TARGET% lets out a wanting groan.",
					"%TARGET% quivers with excitement.",
					"%TARGET% shivers with anticipation."
				)

		if(arousal_messages)
			var/target_message = list(pick(arousal_messages))
			target.visible_message(span_lewd(replacetext(target_message, "%TARGET%", target)))

/datum/interaction/lewd/breast_smother
	name = "Breast Smother"
	description = "Smother them with your breasts. (Warning: Causes oxygen damage)"
	interaction_requires = list(INTERACTION_REQUIRE_TARGET_MOUTH)
	user_required_parts = list(ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_EXPOSED)
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

/datum/interaction/lewd/breast_smother/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	// Check if smothering is enabled in preferences
	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(user) && !user.client && !SSinteractions.is_blacklisted(user)))
		return FALSE
	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/smothering) && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return FALSE

	return TRUE

/datum/interaction/lewd/breast_smother/act(mob/living/user, mob/living/target)
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
				"presses their breasts hard against %TARGET%'s face, crushing their nose.",
				"forces %TARGET%'s face deep into their cleavage, smothering them completely.",
				"squeezes their breasts tight around %TARGET%'s face, blocking airways.",
				"grinds their chest down onto %TARGET%'s face, smothering them.",
				"presses their full cleavage over %TARGET%'s face, cutting off all air.",
				"wraps their arms around %TARGET%'s head and presses them into their chest.",
				"crushes %TARGET%'s face between their breasts tightly.",
				"shoves their cleavage into %TARGET%'s face forcefully."
			)
		if("grab")
			// Moderate smother
			target_arousal = 8
			target_pleasure = 6
			user_arousal = 6
			user_pleasure = 5
			message = list(
				"wraps their arms around %TARGET%'s head, pulling them into their cleavage.",
				"presses their breasts tight against %TARGET%'s face, smothering them.",
				"grinds their chest into %TARGET%'s face, blocking their airways.",
				"wraps their arms around %TARGET%'s head and squeezes them into their chest.",
				"presses their cleavage firmly against %TARGET%'s face.",
				"pulls %TARGET%'s face into their breasts.",
				"holds %TARGET%'s head against their chest tightly.",
				"presses their breasts over %TARGET%'s face."
			)
		else // help
			// Gentle smother
			message = list(
				"gently presses their breasts against %TARGET%'s face.",
				"carefully covers %TARGET%'s face with their cleavage.",
				"lays their breasts over %TARGET%'s face softly.",
				"gently wraps their chest around %TARGET%'s face.",
				"carefully lowers their breasts onto %TARGET%'s face.",
				"gently places their cleavage over %TARGET%'s nose and mouth.",
				"softly presses their chest against %TARGET%'s face.",
				"gently settles their breasts over %TARGET%'s face."
			)

	// Check for choke slut trait
	if(HAS_TRAIT(target, TRAIT_CHOKE_SLUT))
		if(intent == "harm")
			target_arousal += 10
			target_pleasure += 6
			to_chat(target, span_purple("You can't breathe with their breasts crushing your face... it's amazing!"))
		else
			target_arousal += 8
			target_pleasure += 4
			to_chat(target, span_purple("You can barely breathe with their breasts on your face... it's incredible!"))

	. = ..()

/datum/interaction/lewd/breast_smother/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	if(!istype(user))
		return

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
		message = list("%TARGET% passes out under %USER%'s breasts.")

/datum/interaction/lewd/do_boobjob
	name = "Give Boobjob"
	description = "Give them a boobjob."
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	user_required_parts = list(ORGAN_SLOT_BREASTS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_message_text_overrides = list(CLIMAX_POSITION_TARGET = list(
		"%CUMMING% cums all over %CAME_IN%'s breasts",
		"%CUMMING% shoots their load onto %CAME_IN%'s tits",
		"%CUMMING% covers %CAME_IN%'s chest in cum"
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_TARGET = list(
		"%CUMMING% cums all over your breasts",
		"%CUMMING% shoots their load onto your tits",
		"%CUMMING% covers your chest in cum"
	))
	cum_partner_text_overrides = list(CLIMAX_POSITION_TARGET = list(
		"You cum all over %CAME_IN%'s breasts",
		"You shoot your load onto %CAME_IN%'s tits",
		"You cover %CAME_IN%'s chest in cum"
	))
	message = list(
		"wraps their breasts around %TARGET%'s cock",
		"works %TARGET%'s shaft between their tits",
		"pleasures %TARGET% with their breasts",
		"squeezes their breasts around %TARGET%'s cock"
	)
	user_messages = list(
		"You feel %TARGET%'s cock throbbing between your breasts",
		"The warmth of %TARGET%'s shaft feels nice between your tits",
		"You squeeze your breasts around %TARGET%'s cock"
	)
	target_messages = list(
		"%USER%'s soft breasts squeeze your cock",
		"Your shaft slides between %USER%'s tits",
		"The softness of %USER%'s breasts feels amazing"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/DryFlop1.ogg',
		'modular_zzplurt/sound/interactions/DryFlop2.ogg',
		'modular_zzplurt/sound/interactions/DryFlop3.ogg',
		'modular_zzplurt/sound/interactions/DryFlop4.ogg',
		'modular_zzplurt/sound/interactions/DryFlop5.ogg',
		'modular_zzplurt/sound/interactions/DryFlop6.ogg',
		'modular_zzplurt/sound/interactions/DryFlop7.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 4
	user_arousal = 4
	target_arousal = 6
