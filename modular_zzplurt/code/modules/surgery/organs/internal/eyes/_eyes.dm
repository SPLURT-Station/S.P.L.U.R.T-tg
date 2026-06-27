//SPLURT ADDITION START
/obj/item/organ/eyes/copy_traits_from(obj/item/organ/eyes/old_eyes, copy_actions = FALSE)
	. = ..()
	if(isnull(old_eyes))
		return

	eyes_layer = old_eyes.eyes_layer
//SPLURT ADDITION END

/obj/item/organ/eyes/night_vision/arachnid
	name = "arachnid eyes"
	desc = "These eyes seem to have increased sensitivity to bright light, offset by basic night vision."

	low_light_cutoff = list(0, 15, 20) //blatantly copied from mushy mushy
	medium_light_cutoff = list(0, 20, 35)
	high_light_cutoff = list(0, 40, 50)
	flash_protect = FLASH_PROTECTION_SENSITIVE
