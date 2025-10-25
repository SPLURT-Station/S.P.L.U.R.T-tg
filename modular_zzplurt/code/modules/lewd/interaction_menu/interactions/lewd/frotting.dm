/datum/interaction/lewd/frotting
	name = "Frotting"
	description = "Rub your penis against theirs."
	user_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_PENIS = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS, CLIMAX_POSITION_TARGET = CLIMAX_PENIS)
	cum_target = list(CLIMAX_POSITION_USER = null, CLIMAX_POSITION_TARGET = null)
	cum_message_text_overrides = list(
		CLIMAX_POSITION_USER = list(
			"%CUMMING% cums all over %CAME_IN%'s cock.",
			"%CUMMING% shoots their load onto %CAME_IN%'s shaft.",
			"%CUMMING% covers %CAME_IN%'s penis with their cum."
		),
		CLIMAX_POSITION_TARGET = list(
			"%CUMMING% cums all over %CAME_IN%'s cock.",
			"%CUMMING% shoots their load onto %CAME_IN%'s shaft.",
			"%CUMMING% covers %CAME_IN%'s penis with their cum."
		)
	)
	cum_self_text_overrides = list(
		CLIMAX_POSITION_USER = list(
			"you cum all over %CAME_IN%'s cock.",
			"you shoot your load onto %CAME_IN%'s shaft.",
			"you cover %CAME_IN%'s penis with your cum."
		),
		CLIMAX_POSITION_TARGET = list(
			"you cum all over %CAME_IN%'s cock.",
			"you shoot your load onto %CAME_IN%'s shaft.",
			"you cover %CAME_IN%'s penis with your cum."
		)
	)
	cum_partner_text_overrides = list(
		CLIMAX_POSITION_USER = list(
			"%CUMMING% cums all over your cock.",
			"%CUMMING% shoots their load onto your shaft.",
			"%CUMMING% covers your penis with their cum."
		),
		CLIMAX_POSITION_TARGET = list(
			"%CUMMING% cums all over your cock.",
			"%CUMMING% shoots their load onto your shaft.",
			"%CUMMING% covers your penis with their cum."
		)
	)
	message = list(
		"rubs their cock against %TARGET%'s.",
		"grinds their shaft against %TARGET%'s penis.",
		"presses their dick against %TARGET%'s member.",
		"frotts against %TARGET%'s cock."
	)
	sound_use = TRUE
	sound_range = 1
	user_pleasure = 6
	target_pleasure = 6
	user_arousal = 10
	target_arousal = 10

/datum/interaction/lewd/tribadism
	name = "Tribadism"
	description = "Grind your pussy against theirs."
	user_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	target_required_parts = list(ORGAN_SLOT_VAGINA = REQUIRE_GENITAL_EXPOSED)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_VAGINA, CLIMAX_POSITION_TARGET = CLIMAX_VAGINA)
	cum_target = list(CLIMAX_POSITION_USER = ORGAN_SLOT_VAGINA, CLIMAX_POSITION_TARGET = ORGAN_SLOT_VAGINA)
	message = list(
		"grinds their pussy against %TARGET%'s cunt.",
		"rubs their cunt against %TARGET%'s pussy.",
		"thrusts against %TARGET%'s pussy.",
		"humps %TARGET%, their pussies grinding against each other."
	)
	sound_possible = list(
		'modular_zzplurt/sound/interactions/squelch1.ogg',
		'modular_zzplurt/sound/interactions/squelch2.ogg',
		'modular_zzplurt/sound/interactions/squelch3.ogg'
	)
	sound_range = 1
	sound_use = TRUE
	user_pleasure = 6
	target_pleasure = 6
	user_arousal = 10
	target_arousal = 10
