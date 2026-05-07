/// SPLURT infinidorm extensions for upstream condos.
/// Upstream still owns reservation lifecycle (`SScondos.active_condos`), while this layer
/// stores room metadata, trusted guests, and conservation payloads for full parity behavior.

/turf/closed/indestructible/hoteldoor
	/// Condo-safe per-user return points used to prevent incorrect egress routing.
	var/list/entry_points = list()

/turf/closed/indestructible/hoteldoor/promptExit(mob/living/user)
	var/destination = parentSphere
	if(!isliving(user))
		return
	if(!user.mind)
		return
	if(!parentSphere)
		to_chat(user, span_warning("The door seems to be malfunctioning and refuses to operate!"))
		return
	if(istype(get_area(src), /area/misc/condo) && (user.mind in entry_points))
		var/entry_destination = entry_points[user.mind]
		if(entry_destination)
			destination = entry_destination
	if(tgui_alert(user, leave_message, "Exit", list("Leave", "Stay")) == "Leave")
		if(HAS_TRAIT(user, TRAIT_IMMOBILIZED) || (get_dist(get_turf(src), get_turf(user)) > 1)) //no teleporting around if they're dead or moved away during the prompt.
			return
		user.forceMove(get_turf(destination))
		do_sparks(3, FALSE, get_turf(user))

/datum/controller/subsystem/condos
	/// SPLURT metadata for active condo rooms keyed by room number.
	var/list/splurt_room_data = list()
	/// SPLURT metadata for conserved (vacated but saved) condo rooms keyed by room number.
	var/list/splurt_conservated_rooms = list()
	/// Hidden storage turf used to hold conserved room contents.
	var/turf/splurt_storage_turf
	/// Ckey-based UI defaults for the condo check-in interface.
	var/list/splurt_user_data = list()

/datum/controller/subsystem/condos/proc/splurt_is_template_path_local(template_type)
	var/datum/map_template/condo/condo_type = template_type
	var/template_path = initial(condo_type.mappath)
	return findtext(template_path, "_maps/splurt/") == 1 || findtext(template_path, "modular_zzplurt/") == 1

/datum/controller/subsystem/condos/preload_condo_templates()
	var/list/local_template_names = list()
	for(var/item in subtypesof(/datum/map_template/condo))
		var/datum/map_template/condo/condo_type = item
		if(!(initial(condo_type.mappath)))
			continue
		if(splurt_is_template_path_local(condo_type))
			local_template_names[initial(condo_type.name)] = TRUE

	for(var/item in subtypesof(/datum/map_template/condo))
		var/datum/map_template/condo/condo_type = item
		if(!(initial(condo_type.mappath)))
			continue
		if(!splurt_is_template_path_local(condo_type) && local_template_names[initial(condo_type.name)])
			continue

		var/datum/map_template/condo/condo_template = new condo_type()
		condo_templates[condo_template.name] = condo_template
		SSmapping.map_templates[condo_template.name] = condo_template

/datum/map_template/condo
	/// Optional category used by SPLURT's check-in UI tabs.
	var/category = "Misc"
	/// Optional tier gate used by SPLURT's check-in UI.
	var/donator_tier = DONATOR_TIER_NONE
	/// Optional ckey-only whitelist used by SPLURT's check-in UI.
	var/list/ckeywhitelist = list()

/datum/controller/subsystem/condos/proc/splurt_ensure_storage_turf()
	if(splurt_storage_turf)
		return splurt_storage_turf
	var/datum/map_template/hilbertshotelstorage/storage_template = new()
	var/datum/turf_reservation/storage_reservation = SSmapping.request_turf_block_reservation(3, 3)
	if(!storage_reservation)
		return
	var/turf/bottom_left = get_turf(storage_reservation.bottom_left_turfs[1])
	if(!bottom_left)
		return
	storage_template.load(bottom_left)
	splurt_storage_turf = locate(bottom_left.x + 1, bottom_left.y + 1, bottom_left.z)
	return splurt_storage_turf

/datum/controller/subsystem/condos/proc/splurt_get_template(datum/turf_reservation/condo/condo_reservation, template_name)
	var/datum/map_template/condo/template = condo_reservation?.condo_template
	if(!template && template_name)
		template = condo_templates[template_name]
	return template

