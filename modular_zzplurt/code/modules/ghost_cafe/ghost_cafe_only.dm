/obj
	/// Mapper opt-in: delete this object if it enters an area outside the ghost cafe/infinidorm allowlist.
	var/ghost_cafe_only = FALSE

/// Splitting a mapped stack must preserve its instance-level confinement flag.
/obj/proc/inherit_ghost_cafe_restriction(obj/original)
	if(!original.ghost_cafe_only || ghost_cafe_only)
		return
	ghost_cafe_only = TRUE
	AddElement(/datum/element/ghost_cafe_only)

/**
 * Keeps opted-in objects inside the same areas allowed for ghost cafe residents.
 * Area sensitivity also follows the object when it is inside moving containers.
 */
/datum/element/ghost_cafe_only
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/ghost_cafe_only/Attach(datum/target)
	. = ..()
	if(!isobj(target))
		return ELEMENT_INCOMPATIBLE

	var/obj/object = target
	object.become_area_sensitive(type)
	RegisterSignal(object, COMSIG_ENTER_AREA, PROC_REF(check_area))
	check_area(object, get_area(object))

/datum/element/ghost_cafe_only/Detach(obj/object)
	UnregisterSignal(object, COMSIG_ENTER_AREA)
	object.lose_area_sensitivity(type)
	return ..()

/datum/element/ghost_cafe_only/proc/check_area(obj/source, area/new_area)
	SIGNAL_HANDLER

	// Nullspace is also used while destroying or temporarily relocating objects.
	// Check the destination when the object next enters an actual area.
	if(QDELETED(source) || !new_area || (new_area.type in GLOB.ghost_cafe_areas))
		return

	// Defer deletion until area/Entered finishes notifying all nested recipients.
	// Immediate deletion would mutate its recursive-contents list during iteration.
	QDEL_IN(source, 0)
