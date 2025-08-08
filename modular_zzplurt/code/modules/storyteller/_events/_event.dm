/datum/round_event_control/New()
	. = ..()
	if(!(TAG_OPFOR_ONLY in tags) && (TAG_CREW_ANTAG in tags))
		LAZYADD(tags, TAG_OPFOR_ONLY)
