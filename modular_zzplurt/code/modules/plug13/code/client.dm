/client
	var/datum/plug13_connection/plug13

/client/New()
	. = ..()
	if (isnull(plug13))
		plug13 = new(src)

/client/verb/plug13_menu()
	set category = "OOC"
	set name = "Plug13"

	plug13.ui_interact(usr)
