/obj/machinery/vending/cola/Initialize(mapload)
	var/list/extra_products = list(
		/obj/item/reagent_containers/cup/glass/waterbottle/large = 5,
		/obj/item/reagent_containers/cup/soda_cans/carbonatedcum = 5,
		/obj/item/reagent_containers/cup/soda_cans/carbonatedfemcum = 5,
		/obj/item/reagent_containers/cup/soda_cans/blood = 5,
		/obj/item/reagent_containers/cup/soda_cans/blooddiscrete = 5,
		/obj/item/reagent_containers/cup/glass/waterbottle/wataur = 5,
		/obj/item/reagent_containers/cup/soda_cans/determination = 5,
	)
	premium += list(
		/obj/item/reagent_containers/cup/soda_cans/gem_grape_juice = 3,
		/obj/item/reagent_containers/cup/soda_cans/gem_grape_soda = 3
	)
	LAZYADD(products, extra_products)
	. = ..()

