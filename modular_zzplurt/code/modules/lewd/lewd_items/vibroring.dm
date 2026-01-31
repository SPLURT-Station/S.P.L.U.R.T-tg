/obj/item/clothing/sextoy/vibroring/process(seconds_per_tick)
	. = ..()
	var/mob/living/carbon/human/user = loc
	if(!user || !istype(user))
		return PROCESS_KILL
	var/obj/item/organ/genital/testicles/balls = user.get_organ_slot(ORGAN_SLOT_PENIS)
	if(!toy_on || !balls)
		return
	user.plug13_genital_emote(balls, PLUG13_STRENGTH_DEFAULT, PLUG13_DURATION_SHORT)
