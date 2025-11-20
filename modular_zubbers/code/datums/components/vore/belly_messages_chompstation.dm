// CHOMPStation message getters for Drain/Heal modes
// Separated from core belly_messages.dm for modularity

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
