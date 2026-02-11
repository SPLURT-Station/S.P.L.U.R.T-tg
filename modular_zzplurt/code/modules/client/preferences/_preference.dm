/datum/preference/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!is_type_in_list(src, SSinteractions.interaction_menu_preferences))
		return
	for(var/datum/tgui/ui in preferences.parent?.mob?.tgui_open_uis)
		if(ui.interface == "MobInteraction")
			return TRUE


/datum/preference/toggle/intents
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = TRUE
	savefile_key = "intents"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/intents/apply_to_client_updated(client/client, value)
	. = ..()
	var/mob/living/carbon/human/human = client?.mob
	if(!istype(human))
		return

	if(value)
		var/face_cursor = human.client?.prefs?.read_preference(/datum/preference/toggle/face_cursor_combat_mode)
		human.face_mouse = (human.combat_focus && face_cursor) ? TRUE : FALSE

	// A few checks to prevent being stuck in incorrect intents when swappng the preference
	if(value && human.combat_mode == INTENT_HARM)
		human.set_combat_mode(INTENT_HELP, TRUE)

	if(!value && (human.combat_mode in list(INTENT_DISARM, INTENT_GRAB)))
		human.set_combat_mode(INTENT_HELP, TRUE)
	if(!value)
		var/face_cursor = human.client?.prefs?.read_preference(/datum/preference/toggle/face_cursor_combat_mode)
		human.face_mouse = (face_cursor && human.combat_mode) ? TRUE : FALSE

	client.clear_screen()
	QDEL_NULL(human.hud_used)
	human.create_mob_hud()
	if(human.hud_used)
		human.hud_used.show_hud(human.hud_used.hud_version)

	human.reload_huds()
	human.reload_fullscreen()
