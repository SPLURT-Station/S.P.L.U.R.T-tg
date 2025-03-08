/datum/uplink_handler/generate_objectives()
	var/potential_objectives_left = maximum_potential_objectives - (length(potential_objectives) + length(active_objectives))
	var/list/objectives = SStraitor.category_handler.get_possible_objectives(progression_points)
	if(!length(objectives))
		return
	while(length(objectives) && potential_objectives_left > 0)
		var/objective_typepath = pick_weight(objectives)
		var/list/target_list = objectives
		while(islist(objective_typepath))
			if(!length(objective_typepath))
				// Need to wrap this in a list or else it list unrolls and the list doesn't actually get removed.
				// Thank you byond, very cool!
				target_list -= list(objective_typepath)
				break
			target_list = objective_typepath
			objective_typepath = pick_weight(objective_typepath)
		if(islist(objective_typepath) || !objective_typepath)
			continue
		if(!try_add_objective(objective_typepath))
			target_list -= objective_typepath
			continue
		potential_objectives_left--
	on_update()
