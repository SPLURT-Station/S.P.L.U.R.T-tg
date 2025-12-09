// interactions for internal use in the bellyriding component
/datum/interaction/lewd/bellyriding
	category = INTERACTION_CAT_HIDE
	user_required_parts = list(ORGAN_SLOT_PENIS)
	usage = INTERACTION_OTHER
	sound_range = 2

/datum/interaction/lewd/bellyriding/groin_rub
	// these arent shown in interaction menu, but we need both name and desc in definition (populate_interaction_instances)
	name = "bellyriding dick rub against groin"
	description = "bellyriding dick rub against groin"

	sound_use = TRUE
	sound_possible = list('sound/items/weapons/throwtap.ogg')
	target_required_parts = list()
	target_pleasure = 0
	target_arousal = 2
	user_pleasure = 1
	user_arousal = 2

	message = list(
		"'s cock grinds against %TARGET%'s groin.",
		"'s shaft rubs against %TARGET%'s groin.",
		"'s dick rubs across %TARGET%'s body.",
		"'s tip pokes against %TARGET%'s groin."
	)
	user_messages = list(
		span_lewd("Your cock grinds against %TARGET%'s groin."),
		span_lewd("You feel your shaft rub against %TARGET%'s groin."),
		span_lewd("You feel your dick rub across %TARGET%'s body."),
		span_lewd("Your tip pokes against %TARGET%'s groin."),
		span_lewd("%TARGET%'s body grinds against your cock from inertia.")
	)
	target_messages = list(
		span_lewd("%USER%'s cock grinds against your groin."),
		span_lewd("%USER%'s shaft shoves itself between your legs."),
		span_lewd("%USER%'s dick rubs against your body."),
		span_lewd("%USER%'s tip pokes at your groin."),
		span_lewd("Your body grinds against %USER%'s shaft from inertia.")
	)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS, CLIMAX_POSITION_TARGET = null)
	cum_target = list(CLIMAX_POSITION_USER = ORGAN_SLOT_PENIS, CLIMAX_POSITION_TARGET = null)

/datum/interaction/lewd/bellyriding/frot
	name = "bellyriding dick frot"
	description = "bellyriding dick frot"

	sound_use = TRUE
	sound_possible = list('sound/items/weapons/throwtap.ogg')
	target_required_parts = list(ORGAN_SLOT_PENIS)
	target_pleasure = 1
	target_arousal = 2
	user_pleasure = 1
	user_arousal = 2

	message = list(
		"'s cock grinds against %TARGET%'s own.",
		"'s shaft forcibly frots with %TARGET%'s.",
		"'s dick rubs across %TARGET%'s shaft.",
		"'s tip grinds against %TARGET%'s shaft."
	)
	user_messages = list(
		span_lewd("Your cock grinds against %TARGET%'s own."),
		span_lewd("You feel your shaft frot with %TARGET%'s."),
		span_lewd("You feel your dick rub across %TARGET%'s body."),
		span_lewd("Your tip forces itself onto %TARGET%'s cock."),
		span_lewd("%TARGET%'s cock grinds against your own.")
	)
	target_messages = list(
		span_lewd("%USER%'s cock grinds against your groin."),
		span_lewd("%USER%'s shaft massages itself with your own."),
		span_lewd("%USER%'s dick rubs against your own."),
		span_lewd("%USER%'s tip forces itself against your shaft."),
		span_lewd("Your cock grinds against %USER%'s shaft from inertia.")
	)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS, CLIMAX_POSITION_TARGET = null)
	cum_target = list(CLIMAX_POSITION_USER = ORGAN_SLOT_PENIS, CLIMAX_POSITION_TARGET = null)

/datum/interaction/lewd/bellyriding/anus
	name = "bellyriding dick in anus"
	description = "bellyriding dick in anus"

	sound_use = TRUE
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	target_required_parts = list(ORGAN_SLOT_ANUS)
	target_pleasure = 3
	target_arousal = 1
	target_pain = 3
	user_pleasure = 3
	user_arousal = 2
	user_pain = 0

	message = list(
		"'s cock jams itself into %TARGET%'s anus.",
		"forcibly spreads %TARGET%'s anus with their shaft.",
		"abuses %TARGET%'s hole with their shaft.",
		"'s shaft pleasures itself at %TARGET%'s expense."
	)
	user_messages = list(
		span_lewd("Your cock jams itself into %TARGET%'s anus."),
		span_lewd("You forcibly spread %TARGET%'s anus with your shaft."),
		span_lewd("%TARGET%'s anus forcibly stretches to accomodate your shaft."),
		span_lewd("Your shaft pleasures itself at %TARGET%'s expense.")
	)
	target_messages = list(
		span_lewd("%USER%'s cock jams itself into your anus."),
		span_lewd("Your hole is forcibly spread by %TARGET%'s shaft."),
		span_lewd("Your anus forcibly stretches to accomodate your shaft."),
		span_lewd("%USER%'s shaft pleasures itself at your hole's expense.")
	)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS, CLIMAX_POSITION_TARGET = null)
	cum_target = list(CLIMAX_POSITION_USER = ORGAN_SLOT_PENIS, CLIMAX_POSITION_TARGET = ORGAN_SLOT_ANUS)

/datum/interaction/lewd/bellyriding/vagina
	name = "bellyriding dick in vagina"
	description = "bellyriding dick in vagina"

	sound_use = TRUE
	sound_possible = list(
		'modular_zzplurt/sound/interactions/bang1.ogg',
		'modular_zzplurt/sound/interactions/bang2.ogg',
		'modular_zzplurt/sound/interactions/bang3.ogg'
	)
	target_required_parts = list(ORGAN_SLOT_VAGINA)
	target_pleasure = 4
	target_arousal = 2
	target_pain = 3
	user_pleasure = 1
	user_arousal = 2
	user_pain = 0

	message = list(
		"'s cock forces itself inside %TARGET%'s walls.",
		"forcibly spreads %TARGET%'s folds open with their shaft.",
		"abuses %TARGET%'s pussy with their shaft.",
		"'s shaft pleasures itself at %TARGET%'s expense."
	)
	user_messages = list(
		span_lewd("Your cock forces itself into %TARGET%'s pussy."),
		span_lewd("You forcibly spread %TARGET%'s folds apart with your shaft."),
		span_lewd("%TARGET%'s pussy stretches to accomodate your dick."),
		span_lewd("Your shaft pleasures itself at %TARGET%'s expense.")
	)
	target_messages = list(
		span_lewd("%USER%'s cock forces itself into your pussy."),
		span_lewd("Your vagina parts open to accomodate %TARGET%'s shaft."),
		span_lewd("Your pussy stretches as %USER%'s shaft slides into it."),
		span_lewd("%USER%'s shaft pleasures itself at your pussy's expense.")
	)
	cum_genital = list(CLIMAX_POSITION_USER = CLIMAX_PENIS, CLIMAX_POSITION_TARGET = null)
	cum_target = list(CLIMAX_POSITION_USER = ORGAN_SLOT_PENIS, CLIMAX_POSITION_TARGET = ORGAN_SLOT_VAGINA)
