/datum/toolgun_mode
	var/name = "Default mode"
	var/desc = "Coder button."
	var/mode_key = "generic"
	var/obj/item/toolgun/our_tool
	var/tgui_ui_id = "Toolgun"

/datum/toolgun_mode/proc/on_selected(mob/user)
	to_chat(user, span_notice(desc))

/datum/toolgun_mode/proc/main_act(atom/target, mob/user)

/datum/toolgun_mode/proc/secondnary_act(atom/target, mob/user)

/datum/toolgun_mode/proc/use_act(mob/user)
	ui_interact(user)

/datum/toolgun_mode/ui_state(mob/user)
	return our_tool?.ui_state(user)

/datum/toolgun_mode/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, our_tool ? our_tool : user, ui)
	if(!ui)
		ui = new(user, our_tool ? our_tool : user, tgui_ui_id)
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/toolgun_mode/ui_data(mob/user)
	return list(
		"mode_name" = name,
		"mode_desc" = desc,
		"mode_key" = mode_key,
	)

/datum/toolgun_mode/proc/param_to_bool(value)
	if(isnum(value))
		return !!value
	if(istext(value))
		var/value_text = lowertext(trimtext(value))
		return value_text == "1" || value_text == "true" || value_text == "yes" || value_text == "on"
	return FALSE

/datum/toolgun_mode/proc/set_indestructible(atom/target, should_set)
	if(!target || !("resistance_flags" in target.vars))
		return
	if(should_set)
		target.resistance_flags |= INDESTRUCTIBLE
	else
		target.resistance_flags &= ~INDESTRUCTIBLE

/datum/toolgun_mode/spawning
	name = "Spawning mode"
	desc = "Generic object spawning mode."
	mode_key = "spawning"

	var/selected_type_path
	var/datum/selected_type
	var/current_search = ""
	var/current_browse_path
	var/loaded_limit = 80
	var/page_size = 80
	var/create_spawn_effect = TRUE

	var/use_custom_color = FALSE
	var/custom_color = "#FFFFFF"
	var/custom_density = FALSE
	var/custom_opacity = FALSE
	var/custom_indestructible = FALSE
	var/list/type_blacklist = list()

	COOLDOWN_DECLARE(seach_cd)

	var/static/list/cached_type_nodes_by_key
	var/static/list/cached_entries_by_key

/datum/toolgun_mode/spawning/New()
	. = ..()
	if(!selected_type)
		selected_type = get_default_type()
	if(!selected_type_path)
		selected_type_path = "[selected_type]"
	if(!current_browse_path)
		current_browse_path = get_root_path_text()
	sync_settings_from_selected_type()

/datum/toolgun_mode/spawning/on_selected(mob/user)
	. = ..()
	current_search = ""

/datum/toolgun_mode/spawning/proc/get_root_type()
	return /obj

/datum/toolgun_mode/spawning/proc/get_default_type()
	return get_root_type()

/datum/toolgun_mode/spawning/proc/get_root_path_text()
	return "[get_root_type()]"

/datum/toolgun_mode/spawning/proc/get_entry_list_key()
	return "objects"

/datum/toolgun_mode/spawning/proc/get_selected_data_key()
	return "selected_type"

/datum/toolgun_mode/spawning/proc/get_select_action_name()
	return "select_type"

/datum/toolgun_mode/spawning/proc/get_spawn_action_name()
	return "spawn_here"

/datum/toolgun_mode/spawning/proc/get_cache_key()
	return mode_key

/datum/toolgun_mode/spawning/proc/is_blacklisted_type(typepath)
	if(!typepath || !length(type_blacklist))
		return FALSE
	for(var/blacklisted_type in type_blacklist)
		if(ispath(typepath, blacklisted_type))
			return TRUE
	return FALSE

/datum/toolgun_mode/spawning/proc/build_type_cache()
	if(!cached_type_nodes_by_key)
		cached_type_nodes_by_key = list()
	if(!cached_entries_by_key)
		cached_entries_by_key = list()

	var/cache_key = get_cache_key()
	if(cached_type_nodes_by_key[cache_key] && cached_entries_by_key[cache_key])
		return

	var/list/type_nodes = list()
	var/list/object_entries = list()
	var/root_type = get_root_type()

	for(var/atom/entry_path as anything in subtypesof(root_type))
		if(is_blacklisted_type(entry_path))
			continue
		var/path_text = "[entry_path]"
		if(!length(path_text))
			continue

		var/list/path_parts = splittext(path_text, "/")
		var/current_path = ""
		var/parent_path = ""
		for(var/path_part in path_parts)
			if(!length(path_part))
				continue
			current_path += "/[path_part]"
			if(!type_nodes[current_path])
				type_nodes[current_path] = list(
					"id" = current_path,
					"parent" = parent_path,
					"name" = path_part,
				)
			parent_path = current_path

		object_entries += list(list(
			"type" = path_text,
			"name" = "[initial(entry_path.name)]",
			"icon" = "[initial(entry_path.icon)]",
			"icon_state" = "[initial(entry_path.icon_state)]",
		))

	cached_type_nodes_by_key[cache_key] = type_nodes
	cached_entries_by_key[cache_key] = object_entries

