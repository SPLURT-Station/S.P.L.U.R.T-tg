#define RAIL_GROUP "rail_group"

/datum/moving_turf_transition
	var/transition_speed = 5

	/// list(
	///     GROUP_ID = list(
	///         TURF_ICON = 'icon.dmi',
	///         TURF_ICON_STATE = "snow",
	///         SET_TURF_DENSITY = FALSE,
	///         SET_TURF_OPACITY = FALSE
	///     )
	/// )
	/// Alternatively can be used as
	/// list(
	///		TRANSITION_TOP_SIDE = list_of_groups_options,
	///		TRANSITION_BOTTOM_SIDE = list_of_groups_options,
	/// )
	var/list/transition_options = list()

	var/list/rail_theme = RAIL_THEME_DEFAULT

	/// GROUP_ID = current_x
	var/list/current_columns = list()

	/// GROUP_ID = list(turfs)
	var/list/grouped_turfs = list()

	var/change_spawn_theme = null

	/// Wich side of train would be affected by that group
	var/affected_sides = TRANSITION_BOTH

	var/transition = FALSE

/datum/moving_turf_transition/proc/prepare_groups()
	grouped_turfs = get_transition_turfs()

/datum/moving_turf_transition/proc/get_transition_turfs()
	var/list/result = list()

	for(var/turf/open/moving/T as anything in SSmoving_turfs.all_simulated_turfs)
		if(istype(T, /turf/open/moving/auto_icon))
			var/turf/open/moving/auto_icon/MT = T
			if(!MT.transition_group)
				continue

			if(!result[MT.transition_group])
				result[MT.transition_group] = list()

			result[MT.transition_group] += MT
		else if(istype(T, /turf/open/moving/auto_rail))
			var/turf/open/moving/auto_rail/RT = T
			if(!RT.rail_role)
				continue
			if(!result[RAIL_GROUP])
				result[RAIL_GROUP] = list()
			result[RAIL_GROUP] += RT
	return result

/datum/moving_turf_transition/proc/start_transition()
	prepare_groups()

	for(var/group_id in grouped_turfs)
		var/max_x = 0

		for(var/turf/open/moving/auto_icon/T as anything in grouped_turfs[group_id])
			max_x = max(max_x, T.x)

		current_columns[group_id] = max_x

	addtimer(CALLBACK(src, PROC_REF(run_trough_trufs)), 1)

/datum/moving_turf_transition/proc/transit_out()
	return

/datum/moving_turf_transition/proc/transition_ends()
	if(change_spawn_theme && ispath(change_spawn_theme, /datum/train_object_spawner_theme))
		SStrain_controller.set_movement_theme(change_spawn_theme)

/datum/moving_turf_transition/proc/is_turf_top(turf/turf_to_check)
	var/static/obj/effect/landmark/trainstation/train_spawnpoint/SP
	if(!SP)
		SP = locate() in GLOB.landmarks_list
	return turf_to_check.y > SP.y

/datum/moving_turf_transition/proc/run_trough_trufs()
	transition = TRUE
	while(TRUE)
		if(!SStrain_controller.is_moving())
			stoplag()
			continue

		var/finished = TRUE

		for(var/group_id in grouped_turfs)
			if(process_group(group_id))
				finished = FALSE

		if(finished)
			break

		sleep(1 SECONDS / transition_speed)
	transition = FALSE
	transition_ends()


/datum/moving_turf_transition/proc/process_instant()
	prepare_groups()
	transition = TRUE
	for(var/group_id in grouped_turfs)
		if(group_id == RAIL_GROUP)
			var/list/options = rail_theme
			for(var/role in options)
				for(var/turf/open/moving/auto_rail/RT as anything in grouped_turfs[group_id])
					if(!istype(RT, /turf/open/moving/auto_rail))
						continue
					if((RT.rail_role && RT.rail_role != role))
						continue
					var/list/reail_options = options[role]
					apply_to_rail(RT, reail_options)
		else
			var/list/general_options = transition_options[group_id]
			var/list/top_options
			var/list/bottom_options

			if(transition_options[TRANSITION_TOP_SIDE] || transition_options[TRANSITION_BOTTOM_SIDE])
				top_options = transition_options[TRANSITION_TOP_SIDE]
				bottom_options = transition_options[TRANSITION_BOTTOM_SIDE]

			for(var/turf/open/moving/auto_icon/T as anything in grouped_turfs[group_id])
				var/list/options = general_options

				if(is_turf_top(T) && top_options)
					options = top_options[group_id]
				else if(!is_turf_top(T) && bottom_options)
					options = bottom_options[group_id]

				apply_to_turf(T, options)

	transition_ends()
	transition = FALSE

