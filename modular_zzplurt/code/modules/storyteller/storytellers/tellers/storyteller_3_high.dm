/datum/storyteller/high
	name = "High Chaos"
	desc = "High Chaos will try to create the most combat focused events, while trying to avoid purely destructive ones. \
	More combat-focused and frequent events than the Default, but stays ordered to avoid creating a hellshift, unlike the Clown."
	welcome_text = "Welcome to the Gamer storyteller. Now with 50% more ahelps!"

	track_data = /datum/storyteller_data/tracks/gamer

	tag_multipliers = list(
		TAG_COMBAT = 1.5,
		TAG_DESTRUCTIVE = 0.7,
		TAG_CHAOTIC = 1.3,
		TAG_LOW = 1,
		TAG_MEDIUM = 1,
		TAG_HIGH = 1
	)

	antag_divisor = 5
	storyteller_type = STORYTELLER_TYPE_INTENSE | STORYTELLER_TYPE_ANTAGS

/datum/storyteller/high/opfor
	name = /datum/storyteller/high::name + " (OPFOR)"
	desc = /datum/storyteller/high::desc + " (antags are OPFOR-only)"
	welcome_text = /datum/storyteller/high::welcome_text + span_bold(" (Open an OPFOR application if you're interested in becoming an antag for this round)")

	track_data = /datum/storyteller_data/tracks/gamer/opfor

	guarantees_roundstart_crewset = FALSE

	storyteller_type = STORYTELLER_TYPE_INTENSE | STORYTELLER_TYPE_OPFOR_ONLY

	tag_multipliers = list(
		TAG_COMBAT = 1.5,
		TAG_DESTRUCTIVE = 0.7,
		TAG_CHAOTIC = 1.3,
		TAG_LOW = 1,
		TAG_MEDIUM = 1,
		TAG_HIGH = 1,
		TAG_OPFOR_ONLY = 0
	)

/datum/storyteller_data/tracks/gamer/opfor
	threshold_crewset = INFINITY
