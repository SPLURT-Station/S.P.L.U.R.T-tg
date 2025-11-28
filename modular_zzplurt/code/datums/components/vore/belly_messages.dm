/obj/vore_belly
	var/list/drain_messages_owner
	var/list/drain_messages_prey
	var/list/heal_messages_owner
	var/list/heal_messages_prey

/obj/vore_belly/proc/get_drain_messages_owner(mob/prey)
	if(LAZYLEN(drain_messages_owner))
		return format_message(pick(drain_messages_owner), prey)
	return format_message(pick(GLOB.drain_messages_owner), prey)

/obj/vore_belly/proc/get_drain_messages_prey(mob/prey)
	if(LAZYLEN(drain_messages_prey))
		return format_message(pick(drain_messages_prey), prey)
	return format_message(pick(GLOB.drain_messages_prey), prey)

/obj/vore_belly/proc/get_heal_messages_owner(mob/prey)
	if(LAZYLEN(heal_messages_owner))
		return format_message(pick(heal_messages_owner), prey)
	return format_message(pick(GLOB.heal_messages_owner), prey)

/obj/vore_belly/proc/get_heal_messages_prey(mob/prey)
	if(LAZYLEN(heal_messages_prey))
		return format_message(pick(heal_messages_prey), prey)
	return format_message(pick(GLOB.heal_messages_prey), prey)

/obj/vore_belly/proc/get_struggle_messages_outside(mob/prey)
	if(LAZYLEN(struggle_messages_outside))
		return format_message(pick(struggle_messages_outside), prey)
	return format_message(pick(GLOB.struggle_messages_outside), prey)
