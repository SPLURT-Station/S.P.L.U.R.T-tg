/obj/item/weaponcrafting/gunkit/wt458_kit
	name = "WT-458 conversion kit"
	desc = "Contains all the necessary parts, components and disposable tools. Feels strangely lightweight despite some of the titanium bits."

/obj/item/weaponcrafting/gunkit/assault_laser
	name = "Assault Laser Rifle kit"
	desc = "Contains all the necessary parts, components and disposable tools. Feels strangely lightweight despite some of the titanium bits."

/datum/crafting_recipe/wt458
	name = "WT-458 Conversion Kit"
	result = /obj/item/gun/ballistic/automatic/wt458
	reqs = list(
		/obj/item/weaponcrafting/gunkit/wt458_kit = 1,
		/obj/item/gun/ballistic/automatic/wt550/security = 1,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/assault_laser
	name = "Assault Laser Rifle Kit"
	result = /obj/item/gun/energy/laser/assault/security
	reqs = list(
		/obj/item/weaponcrafting/gunkit/assault_laser= 1,
		/obj/item/gun/energy/laser = 1,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED
