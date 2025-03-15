/datum/interaction/lewd/portal/feet
	interaction_requires = list(INTERACTION_REQUIRE_SELF_FEET)

/datum/interaction/lewd/portal/feet/show_climax(mob/living/cumming, mob/living/came_in, position)
	var/obj/item/clothing/shoes/worn_shoes = came_in.get_item_by_slot(ITEM_SLOT_FEET)
	var/feet_text = worn_shoes?.name || pick("bare feet", "toes", "soles")

	var/list/original_messages = cum_message_text_overrides.Copy()
	var/list/original_self_messages = cum_self_text_overrides.Copy()
	var/list/original_partner_messages = cum_partner_text_overrides.Copy()
	var/list/original_hidden_messages = hidden_cum_message_text_overrides.Copy()
	var/list/original_hidden_self_messages = hidden_cum_self_text_overrides.Copy()
	var/list/original_hidden_partner_messages = hidden_cum_partner_text_overrides.Copy()

	// Replace %FEET% in climax messages for the given position
	if(length(cum_message_text_overrides[position]))
		var/message = pick(cum_message_text_overrides[position])
		message = replacetext(message, "%FEET%", feet_text)
		cum_message_text_overrides[position] = list(message)

	if(length(cum_self_text_overrides[position]))
		var/message = pick(cum_self_text_overrides[position])
		message = replacetext(message, "%FEET%", feet_text)
		cum_self_text_overrides[position] = list(message)

	if(length(cum_partner_text_overrides[position]))
		var/message = pick(cum_partner_text_overrides[position])
		message = replacetext(message, "%FEET%", feet_text)
		cum_partner_text_overrides[position] = list(message)

	if(length(hidden_cum_message_text_overrides[position]))
		var/message = pick(hidden_cum_message_text_overrides[position])
		message = replacetext(message, "%FEET%", feet_text)
		hidden_cum_message_text_overrides[position] = list(message)

	if(length(hidden_cum_self_text_overrides[position]))
		var/message = pick(hidden_cum_self_text_overrides[position])
		message = replacetext(message, "%FEET%", feet_text)
		hidden_cum_self_text_overrides[position] = list(message)

	if(length(hidden_cum_partner_text_overrides[position]))
		var/message = pick(hidden_cum_partner_text_overrides[position])
		message = replacetext(message, "%FEET%", feet_text)
		hidden_cum_partner_text_overrides[position] = list(message)

	. = ..()

	// Restore original messages
	cum_message_text_overrides = original_messages
	cum_self_text_overrides = original_self_messages
	cum_partner_text_overrides = original_partner_messages
	hidden_cum_message_text_overrides = original_hidden_messages
	hidden_cum_self_text_overrides = original_hidden_self_messages
	hidden_cum_partner_text_overrides = original_hidden_partner_messages

/datum/interaction/lewd/portal/feet/act(mob/living/user, mob/living/target)
	var/list/original_messages = message.Copy()
	var/list/original_user_messages = user_messages.Copy()
	var/list/original_target_messages = target_messages.Copy()
	var/list/original_hidden_messages = hidden_message.Copy()
	var/list/original_hidden_user_messages = hidden_user_messages.Copy()
	var/list/original_hidden_target_messages = hidden_target_messages.Copy()

	var/obj/item/clothing/shoes/worn_shoes = user.get_item_by_slot(ITEM_SLOT_FEET)
	var/feet_text = worn_shoes?.name || pick("bare feet", "toes", "soles")

	// Replace %FEET% in messages
	if(length(message))
		var/chosen_message = pick(message)
		message = list(replacetext(chosen_message, "%FEET%", feet_text))

	if(length(user_messages))
		var/chosen_message = pick(user_messages)
		user_messages = list(replacetext(chosen_message, "%FEET%", feet_text))

	if(length(target_messages))
		var/chosen_message = pick(target_messages)
		target_messages = list(replacetext(chosen_message, "%FEET%", feet_text))

	if(length(hidden_message))
		var/chosen_message = pick(hidden_message)
		hidden_message = list(replacetext(chosen_message, "%FEET%", feet_text))

	if(length(hidden_user_messages))
		var/chosen_message = pick(hidden_user_messages)
		hidden_user_messages = list(replacetext(chosen_message, "%FEET%", feet_text))

	if(length(hidden_target_messages))
		var/chosen_message = pick(hidden_target_messages)
		hidden_target_messages = list(replacetext(chosen_message, "%FEET%", feet_text))

	. = ..()

	// Restore original messages
	message = original_messages
	user_messages = original_user_messages
	target_messages = original_target_messages
	hidden_message = original_hidden_messages
	hidden_user_messages = original_hidden_user_messages
	hidden_target_messages = original_hidden_target_messages

