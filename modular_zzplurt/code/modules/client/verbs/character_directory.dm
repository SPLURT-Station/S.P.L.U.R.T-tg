//#define READ_PREFS(target, pref) (target.client.prefs.read_preference(/datum/preference/pref) || "Unset") // Add this back with the 516 update because they deleted it

/datum/character_directory/ui_data(mob/user)
	. = ..()
	var/list/data = .

	if (user?.client?.prefs)
		data["personalExtremeTag"] = READ_PREFS(user, choiced/erp_status_extm)
		data["personalExtremeHarmTag"] = READ_PREFS(user, choiced/erp_status_extmharm)
		data["personalUnholyTag"] = READ_PREFS(user, choiced/erp_status_unholy)

	return data

//#undef READ_PREFS // Add this back with the 516 update because they deleted it
