/datum/ai_controller/basic_controller/trooper/ranged/peaceful
	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/call_reinforcements,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree/trooper,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target/reinforce,
	)
