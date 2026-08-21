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
	var/icon_file = model?.cyborg_icon_override || 'icons/mob/silicon/robots.dmi'
	var/icon_state = model?.cyborg_base_icon || "robot"
	var/canvas_size = 0
	var/selector_pixel_x = 0
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
			if((TRAIT_R_WIDE in skin_feature_list) || (TRAIT_R_BIG in skin_feature_list))
				selector_pixel_x = -16

	return list(
		"icon" = icon_file,
		"icon_state" = icon_state,
		"canvas_size" = canvas_size,
		"selector_pixel_x" = selector_pixel_x,
		"skin_features" = skin_features,
	)

/proc/cyborg_character_get_model_preview_states(model_name, variant_name = null)
	var/list/model_snapshot = cyborg_character_ensure_model_snapshot(model_name)
	var/icon_file = model_snapshot["default_icon"] || 'icons/mob/silicon/robots.dmi'
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
	var/icon_file = model_snapshot["default_icon"] || 'icons/mob/silicon/robots.dmi'
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
			"icon" = icon_file,
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
			"icon" = icon_file,
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
			"icon" = icon_file,
			"icon_state" = state_name,
			"movement" = FALSE,
		))

	return options

/proc/cyborg_character_get_metadata_count(metadata_value)
	if(islist(metadata_value))
		return max(length(metadata_value), 1)
	if(isnum(metadata_value))
		return max(metadata_value, 1)
	if(istext(metadata_value))
		return max(text2num(metadata_value), 1)
	return 1

/proc/cyborg_character_get_dirs_for_metadata_count(dir_count)
	if(dir_count >= 8)
		return GLOB.alldirs
	if(dir_count >= 4)
		return GLOB.cardinals
	return list(SOUTH)

/proc/cyborg_character_get_state_direction_entries(icon_file, state_name)
	var/list/state_entries = cyborg_character_get_state_metadata_entries(icon_file, state_name)
	var/list/direction_entries = list()
	var/list/seen_direction_keys = list()
	for(var/list/state_data as anything in state_entries)
		var/dir_count = cyborg_character_get_metadata_count(state_data?["dirs"])
		for(var/output_dir in cyborg_character_get_dirs_for_metadata_count(dir_count))
			var/direction_key = cyborg_character_dir_to_text(output_dir)
			if(seen_direction_keys[direction_key])
				continue
			direction_entries += list(list(
				"value" = direction_key,
				"label" = cyborg_character_get_direction_label(direction_key),
			))
			seen_direction_keys[direction_key] = TRUE
	if(!length(direction_entries))
		direction_entries += list(list("value" = "south", "label" = "South"))
	return direction_entries

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
	return list(ORGAN_SLOT_PENIS, ORGAN_SLOT_SHEATH, ORGAN_SLOT_TESTICLES, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS, ORGAN_SLOT_BREASTS)

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

/proc/cyborg_character_get_cached_preview_image(icon/layer_icon, cache_key, list/image_cache, list/cache_order)
	if(!isicon(layer_icon))
		return null
	if(!istext(cache_key) || !length(cache_key) || !islist(image_cache) || !islist(cache_order))
		return "data:image/png;base64,[icon2base64(layer_icon)]"

	if(cache_key in image_cache)
		return image_cache[cache_key]

	var/cached_image = "data:image/png;base64,[icon2base64(layer_icon)]"
	image_cache[cache_key] = cached_image
	cache_order += cache_key
	while(length(cache_order) > 256)
		var/old_key = cache_order[1]
		cache_order.Cut(1, 2)
		image_cache -= old_key
	return cached_image

/proc/cyborg_character_get_cached_genital_icon_data(cache_key, list/icon_cache)
	if(!istext(cache_key) || !length(cache_key) || !islist(icon_cache))
		return null

	return icon_cache[cache_key]

/proc/cyborg_character_set_cached_genital_icon_data(cache_key, list/icon_data, list/icon_cache, list/cache_order)
	if(!istext(cache_key) || !length(cache_key) || !islist(icon_data) || !islist(icon_cache) || !islist(cache_order))
		return

	if(!(cache_key in icon_cache))
		cache_order += cache_key
	icon_cache[cache_key] = icon_data
	while(length(cache_order) > 128)
		var/old_key = cache_order[1]
		cache_order.Cut(1, 2)
		icon_cache -= old_key

