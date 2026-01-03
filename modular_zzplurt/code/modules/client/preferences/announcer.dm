
/datum/preference/choiced/announcer
	savefile_key = "preferred_announcer"
	savefile_identifier = PREFERENCE_PLAYER
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES

/datum/preference/choiced/announcer/init_possible_values()
	return list(
		"Use Station Default",
		"Tibbets",
		"Lait",
		"Dagoth Ur",
		"Bubber",
		"TG Intern",
		"Medbot"
	)

/datum/preference/choiced/announcer/create_default_value()
	return "Use Station Default"
