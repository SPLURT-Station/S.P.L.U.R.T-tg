/mob/opposing_force()
	set name = "Opposing Force"
	set category = null
	set hidden = 1
	to_chat(src, span_warning("Opposing Force is disabled on this server."))
	return
