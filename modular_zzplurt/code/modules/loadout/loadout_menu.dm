/datum/preference_middleware/loadout/get_ui_static_data(mob/user)
	. = ..()

	if(!.["is_donator"])
		return

	.["donator_tier"] = GLOB.donator_list[user.client.ckey]
