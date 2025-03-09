/datum/interaction/lewd/portal/handjob
	name = "Portal Handjob"
	description = "Give them a handjob through the portal dildo."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_ANY)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_TARGET = null)
	message = list(
		"strokes %TARGET%'s cock through the portal fleshlight",
		"works %TARGET%'s shaft with their hand through the portal dildo",
		"rubs %TARGET%'s penis through the portal dildo",
		"gives %TARGET%'s member a handjob through the portal dildo"
	)
	user_messages = list(
		"You feel %TARGET%'s cock throbbing in your hand through the portal",
		"The warmth of %TARGET%'s shaft pulses in your grip through the portal",
		"You work %TARGET%'s penis with your hand through the portal dildo"
	)
	target_messages = list(
		"You feel %USER%'s hand stroking your cock through the portal panties",
		"%USER%'s fingers wrap around your shaft through the portal",
		"%USER%'s hand works your penis through the portal"
	)

	hidden_message = list(
		"strokes the portal dildo's cock",
		"works the portal dildo's shaft with their hand",
		"rubs the portal dildo's penis",
		"gives the portal dildo's member a handjob"
	)
	hidden_user_messages = list(
		"You feel the cock throbbing in your hand through the portal",
		"The warmth of the shaft pulses in your grip through the portal",
		"You work the penis with your hand through the portal dildo"
	)
	hidden_target_messages = list(
		"You feel a hand stroking your cock through the portal panties",
		"Fingers wrap around your shaft through the portal",
		"A hand works your penis through the portal"
	)

	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%CUMMING%'s cock throbs in %CAME_IN%'s hand as they cum through the portal",
			"%CUMMING% shoots their seed over %CAME_IN%'s hand through the portal",
			"%CUMMING% climaxes hard in %CAME_IN%'s grip through the portal"
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your cock throbs in %CAME_IN%'s hand as you cum through the portal",
			"You shoot your seed over %CAME_IN%'s hand through the portal",
			"You climax hard in %CAME_IN%'s grip through the portal"
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel %CUMMING%'s cock throb in your hand as they cum through the portal",
			"%CUMMING% shoots their seed over your hand through the portal dildo",
			"Your hand is coated with %CUMMING%'s warm cum through the portal"
		)
	)

	hidden_cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"The portal panties' cock throbs in the hand as they cum",
			"The wearer shoots their seed through the portal",
			"The portal panties' user climaxes hard"
		)
	)
	hidden_cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your cock throbs in the hand as you cum through the portal",
			"You shoot your seed through the portal",
			"You climax hard through the portal"
		)
	)
	hidden_cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel the cock throb in your hand as they cum through the portal",
			"Warm cum shoots over your hand through the portal dildo",
			"Your hand is coated with cum through the portal"
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
	target_pleasure = 4
	user_arousal = 2
	target_arousal = 6

/datum/interaction/lewd/portal/finger_vagina
	name = "Portal Fingering (Vagina)"
	description = "Finger their pussy through the portal fleshlight."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	target_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_ANY)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_VAGINA)
	cum_target = list(CLIMAX_POSITION_TARGET = null)
	message = list(
		"fingers %TARGET%'s pussy through the portal fleshlight",
		"works their fingers in %TARGET%'s vagina through the portal fleshlight",
		"rubs %TARGET%'s wet hole through the portal fleshlight",
		"slides their fingers into %TARGET%'s pussy through the portal fleshlight"
	)
	user_messages = list(
		"You feel %TARGET%'s warm pussy around your fingers through the portal",
		"The wetness of %TARGET%'s vagina coats your fingers through the portal",
		"You work your fingers in %TARGET%'s pussy through the portal fleshlight"
	)
	target_messages = list(
		"You feel %USER%'s fingers inside your pussy through the portal panties",
		"%USER%'s fingers slide into your vagina through the portal",
		"%USER%'s fingers work your pussy through the portal"
	)

	hidden_message = list(
		"fingers the portal fleshlight's pussy",
		"works their fingers in the portal fleshlight's vagina",
		"rubs the portal fleshlight's wet hole",
		"slides their fingers into the portal fleshlight's pussy"
	)
	hidden_user_messages = list(
		"You feel the warm pussy around your fingers through the portal",
		"The wetness coats your fingers through the portal",
		"You work your fingers in the vagina through the portal fleshlight"
	)
	hidden_target_messages = list(
		"You feel fingers inside your pussy through the portal panties",
		"Fingers slide into your vagina through the portal",
		"Fingers work your pussy through the portal"
	)

	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%CUMMING%'s pussy quivers around %CAME_IN%'s fingers as they cum through the portal",
			"%CUMMING% climaxes hard on %CAME_IN%'s fingers through the portal",
			"%CUMMING%'s vagina contracts in orgasm around %CAME_IN%'s fingers through the portal"
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your pussy quivers around %CAME_IN%'s fingers as you cum through the portal",
			"You climax hard on %CAME_IN%'s fingers through the portal",
			"Your vagina contracts in orgasm around %CAME_IN%'s fingers through the portal"
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel %CUMMING%'s pussy quiver around your fingers as they cum through the portal",
			"%CUMMING% climaxes on your fingers through the portal fleshlight",
			"The portal fleshlight's pussy contracts around your fingers as %CUMMING% cums"
		)
	)

	hidden_cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"The portal panties' pussy quivers around the fingers as they cum",
			"The wearer climaxes hard through the portal",
			"The portal panties' vagina contracts in orgasm"
		)
	)
	hidden_cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your pussy quivers around the fingers as you cum through the portal",
			"You climax hard through the portal",
			"Your vagina contracts in orgasm through the portal"
		)
	)
	hidden_cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel the pussy quiver around your fingers as they cum through the portal",
			"The portal fleshlight's user climaxes on your fingers",
			"The portal fleshlight's pussy contracts around your fingers"
		)
	)

	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ_fingering.ogg',
		'modular_zzplurt/sound/interactions/champ2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 4
	user_arousal = 2
	target_arousal = 6

