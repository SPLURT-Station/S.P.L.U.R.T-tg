/datum/interaction/lewd/finger_self_vagina
	name = "Finger Pussy (self)"
	description = "Finger your own pussy."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	user_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	usage = INTERACTION_SELF
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_VAGINA)
	additional_details = list(INTERACTION_FILLS_CONTAINERS)
	cum_message_text_overrides = list(CLIMAX_POSITION_USER = list(
		"cums hard on their fingers",
		"shudders as they cum on their hand",
		"fingers themself to climax"
	))
	cum_self_text_overrides = list(CLIMAX_POSITION_USER = list(
		"You cum hard on your fingers",
		"You shudder as you cum on your hand",
		"You finger yourself to climax"
	))
	message = list(
		"fingers their pussy deep",
		"fingers their pussy",
		"plays with their pussy",
		"fingers their own pussy hard"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ_fingering.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 4
	user_arousal = 6

/datum/interaction/lewd/finger_self_vagina/act(mob/living/user, mob/living/target)
	var/obj/item/liquid_container

	var/obj/item/cached_item = user.get_active_held_item()
	if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
		liquid_container = cached_item
	else
		cached_item = user.pulling
		if(istype(cached_item) && cached_item.is_refillable() && cached_item.is_drainable())
			liquid_container = cached_item

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

/datum/interaction/lewd/finger_self_anus
	name = "Finger Ass (self)"
	description = "Finger your own ass."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	user_required_parts = list(ORGAN_SLOT_ANUS = REQUIRE_GENITAL_EXPOSED)
	usage = INTERACTION_SELF
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_BOTH)
	message = list(
		"fingers themself",
		"fingers their asshole",
		"fingers themself hard"
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ_fingering.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 3
	user_arousal = 5
