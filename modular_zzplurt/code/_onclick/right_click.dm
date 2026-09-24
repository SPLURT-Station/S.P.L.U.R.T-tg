// Citadel-style right click controls, ported over from SPLURT-13.
// Outside of a combat state right clicks open the BYOND context menu; while in one
// client.show_popup_menus is suppressed so that right clicks are delivered to Click() for combat actions.

/// Whether this mob is in an active combat state. For most living mobs this is combat mode;
/// humans with the intents preference enabled use combat focus instead.
/mob/proc/combat_mode_active()
	return FALSE

/mob/living/combat_mode_active()
	return combat_mode

/mob/living/carbon/human/combat_mode_active()
	if(!client?.prefs || client.prefs.read_preference(/datum/preference/toggle/intents))
		return combat_focus
	return ..()

/// Synchronizes the client's popup menu setting with our combat state.
/// Right clicks only get delivered to Click() while the context menu is suppressed; non-living mobs never suppress it.
/mob/proc/update_popup_menus()
	if(client)
		client.show_popup_menus = TRUE

/mob/living/update_popup_menus()
	if(client)
		client.show_popup_menus = !combat_mode_active()

/**
 * Citadel-style ctrl+right click: drops the held item at the clicked turf,
 * or rotates an unanchored item on it. Ported from SPLURT-13.
 */
/mob/proc/CtrlRightClickOn(atom/A, params)
	if(isliving(src) && Adjacent(A)) //honestly only humans can do this given it's combat mode but if it's implemented for any other mobs...
		var/mob/living/L = src
		if(L.incapacitated)
			return
		var/obj/item/I = L.get_active_held_item()
		var/turf/T = get_turf(A)
		if(T)
			if(I) //drop item at cursor.
				if(T.density) //no, you can't use your funny blue cube or red cube to clip into the fucking wall.
					return
				for(var/atom/C in T.contents) //nor can you clip into a window or a door/false wall that's not open.
					if(C.opacity || (((C.flags_1 & PREVENT_CLICK_UNDER_1) > 0) != (istype(C,/obj/machinery/door) && !C.density))) //XOR operation within because doors always have PREVENT_CLICK_UNDER_1 flag enabled. Dumb, I know.
						return
				if(L.transferItemToLoc(I, T))
					var/list/click_params = params2list(params)
					//Center the icon where the user clicked. (shamelessly stole code from tables)
					if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
						return
					//Clamp it so that the icon never moves more than 16 pixels in either direction
					I.pixel_x = clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
					I.pixel_y = clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
					return TRUE
			else if(isitem(A) && L.has_active_hand()) //if they have an open hand they'll rotate the item instead.
				var/obj/item/I2 = A
				if(!I2.anchored)
					var/matrix/ntransform = matrix(I2.transform)
					ntransform.Turn(15)
					animate(I2, transform = ntransform, time = 2)
					return TRUE
			else
				CtrlClickOn(A)

/// Citadel-style ranged right click gestures, ported from SPLURT-13's /mob/living/carbon/human/AltRangedAttack.
/mob/living/carbon/human/ranged_secondary_attack(atom/target, modifiers)
	if(isturf(target) || incapacitated) // pretty annoying to wave your fist at floors and walls. And useless.
		return
	if(..())
		return TRUE
	changeNext_move(CLICK_CD_RANGE)
	var/list/target_viewers = viewers(11, target) //doesn't check for blindness.
	if(!(src in target_viewers)) //click catcher issuing calls for out of view objects.
		return TRUE
	if(!has_active_hand())
		to_chat(src, span_notice("You ponder your life choices and sigh."))
		return TRUE
	var/list/src_viewers = viewers(DEFAULT_MESSAGE_RANGE, src) - src // src has a different message.
	var/the_action = "waves to [target]"
	var/what_action = "waves to something you can't see"
	var/self_action = "wave to [target]"

	switch(combat_mode)
		if(INTENT_DISARM)
			the_action = "shoos away [target]"
			what_action = "shoo away something out of your vision"
			self_action = "shoo away [target]"
		if(INTENT_GRAB)
			the_action = "beckons [target] to come"
			what_action = "beckons something out of your vision to come"
			self_action = "beckon [target] to come"
		if(INTENT_HARM)
			var/pronoun = "[p_their()]"
			the_action = "shakes [pronoun] fist at [target]"
			what_action = "shakes [pronoun] fist at something out of your vision"
			self_action = "shake your fist at [target]"

	if(!is_blind())
		to_chat(src, "You [self_action].")
	for(var/mob/viewer in src_viewers)
		if(!viewer.is_blind())
			var/message = (viewer in target_viewers) ? the_action : what_action
			to_chat(viewer, "[src] [message].")
	return TRUE
