SUBSYSTEM_DEF(interactions)
	name = "Interactions"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_INTERACTIONS
	var/list/interactions = list()

/datum/controller/subsystem/interactions/Initialize(timeofday)
	make_interactions()
	return ..()

/// Makes the interactions, they're also a global list because having it as a list and just hanging around there is stupid
/datum/controller/subsystem/interactions/proc/make_interactions()
	if(!interactions || !length(interactions))
		interactions = list()
		for(var/itype in subtypesof(/datum/interaction))
			var/datum/interaction/I = new itype()
			interactions[I.command] = I
	else
		message_admins("make_interactions() called with interactions already made!")
