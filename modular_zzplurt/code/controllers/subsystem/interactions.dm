/*
 * # INIT_ORDER_INTERACTIONS
 * Used by the Interactions subsystems, used to set it's own position in the queue.
 * This puts this last on priority, very far from other subsystems,
 * if citadel ever manages to get this far, push it ever lower.
*/
#define INIT_ORDER_INTERACTIONS		-150
#define QDEL_NULL_LIST(x) if(x) { for(var/y in x) { qdel(y) } ; x = null }

SUBSYSTEM_DEF(interactions)
	name = "Interactions"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_INTERACTIONS
	var/list/interactions
	VAR_PROTECTED/list/blacklisted_mobs = list(
		/mob/dead,
		/mob/dview,
		/mob/camera, // Although it would be funny to fuck the sentient disease or AI hologram
		/mob/living/simple_animal/ //Please don't commit bestiality
	)
	VAR_PROTECTED/initialized_blacklist



/datum/controller/subsystem/interactions/Initialize(timeofday)
	prepare_interactions()
	prepare_blacklisted_mobs()
	. = ..()
	var/extra_info = "<font style='transform: translate(0%, -25%);'>↳</font> Loaded [LAZYLEN(interactions)] interactions!"
	to_chat(world, span_boldannounce(extra_info))
	log_subsystem(src, extra_info)

/datum/controller/subsystem/interactions/stat_entry(msg)
	msg += "|🖐:[LAZYLEN(interactions)]|"
	msg += "🚫👨:[LAZYLEN(blacklisted_mobs)]"
	return ..()

/// Makes the interactions, they're also a global list because having it as a list and just hanging around there is stupid
/datum/controller/subsystem/interactions/proc/prepare_interactions()
	QDEL_NULL_LIST(interactions)
	interactions = list()
	for(var/datum/interaction/interaction as anything in subtypesof(/datum/interaction))
		// Basetype, do not create
		if(!initial(interaction.description))
			continue
		interaction = new interaction()
		interactions["[interaction.type]"] = interaction

/// Blacklisting!
/datum/controller/subsystem/interactions/proc/prepare_blacklisted_mobs()
	blacklisted_mobs = typecacheof(blacklisted_mobs)
	initialized_blacklist = TRUE

/*
 * Lewd interactions have a blacklist for certain mobs. When we evalute the user and target, both of
 * their requirements must be satisfied, and the mob must not be of a blacklisted type.
*/
/datum/controller/subsystem/interactions/proc/is_blacklisted(mob/living/creature)
	if(!creature || !initialized_blacklist)
		return TRUE
	if(is_type_in_typecache(creature, blacklisted_mobs))
		return TRUE
