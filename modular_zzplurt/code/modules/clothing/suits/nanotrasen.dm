/obj/item/clothing/suit/hooded/wintercoat/nanotrasen
	name = "Nanotrasen winter coat"
	desc = "A stylish, corporate wintercoat in Nanotrasen turquoise. It's crafted with durathread-infused fabric.. Mostly fabric though, making it slightly armored but a straight downgrade from normal vests. It has silver markings, it displays the emblems and insignia of Nanotrasen. It has a small silver Nanotrasen logo for a zipper."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "coatnanotrasen_s"
	inhand_icon_state = "b_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/wintercoat_security
	hoodtype = /obj/item/clothing/head/hooded/winterhood/nanotrasen

/obj/item/clothing/suit/hooded/wintercoat/nanotrasen/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_wintercoat_allowed

/obj/item/clothing/suit/hooded/wintercoat/nanotrasen/gold
	name = "Nanotrasen officer's winter coat"
	desc = "A luxurious, corporate wintercoat in Nanotrasen turquoise. It's crafted with durathread-infused fabric. making it a safe choice for those who wish to be armored and warm. It has golden markings, it displays the emblems of Nanotrasen and insignia of NT Executives. It has a small golden Nanotrasen logo for a zipper."
	icon_state = "coatnanotrasen"
	armor_type = /datum/armor/wintercoat_captain
	hoodtype = /obj/item/clothing/head/hooded/winterhood/nanotrasen/gold

/obj/item/clothing/suit/hooded/wintercoat/nanotrasen/gold/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_wintercoat_allowed

/obj/item/clothing/suit/armor/nanotrasen_formal
	name = "Nanotrasen officer's formal coat"
	desc = "A formal coat in teal colors, it's very decorated. It's dawned with Nanotrasen emblems and NT Executive insignias. It was crafted with durathread-infused fabric, making it a bit heavy. However much more safe than normal clothing."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_formal"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/vest_capcarapace

/obj/item/clothing/suit/armor/nanotrasen_formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/armor/nanotrasen_winter
	name = "Nanotrasen officer's winter formal coat"
	desc = "A cozy, winter formal coat in teal colors, it's very decorated and warm. It's dawned with Nanotrasen emblems and NT Executive insignias. It was crafted with durathread-infused fabric, making it a bit heavy. However much more safe than normal clothing."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_formalwinter"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/vest_capcarapace

/obj/item/clothing/suit/armor/nanotrasen_greatcoat
	name = "Nanotrasen officer's greatcoat"
	desc = "A large, heavily padded greatcoat in teal colors, there's golden epaulettes and aiguillettes on the coat, heavily ceremonial. It's dawned with Nanotrasen emblems and NT Executive insignias. It was crafted with durathread-infused fabric, making it a bit heavy. However much more safe than normal formal pieces, it's topped with a black Sam Browne belt with golden buckles with the Nanotrasen logo engraved in them."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_greatcoat"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/vest_capcarapace

/obj/item/clothing/suit/armor/nanotrasen_overcoat
	name = "Nanotrasen officer's overcoat"
	desc = "A large overcoat in teal colors, it's not very decorated. It's barely dawned with Nanotrasen emblems and NT Executive insignias. It was crafted with durathread-infused fabric, making it a bit heavy. However much more safe than normal clothing."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_overcoat"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/vest_capcarapace

/obj/item/clothing/suit/armor/nanotrasen_furred_greatcoat
	name = "Nanotrasen officer's furred greatcoat"
	desc = "A large, heavily padded furred greatcoat in teal colors, you already feel incredibly warm just seeing this thing, based off of old soviet russian designs. It's dawned with Nanotrasen emblems and NT Executive insignias. It was crafted with durathread-infused fabric, making it a bit heavy. However much more safe than normal formal pieces, it's topped with a dark grey belt with a golden buckle with the Nanotrasen logo engraved in it."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_furredcoat"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/vest_capcarapace

/obj/item/clothing/suit/armor/nanotrasen_trenchcoat
	name = "Nanotrasen officer's winter trenchcoat"
	desc = "A heavy-looking trenchcoat with real imported fur from the Solarian System along the collar, there's Nanotrasen Executive insignia along the shoulders. An extremely warm, and comforting piece of clothing. It was crafted with durathread-infused fabric, making it a bit heavy. However much more safer than a normal piece of clothing."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_coat"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/vest_capcarapace

/obj/item/clothing/suit/armor/vest/capcarapace/nanotrasen
	name = "Nanotrasen carapace"
	desc = "A fireproof armored chestpiece reinforced with ceramic plates and plasteel pauldrons to provide additional protection whilst still offering maximum mobility and flexibility. Issued only to Nanotrasen's finest, although it does chafe your nipples."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_vest"
	inhand_icon_state = "b_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/vest_capcarapace

/obj/item/clothing/suit/armor/vest/classic_jacket
	name = "Nanotrasen consultant's jacket"
	desc = "An expensive durathread-infused jacket with a golden badge on the chest and the Nanotrasen logo emblazoned on the back. It weighs surprisingly little, despite how heavy it looks, not to mention the genuine fur which makes it only more cozy to wear, you already feel nostalgic just looking at it."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "classic_nanotrasen"
	body_parts_covered = CHEST|ARMS
	cold_protection = CHEST|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/vest_capcarapace

/obj/item/clothing/suit/armor/vest/classic_jacket/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

//Donation reward for Hacker T.Dog
/obj/item/clothing/suit/armor/vest/nanotrasen_consultant/hubert
	name = "Nanotrasen executive's armored vest"
	desc = "A heavy-looking, yet snug and comfortable heavy-duty webbing vest, however the vest itself doesn't even seem to have any storage.. Are these pouches just for show? At least it's heavily plated to protect you as you sit in your office."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_webvest"
	body_parts_covered = CHEST
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/vest_capcarapace
