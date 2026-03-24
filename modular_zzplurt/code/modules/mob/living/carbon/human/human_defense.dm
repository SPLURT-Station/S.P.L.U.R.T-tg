// Enhanced combat mode features for Issue #42
// Citadel-style combat focus improvements

/mob/living/carbon/human/proc/set_combat_focus(new_mode, silent = TRUE)
	var/intent_toggle = client?.prefs?.read_preference(/datum/preference/toggle/intents)
	if(combat_focus == new_mode)
		return

	. = combat_focus
	combat_focus = new_mode
	hud_used?.focus_toggle?.update_appearance()

	var/focus_sound = client?.prefs.read_preference(/datum/preference/toggle/sound_combatmode)
	if(combat_focus)
		if(intent_toggle)
			face_mouse = !!client?.prefs?.read_preference(/datum/preference/toggle/face_cursor_combat_mode)
		set_combat_indicator(TRUE)
		if(focus_sound && intent_toggle)
			SEND_SOUND(src, sound('sound/misc/ui_togglecombat.ogg', volume = 25))
		// Combat focus bonuses
		add_movespeed_modifier(/datum/movespeed_modifier/combat_focus)
	else
		if(intent_toggle)
			face_mouse = FALSE
		set_combat_indicator(FALSE)
		if(focus_sound && intent_toggle)
			SEND_SOUND(src, sound('sound/misc/ui_toggleoffcombat.ogg', volume = 25))
		// Remove combat focus bonuses
		remove_movespeed_modifier(/datum/movespeed_modifier/combat_focus)

// Combat focus speed modifier
/datum/movespeed_modifier/combat_focus
	movetypes = GROUND
	multiplicative_slowdown = -0.1 // Slight speed boost in combat focus

// Enhanced combat mode functionality
/mob/living/carbon/human/proc/get_combat_focus_bonus()
	if(!combat_focus)
		return 0
	return 0.1 // 10% bonus to combat actions

// Combat focus accuracy modifier for ranged attacks
/mob/living/carbon/human/get_ranged_accuracy_bonus()
	. = ..()
	if(combat_focus)
		. += 0.15 // 15% accuracy bonus when in combat focus

// Combat focus melee damage modifier
/mob/living/carbon/human/get_melee_damage_bonus()
	. = ..()
	if(combat_focus)
		. += 2 // +2 melee damage when in combat focus