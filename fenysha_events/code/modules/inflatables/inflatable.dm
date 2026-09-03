#define TAPE_REQUIRED_TO_FIX 2
#define INFLATABLE_DOOR_OPENED FALSE
#define INFLATABLE_DOOR_CLOSED TRUE
#define BOX_DOOR_AMOUNT 7
#define BOX_WALL_AMOUNT 14

/obj/structure/inflatable
	name = "inflatable wall"
	desc = "An inflatable membrane. Do not puncture. Alt+Click to deflate."
	can_atmos_pass = ATMOS_PASS_DENSITY
	density = TRUE
	anchored = TRUE
	max_integrity = 40
	icon = 'fenysha_events/icons/unique/inflatable.dmi'
	icon_state = "wall"
	/// Which item drops when damaged.
	var/torn_type = /obj/item/inflatable/torn
	/// Which item drops on a normal deflation.
	var/deflated_type = /obj/item/inflatable
	/// Sound of hitting the inflatable structure.
	var/hit_sound = 'sound/effects/glass/glasshit.ogg'
	/// How long a manual, calm deflation takes.
	var/manual_deflation_time = 3 SECONDS
	/// Has the structure already been deflated (protection against re-deflation).
	var/has_been_deflated = FALSE

/obj/structure/inflatable/Initialize(mapload)
	. = ..()
	air_update_turf(TRUE, !density)

/obj/structure/inflatable/ex_act(severity)
	switch(severity)
		if(EXPLODE_DEVASTATE)
			qdel(src)
			return
		if(EXPLODE_HEAVY)
			deflate(TRUE)
			return
		if(EXPLODE_LIGHT)
			if(prob(50))
				deflate(TRUE)
				return

/obj/structure/inflatable/atom_destruction(damage_flag)
	deflate(TRUE)
	return ..()

/obj/structure/inflatable/attackby(obj/item/attacking_item, mob/user, params)
	if(attacking_item.sharpness)
		visible_message(span_danger("<b>[user] punctures [src] with [attacking_item]!</b>"))
		deflate(TRUE)
		return
	return ..()

/obj/structure/inflatable/click_alt(mob/user)
	deflate(FALSE)
	return CLICK_ACTION_SUCCESS

/obj/structure/inflatable/play_attack_sound(damage_amount, damage_type, damage_flag)
	playsound(src, hit_sound, 75, TRUE)

// Deflates the inflatable wall/door and drops the corresponding item.
// If violent = TRUE, it instantly tears and drops the torn variant.
/obj/structure/inflatable/proc/deflate(violent)
	if(has_been_deflated) // Protection against re-deflation
		return

	has_been_deflated = TRUE

	playsound(src, 'sound/machines/hiss.ogg', 75, 1)
	if(!violent)
		balloon_alert_to_viewers("slowly deflating!")
		addtimer(CALLBACK(src, PROC_REF(slow_deflate_finish)), manual_deflation_time)
		return

	var/turf/inflatable_loc = get_turf(src)
	inflatable_loc.balloon_alert_to_viewers("[src] rapidly deflates!") // so it doesn't show an alert from an already-deleted object
	if(torn_type)
		new torn_type(get_turf(src))
	qdel(src)

// Called on a calm (manual) deflation - drops the intact (non-torn) item
/obj/structure/inflatable/proc/slow_deflate_finish()
	if(deflated_type)
		new deflated_type(get_turf(src))
	qdel(src)

/obj/structure/inflatable/verb/hand_deflate()
	set name = "Deflate"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || usr.can_interact())
		return
	deflate(FALSE)


/obj/structure/inflatable/door
	name = "inflatable door"
	can_atmos_pass = ATMOS_PASS_DENSITY
	icon = 'fenysha_events/icons/unique/inflatable.dmi'
	icon_state = "door_closed"
	base_icon_state = "door"
	torn_type = /obj/item/inflatable/door/torn
	deflated_type = /obj/item/inflatable/door
	/// Open (FALSE) or closed (TRUE)?
	var/door_state = INFLATABLE_DOOR_CLOSED

/obj/structure/inflatable/door/Initialize(mapload)
	. = ..()
	density = door_state

/obj/structure/inflatable/door/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!user.can_interact_with(src))
		return
	toggle_door()
	to_chat(user, span_notice("You [door_state ? "close" : "open"] [src]!"))


/obj/structure/inflatable/door/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[door_state ? "closed" : "open"]"

/obj/structure/inflatable/door/proc/toggle_door()
	if(door_state) // was closed -> open it
		door_state = INFLATABLE_DOOR_OPENED
		flick("[base_icon_state]_opening", src)
	else // was open -> close it
		door_state = INFLATABLE_DOOR_CLOSED
		flick("[base_icon_state]_closing", src)
	density = door_state
	air_update_turf(TRUE, !density)
	update_appearance()


