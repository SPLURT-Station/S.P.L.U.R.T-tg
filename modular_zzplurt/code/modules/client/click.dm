/mob/living/carbon/human
	var/_last_next_move = 0

/mob/living/carbon/human/ClickOn(atom/A, params)
	if(world.time <= next_click)
		return
	_last_next_move = next_move
	return ..()

/mob/living/carbon/human/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(isliving(attack_target))
		var/previous_combat_mode
		switch(combat_mode)
			if(INTENT_DISARM)
				modifiers -= LEFT_CLICK
				modifiers[RIGHT_CLICK] = TRUE
				previous_combat_mode = combat_mode
				combat_mode = INTENT_HARM
				. = ..()
				combat_mode = previous_combat_mode
				return
			if(INTENT_GRAB)
				//CtrlClickOn checks for next_move.. which ClickOn has just set right before calling this.
				next_move = _last_next_move
				previous_combat_mode = combat_mode
				combat_mode = INTENT_HARM
				CtrlClickOn(attack_target)
				combat_mode = previous_combat_mode
				return
	return ..()

/datum/martial_art/the_sleeping_carp/add_to_streak(element, mob/living/defender)
	if(!IS_WEAKREF_OF(defender, current_target))
		reset_streak(defender)
	streak += element
	if(length(streak) > max_streak_length)
		streak = copytext(streak, 1 + length(streak[1]))
	if(display_combos)
		timerid = addtimer(CALLBACK(src, PROC_REF(reset_streak), null, FALSE), combo_timer, TIMER_UNIQUE | TIMER_STOPPABLE)
		if(!isnull(combo_display) && !QDELETED(combo_display))
			combo_display.update_icon_state(streak, combo_timer - 2 SECONDS)

/datum/martial_art/the_sleeping_carp/reset_streak(mob/living/new_target, update_icon = TRUE)
	if(timerid)
		deltimer(timerid)
	current_target = WEAKREF(new_target)
	streak = ""
	if(display_combos && update_icon && !isnull(combo_display) && !QDELETED(combo_display))
		combo_display.update_icon_state(streak)
