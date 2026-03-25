// Minimal smother component scaffold.
// Provides a hook for smothering/breath-control mechanics and ties into player prefs.

GLOBAL_LIST_INIT(smother_allowed_mob_types, typecacheof(list(
	/mob/living/carbon/human,
	/mob/living/silicon/robot
)))

/datum/component/smother
	dupe_mode = COMPONENT_DUPE_UNIQUE

var/mob/living/owner = null

/datum/component/smother/Initialize(...)
	. = ..()
	if(!is_type_in_typecache(parent, GLOB.smother_allowed_mob_types))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	return 0

/datum/component/smother/RegisterWithParent()
	// Placeholder: future actions / UI registration would go here
	return

/datum/component/smother/UnregisterFromParent()
	return

/datum/component/smother/Destroy(force)
	owner = null
	return ..()
