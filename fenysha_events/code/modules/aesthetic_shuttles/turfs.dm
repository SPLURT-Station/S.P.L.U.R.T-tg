/*
/area/shuttle
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
*/

/obj/docking_port/mobile/arrivals

/turf/closed/wall/mineral/titanium/shuttle_wall
	name = "стена шаттла" // shuttle wall
	desc = "Легкая титановая стена, используемая в шаттлах." // A light-weight titanium wall used in shuttles.
	icon = 'fenysha_events/icons/unique/shuttles/pod.dmi'
	icon_state = ""
	base_icon_state = ""
	smoothing_flags = null
	smoothing_groups = null
	canSmoothWith = null

/turf/closed/wall/mineral/titanium/shuttle_wall/AfterChange(flags, oldType)
	. = ..()
	var/turf/underturf_path

	if(!ispath(oldType, /turf/closed/wall/mineral/titanium/shuttle_wall))
		underturf_path = oldType
	else
		underturf_path = SSmapping.level_trait(z, ZTRAIT_BASETURF) || /turf/open/space

	var/mutable_appearance/underlay_appearance = mutable_appearance(
		initial(underturf_path.icon),
		initial(underturf_path.icon_state),
		offset_spokesman = src,
		layer = LOW_FLOOR_LAYER - 0.02,
		plane = FLOOR_PLANE)
	underlay_appearance.appearance_flags = RESET_ALPHA | RESET_COLOR
	underlays += underlay_appearance

/turf/closed/wall/mineral/titanium/shuttle_wall/window
	opacity = FALSE

/*
*	КАПСУЛА (POD)
*/

/turf/closed/wall/mineral/titanium/shuttle_wall/pod
	icon = 'fenysha_events/icons/unique/shuttles/pod.dmi'

/turf/closed/wall/mineral/titanium/shuttle_wall/window/pod
	icon = 'fenysha_events/icons/unique/shuttles/pod.dmi'
	icon_state = "3,1"

/*
*	ПАРОХОД (FERRY)
*/

/turf/closed/wall/mineral/titanium/shuttle_wall/ferry
	icon = 'fenysha_events/icons/unique/shuttles/erokez.dmi'
	icon_state = "18,2"

/turf/closed/wall/mineral/titanium/shuttle_wall/window/ferry
	icon = 'fenysha_events/icons/unique/shuttles/erokez.dmi'
	icon_state = "18,2"

/turf/open/floor/iron/shuttle/ferry
	name = "пол шаттла" // shuttle floor
	icon = 'fenysha_events/icons/unique/shuttles/erokez.dmi'
	icon_state = "floor1"

/turf/open/floor/iron/shuttle/ferry/airless
	initial_gas_mix = AIRLESS_ATMOS

/*
*	ЭВАКУАЦИЯ (EVAC)
*/

/turf/closed/wall/mineral/titanium/shuttle_wall/evac
	icon = 'fenysha_events/icons/unique/shuttles/evac_shuttle.dmi'
	icon_state = "9,1"

/turf/closed/wall/mineral/titanium/shuttle_wall/window/evac
	icon = 'fenysha_events/icons/unique/shuttles/evac_shuttle.dmi'
	icon_state = "9,1"

/turf/open/floor/iron/shuttle/evac
	name = "пол шаттла" // shuttle floor
	floor_tile = /obj/item/stack/tile/mineral/titanium/shuttle_evac
	icon = 'fenysha_events/icons/unique/shuttles/evac_shuttle.dmi'
	icon_state = "floor"

/turf/open/floor/iron/shuttle/evac/airless
	initial_gas_mix = AIRLESS_ATMOS

/*
*	ПРИБЫТИЕ (ARRIVALS)
*/

/turf/closed/wall/mineral/titanium/shuttle_wall/arrivals
	icon = 'fenysha_events/icons/unique/shuttles/wagon.dmi'
	icon_state = "3,1"

/turf/closed/wall/mineral/titanium/shuttle_wall/window/arrivals
	icon = 'fenysha_events/icons/unique/shuttles/wagon.dmi'
	icon_state = "3,1"

