// Boatcloaks
/obj/item/clothing/neck/cloak/alt/boatcloak
	name = "boatcloak"
	desc = "A simple, short-ish boatcloak."
	icon = 'modular_zzplurt/icons/obj/clothing/neck.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/neck.dmi'
	icon_state = "boatcloak"
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/neck/cloak/alt/boatcloak/command
	name = "command boatcloak"
	desc = "A boatcloak with gold ribbon."
	icon_state = "boatcloak_com"
	body_parts_covered = CHEST|LEGS|ARMS

/obj/item/clothing/neck/cloak/alt/boatcloak/greyscale
	name = "colorable boatcloak"
	desc = "Colorable short-ish boatcloak."
	icon = 'icons/map_icons/clothing/neck.dmi'
	icon_state = "/obj/item/clothing/neck/cloak/alt/boatcloak/greyscale"
	post_init_icon_state = "boatcloak"
	greyscale_colors = "#EEEEEE"
	greyscale_config = /datum/greyscale_config/boatcloak
	greyscale_config_worn = /datum/greyscale_config/boatcloak/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/datum/greyscale_config/boatcloak
	name = "Boatcloak"
	icon_file = 'modular_zzplurt/icons/obj/clothing/neck.dmi'
	json_config = 'modular_zzplurt/code/datums/greyscale/json_configs/boatcloak.json'

/datum/greyscale_config/boatcloak/worn
	name = "Boatcloak (Worn)"
	icon_file = 'modular_zzplurt/icons/mob/clothing/neck.dmi'

//Donor item for girko
/obj/item/clothing/suit/hooded/cloak/determinations_cloak
	name = "Determinations cloak"
	desc = "A lovingly crafted and modified cloak which has a stitching in it reading 'Made with love by L.Y.D.I.A', A modification of the zul-e cloak specifically adapted and tailored for Determination however wearable by anybody who wishes to appreciate it."
	icon_state = "determinations_cloak"
	icon = 'modular_zzplurt/icons/obj/clothing/neck.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/neck.dmi'
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/determinations_cloakcap
	body_parts_covered = CHEST|GROIN|ARMS
	slot_flags = ITEM_SLOT_OCLOTHING | ITEM_SLOT_NECK
	supports_variations_flags = NONE

/obj/item/clothing/head/hooded/cloakhood/determinations_cloakcap
	name = "Determinations Cloak Hood"
	desc = "A beret fitting to the cloak attached"
	icon_state = "determinations_cloakcap"
	icon = 'modular_zzplurt/icons/obj/clothing/neck.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/neck.dmi'
	flags_inv = null
	supports_variations_flags = NONE
