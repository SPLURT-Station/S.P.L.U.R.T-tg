/obj/item/storage/box/portal_fleshlight
	name = "Portal Fleshlight and Panties"
	desc = "A small silver box with Silver Love Co embossed."
	icon = 'modular_zzplurt/icons/obj/lewd/fleshlight.dmi'
	icon_state = "box"
	illustration = null
	custom_price = 15

/obj/item/storage/box/portal_fleshlight/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.max_total_storage = 10
	atom_storage.max_slots = 3

/obj/item/storage/box/portal_fleshlight/PopulateContents()
	new /obj/item/clothing/sextoy/portal_fleshlight(src)
	new /obj/item/clothing/sextoy/portal_panties(src)
	new /obj/item/paper/fluff/portal_fleshlight(src)

/obj/item/paper/fluff/portal_fleshlight
	name = "Portal Fleshlight Instructions"
	default_raw_text = {"Thank you for purchasing the Silver Love Portal Fleshlight!<br>\
	To use, simply register your new portal fleshlight with the provided panties to link them together. Then ask your lover to wear the panties.<br>\
	Portal panties can also be linked directly to another pair of portal panties so both partners can wear and use them hands-free.<br>\
	The portal fleshlight can be used to target different body parts by right-clicking it to cycle through available targets.<br>\
	Both the fleshlight and panties can be toggled to anonymous mode by right-clicking them.<br>\
	Have fun lovers,<br>\
	<br>\
	Wilhelmina Steiner."}
