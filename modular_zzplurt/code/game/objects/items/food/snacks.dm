/obj/item/food/tibbits
	name = "\improper Tib-Bits Cheddar Wedges"
	desc = "Crunchy, bite-sized cheese wedge chips packed with bold cheddar flavor in every savory morsel. \
		Tib-Bits Cheddar Wedges deliver the perfect balance of crispy texture and rich, cheesy goodness, small \
		in size, big on snackable satisfaction."
	icon = 'modular_zzplurt/icons/obj/food/foods.dmi'
	icon_state = "tibbits"
	trash_type = /obj/item/trash/tibbits
	bite_consumption = 2
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/fat = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	custom_price = PAYCHECK_CREW * 0.7
	tastes = list("mild cheddar cheese" = 1)
	foodtypes = DAIRY|JUNKFOOD|FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tibbits/make_leave_trash()
	AddElement(/datum/element/food_trash, trash_type, FOOD_TRASH_POPABLE)

/obj/item/food/toasties
	name = "\improper Harvest Toasties"
	desc = "Golden, flaky pastries filled with hearty seasoned meats and baked to savory perfection. Harvest \
		Toasties offer a warm, satisfying blend of crisp pastry and rich filling, making each bite a comforting, \
		delicious classic."
	icon = 'modular_zzplurt/icons/obj/food/foods.dmi'
	icon_state = "toasties"
	trash_type = /obj/item/trash/toasties
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	custom_price = PAYCHECK_LOWER * 0.8
	tastes = list("crispy pastry" = 6, "savory meat" = 6)
	foodtypes = GRAIN | MEAT | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/vanillabar
	name = "Lydia's Ivory Bliss"
	desc = "A smooth, elegant white chocolate bar with a delicate sweetness as timeless as Lydia herself, crafted \
		with creamy cocoa butter and vanilla for a luxurious melt-in-your-mouth experience. Lydia's Ivory Bliss is \
		a pale confection of grace, charm, and irresistible indulgence."
	icon = 'modular_zzplurt/icons/obj/food/foods.dmi'
	icon_state = "vanillabar"
	trash_type = /obj/item/trash/vanillabar
	food_reagents = list(
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/coco = 2,
		/datum/reagent/consumable/vanilla = 2,
	)
	custom_price = PAYCHECK_CREW * 0.7
	tastes = list("cocoa butter" = 1, "vanilla" = 1)
	foodtypes = JUNKFOOD | SUGAR | DAIRY
	w_class = WEIGHT_CLASS_TINY
