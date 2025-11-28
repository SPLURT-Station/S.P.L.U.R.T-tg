#define STOCK_NIFSOFT 6

// Based on Skyrat's vending overrides
/obj/machinery/vending/dorms
	zzplurt_product_categories = list(
		list(
			"name" = "Toys",
			"products" = list(
				/obj/item/storage/box/portal_fleshlight = 4,
			)
		),
		list(
			"name" = "Consumables",
			"products" = list(
				/obj/item/reagent_containers/cup/bottle/belly_enlarger = 6,
				/obj/item/reagent_containers/cup/bottle/butt_enlarger = 6
			)
		),
		list(
			"name" = "Restraints",
			"products" = list(
				/obj/item/clothing/suit/bellyriding_harness = 2,
			)
		)
	)

	// New premium items
	zzplurt_premium = list(
		// Original software
		// This is in the PDA
		/*
		/obj/item/disk/nifsoft_uploader/dorms/hypnosis = STOCK_NIFSOFT,
		/obj/item/disk/nifsoft_uploader/shapeshifter = STOCK_NIFSOFT,
		*/

		// New software
		/obj/item/disk/nifsoft_uploader/dorms/nif_disrobe_disk = STOCK_NIFSOFT,
		/obj/item/disk/nifsoft_uploader/nif_hide_backpack_disk = STOCK_NIFSOFT,
		/obj/item/disk/nifsoft_uploader/dorms/nif_gfluid_disk = STOCK_NIFSOFT,
	)

#undef STOCK_NIFSOFT
