// SPLURT EDIT - Enhanced right click controls for Issue #42
// This file enhances the right-click handling for better control

/mob/living/carbon/human
	var/_last_next_move = 0

/mob/living/carbon/human/ClickOn(atom/A, params)
	if(world.time <= next_click)
		return
	_last_next_move = next_move
	return ..()

/mob/living/carbon/human/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	// Check if intents preference is enabled
	var/intent_toggle = client?.prefs?.read_preference(/datum/preference/toggle/intents)
	
	if(isliving(attack_target) && intent_toggle)
		switch(combat_mode)
			if(INTENT_DISARM)
				// Disarm intent: Perform shove/disarm action
				modifiers -= LEFT_CLICK
				modifiers[RIGHT_CLICK] = TRUE
			if(INTENT_GRAB)
				// Grab intent: Initiate grab
				next_move = _last_next_move
				CtrlClickOn(attack_target)
				return
	
	return ..()

// Enhanced right-click handling for combat mode
/mob/living/carbon/human/ranged_secondary_attack(atom/target, modifiers)
	. = ..()
	
	// Combat focus bonus: Enhanced accuracy when in combat focus
	if(combat_focus)
		// Add any combat-specific ranged secondary attack logic here
		return TRUE

// Combat mode enhancements
/mob/living/carbon/human/proc/perform_combat_secondary_attack(atom/target, list/modifiers)
	if(!combat_focus)
		return FALSE
	
	// Special combat mode secondary attacks
	// This can be expanded with Citadel-style combat features
	return TRUE