/turf/open/floor/iron/shuttle/arrivals
	name = "пол шаттла" // shuttle floor
	floor_tile = /obj/item/stack/tile/mineral/titanium/shuttle_arrivals
	icon = 'fenysha_events/icons/unique/shuttles/wagon.dmi'
	icon_state = "floor"

/turf/open/floor/iron/shuttle/arrivals/airless
	initial_gas_mix = AIRLESS_ATMOS

/*
*	ГРУЗОВОЙ (CARGO)
*/

/turf/closed/wall/mineral/titanium/shuttle_wall/cargo
	icon = 'fenysha_events/icons/unique/shuttles/cargo.dmi'
	icon_state = "3,1"

/turf/closed/wall/mineral/titanium/shuttle_wall/window/cargo
	icon = 'fenysha_events/icons/unique/shuttles/cargo.dmi'
	icon_state = "3,1"

/turf/open/floor/iron/shuttle/cargo
	name = "пол шаттла" // shuttle floor
	floor_tile = /obj/item/stack/tile/mineral/titanium/cargo
	icon = 'fenysha_events/icons/unique/shuttles/cargo.dmi'
	icon_state = "floor"
	base_icon_state = "floor"

/turf/open/floor/iron/shuttle/cargo/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/iron/shuttle/cargo/cargo_mainta
	floor_tile = /obj/item/stack/tile/mineral/titanium/cargo/mainta
	icon_state = "floor_mainta"
	base_icon_state = "floor_mainta"

/turf/open/floor/iron/shuttle/cargo/cargo_maintb
	floor_tile = /obj/item/stack/tile/mineral/titanium/cargo/maintb
	icon_state = "floor_maintb"
	base_icon_state = "floor_maintb"

/turf/open/floor/iron/shuttle/cargo/cargo_maintc
	floor_tile = /obj/item/stack/tile/mineral/titanium/cargo/maintc
	icon_state = "floor_maintc"
	base_icon_state = "floor_maintc"

/*
*	ШАХТА (MINING)
*/

/turf/closed/wall/mineral/titanium/shuttle_wall/mining
	icon = 'fenysha_events/icons/unique/shuttles/mining.dmi'

/turf/closed/wall/mineral/titanium/shuttle_wall/window/mining
	icon = 'fenysha_events/icons/unique/shuttles/mining.dmi'

/turf/closed/wall/mineral/titanium/shuttle_wall/mining_large
	icon = 'fenysha_events/icons/unique/shuttles/mining_large.dmi'
	icon_state = "2,2"
	dir = NORTH

/turf/closed/wall/mineral/titanium/shuttle_wall/window/mining_large
	icon = 'fenysha_events/icons/unique/shuttles/mining_large.dmi'
	icon_state = "6,3"
	dir = NORTH

/turf/closed/wall/mineral/titanium/shuttle_wall/mining_labor
	icon = 'fenysha_events/icons/unique/shuttles/mining_labor.dmi'
	icon_state = "4,6"
	dir = NORTH

/turf/closed/wall/mineral/titanium/shuttle_wall/window/mining_labor
	icon = 'fenysha_events/icons/unique/shuttles/mining_labor.dmi'
	icon_state = "4,4"
	dir = NORTH

/*
*	ШАХТА/НИО/РАЗВЕДКА - ПОЛЫ (MINING/RND/EXPLORATION FLOORS)
*/

/turf/open/floor/iron/shuttle/exploration
	name = "пол шаттла" // shuttle floor
	floor_tile = /obj/item/stack/tile/mineral/titanium/exploration
	icon = 'fenysha_events/icons/unique/shuttles/exploration_floor.dmi'
	icon_state = "oside"
	base_icon_state = "oside"

/turf/open/floor/iron/shuttle/exploration/uside
	icon_state = "uside"

/turf/open/floor/iron/shuttle/exploration/corner
	icon_state = "corner"

/turf/open/floor/iron/shuttle/exploration/side
	icon_state = "side"

/turf/open/floor/iron/shuttle/exploration/corner_invcorner
	icon_state = "corner_icorner"

/turf/open/floor/iron/shuttle/exploration/adjinvcorner
	icon_state = "adj_icorner"

/turf/open/floor/iron/shuttle/exploration/oppinvcorner
	icon_state = "opp_icorner"

