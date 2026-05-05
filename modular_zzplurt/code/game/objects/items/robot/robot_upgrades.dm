/obj/item/borg/upgrade/bellyriding_harness
	name = "cyborg bellyriding harness module"
	desc = "An augmentation that equips compatible cyborgs with a bellyriding restraint harness module."
	icon = 'modular_skyrat/modules/borgs/icons/robot_items.dmi'
	icon_state = "module_lust"
	items_to_add = list(/obj/item/borg/bellyriding_harness)

/obj/item/borg/upgrade/bellyriding_harness/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)

/datum/design/borg_upgrade_bellyriding_harness
	name = "Bellyriding Harness Module"
	id = "borg_upgrade_bellyriding_harness"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/bellyriding_harness
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL
	)