/datum/controller/subsystem/condos/proc/splurt_get_default_template()
	var/default_template_name = condo_templates[1]
	if(default_template_name)
		return condo_templates[default_template_name]

/datum/controller/subsystem/condos/proc/splurt_get_parent_side(parent_object)
	var/is_ghost_cafe = FALSE
	if(istype(parent_object, /obj/machinery/cafe_condo_teleporter))
		var/obj/machinery/cafe_condo_teleporter/teleporter = parent_object
		is_ghost_cafe = teleporter.get_ghost_cafe_side()
	return is_ghost_cafe

/datum/controller/subsystem/condos/proc/splurt_can_access_room(list/room_entry, mob/user, requested_is_ghost_cafe = null)
	if(!room_entry || !user?.mind)
		return FALSE
	var/list/room_preferences = room_entry["room_preferences"]
	var/list/access_restrictions = room_entry["access_restrictions"]
	if(!room_preferences || !access_restrictions)
		return FALSE
	var/status = room_preferences["status"]
	var/datum/mind/owner_mind = access_restrictions["room_owner"]
	var/list/trusted_guests = access_restrictions["trusted_guests"]
	if(!trusted_guests)
		trusted_guests = list()
	if(!isnull(requested_is_ghost_cafe) && CONFIG_GET(flag/hilbertshotel_ghost_cafe_restricted))
		if(room_entry["is_ghost_cafe"] != requested_is_ghost_cafe)
			to_chat(user, span_warning("You can't enter this room from this side of the network."))
			return FALSE
	if(status == ROOM_CLOSED && owner_mind != user.mind)
		to_chat(user, span_warning("This room is closed!"))
		return FALSE
	if(status == ROOM_GUESTS_ONLY && owner_mind != user.mind && !(user.mind in trusted_guests))
		to_chat(user, span_warning("Access denied. This room is only available to invited guests."))
		return FALSE
	return TRUE

/datum/controller/subsystem/condos/proc/splurt_generate_occupant_list(condo_number)
	var/list/occupants = list()
	var/list/room_entry = splurt_room_data["[condo_number]"]
	var/datum/turf_reservation/condo/condo_reservation = room_entry?["reservation"]
	var/datum/map_template/condo/template = splurt_get_template(condo_reservation, room_entry?["template"])
	if(!condo_reservation || !template)
		return occupants
	var/turf/bottom_left = condo_reservation.bottom_left_turfs[1]
	if(!bottom_left)
		return occupants
	for(var/x in 0 to template.width - 1)
		for(var/y in 0 to template.height - 1)
			for(var/atom/movable/movable_atom in locate(bottom_left.x + x, bottom_left.y + y, bottom_left.z))
				if(!isliving(movable_atom))
					continue
				var/mob/living/this_living = movable_atom
				if(this_living.mind)
					occupants += this_living.mind.name
	return occupants

