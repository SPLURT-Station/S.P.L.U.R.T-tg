/obj/item/weaponcrafting/gunkit/wt458_kit
	name = "WT-458 conversion kit"
	desc = "Contains all the necessary parts, components and disposable tools. Feels strangely lightweight despite some of the titanium bits."
	custom_materials = list(
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 20,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 15,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 4,
	)

/datum/crafting_recipe/wt458
	name = "WT-458 Conversion Kit"
	result = /obj/item/gun/ballistic/automatic/wt458/nomag
	reqs = list(
		/obj/item/weaponcrafting/gunkit/wt458_kit = 1,
		/obj/item/gun/ballistic/automatic/wt550 = 1,
	)
	blacklist = list(
		/obj/item/gun/ballistic/automatic/wt550/burst,
		/obj/item/gun/ballistic/automatic/wt550/dmr,
		/obj/item/gun/ballistic/automatic/wt550/loyalpin,
	)
	steps = list(
		"Take out the magazine",
		"Leave the rifle unchambered"
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/wt458/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/gun/ballistic/automatic/wt550/the_gun = collected_requirements[/obj/item/gun/ballistic/automatic/wt550][1]
	if(the_gun.magazine || the_gun.chambered)
		return FALSE
	return ..()
