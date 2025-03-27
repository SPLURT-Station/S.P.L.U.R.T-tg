/obj/machinery/vending/boozeomat/Initialize(mapload)
	var/list/extra_products = list(
		/obj/item/reagent_containers/cup/glass/bottle/bloodwine = 3,
		/obj/item/reagent_containers/cup/glass/bottle/femcum_whiskey = 4,
		/obj/item/reagent_containers/cup/glass/bottle/cum_rum = 4,
		/obj/item/reagent_containers/cup/glass/bottle/pitcher = 2
	)
	LAZYADD(products, extra_products)
	. = ..()
