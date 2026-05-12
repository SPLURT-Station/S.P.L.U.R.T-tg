/proc/cyborg_character_ensure_model_list()
	if(length(GLOB.cyborg_model_list))
		return GLOB.cyborg_model_list

	GLOB.cyborg_model_list = list(
		"Engineering" = /obj/item/robot_model/engineering,
		"Medical" = /obj/item/robot_model/medical,
		"Cargo" = /obj/item/robot_model/cargo,
		"Miner" = /obj/item/robot_model/miner,
		"Janitor" = /obj/item/robot_model/janitor,
		"Service" = /obj/item/robot_model/service,
		"Research" = /obj/item/robot_model/sci,
	)
	if(!CONFIG_GET(flag/disable_peaceborg))
		GLOB.cyborg_model_list["Peacekeeper"] = /obj/item/robot_model/peacekeeper
	if(!CONFIG_GET(flag/disable_secborg) || HAS_TRAIT(SSstation, STATION_TRAIT_HOS_AI))
		GLOB.cyborg_model_list["Security"] = /obj/item/robot_model/security

	for(var/model_name in GLOB.cyborg_model_list)
		GLOB.cyborg_all_models_icon_list[model_name] = list()

	return GLOB.cyborg_model_list

/proc/cyborg_character_build_model_skin_data(obj/item/robot_model/model, list/skin_details = null)
	var/icon_file = model?.cyborg_icon_override || 'modular_skyrat/master_files/icons/mob/robots.dmi'
	var/icon_state = model?.cyborg_base_icon || "robot"
	var/canvas_size = 0
	var/list/skin_features = list()

	if(islist(skin_details))
		if(!isnull(skin_details[SKIN_ICON]))
			icon_file = skin_details[SKIN_ICON]
		if(!isnull(skin_details[SKIN_ICON_STATE]))
			icon_state = skin_details[SKIN_ICON_STATE]
		if(islist(skin_details[SKIN_FEATURES]))
			var/list/skin_feature_list = skin_details[SKIN_FEATURES]
			skin_features = skin_feature_list.Copy()
			if((TRAIT_R_BIG in skin_feature_list) || (TRAIT_R_TALL in skin_feature_list))
				canvas_size = 2
			else if(TRAIT_R_WIDE in skin_feature_list)
				canvas_size = 1

	return list(
		"icon" = icon_file,
		"icon_state" = icon_state,
		"canvas_size" = canvas_size,
		"skin_features" = skin_features,
	)

/proc/cyborg_character_get_model_preview_states(model_name, variant_name = null)
	var/list/model_snapshot = cyborg_character_ensure_model_snapshot(model_name)
	var/icon_file = model_snapshot["default_icon"] || 'modular_skyrat/master_files/icons/mob/robots.dmi'
	var/icon_state = model_snapshot["default_icon_state"] || "robot"
	var/list/model_skins = model_snapshot["variant_data"]
	if(!variant_name)
		variant_name = cyborg_character_get_default_model_variant(model_name)
	if(islist(model_skins) && (variant_name in model_skins))
		var/list/variant_data = model_skins[variant_name]
		if(!isnull(variant_data["icon"]))
			icon_file = variant_data["icon"]
		if(!isnull(variant_data["icon_state"]))
			icon_state = variant_data["icon_state"]

	var/list/icon_states = icon_states_fast(icon_file) || list()
	var/list/preview_states = list()
	for(var/state_name in icon_states)
		if(copytext(state_name, 1, length(icon_state) + 1) != icon_state)
			continue
		if(state_name in preview_states)
			continue
		preview_states += state_name

	if(!length(preview_states))
		preview_states += icon_state

	return preview_states

/proc/cyborg_character_get_preview_state_token_from_icon_state(selected_state)
	if(!istext(selected_state) || !length(selected_state))
		return "idle"
	if(findtext(selected_state, "-rest_deep"))
		return "rest_deep"
	if(findtext(selected_state, "-bellyup"))
		return "bellyup"
	if(findtext(selected_state, "-sit"))
		return "sit"
	if(findtext(selected_state, "-rest"))
		return "rest"
	return "idle"

/proc/cyborg_character_get_model_preview_state_options(model_name, variant_name = null)
	var/list/model_snapshot = cyborg_character_ensure_model_snapshot(model_name)
	var/icon_file = model_snapshot["default_icon"] || 'modular_skyrat/master_files/icons/mob/robots.dmi'
	var/icon_state = model_snapshot["default_icon_state"] || "robot"
	var/list/model_skins = model_snapshot["variant_data"]
	if(!variant_name)
		variant_name = cyborg_character_get_default_model_variant(model_name)
	if(islist(model_skins) && (variant_name in model_skins))
		var/list/variant_data = model_skins[variant_name]
		if(!isnull(variant_data["icon"]))
			icon_file = variant_data["icon"]
		if(!isnull(variant_data["icon_state"]))
			icon_state = variant_data["icon_state"]

	var/list/icon_states = icon_states_fast(icon_file) || list()
	var/list/options = list()
	var/list/base_state_entries = cyborg_character_get_state_metadata_entries(icon_file, icon_state)

	if(icon_state in icon_states)
		options += list(list(
			"value" = "idle",
			"label" = "Idle",
			"icon_state" = icon_state,
			"movement" = FALSE,
		))

	var/has_movement = FALSE
	for(var/list/state_data as anything in base_state_entries)
		if(state_data?["movement"])
			has_movement = TRUE
			break
	if(has_movement)
		options += list(list(
			"value" = "moving",
			"label" = "Moving",
			"icon_state" = icon_state,
			"movement" = TRUE,
		))

	var/list/rest_state_specs = list(
		list("value" = "bellyup", "label" = "Belly Up", "suffix" = "-bellyup"),
		list("value" = "rest", "label" = "Rest", "suffix" = "-rest"),
		list("value" = "sit", "label" = "Sit", "suffix" = "-sit"),
		list("value" = "rest_deep", "label" = "Deep Rest", "suffix" = "-rest_deep"),
	)
	for(var/list/spec as anything in rest_state_specs)
		var/state_name = "[icon_state][spec["suffix"]]"
		if(!(state_name in icon_states))
			continue
		options += list(list(
			"value" = spec["value"],
			"label" = spec["label"],
			"icon_state" = state_name,
			"movement" = FALSE,
		))

	return options

/proc/cyborg_character_get_preview_state_option_map(model_name, variant_name = null)
	var/list/state_options = cyborg_character_get_model_preview_state_options(model_name, variant_name)
	var/list/option_map = list()
	for(var/list/state_option as anything in state_options)
		var/value = state_option["value"]
		if(istext(value) && length(value))
			option_map[value] = state_option
	return option_map

/proc/cyborg_character_get_preview_scale(canvas_size)
	var/native_size = 32 + (32 * canvas_size)
	return max(1, FLOOR(384 / native_size, 1))

/proc/cyborg_character_get_allowed_sizes()
	return list(RESIZE_SMALL, RESIZE_NORMAL, 1.6, RESIZE_BIG, 2.5)

/proc/cyborg_character_get_genital_slots()
	return list(ORGAN_SLOT_PENIS, ORGAN_SLOT_SHEATH, ORGAN_SLOT_TESTICLES, ORGAN_SLOT_VAGINA, ORGAN_SLOT_BREASTS)

/proc/cyborg_character_sanitize_size(size)
	var/size_number = text2num("[size]")
	if(isnull(size_number))
		return RESIZE_NORMAL
	var/list/allowed_sizes = cyborg_character_get_allowed_sizes()
	var/closest_size = allowed_sizes[1]
	var/closest_distance = abs(size_number - closest_size)
	for(var/allowed_size in allowed_sizes)
		var/distance = abs(size_number - allowed_size)
		if(distance < closest_distance)
			closest_size = allowed_size
			closest_distance = distance
	return closest_size

/atom/movable/screen/background/cyborg_character_preview_background
	name = "cyborg preview background"
	icon = 'icons/hud/map_backgrounds.dmi'
	icon_state = "clear"
	layer = GAME_PLANE
	plane = GAME_PLANE
	del_on_map_removal = FALSE

/mob/living/silicon/robot/cyborg_character_catalog_host
	name = "cyborg character catalog host"
	invisibility = INVISIBILITY_ABSTRACT
	cell = null
	radio = null

/mob/living/silicon/robot/cyborg_character_catalog_host/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1
	if(LAZYLEN(faction))
		faction = string_list(faction)
	simulated_genitals = list()
	toggleable_cyborg_genitals = list()
	cyborg_genital_layout = list()
	cyborg_genital_sprite_choices = list()
	cyborg_genital_arousal_states = list()
	cyborg_genital_image_holders = list()
	current_size = 1
	return INITIALIZE_HINT_NORMAL

