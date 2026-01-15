/datum/status_effect/climax/on_apply()
	. = ..()
	owner.client?.plug13.send_emote(PLUG13_EMOTE_GROIN, PLUG13_STRENGTH_MAX, PLUG13_DURATION_ORGASM)
