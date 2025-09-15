/datum/interaction/lewd/handjob
	name = "Handjob"
	description = "Jerk them off."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_TARGET = null)
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	message = list(
		"jerks %TARGET% off",
		"works %TARGET%'s shaft",
		"wanks %TARGET%'s cock hard"
	)
	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"cums all over %USER%'s hand.",
			"shoots their load onto %USER%'s palm.",
			"covers %USER%'s fingers in cum."
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"you cum all over %USER%'s hand.",
			"you shoot your load onto %USER%'s palm.",
			"you cover %USER%'s fingers in cum."
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%TARGET% cums all over your hand.",
			"%TARGET% shoots their load onto your palm.",
			"%TARGET% covers your fingers in cum."
		)
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	user_arousal = 3
	target_pleasure = 4
	target_arousal = 6

/datum/interaction/lewd/handjob/act(mob/living/user, mob/living/target)
	var/obj/item/liquid_container

	// Check active hand first
	var/obj/item/cached_item = user.get_active_held_item()
	if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
		liquid_container = cached_item
	else
		// Check if pulling a container
		cached_item = user.pulling
		if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
			liquid_container = cached_item

	// Add container text to message if needed
	if(liquid_container)
		var/list/original_messages = message.Copy()
		var/chosen_message = pick(message)
		LAZYADD(fluid_transfer_objects, list("[REF(target)]" = liquid_container))
		message = list("[chosen_message] over \the [liquid_container]")
		. = ..()
		LAZYREMOVE(fluid_transfer_objects, REF(target))
		message = original_messages
	else
		. = ..()
