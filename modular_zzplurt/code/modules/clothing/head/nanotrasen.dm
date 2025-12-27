/obj/item/clothing/head/hooded/winterhood/nanotrasen
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "hood_nanotrasen_s"
	armor_type = /datum/armor/winterhood_security

/obj/item/clothing/head/hooded/winterhood/nanotrasen/gold
	icon_state = "hood_nanotrasen"
	armor_type = /datum/armor/winterhood_captain

/obj/item/clothing/head/beret/nanotrasen_formal
	name = "\improper Nanotrasen formal beret"
	desc = "Sometimes, a compromise between fashion and defense needs to be made. Thanks to Nanotrasen's most recent nano-fabric durability enhancements, this time, it's not the case."
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "nanotrasen_beret"
	post_init_icon_state = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null
	armor_type = /datum/armor/cosmetic_sec
	strip_delay = 10 SECONDS

/obj/item/clothing/head/beret/nanotrasen_formal/gold
	name = "\improper Nanotrasen officer's beret"
	desc = "Sometimes, a compromise between fashion and defense needs to be made. Thanks to Nanotrasen's most recent nano-fabric durability enhancements, this time, it's not the case."
	icon_state = "nanotrasen_officer_beret"
	armor_type = /datum/armor/hats_caphat

/obj/item/clothing/head/hats/nanotrasen_cap
	name = "\improper Nanotrasen officer cap"
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "nanotrasen_cap"
	desc = "A luxurious peaked cap, worn by only Nanotrasen's finest officers. Inside the lining of the cap, lies two faint initials."
	inhand_icon_state = "that"
	flags_inv = 0
	armor_type = /datum/armor/hats_caphat
	strip_delay = 8 SECONDS
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON //SKYRAT EDIT lets anthros wear the hat

/obj/item/clothing/head/hats/nanotrasen_cap/lowrank
	name = "\improper Nanotrasen peaked cap"
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "nanotrasen_cap_2"
	desc = "A peaked cap, worn by Nanotrasen officials. Inside the lining of the cap, lies two faint initials."
	armor_type = /datum/armor/cosmetic_sec

/obj/item/clothing/head/hats/nanotrasenhat
	name = "\improper Nanotrasen hat"
	desc = "It's good to be god."
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "nanotrasen"
	inhand_icon_state = "that"
	flags_inv = 0
	armor_type = /datum/armor/hats_caphat
	strip_delay = 8 SECONDS

/obj/item/clothing/head/hats/intern/nanotrasen
	name = "\improper Nanotrasen Head Intern beancap"
	desc = "A horrifying mix of beanie and softcap in Nanotrasen blue. You'd have to be pretty desperate for power over your peers to agree to wear this."
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "nt_intern_hat"
	inhand_icon_state = null

/obj/item/clothing/head/hats/warden/drill/nanotrasen/nt
	name = "Nanotrasen campaign hat"
	desc = "A variant of the warden's campaign hat for your more militaristic corporate executives."
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	icon_state = "nanodrill"
	armor_type = /datum/armor/hats_centhat

/obj/item/clothing/mask/gas/atmos/nanotrasen
	name = "\improper Nanotrasen gas mask"
	desc = "Oooh, silver and blue. Fancy! This should help as you sit in your office, it's flexibility makes it easy to fit it in smaller locations, making it a must-have for survival and space management."
	icon = 'modular_zzplurt/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/mask.dmi'
	worn_icon_state = "gas_nanotrasen"
	icon_state = "gas_nanotrasen"
	inhand_icon_state = "gas_nanotrasen"
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/clothing/masks_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/clothing/masks_righthand.dmi'
	resistance_flags = FIRE_PROOF | ACID_PROOF
	w_class = WEIGHT_CLASS_SMALL
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION | CLOTHING_SNOUTED_VOX_VARIATION