/datum/interaction/lewd/portal/finger_anus
	name = "Portal Fingering (Anus)"
	description = "Finger their ass through the portal fleshlight."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	target_required_parts = list(ORGAN_SLOT_ANUS = REQUIRE_GENITAL_ANY)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_BOTH)
	cum_target = list(CLIMAX_POSITION_TARGET = null)
	message = list(
		"fingers %TARGET%'s ass through the portal fleshlight",
		"works their fingers in %TARGET%'s anus through the portal fleshlight",
		"rubs %TARGET%'s tight hole through the portal fleshlight",
		"slides their fingers into %TARGET%'s ass through the portal fleshlight"
	)
	user_messages = list(
		"You feel %TARGET%'s tight ass around your fingers through the portal",
		"The warmth of %TARGET%'s anus envelops your fingers through the portal",
		"You work your fingers in %TARGET%'s ass through the portal fleshlight"
	)
	target_messages = list(
		"You feel %USER%'s fingers inside your ass through the portal panties",
		"%USER%'s fingers slide into your anus through the portal",
		"%USER%'s fingers work your ass through the portal"
	)

	hidden_message = list(
		"fingers the portal fleshlight's ass",
		"works their fingers in the portal fleshlight's anus",
		"rubs the portal fleshlight's tight hole",
		"slides their fingers into the portal fleshlight's ass"
	)
	hidden_user_messages = list(
		"You feel the tight ass around your fingers through the portal",
		"The warmth envelops your fingers through the portal",
		"You work your fingers in the anus through the portal fleshlight"
	)
	hidden_target_messages = list(
		"You feel fingers inside your ass through the portal panties",
		"Fingers slide into your anus through the portal",
		"Fingers work your ass through the portal"
	)

	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%CUMMING%'s ass squeezes around %CAME_IN%'s fingers as they cum through the portal",
			"%CUMMING% climaxes hard on %CAME_IN%'s fingers through the portal",
			"%CUMMING%'s anus contracts in orgasm around %CAME_IN%'s fingers through the portal"
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your ass squeezes around %CAME_IN%'s fingers as you cum through the portal",
			"You climax hard on %CAME_IN%'s fingers through the portal",
			"Your anus contracts in orgasm around %CAME_IN%'s fingers through the portal"
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel %CUMMING%'s ass squeeze around your fingers as they cum through the portal",
			"%CUMMING% climaxes on your fingers through the portal fleshlight",
			"The portal fleshlight's anus contracts around your fingers as %CUMMING% cums"
		)
	)

	hidden_cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"The portal panties' ass squeezes around the fingers as they cum",
			"The wearer climaxes hard through the portal",
			"The portal panties' anus contracts in orgasm"
		)
	)
	hidden_cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your ass squeezes around the fingers as you cum through the portal",
			"You climax hard through the portal",
			"Your anus contracts in orgasm through the portal"
		)
	)
	hidden_cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel the ass squeeze around your fingers as they cum through the portal",
			"The portal fleshlight's user climaxes on your fingers",
			"The portal fleshlight's anus contracts around your fingers"
		)
	)

	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ_fingering.ogg',
		'modular_zzplurt/sound/interactions/champ2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 3
	user_arousal = 2
	target_arousal = 4
	target_pain = 1

