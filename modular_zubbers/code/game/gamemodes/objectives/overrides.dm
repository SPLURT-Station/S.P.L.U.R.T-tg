/datum/antagonist/traitor/forge_single_generic_objective()
	if(prob(KILL_PROB))

		var/datum/objective/gimmick/gimmick_objective = new()
		gimmick_objective.owner = owner
		return gimmick_objective

	var/datum/objective/steal/steal_objective = new()
	steal_objective.owner = owner
	steal_objective.find_target()
	return steal_objective

//SPLURT EDIT REMOVAL BEGIN - Traitor Side Objectives Override
/*
/datum/uplink_handler/generate_objectives()
	on_update()
	return FALSE
*/
//SPLURT EDIT REMOVAL END
