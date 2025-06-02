/datum/round_event_control/antagonist/solo/blood_cult
	name = "Blood Cult"
	roundstart = TRUE

	antag_flag = ROLE_CULTIST
	antag_datum = /datum/antagonist/cult

	weight = 5
	tags = list(TAG_COMBAT, TAG_SPOOKY, TAG_CREW_ANTAG, TAG_MEDIUM)

	maximum_antags_global = 5
	min_players = 30

/datum/round_event_control/antagonist/solo/blood_cult/midround
	name = "Blood Cult Accident"
	roundstart = FALSE
