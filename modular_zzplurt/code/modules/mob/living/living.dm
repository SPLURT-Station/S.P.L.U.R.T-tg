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
		if(0 to 0.4)
			mob_size = MOB_SIZE_TINY
		if(0.41 to 0.8)
			mob_size = MOB_SIZE_SMALL
		if(0.81 to 1.2)
			mob_size = MOB_SIZE_HUMAN
		if(1.21 to INFINITY)
			mob_size = MOB_SIZE_LARGE

// Add health penalty for sizes below 0.8
    if(ishuman(src))
        var/mob/living/carbon/human/H = src
        if(size < 0.8)
            var/health_penalty = (0.8 - size) * 150
            H.maxHealth = initial(H.maxHealth) - health_penalty
            H.health = min(H.health, H.maxHealth)
            H.add_movespeed_modifier(/datum/movespeed_modifier/small_size)
        else
            H.maxHealth = initial(H.maxHealth)
            H.remove_movespeed_modifier(/datum/movespeed_modifier/small_size)

/datum/movespeed_modifier/small_size
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
