//generic roundstart armor, bare minimum stuff that's absolutely needed if you want your mech to be effective
/datum/design/mech_armor
	name = "Basic Mech Armor"
	desc = "Sacrificial plate of metal, designed to increase survivability. Standard issue for civillian exosuits."
	id = "mech_armor_basic"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/armor/basic
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 2)
	construction_time = 5 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MODULES,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_ODYSSEUS + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PADDY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

//heavy mech armor, very slow but also soaks a lot more damage
/datum/design/mech_armor/heavy
	name = "Heavy Mech Armor"
	desc = "Sacrificial plasteel plates for heavy duty reinforcement, twice as durable as basic mech armor but slows you down considerably."
	build_path = /obj/item/mecha_parts/mecha_equipment/armor/heavy
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/plasma = SHEET_MATERIAL_AMOUNT * 3, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 2)
