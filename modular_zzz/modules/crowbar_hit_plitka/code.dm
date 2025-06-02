/turf/open/floor/crowbar_act(mob/living/user, obj/item/I)
	if(user.combat_mode == TRUE)
		return
	..()
