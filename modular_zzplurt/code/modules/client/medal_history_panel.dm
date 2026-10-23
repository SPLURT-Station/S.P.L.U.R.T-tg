GLOBAL_DATUM_INIT(splurt_medal_history, /datum/splurt_medal_history, new)

/// Forward-only history for this server round, independent of client or character lifetime.
/datum/splurt_medal_history
	var/list/entries

/datum/splurt_medal_history/New()
	. = ..()
	entries = list()

/datum/splurt_medal_history/Destroy()
	QDEL_LIST(entries)
	return ..()

/// Internal projection: callers must supply a server-derived account key, never a UI parameter.
/datum/splurt_medal_history/proc/records_for(viewer_ckey)
	var/list/given = list()
	var/list/received = list()
	var/list/result = list("given" = given, "received" = received)
	viewer_ckey = ckey(viewer_ckey)
	if(!viewer_ckey)
		return result

	for(var/datum/splurt_medal_entry/entry as anything in entries)
		if(entry.giver_ckey == viewer_ckey)
			given += list(entry.ui_record())
		if(entry.recipient_ckey == viewer_ckey)
			received += list(entry.ui_record())
	return result

/// Keep generic TGUI messages read-only too; the base status can promote observer/admin users.
/datum/splurt_medal_history/ui_status(mob/user, datum/ui_state/state)
	if(!user?.client)
		return UI_CLOSE
	return UI_UPDATE

/datum/splurt_medal_history/ui_interact(mob/user, datum/tgui/ui)
	if(!user?.client)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MyMedals", "My Medals")
		ui.open()

/datum/splurt_medal_history/ui_data(mob/user)
	if(!user?.client)
		return records_for(null)
	return records_for(user.client.ckey)

GAME_VERB(/client, my_medals, "My Medals", "OOC")
	if(!mob || !VALIDATE_CLIENT_INITIALIZATION(src))
		return
	GLOB.splurt_medal_history.ui_interact(mob)
