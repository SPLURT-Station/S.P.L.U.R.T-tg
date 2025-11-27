// Auto-transfer feature for bellies
// Separated from core belly.dm for modularity

/// Handle automatic transfer of prey between bellies
/// Note: Transfers prey one at a time to prevent spam and allow gradual movement
/// Timer is belly-wide, not per-prey, meaning all prey transfer on the same schedule
/obj/vore_belly/proc/handle_autotransfer(seconds_per_tick)
	if(!autotransfer_enabled || !autotransfer_target)
		return

	// Make sure target belly still exists and is ours
	if(!istype(autotransfer_target) || autotransfer_target.owner != owner)
		autotransfer_enabled = FALSE
		autotransfer_target = null
		return

	// Don't transfer to ourselves
	if(autotransfer_target == src)
		return

	// Increment timer
	autotransfer_timer += seconds_per_tick

	// Check if it's time to transfer
	if(autotransfer_timer >= autotransfer_delay)
		autotransfer_timer = 0

		// Transfer first prey in belly (one at a time to prevent spam)
		if(LAZYLEN(contents) > 0)
			var/atom/movable/prey = contents[1]

			// Don't transfer absorbed prey
			if(ismob(prey))
				var/mob/living/L = prey
				if(HAS_TRAIT_FROM(L, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
					return // Skip this transfer cycle if first prey is absorbed

			// Do the transfer
			var/mob/living/living_parent = owner.parent
			prey.forceMove(autotransfer_target)

			// Messages
			if(ismob(prey))
				to_chat(living_parent, span_notice("You feel [prey] slide from your [name] into your [autotransfer_target.name]."))
				to_chat(prey, span_notice("You slide from [living_parent]'s [name] into their [autotransfer_target.name]!"))

			// Play transfer sound
			if(fancy_sounds && release_sound)
				owner.play_vore_sound(release_sound, "vore_sounds_release_fancy", VORE_SOUND_VOLUME)
			if(autotransfer_target.fancy_sounds && autotransfer_target.insert_sound)
				autotransfer_target.owner.play_vore_sound(autotransfer_target.insert_sound, "vore_sounds_insert_fancy", VORE_SOUND_VOLUME)

			// Show fullscreen for new belly
			if(ismob(prey))
				var/mob/M = prey
				M.clear_fullscreen("vore", FALSE)
				autotransfer_target.show_fullscreen(M)
