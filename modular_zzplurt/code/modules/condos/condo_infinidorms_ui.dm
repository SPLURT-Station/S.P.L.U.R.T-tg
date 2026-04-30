/// Condo teleporter override that reuses SPLURT's infinidorm check-in UI contract.
/obj/machinery/cafe_condo_teleporter
	/// If TRUE, this teleporter belongs to the ghost-cafe side of the network.
	var/is_ghost_cafe = FALSE

/obj/machinery/cafe_condo_teleporter/proc/get_ghost_cafe_side()
	return is_ghost_cafe

/obj/machinery/cafe_condo_teleporter/attack_robot(mob/user)
	if(user.Adjacent(src))
		ui_interact(user)
	return TRUE

/obj/machinery/cafe_condo_teleporter/attack_hand(mob/living/user, list/modifiers)
	ui_interact(user)
	return TRUE

/obj/machinery/cafe_condo_teleporter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HilbertsHotelCheckout")
		ui.set_autoupdate(TRUE)
		ui.open()

/obj/machinery/cafe_condo_teleporter/ui_static_data(mob/user)
	. = ..()
	.["hotel_map_list"] = list()
	for(var/template_name in SScondos.condo_templates)
		var/datum/map_template/condo/template = SScondos.condo_templates[template_name]
		.["hotel_map_list"] += list(list(
			"name" = template.name,
			"category" = template.category || "Misc",
			"donator_tier" = template.donator_tier || DONATOR_TIER_NONE,
			"ckeywhitelist" = template.ckeywhitelist || list(),
		))

/obj/machinery/cafe_condo_teleporter/ui_data(mob/user)
	var/list/data = list()
	if(!user?.ckey)
		return data

	if(!SScondos.splurt_user_data[user.ckey])
		var/datum/map_template/condo/default_template_data = SScondos.condo_templates[SScondos.condo_templates[1]]
		var/default_template = default_template_data?.name
		SScondos.splurt_user_data[user.ckey] = list(
			"room_number" = 1,
			"template" = default_template,
			"donator_tier" = GLOB.donator_list[user.ckey] || DONATOR_TIER_NONE,
		)

	data["current_room"] = SScondos.splurt_user_data[user.ckey]["room_number"]
	data["selected_template"] = SScondos.splurt_user_data[user.ckey]["template"]
	data["user_donator_tier"] = SScondos.splurt_user_data[user.ckey]["donator_tier"]
	data["user_ckey"] = user.ckey

	data["active_rooms"] = list()
	var/is_ghost_cafe = get_ghost_cafe_side()
	var/restrict_sides = CONFIG_GET(flag/hilbertshotel_ghost_cafe_restricted)
	for(var/room_number in SScondos.splurt_room_data)
		var/list/room = SScondos.splurt_room_data["[room_number]"]
		if(restrict_sides && room["is_ghost_cafe"] != is_ghost_cafe)
			continue
		if(room["room_preferences"]["visibility"] == ROOM_VISIBLE)
			data["active_rooms"] += list(list(
				"number" = room_number,
				"name" = room["room_preferences"]["name"],
				"occupants" = SScondos.splurt_generate_occupant_list(room_number),
				"room_preferences" = room["room_preferences"],
			))

	data["conservated_rooms"] = list()
	for(var/room_number in SScondos.splurt_conservated_rooms)
		var/list/room = SScondos.splurt_conservated_rooms[room_number]
		if(restrict_sides && room["is_ghost_cafe"] != is_ghost_cafe)
			continue
		var/visibility = room["room_preferences"]["visibility"]
		switch(visibility)
			if(ROOM_VISIBLE)
				data["conservated_rooms"] += list(list(
					"number" = room_number,
					"room_preferences" = room["room_preferences"],
				))
			if(ROOM_GUESTS_ONLY)
				if((user.mind in room["access_restrictions"]["trusted_guests"]) || (user.mind == room["access_restrictions"]["room_owner"]))
					data["conservated_rooms"] += list(list(
						"number" = room_number,
						"room_preferences" = room["room_preferences"],
					))
			if(ROOM_CLOSED)
				if(user.mind == room["access_restrictions"]["room_owner"])
					data["conservated_rooms"] += list(list(
						"number" = room_number,
						"room_preferences" = room["room_preferences"],
					))
	return data

/obj/machinery/cafe_condo_teleporter/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!usr?.ckey)
		return
	if(!SScondos.splurt_user_data[usr.ckey])
		var/datum/map_template/condo/default_template_data = SScondos.condo_templates[1]
		var/default_template = default_template_data?.name
		SScondos.splurt_user_data[usr.ckey] = list(
			"room_number" = 1,
			"template" = default_template,
			"donator_tier" = GLOB.donator_list[usr.ckey] || DONATOR_TIER_NONE,
		)

	switch(action)
		if("update_room")
			var/new_room = text2num(params["room"])
			if(!new_room || new_room < 1)
				return FALSE
			SScondos.splurt_user_data[usr.ckey]["room_number"] = new_room
			return TRUE
		if("select_room")
			var/template_name = params["room"]
			if(!(template_name in SScondos.condo_templates))
				return FALSE
			SScondos.splurt_user_data[usr.ckey]["template"] = template_name
			return TRUE
		if("checkin")
			var/datum/map_template/condo/default_template_data = SScondos.condo_templates[1]
			var/template_name = SScondos.splurt_user_data[usr.ckey]["template"] || default_template_data?.name
			var/room_number = text2num(params["room"]) || SScondos.splurt_user_data[usr.ckey]["room_number"] || 1
			return prompt_check_in(usr, usr, room_number, template_name)
	return FALSE

