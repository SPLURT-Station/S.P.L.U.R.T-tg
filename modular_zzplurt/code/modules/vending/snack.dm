/obj/machinery/vending/snack/New()
	premium += list(
		/obj/item/food/tibbits = 3,
		/obj/item/food/toasties = 3,
		/obj/item/food/vanillabar = 3,
	)
	products += list(
		/obj/item/storage/fancy/jellybean_bowl = 5,
	)
	. = ..()
