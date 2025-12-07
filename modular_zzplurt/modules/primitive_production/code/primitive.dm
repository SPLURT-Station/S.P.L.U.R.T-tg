/datum/status_effect/primitive_skill/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_step))

/datum/status_effect/primitive_skill/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	return ..()

/datum/status_effect/primitive_skill/tick(seconds_between_ticks)
	for(var/obj/structure/simple_farm/farm in view(3, owner))
		farm.increase_level(stored_level)

/datum/status_effect/primitive_skill/proc/on_step()
	SIGNAL_HANDLER

	if(stored_level < SKILL_LEVEL_MASTER)
		return

	var/range = stored_level == SKILL_LEVEL_MASTER ? 0 : 1
	for(var/obj/structure/simple_farm/farm in view(range, owner))
		if(COOLDOWN_FINISHED(farm, harvest_cooldown))
			farm.create_harvest()
			farm.update_appearance()