/turf/open/floor/iron/shuttle/exploration/invertcorner
	icon_state = "icorner"

/turf/open/floor/iron/shuttle/exploration/doubleinvertcorner
	icon_state = "double_icorner"

/turf/open/floor/iron/shuttle/exploration/tripleinvertcorner
	icon_state = "tri_icorner"

/turf/open/floor/iron/shuttle/exploration/doubleside
	icon_state = "double_side"

/turf/open/floor/iron/shuttle/exploration/quadinvertcorner
	icon_state = "4icorner"

/turf/open/floor/iron/shuttle/exploration/doubleinvertcorner_side
	icon_state = "double_icorner_side"

/turf/open/floor/iron/shuttle/exploration/invertcorner_side
	icon_state = "side_icorner"

/turf/open/floor/iron/shuttle/exploration/invertcorner_side_flipped
	icon_state = "side_icorner_f"

/turf/open/floor/iron/shuttle/exploration/blanktile
	icon_state = "blank"

/turf/open/floor/iron/shuttle/exploration/flat
	floor_tile = /obj/item/stack/tile/mineral/titanium/exploration/flat
	icon_state = "flat"
	base_icon_state = "flat"

/turf/open/floor/iron/shuttle/exploration/flat/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/iron/shuttle/exploration/textured_flat
	floor_tile = /obj/item/stack/tile/mineral/titanium/exploration/flat_textured
	icon_state = "flattexture"
	base_icon_state = "flattexture"

/turf/open/floor/iron/shuttle/exploration/textured_flat/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/iron/shuttle/exploration/equipmentrail1
	icon_state = "rail1"

/turf/open/floor/iron/shuttle/exploration/equipmentrail2
	icon_state = "rail2"

/turf/open/floor/iron/shuttle/exploration/equipmentrail3
	icon_state = "rail3"

/turf/open/floor/iron/shuttle/exploration/hazard
	floor_tile = /obj/item/stack/tile/mineral/titanium/exploration/hazard
	icon_state = "hazard"
	base_icon_state = "hazard"

/turf/open/floor/iron/shuttle/exploration/hazard/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/iron/shuttle/exploration/smooth
	name = "пол шаттла" // shuttle floor
	icon = 'fenysha_events/icons/turf/floors/exploration_floor.dmi'
	icon_state = "exploration-0"
	base_icon_state = "exploration"
	floor_tile = /obj/item/stack/tile/mineral/titanium/exploration
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_EXPLORATION_FLOOR
	canSmoothWith = SMOOTH_GROUP_EXPLORATION_FLOOR

/*
*	СТОПКИ ПЛИТОК (TILE STACKS)
*/

/obj/item/stack/tile/mineral/titanium/cargo
	name = "плитка грузового шаттла" // cargo shuttle tile
	singular_name = "плитка пола грузового шаттла" // cargo shuttle floor tile
	desc = "Утилитарные титановые плитки для пола, используемые в грузовых шаттлах." // Utilitarian titanium floor tiles, used for cargo shuttles.
	icon = 'fenysha_events/icons/items/tiles_misc.dmi'
	icon_state = "cargo"
	inhand_icon_state = "tile-shuttle"
	turf_type = /turf/open/floor/iron/shuttle/cargo
	mineralType = "titanium"
	merge_type = /obj/item/stack/tile/mineral/titanium/cargo

/obj/item/stack/tile/mineral/titanium/cargo/mainta
	name = "плитка грузового шаттла A" // cargo shuttle charger A tile
	singular_name = "плитка пола грузового шаттла A" // cargo shuttle charger A floor tile
	icon_state = "cargo_mainta"
	turf_type = /turf/open/floor/iron/shuttle/cargo/cargo_mainta
	merge_type = /obj/item/stack/tile/mineral/titanium/cargo/mainta
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/mineral/titanium/cargo/maintb
	name = "плитка грузового шаттла B" // cargo shuttle charger B tile
	singular_name = "плитка пола грузового шаттла B" // cargo shuttle charger B floor tile
	icon_state = "cargo_maintb"
	turf_type = /turf/open/floor/iron/shuttle/cargo/cargo_maintb
	merge_type = /obj/item/stack/tile/mineral/titanium/cargo/maintb
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST)

