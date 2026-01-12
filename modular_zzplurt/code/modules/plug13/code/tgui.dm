/datum/plug13_connection/ui_state(mob/user)
	return GLOB.always_state

/datum/plug13_connection/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Plug13", "Plug13")
		ui.open()

/datum/plug13_connection/ui_data(mob/user)
	return list(
		"is_connected" = is_connected,
		"pending" = pending,
		"error" = error,
		"username" = username,
		"code" = code
	)

/datum/plug13_connection/ui_act(action, list/params)
	if(..())
		return

	var/static/regex/codeRegexp = regex(@"^([A-Za-z0-9]{10}|([A-Za-z0-9]{5}-[A-Za-z0-9]{5}))$")
	switch (action)
		if ("connect")
			var/code = params["code"]
			if (!params["code"] || !istext(code))
				return FALSE
			if (length(code) < 10 || length(code) > 11)
				return FALSE
			if (!codeRegexp.Find(code))
				return FALSE
			src.code = code
			connect()
			return TRUE
		if ("disconnect")
			disconnect()
			return TRUE
