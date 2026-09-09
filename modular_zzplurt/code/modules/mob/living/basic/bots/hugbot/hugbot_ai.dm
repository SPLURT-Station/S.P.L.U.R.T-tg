#define BOT_HUG_TARGET_PATH_LIMIT 20

/datum/ai_controller/basic_controller/bot/hugbot
	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity/pacifist,
		/datum/ai_planning_subtree/respond_to_summon,
		/datum/ai_planning_subtree/hugbot_panic,
		/datum/ai_planning_subtree/comfort_patients,
		/datum/ai_planning_subtree/salute_authority,
		/datum/ai_planning_subtree/find_patrol_beacon/hugbot,
	)
	ai_movement = /datum/ai_movement/jps/bot/hugbot
	reset_keys = list(
		BB_PATIENT_TARGET,
		BB_BEACON_TARGET,
		BB_PREVIOUS_BEACON_TARGET,
		BB_BOT_SUMMON_TARGET,
	)

/datum/ai_movement/jps/bot/hugbot
	maximum_length = BOT_HUG_TARGET_PATH_LIMIT
	max_pathing_attempts = 20

// only AI isnt allowed to move when this flag is set, sentient players can
/datum/ai_movement/jps/bot/hugbot/allowed_to_move(datum/move_loop/source)
	var/datum/ai_controller/controller = source.extra_info
	var/mob/living/basic/bot/hugbot/bot_pawn = controller.pawn
	if(bot_pawn.hugbot_flags & HUGBOT_STATIONARY_MODE)
		return FALSE
	return ..()

/datum/ai_movement/jps/bot/hugbot/travel_to_beacon
	maximum_length = AI_BOT_PATH_LENGTH

/// If someone tipped us over, escalate the panic instead of planning anything else.
/datum/ai_planning_subtree/hugbot_panic

/datum/ai_planning_subtree/hugbot_panic/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/basic/bot/hugbot/bot_pawn = controller.pawn
	if(!(bot_pawn.hugbot_flags & HUGBOT_TIPPED_MODE))
		return
	controller.queue_behavior(/datum/ai_behavior/hugbot_panic, BB_ANNOUNCE_ABILITY)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/hugbot_panic
	action_cooldown = 2 SECONDS
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/hugbot_panic/perform(seconds_per_tick, datum/ai_controller/controller, announce_key)
	var/mob/living/basic/bot/hugbot/bot_pawn = controller.pawn
	if(!(bot_pawn.hugbot_flags & HUGBOT_TIPPED_MODE))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	bot_pawn.tipped_status++
	if(bot_pawn.tipped_status >= HUGBOT_PANIC_END)
		bot_pawn.right_ourselves() // strong independent hugbot
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED
	var/message
	switch(bot_pawn.tipped_status)
		if(HUGBOT_PANIC_LOW)
			message = MEDIBOT_VOICED_ASSISTANCE
		if(HUGBOT_PANIC_MED)
			message = MEDIBOT_VOICED_PUT_BACK
		if(HUGBOT_PANIC_HIGH)
			message = MEDIBOT_VOICED_IM_SCARED
		if(HUGBOT_PANIC_FUCK)
			message = pick(MEDIBOT_VOICED_NEED_HELP, MEDIBOT_VOICED_THIS_HURTS)
		if(HUGBOT_PANIC_ENDING)
			message = pick(MEDIBOT_VOICED_THE_END, MEDIBOT_VOICED_NOOO)
	if(!isnull(message))
		bot_pawn.speak(message)
	else if(prob(bot_pawn.tipped_status * 0.2))
		playsound(bot_pawn, 'sound/machines/warning-buzzer.ogg', 30, FALSE, -2)
	if(prob(bot_pawn.tipped_status))
		bot_pawn.do_jitter_animation(bot_pawn.tipped_status * 0.1)
	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED

/// Find someone in need of comfort and go cheer them up.
/datum/ai_planning_subtree/comfort_patients

