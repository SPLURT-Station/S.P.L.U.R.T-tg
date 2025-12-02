/datum/storyteller/medium
	name = "Medium Chaos"
	desc = "Medium Chaos is the default Storyteller, and the comparison point for every other Storyteller. \
	More frequent events than Low Chaos, but less frequent events than High Chaos. Best for an average, varied experience."
	welcome_text = "If I chopped you up in a meat grinder..."
	antag_divisor = 8

	tag_multipliers = list(
		TAG_LOW = 1,
		TAG_MEDIUM = 1,
		TAG_HIGH = 0
		)
	storyteller_type = STORYTELLER_TYPE_INTENSE | STORYTELLER_TYPE_ANTAGS

/datum/storyteller/medium/opfor
	name = /datum/storyteller/medium::name + " (OPFOR)"
	desc = /datum/storyteller/medium::desc + " (antags are OPFOR-only)"
	welcome_text = /datum/storyteller/medium::welcome_text + span_bold(" (Open an OPFOR application if you're interested in becoming an antag for this round)")

	track_data = /datum/storyteller_data/tracks/medium/opfor

	guarantees_roundstart_crewset = FALSE

	tag_multipliers = list(
		TAG_LOW = 1,
		TAG_MEDIUM = 1,
		TAG_HIGH = 0,
		TAG_OPFOR_ONLY = 0
	)
	storyteller_type = STORYTELLER_TYPE_INTENSE | STORYTELLER_TYPE_OPFOR_ONLY

/datum/storyteller_data/tracks/medium/opfor
	threshold_crewset = INFINITY