/datum/controller/subsystem/condos/proc/splurt_conservate_condo(area/misc/condo/current_area)
	var/list/room_entry = splurt_room_data["[current_area.condo_number]"]
	if(!room_entry || !current_area.reservation)
		return FALSE
	var/datum/turf_reservation/condo/current_reservation = current_area.reservation
	var/template_name = room_entry["template"]
	var/datum/map_template/condo/template = splurt_get_template(current_reservation, template_name)
	if(!template)
		return FALSE
	var/turf/storage_turf = splurt_ensure_storage_turf()
	if(!storage_turf)
		return FALSE
	var/list/storage = list()
	var/turf_number = 1
	var/obj/item/abstracthotelstorage/storage_obj = new(storage_turf)
	storage_obj.vars["roomNumber"] = current_area.condo_number
	storage_obj.parentSphere = current_area.parent_object
	storage_obj.name = "Condo [current_area.condo_number] Storage"

	var/turf/room_bottom_left = current_reservation.bottom_left_turfs[1]
	for(var/x in 0 to template.width - 1)
		for(var/y in 0 to template.height - 1)
			var/turf/T = locate(room_bottom_left.x + x, room_bottom_left.y + y, room_bottom_left.z)
			var/list/turf_contents = list()
			for(var/atom/movable/movable_atom in T)
				if(istype(movable_atom, /obj/effect))
					continue
				if(ismob(movable_atom) && !isliving(movable_atom))
					continue
				if(movable_atom.loc != T)
					continue
				if(length(movable_atom.GetComponents(/datum/component/atom_mounted)))
					continue
				if(istype(movable_atom, /obj/machinery/room_controller))
					var/obj/machinery/room_controller/controller = movable_atom
					controller.bluespace_box?.in_hotel_room = FALSE
					controller.bluespace_box?.creation_area = null
				turf_contents += movable_atom
				var/old_resistance = movable_atom.resistance_flags
				var/old_smoothing = movable_atom.smoothing_flags
				movable_atom.resistance_flags |= INDESTRUCTIBLE
				movable_atom.smoothing_flags = NONE
				movable_atom.forceMove(storage_obj)
				movable_atom.resistance_flags = old_resistance
				movable_atom.smoothing_flags = old_smoothing
			storage["[turf_number]"] = turf_contents
			turf_number++

	splurt_conservated_rooms["[current_area.condo_number]"] = list(
		"storage" = storage,
		"template" = template_name,
		"room_preferences" = null,
		"access_restrictions" = null,
		"is_ghost_cafe" = room_entry["is_ghost_cafe"],
	)
	var/list/room_preferences = room_entry["room_preferences"]
	var/list/access_restrictions = room_entry["access_restrictions"]
	splurt_conservated_rooms["[current_area.condo_number]"]["room_preferences"] = room_preferences ? room_preferences.Copy() : list()
	splurt_conservated_rooms["[current_area.condo_number]"]["access_restrictions"] = access_restrictions ? access_restrictions.Copy() : list()

	for(var/turf/turf_to_empty as anything in current_reservation.reserved_turfs)
		turf_to_empty.empty()
	active_condos -= "[current_area.condo_number]"
	splurt_room_data -= "[current_area.condo_number]"
	current_area.parent_object = null
	QDEL_NULL(current_area.reservation)
	return TRUE