/proc/cyborg_character_get_rendered_genital_icon_data(mob/living/silicon/robot/owner_robot, mutable_appearance/genital_overlay, organ_slot, overlay_subindex, render_dir)
	if(!owner_robot || !genital_overlay)
		return null

	var/obj/effect/client_image_holder/cyborg_genital/preview_holder = new(owner_robot, owner_robot, image(genital_overlay), list(), organ_slot, overlay_subindex)
	if(owner_robot.can_cyborg_genital_animate(organ_slot))
		var/list/idle_offsets = owner_robot.get_cyborg_genital_idle_offsets()
		var/list/idle_frame_delays = owner_robot.get_cyborg_automated_idle_frame_delays()
		if(length(idle_offsets) && length(idle_frame_delays))
			preview_holder.play_cyborg_movement_animation(idle_offsets, idle_frame_delays, 0, FALSE, "idle")

	var/image/render_image = preview_holder.generate_image()
	if(!render_image)
		qdel(preview_holder)
		return null

	var/matrix/render_transform = render_image.transform ? matrix(render_image.transform) : null
	var/image/flat_render_image = image(render_image)
	flat_render_image.transform = null
	var/icon/flat_icon = getFlatIcon(flat_render_image, render_dir, no_anim = TRUE)
	if(!isicon(flat_icon))
		qdel(preview_holder)
		return null

	var/list/transformed_icon_data = preview_holder.apply_cyborg_genital_appearance_transform(flat_icon, render_transform)
	var/icon/transformed_icon = transformed_icon_data["icon"]
	if(!isicon(transformed_icon))
		qdel(preview_holder)
		return null

	var/list/rendered_data = list(
		"icon" = transformed_icon,
		"pixel_x" = (render_image.pixel_x || 0) + (transformed_icon_data["pixel_x"] || 0),
		"pixel_y" = (render_image.pixel_y || 0) + (transformed_icon_data["pixel_y"] || 0),
		"width" = transformed_icon.Width(),
		"height" = transformed_icon.Height(),
	)
	qdel(preview_holder)
	return rendered_data

/proc/cyborg_character_apply_body_scale_to_rendered_genital(mob/living/silicon/robot/owner_robot, list/rendered_genital_data, body_scale)
	if(!owner_robot || !islist(rendered_genital_data))
		return null

	var/icon/rendered_genital_icon = rendered_genital_data["icon"]
	if(!isicon(rendered_genital_icon))
		return null

	body_scale = max(body_scale || RESIZE_NORMAL, 0.25)
	var/original_width = max(rendered_genital_icon.Width(), 1)
	var/original_height = max(rendered_genital_icon.Height(), 1)
	var/target_width = max(round(original_width * body_scale), 1)
	var/target_height = max(round(original_height * body_scale), 1)
	var/icon/scaled_icon = rendered_genital_icon
	if(target_width != original_width || target_height != original_height)
		scaled_icon = owner_robot.scale_cyborg_icon_nearest_neighbor(rendered_genital_icon, target_width, target_height)
	if(!isicon(scaled_icon))
		return null

	return list(
		"icon" = scaled_icon,
		"pixel_x" = (rendered_genital_data["pixel_x"] || 0) + round((original_width - scaled_icon.Width()) * 0.5),
		"pixel_y" = (rendered_genital_data["pixel_y"] || 0) + round((original_height - scaled_icon.Height()) * 0.5),
		"width" = scaled_icon.Width(),
		"height" = scaled_icon.Height(),
	)

/mob/living/silicon/robot/cyborg_character_catalog_host/Destroy()
	if(ispath(cell))
		cell = null
	if(ispath(radio))
		radio = null
	return ..()

/proc/cyborg_character_ensure_model_snapshot(model_name)
	var/static/list/model_snapshots = null
	if(!isnull(model_snapshots) && (model_name in model_snapshots))
		return model_snapshots[model_name]

	if(isnull(model_snapshots))
		model_snapshots = list()

	var/list/models = cyborg_character_ensure_model_list()
	var/model_type = models[model_name]
	var/list/model_snapshot = list(
		"variant_names" = list(),
		"variant_data" = list(),
		"default_icon" = 'modular_skyrat/master_files/icons/mob/robots.dmi',
		"default_icon_state" = "robot",
	)

	if(isnull(model_type))
		model_snapshots[model_name] = model_snapshot
		return model_snapshot

	var/mob/living/silicon/robot/cyborg_character_catalog_host/catalog_host = new()
	var/obj/item/robot_model/model = new model_type(catalog_host)

	if(QDELETED(model) || QDELETED(catalog_host))
		qdel(model)
		qdel(catalog_host)
		model_snapshots[model_name] = model_snapshot
		return model_snapshot

	model_snapshot["default_icon"] = model.cyborg_icon_override || 'modular_skyrat/master_files/icons/mob/robots.dmi'
	model_snapshot["default_icon_state"] = model.cyborg_base_icon || "robot"

	var/list/variant_names = model_snapshot["variant_names"]
	var/list/variant_data = model_snapshot["variant_data"]
	if(islist(model.borg_skins) && length(model.borg_skins))
		for(var/variant_name in model.borg_skins)
			var/list/skin_details = model.borg_skins[variant_name]
			variant_names += variant_name
			variant_data[variant_name] = cyborg_character_build_model_skin_data(model, skin_details)
	else
		variant_names += model_name
		variant_data[model_name] = cyborg_character_build_model_skin_data(model)

	qdel(model)
	qdel(catalog_host)

	model_snapshots[model_name] = model_snapshot
	return model_snapshot

/proc/cyborg_character_ensure_model_catalog()
	var/static/list/model_catalog = null
	if(length(model_catalog))
		return model_catalog

	model_catalog = list()
	var/list/models = cyborg_character_ensure_model_list()
	for(var/model_name in models)
		model_catalog[model_name] = cyborg_character_get_model_variant_names(model_name).Copy()

	return model_catalog

/proc/cyborg_character_get_model_names()
	var/list/model_names = list()
	for(var/model_name in cyborg_character_ensure_model_list())
		model_names += model_name
	return model_names

/proc/cyborg_character_get_model_variant_names(model_name)
	RETURN_TYPE(/list)
	var/list/model_snapshot = cyborg_character_ensure_model_snapshot(model_name)
	var/list/variant_names = model_snapshot["variant_names"]
	if(length(variant_names))
		return variant_names.Copy()
	return list(model_name)

/proc/cyborg_character_get_default_model_variant(model_name)
	var/list/variant_names = cyborg_character_get_model_variant_names(model_name)
	if(length(variant_names))
		return variant_names[1]
	return model_name

/proc/cyborg_character_get_model_icon_data(model_name, variant_name = null)
	var/list/model_snapshot = cyborg_character_ensure_model_snapshot(model_name)
	var/icon_file = model_snapshot["default_icon"] || 'modular_skyrat/master_files/icons/mob/robots.dmi'
	var/icon_state = model_snapshot["default_icon_state"] || "robot"
	var/canvas_size = 0
	var/list/skin_features = list()
	var/list/model_skins = model_snapshot["variant_data"]
	if(!variant_name)
		variant_name = cyborg_character_get_default_model_variant(model_name)
	if(islist(model_skins) && (variant_name in model_skins))
		var/list/variant_data = model_skins[variant_name]
		if(!isnull(variant_data["icon"]))
			icon_file = variant_data["icon"]
		if(!isnull(variant_data["icon_state"]))
			icon_state = variant_data["icon_state"]
		if(!isnull(variant_data["canvas_size"]))
			canvas_size = variant_data["canvas_size"]
		if(islist(variant_data["skin_features"]))
			var/list/variant_skin_features = variant_data["skin_features"]
			skin_features = variant_skin_features.Copy()
	return list(
		"icon" = icon_file,
		"icon_state" = icon_state,
		"canvas_size" = canvas_size,
		"skin_features" = skin_features,
		"states" = cyborg_character_get_model_preview_states(model_name, variant_name),
		"preview_width" = 32 + (32 * canvas_size),
		"preview_height" = 32 + (32 * canvas_size),
	)

/proc/cyborg_character_get_preview_rest_stage_key(selected_state)
	if(!istext(selected_state) || !length(selected_state))
		return null
	if(selected_state == "rest_deep" || findtext(selected_state, "-rest_deep"))
		return "rest_deep"
	if(selected_state == "bellyup" || findtext(selected_state, "-bellyup"))
		return "bellyup"
	if(selected_state == "sit" || findtext(selected_state, "-sit"))
		return "sit"
	if(selected_state == "rest" || findtext(selected_state, "-rest"))
		return "rest"
	return null

/proc/cyborg_character_get_preview_direction_key(selected_state, selected_dir)
	var/rest_stage_key = cyborg_character_get_preview_rest_stage_key(selected_state)
	if(rest_stage_key)
		return rest_stage_key
	return cyborg_character_dir_to_text(selected_dir)

/proc/cyborg_character_get_preview_robot_resting(selected_state)
	switch(cyborg_character_get_preview_rest_stage_key(selected_state))
		if("rest")
			return ROBOT_REST_NORMAL
		if("sit")
			return ROBOT_REST_SITTING
		if("bellyup")
			return ROBOT_REST_BELLY_UP
		if("rest_deep")
			return ROBOT_REST_SLEEP
	return FALSE

/proc/cyborg_character_get_state_metadata_entries(icon_file, state_name)
	if(!icon_file || !istext(state_name) || !length(state_name))
		return null

	var/list/metadata = icon_metadata(icon_file)
	if(!islist(metadata) || !islist(metadata["states"]))
		return null

	var/list/state_entries = list()
	for(var/list/state_data as anything in metadata["states"])
		if(state_data?["name"] == state_name)
			state_entries += list(state_data)
	return length(state_entries) ? state_entries : null

