/mob/living/silicon/robot/try_speak(message, ignore_spam = FALSE, forced = null, filterproof = FALSE)
	// Cyborgs cannot speak if silent borg is on.
	// Unless forced is set, as that's probably stating laws or something.
	if(!forced && CONFIG_GET(flag/silent_borg))
		to_chat(src, span_danger("The ability for cyborgs to speak is currently disabled via server config."))
		return FALSE

	return ..()

// SPLURT EDIT START - allow borgs to turn off all comms
/mob/living/silicon/robot/binarycheck()
	if(!comms_enabled)
		return FALSE
	return ..()

/mob/living/silicon/robot/Hear(atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods = list(), message_range = 0)
	if(radio_freq && !comms_enabled)
		return FALSE
	return ..()

/mob/living/silicon/robot/radio(message, list/message_mods = list(), list/spans, language)
	if(!comms_enabled && (message_mods[MODE_HEADSET] || message_mods[RADIO_KEY] == MODE_KEY_BINARY || (message_mods[RADIO_EXTENSION] in GLOB.default_radio_channels)))
		to_chat(src, span_warning("Your communications are turned off!"))
		return NOPASS
	return ..()

GAME_VERB_DESC(/mob/living/silicon/robot, toggle_comms, "Toggle Comms", "Toggle all radio and binary communications on or off.", "AI Commands")
	if(stat == DEAD)
		return
	comms_enabled = !comms_enabled
	if(radio)
		radio.set_listening(comms_enabled)
		if(!comms_enabled && radio.get_broadcasting())
			radio.set_broadcasting(FALSE)
	balloon_alert(src, "comms [comms_enabled ? "enabled" : "disabled"]")
	to_chat(src, span_notice("You toggle all communications [comms_enabled ? "on" : "off"]."))
// SPLURT EDIT END
