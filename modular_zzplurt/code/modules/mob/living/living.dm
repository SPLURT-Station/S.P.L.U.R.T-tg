/mob/living
	var/size_multiplier = RESIZE_NORMAL

/// Returns false on failure
/mob/living/proc/update_size(new_size, cur_size)
	if(!new_size)
		return FALSE
	if(!cur_size)
		cur_size = get_size(src)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(new_size == cur_size)
			return FALSE
		H.dna.features["body_size"] = new_size
		H.dna.update_body_size(cur_size)
	else
		if(new_size == cur_size)
			return FALSE
		size_multiplier = new_size
		current_size = new_size / cur_size
		update_transform()
	adjust_mobsize(new_size)
	SEND_SIGNAL(src, COMSIG_MOB_RESIZED, new_size, cur_size)
	return TRUE

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

		// Remove existing modifiers first
		H.remove_movespeed_modifier(/datum/movespeed_modifier/small_size)
		H.remove_movespeed_modifier(/datum/movespeed_modifier/tiny_size)

		// Apply penalties based on size category
		switch(mob_size)
			if(MOB_SIZE_TINY)
				H.maxHealth = max(1, initial(H.maxHealth) - 60) // 60 less at 0.49 and below
				H.health = min(H.health, H.maxHealth)
				H.add_movespeed_modifier(/datum/movespeed_modifier/tiny_size)
			if(MOB_SIZE_SMALL)
				H.maxHealth = max(1, initial(H.maxHealth) - 30) // 30 less at 0.5 to 0.79
				H.health = min(H.health, H.maxHealth)
				H.add_movespeed_modifier(/datum/movespeed_modifier/small_size)
			else
				H.maxHealth = initial(H.maxHealth)
				H.health = min(H.health, H.maxHealth)

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

/mob/living/verb/switch_scaling()
	set name = "Switch scaling mode"
	set category = "IC"
	set desc = "Switch sharp/fuzzy scaling for current mob."
	fuzzy = !fuzzy
	regenerate_icons()
