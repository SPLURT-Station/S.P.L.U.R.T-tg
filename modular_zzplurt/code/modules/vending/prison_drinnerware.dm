/obj/machinery/vending/dinnerware/prison
	name = "\improper Steel Chef's Dinnerware Vendor"
	desc = "A kitchen and restaurant equipment vendor, moderated for prisoners!"
	product_categories = list(
		list(
			"name" = "Kitchen Utensils",
			"icon" = FA_ICON_KITCHEN_SET,
			"products" = list(
				/obj/item/storage/bag/tray = 8,
				/obj/item/reagent_containers/cup/soup_pot = 3,
				/obj/item/kitchen/spoon/soup_ladle = 3,
				/obj/item/clothing/suit/apron/chef = 2,
				/obj/item/kitchen/rollingpin = 2,
				/obj/item/kitchen/tongs = 2,
				/obj/item/knife/plastic = 2,
			),
		),
		list(
			"name" = "Eating Utensils",
			"icon" = FA_ICON_UTENSILS,
			"products" = list(
				/obj/item/kitchen/fork/plastic = 10,
				/obj/item/kitchen/spoon/plastic = 10,
			),
		),
		list(
			"name" = "Dinnerware",
			"icon" = FA_ICON_PLATE_WHEAT,
			"products" = list(
				/obj/item/plate/small = 5,
				/obj/item/plate = 10,
				/obj/item/plate/large = 5,
				/obj/item/reagent_containers/cup/bowl = 30,
				/obj/item/reagent_containers/cup/glass/drinkingglass = 8,
			),
		),
		list(
			"name" = "Condiments",
			"icon" = FA_ICON_BOTTLE_DROPLET,
			"products" = list(
				/obj/item/reagent_containers/condiment/pack/ketchup = 5,
				/obj/item/reagent_containers/condiment/pack/hotsauce = 5,
				/obj/item/reagent_containers/condiment/pack/astrotame = 5,
				/obj/item/reagent_containers/condiment/saltshaker = 5,
				/obj/item/reagent_containers/condiment/peppermill = 5,
			),
		),
		list(
			"name" = "Recipes",
			"icon" = FA_ICON_BOOK_OPEN_READER,
			"products" = list(
				/obj/item/book/granter/crafting_recipe/cooking_sweets_101 = 2,
			),
		),
	)

	premium = list()
	contraband = list(
		/obj/item/kitchen/rollingpin/illegal = 2,
		/obj/item/knife/kitchen = 2,
	)
	payment_department = ACCOUNT_SEC
