/obj/item/weaponcrafting/gunkit/wt458_kit
	name = "WT-458 conversion kit"
	desc = "Contains all the necessary parts, components and disposable tools. Feels strangely lightweight despite some of the titanium bits."

/datum/crafting_recipe/wt458
	name = "WT-458 Conversion Kit"
	result = /obj/item/gun/ballistic/automatic/wt458/nomag
	reqs = list(
		/obj/item/weaponcrafting/gunkit/wt458_kit = 1,
		/obj/item/gun/ballistic/automatic/wt550/security = 1,
	)
	steps = list(
		"Take out the magazine",
		"Leave the rifle unchambered"
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/wt458/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/gun/ballistic/automatic/wt550/security/the_gun = collected_requirements[/obj/item/gun/ballistic/automatic/wt550/security][1]
	if(the_gun.magazine || the_gun.chambered)
		return FALSE
	return ..()
