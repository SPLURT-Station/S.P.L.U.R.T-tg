/datum/hud
	var/atom/movable/screen/focus_toggle

/datum/hud/human/New(mob/living/carbon/human/owner)
	. = ..()
	if(!owner.client?.prefs?.read_preference(/datum/preference/toggle/intents))
		var/atom/movable/screen/floor_change = screen_objects[HUD_MOB_FLOOR_CHANGER]
		if(floor_change)
			floor_change.screen_loc = "EAST-4:22,SOUTH:5"
		return

	remove_screen_object(HUD_MOB_INTENTS, update = FALSE)
	add_screen_object(/atom/movable/screen/intent_toggle, HUD_MOB_INTENTS, HUD_GROUP_INFO, ui_style)

	focus_toggle = add_screen_object(/atom/movable/screen/focus_toggle, HUD_MOB_FOCUS_TOGGLE, HUD_GROUP_STATIC, ui_style)
	focus_toggle.update_appearance()

/datum/hud/human/Destroy()
	focus_toggle = null
	. = ..()
