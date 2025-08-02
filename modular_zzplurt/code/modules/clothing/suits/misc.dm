/obj/item/clothing/suit/baroness
	name = "Baroness Dress"
	desc = "This dress is stained red due to the bloody history of its previous owner"
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "baroness"
	body_parts_covered = CHEST|GROIN|LEGS|FEET
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	flags_inv = HIDESHOES|HIDEUNDERWEAR

/obj/item/clothing/suit/baroness/ladyballat
	name = "Green Ball Dress"
	desc = "This dress looks a bit like the one an estranged aunt would wear."
	icon_state = "ladyballat"

/obj/item/clothing/suit/invisijacket
	name = "invisifiber jacket"
	desc = "A jacket made of transparent fibers, often used with reinforcement kits."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "jacket_transparent"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/toji
	name = "loose sweater"
	desc = "A loose fitting sweater that gently clings to your frame, like a playful cloud."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "loose_sweater"
	post_init_icon_state = "loose_sweater"
	icon_state_preview = "loose_sweater"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	body_parts_covered = CHEST|GROIN|ARMS
	greyscale_colors = "#FFFFFF"
	greyscale_config = /datum/greyscale_config/loose_sweater
	greyscale_config_worn = /datum/greyscale_config/loose_sweater/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/datum/greyscale_config/loose_sweater
	name = "Loose Sweater"
	icon_file = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	json_config = 'modular_zzplurt/code/datums/greyscale/json_configs/loose_sweater.json'

/datum/greyscale_config/loose_sweater/worn
	name = "Loose Sweater (Worn)"
	icon_file = 'modular_zzplurt/icons/mob/clothing/suit.dmi'

/obj/item/clothing/suit/large_jersey
	name = "loose jersey"
	desc = "A loose, airy jersey that exposes your arms, welcome to the gunshow."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "loose_jersey"
	post_init_icon_state = "loose_jersey"
	icon_state_preview = "loose_jersey"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	body_parts_covered = CHEST|GROIN
	greyscale_colors = "#FFFFFF"
	greyscale_config = /datum/greyscale_config/loose_jersey
	greyscale_config_worn = /datum/greyscale_config/loose_jersey/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/datum/greyscale_config/loose_jersey
	name = "Loose Jersey"
	icon_file = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	json_config = 'modular_zzplurt/code/datums/greyscale/json_configs/loose_jersey.json'

/datum/greyscale_config/loose_jersey/worn
	name = "Loose Jersey (Worn)"
	icon_file = 'modular_zzplurt/icons/mob/clothing/suit.dmi'

/obj/item/clothing/suit/hooded/oversized_hoodie
	name = "oversized hoodie"
	desc = "A cozy oversized hoodie."
	icon_state = "oversized_hoodie"
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	hoodtype = /obj/item/clothing/head/hooded/oversized_hood
	cold_protection = CHEST|GROIN|ARMS
	body_parts_covered = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/hooded/oversized_hood
	name = "oversized hood"
	desc = "An oversized hood that keeps you warm."
	icon_state = "hood_large"
	icon = 'modular_zzplurt/icons/obj/clothing/head.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/head.dmi'
	flags_inv = HIDEHAIR

//DS9
/obj/item/clothing/suit/storage/trek/ds9
	name = "Padded Overcoat"
	desc = "The overcoat worn by all officers of the 2380s."
	icon = 'modular_zzplurt/icons/obj/clothing/trek_item_icon.dmi'
	icon_state = "trek_ds9_coat"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/trek_mob_icon.dmi'
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	allowed = list(
		/obj/item/flashlight,
		/obj/item/analyzer,
		/obj/item/radio,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/reagent_containers/hypospray,
		/obj/item/healthanalyzer,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/cup/vial,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/applicator/pill,
		/obj/item/storage/pill_bottle,
		/obj/item/restraints/handcuffs,
		/obj/item/hypospray
		)
	armor_type = /datum/armor/none

/obj/item/clothing/suit/storage/trek/ds9/admiral
	name = "Admiral Overcoat"
	desc = "Admirality specialty coat to keep flag officers fashionable and protected."
	icon_state = "trek_ds9_coat_adm"
	armor_type = /datum/armor/admiral_coat

/datum/armor/admiral_coat
	melee = 50
	bullet = 50
	laser = 50
	energy = 50
	bomb = 50
	bio = 50
	fire = 50
	acid = 50

//For general use
/obj/item/clothing/suit/storage/fluff/fedcoat
	name = "Federation Uniform Jacket"
	desc = "A uniform jacket from the United Federation. Set phasers to awesome."
	icon = 'modular_zzplurt/icons/obj/clothing/trek_item_icon.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/trek_mob_icon.dmi'
	icon_state = "fedcoat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|GROIN|ARMS
	allowed = list(
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/flashlight,
		/obj/item/analyzer,
		/obj/item/radio,
		/obj/item/gun,
		/obj/item/melee/baton,
		/obj/item/restraints/handcuffs,
		/obj/item/reagent_containers/hypospray,
		/obj/item/hypospray,
		/obj/item/healthanalyzer,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/cup/vial,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/storage/pill_bottle,
		/obj/item/taperecorder)
	armor_type = /datum/armor/none
	var/unbuttoned = FALSE

/obj/item/clothing/suit/storage/fluff/fedcoat/verb/toggle()
	set name = "Toggle coat buttons"
	set category = "Object"
	set src in usr

	var/mob/living/L = usr
	if(!istype(L) || L.stat != CONSCIOUS)
		return FALSE

	switch(unbuttoned)
		if(FALSE)
			icon_state = "[initial(icon_state)]_open"
			unbuttoned = TRUE
			to_chat(usr,"You unbutton the coat.")
		if(TRUE)
			icon_state = "[initial(icon_state)]"
			unbuttoned = FALSE
			to_chat(usr,"You button up the coat.")

	usr.update_worn_oversuit()

//Variants
/obj/item/clothing/suit/storage/fluff/fedcoat/medsci
	icon_state = "fedblue"

/obj/item/clothing/suit/storage/fluff/fedcoat/eng
	icon_state = "fedeng"

/obj/item/clothing/suit/storage/fluff/fedcoat/capt
	icon_state = "fedcapt"

//"modern" ones for fancy

/obj/item/clothing/suit/storage/fluff/modernfedcoat
	name = "Modern Federation Uniform Jacket"
	desc = "A modern uniform jacket from the United Federation."
	icon = 'modular_zzplurt/icons/obj/clothing/trek_item_icon.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/trek_mob_icon.dmi'
	icon_state = "fedmodern"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	body_parts_covered = CHEST|GROIN|ARMS
	allowed = list(
		/obj/item/flashlight,
		/obj/item/analyzer,
		/obj/item/radio,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/reagent_containers/hypospray,
		/obj/item/healthanalyzer,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/cup/vial,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/applicator/pill,
		/obj/item/storage/pill_bottle,
		/obj/item/restraints/handcuffs,
		/obj/item/hypospray
		)
	armor_type = /datum/armor/none

//Variants
/obj/item/clothing/suit/storage/fluff/modernfedcoat/medsci
	icon_state = "fedmodernblue"

/obj/item/clothing/suit/storage/fluff/modernfedcoat/eng
	icon_state = "fedmoderneng"

/obj/item/clothing/suit/storage/fluff/modernfedcoat/sec
	icon_state = "fedmodernsec"
