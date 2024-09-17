/datum/preference/toggle/classic_rclick
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "classic_rightclick"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/classic_rclick/proc/setup_keybinds(client/client, value)
	client.classic_rclick = value
	if(value)
		winset(src, "mapwindow.map", "macro=ShiftToUseMode")
	else
		winset(src, "mapwindow.map", "macro=default")
	client.set_macros()
	client.set_right_click_menu_mode()

/datum/preference/toggle/classic_rclick/apply_to_client(client/client, value)
	setup_keybinds(client, value)

/datum/preference/toggle/classic_rclick/apply_to_client_updated(client/client, value)
	setup_keybinds(client, value)
