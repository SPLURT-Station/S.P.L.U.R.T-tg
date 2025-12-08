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

	if(stored_level < SKILL_LEVEL_LEGENDARY)
		return

	for(var/obj/structure/simple_farm/farm in view(1, owner))
		if(COOLDOWN_FINISHED(farm, harvest_cooldown))
			COOLDOWN_START(farm, harvest_timer, farm.harvest_cooldown)
			farm.create_harvest() // this doesnt adjust exp by itself.. buut we're legendary anyways who cares
			farm.update_appearance()