/obj/machinery/cafe_condo_teleporter/proc/prompt_check_in(mob/user, mob/target, room_number, template_name)
	if(!CONFIG_GET(flag/hilbertshotel_enabled))
		to_chat(target, span_warning("Infinidorm rooms are currently disabled!"))
		return FALSE
	var/max_rooms = CONFIG_GET(number/hilbertshotel_max_rooms)
	if((length(SScondos.splurt_room_data) + length(SScondos.splurt_conservated_rooms) + 1) >= max_rooms)
		to_chat(target, span_warning("This network is currently at maximum room capacity!"))
		return FALSE
	if(room_number > SHORT_REAL_LIMIT)
		to_chat(target, span_warning("This network is only hooked up to [SHORT_REAL_LIMIT] rooms!"))
		return FALSE
	if((room_number < 1) || (room_number != round(room_number)))
		to_chat(target, span_warning("That is not a valid room number!"))
		return FALSE
	if(!check_target_eligibility(target))
		return FALSE

	var/list/active_entry = SScondos.splurt_room_data["[room_number]"]
	var/requested_is_ghost_cafe = get_ghost_cafe_side()
	if(active_entry)
		if(!SScondos.splurt_can_access_room(active_entry, target, requested_is_ghost_cafe))
			return FALSE
		SScondos.enter_active_room(room_number, target)
		return TRUE

	var/datum/map_template/condo/chosen_condo = SScondos.condo_templates[template_name]
	if(!chosen_condo)
		chosen_condo = SScondos.condo_templates[1]
	if(!chosen_condo)
		to_chat(target, span_warning("No condo templates are currently available."))
		return FALSE
	if(chosen_condo.donator_tier > (GLOB.donator_list[target.ckey] || DONATOR_TIER_NONE))
		to_chat(target, span_warning("Tier [chosen_condo.donator_tier] donator access required to use [chosen_condo.name]."))
		return FALSE
	if(LAZYLEN(chosen_condo.ckeywhitelist) && !(chosen_condo.ckeywhitelist.Find(target.ckey)))
		to_chat(target, span_warning("You are not whitelisted to use [chosen_condo.name]."))
		return FALSE

	SScondos.create_and_enter_condo(room_number, chosen_condo, target, src)
	return TRUE

/obj/machinery/room_controller/ui_data(mob/user)
	var/area/current_area = get_area(src)
	if(!istype(current_area, /area/misc/condo) || !SScondos.splurt_room_data["[room_number]"])
		return ..()

	var/list/data = list()
	var/obj/item/card/id/this_id = inserted_id
	data["id_card"] = this_id?.registered_name
	data["bluespace_box"] = !isnull(bluespace_box)
	data["room_number"] = room_number
	data["room_preferences"] = SScondos.splurt_room_data["[room_number]"]["room_preferences"]
	data["access_restrictions"] = SScondos.splurt_room_data["[room_number]"]["access_restrictions"]
	data["user"] = user
	return data

/obj/machinery/room_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/area/current_area = get_area(src)
	if(!istype(current_area, /area/misc/condo) || !SScondos.splurt_room_data["[room_number]"])
		return ..()
	. = FALSE

	switch(action)
		if("eject_id")
			if(inserted_id)
				eject_id(inserted_id, usr)
				return TRUE
		if("eject_box")
			if(bluespace_box)
				bluespace_box.forceMove(drop_location())
				bluespace_box = null
				update_appearance()
				return TRUE
		if("depart")
			if(!inserted_id || !can_depart(usr))
				playsound(src, 'sound/machines/terminal/terminal_error.ogg', 50, TRUE)
				say("Access denied.")
				addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, say), "Please contact the hotel staff for further assistance."), 3 SECONDS)
				return FALSE
			depart_user(usr)
			return TRUE

	var/list/room_data = SScondos.splurt_room_data["[room_number]"]
	switch(action)
		if("toggle_visibility")
			room_data["room_preferences"]["visibility"] = !room_data["room_preferences"]["visibility"]
			. = TRUE
		if("toggle_status")
			var/current_status = room_data["room_preferences"]["status"]
			switch(current_status)
				if(ROOM_OPEN)
					room_data["room_preferences"]["status"] = ROOM_GUESTS_ONLY
				if(ROOM_GUESTS_ONLY)
					room_data["room_preferences"]["status"] = ROOM_CLOSED
				if(ROOM_CLOSED)
					room_data["room_preferences"]["status"] = ROOM_OPEN
			. = TRUE
		if("toggle_privacy")
			room_data["room_preferences"]["privacy"] = !room_data["room_preferences"]["privacy"]
			. = TRUE
		if("update_description")
			room_data["room_preferences"]["description"] = params["description"]
			. = TRUE
		if("update_name")
			room_data["room_preferences"]["name"] = params["name"]
			. = TRUE
		if("set_icon")
			room_data["room_preferences"]["icon"] = params["icon"]
			. = TRUE
		if("modify_trusted_guests")
			SScondos.splurt_modify_trusted_guests(room_number, usr, params["action"], params["user"])
			. = TRUE
		if("transfer_ownership")
			SScondos.splurt_modify_trusted_guests(room_number, usr, "transfer", null)
			. = TRUE
	if(.)
		SStgui.update_uis(src)
	return