/datum/ai_planning_subtree/comfort_patients/SelectBehaviors(datum/ai_controller/basic_controller/bot/controller, seconds_per_tick)
	var/mob/living/basic/bot/hugbot/bot_pawn = controller.pawn
	if(bot_pawn.hugbot_flags & HUGBOT_TIPPED_MODE)
		controller.clear_blackboard_key(BB_PATIENT_TARGET)
		return
	var/is_stationary = bot_pawn.hugbot_flags & HUGBOT_STATIONARY_MODE
	if(controller.blackboard_key_exists(BB_PATIENT_TARGET))
		controller.queue_behavior(/datum/ai_behavior/comfort_patient, BB_PATIENT_TARGET, is_stationary)
		return SUBTREE_RETURN_FINISH_PLANNING
	controller.queue_behavior(/datum/ai_behavior/find_suitable_hug_target, BB_PATIENT_TARGET)

/datum/ai_behavior/find_suitable_hug_target
	var/search_range = 7
	action_cooldown = 2 SECONDS

/datum/ai_behavior/find_suitable_hug_target/perform(seconds_per_tick, datum/ai_controller/basic_controller/bot/controller, target_key)
	var/mob/living/basic/bot/hugbot/bot_pawn = controller.pawn
	var/range = (bot_pawn.hugbot_flags & HUGBOT_STATIONARY_MODE) ? 1 : search_range
	var/list/ignore_keys = controller.blackboard[BB_TEMPORARY_IGNORE_LIST]
	for(var/mob/living/carbon/human/potential_friend in oview(range, controller.pawn))
		if(LAZYACCESS(ignore_keys, potential_friend) || potential_friend.stat == DEAD)
			continue
		if(!bot_pawn.assess_patient(potential_friend))
			continue
		controller.set_if_can_reach(key = target_key, target = potential_friend, distance = BOT_HUG_TARGET_PATH_LIMIT, bypass_add_to_blacklist = (range == 1))
		break

	if(controller.blackboard_key_exists(target_key))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED
	else
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

/datum/ai_behavior/comfort_patient
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/comfort_patient/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/comfort_patient/perform(seconds_per_tick, datum/ai_controller/basic_controller/bot/controller, target_key)
	var/mob/living/carbon/human/patient = controller.blackboard[target_key]
	if(QDELETED(patient) || patient.stat == DEAD)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	var/mob/living/basic/bot/hugbot/bot_pawn = controller.pawn
	if(!bot_pawn.assess_patient(patient))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED
	bot_pawn.melee_attack(patient)
	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED

// clear the target once they have been comforted (or are out of reach)
/datum/ai_behavior/comfort_patient/finish_action(datum/ai_controller/basic_controller/bot/controller, succeeded, target_key, is_stationary)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(!succeeded)
		if(!isnull(target) && !is_stationary)
			controller.add_to_blacklist(target)
		controller.clear_blackboard_key(target_key)
		return
	if(QDELETED(target))
		controller.clear_blackboard_key(target_key)
		return
	var/mob/living/basic/bot/hugbot/bot_pawn = controller.pawn
	if(QDELETED(bot_pawn) || !bot_pawn.assess_patient(target)) // comfort delivered, move on to someone else
		controller.add_to_blacklist(target, HUGBOT_REHUG_COOLDOWN)
		controller.clear_blackboard_key(target_key)

/datum/ai_planning_subtree/find_patrol_beacon/hugbot
	///travel towards beacon behavior
	travel_behavior = /datum/ai_behavior/travel_towards/beacon/hugbot

/datum/ai_planning_subtree/find_patrol_beacon/hugbot/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/basic/bot/hugbot/bot_pawn = controller.pawn
	if(bot_pawn.hugbot_flags & HUGBOT_STATIONARY_MODE)
		return
	return ..()

/datum/ai_behavior/travel_towards/beacon/hugbot
	new_movement_type = /datum/ai_movement/jps/bot/hugbot/travel_to_beacon

#undef BOT_HUG_TARGET_PATH_LIMIT
