/datum/round_event_control/antagonist/New()
	. = ..()
	if(!(TAG_OPFOR_ONLY in tags))
		LAZYADD(tags, TAG_OPFOR_ONLY)
