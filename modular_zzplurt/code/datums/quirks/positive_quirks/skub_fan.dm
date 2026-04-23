/datum/quirk/item_quirk/pro_skub
	name = "Pro-Skub"
	desc = "You are firmly pro-skub and get a mood boost from wearing your pro-skub pin."
	icon = FA_ICON_MAP_PIN
	value = 2
	mob_trait = TRAIT_PRO_SKUB
	gain_text = span_notice("You are proudly pro-skub.")
	lose_text = span_danger("Your pro-skub conviction wanes.")
	medical_record_text = "Patient wouldn't shut up about how good skub is."
	mail_goodies = list(
		/obj/item/skub,
		/obj/item/sticker/skub,
		/obj/item/storage/box/stickers/skub,
		/obj/item/clothing/suit/costume/wellworn_shirt/skub,
	)

/datum/quirk/item_quirk/pro_skub/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/pro_skub_pin, list(LOCATION_BACKPACK, LOCATION_HANDS))

/datum/quirk/item_quirk/anti_skub
	name = "Anti-Skub"
	desc = "You are firmly anti-skub and get a mood boost from wearing your anti-skub pin."
	icon = FA_ICON_THUMBTACK
	value = 2
	mob_trait = TRAIT_ANTI_SKUB
	gain_text = span_notice("You stand against skub.")
	lose_text = span_danger("Your anti-skub conviction fades.")
	medical_record_text = "Patient wouldn't shut up about how bad skub is."
	mail_goodies = list(
		/obj/item/sticker/anti_skub,
		/obj/item/storage/box/stickers/anti_skub,
		/obj/item/clothing/suit/costume/wellworn_shirt/skub/anti,
	)

/datum/quirk/item_quirk/anti_skub/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/anti_skub_pin, list(LOCATION_BACKPACK, LOCATION_HANDS))