/proc/cyborg_character_get_rendered_genital_icon_data(mob/living/silicon/robot/owner_robot, mutable_appearance/genital_overlay, organ_slot, overlay_subindex, render_dir, image_cache_key = null, list/icon_cache = null, list/icon_cache_order = null, list/animation_offsets = null, list/animation_frame_delays = null, animation_label = null)
	if(!owner_robot || !genital_overlay)
		return null

	var/obj/effect/client_image_holder/cyborg_genital/preview_holder = new(owner_robot, owner_robot, image(genital_overlay), list(), organ_slot, overlay_subindex)
	var/image/render_image = image(genital_overlay)
	var/static_animation_pixel_x = 0
	var/static_animation_pixel_y = 0
	if(owner_robot.can_cyborg_genital_animate(organ_slot) && length(animation_offsets) && length(animation_frame_delays) && istext(animation_label))
		var/list/first_animation_offset = animation_offsets[1]
		if(islist(first_animation_offset))
			static_animation_pixel_x = first_animation_offset["pixel_x"] || 0
			static_animation_pixel_y = first_animation_offset["pixel_y"] || 0
	render_image.dir = render_dir
	render_image.loc = null
	render_image.appearance_flags |= KEEP_APART | PIXEL_SCALE
	if(!render_image)
		qdel(preview_holder)
		return null

	var/body_scale = owner_robot.get_cyborg_genital_offset_scale()
	var/source_pixel_x = (render_image.pixel_x || 0) + static_animation_pixel_x
	var/source_pixel_y = (render_image.pixel_y || 0) + static_animation_pixel_y
	var/list/cached_icon_data = cyborg_character_get_cached_genital_icon_data(image_cache_key, icon_cache)
	var/icon/transformed_icon = cached_icon_data?["icon"]
	var/static_pixel_x = cached_icon_data?["pixel_x"] || 0
	var/static_pixel_y = cached_icon_data?["pixel_y"] || 0

	if(!isicon(transformed_icon))
		var/matrix/render_transform = render_image.transform ? matrix(render_image.transform) : null
		var/image/flat_render_image = image(render_image)
		flat_render_image.pixel_x = 0
		flat_render_image.pixel_y = 0
		flat_render_image.transform = null
		var/icon/flat_icon = getFlatIcon(flat_render_image, render_dir, no_anim = TRUE)
		if(!isicon(flat_icon))
			qdel(preview_holder)
			return null

		var/list/transformed_icon_data = preview_holder.apply_cyborg_genital_appearance_transform(flat_icon, render_transform)
		transformed_icon = transformed_icon_data["icon"]
		if(!isicon(transformed_icon))
			qdel(preview_holder)
			return null

		static_pixel_x = transformed_icon_data["pixel_x"] || 0
		static_pixel_y = transformed_icon_data["pixel_y"] || 0
		if(body_scale != RESIZE_NORMAL)
			var/original_width = transformed_icon.Width()
			var/original_height = transformed_icon.Height()
			transformed_icon = owner_robot.scale_cyborg_icon_nearest_neighbor(transformed_icon, max(round(original_width * body_scale), 1), max(round(original_height * body_scale), 1))
			if(!isicon(transformed_icon))
				qdel(preview_holder)
				return null
			static_pixel_x += round((original_width - transformed_icon.Width()) / 2)
			static_pixel_y += round((original_height - transformed_icon.Height()) / 2) + round(owner_robot.get_transform_translation_size(body_scale))

		cyborg_character_set_cached_genital_icon_data(image_cache_key, list(
			"icon" = transformed_icon,
			"pixel_x" = static_pixel_x,
			"pixel_y" = static_pixel_y,
		), icon_cache, icon_cache_order)

	var/rendered_pixel_x = source_pixel_x + static_pixel_x
	var/rendered_pixel_y = source_pixel_y + static_pixel_y

	var/list/rendered_data = list(
		"icon" = transformed_icon,
		"pixel_x" = rendered_pixel_x,
		"pixel_y" = rendered_pixel_y,
		"width" = transformed_icon.Width(),
		"height" = transformed_icon.Height(),
	)
	qdel(preview_holder)
	return rendered_data

/proc/cyborg_character_build_preview_layer(icon/layer_icon, layer_key, layer_kind, pixel_x, pixel_y, z_index, image_cache_key = null, list/image_cache = null, list/image_cache_order = null)
	if(!isicon(layer_icon))
		return null

	return list(
		"key" = layer_key,
		"kind" = layer_kind,
		"image" = cyborg_character_get_cached_preview_image(layer_icon, image_cache_key, image_cache, image_cache_order),
		"x" = pixel_x,
		"y" = pixel_y,
		"width" = layer_icon.Width(),
		"height" = layer_icon.Height(),
		"z" = z_index,
	)