/obj/item/stack/tile/mineral/titanium/cargo/maintc
	name = "крайняя плитка грузового шаттла" // cargo shuttle edge tile
	singular_name = "крайняя плитка пола грузового шаттла" // cargo shuttle edge floor tile
	icon_state = "cargo_maintc"
	turf_type = /turf/open/floor/iron/shuttle/cargo/cargo_maintc
	merge_type = /obj/item/stack/tile/mineral/titanium/cargo/maintc
	tile_rotate_dirs = list(SOUTH, NORTH, EAST, WEST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)

/obj/item/stack/tile/mineral/titanium/exploration
	name = "плитка шахтёрского шаттла" // mining shuttle tile
	singular_name = "плитка пола шахтёрского шаттла" // mining shuttle floor tile
	desc = "Прочные титановые плитки для пола, используемые в шахтёрских шаттлах." // rugged titanium floor tiles, used for mining shuttles.
	icon = 'fenysha_events/icons/items/tiles_misc.dmi'
	icon_state = "exploration"
	inhand_icon_state = "tile-shuttle"
	turf_type = /turf/open/floor/iron/shuttle/exploration/smooth
	mineralType = "titanium"
	merge_type = /obj/item/stack/tile/mineral/titanium/exploration

/obj/item/stack/tile/mineral/titanium/exploration/flat
	name = "плоская плитка шахтёрского шаттла" // flat mining shuttle tile
	singular_name = "плоская плитка пола шахтёрского шаттла" // flat mining shuttle floor tile
	icon_state = "exploration_flat"
	turf_type = /turf/open/floor/iron/shuttle/exploration/flat
	merge_type = /obj/item/stack/tile/mineral/titanium/exploration/flat

/obj/item/stack/tile/mineral/titanium/exploration/flat_textured
	name = "текстурная плитка шахтёрского шаттла" // textured mining shuttle tile
	singular_name = "текстурная плитка пола шахтёрского шаттла" // textured mining shuttle floor tile
	icon_state = "exploration_flat_textured"
	turf_type = /turf/open/floor/iron/shuttle/exploration/textured_flat
	merge_type = /obj/item/stack/tile/mineral/titanium/exploration/flat_textured

/obj/item/stack/tile/mineral/titanium/exploration/hazard
	name = "опасная плитка шахтёрского шаттла" // hazard mining shuttle tile
	singular_name = "опасная плитка пола шахтёрского шаттла" // hazard mining shuttle floor tile
	icon_state = "exploration_flat_hazard"
	turf_type = /turf/open/floor/iron/shuttle/exploration/hazard
	merge_type = /obj/item/stack/tile/mineral/titanium/exploration/hazard

/obj/item/stack/tile/mineral/titanium/shuttle_arrivals
	name = "полосатая плитка шаттла" // striped shuttle tile
	singular_name = "полосатая плитка пола шаттла" // striped shuttle floor tile
	desc = "Полосатые титановые плитки для пола, используемые в шаттлах." // striped titanium floor tiles, used for shuttles.
	icon = 'fenysha_events/icons/items/tiles_misc.dmi'
	icon_state = "shuttle_arrivals"
	inhand_icon_state = "tile-shuttle"
	turf_type = /turf/open/floor/iron/shuttle/arrivals
	mineralType = "titanium"
	merge_type = /obj/item/stack/tile/mineral/titanium/shuttle_arrivals

/obj/item/stack/tile/mineral/titanium/shuttle_evac
	name = "плитка шаттла" // shuttle tile
	singular_name = "плитка пола шаттла" // shuttle floor tile
	desc = "Полосатые титановые плитки для пола, используемые в шаттлах." // striped titanium floor tiles, used for shuttles.
	icon = 'fenysha_events/icons/items/tiles_misc.dmi'
	icon_state = "shuttle_evac"
	inhand_icon_state = "tile-shuttle"
	turf_type = /turf/open/floor/iron/shuttle/evac
	mineralType = "titanium"
	merge_type = /obj/item/stack/tile/mineral/titanium/shuttle_evac
