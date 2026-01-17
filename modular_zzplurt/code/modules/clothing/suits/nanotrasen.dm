/obj/item/clothing/suit/armor/nanotrasen_formal
	name = "\improper Nanotrasen formal coat"
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
	desc = "A luxurious winter coat woven in cyan and silver colours of Nanotrasen. It has a small pin in the shape of the Nanotrasen logo for a zipper."
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
	name = "Nanotrasen winter coat"
	desc = "A luxurious winter coat woven in cyan and golden colours of Nanotrasen. It has a small pin in the shape of the Nanotrasen logo for a zipper."
	icon_state = "coatnanotrasen"
	armor_type = /datum/armor/wintercoat_captain
	hoodtype = /obj/item/clothing/head/hooded/winterhood/nanotrasen/gold

/obj/item/clothing/suit/hooded/wintercoat/nanotrasen/gold/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_wintercoat_allowed

/obj/item/clothing/suit/space/officer/nanotrasen
	name = "Nanotrasen officer's coat"
	desc = "A luxurious coat with genuine fur along the collar, a exotic suit worn by usually officers of Nanotrasen, it's woven with excellent fabrics, while also housing technology to render the wearer safe from space's vaccum, and freezing temperatures."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_coat"
	inhand_icon_state = "b_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/armor/nanotrasen_greatcoat
	name = "Nanotrasen officer's greatcoat"
	desc = "A luxurious, grand greatcoat with silver markings, a exotic suit worn by usually executives of Nanotrasen, it's woven with excellent fabrics to display rank."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "nanotrasen_greatcoat"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
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