/datum/moving_turf_transition/proc/process_group(group_id)
	var/current_x = current_columns[group_id]

	if(current_x <= 0)
		return FALSE

	if(group_id == RAIL_GROUP)
		var/list/options = rail_theme
		for(var/role in options)
			for(var/turf/open/moving/auto_rail/RT as anything in grouped_turfs[group_id])
				if((RT.rail_role != role) || RT.x != current_x)
					continue
				var/list/reail_options = options[role]
				apply_to_rail(RT, reail_options)
	else
		var/list/general_options = transition_options[group_id]
		var/list/top_options
		var/list/bottom_options

		if(transition_options[TRANSITION_TOP_SIDE] || transition_options[TRANSITION_BOTTOM_SIDE])
			top_options = transition_options[TRANSITION_TOP_SIDE]
			bottom_options = transition_options[TRANSITION_BOTTOM_SIDE]

		for(var/turf/open/moving/auto_icon/T as anything in grouped_turfs[group_id])
			if(T.x != current_x)
				continue

			var/list/options = general_options
			if(is_turf_top(T) && top_options)
				options = top_options[group_id]
			else if(!is_turf_top(T) && bottom_options)
				options = bottom_options[group_id]

			apply_to_turf(T, options)

	current_columns[group_id] = current_x - 1
	return TRUE

/datum/moving_turf_transition/proc/apply_to_rail(turf/open/moving/auto_rail/T, list/options)
	T.color = null
	T.change_me(
		options[MOVING_TURF_ICON],
		options[MOVING_TURF_ICON_STATE]
	)

	if(options[MOVING_TURF_NAME])
		T.name = options[MOVING_TURF_NAME]
		T.desc = options[MOVING_TURF_DESC]

	if(options[SET_TURF_DENSITY] != null)
		T.density = options[SET_TURF_DENSITY]

	if(options[SET_TURF_OPACITY] != null)
		T.opacity = options[SET_TURF_OPACITY]


/datum/moving_turf_transition/proc/apply_to_turf(turf/open/moving/auto_icon/T, list/options)
	T.color = null
	T.change_me(
		options[MOVING_TURF_ICON],
		options[MOVING_TURF_ICON_STATE]
	)

	if(options[MOVING_TURF_NAME])
		T.name = options[MOVING_TURF_NAME]
		T.desc = options[MOVING_TURF_DESC]

	if(options[SET_TURF_DENSITY] != null)
		T.density = options[SET_TURF_DENSITY]

	if(options[SET_TURF_OPACITY] != null)
		T.opacity = options[SET_TURF_OPACITY]


/turf/open/moving/auto_icon
	// The turf transtition group this moving turfs belongs to
	var/transition_group = NONE


/turf/open/moving/auto_icon/Initialize(mapload)
	. = ..()
	if(SStrain_controller.loading)
		return

	var/datum/moving_turf_transition/transition = SStrain_controller.transition_theme
	if(!transition || !transition_group)
		reset_to_default()
		return

	var/list/options = transition.transition_options[transition_group]

	if(transition.affected_sides != TRANSITION_BOTH)
		if(transition.is_turf_top(src))
			options = transition.transition_options[TRANSITION_TOP_SIDE] || options
		else
			options = transition.transition_options[TRANSITION_BOTTOM_SIDE] || options

	if(options)
		transition.apply_to_turf(src, options)

/turf/open/moving/auto_icon/proc/reset_to_default()
	src.icon = initial(src.icon)
	base_icon_state = "snow"

	update_icon()
	update_appearance()


/turf/open/moving/auto_icon/proc/change_me(icon, icon_state)
	src.icon = icon
	src.base_icon_state = icon_state

	update_icon()
	update_appearance()


/turf/open/moving/auto_icon/groups
	icon = 'icons/hud/screen_gen.dmi'
	icon_state = "flash"

/turf/open/moving/auto_icon/groups/group_1
	transition_group = TRANSITION_GROUP_1
	color = "#FF0000"

/turf/open/moving/auto_icon/groups/group_2
	transition_group = TRANSITION_GROUP_2
	color = "#FF7F00"

/turf/open/moving/auto_icon/groups/group_3
	transition_group = TRANSITION_GROUP_3
	color = "#FFFF00"

/turf/open/moving/auto_icon/groups/group_4
	transition_group = TRANSITION_GROUP_4
	color = "#7FFF00"

/turf/open/moving/auto_icon/groups/group_5
	transition_group = TRANSITION_GROUP_5
	color = "#00FF00"

/turf/open/moving/auto_icon/groups/group_6
	transition_group = TRANSITION_GROUP_6
	color = "#00FF7F"

/turf/open/moving/auto_icon/groups/group_7
	transition_group = TRANSITION_GROUP_7
	color = "#00FFFF"

/turf/open/moving/auto_icon/groups/group_8
	transition_group = TRANSITION_GROUP_8
	color = "#007FFF"

