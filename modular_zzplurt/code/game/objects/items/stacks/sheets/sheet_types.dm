GLOBAL_LIST_INIT(shadow_wood_recipes, list ( \
	new /datum/stack_recipe("shadow wood floor tile", /obj/item/stack/tile/wood/shadow, 1, 4, 20), \
	new /datum/stack_recipe("shadow wood table frame", /obj/structure/table_frame/shadow_wood, 2, time = 10), \
	new /datum/stack_recipe("shadow wood chair", /obj/structure/chair/wood/shadow, 3, time = 10, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("shadow wood crate", /obj/structure/closet/crate/wooden/shadow, 6, time = 50, one_per_turf = TRUE, on_floor = TRUE),\
	new /datum/stack_recipe("shadow wood bed", /obj/structure/bed/shadow, 2, time = 70, one_per_turf = TRUE, on_floor = TRUE),\
	new /datum/stack_recipe("shadow wood double bed", /obj/structure/bed/double/shadow, 4, time = 140, one_per_turf = TRUE, on_floor = TRUE),\
	new /datum/stack_recipe("shadow wood barricade", /obj/structure/barricade/wooden/shadow, 5, time = 50, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("shadow wood dog bed", /obj/structure/bed/dogbed/shadow, 10, time = 10, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("shadow wood dresser", /obj/structure/dresser/shadow, 10, time = 15, one_per_turf = TRUE, on_floor = TRUE), \
	))

/obj/item/stack/sheet/mineral/wood/shadow
	name = "shadow wood"
	desc = "An purplish wood, it has nothing of special besides its color."
	singular_name = "shadow wood plank"
	icon_state = "sheet-shadow_wood"
	icon = 'modular_zzplurt/icons/obj/stack_objects.dmi'
	sheettype = "shadow_wood"
	merge_type = /obj/item/stack/sheet/mineral/wood/shadow
	novariants = TRUE
	grind_results = list(/datum/reagent/carbon = 20)
	walltype = /turf/closed/wall/mineral/wood/shadow

/obj/item/stack/sheet/mineral/wood/shadow/Initialize(mapload, new_amount, merge = TRUE)
	. = ..()
	recipes = GLOB.shadow_wood_recipes

/obj/item/stack/sheet/mineral/wood/shadow/fifty
	amount = 50
