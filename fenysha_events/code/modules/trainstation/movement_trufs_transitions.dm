/datum/moving_turf_transition
	var/transition_speed = 3

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

	for(var/turf/open/moving/auto_icon/T in SSmoving_turfs.all_simulated_turfs)
		if(!T.transition_group)
			continue

		if(!result[T.transition_group])
			result[T.transition_group] = list()

		result[T.transition_group] += T

	return result

/datum/moving_turf_transition/proc/start_transition()
	if(!grouped_turfs || !length(grouped_turfs))
		prepare_groups()

	for(var/group_id in grouped_turfs)
		var/max_x = 0

		for(var/turf/open/moving/auto_icon/T as anything in grouped_turfs[group_id])
			max_x = max(max_x, T.x)

		current_columns[group_id] = max_x

	addtimer(CALLBACK(src, PROC_REF(run_trough_trufs)), 1)

/datum/moving_turf_transition/proc/transition_ends()
	if(change_spawn_theme && ispath(change_spawn_theme, /datum/train_object_spawner_theme))
		SStrain_controller.set_movement_theme(change_spawn_theme)

/datum/moving_turf_transition/proc/is_turf_top(turf/turf_to_check)
	var/static/obj/effect/landmark/trainstation/train_spawnpoint/SP
	if(!SP)
		SP = locate() in GLOB.landmarks_list
	return turf_to_check.x > SP.x

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
	if(!grouped_turfs)
		prepare_groups()
	transition = TRUE
	for(var/group_id in grouped_turfs)
		var/list/general_options = transition_options[group_id]
		var/list/top_options
		var/list/bottom_options

		if(transition_options[TRANSITION_TOP_SIDE] || transition_options[TRANSITION_BOTTOM_SIDE])
			top_options = transition_options[TRANSITION_TOP_SIDE]
			bottom_options = transition_options[TRANSITION_BOTTOM_SIDE]

		for(var/turf/open/moving/auto_icon/T as anything in grouped_turfs[group_id])
			var/list/options = general_options

			switch(affected_sides)
				if(TRANSITION_TOP_SIDE)
					if(is_turf_top(T) && top_options)
						options = top_options

				if(TRANSITION_BOTTOM_SIDE)
					if(!is_turf_top(T) && bottom_options)
						options = bottom_options

			apply_to_turf(T, options)

	transition_ends()
	transition = FALSE

/datum/moving_turf_transition/proc/process_group(group_id)
	var/current_x = current_columns[group_id]

	if(current_x <= 0)
		return FALSE

	var/list/general_options = transition_options[group_id]
	var/list/top_options
	var/list/bottom_options

	if(transition_options[TRANSITION_TOP_SIDE] || transition_options[TRANSITION_BOTTOM_SIDE])
		top_options = transition_options[TRANSITION_TOP_SIDE]
		bottom_options = transition_options[TRANSITION_BOTTOM_SIDE]

	for(var/turf/open/moving/auto_icon/T as anything in grouped_turfs[group_id])
		if(T.x != current_x)
			continue
		T.color = null
		var/list/options = general_options

		switch(affected_sides)
			if(TRANSITION_TOP_SIDE)
				if(is_turf_top(T) && top_options)
					options = top_options

			if(TRANSITION_BOTTOM_SIDE)
				if(!is_turf_top(T) && bottom_options)
					options = bottom_options

		apply_to_turf(T, options)

	current_columns[group_id] = current_x - 1

	return TRUE


/datum/moving_turf_transition/proc/apply_to_turf(turf/open/moving/auto_icon/T, list/options)
	T.change_me(
		options[MOVING_TURF_ICON],
		options[MOVING_TURF_ICON_STATE]
	)

	if(options[MOVING_TURF_NAME])
		T.name = options[MOVING_TURF_NAME]
		T.desc = options[MOVING_TURF_DESC]

	if(options[SET_TURF_DENSITY])
		T.density = options[SET_TURF_DENSITY]

	if(options[SET_TURF_OPACITY])
		T.opacity = options[SET_TURF_OPACITY]


/turf/open/moving/auto_icon
	// The turf transtition group this moving turfs belongs to
	var/transition_group = NONE


/turf/open/moving/auto_icon/Initialize(mapload)
	. = ..()

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
	update_icon_state()
	update_appearance()


/turf/open/moving/auto_icon/proc/change_me(icon, icon_state)
	src.icon = icon
	src.base_icon_state = icon_state

	update_icon()
	update_icon_state()
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


/datum/moving_turf_transition/plain_snow
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
		TRANSITION_GROUP_12 = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_13 = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_14 = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_15 = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_16 = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_17 = TRANSITION_OPTION_SNOW,
		TRANSITION_GROUP_18 = TRANSITION_OPTION_SNOW_BORDER
	)


/datum/moving_turf_transition/bridge

	change_spawn_theme = /datum/train_object_spawner_theme/bridge
	transition_options = list(
		TRANSITION_GROUP_1  = TRANSITION_OPTION_BRIDGE,
		TRANSITION_GROUP_2  = TRANSITION_OPTION_BRIDGE,
		TRANSITION_GROUP_3  = TRANSITION_OPTION_BRIDGE,
		TRANSITION_GROUP_4  = TRANSITION_OPTION_BRIDGE,
		TRANSITION_GROUP_5  = TRANSITION_OPTION_BRIDGE_FENCE,
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
