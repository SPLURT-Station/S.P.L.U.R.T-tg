/mob/living
	var/size_multiplier = RESIZE_NORMAL
	var/mob_size_base_health

/// Returns false on failure
/mob/living/proc/update_size(new_size, cur_size)
	if(!new_size)
		return FALSE
	if(!cur_size)
		cur_size = get_size(src)
	if(new_size == cur_size)
		return FALSE

	if(ishuman(src))
		var/mob/living/carbon/human/human_owner = src
		if(human_owner.dna?.species?.body_size_restricted)
			return FALSE
		remove_movespeed_modifier(/datum/movespeed_modifier/small_stride)
		update_transform(new_size / cur_size)

		if(get_size(src) >= (RESIZE_A_BIGNORMAL + RESIZE_NORMAL) / 2)
			small_sprite.Grant(src)
		else
			small_sprite.Remove(src)

		var/new_slowdown = (abs(get_size(src) - 1) * CONFIG_GET(number/body_size_slowdown_multiplier))
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/small_stride, TRUE, new_slowdown)
	else
		size_multiplier = new_size
		update_transform(new_size / cur_size)

	adjust_mobsize(new_size)
	SEND_SIGNAL(src, COMSIG_MOB_RESIZED, new_size, cur_size)
	return TRUE

/// Resets visual transform and reapplies current_size cleanly (for temporary visual overrides).
/mob/living/proc/refresh_size_transform()
	var/desired_size = get_size(src)
	current_size = RESIZE_DEFAULT_SIZE
	body_maptext_height_offset = 0
	maptext_height = initial(maptext_height)
	transform = matrix()
	if(desired_size != RESIZE_DEFAULT_SIZE)
		update_transform(desired_size)

/mob/living/proc/adjust_mobsize(size)
	switch(size)
		if(0 to 0.49)
			mob_size = MOB_SIZE_TINY
		if(0.5 to 0.79)
			mob_size = MOB_SIZE_SMALL
		if(0.8 to 1.2)
			mob_size = MOB_SIZE_HUMAN
		if(1.21 to INFINITY)
			mob_size = MOB_SIZE_LARGE

	// Add health and speed penalty based on mob_size category
	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		// Store base health before size modifiers
		if(!H.mob_size_base_health)
			// Calculate base health without tough quirk if present
			var/current_max = H.maxHealth
			if(HAS_TRAIT(H, TRAIT_TOUGH))
				H.mob_size_base_health = current_max * 0.909
			else
				H.mob_size_base_health = current_max

		var/base_health = H.mob_size_base_health

		// Remove existing modifiers first
		H.remove_movespeed_modifier(/datum/movespeed_modifier/small_size)
		H.remove_movespeed_modifier(/datum/movespeed_modifier/tiny_size)

		// Apply penalties based on size category
		switch(mob_size)
			if(MOB_SIZE_TINY)
				H.maxHealth = max(1, base_health - 60) // 60 less at 0.49 and below
				H.health = min(H.health, H.maxHealth)
				H.add_movespeed_modifier(/datum/movespeed_modifier/tiny_size)
			if(MOB_SIZE_SMALL)
				H.maxHealth = max(1, base_health - 35) // 35 less at 0.5 to 0.79
				H.health = min(H.health, H.maxHealth)
				H.add_movespeed_modifier(/datum/movespeed_modifier/small_size)
			else
				H.maxHealth = base_health
				H.health = min(H.health, H.maxHealth)

		// The above overrides quirks because ???, hatred. but this fixes it.
		if(HAS_TRAIT(H, TRAIT_TOUGH))
			H.maxHealth *= 1.1
			H.health = H.maxHealth

/datum/movespeed_modifier/small_size
	multiplicative_slowdown = 0.25

/datum/movespeed_modifier/tiny_size
	multiplicative_slowdown = 0.5

/mob/living/fully_heal(heal_flags)
	set_thirst(THIRST_LEVEL_QUENCHED + 50)
	. = ..()


/mob/living/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, current_size))
			update_size(var_value)
			. = TRUE
		if(NAMEOF(src, size_multiplier))
			update_size(var_value)
			. = TRUE

	if(!isnull(.))
		datum_flags |= DF_VAR_EDITED
		return

	return ..()

GAME_VERB_DESC(/mob/living, switch_scaling, "Switch scaling mode", "Switch sharp/fuzzy scaling for current mob.", "IC")
	fuzzy = !fuzzy
	regenerate_icons()

/**
 * Proc for getting a mob's arousal status as examine message.
 * Checks hormone producing genitals and ERP pref to generate message.
 *
 * This is under /mob/living to allow easier access by status effects.
 */
/mob/living/proc/get_arousal_text()
	// Define temporary list of hormone phrases
	var/list/hormone_types = list()

	// Define default position preference
	var/pos_pref = "to satisfy [p_their()] needs."

	// Check for male hormonal organ
	if(get_organ_slot(ORGAN_SLOT_TESTICLES))
		hormone_types += "in rut"

	// Check for female hormonal organ
	if(get_organ_slot(ORGAN_SLOT_WOMB))
		hormone_types += "in estrous"

	// Check for synthetic
	if(mob_biotypes & MOB_ROBOTIC)
		hormone_types += "simulating hormones"

	// Check if client exists
	if(!client)
		return

	// Check if prefs exist
	if(!client.prefs)
		return

	// Check ERP preference
	var/erp_status_pref = client?.prefs?.read_preference(/datum/preference/choiced/erp_status)

	// Set message based on selection
	switch(erp_status_pref)
		// Disabled
		if("No")
			pos_pref = "to handle it by [p_themselves()]."

		// Dominant
		if("Top - Dom", "Verse-Top - Dom", "Verse - Dom", "Verse-Bottom - Dom", "Bottom - Dom")
			pos_pref = "to take charge of someone."

		// Switch
		if("Top - Switch", "Verse-Top - Switch", "Verse-Bottom - Switch", "Bottom - Switch")
			pos_pref = "to be intimate with someone."

		// Submissive
		if("Top - Sub", "Verse-Top - Sub", "Verse - Sub", "Verse-Bottom - Sub", "Bottom - Sub")
			pos_pref = "someone to take charge of [p_them()]."

		// Indecisive
		if("Verse - Switch")
			pos_pref = "something from someone?"

		// LOOC
		if("Ask (L)OOC")
			pos_pref = "something that needs clarification."

		// OOC
		if("Check OOC Notes")
			pos_pref = "something specific."

	// Build English list
	var/examine_text = span_purple("[p_Theyre()] currently "\
	+ english_list(hormone_types, nothing_text = "experiencing high hormonal levels")\
	+ " and wants " + pos_pref)

	// Return text
	return examine_text
