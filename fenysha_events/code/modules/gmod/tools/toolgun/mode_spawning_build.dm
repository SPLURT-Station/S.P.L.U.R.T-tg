/datum/toolgun_mode/spawning/build_mode
	name = "Строительство"
	desc = "Режим строительства для быстрой постройки чего-либо. Абсолютно бесплатно!"
	mode_key = "build"
	type_blacklist = list(
		/turf/baseturf_skipover,
		/turf/baseturf_bottom,
		/turf/open/genturf,
		/turf/open/openspace,
	)

	var/build_action = "brush"
	var/wand_range = 3
	var/max_fill_tiles = 600

/datum/toolgun_mode/spawning/build_mode/get_root_type()
	return /turf

/datum/toolgun_mode/spawning/build_mode/get_default_type()
	return /turf

/datum/toolgun_mode/spawning/build_mode/get_root_path_text()
	return "/turf"

/datum/toolgun_mode/spawning/build_mode/get_entry_list_key()
	return "turfs"

/datum/toolgun_mode/spawning/build_mode/get_selected_data_key()
	return "selected_turf"

/datum/toolgun_mode/spawning/build_mode/get_select_action_name()
	return "select_turf"

/datum/toolgun_mode/spawning/build_mode/get_spawn_action_name()
	return "build_here"

/datum/toolgun_mode/spawning/build_mode/ui_static_data(mob/user)
	return list(
		"type_nodes" = get_cached_type_nodes(),
		"objects_all" = get_cached_entries(),
	)

/datum/toolgun_mode/spawning/build_mode/ui_data(mob/user)
	. = ..()
	.["build_action"] = build_action
	.["wand_range"] = wand_range

/datum/toolgun_mode/spawning/build_mode/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("set_build_action")
			var/new_action = trimtext(params["build_action"])
			if(new_action in list("brush", "fill", "wand"))
				build_action = new_action
			return TRUE

		if("set_wand_range")
			var/new_range = text2num(params["range"])
			if(isnum(new_range))
				wand_range = clamp(new_range, 1, 12)
			return TRUE

	return ..()

/datum/toolgun_mode/spawning/build_mode/main_act(atom/target, mob/user)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE

	switch(build_action)
		if("fill")
			return fill_region(target_turf)
		if("wand")
			return wand_replace(target_turf)
		else
			return apply_to_turf(target_turf)

/datum/toolgun_mode/spawning/build_mode/secondnary_act(atom/target, mob/user)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE
	selected_type = target_turf.type
	selected_type_path = "[target_turf.type]"
	our_tool.balloon_alert(user, "Выбрано [target_turf]!")
	return FALSE

/datum/toolgun_mode/spawning/build_mode/proc/apply_to_turf(turf/target_turf)
	if(!target_turf || !selected_type || !ispath(selected_type, /turf))
		return FALSE
	var/turf/new_turf = target_turf
	if(target_turf.type != selected_type)
		new_turf = target_turf.ChangeTurf(selected_type, flags = CHANGETURF_INHERIT_AIR)
	if(!new_turf)
		return FALSE
	apply_customization(new_turf)
	return TRUE

/datum/toolgun_mode/spawning/build_mode/proc/wand_replace(turf/center_turf)
	if(!center_turf)
		return FALSE
	var/changed_tiles = 0
	for(var/turf/T in range(wand_range, center_turf))
		if(apply_to_turf(T))
			changed_tiles++
	return changed_tiles > 0

/datum/toolgun_mode/spawning/build_mode/proc/fill_region(turf/start_turf)
	if(!start_turf || !selected_type)
		return FALSE
	var/start_type = start_turf.type
	var/list/pending = list(start_turf)
	var/list/visited = list("\ref[start_turf]" = TRUE)
	var/processed = 0

	while(length(pending) && processed < max_fill_tiles)
		var/turf/current = pending[1]
		pending.Cut(1, 2)
		if(!current || current.type != start_type)
			continue
		if(!apply_to_turf(current))
			continue
		processed++

		for(var/direction in GLOB.cardinals)
			var/turf/neighbor = get_step(current, direction)
			if(!neighbor || neighbor.type != start_type)
				continue
			var/neighbor_key = "\ref[neighbor]"
			if(visited[neighbor_key])
				continue
			visited[neighbor_key] = TRUE
			pending += neighbor

	return processed > 0
