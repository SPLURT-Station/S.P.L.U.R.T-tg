/datum/ai_controller/basic_controller/trooper/syndicate
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_TARGET_MINIMUM_STAT = HARD_CRIT,
		BB_AGGRO_RANGE = 11,
		BB_REINFORCEMENTS_SAY = list(
			"Nanotrasen scum spotted, open fire!",
			"Hostile NT asset detected, eliminate them!",
			"For the Syndicate, engage!",
			"Target confirmed, wipe them out!",
			"Another Nanotrasen pawn, put them down!",
			"Intruder identified, lethal force authorized!",
			"Crush the corporation's lapdogs!",
			"No witnesses, take them out!",
			"NT presence detected, neutralize immediately!",
			"They picked the wrong station, kill them!",
			"Corporate dogs inbound, send them to hell!",
			"Enemy of the Syndicate, terminate!",
			"Show them what happens when you cross us!",
		)
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk/less_walking
	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/call_reinforcements/syndicate,
		/datum/ai_planning_subtree/simple_find_target/true_vision,
		/datum/ai_planning_subtree/attack_obstacle_in_path/trooper,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
	)

/datum/ai_planning_subtree/call_reinforcements/syndicate // Just so they speak, but don't actually clump up in one group.
	call_type = /datum/ai_behavior/call_reinforcements/syndicate

/datum/ai_behavior/call_reinforcements/syndicate

/datum/ai_behavior/call_reinforcements/syndicate/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()

	if(!.)
		return

	if(!istype(controller, /datum/ai_controller))
		return

	var/msg = controller.blackboard[BB_REINFORCEMENTS_SAY]

	if(islist(msg))
		msg = pick(msg)

	var/mob/living/M = controller.pawn
	if(M && msg)
		M.say(msg)

/datum/ai_controller/basic_controller/trooper/syndicate/ranged
	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/call_reinforcements/syndicate,
		/datum/ai_planning_subtree/simple_find_target/true_vision,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree/trooper/syndicate,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
	)

/datum/ai_planning_subtree/basic_ranged_attack_subtree/trooper/syndicate
	ranged_attack_behavior = /datum/ai_behavior/basic_ranged_attack/trooper/syndicate

/datum/ai_behavior/basic_ranged_attack/trooper/syndicate
	action_cooldown = 1 SECONDS
	required_distance = 8
	avoid_friendly_fire = TRUE

/datum/ai_controller/basic_controller/trooper/syndicate/ranged/burst
	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/call_reinforcements/syndicate,
		/datum/ai_planning_subtree/simple_find_target/true_vision,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree/trooper_burst/syndicate,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
	)

/datum/ai_planning_subtree/basic_ranged_attack_subtree/trooper_burst/syndicate
	ranged_attack_behavior = /datum/ai_behavior/basic_ranged_attack/trooper_burst/syndicate

/datum/ai_behavior/basic_ranged_attack/trooper_burst/syndicate
	action_cooldown = 3 SECONDS
	required_distance = 8
	avoid_friendly_fire = TRUE

/datum/ai_controller/basic_controller/trooper/syndicate/ranged/shotgunner
	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/call_reinforcements/syndicate,
		/datum/ai_planning_subtree/simple_find_target/true_vision,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree/trooper_shotgun/syndicate,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
	)

/datum/ai_planning_subtree/basic_ranged_attack_subtree/trooper_shotgun/syndicate
	ranged_attack_behavior = /datum/ai_behavior/basic_ranged_attack/trooper_shotgun/syndicate

/datum/ai_behavior/basic_ranged_attack/trooper_shotgun/syndicate
	action_cooldown = 3 SECONDS
	required_distance = 3
	avoid_friendly_fire = TRUE

/datum/ai_planning_subtree/simple_find_target/true_vision

/datum/ai_planning_subtree/simple_find_target/true_vision/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	controller.queue_behavior(
		/datum/ai_behavior/find_potential_targets/true_vision,
		target_key,
		strategy_key,
		BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION
	)

/datum/ai_behavior/find_potential_targets/true_vision
	vision_range = 11