/datum/controller/subsystem/condos/proc/splurt_restore_condo(condo_number, mob/user, parent_object)
	var/list/conserved_entry = splurt_conservated_rooms["[condo_number]"]
	if(!conserved_entry)
		return FALSE
	var/template_name = conserved_entry["template"]
	var/datum/map_template/condo/template = condo_templates[template_name]
	if(!template)
		template = splurt_get_default_template()
	if(!template)
		to_chat(user, span_warning("The room archive for [condo_number] is corrupted."))
		return FALSE

	var/datum/turf_reservation/condo/condo_reservation = SSmapping.request_turf_block_reservation(template.width, template.height, 1, reservation_type = /datum/turf_reservation/condo)
	if(!condo_reservation)
		to_chat(user, span_warning("Failed to reserve a room for you! Contact the technical concierge."))
		return FALSE
	var/turf/bottom_left = condo_reservation.bottom_left_turfs[1]
	if(!bottom_left)
		to_chat(user, span_warning("Failed to reserve a room for you! Contact the technical concierge."))
		return FALSE
	template.load(bottom_left)
	condo_reservation.condo_template = template

	// Clear fresh map atoms so conserved state can be restored cleanly.
	for(var/x in 0 to template.width - 1)
		for(var/y in 0 to template.height - 1)
			var/turf/T = locate(bottom_left.x + x, bottom_left.y + y, bottom_left.z)
			for(var/atom/movable/movable_atom in T)
				if(ismob(movable_atom) && !isliving(movable_atom))
					continue
				if(istype(movable_atom, /obj/effect))
					continue
				if(length(movable_atom.GetComponents(/datum/component/atom_mounted)))
					continue
				QDEL_LIST(movable_atom.contents)
				qdel(movable_atom)

	var/list/storage = conserved_entry["storage"]
	var/turf_number = 1
	for(var/x in 0 to template.width - 1)
		for(var/y in 0 to template.height - 1)
			var/turf/target_turf = locate(bottom_left.x + x, bottom_left.y + y, bottom_left.z)
			for(var/atom/movable/movable_atom in storage["[turf_number]"])
				if(istype(movable_atom.loc, /obj/item/abstracthotelstorage))
					var/old_resistance = movable_atom.resistance_flags
					movable_atom.resistance_flags |= INDESTRUCTIBLE
					movable_atom.forceMove(target_turf)
					movable_atom.resistance_flags = old_resistance
					if(istype(movable_atom, /obj/machinery/room_controller))
						var/obj/machinery/room_controller/controller = movable_atom
						controller.bluespace_box?.in_hotel_room = TRUE
						controller.bluespace_box?.creation_area = get_area(movable_atom.loc)
			turf_number++

	if(splurt_storage_turf)
		for(var/obj/item/abstracthotelstorage/storage_obj in splurt_storage_turf)
			if(storage_obj.vars["roomNumber"] == condo_number)
				qdel(storage_obj)

	active_condos["[condo_number]"] = condo_reservation
	link_condo_turfs(condo_reservation, condo_number, parent_object, user)
	splurt_room_data["[condo_number]"] = list(
		"reservation" = condo_reservation,
		"template" = template.name,
		"room_preferences" = null,
		"access_restrictions" = null,
		"is_ghost_cafe" = conserved_entry["is_ghost_cafe"],
	)
	var/list/conserved_room_preferences = conserved_entry["room_preferences"]
	var/list/conserved_access_restrictions = conserved_entry["access_restrictions"]
	splurt_room_data["[condo_number]"]["room_preferences"] = conserved_room_preferences ? conserved_room_preferences.Copy() : list()
	splurt_room_data["[condo_number]"]["access_restrictions"] = conserved_access_restrictions ? conserved_access_restrictions.Copy() : list()
	splurt_conservated_rooms -= "[condo_number]"
	splurt_link_room_controls(condo_number, condo_reservation)

	do_sparks(3, FALSE, get_turf(user))
	user.forceMove(locate(
		bottom_left.x + template.landing_zone_x_offset,
		bottom_left.y + template.landing_zone_y_offset,
		bottom_left.z,
	))
	return TRUE

/datum/controller/subsystem/condos/proc/splurt_modify_trusted_guests(room_number, mob/user, action, target_name)
	var/list/room_entry = splurt_room_data["[room_number]"]
	if(!room_entry)
		return FALSE
	var/list/access_restrictions = room_entry["access_restrictions"]
	if(!access_restrictions)
		return FALSE
	var/list/trusted_guests = access_restrictions["trusted_guests"]
	if(!trusted_guests)
		trusted_guests = list()
		access_restrictions["trusted_guests"] = trusted_guests
	switch(action)
		if("add")
			if(!user?.mind)
				return FALSE
			if(user.mind in trusted_guests)
				return FALSE
			if(user.mind == access_restrictions["room_owner"])
				return FALSE
			trusted_guests += user.mind
		if("remove")
			for(var/datum/mind/guest_mind in trusted_guests)
				if(guest_mind.name == target_name)
					trusted_guests -= guest_mind
					return TRUE
			return FALSE
		if("clear")
			if(!length(trusted_guests))
				return FALSE
			access_restrictions["trusted_guests"] = list()
		if("transfer")
			if(!user?.mind || access_restrictions["room_owner"] == user.mind)
				return FALSE
			access_restrictions["room_owner"] = user.mind
		else
			return FALSE
	return TRUE

