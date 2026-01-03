ADMIN_VERB(agegatebunker, R_SERVER, "Toggle Age Gate Bunker", "Toggles the Age Gate Bunker on or off.", ADMIN_CATEGORY_SERVER)
	if(!SSplayer_ranks)
		to_chat(user, span_adminnotice("The Player Ranks subsystem hasn't initialized yet!"))
		return

	var/new_agbun = !CONFIG_GET(flag/age_gate_bunker)
	CONFIG_SET(flag/age_gate_bunker, new_agbun)

	log_admin("[key_name(user)] has toggled the Age Gate Bunker, it is now [new_agbun ? "on" : "off"]")
	message_admins("[key_name_admin(user)] has toggled the Age Gate Bunker, it is now [new_agbun ? "enabled" : "disabled"].")
	SSblackbox.record_feedback("nested tally", "age_gate_toggle", 1, list("Toggle Age Gate Bunker", "[new_agbun ? "Enabled" : "Disabled"]"))
	send2adminchat("Age Gate Bunker", "[key_name(user)] has toggled the Age Gate Bunker, it is now [new_agbun ? "enabled" : "disabled"].")

ADMIN_VERB(addvettedbypass, R_SERVER, "Add Vetted Bypass", "Allows a given ckey to bypass the age gate bunker for the round even if they aren't vetted yet.", ADMIN_CATEGORY_SERVER, ckeytobypass as text)
	if(!SSplayer_ranks)
		to_chat(user, span_adminnotice("The Player Ranks subsystem hasn't initialized yet!"))
		return
	if(!CONFIG_GET(flag/age_gate_bunker))
		to_chat(user, span_adminnotice("The Age Gate Bunker is deactivated!"))
		return

	GLOB.vetted_passthrough |= ckey(ckeytobypass)
	GLOB.vetted_passthrough[ckey(ckeytobypass)] = world.realtime
	log_admin("[key_name(user)] has added [ckeytobypass] to the current round's vetted bypass list.")
	message_admins("[key_name_admin(user)] has added [ckeytobypass] to the current round's vetted bypass list.")
	send2adminchat("Age Gate Bunker", "[key_name(user)] has added [ckeytobypass] to the current round's vetted bypass list.")

ADMIN_VERB(revokevettedbypass, R_SERVER, "Revoke Vetted Bypass", "Revoke's a ckey's permission to bypass the age gate bunker for a given round.", ADMIN_CATEGORY_SERVER, ckeytobypass as text)
	if(!SSplayer_ranks)
		to_chat(user, span_adminnotice("The Player Ranks subsystem hasn't initialized yet!"))
		return
	if(!CONFIG_GET(flag/age_gate_bunker))
		to_chat(user, span_adminnotice("The Age Gate Bunker is deactivated!"))
		return

	GLOB.vetted_passthrough -= ckey(ckeytobypass)
	log_admin("[key_name(user)] has removed [ckeytobypass] from the current round's vetted bypass list.")
	message_admins("[key_name_admin(user)] has removed [ckeytobypass] from the current round's vetted bypass list.")
	send2adminchat("Age Gate Bunker", "[key_name(user)] has removed [ckeytobypass] from the current round's vetted bypass list.")

