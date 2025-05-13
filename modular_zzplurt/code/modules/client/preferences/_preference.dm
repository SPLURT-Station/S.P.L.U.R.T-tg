/datum/preference/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!is_type_in_list(src, SSinteractions.interaction_menu_preferences))
		return
	for(var/datum/tgui/ui in preferences.parent?.mob?.tgui_open_uis)
		if(ui.interface == "MobInteraction")
			return TRUE
