/obj/item/clothing/sextoy/nipple_clamps/process(seconds_per_tick)
	. = ..()
	var/mob/living/carbon/human/target = loc
	var/obj/item/organ/genital/breasts/target_breast = target.get_organ_slot(ORGAN_SLOT_BREASTS)
	if(!target || !target_breast)
		return
	target.plug13_genital_emote(target_breast, PLUG13_STRENGTH_LOW, PLUG13_DURATION_TINY)
