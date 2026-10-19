/obj/vehicle/ridden/wheelchair
	var/has_seatbelt = TRUE
	var/seatbelt_engaged = FALSE
	var/last_collision_time = 0
	var/collision_cooldown = 2 SECONDS
	var/last_stamina_damage_time = 0
	var/stamina_damage_cooldown = 1 SECONDS
	var/examine_more_info = "Left-click: Remove occupant | Right-click: Toggle seatbelt"

/obj/vehicle/ridden/wheelchair/examine(mob/user)
	. = ..()
	if(bell_attached)
		. += span_notice("There is \a [bell_attached] attached to the handle.")
	if(bomb_attached)
		. += span_warning("There are a pair of gas tanks attached to the frame.")
	if(has_seatbelt)
		. += span_notice(examine_more_info)
		if(seatbelt_engaged)
			. += span_notice("The seatbelt is currently engaged.")

/obj/vehicle/ridden/wheelchair/attack_hand(mob/living/user, list/modifiers)
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		return remove_mob(user)
	return ..()

/obj/vehicle/ridden/wheelchair/proc/remove_mob(mob/living/user)
	if(!has_buckled_mobs())
		to_chat(user, span_warning("The wheelchair is empty!"))
		return
	var/mob/living/removed = buckled_mobs[1]
	if(has_seatbelt && seatbelt_engaged)
		to_chat(user, span_warning("The seatbelt is engaged! Disengage it first."))
		return
	to_chat(user, span_notice("You start to help [removed] out of the wheelchair..."))
	if(do_after(user, 3 SECONDS, target = src))
		unbuckle_mob(removed)
		to_chat(user, span_notice("You help [removed] out of the wheelchair."))
		to_chat(removed, span_notice("[user] helps you out of the wheelchair."))
	else
		to_chat(user, span_warning("You were interrupted while helping [removed] out of the wheelchair."))

/obj/vehicle/ridden/wheelchair/proc/toggle_seatbelt(mob/living/user)
	if(!has_buckled_mobs())
		to_chat(user, span_warning("The wheelchair is empty!"))
		return
	var/action = seatbelt_engaged ? "disengage" : "engage"
	to_chat(user, span_notice("You start to [action] the seatbelt..."))
	if(do_after(user, 3 SECONDS, target = src))
		seatbelt_engaged = !seatbelt_engaged
		to_chat(user, span_notice("You [seatbelt_engaged ? "engage" : "disengage"] the seatbelt."))
		playsound(src, 'modular_zzplurt/sound/items/buckling_seatbelt.ogg', 50, TRUE)
		for(var/mob/living/passenger in buckled_mobs)
			to_chat(passenger, span_notice("[user] [seatbelt_engaged ? "engages" : "disengages"] your seatbelt."))
	else
		to_chat(user, span_warning("You were interrupted while trying to [action] the seatbelt."))

/obj/vehicle/ridden/wheelchair/unbuckle_mob(mob/living/buckled_mob, force = FALSE, can_fall = TRUE)
	if(has_seatbelt && seatbelt_engaged && !force)
		to_chat(buckled_mob, span_warning("You're secured by the seatbelt!"))
		return FALSE
	return ..()

/obj/vehicle/ridden/wheelchair/post_buckle_mob(mob/living/buckled_mob)
	. = ..()
	update_appearance()
	if(has_seatbelt)
		to_chat(buckled_mob, span_notice("This wheelchair has a seatbelt. You can toggle it with right-click when not in combat mode."))
		add_seatbelt_action(buckled_mob)

/obj/vehicle/ridden/wheelchair/post_unbuckle_mob(mob/living/unbuckled_mob)
	. = ..()
	update_appearance()
	remove_seatbelt_action(unbuckled_mob)
	seatbelt_engaged = FALSE

/obj/vehicle/ridden/wheelchair/relaymove(mob/living/user, direction)
	if(world.time < last_collision_time + collision_cooldown)
		to_chat(user, span_warning("The wheelchair is still recovering from the last collision!"))
		return FALSE
	return ..()

/obj/vehicle/ridden/wheelchair/Bump(atom/A)
	. = ..()
	if(world.time < last_stamina_damage_time + stamina_damage_cooldown)
		return
	last_stamina_damage_time = world.time
	for(var/mob/living/passenger in buckled_mobs)
		passenger.apply_damage(30, STAMINA)
		to_chat(passenger, span_warning("The collision jolts you, draining your stamina!"))
	if(has_seatbelt && seatbelt_engaged)
		last_collision_time = world.time
		for(var/mob/living/passenger in buckled_mobs)
			to_chat(passenger, span_warning("The seatbelt keeps you secure as the wheelchair collides with [A]!"))
		playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
	else
		handle_collision(A)
	if(ismob(A))
		var/mob/bumped = A
		handle_mob_bump(bumped)

/obj/vehicle/ridden/wheelchair/proc/handle_mob_bump(mob/living/bumped)
	if(!istype(bumped))
		return
	var/damage = rand(3, 7)
	bumped.apply_damage(damage, BRUTE)
	bumped.Knockdown(0.5 SECONDS)
	to_chat(bumped, span_danger("You're hit by [src] and knocked down!"))
	if(has_buckled_mobs())
		var/mob/living/driver = buckled_mobs[1]
		to_chat(driver, span_warning("You hit [bumped] with your wheelchair!"))

/obj/vehicle/ridden/wheelchair/proc/handle_collision(atom/A)
	for(var/mob/living/passenger in buckled_mobs)
		if(!passenger.buckled)
			continue
		passenger.apply_damage(30, STAMINA)
		unbuckle_mob(passenger)
		var/damage = rand(5, 15)
		passenger.apply_damage(damage, BRUTE)
		var/throw_dir = get_dir(src, A)
		var/turf/throw_turf = get_step(src, throw_dir)
		passenger.throw_at(throw_turf, 2, 2)
		to_chat(passenger, span_danger("You're thrown from the wheelchair as it collides with [A]!"))
	playsound(src, 'sound/effects/bang.ogg', 50, TRUE)

/obj/vehicle/ridden/wheelchair/proc/add_seatbelt_action(mob/living/user)
	var/datum/action/seatbelt_toggle/seatbelt_action = new(src)
	seatbelt_action.Grant(user)

/obj/vehicle/ridden/wheelchair/proc/remove_seatbelt_action(mob/living/user)
	for(var/datum/action/action in user.actions)
		if(istype(action, /datum/action/seatbelt_toggle))
			action.Remove(user)

/datum/action/seatbelt_toggle
	name = "Toggle Seatbelt"
	desc = "Toggle the seatbelt keeping you secured to the wheelchair."
	button_icon = 'icons/mob/actions/actions_vehicle.dmi'
	button_icon_state = "seatbelt"

/datum/action/seatbelt_toggle/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	if(istype(owner, /mob/living))
		var/mob/living/rider = owner
		if(istype(rider.buckled, /obj/vehicle/ridden/wheelchair))
			var/obj/vehicle/ridden/wheelchair/chair = rider.buckled
			chair.toggle_seatbelt(rider)

/mob/living/examine(mob/user)
	. = ..()
	if(buckled && istype(buckled, /obj/vehicle/ridden/wheelchair))
		var/obj/vehicle/ridden/wheelchair/chair = buckled
		if(chair.has_seatbelt && chair.seatbelt_engaged)
			. += span_notice("[p_they(TRUE)] [p_are()] currently buckled to the seat!")

/obj/vehicle/ridden/wheelchair/attack_hand_secondary(mob/user, list/modifiers)
	if(has_seatbelt)
		toggle_seatbelt(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return ..()

