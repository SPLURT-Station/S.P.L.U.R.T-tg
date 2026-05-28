/// Condo teleporter override that reuses SPLURT's infinidorm check-in UI contract.
/obj/machinery/cafe_condo_teleporter
	/// If TRUE, this teleporter belongs to the ghost-cafe side of the network.
	var/is_ghost_cafe = FALSE

/obj/machinery/cafe_condo_teleporter/proc/get_ghost_cafe_side()
	return is_ghost_cafe

/obj/machinery/cafe_condo_teleporter/proc/splurt_get_room_join_status(list/room, mob/user)
	var/list/room_preferences = room?["room_preferences"]
	var/list/access_restrictions = room?["access_restrictions"]
	if(!room_preferences || !access_restrictions || !user?.mind)
		return list("can_join" = FALSE)
	var/status = room_preferences["status"]
	var/datum/mind/owner_mind = access_restrictions["room_owner"]
	var/list/trusted_guests = access_restrictions["trusted_guests"]
	if(!trusted_guests)
		trusted_guests = list()
	var/is_owner = owner_mind == user.mind
	var/is_trusted = FALSE
	if(user.mind in trusted_guests)
		is_trusted = TRUE
	return list(
		"can_join" = status == ROOM_OPEN || is_owner || (status == ROOM_GUESTS_ONLY && is_trusted),
		"is_owner" = is_owner,
		"is_trusted" = is_trusted,
	)

/obj/machinery/cafe_condo_teleporter/proc/splurt_build_room_list_entry(room_number, list/room, mob/user)
	var/list/join_status = splurt_get_room_join_status(room, user)
	var/list/room_preferences = room?["room_preferences"]
	if(!room_preferences)
		room_preferences = list()
	return list(
		"number" = room_number,
		"name" = room_preferences["name"] || "Room [room_number]",
		"room_preferences" = room_preferences,
		"expires_at" = room["expires_at"],
		"can_join" = join_status["can_join"],
		"is_owner" = join_status["is_owner"],
		"is_trusted" = join_status["is_trusted"],
	)

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
	if(!.)
		. = list()
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
		var/datum/map_template/condo/default_template_data = SScondos.splurt_get_default_template()
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
		var/list/room_preferences = room["room_preferences"]
		if(room_preferences && room_preferences["visibility"] == ROOM_VISIBLE)
			var/list/room_entry = splurt_build_room_list_entry(room_number, room, user)
			room_entry["occupants"] = SScondos.splurt_generate_occupant_list(room_number)
			data["active_rooms"] += list(room_entry)

	data["conservated_rooms"] = list()
	for(var/room_number in SScondos.splurt_conservated_rooms)
		var/list/room = SScondos.splurt_conservated_rooms[room_number]
		if(restrict_sides && room["is_ghost_cafe"] != is_ghost_cafe)
			continue
		var/list/room_preferences = room["room_preferences"]
		if(!room_preferences || room_preferences["visibility"] != ROOM_VISIBLE)
			continue
		data["conservated_rooms"] += list(splurt_build_room_list_entry(room_number, room, user))
	return data

/obj/machinery/cafe_condo_teleporter/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!usr?.ckey)
		return
	if(!SScondos.splurt_user_data[usr.ckey])
		var/datum/map_template/condo/default_template_data = SScondos.splurt_get_default_template()
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
			var/datum/map_template/condo/default_template_data = SScondos.splurt_get_default_template()
			var/template_name = params["template"]
			if(!(template_name in SScondos.condo_templates))
				template_name = SScondos.splurt_user_data[usr.ckey]["template"] || default_template_data?.name
			else
				SScondos.splurt_user_data[usr.ckey]["template"] = template_name
			var/room_number = text2num(params["room"]) || SScondos.splurt_user_data[usr.ckey]["room_number"] || 1
			var/room_name = params["room_name"]
			return prompt_check_in(usr, usr, room_number, template_name, room_name)
		if("delete_reserved_room")
			var/room_number = text2num(params["room"])
			if(!room_number)
				return FALSE
			return SScondos.splurt_delete_reserved_room(room_number, usr)
	return FALSE

/obj/machinery/cafe_condo_teleporter/proc/prompt_check_in(mob/user, mob/target, room_number, template_name, room_name = null)
	if(!CONFIG_GET(flag/hilbertshotel_enabled))
		to_chat(target, span_warning("Infinidorm rooms are currently disabled!"))
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
	if(SScondos.active_condos["[room_number]"])
		SScondos.enter_active_room(room_number, target)
		return TRUE

	var/datum/map_template/condo/chosen_condo = SScondos.condo_templates[template_name]
	if(!chosen_condo)
		chosen_condo = SScondos.splurt_get_default_template()
	if(!chosen_condo)
		to_chat(target, span_warning("No condo templates are currently available."))
		return FALSE
	if(chosen_condo.donator_tier > (GLOB.donator_list[target.ckey] || DONATOR_TIER_NONE))
		to_chat(target, span_warning("Tier [chosen_condo.donator_tier] donator access required to use [chosen_condo.name]."))
		return FALSE
	if(LAZYLEN(chosen_condo.ckeywhitelist) && !(chosen_condo.ckeywhitelist.Find(target.ckey)))
		to_chat(target, span_warning("You are not whitelisted to use [chosen_condo.name]."))
		return FALSE
	var/max_rooms = CONFIG_GET(number/hilbertshotel_max_rooms)
	if(!SScondos.splurt_conservated_rooms["[room_number]"] && (length(SScondos.splurt_room_data) + length(SScondos.splurt_conservated_rooms)) >= max_rooms)
		to_chat(target, span_warning("This network is currently at maximum room capacity!"))
		return FALSE

	SScondos.create_and_enter_condo(room_number, chosen_condo, target, src)
	if(room_name)
		var/list/room_data = SScondos.splurt_room_data["[room_number]"]
		if(room_data)
			room_data["room_preferences"]["name"] = room_name
	return TRUE
