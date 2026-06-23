// Материалы для шатлов

/obj/item/stack/sheet/spaceship
	name = "обшивка космического корабля" // spaceship plating
	desc = "Металлический лист из титанового сплава, склепанный для использования в стенах космических кораблей." // A metal sheet made out of a titanium alloy, rivited for use in spaceship walls.
	icon = 'fenysha_events/icons/items/shipstacks.dmi'
	icon_state = "sheet-spaceship"
	inhand_icon_state = "sheet-plastitaniumglass"
	singular_name = "пластина космического корабля" // spaceship plate
	construction_path_type = "spaceship"
	merge_type = /obj/item/stack/sheet/spaceship
	walltype = /turf/closed/wall/mineral/titanium/spaceship
	mats_per_unit = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT)

/obj/item/stack/sheet/spaceshipglass
	name = "стекла обшивки окон" // spaceship window plates
	desc = "Стеклянный лист из титано-силикатного сплава, склепанный для использования в рамах окон космических кораблей." // A glass sheet made out of a titanium-silicate alloy, rivited for use in spaceship window frames.
	icon = 'fenysha_events/icons/items/shipstacks.dmi'
	icon_state = "sheet-spaceshipglass"
	inhand_icon_state = "sheet-plastitaniumglass"
	singular_name = "пластина окна космического корабля" // spaceship window plate
	merge_type = /obj/item/stack/sheet/spaceshipglass
	mats_per_unit = list(/datum/material/alloy/plastitaniumglass = SHEET_MATERIAL_AMOUNT)

GLOBAL_LIST_INIT(spaceshipglass_recipes, list(
	new/datum/stack_recipe("spaceship window", /obj/structure/window/reinforced/shuttle/spaceship/unanchored, 2, time = 4 SECONDS,  crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_IS_FULLTILE, category = CAT_WINDOWS), \
	))

/obj/item/stack/sheet/spaceshipglass/get_main_recipes()
	. = ..()
	. += GLOB.spaceshipglass_recipes
