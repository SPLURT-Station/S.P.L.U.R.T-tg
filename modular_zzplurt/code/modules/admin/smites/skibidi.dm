/datum/smite/skibidi
	name = "Toiletification"

/datum/smite/skibidi/effect(client/user, mob/living/target)
	. = ..()
	if(!iscarbon(target))
		to_chat(user, span_warning("This must be used on a carbon mob."), confidential = TRUE)
		return
	playsound(target, 'sound/machines/toilet_flush.ogg', 80, TRUE)
	target.visible_message("[target] is suddenly transformed into a toilet!")
	new /obj/structure/toilet/skibidi(target.loc, target)

/obj/structure/toilet/skibidi
	name = "skibidi toilet"
	desc = "Everybody wants to rule the world."
	max_integrity = 300
	integrity_failure = 0.5

	/// Human who got entrapped by the evil toilet
	var/mob/living/carbon/human/trapped

	/// In case we don't get a human on init, we set up a toilet trap to trap whoever enters the tile
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered)
	)

	/// Delay between movements
	var/move_delay = 0.3 SECONDS
	/// when can we move again?
	var/can_move

/obj/structure/toilet/skibidi/Initialize(mapload, mob/living/carbon/human/toilet_man)
	. = ..()
	cover_open = TRUE
	if(toilet_man)
		register_skibidi(toilet_man)
	else
		AddElement(/datum/element/connect_loc, loc_connections)
		update_appearance(UPDATE_ICON)

/obj/structure/toilet/skibidi/Destroy(force)
	if(trapped)
		unregister_skibidi(trapped)
	return ..()

/obj/structure/toilet/skibidi/examine(mob/user)
	. = ..()
	if(trapped)
		. += span_warning("[trapped] [trapped.p_are()] trapped inside.")

/obj/structure/toilet/skibidi/examine_more(mob/user)
	. = ..()
	if(!trapped)
		return
	. += trapped.examine(user)

/obj/structure/toilet/skibidi/update_overlays()
	. = ..()
	if(!trapped || !cover_open)
		return

	var/obj/item/bodypart/head/head = trapped.get_bodypart(BODY_ZONE_HEAD)
	if(!head)
		return

	var/list/head_overlays = head.get_limb_icon(dropped = FALSE)
	var/mutable_appearance/i_am_an_appearance_trust_me
	switch(dir)
		if(SOUTH)
			for(var/datum/layer in head_overlays)
				i_am_an_appearance_trust_me = layer
				i_am_an_appearance_trust_me.pixel_y -= 8
				i_am_an_appearance_trust_me.pixel_x += 1
		if(NORTH)
			for(var/datum/layer in head_overlays)
				i_am_an_appearance_trust_me = layer
				i_am_an_appearance_trust_me.pixel_y -= 2
				i_am_an_appearance_trust_me.pixel_x += 1
		if(WEST)
			for(var/datum/layer in head_overlays)
				i_am_an_appearance_trust_me = layer
				i_am_an_appearance_trust_me.pixel_y -= 9
				i_am_an_appearance_trust_me.pixel_x += 1
		if(EAST)
			for(var/datum/layer in head_overlays)
				i_am_an_appearance_trust_me = layer
				i_am_an_appearance_trust_me.pixel_y -= 9
				i_am_an_appearance_trust_me.pixel_x -= 1
	. += head_overlays

/obj/structure/toilet/skibidi/setDir(newdir)
	var/old_dir = dir
	. = ..()
	if(dir != old_dir)
		update_appearance(UPDATE_ICON)

/obj/structure/toilet/skibidi/relaymove(mob/living/user, direction)
	if(!direction || !cover_open || (can_move >= world.time))
		return

	// MOVE US
	if(isturf(loc))
		can_move = world.time + move_delay
		try_step_multiz(direction)

/obj/structure/toilet/skibidi/atom_break(damage_flag)
	if(trapped)
		trapped.forceMove(loc)
	return ..()

/obj/structure/toilet/skibidi/proc/on_entered(datum/source, atom/movable/entered)
	SIGNAL_HANDLER

	if(!cover_open || !ishuman(entered))
		return

	playsound(src, 'sound/machines/toilet_flush.ogg', 80, TRUE)
	audible_message("[src] flushes [entered] down [p_themselves()]!")
	register_skibidi(entered)

/obj/structure/toilet/skibidi/proc/register_skibidi(mob/living/carbon/human/trapped)
	trapped.forceMove(src)
	src.trapped = trapped
	RemoveElement(/datum/element/connect_loc, loc_connections)
	RegisterSignal(trapped, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(trapped, COMSIG_MOVABLE_MOVED, PROC_REF(on_trapped_moved))
	name = "[trapped] toilet"
	update_appearance(UPDATE_ICON)

/obj/structure/toilet/skibidi/proc/unregister_skibidi(mob/living/carbon/human/trapped)
	src.trapped = null
	UnregisterSignal(trapped, COMSIG_MOB_SAY)
	UnregisterSignal(trapped, COMSIG_MOVABLE_MOVED)
	if(trapped.loc == src)
		trapped.forceMove(src.loc)
	if(!QDELING(src) && (get_integrity_percentage() > 0.5))
		AddElement(/datum/element/connect_loc, loc_connections)
	name = initial(name)

/obj/structure/toilet/skibidi/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	if(!cover_open)
		speech_args[SPEECH_MESSAGE] = ""
		playsound(src, 'sound/machines/toilet_flush.ogg', 20, TRUE)
	else
		playsound(src, 'sound/machines/toilet_flush.ogg', 40, TRUE)

	var/message = speech_args[SPEECH_MESSAGE]
	if(!length(message) || message[1] == "*")
		return

	speech_args[SPEECH_SPANS] |= SPAN_SANS
	if(prob(50))
		message = pick(\
			"Dob dob!",\
			"Yes yes!",\
			"Skibidi!",\
			"Skibidi dob dob!",\
			"Skibidi dob dob yes yes!",\
			"Yip yip!",\
			"Skibidi dob, yip yip!",\
			"My style is ridiculo[repeat_string(rand(0,5), "culo")]us!"\
		)
	else
		if(prob(50))
			message += " DOB DOB!"
		if(prob(50))
			message += " YES YES!"

	speech_args[SPEECH_MESSAGE] = message

/obj/structure/toilet/skibidi/proc/on_trapped_moved(atom/source)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/goodbye = trapped
	unregister_skibidi(goodbye)

	var/obj/item/bodypart/head/skibidi_head = goodbye.get_bodypart(BODY_ZONE_HEAD)
	if(skibidi_head)
		skibidi_head.drop_limb(special = FALSE, dismembered = FALSE)
		skibidi_head.forceMove(loc)

	goodbye.gib(DROP_ALL_REMAINS)

	update_appearance(UPDATE_ICON)
