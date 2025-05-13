/datum/loadout_item/inhand/toolbox/New(category)
	LAZYADD(blacklisted_roles, ROLE_PERSISTENCE)
	. = ..()
