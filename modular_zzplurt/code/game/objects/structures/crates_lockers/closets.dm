/obj/structure/closet
	/// The overlay for packing peanuts
	var/obj/effect/overlay/packing_peanuts/packing_overlay
	/// What icon we use for packing peanuts
	var/packing_icon = 'modular_zzplurt/icons/obj/crates_peanuts.dmi'
	/**
	 * What icon state we use for packing peanuts
	 * This also uses an "_over" overlay, that goes above items
	 */
	var/packing_icon_state = "packing"
	/// Whether or not we can be filled with packing peanuts
	var/packable = FALSE
	/// Whether or not this crate is filled with packing peanuts on initialize
	var/start_packed = FALSE

/obj/structure/closet/LateInitialize()
	. = ..()
	if(start_packed)
		get_packed()

/obj/structure/closet/Destroy()
	. = ..()
	QDEL_NULL(packing_overlay)

/obj/structure/closet/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(opened)
		if(istype(held_item, /obj/item/stack/packing_peanuts) && !packing_overlay)
			context[SCREENTIP_CONTEXT_LMB] = "Pack peanuts"
			return CONTEXTUAL_SCREENTIP_SET
		else if(isnull(held_item) && packing_overlay)
			context[SCREENTIP_CONTEXT_ALT_RMB] = "Unpack peanuts"
			return CONTEXTUAL_SCREENTIP_SET

/obj/structure/closet/examine(mob/user)
	. = ..()
	if(opened)
		if(packing_overlay)
			. += span_notice("[p_Theyre()] filled to the brim with packing peanuts. [EXAMINE_HINT("Alt-RMB")] to take them out.")
		else if(packable && !packing_overlay)
			. += span_notice("[p_They()] can be packed with [EXAMINE_HINT("packing peanuts")] for safer delivery of fragile objects.")

/obj/structure/closet/update_overlays()
	. = ..()
	if(!packing_overlay)
		return .

	if(opened)
		vis_contents += packing_overlay
	else
		vis_contents -= packing_overlay

/obj/structure/closet/click_alt_secondary(mob/user)
	. = ..()
	if(. == CLICK_ACTION_BLOCKING || !opened || !packing_overlay)
		return
	try_unpacking(user, create_peanuts = TRUE)
	return CLICK_ACTION_BLOCKING

/obj/structure/closet/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/packing_peanuts) && opened && packable && !packing_overlay)
		try_packing(W, user)
		take_contents()
		return TRUE //no afterattack
	else if(opened && packing_overlay)
		balloon_alert(user, "packing item...")
		if(do_after(user, 1 SECONDS, target = src))
			insert(W)
			balloon_alert(user, "packed!")
			return TRUE
	return ..()

/obj/structure/closet/dump_contents()
	if(packing_overlay)
		var/atom/movable/peanuts = get_unpacked(create_peanuts = TRUE)
		if(istype(peanuts))
			peanuts.forceMove(src)
	return ..()

/obj/structure/closet/insert(atom/movable/inserted, mapload = FALSE)
	. = ..()
	if(!. || !packing_overlay)
		return .
	packing_overlay.update_contents(src)
	inserted.flags_1 |= IS_ONTOP_1
	RegisterSignal(inserted, COMSIG_MOVABLE_MOVED, PROC_REF(thing_moved))

/obj/structure/closet/proc/try_packing(obj/item/stack/peanuts, mob/user)
	if(user)
		balloon_alert(user, "packing...")
		if(!do_after(user, 3 SECONDS, src))
			return FALSE
	if(!peanuts.use(10))
		balloon_alert(user, "not enough [peanuts]!")
		return FALSE
	var/successfully_packed = get_packed()
	if(successfully_packed && user)
		balloon_alert(user, "packed!")
	return successfully_packed

/obj/structure/closet/proc/try_unpacking(mob/user, create_peanuts = TRUE)
	if(user)
		balloon_alert(user, "unpacking...")
		if(!do_after(user, 1 SECONDS, src))
			return FALSE
	var/successfully_unpacked = get_unpacked(create_peanuts)
	if(successfully_unpacked)
		if(opened)
			dump_contents()
		if(user)
			balloon_alert(user, "unpacked!")
	return successfully_unpacked

/obj/structure/closet/proc/get_packed()
	packing_overlay = new(null, src)
	packing_overlay.update_contents(src)
	for(var/atom/movable/inserted in src)
		inserted.flags_1 |= IS_ONTOP_1
		RegisterSignal(inserted, COMSIG_MOVABLE_MOVED, PROC_REF(thing_moved))
	update_appearance(UPDATE_ICON)
	return TRUE

/obj/structure/closet/proc/get_unpacked(create_peanuts = TRUE)
	if(!packing_overlay)
		return FALSE
	QDEL_NULL(packing_overlay)
	if(create_peanuts)
		if(!opened)
			return new /obj/item/stack/packing_peanuts(src, 10)
		return new /obj/item/stack/packing_peanuts(loc, 10)
	return TRUE

/obj/structure/closet/proc/thing_moved(atom/movable/source)
	SIGNAL_HANDLER

	source.flags_1 &= ~IS_ONTOP_1
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	packing_overlay.update_contents(src)
