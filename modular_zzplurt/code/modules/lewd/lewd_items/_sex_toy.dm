/obj/item/clothing/sextoy/lewd_equipped(mob/living/carbon/human/user, slot, initial)
	. = ..()
	user.plug13_genital_emote(user.get_organ_slot(slot), PLUG13_STRENGTH_NORMAL, PLUG13_DURATION_SHORT)
