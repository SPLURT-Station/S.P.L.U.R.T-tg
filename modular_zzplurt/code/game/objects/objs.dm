/obj
	/// Whether this object vanishes when taken outside the ghost cafe or infinidorms
	var/ghost_cafe_only = FALSE

/obj/Initialize(mapload)
	. = ..()
	if(ghost_cafe_only)
		enable_ghost_cafe_restriction()

/obj/vv_edit_var(vname, vval)
	. = ..()
	if(. && vname == NAMEOF(src, ghost_cafe_only))
		if(ghost_cafe_only)
			enable_ghost_cafe_restriction()
		else
			disable_ghost_cafe_restriction()

/obj/proc/enable_ghost_cafe_restriction()
	become_area_sensitive(INNATE_TRAIT)
	RegisterSignal(src, COMSIG_ENTER_AREA, PROC_REF(on_ghost_cafe_area_entered), override = TRUE)
	on_ghost_cafe_area_entered(src, get_area(src))

/obj/proc/disable_ghost_cafe_restriction()
	UnregisterSignal(src, COMSIG_ENTER_AREA)
	lose_area_sensitivity(INNATE_TRAIT)

/obj/proc/on_ghost_cafe_area_entered(datum/source, area/entered_area)
	SIGNAL_HANDLER
	if(QDELETED(src) || !ghost_cafe_only || !entered_area)
		return
	if((entered_area.type in GLOB.ghost_cafe_areas) || istype(entered_area, /area/misc/hilbertshotelstorage))
		return
	addtimer(CALLBACK(src, PROC_REF(vanish_outside_ghost_cafe)), 0)

/obj/proc/vanish_outside_ghost_cafe()
	if(QDELETED(src) || !ghost_cafe_only)
		return
	var/area/current_area = get_area(src)
	if(!current_area || (current_area.type in GLOB.ghost_cafe_areas) || istype(current_area, /area/misc/hilbertshotelstorage))
		return
	do_harmless_sparks(3, FALSE, src)
	visible_message(span_warning("[src] vanishes in a flash of light!"))
	qdel(src)

/obj/item/stack/can_merge(obj/item/stack/check, inhand = FALSE)
	. = ..()
	if(. && ghost_cafe_only != check.ghost_cafe_only)
		return FALSE

/obj/item/stack/split_stack(amount)
	. = ..()
	var/obj/item/stack/split = .
	if(split && ghost_cafe_only && !split.ghost_cafe_only)
		split.ghost_cafe_only = TRUE
		split.enable_ghost_cafe_restriction()

