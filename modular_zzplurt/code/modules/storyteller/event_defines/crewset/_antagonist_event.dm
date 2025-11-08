/datum/round_event_control/antagonist/New()
	. = ..()
	if(!(TAG_OPFOR_ONLY in tags))
		LAZYADD(tags, TAG_OPFOR_ONLY)

/datum/round_event_control/antagonist
	/// Protected roles from the antag roll. People will not get those roles if a config is enabled
	var/protected_roles = list(
		JOB_NT_TRN
		)
