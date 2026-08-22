/datum/outfit/cyber_police/post_equip(mob/living/carbon/human/user, visuals_only)
	if(visuals_only || isdummy(user))
		return
	. = ..()
