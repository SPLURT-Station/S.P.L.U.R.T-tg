/obj/item/encryptionkey/headset_syndicate/inteq
	name = "InteQ Encryption Key"
	channels = list(RADIO_CHANNEL_COMMAND = 1, RADIO_CHANNEL_SECURITY = 1)
	icon_state = "inteq_cypherkey"
	icon = 'modular_zzz/icons/obj/clothing/ears/key.dmi'
	special_channels = RADIO_SPECIAL_CENTCOM

/obj/item/radio/headset/inteq
	name = "InteQ Headset"
	desc = "A brown headset, used by InteQ members."
	icon_state = "inteq_headset"
	worn_icon_state = "inteq_headset"
	icon = 'modular_zzz/icons/obj/clothing/ears/inteq.dmi'
	worn_icon = 'modular_zzz/icons/mob/clothing/ears/inteq.dmi'
	freerange = FALSE
	freqlock = TRUE
	keyslot = new /obj/item/encryptionkey/headset_syndicate/inteq

/obj/item/radio/headset/inteq/command
	name = "InteQ Command Headset"
	desc = "A commanding headset to gather your underlings."
	command = TRUE

/obj/item/radio/headset/inteq/bowman
	name = "InteQ Bowman Headset"
	desc = "A brown advanced headset, used by InteQ combatants. Protects your ears from flashbangs."
	icon_state = "inteq_headset_alt"

/obj/item/radio/headset/inteq/bowman/command
	name = "InteQ Bowman Command Headset"
	desc = "A brown advanced headset, used by InteQ combatants. Protects your ears from flashbangs. Helps your to command your men."
	command = TRUE
