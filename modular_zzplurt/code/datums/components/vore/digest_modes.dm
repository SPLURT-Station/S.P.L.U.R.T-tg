/mob/living/proc/vore_can_drain()
	if(client)
		var/datum/vore_preferences/vore_prefs = client.get_vore_prefs()
		return vore_prefs?.read_preference(/datum/vore_pref/toggle/drain)

	return vore_can_negatively_affect()

/datum/digest_mode/drain
	name = DIGEST_MODE_DRAIN
	gurgle_noises = TRUE

/datum/digest_mode/drain/handle_belly(obj/vore_belly/vore_belly, seconds_per_tick)
	// Gurgle fix: call the base proc so gurgle_noises actually plays
	..()
	var/mob/living/living_parent = vore_belly.owner.parent

	for(var/mob/living/L in vore_belly)
		// Respect drain preferences - separate from digestion
		if(!L.vore_can_drain())
			continue
		// Don't drain from dead prey
		if(L.stat == DEAD)
			continue

		// Only drain if prey has nutrition to give
		if(L.nutrition > ABSORB_NUTRITION_BARRIER)
			// Drain nutrition without dealing damage
			var/nutrition_drain = NUTRITION_PER_DAMAGE * 2 * seconds_per_tick
			L.adjust_nutrition(-nutrition_drain)
			living_parent.adjust_nutrition(nutrition_drain)

			// Send messages periodically (every 10 seconds)
			if(!vore_belly.message_timers[REF(L)] || vore_belly.message_timers[REF(L)] <= world.time)
				to_chat(living_parent, span_notice(vore_belly.get_drain_messages_owner(L)))
				to_chat(L, span_notice(vore_belly.get_drain_messages_prey(L)))
				vore_belly.message_timers[REF(L)] = world.time + 10 SECONDS

/datum/digest_mode/heal
	name = DIGEST_MODE_HEAL
	gurgle_noises = TRUE // Heal mode plays soothing gurgle sounds (matches VOREStation/CHOMPStation)

/datum/digest_mode/heal/handle_belly(obj/vore_belly/vore_belly, seconds_per_tick)
	// Gurgle fix: call the base proc so gurgle_noises actually plays
	..()
	var/mob/living/living_parent = vore_belly.owner.parent

	for(var/mob/living/L in vore_belly)
		// Don't heal dead prey
		if(L.stat == DEAD)
			continue

		// Cache damage values to avoid multiple function calls
		var/brute = L.get_brute_loss()
		var/burn = L.get_fire_loss()
		var/has_damage = (brute > 0 || burn > 0)

		// Only heal if pred has nutrition to spare and prey has damage
		if(living_parent.nutrition > ABSORB_NUTRITION_BARRIER && has_damage)
			// Calculate healing amount (scales with pred's nutrition)
			var/heal_amount = 0.5 * seconds_per_tick
			var/actual_healing = 0

			// Heal brute damage
			if(brute > 0)
				L.adjust_brute_loss(-heal_amount)
				actual_healing += heal_amount

			// Heal burn damage
			if(burn > 0)
				L.adjust_fire_loss(-heal_amount)
				actual_healing += heal_amount

			// Cost nutrition from pred based on actual healing done
			living_parent.adjust_nutrition(-NUTRITION_PER_DAMAGE * actual_healing)

			// Send messages periodically (every 10 seconds)
			if(!vore_belly.message_timers[REF(L)] || vore_belly.message_timers[REF(L)] <= world.time)
				to_chat(living_parent, span_notice(vore_belly.get_heal_messages_owner(L)))
				to_chat(L, span_notice(vore_belly.get_heal_messages_prey(L)))
				vore_belly.message_timers[REF(L)] = world.time + 10 SECONDS

// CHOMPStation2 Shrink/Grow digest modes (issue #31, part 2)
// Ports https://github.com/CHOMPStation2/CHOMPStation2 bellymodes_datum_vr.dm