/datum/controller/subsystem/condos/proc/splurt_handle_room_control_action(room_number, mob/user, action, list/params)
	var/list/room_data = splurt_room_data["[room_number]"]
	if(!room_data)
		return FALSE

	switch(action)
		if("toggle_visibility")
			room_data["room_preferences"]["visibility"] = !room_data["room_preferences"]["visibility"]
		if("toggle_status")
			var/current_status = room_data["room_preferences"]["status"]
			switch(current_status)
				if(ROOM_OPEN)
					room_data["room_preferences"]["status"] = ROOM_GUESTS_ONLY
				if(ROOM_GUESTS_ONLY)
					room_data["room_preferences"]["status"] = ROOM_CLOSED
				if(ROOM_CLOSED)
					room_data["room_preferences"]["status"] = ROOM_OPEN
		if("toggle_privacy")
			room_data["room_preferences"]["privacy"] = !room_data["room_preferences"]["privacy"]
		if("update_description")
			room_data["room_preferences"]["description"] = params["description"]
		if("update_name")
			room_data["room_preferences"]["name"] = params["name"]
		if("set_icon")
			room_data["room_preferences"]["icon"] = params["icon"]
		if("modify_trusted_guests")
			if(!splurt_modify_trusted_guests(room_number, user, params["action"], params["user"]))
				return FALSE
		if("transfer_ownership")
			if(!splurt_modify_trusted_guests(room_number, user, "transfer", null))
				return FALSE
		else
			return FALSE

	SEND_SIGNAL(src, COMSIG_HILBERT_ROOM_UPDATED, list("action" = action, "room" = room_number))
	return TRUE

/datum/controller/subsystem/condos/proc/splurt_link_room_controls(condo_number, datum/turf_reservation/condo/condo_reservation)
	if(!condo_reservation)
		return
	var/has_controller = FALSE
	for(var/turf/reserved_turf in condo_reservation.reserved_turfs)
		for(var/obj/machinery/room_controller/controller in reserved_turf.contents)
			splurt_setup_room_controller(controller, condo_number)
			has_controller = TRUE
	if(has_controller)
		return

	var/list/controller_placement = splurt_find_room_controller_placement(condo_reservation)
	if(!controller_placement)
		message_admins("Attention: Failed to place a condo room controller for room [condo_number].")
		return
	var/turf/controller_wall = controller_placement["wall"]
	var/controller_type = splurt_get_room_controller_type(controller_placement["dir"])
	var/obj/machinery/room_controller/controller = new controller_type(controller_wall)
	splurt_setup_room_controller(controller, condo_number)

/datum/controller/subsystem/condos/proc/splurt_get_reserved_turf_lookup(datum/turf_reservation/condo/condo_reservation)
	var/list/reserved_turfs = list()
	for(var/turf/reserved_turf as anything in condo_reservation.reserved_turfs)
		reserved_turfs[reserved_turf] = TRUE
	return reserved_turfs

/datum/controller/subsystem/condos/proc/splurt_setup_room_controller(obj/machinery/room_controller/controller, condo_number)
	if(!controller)
		return
	controller.room_number = condo_number
	if(controller.bluespace_box)
		controller.bluespace_box.in_hotel_room = TRUE
		controller.bluespace_box.creation_area = get_area(controller)
	controller.update_appearance()

/datum/controller/subsystem/condos/proc/splurt_get_room_controller_type(facing_dir)
	switch(facing_dir)
		if(NORTH)
			return /obj/machinery/room_controller/directional/north
		if(SOUTH)
			return /obj/machinery/room_controller/directional/south
		if(EAST)
			return /obj/machinery/room_controller/directional/east
		if(WEST)
			return /obj/machinery/room_controller/directional/west
	return /obj/machinery/room_controller

/datum/controller/subsystem/condos/proc/splurt_get_reachable_condo_turfs(datum/turf_reservation/condo/condo_reservation)
	var/list/reachable_turfs = list()
	var/list/reserved_turfs = splurt_get_reserved_turf_lookup(condo_reservation)
	var/list/search_queue = list()
	for(var/turf/closed/indestructible/hoteldoor/door in condo_reservation.reserved_turfs)
		for(var/direction in GLOB.cardinals)
			var/turf/adjacent_turf = get_step(door, direction)
			if(!reserved_turfs[adjacent_turf] || isclosedturf(adjacent_turf) || reachable_turfs[adjacent_turf])
				continue
			reachable_turfs[adjacent_turf] = TRUE
			search_queue += adjacent_turf

	while(length(search_queue))
		var/turf/current_turf = search_queue[1]
		search_queue.Cut(1, 2)
		for(var/direction in GLOB.cardinals)
			var/turf/next_turf = get_step(current_turf, direction)
			if(!reserved_turfs[next_turf] || isclosedturf(next_turf) || reachable_turfs[next_turf])
				continue
			reachable_turfs[next_turf] = TRUE
			search_queue += next_turf
	return reachable_turfs