/proc/cyborg_character_get_preview_marker_point_offset(list/marker_data, selected_state, selected_dir)
	if(!islist(marker_data))
		return null

	var/direction_key = cyborg_character_get_preview_direction_key(selected_state, selected_dir)
	var/list/marker_point = null
	var/rest_stage_key = cyborg_character_get_preview_rest_stage_key(selected_state)
	if(rest_stage_key)
		marker_point = marker_data["rest_marker_point_by_stage"]?[rest_stage_key]?[direction_key]
		if(!islist(marker_point))
			marker_point = marker_data["rest_marker_point_by_stage"]?[rest_stage_key]?["south"]
	if(!islist(marker_point))
		marker_point = marker_data["marker_point_by_direction"]?[direction_key]
	if(!islist(marker_point))
		marker_point = marker_data["marker_point_by_direction"]?["south"]
	if(!islist(marker_point))
		return null

	var/marker_point_x = marker_point["pixel_x"] || 0
	var/marker_point_y = marker_point["pixel_y"] || 0
	return list(
		"pixel_x" = round(marker_point_x),
		"pixel_y" = round(marker_point_y),
	)

/proc/cyborg_character_get_preview_marker_anchor_offset(list/marker_data, selected_state, selected_dir)
	if(!islist(marker_data))
		return null

	var/direction_key = cyborg_character_get_preview_direction_key(selected_state, selected_dir)
	var/list/marker_anchor = null
	var/rest_stage_key = cyborg_character_get_preview_rest_stage_key(selected_state)
	if(rest_stage_key)
		marker_anchor = marker_data["rest_anchor_by_stage"]?[rest_stage_key]?[direction_key]
		if(!islist(marker_anchor))
			marker_anchor = marker_data["rest_anchor_by_stage"]?[rest_stage_key]?["south"]
	if(!islist(marker_anchor))
		marker_anchor = marker_data["anchor_by_direction"]?[direction_key]
	if(!islist(marker_anchor))
		marker_anchor = marker_data["anchor_by_direction"]?["south"]
	if(!islist(marker_anchor))
		return null

	var/marker_anchor_x = marker_anchor["pixel_x"] || 0
	var/marker_anchor_y = marker_anchor["pixel_y"] || 0
	return list(
		"pixel_x" = round(marker_anchor_x),
		"pixel_y" = round(marker_anchor_y),
	)

/proc/cyborg_character_get_preview_body_offset(model_data, selected_state, selected_dir, list/marker_data = null)
	var/canvas_width = model_data?["preview_width"] || ICON_SIZE_X
	var/canvas_height = model_data?["preview_height"] || ICON_SIZE_Y
	var/list/marker_point_offset = cyborg_character_get_preview_marker_point_offset(marker_data, selected_state, selected_dir)
	var/list/marker_anchor_offset = cyborg_character_get_preview_marker_anchor_offset(marker_data, selected_state, selected_dir)
	var/pixel_x = round(max(canvas_width - ICON_SIZE_X, 0) * 0.5)
	var/pixel_y = round(max(canvas_height - ICON_SIZE_Y, 0) * 0.5)
	var/marker_point_x = 0
	var/marker_point_y = 0
	var/marker_anchor_x = 0
	var/marker_anchor_y = 0
	if(islist(marker_point_offset))
		marker_point_x = marker_point_offset["pixel_x"] || 0
		marker_point_y = marker_point_offset["pixel_y"] || 0
	if(islist(marker_anchor_offset))
		marker_anchor_x = marker_anchor_offset["pixel_x"] || 0
		marker_anchor_y = marker_anchor_offset["pixel_y"] || 0
		pixel_x = round(marker_point_x - marker_anchor_x)
		pixel_y = round(marker_point_y - marker_anchor_y)
	return list(
		"pixel_x" = pixel_x,
		"pixel_y" = pixel_y,
		"direction_key" = cyborg_character_get_preview_direction_key(selected_state, selected_dir),
	)

/proc/cyborg_character_dir_to_text(dir_value)
	switch(dir_value)
		if(NORTH)
			return "north"
		if(SOUTH)
			return "south"
		if(EAST)
			return "east"
		if(WEST)
			return "west"
	return "south"

/proc/cyborg_character_text_to_dir(dir_text)
	switch(LOWER_TEXT("[dir_text]"))
		if("north")
			return NORTH
		if("east")
			return EAST
		if("west")
			return WEST
	return SOUTH

/proc/cyborg_character_get_direction_keys()
	return list("south", "north", "east", "west", "rest", "sit", "bellyup", "rest_deep")

/proc/cyborg_character_get_base_direction_entries()
	return list(
		list("value" = "south", "label" = "South"),
		list("value" = "north", "label" = "North"),
		list("value" = "east", "label" = "East"),
		list("value" = "west", "label" = "West"),
	)

/proc/cyborg_character_get_editable_direction_entries(list/state_options)
	var/list/direction_entries = cyborg_character_get_base_direction_entries()
	var/list/seen_keys = list("south" = TRUE, "north" = TRUE, "east" = TRUE, "west" = TRUE)
	for(var/list/state_option as anything in state_options)
		var/direction_key = cyborg_character_get_preview_rest_stage_key(state_option?["value"])
		if(!direction_key || seen_keys[direction_key])
			continue
		direction_entries += list(list(
			"value" = direction_key,
			"label" = state_option?["label"] || capitalize(direction_key),
		))
		seen_keys[direction_key] = TRUE
	return direction_entries

/proc/cyborg_character_get_editable_direction_keys(list/state_options)
	var/list/direction_keys = list()
	for(var/list/direction_entry as anything in cyborg_character_get_editable_direction_entries(state_options))
		var/direction_key = direction_entry["value"]
		if(istext(direction_key) && length(direction_key))
			direction_keys += direction_key
	return direction_keys

/proc/cyborg_character_get_default_direction_entry()
	return list(
		"visible" = TRUE,
		"pixel_x" = 0,
		"pixel_y" = 0,
		"rotation" = 0,
		"priority" = 5,
	)

/proc/cyborg_character_get_default_layout_entry()
	var/list/advanced = list()
	for(var/direction_key in cyborg_character_get_direction_keys())
		advanced[direction_key] = cyborg_character_get_default_direction_entry()
	return list(
		"pixel_x" = 0,
		"pixel_y" = 0,
		"rotation" = 0,
		"scale" = 1,
		"colors" = list(null, null, null),
		"advanced" = advanced,
	)

/proc/cyborg_character_get_layout_arousal_keys()
	return list("none", "partial", "full")

/proc/cyborg_character_get_layout_arousal_key(arousal_state)
	switch(arousal_state)
		if(AROUSAL_NONE)
			return "none"
		if(AROUSAL_PARTIAL)
			return "partial"
		if(AROUSAL_FULL)
			return "full"
	return null

/proc/cyborg_character_get_layout_store(datum/preferences/preferences)
	if(!preferences)
		return list()

	if(islist(preferences.cyborg_character_layout_draft_store))
		return preferences.cyborg_character_layout_draft_store

	var/list/store = preferences.read_preference(/datum/preference/blob/silicon_genital_layout_presets)
	if(!islist(store))
		store = list()

	if(!islist(store["active"]))
		store["active"] = list()
	if(!islist(store["presets"]))
		store["presets"] = list()
	if(!islist(store["model_defaults"]))
		store["model_defaults"] = list()

	var/list/active = store["active"]
	for(var/organ_slot in cyborg_character_get_genital_slots())
		if(!islist(active[organ_slot]))
			active[organ_slot] = cyborg_character_get_default_layout_entry()

	preferences.cyborg_character_layout_draft_store = deep_copy_list(store)
	return preferences.cyborg_character_layout_draft_store

/proc/cyborg_character_clear_layout_commit_timer(datum/preferences/preferences)
	if(preferences?.cyborg_character_layout_commit_timer)
		deltimer(preferences.cyborg_character_layout_commit_timer)
		preferences.cyborg_character_layout_commit_timer = null

/proc/cyborg_character_schedule_layout_commit(datum/preferences/preferences, delay = 20)
	if(!preferences)
		return
	cyborg_character_clear_layout_commit_timer(preferences)
	preferences.cyborg_character_layout_commit_timer = addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cyborg_character_commit_layout_store), preferences), delay, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/proc/cyborg_character_mark_layout_dirty(datum/preferences/preferences, refresh = TRUE)
	if(!preferences)
		return FALSE
	preferences.cyborg_character_layout_draft_dirty = TRUE
	cyborg_character_schedule_layout_commit(preferences)
	if(refresh)
		cyborg_character_refresh_preview(preferences)
	return TRUE

/proc/cyborg_character_commit_layout_store(datum/preferences/preferences, persist = TRUE, force = FALSE)
	if(!preferences)
		return FALSE

	if(!preferences.cyborg_character_layout_draft_dirty && !force)
		return TRUE

	var/list/store = cyborg_character_get_layout_store(preferences)
	if(!islist(store))
		return FALSE

	cyborg_character_clear_layout_commit_timer(preferences)
	var/list/normalized_store = cyborg_character_normalize_layout_store(store)
	preferences.write_preference(GLOB.preference_entries[/datum/preference/blob/silicon_genital_layout_presets], normalized_store)
	if(persist)
		preferences.save_character(TRUE)
	preferences.cyborg_character_layout_draft_store = deep_copy_list(normalized_store)
	preferences.cyborg_character_layout_draft_dirty = FALSE
	return TRUE

