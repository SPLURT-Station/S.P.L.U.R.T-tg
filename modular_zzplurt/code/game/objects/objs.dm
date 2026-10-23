/**
 * Element that causes an object to vanish when moved outside the Ghost Cafe or Infinidorms.
 * Safely preserves objects stored in Hilbert's Hotel / Infinidorm conservation storage.
 */
/datum/element/ghost_cafe_only
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/ghost_cafe_only/Attach(datum/target)
	. = ..()
	if(!isobj(target))
		return ELEMENT_INCOMPATIBLE
	var/obj/obj_target = target
	obj_target.become_area_sensitive(type)
	RegisterSignal(obj_target, COMSIG_ENTER_AREA, PROC_REF(on_enter_area))

/datum/element/ghost_cafe_only/Detach(datum/source)
	. = ..()
	if(!isobj(source))
		return
	var/obj/obj_source = source
	UnregisterSignal(obj_source, COMSIG_ENTER_AREA)
	obj_source.lose_area_sensitivity(type)

/datum/element/ghost_cafe_only/proc/is_valid_ghost_cafe_area(area/check_area)
	if(!check_area)
		return TRUE
	if(check_area.type in GLOB.ghost_cafe_areas)
		return TRUE
	if(istype(check_area, /area/misc/condo) || istype(check_area, /area/centcom/holding))
		return TRUE
	if(istype(check_area, /area/misc/hilbertshotelstorage) || istype(check_area, /area/misc/hilbertshotel))
		return TRUE
	return FALSE

/datum/element/ghost_cafe_only/proc/on_enter_area(obj/source, area/entered_area)
	SIGNAL_HANDLER
	if(QDELETED(source) || !source.ghost_cafe_only)
		return
	if(is_valid_ghost_cafe_area(entered_area))
		return
	addtimer(CALLBACK(src, PROC_REF(vanish_object), source), 0)

/datum/element/ghost_cafe_only/proc/vanish_object(obj/source)
	if(QDELETED(source) || !source.ghost_cafe_only)
		return
	var/area/current_area = get_area(source)
	if(is_valid_ghost_cafe_area(current_area))
		return
	var/turf/T = get_turf(source)
	if(T)
		do_harmless_sparks(3, FALSE, T)
	source.visible_message(span_warning("[source] vanishes in a flash of light!"))
	qdel(source)

/obj
	/// If TRUE, this object will vanish if moved outside of the Ghost Cafe or Infinidorms.
	var/ghost_cafe_only = FALSE

/obj/Initialize(mapload)
	. = ..()
	if(ghost_cafe_only)
		AddElement(/datum/element/ghost_cafe_only)

/obj/vv_edit_var(vname, vval)
	. = ..()
	if(. && vname == NAMEOF(src, ghost_cafe_only))
		if(ghost_cafe_only)
			AddElement(/datum/element/ghost_cafe_only)
		else
			RemoveElement(/datum/element/ghost_cafe_only)

/obj/item/stack/can_merge(obj/item/stack/check, inhand = FALSE)
	. = ..()
	if(. && ghost_cafe_only != check.ghost_cafe_only)
		return FALSE

/obj/item/stack/split_stack(amount)
	. = ..()
	var/obj/item/stack/split = .
	if(split && ghost_cafe_only && !split.ghost_cafe_only)
		split.ghost_cafe_only = TRUE
		split.AddElement(/datum/element/ghost_cafe_only)
