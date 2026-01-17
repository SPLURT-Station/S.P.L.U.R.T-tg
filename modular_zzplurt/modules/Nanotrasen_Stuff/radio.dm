/obj/item/encryptionkey/headset_iaa
	name = "affairs radio encryption key"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_com"
	post_init_icon_state = "cypherkey_cube"
	channels = list(RADIO_CHANNEL_IAA = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_cube
	greyscale_colors = "#2597C4#D3D3D3"

/obj/item/encryptionkey/headset_iaa/head
	name = "Nanotrasen executive's radio encryption key"
	channels = list(RADIO_CHANNEL_IAA = 1, RADIO_CHANNEL_CENTCOM = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_colors = "#2597C4#FFD351"

/obj/item/radio/headset/nanotrasen
	name = "\proper the Nanotrasen Internal Affairs headset"
	desc = "An official Nanotrasen affairs headset."
	icon = 'modular_zzplurt/icons/obj/clothing/headsets.dmi'
	icon_state = "nano_headset"
	keyslot = new /obj/item/encryptionkey/headset_iaa

/obj/item/radio/headset/heads/nanotrasen
	name = "\proper the Nanotrasen Internal Affairs bowman headset"
	desc = "An official Nanotrasen affairs headset. Protects ears from flashbangs."
	icon = 'modular_zzplurt/icons/obj/clothing/headsets.dmi'
	icon_state = "nano_headset_alt"
	keyslot = new /obj/item/encryptionkey/headset_iaa/head

/obj/item/radio/headset/heads/nanotrasen/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection)