/turf/open/moving/auto_icon/groups/group_9
	transition_group = TRANSITION_GROUP_9
	color = "#0000FF"

/turf/open/moving/auto_icon/groups/group_10
	transition_group = TRANSITION_GROUP_10
	color = "#7F00FF"

/turf/open/moving/auto_icon/groups/group_11
	transition_group = TRANSITION_GROUP_11
	color = "#FF00FF"

/turf/open/moving/auto_icon/groups/group_12
	transition_group = TRANSITION_GROUP_12
	color = "#FF007F"

/turf/open/moving/auto_icon/groups/group_13
	transition_group = TRANSITION_GROUP_13
	color = "#A52A2A"

/turf/open/moving/auto_icon/groups/group_14
	transition_group = TRANSITION_GROUP_14
	color = "#808080"

/turf/open/moving/auto_icon/groups/group_15
	transition_group = TRANSITION_GROUP_15
	color = "#FFFFFF"

/turf/open/moving/auto_icon/groups/group_16
	transition_group = TRANSITION_GROUP_16
	color = "#000000"

/turf/open/moving/auto_icon/groups/group_17
	transition_group = TRANSITION_GROUP_17
	color = "#FFD700"

/turf/open/moving/auto_icon/groups/group_18
	transition_group = TRANSITION_GROUP_18
	color = "#FF69B4"

/turf/open/moving/auto_icon/groups/group_19
	transition_group = TRANSITION_GROUP_19
	color = "#40E0D0"


/datum/moving_turf_transition/undeground
	transition_options = list(
		TRANSITION_TOP_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_SIDINGBOTTOM,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_ROCKW_BORDER
		),
		TRANSITION_BOTTOM_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_SIDINGTOP_BORDER,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_ROCKW_BORDER
		)
	)

/datum/moving_turf_transition/plain_snow

	change_spawn_theme = /datum/train_object_spawner_theme/forest
	rail_theme = RAIL_THEME_SNOWED
	transition_options = list(
		TRANSITION_GROUP_1  = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_2  = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_3  = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_4  = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_5  = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_6  = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_7  = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_8  = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_9  = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_10 = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_11 = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_12 = TRANSITION_OPTION_SNOW_DENSE,
		TRANSITION_GROUP_13 = TRANSITION_OPTION_SNOW_DENSE,
		TRANSITION_GROUP_14 = TRANSITION_OPTION_SNOW_DENSE,
		TRANSITION_GROUP_15 = TRANSITION_OPTION_SNOW_DENSE,
		TRANSITION_GROUP_16 = TRANSITION_OPTION_SNOW_DENSE,
		TRANSITION_GROUP_17 = TRANSITION_OPTION_SNOW_DENSE,
		TRANSITION_GROUP_18 = TRANSITION_OPTION_SNOW_BORDER
	)


/datum/moving_turf_transition/bridge

	change_spawn_theme = /datum/train_object_spawner_theme/bridge
	rail_theme = RAIL_THEME_BRIDGE

	transition_options = list(
		TRANSITION_TOP_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_BRIDGE,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_BRIDGE,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_BRIDGE,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_BRIDGE_FENCE,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_WATER_BORDER
		),
		TRANSITION_BOTTOM_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_BRIDGE,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_BRIDGE,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_BRIDGE,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_BRIDGE_FENCE,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_SIDINGBOTTOM,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_WATER_BORDER
		)
	)

/datum/moving_turf_transition/tunnel

	/// How many time we gonna spend inside tunnel
	var/duration = 2 MINUTES
	/// Where we gonna find outself after leaving tunnel
	var/destination_theme

	change_spawn_theme = /datum/train_object_spawner_theme/tunnel
	transition_options = list(
		TRANSITION_TOP_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_SIDINGBOTTOM,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_ROCKW_BORDER
		),
		TRANSITION_BOTTOM_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_SIDINGTOP_BORDER,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_ROCKW_BORDER
		)
	)

/datum/moving_turf_transition/tunnel/transition_ends()
	. = ..()
	SSdaylight.cycle_locked = TRUE
	SSdaylight.set_intensity_and_color(0, COLOR_BLACK, TRUE)

	if(destination_theme && istype(destination_theme, /datum/moving_turf_transition))
		if(SStrain_controller.time_to_next_station >= duration)
			SStrain_controller.time_to_next_station += duration + 1 MINUTES
			SStrain_controller.planned_transition = destination_theme
			SStrain_controller.enforce_transition = TRUE

/datum/moving_turf_transition/tunnel/transit_out()
	SSdaylight.cycle_locked = FALSE

	var/list/phase_state = SSdaylight.get_phase_light_state()
	SSdaylight.set_target(phase_state["intensity"], phase_state["color"])
	SSdaylight.transition_steps = 2
	for(var/i = 0 to 2)
		SSdaylight.fire()
		sleep(0.1 SECONDS)

