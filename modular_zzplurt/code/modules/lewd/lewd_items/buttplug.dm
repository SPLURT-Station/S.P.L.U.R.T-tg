/obj/item/clothing/sextoy/buttplug/process(seconds_per_tick)
	. = ..()
	var/mob/living/carbon/human/target = loc
	if(!istype(target))
		return

	switch(current_size)
		if("small")
			target.plug13_genital_emote(target.get_organ_slot(current_equipped_slot), PLUG13_STRENGTH_LOW, PLUG13_DURATION_SHORT)
		if("medium")
			target.plug13_genital_emote(target.get_organ_slot(current_equipped_slot), PLUG13_STRENGTH_MEDIUM, PLUG13_DURATION_SHORT)
		if("big")
			target.plug13_genital_emote(target.get_organ_slot(current_equipped_slot), PLUG13_STRENGTH_HIGH, PLUG13_DURATION_SHORT)
