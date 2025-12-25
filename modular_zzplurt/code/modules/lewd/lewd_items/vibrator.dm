/obj/item/clothing/sextoy/vibrator/process(seconds_per_tick)
	. = ..()
	if(!toy_on)
		return
	var/mob/living/carbon/human/target = loc
	if(!istype(target))
		return
	switch(vibration_mode)
		if(VIB_LOW)
			target.plug13_genital_emote(target.get_organ_slot(current_equipped_slot), 0.5 * PLUG13_STRENGTH_DEFAULT, PLUG13_DURATION_SHORT)
		if(VIB_MEDIUM)
			target.plug13_genital_emote(target.get_organ_slot(current_equipped_slot), 1 * PLUG13_STRENGTH_DEFAULT, PLUG13_DURATION_SHORT)
		if(VIB_HIGH)
			target.plug13_genital_emote(target.get_organ_slot(current_equipped_slot), 1.5 * PLUG13_STRENGTH_DEFAULT, PLUG13_DURATION_SHORT)
