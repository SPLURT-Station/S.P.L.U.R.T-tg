/datum/interaction/lewd/portal/oral_penis
	name = "Portal Oral (Penis)"
	description = "Suck their cock through the portal dildo."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_MOUTH)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_ANY)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_TARGET = CLIMAX_TARGET_MOUTH)
	message = list(
		"sucks %TARGET%'s cock through the portal dildo",
		"works %TARGET%'s shaft with their mouth through the portal dildo",
		"licks %TARGET%'s penis through the portal dildo",
		"gives %TARGET%'s member oral through the portal dildo"
	)
	user_messages = list(
		"You feel %TARGET%'s cock throbbing in your mouth through the portal",
		"The warmth of %TARGET%'s shaft pulses on your tongue through the portal",
		"You work %TARGET%'s penis with your mouth through the portal dildo"
	)
	target_messages = list(
		"You feel %USER%'s mouth around your cock through the portal panties",
		"%USER%'s tongue slides along your shaft through the portal",
		"%USER%'s mouth works your penis through the portal"
	)

	hidden_message = list(
		"sucks the portal dildo's cock",
		"works the portal dildo's shaft with their mouth",
		"licks the portal dildo's penis",
		"gives the portal dildo's member oral"
	)
	hidden_user_messages = list(
		"You feel the cock throbbing in your mouth through the portal",
		"The warmth of the shaft pulses on your tongue through the portal",
		"You work the penis with your mouth through the portal dildo"
	)
	hidden_target_messages = list(
		"You feel a mouth around your cock through the portal panties",
		"A tongue slides along your shaft through the portal",
		"A mouth works your penis through the portal"
	)

	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%CUMMING%'s cock throbs in %CAME_IN%'s mouth as they cum through the portal",
			"%CUMMING% shoots their seed into %CAME_IN%'s mouth through the portal",
			"%CUMMING% climaxes hard in %CAME_IN%'s mouth through the portal"
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your cock throbs in %CAME_IN%'s mouth as you cum through the portal",
			"You shoot your seed into %CAME_IN%'s mouth through the portal",
			"You climax hard in %CAME_IN%'s mouth through the portal"
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel %CUMMING%'s cock throb in your mouth as they cum through the portal",
			"%CUMMING% shoots their seed into your mouth through the portal dildo",
			"Your mouth is filled with %CUMMING%'s warm cum through the portal"
		)
	)

	hidden_cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"The portal panties' cock throbs in the mouth as they cum",
			"The wearer shoots their seed through the portal",
			"The portal panties' user climaxes hard"
		)
	)
	hidden_cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your cock throbs in the mouth as you cum through the portal",
			"You shoot your seed through the portal",
			"You climax hard through the portal"
		)
	)
	hidden_cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel the cock throb in your mouth as they cum through the portal",
			"Warm cum shoots into your mouth through the portal dildo",
			"Your mouth is filled with cum through the portal"
		)
	)

	sound_possible = list(
		'modular_zzplurt/sound/interactions/bj1.ogg',
		'modular_zzplurt/sound/interactions/bj2.ogg',
		'modular_zzplurt/sound/interactions/bj3.ogg',
		'modular_zzplurt/sound/interactions/bj4.ogg',
		'modular_zzplurt/sound/interactions/bj5.ogg',
		'modular_zzplurt/sound/interactions/bj6.ogg',
		'modular_zzplurt/sound/interactions/bj7.ogg',
		'modular_zzplurt/sound/interactions/bj8.ogg',
		'modular_zzplurt/sound/interactions/bj9.ogg',
		'modular_zzplurt/sound/interactions/bj10.ogg',
		'modular_zzplurt/sound/interactions/bj11.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 6
	user_arousal = 4
	target_arousal = 8

/datum/interaction/lewd/portal/oral_vagina
	name = "Portal Oral (Vagina)"
	description = "Lick their pussy through the portal fleshlight."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_MOUTH)
	target_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_ANY)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_VAGINA)
	cum_target = list(CLIMAX_POSITION_TARGET = CLIMAX_TARGET_MOUTH)
	message = list(
		"licks %TARGET%'s pussy through the portal fleshlight",
		"works %TARGET%'s vagina with their tongue through the portal fleshlight",
		"sucks %TARGET%'s clit through the portal fleshlight",
		"gives %TARGET%'s pussy oral through the portal fleshlight"
	)
	user_messages = list(
		"You feel %TARGET%'s warm pussy against your tongue through the portal",
		"The wetness of %TARGET%'s vagina coats your mouth through the portal",
		"You work %TARGET%'s pussy with your tongue through the portal fleshlight"
	)
	target_messages = list(
		"You feel %USER%'s tongue on your pussy through the portal panties",
		"%USER%'s mouth works your vagina through the portal",
		"%USER%'s tongue slides along your clit through the portal"
	)

	hidden_message = list(
		"licks the portal fleshlight's pussy",
		"works the portal fleshlight's vagina with their tongue",
		"sucks the portal fleshlight's clit",
		"gives the portal fleshlight's pussy oral"
	)
	hidden_user_messages = list(
		"You feel the warm pussy against your tongue through the portal",
		"The wetness coats your mouth through the portal",
		"You work the pussy with your tongue through the portal fleshlight"
	)
	hidden_target_messages = list(
		"You feel a tongue on your pussy through the portal panties",
		"A mouth works your vagina through the portal",
		"A tongue slides along your clit through the portal"
	)

	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%CUMMING%'s pussy quivers against %CAME_IN%'s tongue as they cum through the portal",
			"%CUMMING% climaxes hard on %CAME_IN%'s mouth through the portal",
			"%CUMMING%'s vagina contracts in orgasm around %CAME_IN%'s tongue through the portal"
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your pussy quivers against %CAME_IN%'s tongue as you cum through the portal",
			"You climax hard on %CAME_IN%'s mouth through the portal",
			"Your vagina contracts in orgasm around %CAME_IN%'s tongue through the portal"
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel %CUMMING%'s pussy quiver against your tongue as they cum through the portal",
			"%CUMMING% climaxes on your mouth through the portal fleshlight",
			"The portal fleshlight's pussy contracts around your tongue as %CUMMING% cums"
		)
	)

	hidden_cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"The portal panties' pussy quivers against the tongue as they cum",
			"The wearer climaxes hard through the portal",
			"The portal panties' vagina contracts in orgasm"
		)
	)
	hidden_cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your pussy quivers against the tongue as you cum through the portal",
			"You climax hard through the portal",
			"Your vagina contracts in orgasm through the portal"
		)
	)
	hidden_cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel the pussy quiver against your tongue as they cum through the portal",
			"The portal fleshlight's user climaxes on your mouth",
			"The portal fleshlight's pussy contracts around your tongue"
		)
	)

	sound_possible = list(
		'modular_zzplurt/sound/interactions/oral1.ogg',
		'modular_zzplurt/sound/interactions/oral2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 6
	user_arousal = 4
	target_arousal = 8

/datum/interaction/lewd/portal/oral_anus
	name = "Portal Oral (Anus)"
	description = "Rim their ass through the portal fleshlight."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_MOUTH)
	target_required_parts = list(ORGAN_SLOT_ANUS = REQUIRE_GENITAL_ANY)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_BOTH)
	cum_target = list(CLIMAX_POSITION_TARGET = null)
	message = list(
		"licks %TARGET%'s ass through the portal fleshlight",
		"works %TARGET%'s anus with their tongue through the portal fleshlight",
		"rims %TARGET%'s hole through the portal fleshlight",
		"gives %TARGET%'s ass oral through the portal fleshlight"
	)
	user_messages = list(
		"You feel %TARGET%'s tight ass against your tongue through the portal",
		"The warmth of %TARGET%'s anus envelops your tongue through the portal",
		"You work %TARGET%'s ass with your tongue through the portal fleshlight"
	)
	target_messages = list(
		"You feel %USER%'s tongue on your ass through the portal panties",
		"%USER%'s mouth works your anus through the portal",
		"%USER%'s tongue slides along your hole through the portal"
	)

	hidden_message = list(
		"licks the portal fleshlight's ass",
		"works the portal fleshlight's anus with their tongue",
		"rims the portal fleshlight's hole",
		"gives the portal fleshlight's ass oral"
	)
	hidden_user_messages = list(
		"You feel the tight ass against your tongue through the portal",
		"The warmth envelops your tongue through the portal",
		"You work the ass with your tongue through the portal fleshlight"
	)
	hidden_target_messages = list(
		"You feel a tongue on your ass through the portal panties",
		"A mouth works your anus through the portal",
		"A tongue slides along your hole through the portal"
	)

	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%CUMMING%'s ass squeezes against %CAME_IN%'s tongue as they cum through the portal",
			"%CUMMING% climaxes hard on %CAME_IN%'s mouth through the portal",
			"%CUMMING%'s anus contracts in orgasm around %CAME_IN%'s tongue through the portal"
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your ass squeezes against %CAME_IN%'s tongue as you cum through the portal",
			"You climax hard on %CAME_IN%'s mouth through the portal",
			"Your anus contracts in orgasm around %CAME_IN%'s tongue through the portal"
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel %CUMMING%'s ass squeeze against your tongue as they cum through the portal",
			"%CUMMING% climaxes on your mouth through the portal fleshlight",
			"The portal fleshlight's anus contracts around your tongue as %CUMMING% cums"
		)
	)

	hidden_cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"The portal panties' ass squeezes against the tongue as they cum",
			"The wearer climaxes hard through the portal",
			"The portal panties' anus contracts in orgasm"
		)
	)
	hidden_cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your ass squeezes against the tongue as you cum through the portal",
			"You climax hard through the portal",
			"Your anus contracts in orgasm through the portal"
		)
	)
	hidden_cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel the ass squeeze against your tongue as they cum through the portal",
			"The portal fleshlight's user climaxes on your mouth",
			"The portal fleshlight's anus contracts around your tongue"
		)
	)

	sound_possible = list(
		'modular_zzplurt/sound/interactions/oral1.ogg',
		'modular_zzplurt/sound/interactions/oral2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 4
	user_arousal = 4
	target_arousal = 6
	target_pain = 1

/datum/interaction/lewd/portal/oral_mouth
	name = "Portal Kiss"
	description = "Kiss them through the portal fleshlight."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_MOUTH, INTERACTION_REQUIRE_TARGET_MOUTH)
	message = list(
		"kisses %TARGET% through the portal fleshlight",
		"presses their lips against %TARGET%'s through the portal fleshlight",
		"makes out with %TARGET% through the portal fleshlight",
		"shares a passionate kiss with %TARGET% through the portal fleshlight"
	)
	user_messages = list(
		"You feel %TARGET%'s warm lips against yours through the portal",
		"The softness of %TARGET%'s mouth presses against yours through the portal",
		"You kiss %TARGET% deeply through the portal fleshlight"
	)
	target_messages = list(
		"You feel %USER%'s lips against yours through the portal panties",
		"%USER%'s mouth presses against yours through the portal",
		"%USER% kisses you deeply through the portal"
	)

	hidden_message = list(
		"kisses through the portal fleshlight",
		"presses their lips against the portal fleshlight",
		"makes out through the portal fleshlight",
		"shares a passionate kiss through the portal fleshlight"
	)
	hidden_user_messages = list(
		"You feel warm lips against yours through the portal",
		"The softness of a mouth presses against yours through the portal",
		"You kiss deeply through the portal fleshlight"
	)
	hidden_target_messages = list(
		"You feel lips against yours through the portal panties",
		"A mouth presses against yours through the portal",
		"Someone kisses you deeply through the portal"
	)

	sound_possible = list(
		'modular_zzplurt/sound/interactions/kiss1.ogg',
		'modular_zzplurt/sound/interactions/kiss2.ogg',
		'modular_zzplurt/sound/interactions/kiss3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 1
	target_pleasure = 1
	user_arousal = 2
	target_arousal = 2

/datum/interaction/lewd/portal/oral_mouth/post_interaction(mob/living/user, mob/living/target)
	. = ..()
	// Check if user has TRAIT_KISS_SLUT and increase their lust
	if(HAS_TRAIT(user, TRAIT_KISS_SLUT))
		user.adjust_pleasure(10, target, interaction = src, position = CLIMAX_POSITION_USER)
		user.adjust_arousal(10)
	// Check if target has TRAIT_KISS_SLUT and increase their lust
	if(HAS_TRAIT(target, TRAIT_KISS_SLUT))
		target.adjust_pleasure(10, user, interaction = src, position = CLIMAX_POSITION_TARGET)
		target.adjust_arousal(10)
