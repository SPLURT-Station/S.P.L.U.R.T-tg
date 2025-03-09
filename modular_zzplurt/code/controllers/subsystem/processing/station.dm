/datum/controller/subsystem/processing/station
	announcer = /datum/centcom_announcer/default/lait

/datum/controller/subsystem/processing/station/proc/set_announcer(datum/centcom_announcer/new_announcer)
	QDEL_NULL(announcer)
	announcer = new new_announcer()

ADMIN_VERB(set_announcer, R_FUN, "Set announcer", "Sets the station announcer to a new type", ADMIN_CATEGORY_FUN)
	var/list/announcer_choices = subtypesof(/datum/centcom_announcer)
	var/datum/centcom_announcer/announcer_choice = tgui_input_list(usr, "Select an announcer", "Set Announcer", announcer_choices)
	if(!announcer_choice)
		return
	SSstation.set_announcer(announcer_choice)
	message_admins("Admin [key_name_admin(usr)] has set the station announcer to [announcer_choice].")