// Deployable item (wall or door)
/obj/item/inflatable
	name = "inflatable wall"
	desc = "A folded membrane that, when activated, quickly unfolds into a large cubic shape."
	icon = 'fenysha_events/icons/unique/inflatable.dmi'
	icon_state = "folded_wall"
	base_icon_state = "folded_wall"
	w_class = WEIGHT_CLASS_SMALL
	/// Which structure to deploy when used.
	var/structure_type = /obj/structure/inflatable
	/// Whether the membrane is torn.
	var/torn = FALSE

/obj/item/inflatable/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/inflatable/torn
	torn = TRUE

/obj/item/inflatable/attack_self(mob/user)
	. = ..()
	if(torn)
		to_chat(user, span_warning("[src] is too badly damaged and won't work!"))
		return
	if(locate(structure_type) in get_turf(user))
		to_chat(user, span_warning("There's already a wall set up here!"))
		return
	playsound(loc, 'sound/items/zip/zip.ogg', 75, 1)
	to_chat(user, span_notice("You inflate [src]."))
	if(do_after(user, 1 SECONDS, src))
		new structure_type(get_turf(user))
		qdel(src)


/obj/item/inflatable/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/stack/medical/wrap/sticky_tape/duct))
		return ..()
	if(!torn)
		to_chat(user, span_notice("[src] doesn't need any repairs!"))
		return
	var/obj/item/stack/medical/wrap/sticky_tape/duct/attacking_tape = attacking_item
	if(attacking_tape.use(TAPE_REQUIRED_TO_FIX, check = TRUE))
		to_chat(user, span_danger("Not enough [attacking_tape]! You need at least [TAPE_REQUIRED_TO_FIX]!"))
		return
	if(!do_after(user, 2 SECONDS, src))
		return
	playsound(user, 'fenysha_events/sounds/effects/ducttape1.ogg', 50, 1)
	to_chat(user, span_notice("You patch up [src] with [attacking_tape]!"))
	attacking_tape.use(TAPE_REQUIRED_TO_FIX)
	torn = FALSE
	update_appearance()

/obj/item/inflatable/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][torn ? "_torn" : ""]"

/obj/item/inflatable/examine(mob/user)
	. = ..()
	if(torn)
		. += span_warning("The membrane is badly torn and cannot be used! The damage looks like it could be repaired with <b>duct tape</b>.")

/obj/item/inflatable/suicide_act(mob/living/user)
	visible_message(user, span_danger("[user] starts shoving [src] up their ass! It looks like they're about to pull the cord, oh no!"))
	playsound(user.loc, 'sound/machines/hiss.ogg', 75, 1)
	new structure_type(user.loc)
	user.gib()
	return BRUTELOSS

/obj/item/inflatable/door
	name = "inflatable door"
	desc = "A folded membrane that, when activated, quickly unfolds into a simple door."
	icon = 'fenysha_events/icons/unique/inflatable.dmi'
	icon_state = "folded_door"
	base_icon_state = "folded_door"
	structure_type = /obj/structure/inflatable/door

/obj/item/inflatable/door/torn
	torn = TRUE


/// Storage for the box of inflatable walls and doors
/datum/storage/inflatables_box
	max_slots = (BOX_DOOR_AMOUNT + BOX_WALL_AMOUNT)
	max_specific_storage = WEIGHT_CLASS_SMALL
	max_total_storage = (BOX_DOOR_AMOUNT + BOX_WALL_AMOUNT) * WEIGHT_CLASS_SMALL


/// A box full of inflatable walls and doors
/obj/item/storage/inflatable
	icon = 'fenysha_events/icons/unique/inflatable.dmi'
	name = "box of inflatable barriers"
	desc = "Contains inflatable walls and doors."
	icon_state = "inf"
	w_class = WEIGHT_CLASS_NORMAL
	storage_type = /datum/storage/inflatables_box

/obj/item/storage/inflatable/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(typesof(/obj/item/inflatable))

/obj/item/storage/inflatable/PopulateContents()
	for(var/i = 0, i < BOX_DOOR_AMOUNT, i++)
		new /obj/item/inflatable/door(src)
	for(var/i = 0, i < BOX_WALL_AMOUNT, i++)
		new /obj/item/inflatable(src)

#undef TAPE_REQUIRED_TO_FIX
#undef INFLATABLE_DOOR_OPENED
#undef INFLATABLE_DOOR_CLOSED
#undef BOX_DOOR_AMOUNT
#undef BOX_WALL_AMOUNT
