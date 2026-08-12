GLOBAL_LIST_INIT(fandom_choices, list(
	"Clown",
	"Mime",
	"Pro skub",
	"Anti skub",
))

/proc/normalize_fandom_choice(fandom_choice)
	if(fandom_choice in GLOB.fandom_choices)
		return fandom_choice
	return "Clown"

/proc/get_fandom_quirk_metadata(fandom_choice)
	var/normalized_choice = normalize_fandom_choice(fandom_choice)

	switch(normalized_choice)
		if("Mime")
			return list(
				"choice" = normalized_choice,
				"pin_type" = /obj/item/clothing/accessory/mime_fan_pin,
				"mob_trait" = TRAIT_MIME_FAN,
				"gain_text" = span_notice("You are a big fan of the Mime."),
				"lose_text" = span_danger("The mime doesn't seem so great."),
				"medical_record_text" = "Patient reports being a big fan of mimes.",
				"mail_goodies" = list(
					/obj/item/toy/crayon/mime,
					/obj/item/clothing/mask/gas/mime,
					/obj/item/storage/backpack/mime,
					/obj/item/clothing/under/rank/civilian/mime,
					/obj/item/reagent_containers/cup/glass/bottle/bottleofnothing,
					/obj/item/stamp/mime,
					/obj/item/storage/box/survival/hug/black,
					/obj/item/bedsheet/mime,
					/obj/item/clothing/shoes/sneakers/mime,
					/obj/item/toy/figure/mime,
					/obj/item/toy/crayon/spraycan/mimecan,
				),
			)
		if("Pro skub")
			return list(
				"choice" = normalized_choice,
				"pin_type" = /obj/item/clothing/accessory/pro_skub_pin,
				"mob_trait" = TRAIT_PRO_SKUB,
				"gain_text" = span_notice("You are proudly pro-skub."),
				"lose_text" = span_danger("Your pro-skub conviction wanes."),
				"medical_record_text" = "Patient wouldn't shut up about how good skub is.",
				"mail_goodies" = list(
					/obj/item/skub,
					/obj/item/sticker/skub,
					/obj/item/storage/box/stickers/skub,
					/obj/item/clothing/suit/costume/wellworn_shirt/skub,
				),
			)
		if("Anti skub")
			return list(
				"choice" = normalized_choice,
				"pin_type" = /obj/item/clothing/accessory/anti_skub_pin,
				"mob_trait" = TRAIT_ANTI_SKUB,
				"gain_text" = span_notice("You stand against skub."),
				"lose_text" = span_danger("Your anti-skub conviction fades."),
				"medical_record_text" = "Patient wouldn't shut up about how bad skub is.",
				"mail_goodies" = list(
					/obj/item/sticker/anti_skub,
					/obj/item/storage/box/stickers/anti_skub,
					/obj/item/clothing/suit/costume/wellworn_shirt/skub/anti,
				),
			)

	return list(
		"choice" = "Clown",
		"pin_type" = /obj/item/clothing/accessory/clown_enjoyer_pin,
		"mob_trait" = TRAIT_CLOWN_ENJOYER,
		"gain_text" = span_notice("You are a big enjoyer of clowns."),
		"lose_text" = span_danger("The clown doesn't seem so great."),
		"medical_record_text" = "Patient reports being a big enjoyer of clowns.",
		"mail_goodies" = list(
			/obj/item/bikehorn,
			/obj/item/stamp/clown,
			/obj/item/megaphone/clown,
			/obj/item/clothing/shoes/clown_shoes,
			/obj/item/bedsheet/clown,
			/obj/item/clothing/mask/gas/clown_hat,
			/obj/item/storage/backpack/clown,
			/obj/item/storage/backpack/duffelbag/clown,
			/obj/item/toy/crayon/rainbow,
			/obj/item/toy/figure/clown,
			/obj/item/tank/internals/emergency_oxygen/engi/clown/n2o,
			/obj/item/tank/internals/emergency_oxygen/engi/clown/bz,
			/obj/item/tank/internals/emergency_oxygen/engi/clown/helium,
		),
	)

/datum/quirk_constant_data/fandom
	associated_typepath = /datum/quirk/item_quirk/fandom
	customization_options = list(/datum/preference/choiced/fandom)

/datum/quirk/item_quirk/clown_enjoyer
	hidden_quirk = TRUE

/datum/quirk/item_quirk/mime_fan
	hidden_quirk = TRUE

/datum/quirk/item_quirk/fandom
	name = "Partisan Ideologue"
	desc = "You're an enthusiastic fan of something very specific and get a mood boost from wearing a matching pin."
	icon = FA_ICON_TAG
	value = 2
	var/fandom_choice = "Clown"
	var/pin_type = /obj/item/clothing/accessory/clown_enjoyer_pin

/datum/quirk/item_quirk/fandom/add_to_holder(mob/living/new_holder, quirk_transfer, client/client_source, unique = TRUE, announce = FALSE)
	var/list/fandom_metadata = get_fandom_quirk_metadata(client_source?.prefs?.read_preference(/datum/preference/choiced/fandom))

	fandom_choice = fandom_metadata["choice"]
	pin_type = fandom_metadata["pin_type"]
	mob_trait = fandom_metadata["mob_trait"]
	gain_text = fandom_metadata["gain_text"]
	lose_text = fandom_metadata["lose_text"]
	medical_record_text = fandom_metadata["medical_record_text"]
	mail_goodies = fandom_metadata["mail_goodies"]
	return ..()

/datum/quirk/item_quirk/fandom/add_unique(client/client_source)
	give_item_to_holder(pin_type, list(LOCATION_BACKPACK, LOCATION_HANDS))

/datum/quirk/item_quirk/pro_skub
	name = "Pro-Skub"
	desc = "You are firmly pro-skub and get a mood boost from wearing your pro-skub pin."
	icon = FA_ICON_FLAG
	value = 2
	hidden_quirk = TRUE
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
	icon = FA_ICON_FLAG_CHECKERED
	value = 2
	hidden_quirk = TRUE
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
