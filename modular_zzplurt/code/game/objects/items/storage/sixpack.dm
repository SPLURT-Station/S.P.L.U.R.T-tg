/**
 * Makes six packs generate can overlays procedurally because nothing good comes out of TG
 */

/obj/item/storage/cans
	icon = 'icons/obj/storage/storage.dmi'
	icon_state = "canholder"
	base_icon_state = "canholder"

/obj/item/storage/cans/update_icon_state()
	. = ..()
	icon_state = base_icon_state

/obj/item/storage/cans/update_overlays()
	. = ..()
	for(var/i = length(contents);i > 0;i--)
		var/obj/item/thingmabob = contents[i]
		var/mutable_appearance/obamna_soda = new /mutable_appearance(thingmabob)
		obamna_soda.plane = FLOAT_PLANE
		obamna_soda.layer = FLOAT_LAYER
		if(istype(thingmabob, /obj/item/reagent_containers/cup/glass/bottle))
			obamna_soda.pixel_x = -11 + ( ((i - 1) % 3) * 10)
			obamna_soda.pixel_y = 0 + (FLOOR((i - 1) / 3, 1) * 8)
		else if(istype(thingmabob, /obj/item/reagent_containers/cup/glass/waterbottle))
			obamna_soda.pixel_x = -10 + ( ((i - 1) % 3) * 10)
			obamna_soda.pixel_y = -5 + (FLOOR((i - 1) / 3, 1) * 8)
		else
			obamna_soda.pixel_x = -10 + ( ((i - 1) % 3) * 10)
			obamna_soda.pixel_y = -4 + (FLOOR((i - 1) / 3, 1) * 8)
		. += obamna_soda
