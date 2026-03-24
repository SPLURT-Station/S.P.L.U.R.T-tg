// Enhanced keybindings for combat mode - Issue #42

/datum/keybinding/human/toggle_combat_focus
	name = "toggle_combat_focus"
	full_name = "Toggle Combat Focus"
	description = "Toggles combat focus mode for enhanced combat awareness."
	hotkey_keys = list("G")
	keybind_signal = COMSIG_KB_HUMAN_TOGGLE_COMBAT_FOCUS_DOWN

/datum/keybinding/human/toggle_combat_focus/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	if(!istype(human))
		return
	human.set_combat_focus(!human.combat_focus, FALSE)
	return TRUE

/datum/keybinding/human/cycle_intent
	name = "cycle_intent"
	full_name = "Cycle Intent"
	description = "Cycles through intents: Help -> Disarm -> Grab -> Harm -> Help"
	hotkey_keys = list("Unbound")
	keybind_signal = COMSIG_KB_HUMAN_CYCLE_INTENT_DOWN

/datum/keybinding/human/cycle_intent/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	if(!istype(human))
		return
	
	var/intent_toggle = user.prefs?.read_preference(/datum/preference/toggle/intents)
	if(!intent_toggle)
		return
	
	// Cycle through intents
	switch(human.combat_mode)
		if(INTENT_HELP)
			human.set_combat_mode(INTENT_DISARM, silent = TRUE)
		if(INTENT_DISARM)
			human.set_combat_mode(INTENT_GRAB, silent = TRUE)
		if(INTENT_GRAB)
			human.set_combat_mode(INTENT_HARM, silent = TRUE)
		if(INTENT_HARM)
			human.set_combat_mode(INTENT_HELP, silent = TRUE)
		else
			human.set_combat_mode(INTENT_HELP, silent = TRUE)
	
	return TRUE

// Combat mode quick actions
/datum/keybinding/human/combat_quick_shove
	name = "combat_quick_shove"
	full_name = "Quick Shove"
	description = "Quickly shove target in combat mode."
	hotkey_keys = list("Unbound")
	keybind_signal = COMSIG_KB_HUMAN_COMBAT_QUICK_SHOVE_DOWN

/datum/keybinding/human/combat_quick_shove/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	if(!istype(human) || !human.combat_focus)
		return
	
	// Perform quick shove action
	var/atom/target = user.mob.client?.mouse_object
	if(target && isliving(target))
		var/mob/living/L = target
		if(L.Adjacent(human))
			human.disarm(L)
			return TRUE
	return FALSE