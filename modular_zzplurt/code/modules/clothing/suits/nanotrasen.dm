/obj/item/clothing/suit/armor/nanotrasen_formal
	name = "\improper Nanotrasen officer's formal coat"
	desc = "A stylish coat given to Nanotrasen Officers. Perfect for sending representatives to suicide missions with style!"
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_formal"
	inhand_icon_state = "b_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/vest_capcarapace

/obj/item/clothing/suit/armor/nanotrasen_formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

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

/obj/item/clothing/suit/armor/nanotrasen_greatcoat
	name = "Nanotrasen officer's greatcoat"
	desc = "A large, heavily padded greatcoat in turquoise colors, there's golden epaulettes and aiguillettes on the coat, heavily ceremonial. It's dawned with Nanotrasen emblems and NT Executive insignias. It was crafted with durathread-infused fabric, making it a bit heavy. However much more safe than normal formal pieces, it's topped with a black Sam Browne belt with golden buckles with the Nanotrasen logo engraved in them."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_greatcoat"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/vest_capcarapace

/obj/item/clothing/suit/armor/vest/nt_officerfake
	name = "Nanotrasen officer's coat"
	desc = "A luxurious coat with synthetic fur along the collar, a exotic suit worn by usually officers of Nanotrasen it's woven with excellent fabrics. This one lacks the special tech of space protection, which hinders it just as a piece of clothing."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_coat"
	inhand_icon_state = "b_suit"
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