/proc/cyborg_character_trim_icon_to_visible_bounds(icon/source_icon, padding = 2)
	if(!isicon(source_icon))
		return null

	var/min_x = source_icon.Width() + 1
	var/min_y = source_icon.Height() + 1
	var/max_x = 0
	var/max_y = 0
	for(var/x in 1 to source_icon.Width())
		for(var/y in 1 to source_icon.Height())
			if(!source_icon.GetPixel(x, y))
				continue
			min_x = min(min_x, x)
			min_y = min(min_y, y)
			max_x = max(max_x, x)
			max_y = max(max_y, y)

	if(max_x < min_x || max_y < min_y)
		return source_icon

	var/icon/trimmed_icon = new(source_icon)
	trimmed_icon.Crop(min_x - padding, min_y - padding, max_x + padding, max_y + padding)
	return trimmed_icon

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
		"default_icon" = 'icons/mob/silicon/robots.dmi',
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

	model_snapshot["default_icon"] = model.cyborg_icon_override || 'icons/mob/silicon/robots.dmi'
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

/proc/cyborg_character_get_model_icon_data(model_name, variant_name = null, include_states = TRUE)
	var/list/model_snapshot = cyborg_character_ensure_model_snapshot(model_name)
	var/icon_file = model_snapshot["default_icon"] || 'icons/mob/silicon/robots.dmi'
	var/icon_state = model_snapshot["default_icon_state"] || "robot"
	var/canvas_size = 0
	var/selector_pixel_x = 0
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
		selector_pixel_x = variant_data["selector_pixel_x"] || 0
		if(islist(variant_data["skin_features"]))
			var/list/variant_skin_features = variant_data["skin_features"]
			skin_features = variant_skin_features.Copy()
	return list(
		"icon" = icon_file,
		"icon_state" = icon_state,
		"canvas_size" = canvas_size,
		"selector_pixel_x" = selector_pixel_x,
		"skin_features" = skin_features,
		"states" = include_states ? cyborg_character_get_model_preview_states(model_name, variant_name) : list(),
		"preview_width" = 32 + (32 * canvas_size),
		"preview_height" = 32 + (32 * canvas_size),
	)

/proc/cyborg_character_get_selector_thumbnail_base64(list/model_data, state_override = null)
	if(!islist(model_data))
		return null
	var/icon_file = model_data["icon"]
	var/icon_state = state_override || model_data["icon_state"] || "robot"
	if(isnull(icon_file))
		return null

	var/preview_dir = SOUTH
	var/selector_pixel_x = model_data["selector_pixel_x"] || 0
	var/static/list/preview_cache = list()
	var/cache_key = "[icon_file]|[icon_state]|[preview_dir]|[selector_pixel_x]"
	if(cache_key in preview_cache)
		return preview_cache[cache_key]

	var/icon/preview_icon = icon(icon_file, icon_state, preview_dir, 1, FALSE)
	if(!isicon(preview_icon))
		preview_cache[cache_key] = null
		return null

	var/should_trim = TRUE
	if(selector_pixel_x)
		var/icon/positioned_icon = icon('icons/blanks/32x32.dmi', "nothing")
		positioned_icon.Scale(max(preview_icon.Width() + abs(selector_pixel_x), 32), max(preview_icon.Height(), 32))
		positioned_icon.Blend(preview_icon, ICON_OVERLAY, max(selector_pixel_x + 1, 1), 1)
		preview_icon = positioned_icon
		should_trim = FALSE

	if(should_trim)
		preview_icon = cyborg_character_trim_icon_to_visible_bounds(preview_icon)
		if(!isicon(preview_icon))
			preview_cache[cache_key] = null
			return null

	var/preview_base64 = icon2base64(preview_icon)
	preview_cache[cache_key] = preview_base64
	return preview_base64

/proc/cyborg_character_get_model_preview_base64(model_name, variant_name = null)
	var/list/model_data = cyborg_character_get_model_icon_data(model_name, variant_name, FALSE)
	return cyborg_character_get_selector_thumbnail_base64(model_data)

/proc/cyborg_character_get_department_preview_options(list/model_catalog, selected_model)
	var/list/options = list()
	for(var/department_name in cyborg_character_get_model_names())
		var/list/department_models = model_catalog[department_name]
		var/preview_model = selected_model
		if(!(preview_model in department_models))
			preview_model = cyborg_character_get_default_model_variant(department_name)
		options += list(list(
			"value" = department_name,
			"label" = department_name,
			"preview_model" = preview_model,
			"preview_image" = cyborg_character_get_model_preview_base64(department_name, preview_model),
		))
	return options

/proc/cyborg_character_get_model_preview_options(model_department)
	var/list/options = list()
	for(var/model_name in cyborg_character_get_model_variant_names(model_department))
		options += list(list(
			"value" = model_name,
			"label" = model_name,
			"preview_image" = cyborg_character_get_model_preview_base64(model_department, model_name),
		))
	return options

