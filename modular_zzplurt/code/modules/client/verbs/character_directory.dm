GLOBAL_LIST_EMPTY(hookup_looking)
GLOBAL_LIST_EMPTY(hookup_notes)

#define READ_PREFS(target, pref) (target.client.prefs.read_preference(/datum/preference/pref) || "Unset")

/datum/character_directory/ui_data(mob/user)
	. = ..()
	var/list/data = .

	if (user?.client?.prefs)
		data["personalExtremeTag"] = READ_PREFS(user, choiced/erp_status_extm)
		data["personalExtremeHarmTag"] = READ_PREFS(user, choiced/erp_status_extmharm)
		data["personalUnholyTag"] = READ_PREFS(user, choiced/erp_status_unholy)

	var/user_ref = user ? REF(user) : null
	data["lookingForHookup"] = !!(user_ref && GLOB.hookup_looking[user_ref])
	data["hookupNote"] = (user_ref && GLOB.hookup_notes[user_ref]) || ""
	data["isHookupApp"] = FALSE

	return data

/datum/character_directory/ui_static_data(mob/user)
	. = ..()
	var/list/data = .
	for(var/list/entry in data["directory"])
		var/ref = entry["ref"]
		entry["looking_for_hookup"] = !!(ref && GLOB.hookup_looking[ref])
		entry["hookup_note"] = (ref && GLOB.hookup_notes[ref]) || ""
	return data

/datum/character_directory/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = usr
	if(!user)
		return

	. = handle_hookup_action(action, params, user, null)
	if(. && (action == "toggle_hookup" || action == "set_hookup_note"))
		update_static_data(user, ui)

/datum/character_directory/proc/handle_hookup_action(action, list/params, mob/user, obj/item/modular_computer/host_computer)
	switch(action)
		if("toggle_hookup")
			var/user_ref = REF(user)
			GLOB.hookup_looking[user_ref] = !GLOB.hookup_looking[user_ref]
			return TRUE
		if("set_hookup_note")
			var/user_ref = REF(user)
			var/new_note = tgui_input_text(user, "Enter a short status or location note (leave blank to clear):", "Hookup Status Note", GLOB.hookup_notes[user_ref] || "", max_length = 120)
			if(isnull(new_note) || QDELETED(user))
				return FALSE
			new_note = trim(new_note)
			if(length(new_note))
				GLOB.hookup_notes[user_ref] = new_note
				GLOB.hookup_looking[user_ref] = TRUE
			else
				GLOB.hookup_notes -= user_ref
			return TRUE
		if("message")
			if(!host_computer)
				return FALSE
			var/datum/computer_file/program/messenger/my_messenger = locate() in host_computer.stored_files
			if(!my_messenger || !my_messenger.sending_and_receiving)
				to_chat(user, span_warning("Your PDA messenger is unavailable or has sending disabled."))
				return FALSE
			var/mob/living/target = (locate(params["ref"]) in GLOB.mob_list)
			if(!target)
				to_chat(user, span_warning("Could not locate that crew member on the network."))
				return FALSE
			var/datum/computer_file/program/messenger/target_messenger
			for(var/messenger_ref in GLOB.pda_messengers)
				var/datum/computer_file/program/messenger/candidate = GLOB.pda_messengers[messenger_ref]
				if(!istype(candidate) || !istype(candidate.computer) || candidate == my_messenger || candidate.invisible)
					continue
				if((candidate.computer in target.get_all_contents()) || candidate.computer.saved_identification == target.real_name || candidate.computer.saved_identification == target.name)
					target_messenger = candidate
					break
			if(!target_messenger)
				to_chat(user, span_warning("Could not find an active PDA messenger for [target.name]."))
				return FALSE
			var/input_message = tgui_input_text(user, "Enter a message to send to [target.name]. Start with # for subtle.", "Hookup Message ([target.name])", max_length = MAX_MESSAGE_LEN, encode = FALSE)
			if(!input_message || QDELETED(user) || QDELETED(host_computer) || !host_computer.can_interact(user))
				return FALSE
			return my_messenger.send_message(user, input_message, list(target_messenger))

/datum/computer_file/program/hookup
	filename = "hookup_app"
	filedesc = "Hookup Directory"
	downloader_category = PROGRAM_CATEGORY_DEVICE
	program_open_overlay = "text"
	extended_desc = "A station-wide hookup and partner-finding app synced with crew ERP preferences and PDA messaging."
	size = 0
	undeletable = TRUE
	power_cell_use = NONE
	program_flags = PROGRAM_ON_NTNET_STORE | PROGRAM_REQUIRES_NTNET
	can_run_on_flags = PROGRAM_ALL
	tgui_id = "ZubbersCharacterDirectory"
	program_icon = "heart"

/datum/computer_file/program/hookup/ui_data(mob/user)
	if(!GLOB.character_directory)
		GLOB.character_directory = new
	var/list/data = GLOB.character_directory.ui_data(user)
	data["isHookupApp"] = TRUE
	return data

/datum/computer_file/program/hookup/ui_static_data(mob/user)
	if(!GLOB.character_directory)
		GLOB.character_directory = new
	return GLOB.character_directory.ui_static_data(user)

/datum/computer_file/program/hookup/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!user)
		return
	if(!GLOB.character_directory)
		GLOB.character_directory = new
	if(action == "refresh")
		if(!COOLDOWN_FINISHED(user.client, char_directory_cooldown))
			to_chat(user, span_warning("Don't spam character directory refresh."))
			return
		COOLDOWN_START(user.client, char_directory_cooldown, 10)
		computer?.update_static_data_for_all_viewers()
		return TRUE
	if(action == "orbit" || action == "view")
		return GLOB.character_directory.ui_act(action, params, ui, state)
	. = GLOB.character_directory.handle_hookup_action(action, params, user, computer)
	if(. && (action == "toggle_hookup" || action == "set_hookup_note"))
		computer?.update_static_data_for_all_viewers()

#undef READ_PREFS
