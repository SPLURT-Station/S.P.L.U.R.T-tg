/datum/element/spontaneous_vore

/datum/element/spontaneous_vore/Attach(datum/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_LIVING_STUMBLED_INTO, PROC_REF(handle_stumble))
	RegisterSignal(target, COMSIG_LIVING_FALLING_DOWN, PROC_REF(handle_fall))
	RegisterSignal(target, COMSIG_LIVING_HIT_BY_THROWN_ENTITY, PROC_REF(handle_hitby))
	RegisterSignal(target, COMSIG_MOVABLE_CROSS, PROC_REF(handle_crossed))

/datum/element/spontaneous_vore/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, list(COMSIG_LIVING_STUMBLED_INTO, COMSIG_LIVING_FALLING_DOWN, COMSIG_LIVING_HIT_BY_THROWN_ENTITY, COMSIG_MOVABLE_CROSS))

///Source is the one being bumped into (Owner of this component)
///Target is the one bumping into us.
/datum/element/spontaneous_vore/proc/handle_stumble(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	if(!isturf(target.loc) || !isturf(source.loc))
		return

	var/datum/component/vore/source_vore = source.GetComponent(/datum/component/vore)
	if(source_vore && check_vore_preferences(source, source, target, TRUE))
		source.visible_message(span_warning("[target] flops carelessly right into [source]'s mouth!"))
		source_vore.vore_other(target)
		target.stop_flying()
		return CANCEL_STUMBLED_INTO

/datum/element/spontaneous_vore/proc/handle_fall(mob/living/source, turf/landing, mob/living/drop_mob)
	SIGNAL_HANDLER

	if(!drop_mob || drop_mob == source)
		return

	if((drop_mob.status_flags & HIDING))
		var/obj/structure/table/is_there_a_table = locate() in landing
		if(is_there_a_table)
			return

	// pred = drop_mob, prey = source
	var/datum/component/vore/drop_mob_vore = drop_mob.GetComponent(/datum/component/vore)
	if(drop_mob_vore && check_vore_preferences(drop_mob, drop_mob, source, TRUE))
		drop_mob.visible_message(span_danger("\The [drop_mob] swallows \the [source] as they fall right into their mouth!"))
		drop_mob_vore.vore_other(source)
		return COMSIG_CANCEL_FALL

/datum/element/spontaneous_vore/proc/handle_hitby(mob/living/source, atom/movable/hitby, mob/thrower, speed)
	SIGNAL_HANDLER

	if(isliving(hitby))
		var/mob/living/thrown_mob = hitby
		
		var/datum/component/vore/source_vore = source.GetComponent(/datum/component/vore)
		if(source_vore && check_vore_preferences(source, source, thrown_mob, TRUE))
			source.visible_message(span_warning("[thrown_mob] is thrown right into [source]'s mouth!"))
			source_vore.vore_other(thrown_mob)
			return COMSIG_CANCEL_HITBY

/datum/element/spontaneous_vore/proc/handle_crossed(mob/living/source, mob/living/crossed)
	SIGNAL_HANDLER

	if(source == crossed || !istype(crossed))
		return

	var/datum/component/vore/source_vore = source.GetComponent(/datum/component/vore)
	if(source_vore && check_vore_preferences(source, source, crossed, TRUE))
		source.visible_message(span_warning("[crossed] slips right into [source]'s open mouth!"))
		source_vore.vore_other(crossed)
		return COMPONENT_BLOCK_CROSS