/proc/cyborg_character_add_state_preview_images(list/state_options, model_department, model_name)
	var/list/model_data = cyborg_character_get_model_icon_data(model_department, model_name, FALSE)
	var/list/options = list()
	for(var/list/state_option as anything in state_options)
		var/list/option = state_option.Copy()
		option["preview_image"] = cyborg_character_get_selector_thumbnail_base64(model_data, option["icon_state"])
		options += list(option)
	return options

/proc/cyborg_character_get_preview_rest_stage_key(selected_state)
	if(!istext(selected_state) || !length(selected_state))
		return null
	var/separator = findtext(selected_state, ":")
	if(separator)
		selected_state = copytext(selected_state, 1, separator)
	if(selected_state == "rest_deep" || findtext(selected_state, "-rest_deep"))
		return "rest_deep"
	if(selected_state == "bellyup" || findtext(selected_state, "-bellyup"))
		return "bellyup"
	if(selected_state == "sit" || findtext(selected_state, "-sit"))
		return "sit"
	if(selected_state == "rest" || findtext(selected_state, "-rest"))
		return "rest"
	return null

/proc/cyborg_character_make_rest_direction_key(rest_stage_key, direction_key)
	if(!istext(rest_stage_key) || !length(rest_stage_key) || !istext(direction_key) || !length(direction_key))
		return null
	return "[rest_stage_key]:[direction_key]"

/proc/cyborg_character_get_rest_direction_key(direction_key, fallback_dir = SOUTH)
	if(!istext(direction_key) || !length(direction_key))
		return cyborg_character_dir_to_text(fallback_dir)
	var/separator = findtext(direction_key, ":")
	if(separator)
		var/specific_direction = copytext(direction_key, separator + 1)
		if(specific_direction in list("south", "north", "east", "west"))
			return specific_direction
	if(direction_key in list("south", "north", "east", "west"))
		return direction_key
	return cyborg_character_dir_to_text(fallback_dir)