/datum/controller/subsystem/condos/proc/splurt_find_room_controller_placement(datum/turf_reservation/condo/condo_reservation)
	var/list/door_turfs = list()
	for(var/turf/closed/indestructible/hoteldoor/door in condo_reservation.reserved_turfs)
		door_turfs += door
	if(!length(door_turfs))
		return

	var/list/reachable_turfs = splurt_get_reachable_condo_turfs(condo_reservation)
	if(!length(reachable_turfs))
		return

	var/best_distance = INFINITY
	var/turf/best_wall
	var/best_dir
	for(var/turf/possible_wall in condo_reservation.reserved_turfs)
		if(!iswallturf(possible_wall) || (locate(/obj/machinery/room_controller) in possible_wall))
			continue
		var/facing_dir
		for(var/direction in GLOB.cardinals)
			var/turf/adjacent_turf = get_step(possible_wall, direction)
			if(reachable_turfs[adjacent_turf])
				facing_dir = direction
				break
		if(!facing_dir)
			continue
		var/nearest_door_distance = INFINITY
		for(var/turf/door in door_turfs)
			nearest_door_distance = min(nearest_door_distance, get_dist(door, possible_wall))
		if(nearest_door_distance >= best_distance)
			continue
		best_distance = nearest_door_distance
		best_wall = possible_wall
		best_dir = facing_dir
	if(!best_wall)
		return
	return list("wall" = best_wall, "dir" = best_dir)

/datum/controller/subsystem/condos/proc/attempt_restore_condo(condo_number, datum/map_template/condo/template, mob/user, parent_object)
	if(!splurt_conservated_rooms["[condo_number]"])
		return FALSE
	var/list/room_entry = splurt_conservated_rooms["[condo_number]"]
	var/requested_is_ghost_cafe = splurt_get_parent_side(parent_object)
	if(!splurt_can_access_room(room_entry, user, requested_is_ghost_cafe))
		return TRUE
	if(splurt_restore_condo(condo_number, user, parent_object))
		to_chat(user, span_notice("You feel a strange sense of déjà vu."))
		return TRUE
	return FALSE

/datum/controller/subsystem/condos/proc/on_condo_created(condo_number, datum/turf_reservation/condo/condo_reservation, mob/user, parent_object)
	var/template_name = condo_reservation?.condo_template?.name
	if(!template_name)
		var/datum/map_template/condo/default_template = splurt_get_default_template()
		template_name = default_template?.name || "Condo"
	splurt_room_data["[condo_number]"] = list(
		"reservation" = condo_reservation,
		"template" = template_name,
		"room_preferences" = list(
			"status" = ROOM_OPEN,
			"visibility" = ROOM_VISIBLE,
			"privacy" = ROOM_GUESTS_HIDDEN,
			"description" = null,
			"name" = template_name,
			"icon" = "door-open",
		),
		"access_restrictions" = list(
			"room_owner" = user?.mind,
			"trusted_guests" = list(),
		),
		"is_ghost_cafe" = splurt_get_parent_side(parent_object),
	)
	splurt_conservated_rooms -= "[condo_number]"
	splurt_link_room_controls(condo_number, condo_reservation)

/datum/controller/subsystem/condos/proc/on_condo_joined(condo_number, datum/turf_reservation/condo/condo_reservation, mob/user)
	if(!user?.mind || !condo_reservation)
		return
	var/turf/condo_bottom_left = condo_reservation.bottom_left_turfs[1]
	var/area/misc/condo/current_area = get_area(condo_bottom_left)
	if(!current_area?.parent_object)
		return
	for(var/turf/closed/indestructible/hoteldoor/door in condo_reservation.reserved_turfs)
		door.entry_points[user.mind] = current_area.parent_object

/datum/controller/subsystem/condos/proc/should_preserve_condo(area/misc/condo/current_area, atom/movable/gone)
	if(!splurt_room_data["[current_area.condo_number]"])
		return FALSE
	log_game("[gone] has left condo [current_area.condo_number] (SPLURT conservation).")
	return splurt_conservate_condo(current_area)
