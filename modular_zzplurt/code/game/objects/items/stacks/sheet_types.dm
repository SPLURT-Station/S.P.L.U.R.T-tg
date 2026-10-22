GLOBAL_LIST_INIT(splurt_wood_recipes, list(
	new /datum/stack_recipe("large painting frame", /obj/item/wallframe/painting/large, 2, time = 1 SECONDS, crafting_flags = NONE, category = CAT_ENTERTAINMENT),
))

/obj/item/stack/sheet/mineral/wood/get_main_recipes()
	. = ..()
	. += GLOB.splurt_wood_recipes
