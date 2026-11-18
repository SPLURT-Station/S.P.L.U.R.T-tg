/datum/controller/subsystem/mapping/setup_ruins()
	// Taeloth / Jungle Ruins, Rimpoint
	var/list/jungle_ruins = levels_by_trait(ZTRAIT_JUNGLE_RUINS)
	if(jungle_ruins.len)
		seedRuins(jungle_ruins, CONFIG_GET(number/jungle_budget), list(/area/taeloth/outdoors/unexplored), themed_ruins[ZTRAIT_JUNGLE_RUINS], clear_below = TRUE)

	// Taeloth Caves / Jungle Cave Ruins, Rimpoint
	var/list/jungle_cave_ruins = levels_by_trait(ZTRAIT_JUNGLE_CAVE_RUINS)
	if(jungle_cave_ruins.len)
		seedRuins(jungle_ruins, CONFIG_GET(number/jungle_cave_budget), list(/area/taeloth/underground/unexplored), themed_ruins[ZTRAIT_JUNGLE_CAVE_RUINS], clear_below = TRUE)
