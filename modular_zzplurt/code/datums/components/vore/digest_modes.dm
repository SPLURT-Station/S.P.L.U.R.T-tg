/mob/living/proc/vore_can_drain()
	if(client)
		var/datum/vore_preferences/vore_prefs = client.get_vore_prefs()
		return vore_prefs?.read_preference(/datum/vore_pref/toggle/drain)

	return vore_can_negatively_affect()

/datum/digest_mode/drain
	name = DIGEST_MODE_DRAIN
	gurgle_noises = TRUE

/datum/digest_mode/drain/handle_belly(obj/vore_belly/vore_belly, seconds_per_tick)
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
	var/mob/living/living_parent = vore_belly.owner.parent

	for(var/mob/living/L in vore_belly)
		// Don't heal dead prey
		if(L.stat == DEAD)
			continue

		// Cache damage values to avoid multiple function calls
		var/brute = L.getBruteLoss()
		var/burn = L.getFireLoss()
		var/has_damage = (brute > 0 || burn > 0)

		// Only heal if pred has nutrition to spare and prey has damage
		if(living_parent.nutrition > ABSORB_NUTRITION_BARRIER && has_damage)
			// Calculate healing amount (scales with pred's nutrition)
			var/heal_amount = 0.5 * seconds_per_tick
			var/actual_healing = 0

			// Heal brute damage
			if(brute > 0)
				L.adjustBruteLoss(-heal_amount)
				actual_healing += heal_amount

			// Heal burn damage
			if(burn > 0)
				L.adjustFireLoss(-heal_amount)
				actual_healing += heal_amount

			// Cost nutrition from pred based on actual healing done
			living_parent.adjust_nutrition(-NUTRITION_PER_DAMAGE * actual_healing)

			// Send messages periodically (every 10 seconds)
			if(!vore_belly.message_timers[REF(L)] || vore_belly.message_timers[REF(L)] <= world.time)
				to_chat(living_parent, span_notice(vore_belly.get_heal_messages_owner(L)))
				to_chat(L, span_notice(vore_belly.get_heal_messages_prey(L)))
				vore_belly.message_timers[REF(L)] = world.time + 10 SECONDS
