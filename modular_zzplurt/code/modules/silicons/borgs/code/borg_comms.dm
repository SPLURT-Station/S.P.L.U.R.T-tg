/mob/living/silicon/robot
	/// Master radio/binary switch. Does not rewrite the radio's independent settings.
	var/comms_muted = FALSE

GAME_VERB_DESC(/mob/living/silicon/robot, toggle_comms, "Toggle Communications", "Enable or disable radio and binary communications. Local speech and system alerts are unaffected.", "Robot Commands")
	set_comms_muted(!comms_muted)
	to_chat(src, span_notice("Radio and binary communications [comms_muted ? "disabled" : "enabled"]. Local speech and system alerts are unaffected."))

/mob/living/silicon/robot/proc/set_comms_muted(new_value)
	comms_muted = !!new_value

/// Shared with radio TTS, whose recipients and playback are separate from Hear().
/mob/proc/can_receive_radio_communications()
	return TRUE

/mob/living/silicon/robot/can_receive_radio_communications()
	return !comms_muted

/mob/living/silicon/robot/binarycheck()
	return !comms_muted && ..()

/mob/living/silicon/robot/robot_talk(message, list/spans = list(), list/message_mods = list())
	if(comms_muted)
		return
	return ..()

/mob/living/silicon/robot/Hear(atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods = list(), message_range = 0)
	// Includes nearby radios/intercoms, not just our integrated transceiver.
	if(radio_freq && comms_muted)
		return FALSE
	return ..()

/mob/living/silicon/robot/radio(message, list/message_mods = list(), list/spans, language)
	if(comms_muted && (message_mods[MODE_HEADSET] || message_mods[RADIO_EXTENSION]))
		to_chat(src, span_warning("Your communications are disabled."))
		return NOPASS
	return ..()

/obj/item/radio/borg/can_receive(input_frequency, list/levels)
	if(iscyborg(loc))
		var/mob/living/silicon/robot/owner = loc
		if(owner.comms_muted)
			return FALSE
	return ..()

/obj/item/radio/borg/talk_into(atom/movable/talking_movable, message, channel, list/spans, datum/language/language, list/message_mods)
	if(iscyborg(loc))
		var/mob/living/silicon/robot/owner = loc
		if(owner.comms_muted)
			return NONE
	return ..()

/obj/item/radio/borg/talk_into_impl(atom/movable/talking_movable, message, channel, list/spans, datum/language/language, list/message_mods)
	// Recheck at the asynchronous transmission entry point as well.
	if(iscyborg(loc))
		var/mob/living/silicon/robot/owner = loc
		if(owner.comms_muted)
			return
	return ..()

/obj/item/radio/borg/backup_transmission(datum/signal/subspace/vocal/signal)
	// A non-subspace transmission may have been queued before communications were disabled.
	if(iscyborg(loc))
		var/mob/living/silicon/robot/owner = loc
		if(owner.comms_muted)
			return
	return ..()