/proc/cyborg_character_save_layout_store(datum/preferences/preferences, list/store, persist = FALSE)
	if(!preferences || !islist(store))
		return FALSE
	preferences.cyborg_character_layout_draft_store = deep_copy_list(store)
	if(!persist)
		return cyborg_character_mark_layout_dirty(preferences, FALSE)
	preferences.cyborg_character_layout_draft_dirty = TRUE
	if(!cyborg_character_commit_layout_store(preferences, TRUE, TRUE))
		return FALSE
	return TRUE

/proc/cyborg_character_get_default_color(organ_slot)
	switch(organ_slot)
		if(ORGAN_SLOT_VAGINA)
			return "#d9a0aa"
		if(ORGAN_SLOT_BREASTS)
			return "#f2cfbf"
		if(ORGAN_SLOT_TESTICLES)
			return "#f2cfbf"
		if(ORGAN_SLOT_PENIS)
			return "#f2cfbf"
		if(ORGAN_SLOT_SHEATH)
			return "#f2cfbf"
	return "#ffffff"

/proc/cyborg_character_sanitize_color(color)
	if(!istext(color) || !length(color))
		return null
	return sanitize_hexcolor(color)

/proc/cyborg_character_sanitize_color_list(list/colors)
	var/list/sanitized_colors = list(null, null, null)
	if(!islist(colors))
		return sanitized_colors
	for(var/index in 1 to 3)
		sanitized_colors[index] = cyborg_character_sanitize_color(colors[index])
	return sanitized_colors

/proc/cyborg_character_sanitize_offset(offset)
	return sanitize_float(offset, -128, 128, 0.01, 0)

/proc/cyborg_character_sanitize_direction_override(list/entry)
	var/list/sanitized_entry = list()
	if(!islist(entry))
		return sanitized_entry
	if(!isnull(entry["visible"]))
		sanitized_entry["visible"] = !!entry["visible"]
	if(!isnull(entry["pixel_x"]))
		sanitized_entry["pixel_x"] = cyborg_character_sanitize_offset(entry["pixel_x"])
	if(!isnull(entry["pixel_y"]))
		sanitized_entry["pixel_y"] = cyborg_character_sanitize_offset(entry["pixel_y"])
	if(!isnull(entry["rotation"]))
		sanitized_entry["rotation"] = sanitize_float(entry["rotation"], -180, 180, 1, 0)
	if(!isnull(entry["priority"]))
		sanitized_entry["priority"] = round(sanitize_float(entry["priority"], 1, 10, 1, 5))
	return sanitized_entry

/proc/cyborg_character_sanitize_direction_entry(list/entry)
	var/list/sanitized_entry = cyborg_character_get_default_direction_entry()
	if(!islist(entry))
		return sanitized_entry
	if(!isnull(entry["visible"]))
		sanitized_entry["visible"] = !!entry["visible"]
	sanitized_entry["pixel_x"] = cyborg_character_sanitize_offset(entry["pixel_x"])
	sanitized_entry["pixel_y"] = cyborg_character_sanitize_offset(entry["pixel_y"])
	sanitized_entry["rotation"] = sanitize_float(entry["rotation"], -180, 180, 1, 0)
	sanitized_entry["priority"] = round(sanitize_float(entry["priority"], 1, 10, 1, 5))
	if(islist(entry["arousal"]))
		var/list/arousal_entries = list()
		for(var/arousal_key in cyborg_character_get_layout_arousal_keys())
			var/list/sanitized_override = cyborg_character_sanitize_direction_override(entry["arousal"]?[arousal_key])
			if(length(sanitized_override))
				arousal_entries[arousal_key] = sanitized_override
		if(length(arousal_entries))
			sanitized_entry["arousal"] = arousal_entries
	return sanitized_entry

/proc/cyborg_character_sanitize_layout_entry(list/entry)
	var/list/sanitized_entry = cyborg_character_get_default_layout_entry()
	if(!islist(entry))
		return sanitized_entry
	sanitized_entry["pixel_x"] = cyborg_character_sanitize_offset(entry["pixel_x"])
	sanitized_entry["pixel_y"] = cyborg_character_sanitize_offset(entry["pixel_y"])
	sanitized_entry["rotation"] = sanitize_float(entry["rotation"], -180, 180, 1, 0)
	sanitized_entry["scale"] = sanitize_float(entry["scale"], 0.25, 16, 0.05, 1)
	sanitized_entry["colors"] = cyborg_character_sanitize_color_list(entry["colors"])
	var/list/advanced = sanitized_entry["advanced"]
	for(var/direction_key in cyborg_character_get_direction_keys())
		advanced[direction_key] = cyborg_character_sanitize_direction_entry(entry["advanced"]?[direction_key])
	return sanitized_entry

/proc/cyborg_character_normalize_layout_store(list/store)
	if(!islist(store))
		store = list()
	if(!islist(store["active"]))
		store["active"] = list()
	if(!islist(store["presets"]))
		store["presets"] = list()
	if(!islist(store["model_defaults"]))
		store["model_defaults"] = list()

	var/list/active = store["active"]
	for(var/organ_slot in cyborg_character_get_genital_slots())
		active[organ_slot] = cyborg_character_sanitize_layout_entry(active[organ_slot])

	var/list/presets = store["presets"]
	for(var/preset_name in presets.Copy())
		var/list/preset_data = presets[preset_name]
		if(!islist(preset_data))
			presets -= preset_name
			continue
		var/list/sanitized_preset = list()
		for(var/organ_slot in cyborg_character_get_genital_slots())
			sanitized_preset[organ_slot] = cyborg_character_sanitize_layout_entry(preset_data[organ_slot])
		presets[preset_name] = sanitized_preset

	while(length(presets) > 10)
		var/remove_name = presets[presets.len]
		presets -= remove_name

	var/list/model_defaults = store["model_defaults"]
	for(var/model_key in model_defaults.Copy())
		var/list/model_data = model_defaults[model_key]
		if(!islist(model_data))
			model_defaults -= model_key
			continue
		var/list/sanitized_model_data = list()
		for(var/organ_slot in cyborg_character_get_genital_slots())
			sanitized_model_data[organ_slot] = cyborg_character_sanitize_layout_entry(model_data[organ_slot])
		model_defaults[model_key] = sanitized_model_data

	return store

/proc/cyborg_character_get_sprite_preference_path(organ_slot)
	switch(organ_slot)
		if(ORGAN_SLOT_PENIS)
			return /datum/preference/choiced/silicon_genital_sprite/penis
		if(ORGAN_SLOT_SHEATH)
			return /datum/preference/choiced/silicon_genital_sprite/sheath
		if(ORGAN_SLOT_TESTICLES)
			return /datum/preference/choiced/silicon_genital_sprite/testicles
		if(ORGAN_SLOT_VAGINA)
			return /datum/preference/choiced/silicon_genital_sprite/vagina
		if(ORGAN_SLOT_BREASTS)
			return /datum/preference/choiced/silicon_genital_sprite/breasts
	return null

/proc/cyborg_character_get_organ_slot_from_sprite_preference_key(preference_key)
	switch(preference_key)
		if("silicon_penis_sprite")
			return ORGAN_SLOT_PENIS
		if("silicon_sheath_sprite")
			return ORGAN_SLOT_SHEATH
		if("silicon_testicles_sprite")
			return ORGAN_SLOT_TESTICLES
		if("silicon_vagina_sprite")
			return ORGAN_SLOT_VAGINA
		if("silicon_breasts_sprite")
			return ORGAN_SLOT_BREASTS
	return null

/proc/cyborg_character_get_sprite_choice(datum/preferences/preferences, organ_slot)
	var/preference_path = cyborg_character_get_sprite_preference_path(organ_slot)
	if(!preference_path)
		return null

	var/list/possible_values = get_silicon_genital_sprite_values(organ_slot)
	var/chosen_value = preferences?.read_preference(preference_path)
	if(chosen_value in possible_values)
		return chosen_value

	var/datum/preference/choiced/preference_entry = GLOB.preference_entries[preference_path]
	var/default_value = preference_entry?.create_default_value()
	if(default_value in possible_values)
		return default_value

	if(length(possible_values))
		return possible_values[1]

	return null

/proc/cyborg_character_get_slot_name(organ_slot)
	switch(organ_slot)
		if(ORGAN_SLOT_PENIS)
			return "Penis"
		if(ORGAN_SLOT_SHEATH)
			return "Sheath"
		if(ORGAN_SLOT_TESTICLES)
			return "Balls / Sheath"
		if(ORGAN_SLOT_VAGINA)
			return "Vagina"
		if(ORGAN_SLOT_BREASTS)
			return "Breasts"
	return capitalize("[organ_slot]")

/proc/cyborg_character_get_arousal_label(arousal_state)
	switch(arousal_state)
		if(AROUSAL_NONE)
			return "None"
		if(AROUSAL_PARTIAL)
			return "Partial"
		if(AROUSAL_FULL)
			return "Full"
	return "Locked"

/proc/cyborg_character_can_preview_genital_arouse(organ_slot)
	return organ_slot in list(ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA)

