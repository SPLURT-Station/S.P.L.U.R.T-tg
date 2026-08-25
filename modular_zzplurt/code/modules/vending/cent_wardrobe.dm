/obj/machinery/vending/wardrobe/cent_wardrobe/Initialize(mapload)
	var/list/extra_products = list(
		/obj/item/clothing/gloves/captain/centcom = 3,
		/obj/item/clothing/head/beret/centcom_formal = 3,
		/obj/item/clothing/head/beret/centcom_officer = 3,
		/obj/item/clothing/mask/gas/atmos/centcom = 3,
		/obj/item/clothing/suit/armor/centcom_commander = 3,
		/obj/item/clothing/suit/armor/centcom_jacket = 3,
		/obj/item/clothing/suit/armor/vest/capcarapace/centcom = 3,
		/obj/item/clothing/suit/hazardvest/centcom = 3,
		/obj/item/clothing/accessory/bubber/acc_medal/neckpin/centcom = 6,
		/obj/item/clothing/under/rank/centcom/lieutenant = 3,
		/obj/item/clothing/under/rank/centcom/lieutenant/skirt = 3,
		/obj/item/clothing/under/rank/centcom/lieutenant/turtleneck = 3,
		/obj/item/clothing/under/rank/centcom/lieutenant/skirt/turtleneck = 3,
		/obj/item/clothing/under/rank/centcom/commander/turtleneck = 3,
		/obj/item/clothing/under/rank/centcom/commander/skirt/turtleneck = 3,
		/obj/item/clothing/under/rank/centcom/officer/senior = 3,
		/obj/item/clothing/under/rank/centcom/officer/skirt/senior = 3,
		/obj/item/clothing/under/rank/centcom/official/turtleneck = 3,
		/obj/item/storage/belt/sheath/sabre/centcom = 3,
		/obj/item/storage/box/centcom_kit/spacesuit = 6,
		/obj/item/storage/box/centcom_kit/spacesuit/armored = 6,
		/obj/item/storage/box/centcom_kit/spacesuit/command = 3,
		/obj/item/radio/headset/headset_cent = 3,
	)
	LAZYADD(products, extra_products)
	. = ..()
