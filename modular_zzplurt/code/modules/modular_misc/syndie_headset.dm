/obj/item/radio/headset/syndicateciv
	name = "Syndicate Civilian headset"
	desc = "A headset with a large red cross on the earpiece."
	icon = 'modular_zzplurt/icons/obj/clothing/headsets.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/ears.dmi'
	icon_state = "syndie_headset"
	worn_icon_state = "syndie_headset"
	inhand_icon_state = null
	radiosound = 'modular_skyrat/modules/radiosound/sound/radio/syndie.ogg'
	keyslot = null

/obj/item/radio/headset/syndicateciv/command
	icon = 'icons/obj/clothing/headsets.dmi'
	worn_icon = 'icons/mob/clothing/ears.dmi'

/obj/item/radio/headset/syndicateciv/command/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))