/datum/interaction/lewd/portal/feet/footjob
	name = "Portal Footjob"
	description = "Give them a footjob through the portal dildo."
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_ANY)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_TARGET = null)
	message = list(
		"rubs %TARGET%'s cock with their %FEET% through the portal dildo",
		"works %TARGET%'s shaft with their %FEET% through the portal dildo",
		"grinds their %FEET% against %TARGET%'s penis through the portal dildo",
		"gives %TARGET%'s member a footjob through the portal dildo"
	)
	user_messages = list(
		"You feel %TARGET%'s cock throbbing against your %FEET% through the portal",
		"The warmth of %TARGET%'s shaft pulses against your %FEET% through the portal",
		"You work %TARGET%'s penis with your %FEET% through the portal dildo"
	)
	target_messages = list(
		"You feel %USER%'s %FEET% rubbing your cock through the portal panties",
		"%USER%'s %FEET% press against your shaft through the portal",
		"%USER%'s %FEET% work your penis through the portal"
	)

	hidden_message = list(
		"rubs the portal dildo's cock with their %FEET%",
		"works the portal dildo's shaft with their %FEET%",
		"grinds their %FEET% against the portal dildo's penis",
		"gives the portal dildo's member a footjob"
	)
	hidden_user_messages = list(
		"You feel the cock throbbing against your %FEET% through the portal",
		"The warmth of the shaft pulses against your %FEET% through the portal",
		"You work the penis with your %FEET% through the portal dildo"
	)
	hidden_target_messages = list(
		"You feel %FEET% rubbing your cock through the portal panties",
		"%FEET% press against your shaft through the portal",
		"%FEET% work your penis through the portal"
	)

	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%CUMMING%'s cock throbs against %CAME_IN%'s %FEET% as they cum through the portal",
			"%CUMMING% shoots their seed over %CAME_IN%'s %FEET% through the portal",
			"%CUMMING% climaxes hard on %CAME_IN%'s %FEET% through the portal"
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your cock throbs against %CAME_IN%'s %FEET% as you cum through the portal",
			"You shoot your seed over %CAME_IN%'s %FEET% through the portal",
			"You climax hard on %CAME_IN%'s %FEET% through the portal"
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel %CUMMING%'s cock throb against your %FEET% as they cum through the portal",
			"%CUMMING% shoots their seed over your %FEET% through the portal dildo",
			"Your %FEET% are coated with %CUMMING%'s warm cum through the portal"
		)
	)

	hidden_cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"The portal panties' cock throbs against the %FEET% as they cum",
			"The wearer shoots their seed over the %FEET% through the portal",
			"The portal panties' user climaxes hard on the %FEET%"
		)
	)
	hidden_cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your cock throbs against the %FEET% as you cum through the portal",
			"You shoot your seed over the %FEET% through the portal",
			"You climax hard on the %FEET% through the portal"
		)
	)
	hidden_cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel the cock throb against your %FEET% as they cum through the portal",
			"Warm cum shoots over your %FEET% through the portal dildo",
			"Your %FEET% are coated with cum through the portal"
		)
	)

	sound_possible = list(
		'modular_zzplurt/sound/interactions/foot_dry1.ogg',
		'modular_zzplurt/sound/interactions/foot_dry3.ogg',
		'modular_zzplurt/sound/interactions/foot_wet1.ogg',
		'modular_zzplurt/sound/interactions/foot_wet2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 3
	user_arousal = 2
	target_arousal = 4

/datum/interaction/lewd/portal/feet/footgrind_vagina
	name = "Portal Foot Grind (Vagina)"
	description = "Grind your foot against their pussy through the portal fleshlight."
	target_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_ANY)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_VAGINA)
	cum_target = list(CLIMAX_POSITION_TARGET = null)
	message = list(
		"grinds their %FEET% against %TARGET%'s pussy through the portal fleshlight",
		"rubs their %FEET% on %TARGET%'s vagina through the portal fleshlight",
		"works their %FEET% against %TARGET%'s wet hole through the portal fleshlight",
		"presses their %FEET% into %TARGET%'s pussy through the portal fleshlight"
	)
	user_messages = list(
		"You feel %TARGET%'s warm pussy against your %FEET% through the portal",
		"The wetness of %TARGET%'s vagina coats your %FEET% as you grind through the portal",
		"You work your %FEET% against %TARGET%'s pussy through the portal fleshlight"
	)
	target_messages = list(
		"You feel %USER%'s %FEET% grinding against your pussy through the portal panties",
		"%USER%'s %FEET% rub against your vagina through the portal",
		"%USER%'s %FEET% work your pussy through the portal"
	)

	hidden_message = list(
		"grinds their %FEET% against the portal fleshlight's pussy",
		"rubs their %FEET% on the portal fleshlight's vagina",
		"works their %FEET% against the portal fleshlight's wet hole",
		"presses their %FEET% into the portal fleshlight's pussy"
	)
	hidden_user_messages = list(
		"You feel the warm pussy against your %FEET% through the portal",
		"The wetness coats your %FEET% as you grind through the portal",
		"You work your %FEET% against the vagina through the portal fleshlight"
	)
	hidden_target_messages = list(
		"You feel %FEET% grinding against your pussy through the portal panties",
		"%FEET% rub against your vagina through the portal",
		"%FEET% work your pussy through the portal"
	)

	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%CUMMING%'s pussy quivers against %CAME_IN%'s %FEET% as they cum through the portal",
			"%CUMMING% climaxes hard on %CAME_IN%'s %FEET% through the portal",
			"%CUMMING%'s vagina contracts in orgasm around %CAME_IN%'s %FEET% through the portal"
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your pussy quivers against %CAME_IN%'s %FEET% as you cum through the portal",
			"You climax hard on %CAME_IN%'s %FEET% through the portal",
			"Your vagina contracts in orgasm around %CAME_IN%'s %FEET% through the portal"
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel %CUMMING%'s pussy quiver against your %FEET% as they cum through the portal",
			"%CUMMING% climaxes on your %FEET% through the portal fleshlight",
			"The portal fleshlight's pussy contracts around your %FEET% as %CUMMING% cums"
		)
	)

	hidden_cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"The portal panties' pussy quivers against the %FEET% as they cum",
			"The wearer climaxes hard on the %FEET% through the portal",
			"The portal panties' vagina contracts in orgasm"
		)
	)
	hidden_cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your pussy quivers against the %FEET% as you cum through the portal",
			"You climax hard on the %FEET% through the portal",
			"Your vagina contracts in orgasm around the %FEET% through the portal"
		)
	)
	hidden_cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel the pussy quiver against your %FEET% as they cum through the portal",
			"The portal fleshlight's user climaxes on your %FEET%",
			"The portal fleshlight's pussy contracts around your %FEET%"
		)
	)

	sound_possible = list(
		'modular_zzplurt/sound/interactions/foot_wet1.ogg',
		'modular_zzplurt/sound/interactions/foot_wet2.ogg',
		'modular_zzplurt/sound/interactions/foot_wet3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 3
	user_arousal = 2
	target_arousal = 4

/datum/interaction/lewd/portal/feet/footgrind_anus
	name = "Portal Foot Grind (Anus)"
	description = "Grind your foot against their ass through the portal fleshlight."
	target_required_parts = list(ORGAN_SLOT_ANUS = REQUIRE_GENITAL_ANY)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_BOTH)
	cum_target = list(CLIMAX_POSITION_TARGET = null)
	message = list(
		"grinds their %FEET% against %TARGET%'s ass through the portal fleshlight",
		"rubs their %FEET% on %TARGET%'s anus through the portal fleshlight",
		"works their %FEET% against %TARGET%'s tight hole through the portal fleshlight",
		"presses their %FEET% into %TARGET%'s ass through the portal fleshlight"
	)
	user_messages = list(
		"You feel %TARGET%'s tight ass against your %FEET% through the portal",
		"The warmth of %TARGET%'s anus envelops your %FEET% as you grind through the portal",
		"You work your %FEET% against %TARGET%'s ass through the portal fleshlight"
	)
	target_messages = list(
		"You feel %USER%'s %FEET% grinding against your ass through the portal panties",
		"%USER%'s %FEET% rub against your anus through the portal",
		"%USER%'s %FEET% work your ass through the portal"
	)

	hidden_message = list(
		"grinds their %FEET% against the portal fleshlight's ass",
		"rubs their %FEET% on the portal fleshlight's anus",
		"works their %FEET% against the portal fleshlight's tight hole",
		"presses their %FEET% into the portal fleshlight's ass"
	)
	hidden_user_messages = list(
		"You feel the tight ass against your %FEET% through the portal",
		"The warmth envelops your %FEET% as you grind through the portal",
		"You work your %FEET% against the anus through the portal fleshlight"
	)
	hidden_target_messages = list(
		"You feel %FEET% grinding against your ass through the portal panties",
		"%FEET% rub against your anus through the portal",
		"%FEET% work your ass through the portal"
	)

	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%CUMMING%'s ass squeezes against %CAME_IN%'s %FEET% as they cum through the portal",
			"%CUMMING% climaxes hard on %CAME_IN%'s %FEET% through the portal",
			"%CUMMING%'s anus contracts in orgasm around %CAME_IN%'s %FEET% through the portal"
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your ass squeezes against %CAME_IN%'s %FEET% as you cum through the portal",
			"You climax hard on %CAME_IN%'s %FEET% through the portal",
			"Your anus contracts in orgasm around %CAME_IN%'s %FEET% through the portal"
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel %CUMMING%'s ass squeeze against your %FEET% as they cum through the portal",
			"%CUMMING% climaxes on your %FEET% through the portal fleshlight",
			"The portal fleshlight's anus contracts around your %FEET% as %CUMMING% cums"
		)
	)

	hidden_cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"The portal panties' ass squeezes against the %FEET% as they cum",
			"The wearer climaxes hard on the %FEET% through the portal",
			"The portal panties' anus contracts in orgasm"
		)
	)
	hidden_cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your ass squeezes against the %FEET% as you cum through the portal",
			"You climax hard on the %FEET% through the portal",
			"Your anus contracts in orgasm around the %FEET% through the portal"
		)
	)
	hidden_cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel the ass squeeze against your %FEET% as they cum through the portal",
			"The portal fleshlight's user climaxes on your %FEET%",
			"The portal fleshlight's anus contracts around your %FEET%"
		)
	)

	sound_possible = list(
		'modular_zzplurt/sound/interactions/foot_wet1.ogg',
		'modular_zzplurt/sound/interactions/foot_wet2.ogg',
		'modular_zzplurt/sound/interactions/foot_wet3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 2
	user_arousal = 2
	target_arousal = 3
	target_pain = 1
