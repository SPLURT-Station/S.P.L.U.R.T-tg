/datum/storyteller/low
	name = "Low Chaos"
	desc = "Low Chaos will be light on events compared to other storytellers, especially so on ones involving combat, destruction, or chaos. \
	The least hectic storyteller of all, while still having some spice. Best for RP-focused rounds with a few events sprinkled in."
	welcome_text = "If you vote for this storyteller on Ice Box, you have no originality."

	track_data = /datum/storyteller_data/tracks/chill

	guarantees_roundstart_crewset = FALSE
	tag_multipliers = list(
		TAG_COMBAT = 0.3,
		TAG_DESTRUCTIVE = 0.3,
		TAG_CHAOTIC = 0.1,
		TAG_LOW = 1,
		TAG_MEDIUM = 0,
		TAG_HIGH = 0
	)
	antag_divisor = 32
	storyteller_type = STORYTELLER_TYPE_CALM | STORYTELLER_TYPE_ANTAGS

/datum/storyteller/low/opfor
	name = /datum/storyteller/low::name + " (OPFOR)"
	desc = /datum/storyteller/low::desc + " (antags are OPFOR-only)"
	welcome_text = /datum/storyteller/low::welcome_text + span_bold(" (Open an OPFOR application if you're interested in becoming an antag for this round)")

	track_data = /datum/storyteller_data/tracks/chill/opfor

	guarantees_roundstart_crewset = FALSE

	tag_multipliers = list(
		TAG_COMBAT = 0.3,
		TAG_DESTRUCTIVE = 0.3,
		TAG_CHAOTIC = 0.1,
		TAG_LOW = 1,
		TAG_MEDIUM = 0,
		TAG_HIGH = 0,
		TAG_OPFOR_ONLY = 0
	)
	storyteller_type = STORYTELLER_TYPE_CALM | STORYTELLER_TYPE_OPFOR_ONLY

/datum/storyteller_data/tracks/chill/opfor
	threshold_crewset = INFINITY
