/obj/item/clothing/suit/chaplainsuit/armor/templar/hospitaller
	icon = 'modular_skyrat/master_files/icons/obj/clothing/suits/chaplain.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/suits/chaplain.dmi'
	desc = "Protect the weak and defenceless, live by honor and glory, and fight for the welfare of all!"
	icon_state = "knight_hospitaller"
	unique_reskin = null

/obj/item/clothing/suit/chaplainsuit/armor/templar/hospitaller/no_armor
	armor_type = /datum/armor/none

//
/obj/item/clothing/suit/goner
	name = "trencher coat"
	desc = "A generic trench coat of the boring wars. This one have purple, corporate insignias."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/suit_digi.dmi'
	icon_state = "goner_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	armor_type = /datum/armor/suit_armor/goner

/datum/armor/suit_armor/goner
	melee = 25
	bullet = 10
	laser = 25
	energy = 10
	bomb = 5
	bio = 5
	fire = 50
	acid = 45
	wound = 10

/obj/item/clothing/suit/goner/Initialize(mapload)
	. = ..()
	allowed = GLOB.detective_vest_allowed + typecacheof(/obj/item/toy)

/obj/item/clothing/suit/goner/fake
	name = "trencher coat replica"
	desc = "A 90% replica of No Man's Land-type coat. Obviously won't protect you from the blastwave."
	armor_type = /datum/armor/none
	uses_advanced_reskins = TRUE // Since polychromic no longer available at least allow us to reskin it after GWTB armies colors.
	unique_reskin = list(
		"Default (Purple)" = list(
			RESKIN_ICON = 'modular_zzplurt/icons/obj/clothing/suits.dmi',
			RESKIN_ICON_STATE = "goner_suit",
			RESKIN_WORN_ICON = 'modular_zzplurt/icons/mob/clothing/suit.dmi',
			RESKIN_WORN_ICON_STATE = "goner_suit"
		),
		"Red" = list(
			RESKIN_ICON = 'modular_zzplurt/icons/obj/clothing/suits.dmi',
			RESKIN_ICON_STATE = "goner_suit_r",
			RESKIN_WORN_ICON = 'modular_zzplurt/icons/mob/clothing/suit.dmi',
			RESKIN_WORN_ICON_STATE = "goner_suit_r"
		),
		"Green" = list(
			RESKIN_ICON = 'modular_zzplurt/icons/obj/clothing/suits.dmi',
			RESKIN_ICON_STATE = "goner_suit_g",
			RESKIN_WORN_ICON = 'modular_zzplurt/icons/mob/clothing/suit.dmi',
			RESKIN_WORN_ICON_STATE = "goner_suit_g"
		),
		"Blue" = list(
			RESKIN_ICON = 'modular_zzplurt/icons/obj/clothing/suits.dmi',
			RESKIN_ICON_STATE = "goner_suit_b",
			RESKIN_WORN_ICON = 'modular_zzplurt/icons/mob/clothing/suit.dmi',
			RESKIN_WORN_ICON_STATE = "goner_suit_b"
		),
		"Yellow" = list(
			RESKIN_ICON = 'modular_zzplurt/icons/obj/clothing/suits.dmi',
			RESKIN_ICON_STATE = "goner_suit_y",
			RESKIN_WORN_ICON = 'modular_zzplurt/icons/mob/clothing/suit.dmi',
			RESKIN_WORN_ICON_STATE = "goner_suit_y"
		)
	)

//
/obj/item/clothing/suit/goner/red
	name = "red trencher coat"
	desc = "A trench coat of the boring wars. This one have red insignias."
	icon_state = "goner_suit_r"

/obj/item/clothing/suit/goner/green
	name = "green trencher coat"
	desc = "A trench coat of the boring wars. This one have green insignias."
	icon_state = "goner_suit_g"

/obj/item/clothing/suit/goner/blue
	name = "blue trencher coat"
	desc = "A trench coat of the boring wars. This one have blue insignias."
	icon_state = "goner_suit_b"

/obj/item/clothing/suit/goner/yellow
	name = "yellow trencher coat"
	desc = "A trench coat of the boring wars. This one have yellow insignias."
	icon_state = "goner_suit_y"

/obj/item/clothing/suit/armor/vest/harness
	name = "armored harness"
	desc = "A simple, inconspicuous harness replacement for an armor vest."
	icon = 'modular_zubbers/icons/obj/clothing/suits.dmi'
	icon_state = "suit_harness"
	worn_icon = 'modular_zubbers/icons/mob/clothing/suits.dmi'
	worn_icon_state = "suit_harness"
	inhand_icon_state = "armor"

/obj/item/clothing/suit/hooded/explorer/explorerharness
	name = "explorer suit harness"
	desc = "An armored harness for those who are more daring than others or just like to show off the goods as they mine."
	hood_up_affix = ""
	icon = 'modular_skyrat/master_files/icons/obj/clothing/under/misc.dmi'
	icon_state = "gear_harness"
	worn_icon = 'modular_zubbers/icons/mob/clothing/suits.dmi'
	worn_icon_state = "suit_harness"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	hoodtype = /obj/item/clothing/head/hooded/explorer/invisiblehood

/obj/item/clothing/head/hooded/explorer/invisiblehood
	name = "invisifiber hood"
	desc = "A hood made of transparent fibers, this one is used for the hood of the explorer gear harness"
	icon = 'modular_zzplurt/icons/obj/clothing/head.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "hat_transparent"
	worn_icon_state = "none"
	flags_inv = NONE
