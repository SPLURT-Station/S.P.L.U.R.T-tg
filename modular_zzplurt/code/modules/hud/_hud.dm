
/datum/hud
	var/atom/movable/screen/focus_toggle

/datum/hud/human/New(mob/living/carbon/human/owner)
	. = ..()
	if(!owner.client?.prefs?.read_preference(/datum/preference/toggle/intents))
		floor_change.screen_loc = "EAST-4:22,SOUTH:5"
		return
	var/index = static_inventory.Find(action_intent)
	static_inventory[index] = null
	qdel(action_intent)

	action_intent = new /atom/movable/screen/intent_toggle(null, src)
	static_inventory[index] = action_intent

	focus_toggle = new /atom/movable/screen/focus_toggle(null, src)
	focus_toggle.icon = ui_style
	focus_toggle.update_appearance()
	static_inventory += focus_toggle

/datum/hud/human/Destroy()
	focus_toggle = null
	. = ..()