/proc/cyborg_character_get_preview_direction_key(selected_state, selected_dir)
	var/rest_stage_key = cyborg_character_get_preview_rest_stage_key(selected_state)
	if(rest_stage_key)
		return cyborg_character_make_rest_direction_key(rest_stage_key, cyborg_character_dir_to_text(selected_dir))
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
	var/rest_direction_key = cyborg_character_get_rest_direction_key(direction_key, selected_dir)
	var/list/marker_point = null
	var/rest_stage_key = cyborg_character_get_preview_rest_stage_key(selected_state)
	if(rest_stage_key)
		marker_point = marker_data["rest_marker_point_by_stage"]?[rest_stage_key]?[rest_direction_key]
		if(!islist(marker_point))
			marker_point = marker_data["rest_marker_point_by_stage"]?[rest_stage_key]?["south"]
	if(!islist(marker_point))
		marker_point = marker_data["marker_point_by_direction"]?[rest_stage_key ? rest_direction_key : direction_key]
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
	var/rest_direction_key = cyborg_character_get_rest_direction_key(direction_key, selected_dir)
	var/list/marker_anchor = null
	var/rest_stage_key = cyborg_character_get_preview_rest_stage_key(selected_state)
	if(rest_stage_key)
		marker_anchor = marker_data["rest_anchor_by_stage"]?[rest_stage_key]?[rest_direction_key]
		if(!islist(marker_anchor))
			marker_anchor = marker_data["rest_anchor_by_stage"]?[rest_stage_key]?["south"]
	if(!islist(marker_anchor))
		marker_anchor = marker_data["anchor_by_direction"]?[rest_stage_key ? rest_direction_key : direction_key]
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
	var/uses_marker_anchor = FALSE
	if(islist(marker_point_offset))
		marker_point_x = marker_point_offset["pixel_x"] || 0
		marker_point_y = marker_point_offset["pixel_y"] || 0
	if(islist(marker_anchor_offset))
		uses_marker_anchor = TRUE
		marker_anchor_x = marker_anchor_offset["pixel_x"] || 0
		marker_anchor_y = marker_anchor_offset["pixel_y"] || 0
		// Marker anchor offsets are stored in live mob tile space: marker pixel
		// minus the normal 32x32 tile center and any wide/tall canvas anchor.
		// Convert them back to preview body top-left space before applying the
		// preview-side canvas anchor and update_transform() scaling math.
		pixel_x = round(marker_point_x - marker_anchor_x - (ICON_SIZE_X * 0.5))
		pixel_y = round(marker_point_y - marker_anchor_y - (ICON_SIZE_Y * 0.5))
	return list(
		"pixel_x" = pixel_x,
		"pixel_y" = pixel_y,
		"uses_marker_anchor" = uses_marker_anchor,
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
	var/list/direction_keys = list("south", "north", "east", "west", "rest", "sit", "bellyup", "rest_deep")
	for(var/rest_stage_key in list("rest", "sit", "bellyup", "rest_deep"))
		for(var/direction_key in list("south", "north", "east", "west"))
			direction_keys += cyborg_character_make_rest_direction_key(rest_stage_key, direction_key)
	return direction_keys

/proc/cyborg_character_get_direction_label(direction_key)
	switch(direction_key)
		if("south")
			return "South"
		if("north")
			return "North"
		if("east")
			return "East"
		if("west")
			return "West"
		if("rest")
			return "Rest"
		if("sit")
			return "Sit"
		if("bellyup")
			return "Belly Up"
		if("rest_deep")
			return "Deep Rest"
	return capitalize("[direction_key]")

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
		var/rest_stage_key = cyborg_character_get_preview_rest_stage_key(state_option?["value"])
		if(!rest_stage_key)
			continue
		var/icon_file = state_option?["icon"]
		var/state_name = state_option?["icon_state"]
		var/list/state_direction_entries = cyborg_character_get_state_direction_entries(icon_file, state_name)
		for(var/list/state_direction_entry as anything in state_direction_entries)
			var/state_direction_key = state_direction_entry?["value"]
			var/direction_key = cyborg_character_make_rest_direction_key(rest_stage_key, state_direction_key)
			if(!direction_key || seen_keys[direction_key])
				continue
			direction_entries += list(list(
				"value" = direction_key,
				"label" = state_direction_entry?["label"] || cyborg_character_get_direction_label(state_direction_key),
				"rest" = TRUE,
				"group" = rest_stage_key,
				"group_label" = state_option?["label"] || cyborg_character_get_direction_label(rest_stage_key),
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
		if(ORGAN_SLOT_ANUS)
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
	var/list/source_advanced = entry["advanced"]
	for(var/direction_key in cyborg_character_get_direction_keys())
		var/list/source_direction = source_advanced?[direction_key]
		var/rest_stage_key = cyborg_character_get_preview_rest_stage_key(direction_key)
		if(rest_stage_key && islist(source_advanced) && !(direction_key in source_advanced) && (rest_stage_key in source_advanced))
			source_direction = source_advanced[rest_stage_key]
		advanced[direction_key] = cyborg_character_sanitize_direction_entry(source_direction)
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
		if(ORGAN_SLOT_ANUS)
			return /datum/preference/choiced/silicon_genital_sprite/anus
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
		if("silicon_anus_sprite")
			return ORGAN_SLOT_ANUS
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
		if(ORGAN_SLOT_ANUS)
			return "Anus"
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
	return organ_slot in list(ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS)

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
			"preview_layers" = preferences.cyborg_character_preview_view.preview_layers,
			"preview_canvas_width" = preferences.cyborg_character_preview_view.preview_canvas_width,
			"preview_canvas_height" = preferences.cyborg_character_preview_view.preview_canvas_height,
			"models" = model_departments,
			"models_by_department" = model_catalog,
			"department_previews" = cyborg_character_get_department_preview_options(model_catalog, model_name),
			"model_previews" = cyborg_character_get_model_preview_options(model_department),
			"selected_department" = model_department,
			"selected_model" = preferences.cyborg_character_preview_model,
			"selected_state" = preferences.cyborg_character_preview_state,
			"base_state" = preview_data?["icon_state"] || "robot",
			"selected_dir" = preferences.cyborg_character_preview_dir,
			"preview_width" = preview_data?["preview_width"] || 32,
			"preview_height" = preview_data?["preview_height"] || 32,
			"size" = cyborg_character_sanitize_size(preferences.read_preference(/datum/preference/numeric/cyborg_size)),
			"size_options" = cyborg_character_get_allowed_sizes(),
			"states" = cyborg_character_add_state_preview_images(preview_state_options, model_department, model_name),
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

	var/old_model = preferences.cyborg_character_preview_model
	var/list/department_models = model_catalog[department_name]
	preferences.cyborg_character_preview_department = department_name
	preferences.cyborg_character_preview_model = (old_model in department_models) ? old_model : cyborg_character_get_default_model_variant(department_name)
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
	if(!(organ_slot in list(ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS)))
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
	var/arousal_key = cyborg_character_get_layout_arousal_key(text2num("[params["arousal"]]"))
	if(arousal_key)
		var/list/direction_entry = cyborg_character_sanitize_direction_entry(layout_entry["advanced"]?[direction_key])
		if(islist(direction_entry["arousal"]))
			direction_entry["arousal"] -= arousal_key
			if(!length(direction_entry["arousal"]))
				direction_entry -= "arousal"
		layout_entry["advanced"][direction_key] = cyborg_character_sanitize_direction_entry(direction_entry)
	else
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
	var/list/preview_layers = list()
	var/preview_canvas_width = ICON_SIZE_X
	var/preview_canvas_height = ICON_SIZE_Y
	var/list/layer_image_cache = list()
	var/list/layer_image_cache_order = list()
	var/list/genital_icon_cache = list()
	var/list/genital_icon_cache_order = list()

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
	layer_image_cache = null
	layer_image_cache_order = null
	genital_icon_cache = null
	genital_icon_cache_order = null
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

/atom/movable/screen/map_view/cyborg_character_preview/proc/configure_preview_robot_state(mob/living/silicon/robot/cyborg_character_catalog_host/catalog_host, list/store, list/model_data, selected_state, selected_dir, selected_size = RESIZE_NORMAL)
	if(!catalog_host)
		return

	catalog_host.icon = model_data?["icon"] || catalog_host.icon
	catalog_host.icon_state = selected_state
	catalog_host.dir = selected_dir
	catalog_host.current_size = max(selected_size || RESIZE_NORMAL, 0.25)
	catalog_host.transform = null
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
	var/selected_size = cyborg_character_sanitize_size(preferences.read_preference(/datum/preference/numeric/cyborg_size))

	var/mob/living/silicon/robot/cyborg_character_catalog_host/catalog_host = ensure_preview_robot(model_department, model_name, model_data)
	configure_preview_robot_state(catalog_host, store, model_data, resolved_icon_state, preview_dir, selected_size)
	var/list/marker_data = catalog_host.get_cyborg_genital_animation_marker_data()
	var/list/preview_canvas_anchor_offset = catalog_host.get_cyborg_genital_canvas_anchor_offset()
	var/list/body_offset = cyborg_character_get_preview_body_offset(model_data, resolved_icon_state, preview_dir, marker_data)
	var/body_offset_scale = body_offset["uses_marker_anchor"] ? selected_size : RESIZE_NORMAL
	var/body_anchor_pixel_x = body_offset["uses_marker_anchor"] ? (preview_canvas_anchor_offset?["pixel_x"] || 0) : 0
	var/body_anchor_pixel_y = body_offset["uses_marker_anchor"] ? (preview_canvas_anchor_offset?["pixel_y"] || 0) : 0
	var/preview_body_pixel_x = round((body_offset["pixel_x"] || 0) * body_offset_scale) + (catalog_host.pixel_w || 0) - body_anchor_pixel_x
	var/preview_body_pixel_y = round((body_offset["pixel_y"] || 0) * body_offset_scale) + (catalog_host.pixel_z || 0) - body_anchor_pixel_y
	var/preview_base_width = model_data?["preview_width"] || ICON_SIZE_X
	var/preview_base_height = model_data?["preview_height"] || ICON_SIZE_Y
	if(canvas_size == 0)
		preview_base_width = ICON_SIZE_X
		preview_base_height = ICON_SIZE_Y
	else if(canvas_size == 1)
		preview_base_width = 64
		preview_base_height = 64
	else
		preview_base_width = 96
		preview_base_height = 96
	var/icon/body_icon = icon(icon_file, resolved_icon_state, preview_dir, 1, FALSE)
	if(isicon(body_icon) && selected_size != RESIZE_NORMAL)
		body_icon = catalog_host.scale_cyborg_icon_nearest_neighbor(body_icon, max(round(body_icon.Width() * selected_size), 1), max(round(body_icon.Height() * selected_size), 1))
	var/body_width = isicon(body_icon) ? body_icon.Width() : ICON_SIZE_X
	var/body_height = isicon(body_icon) ? body_icon.Height() : ICON_SIZE_Y
	var/list/body_scale_offset = catalog_host.get_cyborg_genital_transform_offset()
	var/preview_body_draw_pixel_x = preview_body_pixel_x + (body_scale_offset?["pixel_x"] || 0)
	var/preview_body_draw_pixel_y = preview_body_pixel_y + (body_scale_offset?["pixel_y"] || 0)
	var/preview_margin = 96
	var/canvas_state = preferences.read_preference(/datum/preference/choiced/background_state)
	if(!istext(canvas_state) || !length(canvas_state))
		canvas_state = "clear"
	var/preview_content_min_x = preview_body_draw_pixel_x
	var/preview_content_min_y = preview_body_draw_pixel_y
	var/preview_content_max_x = preview_body_draw_pixel_x + body_width
	var/preview_content_max_y = preview_body_draw_pixel_y + body_height
	var/list/raw_layers = list()
	if(isicon(body_icon))
		raw_layers += list(list(
			"icon" = body_icon,
			"x" = preview_body_draw_pixel_x,
			"y" = preview_body_draw_pixel_y,
			"z" = round(MOB_LAYER * 100000),
			"key" = "body",
			"kind" = "body",
			"image_cache_key" = "body|[icon_file]|[resolved_icon_state]|[preview_dir]|[selected_size]",
		))

	var/preview_direction_key = catalog_host.get_cyborg_genital_direction_key()
	var/list/preview_idle_offsets
	var/list/preview_idle_frame_delays
	var/preview_animation_label
	if(selected_state_token == "idle" && !catalog_host.robot_resting)
		preview_idle_offsets = catalog_host.get_cyborg_genital_idle_offsets(preview_direction_key)
		preview_idle_frame_delays = catalog_host.get_cyborg_automated_idle_frame_delays()
		if(length(preview_idle_offsets) && length(preview_idle_frame_delays))
			preview_animation_label = "idle"
	for(var/organ_slot in catalog_host.get_cyborg_genital_slots())
		var/list/base_genital_overlays = catalog_host.make_cyborg_genital_overlay(organ_slot, preview_dir, preview_direction_key, TRUE)
		var/list/genital_layout_entry = catalog_host.get_cyborg_genital_layout_entry(organ_slot)
		var/list/genital_direction_entry = catalog_host.get_cyborg_genital_direction_entry(organ_slot, genital_layout_entry, preview_direction_key)
		var/datum/sprite_accessory/genital/genital_accessory = catalog_host.get_cyborg_genital_sprite_accessory(organ_slot)
		var/genital_sprite_suffix = catalog_host.get_cyborg_genital_overlay_sprite_suffix(organ_slot, genital_accessory)
		var/genital_render_scale = catalog_host.uses_cyborg_direct_genital_overlay(genital_accessory) ? catalog_host.get_cyborg_direct_genital_render_scale(organ_slot, genital_accessory, genital_sprite_suffix, genital_layout_entry) : catalog_host.get_cyborg_genital_generic_render_scale(organ_slot, genital_layout_entry)
		var/genital_layout_cache_key = json_encode(list(
			"sprite" = catalog_host.get_cyborg_genital_sprite_choice(organ_slot),
			"accessory" = "[genital_accessory?.type]",
			"icon" = "[genital_accessory?.icon]",
			"icon_state" = genital_accessory?.icon_state,
			"suffix" = genital_sprite_suffix,
			"direct" = catalog_host.uses_cyborg_direct_genital_overlay(genital_accessory),
			"render_scale" = genital_render_scale,
			"scale" = genital_layout_entry["scale"],
			"rotation" = genital_layout_entry["rotation"],
			"colors" = genital_layout_entry["colors"],
			"direction" = genital_direction_entry,
		))
		var/overlay_subindex = 0
		for(var/mutable_appearance/genital_overlay as anything in base_genital_overlays)
			overlay_subindex++
			genital_overlay.plane = FLOAT_PLANE
			var/genital_transform_key = genital_overlay.transform ? json_encode(matrix(genital_overlay.transform).tolist()) : ""
			var/genital_animation_key = preview_animation_label ? "[preview_animation_label]|[json_encode(preview_idle_offsets)]|[json_encode(preview_idle_frame_delays)]" : ""
			var/genital_image_cache_key = "genital|[organ_slot]|[overlay_subindex]|[preview_dir]|[selected_size]|[genital_layout_cache_key]|[genital_overlay.icon]|[genital_overlay.icon_state]|[genital_overlay.color]|[genital_overlay.alpha]|[genital_transform_key]|[genital_animation_key]"
			var/list/rendered_genital_data = cyborg_character_get_rendered_genital_icon_data(catalog_host, genital_overlay, organ_slot, overlay_subindex, preview_dir, genital_image_cache_key, genital_icon_cache, genital_icon_cache_order, preview_idle_offsets, preview_idle_frame_delays, preview_animation_label)
			var/icon/rendered_genital_icon = rendered_genital_data?["icon"]
			if(isicon(rendered_genital_icon))
				var/genital_draw_x = preview_body_pixel_x + (rendered_genital_data["pixel_x"] || 0)
				var/genital_draw_y = preview_body_pixel_y + (rendered_genital_data["pixel_y"] || 0)
				preview_content_min_x = min(preview_content_min_x, genital_draw_x)
				preview_content_min_y = min(preview_content_min_y, genital_draw_y)
				preview_content_max_x = max(preview_content_max_x, genital_draw_x + rendered_genital_icon.Width())
				preview_content_max_y = max(preview_content_max_y, genital_draw_y + rendered_genital_icon.Height())
				raw_layers += list(list(
					"icon" = rendered_genital_icon,
					"x" = genital_draw_x,
					"y" = genital_draw_y,
					"z" = round((genital_overlay.layer || ABOVE_MOB_LAYER) * 100000) + overlay_subindex,
					"key" = "genital-[organ_slot]-[overlay_subindex]",
					"kind" = "genital",
					"image_cache_key" = genital_image_cache_key,
				))

	var/mutable_appearance/drawover_overlay = (selected_state_token == "rest_deep") ? null : catalog_host.build_cyborg_side_drawover_overlay()
	if(drawover_overlay)
		drawover_overlay.plane = FLOAT_PLANE
		var/image/drawover_render_image = image(drawover_overlay)
		drawover_render_image.dir = preview_dir
		drawover_render_image.pixel_x = 0
		drawover_render_image.pixel_y = 0
		drawover_render_image.transform = null
		var/icon/drawover_flat_icon
		if(drawover_render_image.icon)
			drawover_flat_icon = icon(drawover_render_image.icon, drawover_render_image.icon_state, preview_dir, 1, FALSE)
		if(!isicon(drawover_flat_icon))
			drawover_flat_icon = getFlatIcon(drawover_render_image, preview_dir, no_anim = TRUE)
		if(isicon(drawover_flat_icon))
			if(selected_size != RESIZE_NORMAL)
				drawover_flat_icon = catalog_host.scale_cyborg_icon_nearest_neighbor(drawover_flat_icon, max(round(drawover_flat_icon.Width() * selected_size), 1), max(round(drawover_flat_icon.Height() * selected_size), 1))
			var/drawover_draw_x = preview_body_draw_pixel_x + drawover_overlay.pixel_x
			var/drawover_draw_y = preview_body_draw_pixel_y + drawover_overlay.pixel_y
			preview_content_min_x = min(preview_content_min_x, drawover_draw_x)
			preview_content_min_y = min(preview_content_min_y, drawover_draw_y)
			preview_content_max_x = max(preview_content_max_x, drawover_draw_x + drawover_flat_icon.Width())
			preview_content_max_y = max(preview_content_max_y, drawover_draw_y + drawover_flat_icon.Height())
			raw_layers += list(list(
				"icon" = drawover_flat_icon,
				"x" = drawover_draw_x,
				"y" = drawover_draw_y,
				"z" = round((drawover_overlay.layer || ABOVE_MOB_LAYER) * 100000) + 50000,
				"key" = "drawover",
				"kind" = "drawover",
				"image_cache_key" = "drawover|static|[drawover_overlay.icon]|[drawover_overlay.icon_state]|[preview_dir]|[selected_size]|[drawover_overlay.color]|[drawover_overlay.alpha]",
			))

	var/preview_pad_left = max(-preview_content_min_x, 0) + preview_margin
	var/preview_pad_down = max(-preview_content_min_y, 0) + preview_margin
	preview_canvas_width = max(preview_base_width + preview_pad_left + preview_margin, preview_content_max_x + preview_pad_left + preview_margin)
	preview_canvas_height = max(preview_base_height + preview_pad_down + preview_margin, preview_content_max_y + preview_pad_down + preview_margin)
	preview_canvas_width = max(preview_canvas_width, 1)
	preview_canvas_height = max(preview_canvas_height, 1)

	var/icon/background_icon = icon('modular_zubbers/icons/customization/template_96x96.dmi', canvas_state)
	var/background_tile_size = 96
	var/icon/background_preview_icon = icon('icons/blanks/32x32.dmi', "nothing")
	background_preview_icon.Scale(preview_canvas_width, preview_canvas_height)
	for(var/tile_x in 1 to preview_canvas_width step background_tile_size)
		for(var/tile_y in 1 to preview_canvas_height step background_tile_size)
			background_preview_icon.Blend(background_icon, ICON_OVERLAY, tile_x, tile_y)

	preview_layers = list()
	preview_layers += list(cyborg_character_build_preview_layer(background_preview_icon, "background", "background", 0, 0, 0, "background|[canvas_state]|[preview_canvas_width]|[preview_canvas_height]", layer_image_cache, layer_image_cache_order))
	for(var/list/raw_layer as anything in raw_layers)
		var/icon/layer_icon = raw_layer["icon"]
		var/list/preview_layer = cyborg_character_build_preview_layer(
			layer_icon,
			raw_layer["key"],
			raw_layer["kind"],
			(raw_layer["x"] || 0) + preview_pad_left,
			(raw_layer["y"] || 0) + preview_pad_down,
			raw_layer["z"] || 0,
			raw_layer["image_cache_key"],
			layer_image_cache,
			layer_image_cache_order,
		)
		if(preview_layer)
			preview_layers += list(preview_layer)

	preview_image = null
