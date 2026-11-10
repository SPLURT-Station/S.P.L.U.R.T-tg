/**********************Taeloth Areas**************************/

/area/taeloth
	name = "Taeloth"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "explored"
	default_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = VALID_TERRITORY
	area_flags_mapping = UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	sound_environment = SOUND_ENVIRONMENT_FOREST
	ambience_index = AMBIENCE_HOLY
	allow_shuttle_docking = TRUE
	map_generator = /datum/map_generator/jungle_generator
	use_mapgen = FALSE

/area/taeloth/outdoors
	name = "Taeloth Central Grounds"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	area_flags = VALID_TERRITORY
	outdoors = TRUE

/area/taeloth/outdoors/Initialize(mapload)
	if(HAS_TRAIT(SSstation, STATION_TRAIT_BRIGHT_DAY))
		base_lighting_alpha = 145
	return ..()

/area/taeloth/outdoors/roof // This is the only way I know how to make rain not drop where there's a fucking roof.
	outdoors = FALSE

/area/taeloth/outdoors/roof/powered // Literally just because I'm too lazy to mark every powered item outside as unrequiring power.
	always_unpowered = FALSE
	requires_power = FALSE
	power_equip = TRUE

/area/taeloth/outdoors/powered // Literally just because I'm too lazy to mark every powered item outside as unrequiring power.
	always_unpowered = FALSE
	requires_power = FALSE
	power_equip = TRUE

/area/taeloth/outdoors/unexplored // In theory, monsters spawn here. They do not in practice, unimplemented. Random Generation + Ruins work though.
	icon_state = "unexplored"
	area_flags = VALID_TERRITORY
	area_flags_mapping = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	use_mapgen = TRUE

/area/taeloth/outdoors/unexplored/danger // Additional to said theory: megafauna.
	icon_state = "danger"
	area_flags = VALID_TERRITORY
	area_flags_mapping = parent_type::area_flags_mapping | MEGAFAUNA_SPAWN_ALLOWED

/area/taeloth/underground
	name = "Taeloth Caves"
	sound_environment = SOUND_ENVIRONMENT_CAVE
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambience_index = AMBIENCE_MINING
	area_flags = VALID_TERRITORY
	outdoors = FALSE

/area/taeloth/underground/unexplored
	icon_state = "unexplored"
	area_flags = VALID_TERRITORY
	area_flags_mapping = CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	map_generator = /datum/map_generator/cave_generator/rimpoint_jungle
	use_mapgen = TRUE
