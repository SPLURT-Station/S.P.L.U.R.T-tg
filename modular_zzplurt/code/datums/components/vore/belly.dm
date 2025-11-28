/obj/vore_belly
	var/list/message_timers = list() // Per-prey message cooldowns for digest modes

	// Auto-transfer settings
	var/autotransfer_enabled = FALSE
	var/obj/vore_belly/autotransfer_target = null
	var/autotransfer_delay = 60 SECONDS // How long before transfer
	var/autotransfer_timer = 0 // Current timer for each prey

/obj/vore_belly/process(seconds_per_tick)
	. = ..()
	handle_autotransfer(seconds_per_tick)

/obj/vore_belly/ui_data(mob/user)
	. = ..()

	// Auto-transfer settings
	.["autotransfer_enabled"] = autotransfer_enabled
	.["autotransfer_target"] = autotransfer_target ? REF(autotransfer_target) : null
	.["autotransfer_target_name"] = autotransfer_target ? autotransfer_target.name : null
	.["autotransfer_delay"] = autotransfer_delay / 10 // Convert to seconds for display

	.["messages"] += list(
		"drain_messages_owner" = drain_messages_owner || GLOB.drain_messages_owner,
		"drain_messages_prey" = drain_messages_prey || GLOB.drain_messages_prey,
		"heal_messages_owner" = heal_messages_owner || GLOB.heal_messages_owner,
		"heal_messages_prey" = heal_messages_prey || GLOB.heal_messages_prey,
	)

/obj/vore_belly/ui_modify_var(var_name, value)
	. = ..()
	switch(var_name)
		// Auto-transfer settings
		if("autotransfer_enabled")
			autotransfer_enabled = !autotransfer_enabled
			if(!autotransfer_enabled)
				autotransfer_timer = 0
		if("autotransfer_target")
			var/list/belly_choices = list()
			for(var/obj/vore_belly/belly as anything in owner.vore_bellies)
				if(belly != src) // Don't allow transferring to self
					belly_choices[belly.name] = belly
			if(LAZYLEN(belly_choices))
				var/choice = tgui_input_list(usr, "Select target belly for auto-transfer", "Auto-Transfer Target", belly_choices)
				if(choice)
					autotransfer_target = belly_choices[choice]
			else
				to_chat(usr, span_warning("You need at least one other belly to set as a transfer target!"))
		if("autotransfer_delay")
			var/new_delay = tgui_input_number(usr, "Transfer delay in seconds", "Auto-Transfer Delay", autotransfer_delay / 10, 300, 5)
			if(new_delay)
				autotransfer_delay = new_delay * 10 // Convert to deciseconds
				autotransfer_timer = 0 // Reset timer

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
