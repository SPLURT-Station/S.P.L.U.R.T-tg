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
	storyteller_type = STORYTELLER_TYPE_INTENSE

/datum/storyteller/medium/opfor
	name = "Freeform Chaos (Events/No Antag Rolls)"
	desc = "Random events come at a moderate pace and antagonists come from space or player generation (OPFORs) rather than from random generation."
	welcome_text = "Crew-based antagonists will not be randomly rolled this round, use the Opposing Force verb to work out an idea with online event admins."
	antag_divisor = 0

	track_data = /datum/storyteller_data/tracks/medium/opfor

	guarantees_roundstart_crewset = FALSE

	tag_multipliers = list(
		TAG_LOW = 1,
		TAG_MEDIUM = 1,
		TAG_HIGH = 0,
		TAG_OPFOR_ONLY = 0
	)
	storyteller_type = STORYTELLER_TYPE_CALM

/datum/storyteller_data/tracks/medium/opfor
	threshold_crewset = INFINITY
	threshold_ghostset = INFINITY