/proc/cyborg_character_get_preview_genital_arousal_state(datum/preferences/preferences, organ_slot)
	if(!cyborg_character_can_preview_genital_arouse(organ_slot))
		return AROUSAL_CANT

	var/list/preview_states = preferences?.cyborg_character_preview_arousal_states
	if(islist(preview_states) && (organ_slot in preview_states))
		var/selected_state = preview_states[organ_slot]
		if(selected_state in list(AROUSAL_NONE, AROUSAL_PARTIAL, AROUSAL_FULL))
			return selected_state

	return AROUSAL_NONE

/proc/cyborg_character_get_genital_color_layers(datum/preferences/preferences, organ_slot, list/layout_entry)
	var/sprite_choice = cyborg_character_get_sprite_choice(preferences, organ_slot)
	var/datum/sprite_accessory/genital/accessory = SSaccessories.sprite_accessories[organ_slot]?[sprite_choice]
	var/mob/living/silicon/robot/cyborg_character_catalog_host/catalog_host = preferences?.cyborg_character_preview_view?.preview_robot
	if(catalog_host && accessory)
		if(!islist(catalog_host.cyborg_genital_layout))
			catalog_host.cyborg_genital_layout = list()
		if(!islist(catalog_host.cyborg_genital_sprite_choices))
			catalog_host.cyborg_genital_sprite_choices = list()
		if(!islist(catalog_host.cyborg_genital_arousal_states))
			catalog_host.cyborg_genital_arousal_states = list()
		catalog_host.cyborg_genital_layout[organ_slot] = deep_copy_list(layout_entry)
		catalog_host.cyborg_genital_sprite_choices[organ_slot] = sprite_choice
		catalog_host.cyborg_genital_arousal_states[organ_slot] = cyborg_character_get_preview_genital_arousal_state(preferences, organ_slot)
		var/list/color_layers = catalog_host.get_cyborg_genital_color_layer_names(organ_slot, accessory)
		if(length(color_layers))
			return color_layers
	return list("1" = "primary")

/proc/cyborg_character_build_genital_entry(datum/preferences/preferences, organ_slot, list/layout_entry, model_name)
	var/sprite_choice = cyborg_character_get_sprite_choice(preferences, organ_slot)
	var/has_sprite = is_factual_sprite_accessory(organ_slot, sprite_choice)
	var/list/custom_colors = cyborg_character_sanitize_color_list(layout_entry["colors"])
	var/default_color = cyborg_character_get_default_color(organ_slot)
	var/list/resolved_colors = list(default_color, default_color, default_color)
	for(var/index in 1 to 3)
		if(custom_colors[index])
			resolved_colors[index] = custom_colors[index]
	var/arousal_state = cyborg_character_get_preview_genital_arousal_state(preferences, organ_slot)

	return list(
		"slot" = organ_slot,
		"name" = cyborg_character_get_slot_name(organ_slot),
		"sprite" = sprite_choice,
		"has_sprite" = has_sprite,
		"visible" = TRUE,
		"can_arouse" = cyborg_character_can_preview_genital_arouse(organ_slot),
		"aroused" = arousal_state,
		"arousal_label" = cyborg_character_get_arousal_label(arousal_state),
		"pixel_x" = layout_entry["pixel_x"],
		"pixel_y" = layout_entry["pixel_y"],
		"rotation" = layout_entry["rotation"],
		"scale" = layout_entry["scale"],
		"direction_pixel_x" = 0,
		"direction_pixel_y" = 0,
		"direction_rotation" = 0,
		"direction_visible" = TRUE,
		"scale_limit" = 16,
		"body_scale" = 1,
		"offset_limit" = 32,
		"colors" = custom_colors,
		"color_layers" = cyborg_character_get_genital_color_layers(preferences, organ_slot, layout_entry),
		"resolved_colors" = resolved_colors,
		"preview_color" = resolved_colors[1],
		"advanced" = deep_copy_list(layout_entry["advanced"]),
	)

/proc/cyborg_character_refresh_preview(datum/preferences/preferences)
	preferences?.cyborg_character_preview_view?.update_body()

/datum/preference_middleware/cyborg_character
	action_delegations = list(
		"set_cyborg_preview_department" = PROC_REF(set_cyborg_preview_department),
		"set_cyborg_preview_model" = PROC_REF(set_cyborg_preview_model),
		"set_cyborg_preview_state" = PROC_REF(set_cyborg_preview_state),
		"set_cyborg_preview_dir" = PROC_REF(set_cyborg_preview_dir),
		"set_cyborg_size" = PROC_REF(set_cyborg_size),
		"update_cyborg_background" = PROC_REF(update_cyborg_background),
		"set_cyborg_preview_genital_arousal" = PROC_REF(set_cyborg_preview_genital_arousal),
		"set_cyborg_reproduction_value" = PROC_REF(set_cyborg_reproduction_value),
		"set_cyborg_reproduction_direction_value" = PROC_REF(set_cyborg_reproduction_direction_value),
		"reset_cyborg_reproduction_value" = PROC_REF(reset_cyborg_reproduction_value),
		"reset_cyborg_reproduction_direction_value" = PROC_REF(reset_cyborg_reproduction_direction_value),
		"save_cyborg_reproduction_preset" = PROC_REF(save_cyborg_reproduction_preset),
		"load_cyborg_reproduction_preset" = PROC_REF(load_cyborg_reproduction_preset),
		"delete_cyborg_reproduction_preset" = PROC_REF(delete_cyborg_reproduction_preset),
		"save_cyborg_reproduction_model_default" = PROC_REF(save_cyborg_reproduction_model_default),
		"load_cyborg_reproduction_model_default" = PROC_REF(load_cyborg_reproduction_model_default),
		"clear_cyborg_reproduction_model_default" = PROC_REF(clear_cyborg_reproduction_model_default),
	)

