/datum/status_effect/primitive_skill/tick(seconds_between_ticks)
	for(var/obj/structure/simple_farm/farm in view(3, owner))
		farm.increase_level(stored_level)

