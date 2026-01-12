/obj/item/clothing/sextoy/dildo/process(seconds_per_tick)
	. = ..()
	var/mob/living/carbon/human/user = loc
	if(!istype(user))
		return
	switch(poly_size)
		if("small")
			user.plug13_genital_emote(user.get_organ_slot(current_equipped_slot), PLUG13_STRENGTH_LOW, PLUG13_DURATION_SHORT)
		if("medium")
			user.plug13_genital_emote(user.get_organ_slot(current_equipped_slot), PLUG13_STRENGTH_MEDIUM, PLUG13_DURATION_SHORT)
		if("big")
			user.plug13_genital_emote(user.get_organ_slot(current_equipped_slot), PLUG13_STRENGTH_HIGH, PLUG13_DURATION_SHORT)
