/obj/vehicle/ridden/wheelchair
	var/has_seatbelt = FALSE
	var/seatbelt_engaged = FALSE
	var/last_collision_time = 0
	var/collision_cooldown = 2 SECONDS

	// Add this new variable for the examine text
	var/examine_more_info = "Left-click: Remove occupant | Right-click: Toggle seatbelt"

// Modify the examine() function for the wheelchair
/obj/vehicle/ridden/wheelchair/examine(mob/user)
	. = ..()	// Call the parent examine() function
	if(has_seatbelt)
		. += span_notice(examine_more_info)

// Handle left-click interactions
/obj/vehicle/ridden/wheelchair/attack_hand(mob/living/user, list/modifiers)
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		return remove_mob(user)
	return ..()

// Remove a mob from the wheelchair
/obj/vehicle/ridden/wheelchair/proc/remove_mob(mob/living/user)
	if(!buckled_mobs.len)
		to_chat(user, span_warning("The wheelchair is empty!"))
		return

	var/mob/living/M = buckled_mobs[1]	// Assume the first buckled mob
	if(has_seatbelt && seatbelt_engaged)
		to_chat(user, span_warning("The seatbelt is engaged! Disengage it first."))
		return

	to_chat(user, span_notice("You start to help [M] out of the wheelchair..."))
	if(do_after(user, 3 SECONDS, target = src))
		unbuckle_mob(M)
		to_chat(user, span_notice("You help [M] out of the wheelchair."))
		to_chat(M, span_notice("[user] helps you out of the wheelchair."))
	else
		to_chat(user, span_warning("You were interrupted while helping [M] out of the wheelchair."))

// Toggle the seatbelt
/obj/vehicle/ridden/wheelchair/proc/toggle_seatbelt(mob/living/user)
	if(!buckled_mobs.len)
		to_chat(user, span_warning("The wheelchair is empty!"))
		return

	var/action = seatbelt_engaged ? "disengage" : "engage"
	to_chat(user, span_notice("You start to [action] the seatbelt..."))
	if(do_after(user, 3 SECONDS, target = src))
		seatbelt_engaged = !seatbelt_engaged
		to_chat(user, span_notice("You [seatbelt_engaged ? "engage" : "disengage"] the seatbelt."))
		playsound(src, 'modular_zzplurt/sound/items/buckling_seatbelt.ogg', 50, TRUE)
		for(var/mob/living/M in buckled_mobs)
			to_chat(M, span_notice("[user] [seatbelt_engaged ? "engages" : "disengages"] your seatbelt."))
	else
		to_chat(user, span_warning("You were interrupted while trying to [action] the seatbelt."))

// Override unbuckle_mob to prevent unbuckling when seatbelt is engaged
/obj/vehicle/ridden/wheelchair/unbuckle_mob(mob/living/buckled_mob, force = FALSE, can_fall = TRUE)
	if(has_seatbelt && seatbelt_engaged && !force)
		to_chat(buckled_mob, span_warning("You're secured by the seatbelt!"))
		return FALSE
	return ..()

// Inform the user about the seatbelt when they're buckled
/obj/vehicle/ridden/wheelchair/post_buckle_mob(mob/living/user)
	. = ..()
	if(has_seatbelt)
		to_chat(user, span_notice("This wheelchair has a seatbelt. You can toggle it with right-click when not in combat mode."))

// Handle movement and collision cooldown
/obj/vehicle/ridden/wheelchair/relaymove(mob/living/user, direction)
	if(world.time < last_collision_time + collision_cooldown)
		to_chat(user, span_warning("The wheelchair is still recovering from the last collision!"))
		return FALSE
	return ..()

// Handle collisions
/obj/vehicle/ridden/wheelchair/Bump(atom/A)
	. = ..()	// Call the parent Bump() function first

	if(has_seatbelt && seatbelt_engaged)
		last_collision_time = world.time
		for(var/mob/living/M in buckled_mobs)
			to_chat(M, span_warning("The seatbelt keeps you secure as the wheelchair collides with [A]!"))
		playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
	else
		handle_collision(A)

	// Handle collision with other mobs
	if(ismob(A))
		var/mob/M = A
		handle_mob_bump(M)

// Handle collisions with mobs
/obj/vehicle/ridden/wheelchair/proc/handle_mob_bump(mob/living/L)
	if(!istype(L))
		return

	// Apply damage to the hit mob
	var/damage = rand(3, 7)	// Adjust these values as needed
	L.apply_damage(damage, BRUTE)

	// Knock down the hit mob for 0.5 seconds
	L.Knockdown(0.5 SECONDS)

	// Notify the hit mob
	to_chat(L, span_danger("You're hit by [src] and knocked down!"))

	// Notify the wheelchair user
	if(buckled_mobs.len)
		var/mob/living/user = buckled_mobs[1]
		to_chat(user, span_warning("You hit [L] with your wheelchair!"))

// Handle collisions with objects
/obj/vehicle/ridden/wheelchair/proc/handle_collision(atom/A)
	for(var/mob/living/passenger in buckled_mobs)
		if(!passenger.buckled)	// Check if the passenger is still buckled
			continue

		// Eject the passenger
		unbuckle_mob(passenger)

		// Calculate damage (you may need to adjust these values)
		var/damage = rand(5, 15)

		// Apply damage to the passenger
		passenger.apply_damage(damage, BRUTE)

		// Throw the passenger
		var/throw_dir = get_dir(src, A)
		var/turf/T = get_step(src, throw_dir)
		passenger.throw_at(T, 2, 2)

		// Notify the passenger
		to_chat(passenger, span_danger("You're thrown from the wheelchair as it collides with [A]!"))

	// Play a sound effect for the collision
	playsound(src, 'sound/effects/bang.ogg', 50, TRUE)

// Add seatbelt to existing wheelchairs
/obj/vehicle/ridden/wheelchair/Initialize()
	. = ..()
	has_seatbelt = TRUE

// Add seatbelt toggle action to the user
/obj/vehicle/ridden/wheelchair/proc/add_seatbelt_action(mob/living/user)
	var/datum/action/seatbelt_toggle/SB = new(src)
	SB.Grant(user)

// Remove seatbelt toggle action from the user
/obj/vehicle/ridden/wheelchair/proc/remove_seatbelt_action(mob/living/user)
	for(var/datum/action/A in user.actions)
		if(istype(A, /datum/action/seatbelt_toggle))
			A.Remove(user)

// Seatbelt toggle action
/datum/action/seatbelt_toggle
	name = "Toggle Seatbelt"
	button_icon = 'icons/mob/actions/actions_vehicle.dmi'
	button_icon_state = "seatbelt"

/datum/action/seatbelt_toggle/Trigger(trigger_flags)
	if(istype(owner, /mob/living))
		var/mob/living/L = owner
		if(istype(L.buckled, /obj/vehicle/ridden/wheelchair))
			var/obj/vehicle/ridden/wheelchair/W = L.buckled
			W.toggle_seatbelt(L)

// Add seatbelt information to mob examine
/mob/living/examine(mob/user)
	. = ..()
	if(buckled && istype(buckled, /obj/vehicle/ridden/wheelchair))
		var/obj/vehicle/ridden/wheelchair/W = buckled
		if(W.has_seatbelt && W.seatbelt_engaged)
			. += span_notice("[p_they(TRUE)] [p_are()] currently buckled to the seat!")

// Handle right-click interactions
/obj/vehicle/ridden/wheelchair/attack_hand_secondary(mob/user, list/modifiers)
	if(has_seatbelt)
		toggle_seatbelt(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return ..()
