/obj/item/clothing/under/Destroy()
	if(ishuman(loc) && !isdummy(loc))
		var/mob/living/carbon/human/wearer = loc
		GLOB.suit_sensors_list -= wearer
		wearer.med_hud_set_status()
	return ..()

/obj/item/clothing/under/costume/allamerican // Added digi-legs sprite variation
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/under/under_digi.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
