/datum/crafting_recipe/armored_harness
	name = "Armored Harness"
	result = /obj/item/clothing/suit/armor/vest/harness
	time = 5 SECONDS
	reqs = list(
		/obj/item/clothing/suit/armor/vest = 1,
		/obj/item/stack/sheet/cloth = 3,
		/obj/item/stack/cable_coil = 15,
	)
	category = CAT_CLOTHING

/datum/crafting_recipe/hudsunadmin
	name = "Administrative HUDsunglasses"
	result = /obj/item/clothing/glasses/hud/administrative/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/administrative = 1,
				  /obj/item/clothing/glasses/sunglasses = 1,
				  /obj/item/stack/cable_coil = 5)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/hudsunadminremoval
	name = "Administrative HUD removal"
	result = /obj/item/clothing/glasses/sunglasses
	time = 2 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	reqs = list(/obj/item/clothing/glasses/hud/administrative/sunglasses = 1)
	category = CAT_EQUIPMENT
