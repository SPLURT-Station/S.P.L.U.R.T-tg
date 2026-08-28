/obj/item/soulstone/soulcatcher
	name = "vore soulcatcher"
	desc = "A magical gem capable of trapping the minds of the departed in a virtual landscape."
	var/interior_design = "You find yourself trapped in a swirling void."
	var/capture_message = "You feel your soul being pulled into the gem!"
	var/transit_message = "The landscape shifts around you..."
	var/transfer_message = "You are pulled out of the gem!"
	var/release_message = "You are released from the gem!"
	var/delete_message = "Your soul is shattered into pieces!"

/obj/item/soulstone/soulcatcher/Initialize(mapload)
	. = ..()
	// In a complete implementation, this would spawn a virtual belly object
	// and hook into the UI for the user to customize the messages.

/obj/item/soulstone/soulcatcher/attack(mob/living/M, mob/living/user, params)
	. = ..()
	if(.) // if attack succeeded (soul trapped)
		var/mob/dead/observer/ghost = get_ghost(M)
		if(ghost)
			to_chat(ghost, span_vwarning(capture_message))
			to_chat(ghost, span_notice(interior_design))

/obj/item/soulstone/soulcatcher/proc/get_ghost(mob/living/M)
	// Gets the ghost from the mob or the soulgem's contents
	for(var/mob/dead/observer/G in src)
		if(G.mind == M.mind)
			return G
	return null

/obj/item/soulstone/soulcatcher/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Soulcatcher")
		ui.open()

/obj/item/soulstone/soulcatcher/ui_data(mob/user)
	var/list/data = list()
	data["interior_design"] = interior_design
	data["capture_message"] = capture_message
	data["transit_message"] = transit_message
	data["transfer_message"] = transfer_message
	data["release_message"] = release_message
	data["delete_message"] = delete_message
	return data

/obj/item/soulstone/soulcatcher/ui_act(action, params)
	. = ..()
	if(.)
		return
	
	switch(action)
		if("update_message")
			var/msg_type = params["type"]
			var/new_msg = params["message"]
			if(msg_type == "interior_design")
				interior_design = new_msg
				for(var/mob/dead/observer/G in src)
					to_chat(G, span_notice(transit_message))
					to_chat(G, span_notice(interior_design))
			else if(msg_type == "capture_message")
				capture_message = new_msg
			else if(msg_type == "transit_message")
				transit_message = new_msg
			else if(msg_type == "transfer_message")
				transfer_message = new_msg
			else if(msg_type == "release_message")
				release_message = new_msg
			else if(msg_type == "delete_message")
				delete_message = new_msg
			return TRUE
