/obj/machinery/vending/autodrobe/Initialize(mapload)
	var/list/extra_products = list(
		/obj/item/clothing/mask/kitsuneblk = 2,
		/obj/item/clothing/mask/kitsunewhi = 2,
	)
	LAZYADD(products, extra_products)
	. = ..()
