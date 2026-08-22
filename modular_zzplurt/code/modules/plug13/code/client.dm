/client
	var/datum/plug13_connection/plug13

/client/New()
	. = ..()
	if (isnull(plug13))
		plug13 = new(src)

GAME_VERB(/client, plug13_menu, "Plug13", "OOC")
	plug13.ui_interact(usr)