/datum/preference_middleware/cyborg_character/get_ui_data(mob/user)
	if(preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return list()

	var/list/model_departments = cyborg_character_get_model_names()
	if(!length(model_departments))
		model_departments = list("Engineering")
	var/list/model_catalog = cyborg_character_ensure_model_catalog()
	if(!length(model_catalog))
		model_catalog = list("Engineering" = list("Engineering"))

	var/selected_department = preferences.cyborg_character_preview_department
	var/selected_model = preferences.cyborg_character_preview_model

	if(!(selected_department in model_catalog))
		if(selected_model in model_catalog)
			selected_department = selected_model
			selected_model = null
		else
			selected_department = model_departments[1]

	var/list/department_models = model_catalog[selected_department]
	if(!length(department_models))
		department_models = list(cyborg_character_get_default_model_variant(selected_department))
		model_catalog[selected_department] = department_models

	if(!(selected_model in department_models))
		if(selected_model in model_departments)
			selected_department = selected_model
			department_models = model_catalog[selected_department]
		selected_model = department_models[1]

	preferences.cyborg_character_preview_department = selected_department
	preferences.cyborg_character_preview_model = selected_model

	if(isnull(preferences.cyborg_character_preview_state))
		preferences.cyborg_character_preview_state = "idle"
	if(isnull(preferences.cyborg_character_preview_dir))
		preferences.cyborg_character_preview_dir = "south"

	if(!preferences.cyborg_character_preview_view)
		preferences.create_cyborg_character_preview_view(user)

	var/list/store = cyborg_character_get_layout_store(preferences)
	var/model_name = preferences.cyborg_character_preview_model
	var/model_department = preferences.cyborg_character_preview_department
	var/list/preview_data = cyborg_character_get_model_icon_data(model_department, model_name)
	var/list/preview_state_options = cyborg_character_get_model_preview_state_options(model_department, model_name)
	var/list/preview_state_map = cyborg_character_get_preview_state_option_map(model_department, model_name)
	preferences.cyborg_character_preview_state = LOWER_TEXT("[preferences.cyborg_character_preview_state]")
	if(!(preferences.cyborg_character_preview_state in preview_state_map))
		var/normalized_state = cyborg_character_get_preview_state_token_from_icon_state(preferences.cyborg_character_preview_state)
		if(normalized_state in preview_state_map)
			preferences.cyborg_character_preview_state = normalized_state
		else if(length(preview_state_options))
			preferences.cyborg_character_preview_state = preview_state_options[1]?["value"]
		else
			preferences.cyborg_character_preview_state = "idle"
	var/model_key = LOWER_TEXT("[model_department]#[model_name]")
	var/list/model_defaults = store["model_defaults"]

	var/list/reproduction_management = list(
		"enabled" = TRUE,
		"presetLimit" = 10,
		"presets" = list(),
		"genitals" = list(),
		"offset_directions" = cyborg_character_get_editable_direction_entries(preview_state_options),
		"model_department" = model_department || "Current Department",
		"model_name" = model_name || "Current Model",
		"model_key" = model_key,
		"has_model_default" = !!model_defaults[model_key],
	)

	for(var/preset_name in store["presets"])
		reproduction_management["presets"] += list(list("name" = preset_name))

	for(var/organ_slot in cyborg_character_get_genital_slots())
		var/list/layout_entry = cyborg_character_sanitize_layout_entry(store["active"][organ_slot])
		reproduction_management["genitals"] += list(cyborg_character_build_genital_entry(preferences, organ_slot, layout_entry, model_name))

	return list(
		"cyborg_character" = list(
			"preview" = preferences.cyborg_character_preview_view.assigned_map,
			"preview_image" = preferences.cyborg_character_preview_view.preview_image,
			"models" = model_departments,
			"models_by_department" = model_catalog,
			"selected_department" = model_department,
			"selected_model" = preferences.cyborg_character_preview_model,
			"selected_state" = preferences.cyborg_character_preview_state,
			"base_state" = preview_data?["icon_state"] || "robot",
			"selected_dir" = preferences.cyborg_character_preview_dir,
			"preview_width" = preview_data?["preview_width"] || 32,
			"preview_height" = preview_data?["preview_height"] || 32,
			"size" = cyborg_character_sanitize_size(preferences.read_preference(/datum/preference/numeric/cyborg_size)),
			"size_options" = cyborg_character_get_allowed_sizes(),
			"states" = preview_state_options,
			"reproductionManagement" = reproduction_management,
		),
	)

/datum/preference_middleware/cyborg_character/proc/set_cyborg_size(list/params, mob/user)
	var/new_size = cyborg_character_sanitize_size(params["size"])
	if(!preferences.update_preference(GLOB.preference_entries[/datum/preference/numeric/cyborg_size], new_size))
		return FALSE
	preferences.save_character(TRUE)
	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/update_cyborg_background(list/params, mob/user)
	if(!preferences.update_preference(GLOB.preference_entries[/datum/preference/choiced/background_state], params["new_background"]))
		return FALSE
	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/set_cyborg_preview_department(list/params, mob/user)
	var/department_name = params["department"]
	var/list/model_catalog = cyborg_character_ensure_model_catalog()
	if(!(department_name in model_catalog))
		return FALSE

	preferences.cyborg_character_preview_department = department_name
	preferences.cyborg_character_preview_model = cyborg_character_get_default_model_variant(department_name)
	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/set_cyborg_preview_model(list/params, mob/user)
	var/model_name = params["model"]
	var/list/model_catalog = cyborg_character_ensure_model_catalog()
	var/department_name = preferences.cyborg_character_preview_department
	if(!(department_name in model_catalog))
		department_name = cyborg_character_get_model_names()[1]
		preferences.cyborg_character_preview_department = department_name

	var/list/department_models = model_catalog[department_name]
	if(!(model_name in department_models))
		return FALSE

	preferences.cyborg_character_preview_model = model_name
	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/set_cyborg_preview_state(list/params, mob/user)
	var/state = params["state"]
	var/list/state_map = cyborg_character_get_preview_state_option_map(preferences.cyborg_character_preview_department, preferences.cyborg_character_preview_model)
	if(!(state in state_map))
		return FALSE
	preferences.cyborg_character_preview_state = state
	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/set_cyborg_preview_dir(list/params, mob/user)
	var/dir_name = LOWER_TEXT("[params["dir"]]")
	if(!(dir_name in list("north", "south", "east", "west")))
		return FALSE
	preferences.cyborg_character_preview_dir = dir_name
	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/set_cyborg_preview_genital_arousal(list/params, mob/user)
	var/organ_slot = params["slot"]
	if(!(organ_slot in list(ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA)))
		return FALSE

	var/raw_arousal = params["arousal"]
	var/arousal_state = isnull(raw_arousal) ? null : text2num("[raw_arousal]")
	if(!(arousal_state in list(AROUSAL_NONE, AROUSAL_PARTIAL, AROUSAL_FULL)))
		arousal_state = null

	if(!islist(preferences.cyborg_character_preview_arousal_states))
		preferences.cyborg_character_preview_arousal_states = list()

	if(isnull(arousal_state))
		preferences.cyborg_character_preview_arousal_states -= organ_slot
	else
		preferences.cyborg_character_preview_arousal_states[organ_slot] = arousal_state

	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/get_slot_layout(list/store, organ_slot)
	var/list/active = store["active"]
	var/list/layout_entry = cyborg_character_sanitize_layout_entry(active[organ_slot])
	active[organ_slot] = layout_entry
	return layout_entry

/datum/preference_middleware/cyborg_character/proc/set_cyborg_reproduction_value(list/params, mob/user)
	var/organ_slot = params["slot"]
	var/list/store = cyborg_character_get_layout_store(preferences)
	var/list/layout_entry = get_slot_layout(store, organ_slot)
	var/field = params["field"]
	var/value = params["value"]

	switch(field)
		if("pixel_x", "pixel_y", "rotation", "scale")
			layout_entry[field] = text2num("[value]")
		if("color")
			var/color_index = clamp(text2num("[value]") || 1, 1, 3)
			var/new_color = tgui_color_picker(user, "Select new color", null, layout_entry["colors"][color_index] || COLOR_WHITE)
			if(!new_color)
				return FALSE
			layout_entry["colors"][color_index] = cyborg_character_sanitize_color(new_color)
		if("reset_color")
			var/reset_index = clamp(text2num("[value]") || 1, 1, 3)
			layout_entry["colors"][reset_index] = null
		else
			return FALSE

	store["active"][organ_slot] = cyborg_character_sanitize_layout_entry(layout_entry)
	if(!cyborg_character_save_layout_store(preferences, cyborg_character_normalize_layout_store(store)))
		return FALSE
	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/set_cyborg_reproduction_direction_value(list/params, mob/user)
	var/organ_slot = params["slot"]
	var/direction_key = params["direction"]
	var/list/preview_state_options = cyborg_character_get_model_preview_state_options(preferences.cyborg_character_preview_department, preferences.cyborg_character_preview_model)
	if(!(direction_key in cyborg_character_get_editable_direction_keys(preview_state_options)))
		return FALSE

	var/list/store = cyborg_character_get_layout_store(preferences)
	var/list/layout_entry = get_slot_layout(store, organ_slot)
	var/list/direction_entry = cyborg_character_sanitize_direction_entry(layout_entry["advanced"]?[direction_key])
	var/field = params["field"]
	var/value = params["value"]
	var/arousal_key = cyborg_character_get_layout_arousal_key(text2num("[params["arousal"]]"))

	switch(field)
		if("visible", "pixel_x", "pixel_y", "rotation", "priority")
			if(arousal_key)
				var/list/arousal_entries = islist(direction_entry["arousal"]) ? direction_entry["arousal"] : list()
				var/list/arousal_entry = cyborg_character_sanitize_direction_override(arousal_entries?[arousal_key])
				arousal_entry[field] = field == "visible" ? !!text2num("[value]") : text2num("[value]")
				arousal_entries[arousal_key] = cyborg_character_sanitize_direction_override(arousal_entry)
				direction_entry["arousal"] = arousal_entries
			else
				direction_entry[field] = field == "visible" ? !!text2num("[value]") : text2num("[value]")
		else
			return FALSE

	layout_entry["advanced"][direction_key] = cyborg_character_sanitize_direction_entry(direction_entry)
	store["active"][organ_slot] = cyborg_character_sanitize_layout_entry(layout_entry)
	if(!cyborg_character_save_layout_store(preferences, cyborg_character_normalize_layout_store(store)))
		return FALSE
	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/reset_cyborg_reproduction_value(list/params, mob/user)
	var/organ_slot = params["slot"]
	var/list/store = cyborg_character_get_layout_store(preferences)
	store["active"][organ_slot] = cyborg_character_get_default_layout_entry()
	if(!cyborg_character_save_layout_store(preferences, cyborg_character_normalize_layout_store(store)))
		return FALSE
	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/reset_cyborg_reproduction_direction_value(list/params, mob/user)
	var/organ_slot = params["slot"]
	var/direction_key = params["direction"]
	var/list/preview_state_options = cyborg_character_get_model_preview_state_options(preferences.cyborg_character_preview_department, preferences.cyborg_character_preview_model)
	if(!(direction_key in cyborg_character_get_editable_direction_keys(preview_state_options)))
		return FALSE

	var/list/store = cyborg_character_get_layout_store(preferences)
	var/list/layout_entry = get_slot_layout(store, organ_slot)
	layout_entry["advanced"][direction_key] = cyborg_character_get_default_direction_entry()
	store["active"][organ_slot] = cyborg_character_sanitize_layout_entry(layout_entry)
	if(!cyborg_character_save_layout_store(preferences, cyborg_character_normalize_layout_store(store)))
		return FALSE
	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/save_cyborg_reproduction_preset(list/params, mob/user)
	var/preset_name = tgui_input_text(user, "Choose a preset name.", "Save Preset", max_length = 24)
	if(!istext(preset_name) || !length(preset_name))
		return FALSE

	var/list/store = cyborg_character_get_layout_store(preferences)
	store["presets"][preset_name] = deep_copy_list(store["active"])
	if(!cyborg_character_save_layout_store(preferences, cyborg_character_normalize_layout_store(store), TRUE))
		return FALSE
	return TRUE

/datum/preference_middleware/cyborg_character/proc/load_cyborg_reproduction_preset(list/params, mob/user)
	var/preset_name = params["preset"]
	var/list/store = cyborg_character_get_layout_store(preferences)
	var/list/preset = store["presets"]?[preset_name]
	if(!islist(preset))
		return FALSE
	store["active"] = deep_copy_list(preset)
	if(!cyborg_character_save_layout_store(preferences, cyborg_character_normalize_layout_store(store)))
		return FALSE
	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/delete_cyborg_reproduction_preset(list/params, mob/user)
	var/preset_name = params["preset"]
	var/list/store = cyborg_character_get_layout_store(preferences)
	if(!islist(store["presets"]) || !(preset_name in store["presets"]))
		return FALSE
	store["presets"] -= preset_name
	if(!cyborg_character_save_layout_store(preferences, cyborg_character_normalize_layout_store(store), TRUE))
		return FALSE
	return TRUE

/datum/preference_middleware/cyborg_character/proc/save_cyborg_reproduction_model_default(list/params, mob/user)
	var/model_key = LOWER_TEXT("[preferences.cyborg_character_preview_department]#[preferences.cyborg_character_preview_model]")
	var/list/store = cyborg_character_get_layout_store(preferences)
	store["model_defaults"][model_key] = deep_copy_list(store["active"])
	if(!cyborg_character_save_layout_store(preferences, cyborg_character_normalize_layout_store(store), TRUE))
		return FALSE
	return TRUE

/datum/preference_middleware/cyborg_character/proc/load_cyborg_reproduction_model_default(list/params, mob/user)
	var/model_key = LOWER_TEXT("[preferences.cyborg_character_preview_department]#[preferences.cyborg_character_preview_model]")
	var/list/store = cyborg_character_get_layout_store(preferences)
	var/list/model_default = store["model_defaults"]?[model_key]
	if(!islist(model_default))
		return FALSE
	store["active"] = deep_copy_list(model_default)
	if(!cyborg_character_save_layout_store(preferences, cyborg_character_normalize_layout_store(store)))
		return FALSE
	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/proc/clear_cyborg_reproduction_model_default(list/params, mob/user)
	var/model_key = LOWER_TEXT("[preferences.cyborg_character_preview_department]#[preferences.cyborg_character_preview_model]")
	var/list/store = cyborg_character_get_layout_store(preferences)
	if(!(model_key in store["model_defaults"]))
		return FALSE
	store["model_defaults"] -= model_key
	if(!cyborg_character_save_layout_store(preferences, cyborg_character_normalize_layout_store(store), TRUE))
		return FALSE
	return TRUE

/datum/preference_middleware/cyborg_character/on_new_character(mob/user)
	preferences.cyborg_character_preview_arousal_states = null
	preferences.cyborg_character_layout_draft_store = null
	preferences.cyborg_character_layout_draft_dirty = FALSE
	cyborg_character_clear_layout_commit_timer(preferences)

/datum/preference_middleware/cyborg_character/post_set_preference(mob/user, preference, value)
	var/organ_slot = cyborg_character_get_organ_slot_from_sprite_preference_key(preference)
	if(!organ_slot)
		return FALSE

	if(!is_factual_sprite_accessory(organ_slot, value))
		var/list/store = cyborg_character_get_layout_store(preferences)
		store["active"][organ_slot] = cyborg_character_get_default_layout_entry()
		cyborg_character_save_layout_store(preferences, cyborg_character_normalize_layout_store(store))

	cyborg_character_refresh_preview(preferences)
	return TRUE

/datum/preference_middleware/cyborg_character/flush_ui_state(mob/user)
	cyborg_character_commit_layout_store(preferences, FALSE)

/atom/movable/screen/map_view/cyborg_character_preview
	name = "cyborg_character_preview"
	var/datum/preferences/preferences
	var/atom/movable/screen/background/cyborg_character_preview_background/background
	var/mob/living/silicon/robot/cyborg_character_catalog_host/preview_robot
	var/preview_model_department
	var/preview_model_name
	var/preview_image

/atom/movable/screen/map_view/cyborg_character_preview/Initialize(mapload, datum/preferences/preferences)
	. = ..()
	src.preferences = preferences
	background = new
	background.del_on_map_removal = FALSE
	preview_robot = new()

/atom/movable/screen/map_view/cyborg_character_preview/generate_view(map_key)
	. = ..()
	if(!background)
		background = new
		background.del_on_map_removal = FALSE
	background.assigned_map = assigned_map
	background.fill_rect(1, 1, 15, 15)
	set_position(8, 8)

/atom/movable/screen/map_view/cyborg_character_preview/display_to_client(client/show_to)
	show_to.register_map_obj(background)
	return ..()

/atom/movable/screen/map_view/cyborg_character_preview/Destroy()
	QDEL_NULL(background)
	QDEL_NULL(preview_robot)
	preferences = null
	return ..()

/atom/movable/screen/map_view/cyborg_character_preview/proc/ensure_preview_robot(model_department, model_name, list/model_data)
	if(!preview_robot)
		preview_robot = new()
	if(preview_robot.model && preview_model_department == model_department && preview_model_name == model_name)
		return preview_robot

	QDEL_NULL(preview_robot)
	preview_robot = new()
	preview_model_department = model_department
	preview_model_name = model_name

	var/model_type = cyborg_character_ensure_model_list()[model_department]
	if(isnull(model_type))
		return preview_robot

	var/obj/item/robot_model/model = new model_type(preview_robot)
	preview_robot.model = model
	model.name = model_name
	model.cyborg_icon_override = model_data?["icon"] || model.cyborg_icon_override
	model.cyborg_base_icon = model_data?["icon_state"] || model.cyborg_base_icon
	if(islist(model_data?["skin_features"]))
		if(!islist(model.model_features))
			model.model_features = list()
		model.model_features += model_data["skin_features"]
	preview_robot.icon = model.cyborg_icon_override || preview_robot.icon
	return preview_robot

/atom/movable/screen/map_view/cyborg_character_preview/proc/configure_preview_robot_state(mob/living/silicon/robot/cyborg_character_catalog_host/catalog_host, list/store, list/model_data, selected_state, selected_dir)
	if(!catalog_host)
		return

	catalog_host.icon = model_data?["icon"] || catalog_host.icon
	catalog_host.icon_state = selected_state
	catalog_host.dir = selected_dir
	var/selected_size = cyborg_character_sanitize_size(preferences.read_preference(/datum/preference/numeric/cyborg_size))
	catalog_host.current_size = selected_size
	catalog_host.transform = matrix().Scale(selected_size)
	catalog_host.cyborg_genital_appearance_revision++
	catalog_host.cyborg_genital_idle_phase_start_time = world.time
	catalog_host.cyborg_genital_movement_active = FALSE
	catalog_host.cyborg_genital_movement_signature = null
	catalog_host.robot_resting = cyborg_character_get_preview_robot_resting(selected_state)
	catalog_host.simulated_genitals = list()
	catalog_host.toggleable_cyborg_genitals = list()
	catalog_host.cyborg_genital_layout = deep_copy_list(store?["active"])
	catalog_host.cyborg_genital_sprite_choices = list()
	catalog_host.cyborg_genital_arousal_states = list()

	for(var/organ_slot in catalog_host.get_cyborg_genital_slots())
		var/sprite_choice = cyborg_character_get_sprite_choice(preferences, organ_slot)
		catalog_host.cyborg_genital_sprite_choices[organ_slot] = sprite_choice
		catalog_host.cyborg_genital_arousal_states[organ_slot] = cyborg_character_get_preview_genital_arousal_state(preferences, organ_slot)
		catalog_host.simulated_genitals[organ_slot] = is_factual_sprite_accessory(organ_slot, sprite_choice)
		if(catalog_host.simulated_genitals[organ_slot])
			catalog_host.toggleable_cyborg_genitals += organ_slot

	catalog_host.model?.update_tallborg()
	catalog_host.model?.update_quadruped()
	catalog_host.model?.update_lightweight()
	catalog_host.model?.update_robot_rest()

/atom/movable/screen/map_view/cyborg_character_preview/proc/update_body()
	if(!preferences)
		return

	var/model_department = preferences.cyborg_character_preview_department
	var/model_name = preferences.cyborg_character_preview_model
	var/list/model_catalog = cyborg_character_ensure_model_catalog()
	if(!(model_department in model_catalog))
		model_department = cyborg_character_get_model_names()[1]
		preferences.cyborg_character_preview_department = model_department
	var/list/model_variants = model_catalog[model_department]
	if(!length(model_variants))
		model_variants = list(cyborg_character_get_default_model_variant(model_department))
		model_catalog[model_department] = model_variants
	if(!(model_name in model_variants))
		model_name = model_variants[1]
		preferences.cyborg_character_preview_model = model_name

	var/list/model_data = cyborg_character_get_model_icon_data(model_department, model_name)
	if(!model_data)
		var/list/fallback_models = cyborg_character_get_model_names()
		if(length(fallback_models))
			model_department = fallback_models[1]
			model_name = cyborg_character_get_default_model_variant(model_department)
			preferences.cyborg_character_preview_department = model_department
			preferences.cyborg_character_preview_model = model_name
			model_data = cyborg_character_get_model_icon_data(model_department, model_name)

	if(!model_data)
		return

	var/icon_file = model_data["icon"]
	var/icon_state = model_data["icon_state"]
	var/list/state_map = cyborg_character_get_preview_state_option_map(model_department, model_name)
	var/list/state_options = cyborg_character_get_model_preview_state_options(model_department, model_name)
	var/selected_state_token = LOWER_TEXT("[preferences.cyborg_character_preview_state]")
	if(!(selected_state_token in state_map))
		var/normalized_state = cyborg_character_get_preview_state_token_from_icon_state(selected_state_token)
		if(normalized_state in state_map)
			selected_state_token = normalized_state
		else if(length(state_options))
			selected_state_token = state_options[1]?["value"]
		else
			selected_state_token = "idle"
	preferences.cyborg_character_preview_state = selected_state_token
	var/list/selected_state_option = state_map[selected_state_token]
	var/resolved_icon_state = selected_state_option?["icon_state"] || icon_state
	var/canvas_size = model_data["canvas_size"] || 0
	var/preview_dir = cyborg_character_text_to_dir(preferences.cyborg_character_preview_dir)
	var/list/store = cyborg_character_get_layout_store(preferences)

	var/mob/living/silicon/robot/cyborg_character_catalog_host/catalog_host = ensure_preview_robot(model_department, model_name, model_data)
	configure_preview_robot_state(catalog_host, store, model_data, resolved_icon_state, preview_dir)
	var/list/marker_data = catalog_host.get_cyborg_genital_animation_marker_data()
	var/list/preview_canvas_anchor_offset = catalog_host.get_cyborg_genital_canvas_anchor_offset()
	var/list/body_offset = cyborg_character_get_preview_body_offset(model_data, resolved_icon_state, preview_dir, marker_data)
	var/preview_body_pixel_x = (body_offset["pixel_x"] || 0) + (catalog_host.pixel_w || 0) - (preview_canvas_anchor_offset?["pixel_x"] || 0)
	var/preview_body_pixel_y = (body_offset["pixel_y"] || 0) + (catalog_host.pixel_z || 0) - (preview_canvas_anchor_offset?["pixel_y"] || 0)
	var/preview_genital_pixel_x = 0
	var/preview_genital_pixel_y = 0
	var/preview_canvas_width = model_data?["preview_width"] || ICON_SIZE_X
	var/preview_canvas_height = model_data?["preview_height"] || ICON_SIZE_Y
	var/image/preview_canvas
	if(canvas_size == 0)
		preview_canvas_width = ICON_SIZE_X
		preview_canvas_height = ICON_SIZE_Y
		preview_canvas = image('modular_zubbers/icons/customization/template.dmi')
	else if(canvas_size == 1)
		preview_canvas_width = 64
		preview_canvas_height = 64
		preview_canvas = image('modular_zubbers/icons/customization/template_64x64.dmi')
	else
		preview_canvas_width = 96
		preview_canvas_height = 96
		preview_canvas = image('modular_zubbers/icons/customization/template_96x96.dmi')
	var/icon/body_icon = getFlatIcon(image(icon = icon_file, icon_state = resolved_icon_state, dir = preview_dir), preview_dir, no_anim = TRUE)
	var/selected_size = cyborg_character_sanitize_size(preferences.read_preference(/datum/preference/numeric/cyborg_size))
	if(isicon(body_icon) && selected_size != RESIZE_NORMAL)
		body_icon.Scale(max(round(body_icon.Width() * selected_size), 1), max(round(body_icon.Height() * selected_size), 1))
	var/body_width = isicon(body_icon) ? body_icon.Width() : ICON_SIZE_X
	var/body_height = isicon(body_icon) ? body_icon.Height() : ICON_SIZE_Y
	var/list/body_scale_offset = catalog_host.get_cyborg_genital_transform_offset()
	var/body_scale_pixel_x = body_scale_offset["pixel_x"] || 0
	var/body_scale_pixel_y = body_scale_offset["pixel_y"] || 0
	var/preview_body_draw_pixel_x = preview_body_pixel_x + body_scale_pixel_x
	var/preview_body_draw_pixel_y = preview_body_pixel_y + body_scale_pixel_y
	var/preview_margin = 96
	var/canvas_state = preferences.read_preference(/datum/preference/choiced/background_state)
	if(!istext(canvas_state) || !length(canvas_state))
		canvas_state = "clear"
	var/preview_content_min_x = preview_body_draw_pixel_x
	var/preview_content_min_y = preview_body_draw_pixel_y
	var/preview_content_max_x = preview_body_draw_pixel_x + body_width
	var/preview_content_max_y = preview_body_draw_pixel_y + body_height
	var/preview_pad_left = max(-preview_body_draw_pixel_x, 0) + preview_margin
	var/preview_pad_down = max(-preview_body_draw_pixel_y, 0) + preview_margin
	preview_canvas_width = max(preview_canvas_width + preview_pad_left + preview_margin, preview_body_draw_pixel_x + preview_pad_left + body_width + preview_margin)
	preview_canvas_height = max(preview_canvas_height + preview_pad_down + preview_margin, preview_body_draw_pixel_y + preview_pad_down + body_height + preview_margin)
	var/icon/preview_icon = icon('icons/blanks/32x32.dmi', "nothing")
	preview_canvas_width = max(preview_canvas_width, 1)
	preview_canvas_height = max(preview_canvas_height, 1)
	if(preview_icon.Width() != preview_canvas_width || preview_icon.Height() != preview_canvas_height)
		preview_icon.Scale(preview_canvas_width, preview_canvas_height)
	if(isicon(body_icon))
		preview_icon.Blend(body_icon, ICON_OVERLAY, preview_body_draw_pixel_x + preview_pad_left + 1, preview_body_draw_pixel_y + preview_pad_down + 1)

	var/preview_direction_key = catalog_host.get_cyborg_genital_direction_key()
	for(var/organ_slot in catalog_host.get_cyborg_genital_slots())
		var/list/base_genital_overlays = catalog_host.make_cyborg_genital_overlay(organ_slot, preview_dir, preview_direction_key)
		var/overlay_subindex = 0
		for(var/mutable_appearance/genital_overlay as anything in base_genital_overlays)
			overlay_subindex++
			genital_overlay.pixel_x += preview_genital_pixel_x
			genital_overlay.pixel_y += preview_genital_pixel_y
			genital_overlay.plane = FLOAT_PLANE
			var/list/rendered_genital_data = cyborg_character_get_rendered_genital_icon_data(catalog_host, genital_overlay, organ_slot, overlay_subindex, preview_dir)
			rendered_genital_data = cyborg_character_apply_body_scale_to_rendered_genital(catalog_host, rendered_genital_data, selected_size)
			var/icon/rendered_genital_icon = rendered_genital_data?["icon"]
			if(isicon(rendered_genital_icon))
				var/genital_draw_x = preview_body_pixel_x + (rendered_genital_data["pixel_x"] || 0)
				var/genital_draw_y = preview_body_pixel_y + (rendered_genital_data["pixel_y"] || 0)
				preview_content_min_x = min(preview_content_min_x, genital_draw_x)
				preview_content_min_y = min(preview_content_min_y, genital_draw_y)
				preview_content_max_x = max(preview_content_max_x, genital_draw_x + rendered_genital_icon.Width())
				preview_content_max_y = max(preview_content_max_y, genital_draw_y + rendered_genital_icon.Height())
				preview_icon.Blend(rendered_genital_icon, ICON_OVERLAY, genital_draw_x + preview_pad_left + 1, genital_draw_y + preview_pad_down + 1)

	var/mutable_appearance/drawover_overlay = catalog_host.build_cyborg_side_drawover_overlay()
	if(drawover_overlay)
		drawover_overlay.plane = FLOAT_PLANE
		var/image/drawover_render_image = image(drawover_overlay)
		var/icon/drawover_flat_icon = getFlatIcon(drawover_render_image, preview_dir, no_anim = TRUE)
		if(isicon(drawover_flat_icon))
			if(selected_size != RESIZE_NORMAL)
				drawover_flat_icon.Scale(max(round(drawover_flat_icon.Width() * selected_size), 1), max(round(drawover_flat_icon.Height() * selected_size), 1))
			var/drawover_draw_x = preview_body_draw_pixel_x + drawover_overlay.pixel_x
			var/drawover_draw_y = preview_body_draw_pixel_y + drawover_overlay.pixel_y
			preview_content_min_x = min(preview_content_min_x, drawover_draw_x)
			preview_content_min_y = min(preview_content_min_y, drawover_draw_y)
			preview_content_max_x = max(preview_content_max_x, drawover_draw_x + drawover_flat_icon.Width())
			preview_content_max_y = max(preview_content_max_y, drawover_draw_y + drawover_flat_icon.Height())
			preview_icon.Blend(drawover_flat_icon, ICON_OVERLAY, drawover_draw_x + preview_pad_left + 1, drawover_draw_y + preview_pad_down + 1)

	if(!isicon(preview_icon))
		appearance = preview_canvas.appearance
		return

	var/icon/background_icon = icon('modular_zubbers/icons/customization/template_96x96.dmi', canvas_state)
	var/icon/background_preview_icon = icon('icons/blanks/32x32.dmi', "nothing")
	background_preview_icon.Scale(preview_icon.Width(), preview_icon.Height())
	for(var/tile_x in 1 to preview_icon.Width() step 96)
		for(var/tile_y in 1 to preview_icon.Height() step 96)
			background_preview_icon.Blend(background_icon, ICON_OVERLAY, tile_x, tile_y)
	background_preview_icon.Blend(preview_icon, ICON_OVERLAY, 1, 1)
	preview_icon = background_preview_icon
	preview_image = "data:image/png;base64,[icon2base64(preview_icon)]"
	var/image/preview_output = image(fcopy_rsc(preview_icon))
	preview_output.layer = MOB_LAYER
	preview_output.plane = FLOAT_PLANE
	appearance = preview_output.appearance