/datum/interaction/lewd/portal/finger_mouth
	name = "Portal Fingering (Mouth)"
	description = "Play with their mouth through the portal fleshlight."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND, INTERACTION_REQUIRE_TARGET_MOUTH)
	message = list(
		"plays with %TARGET%'s mouth through the portal fleshlight",
		"slides their fingers into %TARGET%'s mouth through the portal fleshlight",
		"rubs %TARGET%'s tongue through the portal fleshlight",
		"explores %TARGET%'s mouth with their fingers through the portal fleshlight"
	)
	user_messages = list(
		"You feel %TARGET%'s warm mouth around your fingers through the portal",
		"The wetness of %TARGET%'s tongue coats your fingers through the portal",
		"You play with %TARGET%'s mouth through the portal fleshlight"
	)
	target_messages = list(
		"You feel %USER%'s fingers inside your mouth through the portal panties",
		"%USER%'s fingers slide over your tongue through the portal",
		"%USER%'s fingers explore your mouth through the portal"
	)

	hidden_message = list(
		"plays with the portal fleshlight's mouth",
		"slides their fingers into the portal fleshlight's mouth",
		"rubs the portal fleshlight's tongue",
		"explores the portal fleshlight's mouth with their fingers"
	)
	hidden_user_messages = list(
		"You feel the warm mouth around your fingers through the portal",
		"The wetness of the tongue coats your fingers through the portal",
		"You play with the mouth through the portal fleshlight"
	)
	hidden_target_messages = list(
		"You feel fingers inside your mouth through the portal panties",
		"Fingers slide over your tongue through the portal",
		"Fingers explore your mouth through the portal"
	)

	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ_fingering.ogg',
		'modular_zzplurt/sound/interactions/champ2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 1
	user_arousal = 2
	target_arousal = 2

/datum/interaction/lewd/portal/finger_urethra
	name = "Portal Fingering (Urethra)"
	description = "Finger their urethra through the portal dildo."
	interaction_requires = list(INTERACTION_REQUIRE_SELF_HAND)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_ANY)
	cum_genital = list(CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_TARGET = null)
	message = list(
		"fingers %TARGET%'s urethra through the portal dildo",
		"works their fingers in %TARGET%'s cock through the portal dildo",
		"rubs inside %TARGET%'s penis through the portal dildo",
		"slides their fingers into %TARGET%'s urethra through the portal dildo"
	)
	user_messages = list(
		"You feel %TARGET%'s urethra around your fingers through the portal",
		"The warmth of %TARGET%'s cock envelops your fingers through the portal",
		"You work your fingers in %TARGET%'s urethra through the portal dildo"
	)
	target_messages = list(
		"You feel %USER%'s fingers inside your urethra through the portal panties",
		"%USER%'s fingers slide into your cock through the portal",
		"%USER%'s fingers work your urethra through the portal"
	)

	hidden_message = list(
		"fingers the portal dildo's urethra",
		"works their fingers in the portal dildo's cock",
		"rubs inside the portal dildo's penis",
		"slides their fingers into the portal dildo's urethra"
	)
	hidden_user_messages = list(
		"You feel the urethra around your fingers through the portal",
		"The warmth envelops your fingers through the portal",
		"You work your fingers in the cock through the portal dildo"
	)
	hidden_target_messages = list(
		"You feel fingers inside your urethra through the portal panties",
		"Fingers slide into your cock through the portal",
		"Fingers work your urethra through the portal"
	)

	cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"%CUMMING%'s cock throbs around %CAME_IN%'s fingers as they cum through the portal",
			"%CUMMING% climaxes hard on %CAME_IN%'s fingers through the portal",
			"%CUMMING%'s urethra contracts in orgasm around %CAME_IN%'s fingers through the portal dildo"
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your cock throbs around %CAME_IN%'s fingers as you cum through the portal",
			"You climax hard on %CAME_IN%'s fingers through the portal",
			"Your urethra contracts in orgasm around %CAME_IN%'s fingers through the portal dildo"
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel %CUMMING%'s cock throb around your fingers as they cum through the portal",
			"%CUMMING% climaxes on your fingers through the portal dildo",
			"The portal dildo's urethra contracts around your fingers as %CUMMING% cums"
		)
	)

	hidden_cum_message_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"The portal panties' cock throbs around the fingers as they cum",
			"The wearer climaxes hard through the portal",
			"The portal panties' urethra contracts in orgasm"
		)
	)
	hidden_cum_self_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"Your cock throbs around the fingers as you cum through the portal",
			"You climax hard through the portal",
			"Your urethra contracts in orgasm through the portal"
		)
	)
	hidden_cum_partner_text_overrides = list(
		CLIMAX_POSITION_TARGET = list(
			"You feel the cock throb around your fingers as they cum through the portal",
			"The portal dildo's user climaxes on your fingers",
			"The portal dildo's urethra contracts around your fingers"
		)
	)

	sound_possible = list(
		'modular_zzplurt/sound/interactions/champ_fingering.ogg',
		'modular_zzplurt/sound/interactions/champ2.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 0
	target_pleasure = 3
	user_arousal = 2
	target_arousal = 4
	target_pain = 2