/datum/toolgun_mode/spawning/proc/get_cached_type_nodes()
	build_type_cache()
	return cached_type_nodes_by_key[get_cache_key()]

/datum/toolgun_mode/spawning/proc/get_cached_entries()
	build_type_cache()
	return cached_entries_by_key[get_cache_key()]

/datum/toolgun_mode/spawning/proc/sync_settings_from_selected_type()
	if(!selected_type)
		return
	if("density" in selected_type.vars)
		custom_density = !!selected_type.vars["density"]
	if("opacity" in selected_type.vars)
		custom_opacity = !!selected_type.vars["opacity"]
	if("resistance_flags" in selected_type.vars)
		custom_indestructible = !!(selected_type.vars["resistance_flags"] & INDESTRUCTIBLE)
	if("color" in selected_type.vars)
		var/new_color = "[selected_type.vars["color"]]"
		if(length(new_color))
			custom_color = new_color

/datum/toolgun_mode/spawning/ui_static_data(mob/user)
	return list(
		"type_nodes" = get_cached_type_nodes(),
		"objects_all" = get_cached_entries(),
	)

/datum/toolgun_mode/spawning/ui_data(mob/user)
	. = ..()
	sync_settings_from_selected_type()
	.[get_selected_data_key()] = selected_type_path
	.["browse_path"] = current_browse_path
	.["search"] = current_search
	.["loaded_limit"] = loaded_limit
	.["page_size"] = page_size
	.["use_custom_color"] = use_custom_color
	.["custom_color"] = custom_color
	.["custom_density"] = custom_density
	.["custom_opacity"] = custom_opacity
	.["custom_indestructible"] = custom_indestructible

/datum/toolgun_mode/spawning/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(action == "browse_to")
		var/path_to_browse = trimtext(params["path"])
		var/root_path = get_root_path_text()
		if(length(path_to_browse) && (path_to_browse == root_path || text2path(path_to_browse)))
			current_browse_path = path_to_browse
			loaded_limit = page_size
		return TRUE

	else if(action == get_select_action_name())
		var/path_to_select = params["path"]
		var/type_to_select = text2path(path_to_select)
		var/root_type = get_root_type()
		if(type_to_select && ispath(type_to_select, root_type))
			selected_type_path = path_to_select
			selected_type = type_to_select
			sync_settings_from_selected_type()
		return TRUE

	else if((action == "set_search") && COOLDOWN_FINISHED(src, seach_cd))
		current_search = trimtext(params["search"])
		if(length(current_search) < 3)
			return TRUE

		COOLDOWN_START(src, seach_cd, 4 SECONDS)
		loaded_limit = page_size
		return TRUE

	else if(action == "load_more")
		if(!length(current_search))
			loaded_limit += page_size
		return TRUE

	else if(action == get_spawn_action_name())
		return main_act(get_turf(usr), usr)

	else if(action == "set_custom_color")
		var/new_color = trimtext(params["color"])
		if(length(new_color))
			custom_color = new_color
		return TRUE

	else if(action == "pick_custom_color")
		var/chosen_color = tgui_color_picker(usr, "Select spawn color", "Toolgun spawn mode", custom_color)
		if(chosen_color)
			custom_color = chosen_color
		return TRUE

	else if(action == "toggle_use_custom_color")
		use_custom_color = !use_custom_color
		return TRUE

	else if(action == "toggle_custom_density")
		custom_density = !custom_density
		return TRUE

	else if(action == "toggle_custom_opacity")
		custom_opacity = !custom_opacity
		return TRUE

	else if(action == "toggle_custom_indestructible")
		custom_indestructible = !custom_indestructible
		return TRUE

	return ..()

/datum/toolgun_mode/spawning/proc/apply_customization(atom/created_atom)
	if(!created_atom)
		return
	if(use_custom_color && ("color" in created_atom.vars))
		created_atom.color = custom_color
	if("density" in created_atom.vars)
		created_atom.density = custom_density
	if("opacity" in created_atom.vars)
		created_atom.opacity = custom_opacity
	set_indestructible(created_atom, custom_indestructible)

/datum/toolgun_mode/spawning/main_act(atom/target, mob/user)
	if(!selected_type)
		return FALSE
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE
	var/atom/created_atom = new selected_type(target_turf)
	if(!created_atom)
		return FALSE
	apply_customization(created_atom)
	after_spawn(created_atom, user)
	return TRUE

/datum/toolgun_mode/spawning/proc/after_spawn(atom/created_atom, mob/user)
	if(create_spawn_effect)
		var/init_alpha = created_atom.alpha
		var/init_color = created_atom.color

		created_atom.color = COLOR_FRENCH_BLUE
		created_atom.alpha = 100

		animate(created_atom, alpha = init_alpha, color = init_color, time = 5)
	return
