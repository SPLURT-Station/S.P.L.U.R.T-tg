/datum/preference/toggle/master_erp_preferences/is_accessible(datum/preferences/preferences)
	. = ..()
	// SPLURT EDIT - Poorly implemented
	/*
	if(preferences.parent.is_vetted)
		return TRUE
	*/
	// SPLURT EDIT END
	ASYNC
		SSplayer_ranks.is_vetted(preferences.parent, admin_bypass = FALSE)


/datum/preference/toggle/erp/is_accessible(datum/preferences/preferences)
	. = ..()
	// SPLURT EDIT - Poorly implemented
	/*
	if(preferences.parent.is_vetted)
		return TRUE
	*/
	// SPLURT EDIT END
	ASYNC
		SSplayer_ranks.is_vetted(preferences.parent, admin_bypass = FALSE)

