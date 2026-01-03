/datum/tgs_chat_command/addvettedpass
	name = "addvettedpass"
	help_text = "addvettedpass <ckey> | Add someone to the age gate bunker bypass list"
	admin_only = TRUE

/datum/tgs_chat_command/addvettedpass/Run(datum/tgs_chat_user/sender, params)
	if(!SSplayer_ranks)
		return "The Player Ranks subsystem hasn't initialized yet!"
	if(!CONFIG_GET(flag/age_gate_bunker))
		return "The Age Gate Bunker is deactivated!"

	GLOB.vetted_passthrough |= ckey(params)
	GLOB.vetted_passthrough[ckey(params)] = world.realtime
	log_admin("[sender.friendly_name] has added [params] to the current round's vetted bypass list.")
	message_admins("[sender.friendly_name] has added [params] to the current round's vetted bypass list.")
	return "[params] has been added to the current round's age gate bunker bypass list."

/datum/tgs_chat_command/revvettedpass
	name = "revvettedpass"
	help_text = "revvettedpass <ckey> | Remove someone from the age gate bunker bypass list"
	admin_only = TRUE

/datum/tgs_chat_command/revvettedpass/Run(datum/tgs_chat_user/sender, params)
	if(!SSplayer_ranks)
		return "The Player Ranks subsystem hasn't initialized yet!"
	if(!CONFIG_GET(flag/age_gate_bunker))
		return "The Age Gate Bunker is deactivated!"

	GLOB.vetted_passthrough -= ckey(params)
	log_admin("[sender.friendly_name] has removed [params] from the current round's vetted bypass list.")
	message_admins("[sender.friendly_name] has removed [params] from the current round's vetted bypass list.")
	return "[params] has been removed from the current round's age gate bunker bypass list."