/datum/moving_turf_transition/tunnel/to_near_river_top
	destination_theme = /datum/moving_turf_transition/near_river_top

/datum/moving_turf_transition/tunnel/to_near_river_bottom
	destination_theme = /datum/moving_turf_transition/near_river_bottom

/datum/moving_turf_transition/tunnel/to_bridge
	destination_theme = /datum/moving_turf_transition/bridge

/datum/moving_turf_transition/tunnel/to_forest
	destination_theme = /datum/moving_turf_transition/plain_snow

/datum/moving_turf_transition/tunnel/to_near_road_bottom
	destination_theme = /datum/moving_turf_transition/near_road_bottom

/datum/moving_turf_transition/tunnel/to_void
	duration = 5 MINUTES
	destination_theme = /datum/moving_turf_transition/void


/datum/moving_turf_transition/near_river_top

	change_spawn_theme = /datum/train_object_spawner_theme/near_river_top
	rail_theme = RAIL_THEME_SNOWED

	transition_options = list(
		TRANSITION_TOP_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_BRIDGE_FENCE,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_WATER_BORDER
		),
		TRANSITION_BOTTOM_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_SNOW_BORDER
		)
	)


/datum/moving_turf_transition/near_river_bottom

	change_spawn_theme = /datum/train_object_spawner_theme/near_river_bottom
	rail_theme = RAIL_THEME_SNOWED

	transition_options = list(
		TRANSITION_TOP_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_SNOW_BORDER
		),
		TRANSITION_BOTTOM_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_BRIDGE_FENCE,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_SIDINGBOTTOM,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_WATER,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_WATER_DENSE,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_WATER_BORDER
		)
	)

/datum/moving_turf_transition/near_road_bottom

	rail_theme = RAIL_THEME_SNOWED
	change_spawn_theme = /datum/train_object_spawner_theme/near_road_bottom

	transition_options = list(
		TRANSITION_TOP_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_SNOW_BORDER
		),
		TRANSITION_BOTTOM_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_ASPHALT_TOP,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_ASPHALT,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_ASPHALT,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_ASPHALT,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_ASPHALT_BOTTOM,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_SNOW,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_SNOW_DENSE,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_SNOW_BORDER
		)
	)


/datum/moving_turf_transition/undeground
	transition_options = list(
		TRANSITION_TOP_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_SIDINGBOTTOM,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_ROCKW_BORDER
		),
		TRANSITION_BOTTOM_SIDE = list(
			TRANSITION_GROUP_1  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_2  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_3  = TRANSITION_OPTION_TUNNEL_FLOOR,
			TRANSITION_GROUP_4  = TRANSITION_OPTION_SIDINGTOP_BORDER,
			TRANSITION_GROUP_5  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_6  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_7  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_8  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_9  = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_10 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_11 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_12 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_13 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_14 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_15 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_16 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_17 = TRANSITION_OPTION_ROCKW_BORDER,
			TRANSITION_GROUP_18 = TRANSITION_OPTION_ROCKW_BORDER
		)
	)


/datum/moving_turf_transition/void
	change_spawn_theme = /datum/train_object_spawner_theme/khara_capsules
	rail_theme = RAIL_THEME_VOID
	transition_options = list(
		TRANSITION_GROUP_1  = TRANSITION_OPTION_VOID_DENSE,
		TRANSITION_GROUP_2  = TRANSITION_OPTION_VOID,
		TRANSITION_GROUP_3  = TRANSITION_OPTION_VOID,
		TRANSITION_GROUP_4  = TRANSITION_OPTION_VOID,
		TRANSITION_GROUP_5  = TRANSITION_OPTION_VOID,
		TRANSITION_GROUP_6  = TRANSITION_OPTION_VOID,
		TRANSITION_GROUP_7  = TRANSITION_OPTION_VOID,
		TRANSITION_GROUP_8  = TRANSITION_OPTION_VOID,
		TRANSITION_GROUP_9  = TRANSITION_OPTION_VOID,
		TRANSITION_GROUP_10 = TRANSITION_OPTION_VOID,
		TRANSITION_GROUP_11 = TRANSITION_OPTION_VOID,
		TRANSITION_GROUP_12 = TRANSITION_OPTION_VOID_DENSE,
		TRANSITION_GROUP_13 = TRANSITION_OPTION_VOID_DENSE,
		TRANSITION_GROUP_14 = TRANSITION_OPTION_VOID_DENSE,
		TRANSITION_GROUP_15 = TRANSITION_OPTION_VOID_DENSE,
		TRANSITION_GROUP_16 = TRANSITION_OPTION_VOID_DENSE,
		TRANSITION_GROUP_17 = TRANSITION_OPTION_VOID_DENSE,
		TRANSITION_GROUP_18 = TRANSITION_OPTION_VOID_BORDER
	)