/mob/living/proc/vore_can_shrink()
	if(client)
		var/datum/vore_preferences/vore_prefs = client.get_vore_prefs()
		return vore_prefs?.read_preference(/datum/vore_pref/toggle/shrink)

	return vore_can_negatively_affect()

/// Shrinks prey towards the belly's target size while draining them, like CHOMPStation's shrink mode
/datum/digest_mode/shrink
	name = DIGEST_MODE_SHRINK
	gurgle_noises = TRUE

/datum/digest_mode/shrink/handle_belly(obj/vore_belly/vore_belly, seconds_per_tick)
	var/mob/living/living_parent = vore_belly.owner.parent

	for(var/mob/living/L in vore_belly)
		// Respect shrink preferences - separate from digestion
		if(!L.vore_can_shrink())
			continue
		// Can't reshape the dead
		if(L.stat == DEAD)
			continue

		var/current_size = get_size(L)
		// Only shrink prey that are bigger than the belly's target size
		if(current_size > vore_belly.shrink_grow_size)
			var/new_size = max(vore_belly.shrink_grow_size, current_size - (VORE_RESIZE_RATE_PER_SECOND * seconds_per_tick))
			if(L.update_size(new_size))
				// Send messages periodically (every 10 seconds)
				if(!vore_belly.message_timers[REF(L)] || vore_belly.message_timers[REF(L)] <= world.time)
					to_chat(living_parent, span_notice(vore_belly.get_shrink_messages_owner(L)))
					to_chat(L, span_notice(vore_belly.get_shrink_messages_prey(L)))
					vore_belly.message_timers[REF(L)] = world.time + 10 SECONDS
				if(new_size <= vore_belly.shrink_grow_size)
					// Feedback so the pred knows their prey has stopped shrinking
					to_chat(living_parent, span_notice("You feel [L] get as small as you would like within your [LOWER_TEXT(vore_belly.name)]."))

	// Shrink is a drain mode at heart, so it also saps nutrition (matches CHOMPStation)
	return ..()

/mob/living/proc/vore_can_grow()
	if(client)
		var/datum/vore_preferences/vore_prefs = client.get_vore_prefs()
		return vore_prefs?.read_preference(/datum/vore_pref/toggle/grow)

	return vore_can_negatively_affect()

/// Grows prey towards the belly's target size, like CHOMPStation's grow mode
/datum/digest_mode/grow
	name = DIGEST_MODE_GROW
	gurgle_noises = TRUE

/datum/digest_mode/grow/handle_belly(obj/vore_belly/vore_belly, seconds_per_tick)
	var/mob/living/living_parent = vore_belly.owner.parent

	for(var/mob/living/L in vore_belly)
		// Respect grow preferences - separate from digestion
		if(!L.vore_can_grow())
			continue
		// Can't reshape the dead
		if(L.stat == DEAD)
			continue

		var/current_size = get_size(L)
		// Only grow prey that are smaller than the belly's target size
		if(current_size < vore_belly.shrink_grow_size)
			var/new_size = min(vore_belly.shrink_grow_size, current_size + (VORE_RESIZE_RATE_PER_SECOND * seconds_per_tick))
			if(L.update_size(new_size))
				// Send messages periodically (every 10 seconds)
				if(!vore_belly.message_timers[REF(L)] || vore_belly.message_timers[REF(L)] <= world.time)
					to_chat(living_parent, span_notice(vore_belly.get_grow_messages_owner(L)))
					to_chat(L, span_notice(vore_belly.get_grow_messages_prey(L)))
					vore_belly.message_timers[REF(L)] = world.time + 10 SECONDS
				if(new_size >= vore_belly.shrink_grow_size)
					// Feedback so the pred knows their prey has stopped growing
					to_chat(living_parent, span_notice("You feel [L] get as big as you would like within your [LOWER_TEXT(vore_belly.name)]."))
