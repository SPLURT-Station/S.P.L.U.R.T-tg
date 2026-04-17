/obj/item/encryptionkey/headset_iaa
	name = "\proper the affairs radio encryption key"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_com"
	post_init_icon_state = "cypherkey_centcom"
	channels = list(RADIO_CHANNEL_IAA = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_centcom
	greyscale_colors = "#2597C4#D3D3D3"

/obj/item/encryptionkey/head/ntc
	name = "\proper the Nanotrasen consultant's radio encryption key"
	channels = list(RADIO_CHANNEL_IAA = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_colors = "#2597C4#FFD351"

/obj/item/radio/headset/nanotrasen
	name = "\proper the Nanotrasen Internal Affairs headset"
	desc = "An official Nanotrasen affairs headset."
	icon = 'modular_zzplurt/icons/obj/clothing/headsets.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/ears.dmi'
	icon_state = "nano_headset"
	worn_icon_state = "nano_headset"
	keyslot = new /obj/item/encryptionkey/headset_iaa

/obj/item/radio/headset/heads/nanotrasen
	name = "\proper the Nanotrasen Consultant's headset"
	desc = "An official Nanotrasen affairs headset, this one is worn by an executive of the NTIA."
	icon = 'modular_zzplurt/icons/obj/clothing/headsets.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/ears.dmi'
	icon_state = "nano_headset"
	worn_icon_state = "nano_headset"
	keyslot = new /obj/item/encryptionkey/head/ntc
	keyslot2 = new /obj/item/encryptionkey/headset_cent

/obj/item/radio/headset/heads/nanotrasen/alt
	name = "\proper the Nanotrasen Internal Affairs executive's bowman headset"
	desc = "An official Nanotrasen affairs headset, this one is worn by an executive of the NTIA. Protects ears from flashbangs."
	icon_state = "nano_headset_alt"
	worn_icon_state = "nano_headset_alt"
	keyslot = new /obj/item/encryptionkey/head/ntc
	keyslot2 = new /obj/item/encryptionkey/headset_cent

/obj/item/radio/headset/heads/nanotrasen/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection)
