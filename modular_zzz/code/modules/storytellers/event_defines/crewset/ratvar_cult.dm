/datum/round_event_control/antagonist/solo/clock_cult
	name = "Clock Cult"
	roundstart = TRUE

	antag_flag = ROLE_CLOCK_CULTIST
	antag_datum = /datum/antagonist/clock_cultist
	weight = 0
	min_players = 30

	maximum_antags_global = 5

	tags = list(TAG_COMBAT, TAG_SPOOKY, TAG_CREW_ANTAG, TAG_MEDIUM)

/datum/round_event_control/antagonist/solo/clock_cult/midround
	name = "Clock Cult Accident"
	roundstart = FALSE
