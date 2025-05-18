/datum/tgs_chat_command/restart
	name = "restart"
	help_text = "Forces a restart on the server"
	admin_only = TRUE

/datum/tgs_chat_command/restart/Run(datum/tgs_chat_user/sender)
	. = new /datum/tgs_message_content("Restarting.")
	to_chat(world, span_boldwarning("Server restart - Initialized by [sender.friendly_name] on Discord."))
	send2adminchat("Server", "[sender.friendly_name] forced a restart.")
	addtimer(CALLBACK(src, PROC_REF(DoEndProcess)), 1 SECONDS)

/datum/tgs_chat_command/restart/proc/DoEndProcess()
	world.TgsEndProcess()
