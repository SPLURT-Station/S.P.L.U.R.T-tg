/obj/effect/client_image_holder/cyborg_genital
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = KEEP_APART

	var/mob/living/silicon/robot/owner_robot
	var/image/base_image_appearance
	var/base_image_appearance_key
	var/image/image_appearance
	var/matrix/base_transform
	var/cyborg_genital_active_animation_key
	var/list/cyborg_genital_active_animation_direction_pixels
	var/cyborg_genital_organ_slot
	var/cyborg_genital_overlay_subindex = 1

/obj/effect/client_image_holder/cyborg_genital/Initialize(mapload, mob/living/silicon/robot/new_owner, image/new_appearance, list/mobs_which_see_us, new_organ_slot = null, new_overlay_subindex = 1)
	owner_robot = new_owner
	cyborg_genital_organ_slot = new_organ_slot
	cyborg_genital_overlay_subindex = max(new_overlay_subindex || 1, 1)
	base_image_appearance = new_appearance
	base_image_appearance_key = get_cyborg_genital_animation_base_key() || get_cyborg_genital_base_appearance_key(new_appearance)
	image_appearance = new_appearance
	cache_cyborg_genital_base_appearance_data(new_appearance)
	. = ..(mapload, mobs_which_see_us)

/obj/effect/client_image_holder/cyborg_genital/generate_image()
	if(!owner_robot || !image_appearance)
		return ..()

	var/image/generated = image(image_appearance)
	generated.loc = owner_robot
	generated.dir = owner_robot.dir
	generated.appearance_flags |= KEEP_APART | PIXEL_SCALE
	var/list/animation_pixels = get_cyborg_genital_active_animation_pixels(owner_robot.dir)
	if(islist(animation_pixels))
		generated.pixel_x = animation_pixels["pixel_x"] || 0
		generated.pixel_y = animation_pixels["pixel_y"] || 0
	if(generated.plane == FLOAT_PLANE)
		SET_PLANE_EXPLICIT(generated, GAME_PLANE, owner_robot)
	if(image_appearance == base_image_appearance)
		base_pixel_x = generated.pixel_x
		base_pixel_y = generated.pixel_y
		base_pixel_w = generated.pixel_w
		base_pixel_z = generated.pixel_z
		base_transform = generated.transform ? matrix(generated.transform) : null
	return generated

/obj/effect/client_image_holder/cyborg_genital/regenerate_image()
	var/image/new_image = generate_image()
	if(shown_image)
		shown_image.appearance = new_image.appearance
		shown_image.loc = new_image.loc
		shown_image.dir = new_image.dir
	else
		shown_image = new_image

	for(var/mob/seer as anything in who_sees_us)
		show_image_to(seer)

/obj/effect/client_image_holder/cyborg_genital/proc/reset_cyborg_animation()
	if(image_appearance != base_image_appearance)
		image_appearance = base_image_appearance
		cyborg_genital_active_animation_key = null
		cyborg_genital_active_animation_direction_pixels = null
		regenerate_image()
	return !!shown_image

/obj/effect/client_image_holder/cyborg_genital/proc/clear_cyborg_active_animation(regenerate = TRUE)
	cyborg_genital_active_animation_key = null
	cyborg_genital_active_animation_direction_pixels = null
	if(image_appearance != base_image_appearance)
		image_appearance = base_image_appearance
		if(regenerate)
			regenerate_image()
	return TRUE

/obj/effect/client_image_holder/cyborg_genital/proc/cache_cyborg_genital_base_appearance_data(image/appearance_to_cache)
	if(!appearance_to_cache)
		return FALSE
	base_pixel_x = appearance_to_cache.pixel_x
	base_pixel_y = appearance_to_cache.pixel_y
	base_pixel_w = appearance_to_cache.pixel_w
	base_pixel_z = appearance_to_cache.pixel_z
	base_transform = appearance_to_cache.transform ? matrix(appearance_to_cache.transform) : null
	return TRUE

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_active_animation_pixels(output_dir)
	if(!islist(cyborg_genital_active_animation_direction_pixels) || !owner_robot)
		return null
	var/direction_key = owner_robot.get_cyborg_genital_direction_key_for_dir(output_dir)
	if(!direction_key)
		return null
	return cyborg_genital_active_animation_direction_pixels[direction_key]

/obj/effect/client_image_holder/cyborg_genital/proc/apply_cyborg_genital_animation_direction_pixels(output_dir)
	if(!shown_image)
		return FALSE
	var/list/animation_pixels = get_cyborg_genital_active_animation_pixels(output_dir)
	if(!islist(animation_pixels))
		return FALSE
	shown_image.pixel_x = animation_pixels["pixel_x"] || 0
	shown_image.pixel_y = animation_pixels["pixel_y"] || 0
	return TRUE

/obj/effect/client_image_holder/cyborg_genital/proc/update_image_appearance(image/new_appearance, defer_active_animation_regenerate = FALSE)
	var/new_appearance_key = get_cyborg_genital_animation_base_key() || get_cyborg_genital_base_appearance_key(new_appearance)
	var/appearance_matches_active_base = !isnull(new_appearance_key) && new_appearance_key == base_image_appearance_key
	base_image_appearance = new_appearance
	base_image_appearance_key = new_appearance_key
	cache_cyborg_genital_base_appearance_data(new_appearance)
	if(appearance_matches_active_base && image_appearance != base_image_appearance && cyborg_genital_active_animation_key)
		if(shown_image)
			shown_image.dir = owner_robot?.dir || shown_image.dir
		return TRUE
	if(defer_active_animation_regenerate && image_appearance != base_image_appearance && cyborg_genital_active_animation_key)
		cyborg_genital_active_animation_key = null
		cyborg_genital_active_animation_direction_pixels = null
		return TRUE

	image_appearance = new_appearance
	cyborg_genital_active_animation_key = null
	cyborg_genital_active_animation_direction_pixels = null
	regenerate_image()
	return TRUE

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_directional_base_appearance(output_dir)
	if(!owner_robot || isnull(cyborg_genital_organ_slot))
		return null

	var/list/directional_overlays = owner_robot.make_cyborg_genital_overlay(cyborg_genital_organ_slot, output_dir)
	if(cyborg_genital_overlay_subindex > length(directional_overlays))
		return null
	return directional_overlays[cyborg_genital_overlay_subindex]

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_animation_base_key()
	if(!owner_robot || isnull(cyborg_genital_organ_slot))
		return null

	var/list/base_keys = list()
	for(var/output_dir in GLOB.cardinals)
		var/image/directional_appearance = get_cyborg_genital_directional_base_appearance(output_dir)
		base_keys += directional_appearance ? get_cyborg_genital_base_appearance_key(directional_appearance) : "null"
	return base_keys.Join("|")

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_base_appearance_key(image/appearance_to_key)
	if(!appearance_to_key)
		return null

	var/transform_key = "identity"
	if(appearance_to_key.transform)
		var/matrix/appearance_transform = matrix(appearance_to_key.transform)
		var/list/transform_values = appearance_transform.tolist()
		transform_key = transform_values.Join(",")
	return "[appearance_to_key.icon]-[appearance_to_key.icon_state]-dir[appearance_to_key.dir]-layer[appearance_to_key.layer]-plane[appearance_to_key.plane]-px[appearance_to_key.pixel_x]-py[appearance_to_key.pixel_y]-pw[appearance_to_key.pixel_w]-pz[appearance_to_key.pixel_z]-color[appearance_to_key.color]-alpha[appearance_to_key.alpha]-transform[transform_key]"

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_animation_identity_key(list/offsets, list/frame_delays, animation_label)
	var/body_scale = owner_robot?.get_cyborg_genital_body_scale() || 1
	var/delay_key = owner_robot ? owner_robot.format_cyborg_genital_animation_delays(frame_delays) : "[frame_delays]"
	var/list/directional_offset_keys = list()
	if(owner_robot)
		for(var/output_dir in GLOB.cardinals)
			var/direction_key = owner_robot.get_cyborg_genital_direction_key_for_dir(output_dir)
			var/list/directional_offsets = owner_robot.get_cyborg_genital_animation_offsets_for_direction(animation_label, direction_key)
			if(!length(directional_offsets) && output_dir == owner_robot.dir)
				directional_offsets = offsets
			directional_offset_keys += "[direction_key]=[owner_robot.format_cyborg_genital_animation_offsets(directional_offsets)]"
	else
		directional_offset_keys += "[offsets]"
	return "[animation_label]-scale[body_scale]-offsets[directional_offset_keys.Join("|")]-delays[delay_key]"

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_animation_cache_key(list/offsets, list/frame_delays, animation_label)
	return "rev[owner_robot?.cyborg_genital_appearance_revision || 0]-[base_image_appearance_key]-[get_cyborg_genital_animation_identity_key(offsets, frame_delays, animation_label)]"

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_animation_state_name(animation_label)
	var/list/marker_source = owner_robot?.get_cyborg_genital_animation_marker_source()
	var/base_state = marker_source?["marker_state"] || marker_source?["state"] || base_image_appearance?.icon_state || "cyborg_genital"
	return "[base_state]_[animation_label]"

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_metadata_state_delays(list/dmi_metadata, animation_state, moving)
	if(!islist(dmi_metadata) || !islist(dmi_metadata["states"]))
		return null
	for(var/list/state_metadata as anything in dmi_metadata["states"])
		if(state_metadata?["name"] != animation_state)
			continue
		if(!!state_metadata?["movement"] != !!moving)
			continue
		if(islist(state_metadata["delay"]))
			return state_metadata["delay"]
		if(islist(state_metadata["delays"]))
			return state_metadata["delays"]
	return null

/obj/effect/client_image_holder/cyborg_genital/proc/cyborg_genital_delay_lists_match(list/expected_delays, list/actual_delays)
	if(length(expected_delays) != length(actual_delays))
		return FALSE
	for(var/frame_index in 1 to length(expected_delays))
		if(text2num("[expected_delays[frame_index]]") != text2num("[actual_delays[frame_index]]"))
			return FALSE
	return TRUE

/obj/effect/client_image_holder/cyborg_genital/proc/inject_cyborg_genital_animation_metadata(path, list/dmi_metadata)
	if(!istext(path) || !length(path) || !islist(dmi_metadata))
		return FALSE

	// rustg appends injected metadata, so strip the old DMI chunk first or reads keep seeing stale frame delays.
	var/strip_error = rustg_dmi_strip_metadata(path)
	if(strip_error)
		return FALSE

	var/inject_error = rustg_dmi_inject_metadata(path, json_encode(dmi_metadata))
	if(inject_error)
		return FALSE

	return TRUE

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_animation_metadata(list/source_metadata, canvas_width, canvas_height, animation_state, list/frame_delays, moving)
	var/list/metadata = islist(source_metadata) ? deep_copy_list(source_metadata) : list()
	var/list/states = islist(metadata["states"]) ? metadata["states"] : list()
	var/state_updated = FALSE

	for(var/state_index in 1 to length(states))
		var/list/state_metadata = states[state_index]
		if(!islist(state_metadata))
			continue
		if(state_metadata?["name"] != animation_state)
			continue
		if(!!state_metadata?["movement"] != !!moving)
			continue

		state_metadata["dirs"] = 4
		state_metadata["delay"] = frame_delays
		if(moving)
			state_metadata["movement"] = 1
		else
			state_metadata -= "movement"
		states[state_index] = state_metadata
		state_updated = TRUE
		break

	if(!state_updated)
		var/list/state_metadata = list(
			"name" = animation_state,
			"dirs" = 4,
			"delay" = frame_delays,
		)
		if(moving)
			state_metadata["movement"] = 1
		states += list(state_metadata)

	metadata["width"] = canvas_width
	metadata["height"] = canvas_height
	metadata["states"] = states
	return metadata

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_blank_animation_template(canvas_width, canvas_height, animation_state, list/frame_delays, moving)
	if(canvas_width < 1 || canvas_height < 1 || !istext(animation_state) || !length(animation_state) || !length(frame_delays))
		return null

	var/delay_key = owner_robot ? owner_robot.format_cyborg_genital_animation_delays(frame_delays) : "[frame_delays]"
	var/template_key = "[canvas_width]x[canvas_height]-[animation_state]-moving[moving]-dirs4-delays[delay_key]"
	var/static/list/cached_blank_templates = list()
	if(cached_blank_templates[template_key])
		return cached_blank_templates[template_key]

	var/icon/blank_frame = icon('icons/blanks/32x32.dmi', "nothing")
	if(blank_frame.Width() != canvas_width || blank_frame.Height() != canvas_height)
		blank_frame.Scale(canvas_width, canvas_height)

	var/icon/template_icon = new /icon()
	for(var/output_dir in GLOB.cardinals)
		for(var/frame_index in 1 to length(frame_delays))
			template_icon.Insert(blank_frame, animation_state, dir = output_dir, frame = frame_index, moving = moving)

	var/tmp_path = "tmp/cyborg_genital_blank_[world.time]_[rand(1, 1e9)].dmi"
	if(!fcopy(template_icon, tmp_path))
		return null

	var/list/template_readback_metadata = rustg_dmi_read_metadata(tmp_path)
	var/list/dmi_metadata = get_cyborg_genital_animation_metadata(template_readback_metadata, canvas_width, canvas_height, animation_state, frame_delays, moving)
	inject_cyborg_genital_animation_metadata(tmp_path, dmi_metadata)
	var/icon/fixed_template = icon(tmp_path)
	fdel(tmp_path)
	if(!isicon(fixed_template))
		return null

	if(length(cached_blank_templates) > 128)
		cached_blank_templates.Cut()
	cached_blank_templates[template_key] = fixed_template
	return fixed_template

/obj/effect/client_image_holder/cyborg_genital/proc/finalize_cyborg_genital_baked_icon(icon/animated_icon, canvas_width, canvas_height, animation_state, list/frame_delays, moving)
	if(!isicon(animated_icon))
		return null

	var/tmp_path = "tmp/cyborg_genital_baked_[world.time]_[rand(1, 1e9)].dmi"
	if(!fcopy(animated_icon, tmp_path))
		return animated_icon

	var/list/readback_metadata = rustg_dmi_read_metadata(tmp_path)
	var/list/readback_delays = get_cyborg_genital_metadata_state_delays(readback_metadata, animation_state, moving)
	if(cyborg_genital_delay_lists_match(frame_delays, readback_delays))
		fdel(tmp_path)
		return animated_icon

	var/list/dmi_metadata = get_cyborg_genital_animation_metadata(readback_metadata, canvas_width, canvas_height, animation_state, frame_delays, moving)
	inject_cyborg_genital_animation_metadata(tmp_path, dmi_metadata)

	var/icon/repaired_icon = icon(tmp_path)
	// BYOND can lazily read DMI metadata from file-backed icons. Keep repaired
	// animation DMIs available after readback so later flattening/client renders
	// do not lose the baked state metadata out from under the icon.
	return isicon(repaired_icon) ? repaired_icon : animated_icon

/obj/effect/client_image_holder/cyborg_genital/proc/apply_cyborg_genital_appearance_transform(icon/flat_icon, matrix/appearance_transform)
	if(!isicon(flat_icon) || !appearance_transform)
		return list("icon" = flat_icon, "pixel_x" = 0, "pixel_y" = 0)

	var/datum/decompose_matrix/decomposed_transform = appearance_transform.decompose()
	var/original_width = max(flat_icon.Width(), 1)
	var/original_height = max(flat_icon.Height(), 1)
	var/icon/transformed_icon = new(flat_icon)

	var/scale_x = abs(decomposed_transform.scale_x || 1)
	var/scale_y = abs(decomposed_transform.scale_y || 1)
	if(scale_x != 1 || scale_y != 1)
		transformed_icon.Scale(max(round(original_width * scale_x), 1), max(round(original_height * scale_y), 1))

	var/rotation = decomposed_transform.rotation || 0
	if(rotation)
		transformed_icon.Turn(rotation)

	return list(
		"icon" = transformed_icon,
		"pixel_x" = round((original_width - transformed_icon.Width()) / 2),
		"pixel_y" = round((original_height - transformed_icon.Height()) / 2),
	)

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_animation_start_frame(list/frame_delays, total_cycle_time, preserve_phase, phase_start_time = 0)
	if(!preserve_phase || total_cycle_time <= 0)
		return 1

	var/cycle_progress = max(world.time - phase_start_time, 0) % total_cycle_time
	var/accumulated_time = 0
	for(var/frame_index in 1 to length(frame_delays))
		var/frame_delay = frame_delays[frame_index]
		if(cycle_progress < accumulated_time + frame_delay)
			return frame_index
		accumulated_time += frame_delay
	return 1

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_animation_frame_record_data(list/offsets, list/frame_delays, animation_label, start_frame_index)
	if(!owner_robot || !base_image_appearance || !length(offsets) || !length(frame_delays))
		return null

	var/body_scale = owner_robot.get_cyborg_genital_body_scale()
	var/frame_count = min(length(offsets), length(frame_delays))
	if(frame_count <= 0)
		return null

	var/list/rotated_frame_delays = list()
	for(var/sequence_index in 0 to (frame_count - 1))
		var/source_frame_index = ((start_frame_index - 1 + sequence_index) % frame_count) + 1
		rotated_frame_delays += frame_delays[source_frame_index]

	var/list/frame_records = list()
	var/canvas_left_extent = 0
	var/canvas_right_extent = 1
	var/canvas_down_extent = 0
	var/canvas_up_extent = 1
	for(var/output_dir in GLOB.cardinals)
		var/direction_key = owner_robot.get_cyborg_genital_direction_key_for_dir(output_dir)
		var/image/directional_appearance = get_cyborg_genital_directional_base_appearance(output_dir)
		if(!directional_appearance)
			continue

		var/image/base_render_image = image(directional_appearance)
		base_render_image.dir = output_dir
		var/matrix/appearance_transform = directional_appearance.transform ? matrix(directional_appearance.transform) : null
		base_render_image.pixel_x = 0
		base_render_image.pixel_y = 0
		base_render_image.pixel_w = 0
		base_render_image.pixel_z = 0
		base_render_image.transform = null
		var/icon/base_flat_icon = getFlatIcon(base_render_image, output_dir, no_anim = TRUE)
		if(!base_flat_icon)
			continue
		var/list/transformed_flat_icon_data = apply_cyborg_genital_appearance_transform(base_flat_icon, appearance_transform)
		base_flat_icon = transformed_flat_icon_data["icon"]
		if(!base_flat_icon)
			continue

		var/list/directional_offsets = owner_robot.get_cyborg_genital_animation_offsets_for_direction(animation_label, direction_key)
		if(!length(directional_offsets) && output_dir == owner_robot.dir)
			directional_offsets = offsets
		if(!length(directional_offsets))
			continue

		var/source_width = max(base_flat_icon.Width(), 1)
		var/source_height = max(base_flat_icon.Height(), 1)
		var/base_screen_pixel_x = (directional_appearance.pixel_x || 0) + transformed_flat_icon_data["pixel_x"]
		var/base_screen_pixel_y = (directional_appearance.pixel_y || 0) + transformed_flat_icon_data["pixel_y"]
		var/source_center_x = source_width * 0.5
		var/source_center_y = source_height * 0.5
		for(var/sequence_index in 0 to (frame_count - 1))
			var/source_frame_index = ((start_frame_index - 1 + sequence_index) % frame_count) + 1
			var/list/source_offset = directional_offsets[source_frame_index]
			if(!islist(source_offset))
				source_offset = list()
			var/animation_pixel_x = round((source_offset?["pixel_x"] || 0) * body_scale)
			var/animation_pixel_y = round((source_offset?["pixel_y"] || 0) * body_scale)
			canvas_left_extent = max(canvas_left_extent, source_center_x - animation_pixel_x)
			canvas_right_extent = max(canvas_right_extent, source_center_x + animation_pixel_x)
			canvas_down_extent = max(canvas_down_extent, source_center_y - animation_pixel_y)
			canvas_up_extent = max(canvas_up_extent, source_center_y + animation_pixel_y)
			frame_records += list(list(
				"dir" = output_dir,
				"direction_key" = direction_key,
				"frame" = sequence_index + 1,
				"icon" = base_flat_icon,
				"source_width" = source_width,
				"source_height" = source_height,
				"base_pixel_x" = base_screen_pixel_x,
				"base_pixel_y" = base_screen_pixel_y,
				"animation_pixel_x" = animation_pixel_x,
				"animation_pixel_y" = animation_pixel_y,
			))

	if(!length(frame_records))
		return null

	var/canvas_center_x = ceil(canvas_left_extent)
	var/canvas_center_y = ceil(canvas_down_extent)
	var/canvas_width = max(ceil(canvas_left_extent + canvas_right_extent), 1)
	var/canvas_height = max(ceil(canvas_down_extent + canvas_up_extent), 1)
	return list(
		"frame_records" = frame_records,
		"frame_delays" = rotated_frame_delays,
		"canvas_center_x" = canvas_center_x,
		"canvas_center_y" = canvas_center_y,
		"canvas_width" = canvas_width,
		"canvas_height" = canvas_height,
		"moving" = (animation_label == "movement"),
	)

/obj/effect/client_image_holder/cyborg_genital/proc/get_cyborg_genital_animated_icon_data(list/offsets, list/frame_delays, animation_label, start_frame_index)
	if(!owner_robot || !base_image_appearance || !length(offsets) || !length(frame_delays))
		return null

	// Bake one canonical all-dir animation per appearance. Phase changes should not multiply DMI cache entries.
	start_frame_index = 1
	var/cache_key = get_cyborg_genital_animation_cache_key(offsets, frame_delays, animation_label)
	var/static/list/cached_animated_icon_data = list()
	if(cached_animated_icon_data[cache_key])
		return cached_animated_icon_data[cache_key]

	var/list/frame_record_data = get_cyborg_genital_animation_frame_record_data(offsets, frame_delays, animation_label, start_frame_index)
	if(!islist(frame_record_data))
		return null

	var/list/frame_records = frame_record_data["frame_records"]
	var/list/rotated_frame_delays = frame_record_data["frame_delays"]
	var/canvas_center_x = frame_record_data["canvas_center_x"]
	var/canvas_center_y = frame_record_data["canvas_center_y"]
	var/canvas_width = frame_record_data["canvas_width"]
	var/canvas_height = frame_record_data["canvas_height"]
	var/animated_icon_state = get_cyborg_genital_animation_state_name(animation_label)
	var/animated_icon_moving = !!frame_record_data["moving"]
	var/icon/blank_animation_icon = get_cyborg_genital_blank_animation_template(canvas_width, canvas_height, animated_icon_state, rotated_frame_delays, animated_icon_moving)
	if(!isicon(blank_animation_icon))
		return null

	var/icon/animated_icon = new(blank_animation_icon)
	var/list/direction_pixels = list()
	for(var/list/frame_record as anything in frame_records)
		var/icon/base_flat_icon = frame_record["icon"]
		var/source_width = frame_record["source_width"] || ICON_SIZE_X
		var/source_height = frame_record["source_height"] || ICON_SIZE_Y
		var/insert_x = round(canvas_center_x + (frame_record["animation_pixel_x"] || 0) - (source_width * 0.5))
		var/insert_y = round(canvas_center_y + (frame_record["animation_pixel_y"] || 0) - (source_height * 0.5))
		if(frame_record["frame"] == 1)
			var/direction_key = frame_record["direction_key"]
			if(direction_key)
				direction_pixels[direction_key] = list(
					"pixel_x" = round((frame_record["base_pixel_x"] || 0) - insert_x),
					"pixel_y" = round((frame_record["base_pixel_y"] || 0) - insert_y),
				)
		var/icon/frame_icon = icon('icons/blanks/32x32.dmi', "nothing")
		if(frame_icon.Width() != canvas_width || frame_icon.Height() != canvas_height)
			frame_icon.Scale(canvas_width, canvas_height)
		frame_icon.Blend(base_flat_icon, ICON_OVERLAY, insert_x + 1, insert_y + 1)
		animated_icon.Insert(frame_icon, animated_icon_state, dir = frame_record["dir"], frame = frame_record["frame"], moving = animated_icon_moving)
	animated_icon = finalize_cyborg_genital_baked_icon(animated_icon, canvas_width, canvas_height, animated_icon_state, rotated_frame_delays, animated_icon_moving)
	if(!isicon(animated_icon))
		return null

	var/list/icon_data = list(
		"icon" = animated_icon,
		"icon_state" = animated_icon_state,
		"direction_pixels" = direction_pixels,
	)
	if(length(cached_animated_icon_data) > 256)
		cached_animated_icon_data.Cut()
	cached_animated_icon_data[cache_key] = icon_data
	return icon_data

/obj/effect/client_image_holder/cyborg_genital/proc/build_cyborg_genital_animated_appearance(list/offsets, list/frame_delays, animation_label, start_frame_index)
	var/list/icon_data = get_cyborg_genital_animated_icon_data(offsets, frame_delays, animation_label, start_frame_index)
	if(!islist(icon_data))
		return null

	var/mutable_appearance/animated_appearance = new /mutable_appearance(base_image_appearance)
	animated_appearance.icon = icon_data["icon"]
	animated_appearance.icon_state = icon_data["icon_state"]
	animated_appearance.color = null
	animated_appearance.alpha = 255
	animated_appearance.overlays.Cut()
	animated_appearance.underlays.Cut()
	animated_appearance.transform = null
	cyborg_genital_active_animation_direction_pixels = icon_data["direction_pixels"]
	var/list/animation_pixels = get_cyborg_genital_active_animation_pixels(owner_robot.dir)
	animated_appearance.pixel_x = animation_pixels?["pixel_x"] || 0
	animated_appearance.pixel_y = animation_pixels?["pixel_y"] || 0
	return animated_appearance

/proc/get_cyborg_genital_animation_timing_data(list/offsets, list/frame_delays)
	if(!islist(offsets) || !length(offsets) || !islist(frame_delays) || !length(frame_delays))
		return null

	var/frame_count = min(length(offsets), length(frame_delays))
	if(frame_count <= 0)
		return null

	var/list/normalized_frame_delays = list()
	var/total_cycle_time = 0
	for(var/frame_index in 1 to frame_count)
		var/frame_delay = frame_delays[frame_index]
		if(!isnum(frame_delay) || frame_delay <= 0)
			frame_delay = 1
		normalized_frame_delays += frame_delay
		total_cycle_time += frame_delay

	if(total_cycle_time <= 0)
		return null

	return list(
		"frame_count" = frame_count,
		"frame_delays" = normalized_frame_delays,
		"total_cycle_time" = total_cycle_time,
	)

/obj/effect/client_image_holder/cyborg_genital/proc/play_cyborg_movement_animation(list/offsets, list/frame_delays, loop = 0, preserve_phase = TRUE, animation_label = "unknown", phase_start_time = 0)
	var/list/timing_data = get_cyborg_genital_animation_timing_data(offsets, frame_delays)
	if(!islist(timing_data))
		return FALSE
	frame_delays = timing_data["frame_delays"]
	var/total_cycle_time = timing_data["total_cycle_time"]
	var/start_frame_index = get_cyborg_genital_animation_start_frame(frame_delays, total_cycle_time, preserve_phase, phase_start_time)
	var/animation_cache_key = get_cyborg_genital_animation_cache_key(offsets, frame_delays, animation_label)
	if(cyborg_genital_active_animation_key == animation_cache_key && image_appearance != base_image_appearance)
		if(shown_image)
			shown_image.dir = owner_robot?.dir || shown_image.dir
		return TRUE

	var/mutable_appearance/animated_appearance = build_cyborg_genital_animated_appearance(offsets, frame_delays, animation_label, start_frame_index)
	if(!animated_appearance)
		return FALSE

	image_appearance = animated_appearance
	cyborg_genital_active_animation_key = animation_cache_key
	regenerate_image()
	return TRUE

/obj/effect/client_image_holder/cyborg_genital/update_icon(updates = ALL)
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/effect/client_image_holder/cyborg_genital/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	SHOULD_CALL_PARENT(FALSE)
	return

/proc/refresh_all_cyborg_genital_images()
	for(var/mob/living/silicon/robot/cyborg as anything in GLOB.mob_list)
		if(!istype(cyborg))
			continue
		cyborg.refresh_cyborg_genital_images()

/mob/living/silicon/robot
	var/list/toggleable_cyborg_genitals = list()
	var/list/cyborg_genital_layout = list()
	var/list/cyborg_genital_sprite_choices = list()
	var/list/cyborg_genital_arousal_states = list()
	var/list/cyborg_genital_image_holders = list()
	var/last_cyborg_genital_model_key
	var/cyborg_genital_idle_phase_start_time = 0
	var/cyborg_genital_movement_active = FALSE
	var/cyborg_genital_movement_signature
	var/cyborg_genital_movement_deadline = 0
	var/cyborg_genital_movement_phase_start_time = 0
	var/cyborg_genital_last_move_time = 0
	var/cyborg_genital_last_move_interval = 0
	var/cyborg_genital_appearance_revision = 0

/mob/living/silicon/robot/crowbar_act(mob/living/user, obj/item/this_item)
	var/validbreakout = FALSE
	for(var/obj/item/dogborg/sleeper/this_sleeper in held_items)
		if(!LAZYLEN(this_sleeper.contents))
			continue
		if(!validbreakout)
			visible_message("<span class='notice'>[user] wedges [this_item] into the crevice separating [this_sleeper] from [src]'s chassis, and begins to pry...</span>", "<span class='notice'>You wedge [this_item] into the crevice separating [this_sleeper] from [src]'s chassis, and begin to pry...</span>")
		validbreakout = TRUE
		this_sleeper.go_out()
	if(validbreakout)
		return TRUE
	return ..()


/mob/living/silicon/robot
	var/sleeper_garbage
	var/sleeper_occupant
	var/sleeper_enviroment

/mob/living/silicon/robot/Initialize(mapload)
	. = ..()
	simulated_genitals[ORGAN_SLOT_TAIL] = TRUE
	toggleable_cyborg_genitals = list()
	cyborg_genital_layout = list()
	cyborg_genital_sprite_choices = list()
	cyborg_genital_arousal_states = list()
	cyborg_genital_image_holders = list()
	last_cyborg_genital_model_key = null
	cyborg_genital_idle_phase_start_time = 0
	cyborg_genital_movement_phase_start_time = 0

/mob/living/silicon/robot/Destroy(force)
	clear_cyborg_genital_images()
	return ..()

/mob/living/silicon/robot/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	apply_cyborg_genital_preferences(client)
	regenerate_icons()
	show_laws(0)

/mob/living/silicon/robot/proc/get_toggleable_cyborg_genitals()
	return toggleable_cyborg_genitals.Copy()

/mob/living/silicon/robot/proc/apply_cyborg_genital_preferences(client/player_client)
	if(!player_client?.prefs)
		return FALSE

	apply_cyborg_size_preference(player_client)
	var/list/new_toggleable_genitals = list()

	for(var/organ_slot in get_cyborg_genital_slots())
		var/sprite_choice = read_cyborg_genital_sprite_choice(player_client, organ_slot)
		cyborg_genital_sprite_choices[organ_slot] = sprite_choice
		cyborg_genital_arousal_states[organ_slot] = get_default_cyborg_genital_arousal_state(organ_slot)
		simulated_genitals[organ_slot] = FALSE
		if(is_factual_sprite_accessory(organ_slot, sprite_choice))
			new_toggleable_genitals += organ_slot

	toggleable_cyborg_genitals = new_toggleable_genitals
	refresh_cyborg_genital_layout(player_client)
	last_cyborg_genital_model_key = null
	apply_cyborg_model_default_if_needed(player_client)
	update_cyborg_genital_appearance()
	return TRUE

/mob/living/silicon/robot/proc/enforce_cyborg_sharp_scaling()
	fuzzy = FALSE
	appearance_flags |= PIXEL_SCALE

/mob/living/silicon/robot/proc/apply_cyborg_size_preference(client/player_client)
	if(!player_client?.prefs)
		return FALSE

	var/target_size = cyborg_character_sanitize_size(player_client.prefs.read_preference(/datum/preference/numeric/cyborg_size))
	var/current_scale = current_size || RESIZE_NORMAL
	enforce_cyborg_sharp_scaling()
	if(current_scale == target_size)
		return TRUE

	update_transform(target_size / current_scale)
	appearance_flags |= PIXEL_SCALE
	hasExpanded = target_size > RESIZE_NORMAL
	hasShrunk = target_size < RESIZE_NORMAL
	resized = target_size != RESIZE_NORMAL
	return TRUE

/mob/living/silicon/robot/proc/get_cyborg_genital_slots()
	return list(ORGAN_SLOT_PENIS, ORGAN_SLOT_SHEATH, ORGAN_SLOT_TESTICLES, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS, ORGAN_SLOT_BREASTS)

/mob/living/silicon/robot/proc/can_cyborg_genital_animate(organ_slot)
	return organ_slot != ORGAN_SLOT_BREASTS

/mob/living/silicon/robot/proc/is_cyborg_dogborg_model()
	if(!model)
		return FALSE
	return TRAIT_R_DOGBORG in model.model_features

/mob/living/silicon/robot/proc/is_cyborg_drake_model()
	return !!findtext(LOWER_TEXT(model?.cyborg_base_icon), "drake")

/mob/living/silicon/robot/proc/format_cyborg_genital_animation_offsets(list/offsets)
	if(!islist(offsets) || !length(offsets))
		return "none"

	var/list/formatted_offsets = list()
	for(var/list/offset as anything in offsets)
		if(!islist(offset))
			formatted_offsets += "null"
			continue
		formatted_offsets += "([offset?["pixel_x"] || 0],[offset?["pixel_y"] || 0],[offset?["rotation"] || 0])"
	return formatted_offsets.Join(";")

/mob/living/silicon/robot/proc/format_cyborg_genital_animation_delays(list/frame_delays)
	if(!islist(frame_delays) || !length(frame_delays))
		return "none"

	var/list/formatted_delays = list()
	for(var/frame_delay in frame_delays)
		formatted_delays += "[frame_delay]"
	return formatted_delays.Join(",")

/mob/living/silicon/robot/proc/get_cyborg_quad_model_family()
	var/model_key = LOWER_TEXT(model?.cyborg_base_icon)
	var/model_name = LOWER_TEXT(model?.name)
	var/model_icon_path = LOWER_TEXT(model?.cyborg_icon_override)
	if(!length(model_key) && istext(model?.name))
		model_key = model_name

	if(findtext(model_icon_path, "/catborgs/") || model_name == "c9-t7o")
		return "catborg"
	if(findtext(model_icon_path, "kittyborg") || model_name == "k1-t7y")
		return "kittyborg"
	if(findtext(model_name, "hound") || findtext(model_key, "hound") || model_key == "k9" || model_key == "k9dark")
		return "hound"
	if(findtext(model_name, "dragon") || findtext(model_key, "dragon"))
		return "dragon"
	if(model_key == "badboi" || model_key == "prettyboi")
		return "boi"
	if(findtext(model_icon_path, "/curverobot_") || model_name == "haydee" || model_name == "bundee")
		return "vixie"
	if(findtext(model_key, "smolraptor") || findtext(model_name, "smolraptor") || findtext(model_icon_path, "/smallraptors/"))
		return "smallraptor"
	if(findtext(model_key, "raptor") && !findtext(model_key, "smolraptor"))
		return "raptor"
	if(findtext(model_name, "myomer") || findtext(model_key, "myomer") || findtext(model_icon_path, "/myomer/"))
		return "myomer"
	if(is_cyborg_dogborg_model())
		return "dog"
	if(findtext(model_key, "drake"))
		return "drake"
	if(findtext(model_key, "pupdozer"))
		return "pupdozer"
	if(model_key == "j9" || findtext(model_key, "vale"))
		return "vale"
	if(findtext(model_key, "borgi"))
		return "borgi"
	if(findtext(model_key, "otie"))
		return "otie"
	if(findtext(model_key, "alina"))
		return "alina"
	return null

/mob/living/silicon/robot/proc/is_cyborg_animated_quad_model()
	return !isnull(get_cyborg_quad_model_family())

/mob/living/silicon/robot/proc/use_cyborg_side_occlusion(organ_slot)
	if(!(organ_slot in get_cyborg_genital_slots()))
		return FALSE
	if(organ_slot == ORGAN_SLOT_BREASTS)
		return FALSE
	if(!(dir & (EAST|WEST)))
		return FALSE
	return has_cyborg_authored_drawover()

/mob/living/silicon/robot/proc/get_cyborg_genital_viewers()
	var/list/viewers = list()
	for(var/mob/viewer as anything in GLOB.player_list)
		if(!viewer?.client)
			continue
		if(viewer.client.prefs?.read_preference(/datum/preference/toggle/see_cyborg_genitalia) == FALSE)
			continue
		viewers += viewer
	return viewers

/mob/living/silicon/robot/proc/clear_cyborg_genital_images()
	QDEL_LIST(cyborg_genital_image_holders)
	cyborg_genital_image_holders = list()

/mob/living/silicon/robot/proc/reset_cyborg_genital_holder_animations()
	cyborg_genital_movement_active = FALSE
	cyborg_genital_movement_signature = null
	cyborg_genital_movement_deadline = 0
	cyborg_genital_movement_phase_start_time = 0
	cyborg_genital_last_move_time = 0
	cyborg_genital_last_move_interval = 0
	for(var/obj/effect/client_image_holder/cyborg_genital/holder as anything in cyborg_genital_image_holders)
		if(!istype(holder))
			continue
		holder.reset_cyborg_animation()

/mob/living/silicon/robot/proc/add_cyborg_drawover_state_candidate(list/candidates, candidate_state)
	if(!islist(candidates) || !istext(candidate_state) || !length(candidate_state) || (candidate_state in candidates))
		return FALSE
	candidates += candidate_state
	return TRUE

/mob/living/silicon/robot/proc/get_cyborg_drawover_icon_files()
	return list()

/mob/living/silicon/robot/proc/get_cyborg_drawover_mask_family()
	var/icon/model_icon = model?.cyborg_icon_override
	if(isnull(model_icon))
		return null

	var/model_icon_path = LOWER_TEXT(model_icon)
	if(findtext(model_icon_path, "widerobot"))
		return "widerobot"
	if(findtext(model_icon_path, "tallrobot"))
		return "tallrobot"
	if(findtext(model_icon_path, "largerobot"))
		return "largerobot"
	return null

/mob/living/silicon/robot/proc/get_cyborg_drawover_mask_file()
	var/quad_family = get_cyborg_quad_model_family()
	switch(quad_family)
		if("boi")
			var/boi_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/boimask.dmi"
			if(fexists(boi_mask_file))
				return boi_mask_file
		if("vixie")
			var/vixie_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/vixmimask.dmi"
			if(fexists(vixie_mask_file))
				return vixie_mask_file
		if("smallraptor")
			var/smolraptor_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/smolraptormask.dmi"
			if(fexists(smolraptor_mask_file))
				return smolraptor_mask_file
		if("myomer")
			var/myomer_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/Myomermask.dmi"
			if(fexists(myomer_mask_file))
				return myomer_mask_file
		if("catborg")
			var/catborg_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/catborgmask.dmi"
			if(fexists(catborg_mask_file))
				return catborg_mask_file
		if("kittyborg")
			var/kittyborg_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/kittyborgmask.dmi"
			if(fexists(kittyborg_mask_file))
				return kittyborg_mask_file
		if("borgi")
			var/borgi_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/borgimask.dmi"
			if(fexists(borgi_mask_file))
				return borgi_mask_file
		if("alina")
			var/alina_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/alinamask.dmi"
			if(fexists(alina_mask_file))
				return alina_mask_file
		if("otie")
			var/otie_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/otiemask.dmi"
			if(fexists(otie_mask_file))
				return otie_mask_file
		if("raptor")
			var/raptor_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/raptormask.dmi"
			if(fexists(raptor_mask_file))
				return raptor_mask_file
		if("vale")
			var/vale_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/valemask.dmi"
			if(fexists(vale_mask_file))
				return vale_mask_file
		if("hound")
			var/hound_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/houndmask.dmi"
			if(fexists(hound_mask_file))
				return hound_mask_file
		if("drake")
			var/drake_mask_file = "modular_zzplurt/icons/mob/cyborg_occlusion_sources/drakemask.dmi"
			if(fexists(drake_mask_file))
				return drake_mask_file

	switch(get_cyborg_drawover_mask_family())
		if("widerobot")
			return "modular_zzplurt/icons/mob/cyborg_occlusion_masks/widerobot.dmi"
		if("tallrobot")
			return "modular_zzplurt/icons/mob/cyborg_occlusion_masks/tallrobot.dmi"
		if("largerobot")
			return "modular_zzplurt/icons/mob/cyborg_occlusion_masks/largerobot.dmi"
	return null

/mob/living/silicon/robot/proc/get_cyborg_family_drawover_state()
	var/icon/model_icon = model?.cyborg_icon_override
	var/mask_file = get_cyborg_drawover_mask_file()
	if(isnull(model_icon) || !mask_file || !fexists(mask_file))
		return null

	for(var/drawover_state in get_cyborg_drawover_state_candidates())
		var/mask_state = get_cyborg_family_drawover_mask_state(drawover_state)
		if(icon_exists(mask_file, mask_state) && icon_exists(model_icon, drawover_state))
			return list("state" = drawover_state, "mask_state" = mask_state)

	return null

/mob/living/silicon/robot/proc/get_cyborg_family_drawover_mask_state(drawover_state)
	if(!istext(drawover_state) || !length(drawover_state))
		return null

	var/family = get_cyborg_quad_model_family()
	if(family == "boi")
		var/state_suffix_index = findtext(drawover_state, "-")
		if(state_suffix_index)
			return "badboi[copytext(drawover_state, state_suffix_index)]"
		return "badboi"
	if(family == "vixie")
		var/state_suffix_index = findtext(drawover_state, "-")
		if(state_suffix_index)
			return "vixsec[copytext(drawover_state, state_suffix_index)]"
		return "vixsec"
	if(family == "smallraptor")
		var/state_suffix_index = findtext(drawover_state, "-")
		if(state_suffix_index)
			return "smolraptor[copytext(drawover_state, state_suffix_index)]"
		return "smolraptor"
	if(family == "myomer")
		if(findtext(drawover_state, "-sit"))
			return "myomer-pk-sit"
		return "myomer-pk"
	if(family == "catborg")
		var/state_suffix_index = findtext(drawover_state, "-")
		if(state_suffix_index)
			return "engi[copytext(drawover_state, state_suffix_index)]"
		return "engi"
	if(family == "kittyborg")
		var/state_suffix_index = findtext(drawover_state, "-")
		if(state_suffix_index)
			return "engi[copytext(drawover_state, state_suffix_index)]"
		return "engi"
	if(family == "borgi")
		if(findtext(drawover_state, "borgi") == 1)
			var/state_suffix_index = findtext(drawover_state, "-")
			if(state_suffix_index)
				return "borgi-jani[copytext(drawover_state, state_suffix_index)]"
			return "borgi-jani"
	if(family == "alina")
		if(findtext(drawover_state, "alina") == 1)
			var/state_suffix_index = findtext(drawover_state, "-")
			if(state_suffix_index)
				return "alina-eng[copytext(drawover_state, state_suffix_index)]"
			return "alina-eng"
	if(family == "otie")
		if(findtext(drawover_state, "otie") == 1)
			var/state_suffix_index = findtext(drawover_state, "-")
			if(state_suffix_index)
				return "otie[copytext(drawover_state, state_suffix_index)]"
			return "otie"
	if(family == "raptor")
		if(findtext(drawover_state, "raptor") == 1)
			var/state_suffix_index = findtext(drawover_state, "-")
			if(state_suffix_index)
				return "raptor[copytext(drawover_state, state_suffix_index)]"
			return "raptor"
	if(family == "vale")
		if(findtext(drawover_state, "vale") == 1 || drawover_state == "j9")
			var/state_suffix_index = findtext(drawover_state, "-")
			if(state_suffix_index)
				return "vale[copytext(drawover_state, state_suffix_index)]"
			return "vale"
	if(family == "hound")
		var/state_suffix_index = findtext(drawover_state, "-")
		if(state_suffix_index)
			return "hound[copytext(drawover_state, state_suffix_index)]"
		return "hound"
	if(family == "drake")
		if(findtext(drawover_state, "drake") == 1)
			var/state_suffix_index = findtext(drawover_state, "-")
			if(state_suffix_index)
				return "drake[copytext(drawover_state, state_suffix_index)]"
			return "drake"

	return drawover_state

/mob/living/silicon/robot/proc/get_cyborg_drawover_state_metadata_entries(icon_file, drawover_state)
	if(!icon_file || !istext(drawover_state) || !length(drawover_state))
		return null

	var/list/metadata = icon_metadata(icon_file)
	if(!islist(metadata) || !islist(metadata["states"]))
		return null

	var/list/matching_entries = list()
	for(var/list/state_data as anything in metadata["states"])
		if(state_data?["name"] != drawover_state)
			continue
		matching_entries += list(state_data)

	return length(matching_entries) ? matching_entries : null

/mob/living/silicon/robot/proc/get_cyborg_drawover_dirs_for_count(dir_count)
	if(dir_count >= 8)
		return GLOB.alldirs
	if(dir_count >= 4)
		return GLOB.cardinals
	return list(SOUTH)

/mob/living/silicon/robot/proc/get_cyborg_drawover_frame_delay(list/state_data, frame_index)
	var/delays = state_data?["delay"]
	if(islist(delays))
		if(frame_index <= length(delays) && isnum(delays[frame_index]))
			return delays[frame_index]
		if(length(delays) && isnum(delays[1]))
			return delays[1]
	if(isnum(delays))
		return delays
	return null

/mob/living/silicon/robot/proc/get_cyborg_drawover_metadata_count(metadata_value)
	if(islist(metadata_value))
		return max(length(metadata_value), 1)
	if(isnum(metadata_value))
		return max(metadata_value, 1)
	if(istext(metadata_value))
		return max(text2num(metadata_value), 1)
	return 1

/mob/living/silicon/robot/proc/get_cyborg_drawover_frame_count(list/state_data)
	var/frame_count = get_cyborg_drawover_metadata_count(state_data?["frames"])
	if(frame_count > 1)
		return frame_count

	var/delays = state_data?["delay"]
	if(islist(delays))
		return max(length(delays), 1)

	return frame_count

/mob/living/silicon/robot/proc/get_cyborg_family_animation_marker_source()
	var/family = get_cyborg_quad_model_family()
	switch(family)
		if("boi")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/boi.dmi"
			var/source_icon = "modular_zzplurt/icons/mob/robot/widerobot.dmi"
			var/source_state = "badboi"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
				)
		if("vixie")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/vixie.dmi"
			var/source_icon = "modular_zubbers/code/modules/silicons/borgs/sprites/curverobot_syndie.dmi"
			var/source_state = "HaydeeSecClassic"
			var/marker_state = "vixsec"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state) && istext(marker_state) && length(marker_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
					"marker_state" = marker_state,
				)
		if("myomer")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/Myomer.dmi"
			var/source_icon = "modular_zubbers/code/modules/silicons/borgs/sprites/myomer/ProjectMyomerPeaceKeeper.dmi"
			var/source_state = "myomer-pk"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
				)
		if("catborg")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/catborg.dmi"
			var/source_icon = "modular_zubbers/code/modules/silicons/borgs/sprites/kittycatborgs/catborgs/catborg_engineering.dmi"
			var/source_state = "engi"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
				)
		if("kittyborg")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/kittyborg.dmi"
			var/source_icon = "modular_zubbers/code/modules/silicons/borgs/sprites/kittycatborgs/kittyborg/kittyborg_engi.dmi"
			var/source_state = "engi"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
				)
		if("dragon")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/dragon.dmi"
			var/source_icon = "modular_zubbers/code/modules/silicons/borgs/sprites/dragonborg/dragon_cargo.dmi"
			var/source_state = "dragon-cargo"
			var/marker_state = "dragon"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state) && istext(marker_state) && length(marker_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
					"marker_state" = marker_state,
				)
		if("borgi")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/borgi.dmi"
			var/source_icon = "modular_skyrat/modules/borgs/icons/widerobot_jani.dmi"
			var/source_state = "borgi-jani"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
				)
		if("alina")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/alina.dmi"
			var/source_icon = "modular_skyrat/modules/borgs/icons/widerobot_eng.dmi"
			var/source_state = "alina-eng"
			var/marker_state = "alina"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state) && istext(marker_state) && length(marker_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
					"marker_state" = marker_state,
				)
		if("otie")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/otie.dmi"
			var/source_icon = "modular_skyrat/modules/borgs/icons/widerobot_eng.dmi"
			var/source_state = "otiee"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
				)
		if("raptor")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/raptor.dmi"
			var/source_icon = "modular_zubbers/code/modules/silicons/borgs/sprites/largerobot_pk.dmi"
			var/source_state = "raptor"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
				)
		if("vale")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/vale.dmi"
			var/source_icon = "modular_zubbers/code/modules/silicons/borgs/sprites/widerobot_sci.dmi"
			var/source_state = "vale"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
				)
		if("hound")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/hound.dmi"
			var/source_icon = "modular_zubbers/code/modules/silicons/borgs/sprites/widerobot_sci.dmi"
			var/source_state = "hound"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
				)
		if("drake")
			var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/drake.dmi"
			var/source_icon = "modular_zubbers/code/modules/silicons/borgs/sprites/widerobot_sci.dmi"
			var/source_state = "drake"
			if(fexists(marker_file) && fexists(source_icon) && istext(source_state) && length(source_state))
				return list(
					"marker_file" = marker_file,
					"source_icon" = source_icon,
					"anchor_icon" = model?.cyborg_icon_override || icon,
					"state" = source_state,
				)
	return null

/mob/living/silicon/robot/proc/get_cyborg_genital_animation_marker_source()
	var/icon/model_icon = model?.cyborg_icon_override
	var/base_state = model?.cyborg_base_icon
	if(!isnull(model_icon) && istext(base_state) && length(base_state))
		var/list/icon_path_parts = splittext("[model_icon]", "/")
		if(length(icon_path_parts))
			var/file_name = icon_path_parts[icon_path_parts.len]
			if(istext(file_name) && length(file_name))
				var/marker_file = "modular_zzplurt/icons/mob/cyborg_animation_markers/[file_name]"
				if(fexists(marker_file))
					return list(
						"marker_file" = marker_file,
						"source_icon" = model_icon,
						"anchor_icon" = model_icon,
						"state" = base_state,
					)

	return get_cyborg_family_animation_marker_source()

/mob/living/silicon/robot/proc/get_cyborg_genital_animation_blank_marker_file(marker_file)
	if(!istext(marker_file) || !length(marker_file))
		return null

	var/list/path_parts = splittext(marker_file, "/")
	if(!length(path_parts))
		return null

	var/file_name = path_parts[path_parts.len]
	if(!istext(file_name) || !length(file_name))
		return null

	path_parts.Cut(path_parts.len)
	var/base_directory = path_parts.Join("/")
	if(!length(base_directory))
		return null

	var/blank_marker_file = "[base_directory]/~generated_files/[file_name]"
	if(fexists(blank_marker_file))
		return blank_marker_file

	return null

/mob/living/silicon/robot/proc/get_cyborg_genital_animation_state_data(icon_file, state_name, moving = null)
	var/list/state_entries = get_cyborg_drawover_state_metadata_entries(icon_file, state_name)
	if(!length(state_entries))
		return null

	if(isnull(moving))
		return state_entries[1]

	for(var/list/state_data as anything in state_entries)
		if(!!state_data?["movement"] == !!moving)
			return state_data

	return null

/mob/living/silicon/robot/proc/get_cyborg_genital_direction_key_for_dir(direction)
	if(direction & NORTH)
		return "north"
	if(direction & SOUTH)
		return "south"
	if(direction & EAST)
		return "east"
	if(direction & WEST)
		return "west"
	return null

/mob/living/silicon/robot/proc/find_cyborg_genital_marker_pixel(icon/base_frame, icon/marker_frame)
	if(!base_frame || !marker_frame)
		return null

	var/icon_width = min(base_frame.Width(), marker_frame.Width())
	var/icon_height = min(base_frame.Height(), marker_frame.Height())
	var/list/changed_pixel = null
	for(var/x in 1 to icon_width)
		for(var/y in 1 to icon_height)
			if(base_frame.GetPixel(x, y) == marker_frame.GetPixel(x, y))
				continue
			if(changed_pixel)
				return null
			changed_pixel = list("x" = x, "y" = y)

	return changed_pixel

/mob/living/silicon/robot/proc/find_cyborg_genital_anchor_marker_pixel(icon/marker_frame)
	if(!marker_frame)
		return null

	var/list/found_pixel = null
	for(var/x in 1 to marker_frame.Width())
		for(var/y in 1 to marker_frame.Height())
			var/pixel = marker_frame.GetPixel(x, y)
			if(!pixel)
				continue
			if(LOWER_TEXT(pixel) == "#33ffff")
				if(found_pixel)
					return null
				found_pixel = list("x" = x, "y" = y)

	return found_pixel

/mob/living/silicon/robot/proc/get_cyborg_genital_canvas_anchor_base_offset(icon_file = icon)
	var/list/icon_dimensions = get_icon_dimensions(icon_file)
	var/icon_width = icon_dimensions?["width"] || ICON_SIZE_X
	var/extra_width = max(icon_width - ICON_SIZE_X, 0)
	return list(
		"pixel_x" = round(extra_width * 0.5),
		"pixel_y" = 8,
	)

/mob/living/silicon/robot/proc/get_cyborg_genital_marker_base_offset(icon_file, list/marker_pixel)
	if(!icon_file || !islist(marker_pixel))
		return null

	var/list/canvas_anchor_offset = get_cyborg_genital_canvas_anchor_base_offset(icon_file)
	return list(
		"pixel_x" = round((marker_pixel["x"] || 0) - (ICON_SIZE_X * 0.5) - (canvas_anchor_offset?["pixel_x"] || 0)),
		"pixel_y" = round((marker_pixel["y"] || 0) - (ICON_SIZE_Y * 0.5) - (canvas_anchor_offset?["pixel_y"] || 0)),
	)

/mob/living/silicon/robot/proc/get_cyborg_genital_animation_frame_delays(list/state_data)
	var/delays = state_data?["delay"]
	if(!islist(delays) && !isnum(delays))
		return null

	var/frame_count = get_cyborg_drawover_frame_count(state_data)
	var/list/frame_delays = list()
	for(var/frame_index in 1 to frame_count)
		var/frame_delay = get_cyborg_drawover_frame_delay(state_data, frame_index)
		if(!isnum(frame_delay) || frame_delay <= 0)
			return null
		frame_delays += frame_delay

	return length(frame_delays) ? frame_delays : null

/mob/living/silicon/robot/proc/build_cyborg_genital_animation_anchor_map(icon/base_icon, marker_file, base_state_name, marker_state_name, list/state_data, moving = FALSE, return_marker_pixels = FALSE)
	if(isnull(base_icon) || !marker_file || !islist(state_data))
		return null

	var/dir_count = get_cyborg_drawover_metadata_count(state_data["dirs"])
	var/list/output_dirs = get_cyborg_drawover_dirs_for_count(dir_count)
	var/list/anchors_by_direction = list()
	for(var/output_dir in output_dirs)
		var/direction_key = get_cyborg_genital_direction_key_for_dir(output_dir)
		if(!direction_key)
			continue

		var/icon/marker_frame = icon(marker_file, marker_state_name, output_dir, 1, moving)
		var/list/marker_pixel = find_cyborg_genital_anchor_marker_pixel(marker_frame)
		if(!islist(marker_pixel))
			var/icon/base_frame = icon(base_icon, base_state_name, output_dir, 1, moving)
			marker_pixel = find_cyborg_genital_marker_pixel(base_frame, marker_frame)
		var/list/base_offset = get_cyborg_genital_marker_base_offset(base_icon, marker_pixel)
		if(!islist(base_offset))
			continue

		anchors_by_direction[direction_key] = return_marker_pixels ? list(
			"pixel_x" = marker_pixel["x"] || 0,
			"pixel_y" = marker_pixel["y"] || 0,
		) : base_offset

	return length(anchors_by_direction) ? anchors_by_direction : null

/mob/living/silicon/robot/proc/build_cyborg_genital_animation_frame_map(icon/base_icon, marker_file, base_state_name, marker_state_name, list/state_data, moving = TRUE)
	if(isnull(base_icon) || !marker_file || !islist(state_data))
		return null

	var/dir_count = get_cyborg_drawover_metadata_count(state_data["dirs"])
	var/frame_count = get_cyborg_drawover_frame_count(state_data)
	var/list/output_dirs = get_cyborg_drawover_dirs_for_count(dir_count)
	var/list/frames_by_direction = list()
	for(var/output_dir in output_dirs)
		var/direction_key = get_cyborg_genital_direction_key_for_dir(output_dir)
		if(!direction_key)
			continue

		var/list/anchor_pixel = null
		var/list/marker_pixels = list()
		for(var/frame_index in 1 to frame_count)
			var/icon/base_frame = icon(base_icon, base_state_name, output_dir, frame_index, moving)
			var/icon/marker_frame = icon(marker_file, marker_state_name, output_dir, frame_index, moving)
			var/list/marker_pixel = find_cyborg_genital_marker_pixel(base_frame, marker_frame)
			marker_pixels += list(islist(marker_pixel) ? marker_pixel : null)
			if(islist(marker_pixel) && !islist(anchor_pixel))
				anchor_pixel = marker_pixel.Copy()

		if(!islist(anchor_pixel))
			continue

		var/list/frames = list()
		var/list/last_marker_pixel = null
		for(var/frame_index in 1 to frame_count)
			var/list/marker_pixel = marker_pixels[frame_index]
			if(!islist(marker_pixel) && islist(last_marker_pixel))
				marker_pixel = last_marker_pixel
			if(!islist(marker_pixel) && frame_index < frame_count)
				for(var/future_frame_index in (frame_index + 1) to frame_count)
					var/list/future_marker_pixel = marker_pixels[future_frame_index]
					if(islist(future_marker_pixel))
						marker_pixel = future_marker_pixel
						break
			if(!islist(marker_pixel))
				marker_pixel = islist(last_marker_pixel) ? last_marker_pixel : anchor_pixel
			last_marker_pixel = marker_pixel
			frames += list(list(
				"pixel_x" = (marker_pixel["x"] || 0) - (anchor_pixel["x"] || 0),
				"pixel_y" = (marker_pixel["y"] || 0) - (anchor_pixel["y"] || 0),
			))

		frames_by_direction[direction_key] = frames

	return length(frames_by_direction) ? frames_by_direction : null

/mob/living/silicon/robot/proc/build_cyborg_genital_animation_marker_data()
	var/list/marker_source = get_cyborg_genital_animation_marker_source()
	var/source_icon = marker_source?["source_icon"]
	var/anchor_icon = marker_source?["anchor_icon"] || source_icon
	var/marker_file = marker_source?["marker_file"]
	var/source_state = marker_source?["state"]
	var/marker_state = marker_source?["marker_state"] || source_state
	if(!source_icon || !marker_file || !istext(source_state) || !length(source_state) || !istext(marker_state) || !length(marker_state))
		return null
	if(!icon_exists(source_icon, source_state) || !icon_exists(marker_file, marker_state))
		return null

	var/list/data = list(
		"anchor_by_direction" = list(),
		"marker_point_by_direction" = list(),
		"rest_anchor_by_stage" = list(),
		"rest_marker_point_by_stage" = list(),
		"idle_by_direction" = list(),
		"idle_frame_delays" = null,
		"movement_by_direction" = list(),
		"frame_delays" = null,
	)

	var/list/exact_standing_state_data = get_cyborg_genital_animation_state_data(source_icon, source_state, FALSE)
	var/list/standing_state_data = exact_standing_state_data
	if(!islist(standing_state_data))
		standing_state_data = get_cyborg_genital_animation_state_data(source_icon, source_state, TRUE)
	var/list/anchor_by_direction = build_cyborg_genital_animation_anchor_map(anchor_icon, marker_file, source_state, marker_state, standing_state_data, !!standing_state_data?["movement"])
	if(islist(anchor_by_direction))
		data["anchor_by_direction"] = anchor_by_direction
	var/list/marker_point_by_direction = build_cyborg_genital_animation_anchor_map(anchor_icon, marker_file, source_state, marker_state, standing_state_data, !!standing_state_data?["movement"], TRUE)
	if(islist(marker_point_by_direction))
		data["marker_point_by_direction"] = marker_point_by_direction
	var/list/idle_by_direction = build_cyborg_genital_animation_frame_map(source_icon, marker_file, source_state, marker_state, exact_standing_state_data, FALSE)
	if(islist(exact_standing_state_data) && islist(idle_by_direction))
		data["idle_by_direction"] = idle_by_direction
		data["idle_frame_delays"] = get_cyborg_genital_animation_frame_delays(exact_standing_state_data)

	var/list/rest_stage_suffixes = list(
		"rest" = "rest",
		"rest_deep" = "rest",
		"sit" = "sit",
		"bellyup" = "bellyup",
	)
	for(var/rest_stage_key in rest_stage_suffixes)
		var/source_rest_state = "[source_state]-[rest_stage_suffixes[rest_stage_key]]"
		var/marker_rest_state = "[marker_state]-[rest_stage_suffixes[rest_stage_key]]"
		if(!icon_exists(source_icon, source_rest_state) || !icon_exists(marker_file, marker_rest_state))
			continue
		var/list/rest_state_data = get_cyborg_genital_animation_state_data(source_icon, source_rest_state, FALSE)
		if(!islist(rest_state_data))
			continue
		var/list/rest_anchor_by_direction = build_cyborg_genital_animation_anchor_map(anchor_icon, marker_file, source_rest_state, marker_rest_state, rest_state_data, FALSE)
		if(islist(rest_anchor_by_direction))
			data["rest_anchor_by_stage"][rest_stage_key] = rest_anchor_by_direction
		var/list/rest_marker_point_by_direction = build_cyborg_genital_animation_anchor_map(anchor_icon, marker_file, source_rest_state, marker_rest_state, rest_state_data, FALSE, TRUE)
		if(islist(rest_marker_point_by_direction))
			data["rest_marker_point_by_stage"][rest_stage_key] = rest_marker_point_by_direction

	var/list/movement_state_data = get_cyborg_genital_animation_state_data(source_icon, source_state, TRUE)
	if(!islist(movement_state_data))
		movement_state_data = standing_state_data
	var/list/movement_by_direction = build_cyborg_genital_animation_frame_map(source_icon, marker_file, source_state, marker_state, movement_state_data, !!movement_state_data?["movement"])
	if(islist(movement_by_direction))
		data["movement_by_direction"] = movement_by_direction
		data["frame_delays"] = get_cyborg_genital_animation_frame_delays(movement_state_data)

	if(!length(data["anchor_by_direction"]) && !length(data["movement_by_direction"]))
		return null

	return data

/mob/living/silicon/robot/proc/get_cyborg_genital_animation_marker_data()
	var/list/marker_source = get_cyborg_genital_animation_marker_source()
	var/source_icon = marker_source?["source_icon"]
	var/anchor_icon = marker_source?["anchor_icon"] || source_icon
	var/marker_file = marker_source?["marker_file"]
	var/source_state = marker_source?["state"]
	var/marker_state = marker_source?["marker_state"] || source_state
	if(!source_icon || !marker_file || !istext(source_state) || !length(source_state) || !istext(marker_state) || !length(marker_state))
		return null

	var/cache_key = "[source_icon]-[anchor_icon]-[marker_file]-[source_state]-[marker_state]"
	var/static/list/cached_marker_data = list()
	if(!isnull(cached_marker_data[cache_key]))
		return islist(cached_marker_data[cache_key]) ? cached_marker_data[cache_key] : null

	var/list/marker_data = build_cyborg_genital_animation_marker_data()
	cached_marker_data[cache_key] = islist(marker_data) ? marker_data : FALSE
	return marker_data

/mob/living/silicon/robot/proc/get_cyborg_genital_marker_slot_adjustment(organ_slot)
	switch(organ_slot)
		if(ORGAN_SLOT_PENIS, ORGAN_SLOT_SHEATH)
			return list("pixel_x" = 0, "pixel_y" = 0)
		if(ORGAN_SLOT_TESTICLES)
			return list("pixel_x" = 0, "pixel_y" = 3)
		if(ORGAN_SLOT_VAGINA)
			return list("pixel_x" = 0, "pixel_y" = ((get_cyborg_quad_model_family() in list("dog", "hound", "pupdozer")) ? 2 : 1))
	return list("pixel_x" = 0, "pixel_y" = 0)

/mob/living/silicon/robot/proc/get_cyborg_genital_automated_base_offsets(organ_slot, direction_key_override = null)
	var/list/marker_data = get_cyborg_genital_animation_marker_data()
	if(!islist(marker_data))
		return null

	var/direction_key = direction_key_override || get_cyborg_genital_direction_key()
	var/list/base_offset = null
	if(is_cyborg_genital_rest_stage_key(direction_key))
		var/rest_stage_key = get_cyborg_genital_rest_stage_key(direction_key)
		var/rest_dir_key = get_cyborg_genital_direction_from_rest_key(direction_key) || "south"
		base_offset = marker_data["rest_anchor_by_stage"]?[rest_stage_key]?[rest_dir_key]
		if(!islist(base_offset))
			base_offset = marker_data["rest_anchor_by_stage"]?[rest_stage_key]?["south"]
	else
		base_offset = marker_data["anchor_by_direction"]?[direction_key]
	if(!islist(base_offset))
		return null

	var/list/slot_adjustment = get_cyborg_genital_marker_slot_adjustment(organ_slot)
	return list(
		"pixel_x" = (base_offset?["pixel_x"] || 0) + (slot_adjustment?["pixel_x"] || 0),
		"pixel_y" = (base_offset?["pixel_y"] || 0) + (slot_adjustment?["pixel_y"] || 0),
	)

/mob/living/silicon/robot/proc/get_cyborg_automated_movement_offsets(direction_key_override = null)
	var/direction_key = direction_key_override || get_cyborg_genital_direction_key()
	if(is_cyborg_genital_rest_stage_key(direction_key))
		return null

	var/list/marker_data = get_cyborg_genital_animation_marker_data()
	if(!islist(marker_data))
		return null

	return marker_data["movement_by_direction"]?[direction_key]


/mob/living/silicon/robot/proc/get_cyborg_automated_idle_offsets(direction_key_override = null)
	var/direction_key = direction_key_override || get_cyborg_genital_direction_key()
	if(is_cyborg_genital_rest_stage_key(direction_key))
		return null

	var/list/marker_data = get_cyborg_genital_animation_marker_data()
	if(!islist(marker_data))
		return null

	return marker_data["idle_by_direction"]?[direction_key]

/mob/living/silicon/robot/proc/get_cyborg_genital_animation_offsets_for_direction(animation_label, direction_key)
	if(animation_label == "idle")
		return get_cyborg_automated_idle_offsets(direction_key)
	return get_cyborg_automated_movement_offsets(direction_key)


/mob/living/silicon/robot/proc/get_cyborg_automated_movement_frame_delays()
	var/list/automated_offsets = get_cyborg_automated_movement_offsets()
	if(!length(automated_offsets))
		return null

	var/list/marker_data = get_cyborg_genital_animation_marker_data()
	var/list/frame_delays = marker_data?["frame_delays"]
	if(islist(frame_delays) && length(frame_delays))
		return frame_delays.Copy()
	return null


/mob/living/silicon/robot/proc/get_cyborg_automated_idle_frame_delays()
	var/list/automated_offsets = get_cyborg_automated_idle_offsets()
	if(!length(automated_offsets))
		return null

	var/list/marker_data = get_cyborg_genital_animation_marker_data()
	var/list/frame_delays = marker_data?["idle_frame_delays"]
	if(islist(frame_delays) && length(frame_delays))
		return frame_delays.Copy()
	return null

/mob/living/silicon/robot/proc/get_cyborg_icon_override_mask_offset(moving = FALSE)
	var/obj/item/robot_model/current_model = model
	if(!istype(current_model) || isnull(current_model.cyborg_icon_override))
		return list("pixel_x" = 0, "pixel_y" = 0)

	if(moving)
		return list(
			"pixel_x" = current_model.cyborg_icon_override_moving_pixel_x || 0,
			"pixel_y" = current_model.cyborg_icon_override_moving_pixel_y || 0,
		)

	return list(
		"pixel_x" = current_model.cyborg_icon_override_idle_pixel_x || 0,
		"pixel_y" = current_model.cyborg_icon_override_idle_pixel_y || 0,
	)

/mob/living/silicon/robot/proc/build_cyborg_family_drawover_mask_frame(icon/source_icon, icon/family_mask_icon, list/source_offset = null)
	if(!source_icon || !family_mask_icon)
		return null

	var/icon/result_icon = icon('icons/blanks/32x32.dmi', "nothing")
	var/icon_width = max(max(source_icon.Width(), family_mask_icon.Width()), 1)
	var/icon_height = max(max(source_icon.Height(), family_mask_icon.Height()), 1)
	if(result_icon.Width() != icon_width || result_icon.Height() != icon_height)
		result_icon.Scale(icon_width, icon_height)

	var/source_offset_x = source_offset?["pixel_x"] || 0
	var/source_offset_y = source_offset?["pixel_y"] || 0
	for(var/x in 1 to icon_width)
		for(var/y in 1 to icon_height)
			if(!cyborg_direct_genital_pixel_is_visible(family_mask_icon.GetPixel(x, y)))
				continue
			var/source_x = x - source_offset_x
			var/source_y = y - source_offset_y
			if(source_x < 1 || source_x > source_icon.Width() || source_y < 1 || source_y > source_icon.Height())
				continue
			var/pixel_color = source_icon.GetPixel(source_x, source_y)
			if(!cyborg_direct_genital_pixel_is_visible(pixel_color))
				continue
			result_icon.DrawBox(pixel_color, x, y)

	return result_icon

/mob/living/silicon/robot/proc/build_cyborg_family_masked_drawover_icon(drawover_state, mask_state = null)
	if(!istext(drawover_state) || !length(drawover_state))
		return null
	if(!istext(mask_state) || !length(mask_state))
		mask_state = drawover_state

	var/icon/model_icon = model?.cyborg_icon_override
	var/mask_file = get_cyborg_drawover_mask_file()
	if(isnull(model_icon) || !mask_file || !fexists(mask_file))
		return null
	if(!icon_exists(model_icon, drawover_state) || !icon_exists(mask_file, mask_state))
		return null

	var/list/idle_offset = get_cyborg_icon_override_mask_offset(FALSE)
	var/list/moving_offset = get_cyborg_icon_override_mask_offset(TRUE)
	var/cache_key = "[model_icon]-[mask_file]-[drawover_state]-[mask_state]-idle([idle_offset?["pixel_x"] || 0],[idle_offset?["pixel_y"] || 0])-moving([moving_offset?["pixel_x"] || 0],[moving_offset?["pixel_y"] || 0])"
	var/static/list/cached_drawover_icons = list()
	if(cached_drawover_icons[cache_key])
		return cached_drawover_icons[cache_key]

	var/list/source_metadata_entries = get_cyborg_drawover_state_metadata_entries(model_icon, drawover_state)
	var/list/mask_metadata_entries = get_cyborg_drawover_state_metadata_entries(mask_file, mask_state)
	if(!length(source_metadata_entries) || !length(mask_metadata_entries))
		return null

	var/icon/result_icon = new /icon()
	var/inserted_any_frames = FALSE
	var/list/build_summaries = list()
	for(var/list/mask_state_data as anything in mask_metadata_entries)
		var/mask_movement = !!mask_state_data?["movement"]
		var/list/source_state_data = null
		for(var/list/candidate_source_state as anything in source_metadata_entries)
			if(!!candidate_source_state?["movement"] == mask_movement)
				source_state_data = candidate_source_state
				break
		if(!islist(source_state_data))
			build_summaries += "movement=[mask_movement]:no_source_match"
			continue

		var/source_dirs = source_state_data["dirs"]
		var/mask_dirs = mask_state_data["dirs"]
		var/source_dir_count = get_cyborg_drawover_metadata_count(source_dirs)
		var/mask_dir_count = get_cyborg_drawover_metadata_count(mask_dirs)
		var/source_frame_count = get_cyborg_drawover_frame_count(source_state_data)
		var/mask_frame_count = get_cyborg_drawover_frame_count(mask_state_data)
		var/list/output_dirs = get_cyborg_drawover_dirs_for_count(min(source_dir_count, mask_dir_count))
		var/frame_count = min(source_frame_count, mask_frame_count)
		var/frames_inserted_for_entry = 0
		var/list/source_offset = get_cyborg_icon_override_mask_offset(mask_movement)

		for(var/output_dir in output_dirs)
			for(var/frame_index in 1 to frame_count)
				var/icon/source_frame = icon(model_icon, drawover_state, output_dir, frame_index, mask_movement)
				var/icon/mask_frame = icon(mask_file, mask_state, output_dir, frame_index, mask_movement)
				if(!source_frame || !mask_frame)
					continue

				var/icon/result_frame = build_cyborg_family_drawover_mask_frame(source_frame, mask_frame, source_offset)
				if(!result_frame)
					continue

				var/frame_delay = get_cyborg_drawover_frame_delay(source_state_data, frame_index)
				if(isnull(frame_delay))
					result_icon.Insert(result_frame, "", dir = output_dir, frame = frame_index, moving = mask_movement)
				else
					result_icon.Insert(result_frame, "", dir = output_dir, frame = frame_index, moving = mask_movement, delay = frame_delay)
				inserted_any_frames = TRUE
				frames_inserted_for_entry++

		build_summaries += "movement=[mask_movement]:dirs=[length(output_dirs)] source_frames=[source_frame_count] mask_frames=[mask_frame_count] inserted=[frames_inserted_for_entry]"

	if(!inserted_any_frames)
		return null

	cached_drawover_icons[cache_key] = result_icon
	return result_icon

/mob/living/silicon/robot/proc/get_cyborg_drawover_icon_file(drawover_state)
	if(!istext(drawover_state) || !length(drawover_state))
		return null

	for(var/icon_file in get_cyborg_drawover_icon_files())
		if(!fexists(icon_file))
			continue
		if(icon_exists(icon_file, drawover_state))
			return icon_file

	return null

/mob/living/silicon/robot/proc/has_cyborg_authored_drawover()
	return !isnull(find_cyborg_drawover_entry())

/mob/living/silicon/robot/proc/get_cyborg_drawover_state_candidates()
	var/list/candidates = list()
	var/base_state = model?.cyborg_base_icon
	var/current_state = icon_state
	var/direction_key = get_cyborg_genital_direction_key()
	var/drawover_direction_key = get_cyborg_genital_rest_stage_key(direction_key) || direction_key

	if(istext(current_state) && length(current_state) && current_state != base_state)
		add_cyborg_drawover_state_candidate(candidates, current_state)

	if(istext(drawover_direction_key) && length(drawover_direction_key))
		add_cyborg_drawover_state_candidate(candidates, "[current_state]-[drawover_direction_key]")
		add_cyborg_drawover_state_candidate(candidates, "[base_state]-[drawover_direction_key]")

	if(dir & EAST)
		add_cyborg_drawover_state_candidate(candidates, "[current_state]-east")
		add_cyborg_drawover_state_candidate(candidates, "[base_state]-east")
	else if(dir & WEST)
		add_cyborg_drawover_state_candidate(candidates, "[current_state]-west")
		add_cyborg_drawover_state_candidate(candidates, "[base_state]-west")

	add_cyborg_drawover_state_candidate(candidates, current_state)
	add_cyborg_drawover_state_candidate(candidates, base_state)
	return candidates

/mob/living/silicon/robot/proc/find_cyborg_drawover_entry()
	var/list/family_drawover_entry = get_cyborg_family_drawover_state()
	if(islist(family_drawover_entry))
		return list("mode" = "family_mask", "state" = family_drawover_entry["state"], "mask_state" = family_drawover_entry["mask_state"])

	for(var/drawover_state in get_cyborg_drawover_state_candidates())
		var/drawover_icon = get_cyborg_drawover_icon_file(drawover_state)
		if(drawover_icon)
			return list("mode" = "authored", "icon" = drawover_icon, "state" = drawover_state)

	return null

/mob/living/silicon/robot/proc/has_cyborg_side_drawover_genitals()
	for(var/organ_slot in toggleable_cyborg_genitals)
		if(!simulated_genitals[organ_slot])
			continue
		if(organ_slot in list(ORGAN_SLOT_PENIS, ORGAN_SLOT_TESTICLES, ORGAN_SLOT_VAGINA))
			return TRUE
	return FALSE

/mob/living/silicon/robot/proc/build_cyborg_side_drawover_overlay()
	if(!(dir & (EAST|WEST)))
		return null
	if(!has_cyborg_authored_drawover() || !has_cyborg_side_drawover_genitals())
		return null

	var/list/drawover_entry = find_cyborg_drawover_entry()
	if(!islist(drawover_entry))
		return null

	var/drawover_state = drawover_entry["state"]
	if(!drawover_state)
		return null

	var/mutable_appearance/drawover_overlay
	if(drawover_entry["mode"] == "family_mask")
		var/mask_state = drawover_entry["mask_state"] || drawover_state
		var/icon/drawover_icon = build_cyborg_family_masked_drawover_icon(drawover_state, mask_state)
		if(!drawover_icon)
			return null
		drawover_overlay = mutable_appearance(drawover_icon, "", ABOVE_MOB_LAYER + 0.06)
		drawover_overlay.dir = dir
	else
		var/drawover_icon = drawover_entry["icon"]
		if(!drawover_icon)
			return null
		drawover_overlay = mutable_appearance(drawover_icon, drawover_state, ABOVE_MOB_LAYER + 0.06)
		drawover_overlay.dir = dir
	drawover_overlay.appearance_flags |= KEEP_APART | PIXEL_SCALE
	SET_PLANE_EXPLICIT(drawover_overlay, GAME_PLANE, src)
	return drawover_overlay

/mob/living/silicon/robot/proc/sync_cyborg_image_holder_viewers(obj/effect/client_image_holder/holder, list/viewers)
	if(!istype(holder) || !islist(viewers))
		return FALSE

	var/list/current_viewers = islist(holder.who_sees_us) ? holder.who_sees_us.Copy() : list()
	for(var/mob/viewer as anything in viewers)
		if(!(viewer in holder.who_sees_us))
			holder.add_seer(viewer)
	for(var/mob/viewer as anything in current_viewers)
		if(!(viewer in viewers))
			holder.remove_seer(viewer)

	return !QDELETED(holder)

/mob/living/silicon/robot/proc/refresh_cyborg_genital_images(defer_active_animation_regenerate = FALSE)
	apply_cyborg_model_default_if_needed()
	if(!LAZYLEN(toggleable_cyborg_genitals))
		clear_cyborg_genital_images()
		return

	var/list/viewers = get_cyborg_genital_viewers()
	if(!length(viewers))
		clear_cyborg_genital_images()
		return

	var/list/genital_overlay_entries = get_cyborg_genital_overlay_entries()
	var/list/existing_genital_holders = cyborg_genital_image_holders
	var/list/new_genital_holders = list()
	var/genital_index = 1
	for(var/list/genital_overlay_entry as anything in genital_overlay_entries)
		var/mutable_appearance/genital_overlay = genital_overlay_entry["appearance"]
		var/obj/effect/client_image_holder/cyborg_genital/holder = genital_index <= existing_genital_holders.len ? existing_genital_holders[genital_index] : null
		if(!istype(holder))
			holder = new /obj/effect/client_image_holder/cyborg_genital(src, src, genital_overlay, viewers, genital_overlay_entry["organ_slot"], genital_overlay_entry["overlay_subindex"])
		else
			holder.owner_robot = src
			holder.cyborg_genital_organ_slot = genital_overlay_entry["organ_slot"]
			holder.cyborg_genital_overlay_subindex = genital_overlay_entry["overlay_subindex"]
			holder.update_image_appearance(genital_overlay, defer_active_animation_regenerate)
			if(!sync_cyborg_image_holder_viewers(holder, viewers))
				holder = new /obj/effect/client_image_holder/cyborg_genital(src, src, genital_overlay, viewers, genital_overlay_entry["organ_slot"], genital_overlay_entry["overlay_subindex"])
		new_genital_holders += holder
		genital_index++

	while(genital_index <= length(existing_genital_holders))
		qdel(existing_genital_holders[genital_index])
		genital_index++

	cyborg_genital_image_holders = new_genital_holders

/mob/living/silicon/robot/proc/can_fast_refresh_cyborg_genital_direction()
	if(!LAZYLEN(cyborg_genital_image_holders))
		return FALSE
	if(robot_resting)
		return FALSE

	for(var/obj/effect/client_image_holder/cyborg_genital/holder as anything in cyborg_genital_image_holders)
		if(!istype(holder))
			return FALSE
		if(holder.image_appearance == holder.base_image_appearance || !holder.cyborg_genital_active_animation_key)
			return FALSE
	return TRUE

/mob/living/silicon/robot/proc/fast_refresh_cyborg_genital_direction(new_dir)
	if(!can_fast_refresh_cyborg_genital_direction())
		return FALSE

	if(has_cyborg_side_drawover_genitals() && has_cyborg_authored_drawover())
		update_appearance(UPDATE_OVERLAYS)

	var/list/viewers = get_cyborg_genital_viewers()
	if(!length(viewers))
		clear_cyborg_genital_images()
		return TRUE

	for(var/obj/effect/client_image_holder/cyborg_genital/holder as anything in cyborg_genital_image_holders)
		if(!sync_cyborg_image_holder_viewers(holder, viewers))
			return FALSE
		if(holder.shown_image)
			holder.shown_image.dir = new_dir
			holder.apply_cyborg_genital_animation_direction_pixels(new_dir)
		else
			holder.regenerate_image()
	return TRUE


/mob/living/silicon/robot/proc/update_cyborg_genital_appearance()
	cyborg_genital_appearance_revision++
	enforce_cyborg_sharp_scaling()
	update_appearance(UPDATE_OVERLAYS)
	// Color/layout edits need to invalidate the active holder immediately, not after the next animation tick.
	refresh_cyborg_genital_images(FALSE)
	if(robot_resting)
		reset_cyborg_genital_holder_animations()
		return
	if(cyborg_genital_movement_active)
		if(animate_cyborg_genital_movement(TRUE, TRUE))
			return
		animate_cyborg_genital_idle(TRUE, TRUE)
		return
	animate_cyborg_genital_idle(TRUE, TRUE)

/mob/living/silicon/robot/proc/get_default_cyborg_genital_arousal_state(organ_slot)
	if(organ_slot == ORGAN_SLOT_PENIS || organ_slot == ORGAN_SLOT_VAGINA || organ_slot == ORGAN_SLOT_ANUS)
		return AROUSAL_NONE
	return AROUSAL_CANT

/mob/living/silicon/robot/proc/can_cyborg_genital_arouse(organ_slot)
	return get_default_cyborg_genital_arousal_state(organ_slot) != AROUSAL_CANT

/mob/living/silicon/robot/proc/get_cyborg_genital_arousal_state(organ_slot)
	if(!can_cyborg_genital_arouse(organ_slot))
		return AROUSAL_CANT
	var/current_state = cyborg_genital_arousal_states?[organ_slot]
	if(current_state in list(AROUSAL_NONE, AROUSAL_PARTIAL, AROUSAL_FULL))
		return current_state
	return AROUSAL_NONE

/mob/living/silicon/robot/proc/set_cyborg_genital_arousal_state(organ_slot, arousal_state)
	if(!can_cyborg_genital_arouse(organ_slot))
		return FALSE
	if(!(arousal_state in list(AROUSAL_NONE, AROUSAL_PARTIAL, AROUSAL_FULL)))
		return FALSE
	cyborg_genital_arousal_states[organ_slot] = arousal_state
	update_cyborg_genital_appearance()
	return TRUE

/mob/living/silicon/robot/proc/get_cyborg_genital_arousal_label(arousal_state)
	switch(arousal_state)
		if(AROUSAL_NONE)
			return "None"
		if(AROUSAL_PARTIAL)
			return "Partial"
		if(AROUSAL_FULL)
			return "Full"
	return "Locked"

/mob/living/silicon/robot/proc/get_cyborg_genital_direction_keys()
	var/list/direction_keys = list("south", "north", "east", "west", "rest", "sit", "bellyup", "rest_deep")
	for(var/rest_stage_key in list("rest", "sit", "bellyup", "rest_deep"))
		for(var/direction_key in list("south", "north", "east", "west"))
			direction_keys += get_cyborg_genital_rest_direction_key(rest_stage_key, direction_key)
	return direction_keys

/mob/living/silicon/robot/proc/get_cyborg_genital_rest_stage_key(direction_key)
	if(!istext(direction_key) || !length(direction_key))
		return null
	var/separator = findtext(direction_key, ":")
	if(separator)
		direction_key = copytext(direction_key, 1, separator)
	if(direction_key in list("rest", "sit", "bellyup", "rest_deep"))
		return direction_key
	return null

/mob/living/silicon/robot/proc/get_cyborg_genital_rest_direction_key(rest_stage_key, direction_key)
	if(!istext(rest_stage_key) || !length(rest_stage_key) || !istext(direction_key) || !length(direction_key))
		return null
	return "[rest_stage_key]:[direction_key]"

/mob/living/silicon/robot/proc/get_cyborg_genital_direction_from_rest_key(direction_key, fallback_dir = null)
	if(istext(direction_key) && length(direction_key))
		var/separator = findtext(direction_key, ":")
		if(separator)
			var/specific_direction = copytext(direction_key, separator + 1)
			if(specific_direction in list("south", "north", "east", "west"))
				return specific_direction
		if(direction_key in list("south", "north", "east", "west"))
			return direction_key
	if(!isnull(fallback_dir))
		return get_cyborg_genital_direction_key_for_dir(fallback_dir)
	return get_cyborg_genital_direction_key_for_dir(dir)

/mob/living/silicon/robot/proc/is_cyborg_genital_rest_stage_key(direction_key)
	return !isnull(get_cyborg_genital_rest_stage_key(direction_key))

/mob/living/silicon/robot/proc/get_default_cyborg_genital_direction_entry()
	return list(
		"visible" = TRUE,
		"pixel_x" = 0,
		"pixel_y" = 0,
		"rotation" = 0,
		"priority" = 5,
	)

/mob/living/silicon/robot/proc/get_cyborg_genital_layout_arousal_keys()
	return list("none", "partial", "full")

/mob/living/silicon/robot/proc/get_cyborg_genital_layout_arousal_key(organ_slot, arousal_state = null)
	if(isnull(arousal_state))
		arousal_state = get_cyborg_genital_arousal_state(organ_slot)
	switch(arousal_state)
		if(AROUSAL_NONE)
			return "none"
		if(AROUSAL_PARTIAL)
			return "partial"
		if(AROUSAL_FULL)
			return "full"
	return null

/mob/living/silicon/robot/proc/get_default_cyborg_genital_layout_entry()
	var/list/advanced = list()
	for(var/direction_key in get_cyborg_genital_direction_keys())
		advanced[direction_key] = get_default_cyborg_genital_direction_entry()
	return list(
		"pixel_x" = 0,
		"pixel_y" = 0,
		"rotation" = 0,
		"scale" = 1,
		"colors" = list(null, null, null),
		"advanced" = advanced,
	)

/mob/living/silicon/robot/proc/get_cyborg_genital_scale_limit()
	return 16

/mob/living/silicon/robot/proc/sanitize_cyborg_genital_color(color)
	if(!istext(color) || !length(color))
		return null
	return sanitize_hexcolor(color)

/mob/living/silicon/robot/proc/sanitize_cyborg_genital_color_list(list/colors)
	var/list/sanitized_colors = list(null, null, null)
	if(!islist(colors))
		return sanitized_colors
	for(var/index in 1 to 3)
		sanitized_colors[index] = sanitize_cyborg_genital_color(colors[index])
	return sanitized_colors

/mob/living/silicon/robot/proc/sanitize_cyborg_genital_offset(offset)
	return sanitize_float(offset, -128, 128, 0.01, 0)

/mob/living/silicon/robot/proc/sanitize_cyborg_genital_direction_override_entry(list/entry)
	var/list/sanitized_entry = list()
	if(!islist(entry))
		return sanitized_entry
	if(!isnull(entry["visible"]))
		sanitized_entry["visible"] = !!entry["visible"]
	if(!isnull(entry["pixel_x"]))
		sanitized_entry["pixel_x"] = sanitize_cyborg_genital_offset(entry["pixel_x"])
	if(!isnull(entry["pixel_y"]))
		sanitized_entry["pixel_y"] = sanitize_cyborg_genital_offset(entry["pixel_y"])
	if(!isnull(entry["rotation"]))
		sanitized_entry["rotation"] = sanitize_float(entry["rotation"], -180, 180, 1, 0)
	if(!isnull(entry["priority"]))
		sanitized_entry["priority"] = round(sanitize_float(entry["priority"], 1, 10, 1, 5))
	return sanitized_entry

/mob/living/silicon/robot/proc/sanitize_cyborg_genital_direction_entry(list/entry, include_arousal_overrides = TRUE)
	var/list/sanitized_entry = get_default_cyborg_genital_direction_entry()
	if(!islist(entry))
		return sanitized_entry
	if(!isnull(entry["visible"]))
		sanitized_entry["visible"] = !!entry["visible"]
	sanitized_entry["pixel_x"] = sanitize_cyborg_genital_offset(entry["pixel_x"])
	sanitized_entry["pixel_y"] = sanitize_cyborg_genital_offset(entry["pixel_y"])
	sanitized_entry["rotation"] = sanitize_float(entry["rotation"], -180, 180, 1, 0)
	sanitized_entry["priority"] = round(sanitize_float(entry["priority"], 1, 10, 1, 5))
	if(include_arousal_overrides)
		var/list/sanitized_arousal = list()
		for(var/arousal_key in get_cyborg_genital_layout_arousal_keys())
			var/list/sanitized_override = sanitize_cyborg_genital_direction_override_entry(entry["arousal"]?[arousal_key])
			if(length(sanitized_override))
				sanitized_arousal[arousal_key] = sanitized_override
		if(length(sanitized_arousal))
			sanitized_entry["arousal"] = sanitized_arousal
	return sanitized_entry

/mob/living/silicon/robot/proc/get_cyborg_genital_direction_entry(organ_slot, list/layout_entry = null, direction_key = null, arousal_state = null)
	layout_entry = sanitize_cyborg_genital_layout_entry(layout_entry || cyborg_genital_layout?[organ_slot])
	direction_key ||= get_cyborg_genital_direction_key()
	var/list/direction_entry = sanitize_cyborg_genital_direction_entry(layout_entry["advanced"]?[direction_key])
	var/arousal_key = get_cyborg_genital_layout_arousal_key(organ_slot, arousal_state)
	if(!arousal_key)
		return direction_entry

	var/list/arousal_override = sanitize_cyborg_genital_direction_override_entry(layout_entry["advanced"]?[direction_key]?["arousal"]?[arousal_key])
	if(!length(arousal_override))
		return direction_entry

	var/list/effective_entry = direction_entry.Copy()
	for(var/field_name in arousal_override)
		effective_entry[field_name] = arousal_override[field_name]
	return effective_entry

/mob/living/silicon/robot/proc/get_cyborg_genital_priority_layer_adjustment(list/direction_entry)
	var/priority = round(sanitize_float(direction_entry?["priority"], 1, 10, 1, 5))
	return (10 - priority) * 0.0001

/mob/living/silicon/robot/proc/get_cyborg_genital_priority_layer(base_layer, list/direction_entry)
	var/priority = round(sanitize_float(direction_entry?["priority"], 1, 10, 1, 5))
	if(base_layer < ABOVE_MOB_LAYER)
		return base_layer + ((10 - priority) * 0.004)
	var/base_tiebreaker = clamp(base_layer - ABOVE_MOB_LAYER, 0, 0.0009)
	return ABOVE_MOB_LAYER + 0.01 + ((10 - priority) * 0.004) + base_tiebreaker

/mob/living/silicon/robot/proc/sanitize_cyborg_genital_layout_entry(list/entry)
	var/list/sanitized_entry = get_default_cyborg_genital_layout_entry()
	if(!islist(entry))
		return sanitized_entry
	sanitized_entry["pixel_x"] = sanitize_cyborg_genital_offset(entry["pixel_x"])
	sanitized_entry["pixel_y"] = sanitize_cyborg_genital_offset(entry["pixel_y"])
	sanitized_entry["rotation"] = sanitize_float(entry["rotation"], -180, 180, 1, 0)
	sanitized_entry["scale"] = sanitize_float(entry["scale"], 0.25, get_cyborg_genital_scale_limit(), 0.05, 1)
	var/list/colors = sanitize_cyborg_genital_color_list(entry["colors"])
	if(isnull(colors[1]))
		colors[1] = sanitize_cyborg_genital_color(entry["color"])
	sanitized_entry["colors"] = colors

	var/list/advanced_entry = entry["advanced"]
	var/list/sanitized_advanced = sanitized_entry["advanced"]
	var/list/legacy_lying_entry = sanitize_cyborg_genital_direction_entry(advanced_entry?["lying"])
	for(var/direction_key in get_cyborg_genital_direction_keys())
		var/rest_stage_key = get_cyborg_genital_rest_stage_key(direction_key)
		if(rest_stage_key && islist(advanced_entry) && !(direction_key in advanced_entry) && (rest_stage_key in advanced_entry))
			sanitized_advanced[direction_key] = sanitize_cyborg_genital_direction_entry(advanced_entry[rest_stage_key])
			continue
		if(is_cyborg_genital_rest_stage_key(direction_key) && islist(advanced_entry) && !(direction_key in advanced_entry) && ("lying" in advanced_entry))
			sanitized_advanced[direction_key] = legacy_lying_entry.Copy()
		else
			sanitized_advanced[direction_key] = sanitize_cyborg_genital_direction_entry(advanced_entry?[direction_key])

	return sanitized_entry

/mob/living/silicon/robot/proc/normalize_cyborg_genital_layout_store(list/store)
	if(!islist(store))
		store = list()
	if(!islist(store["active"]))
		store["active"] = list()
	if(!islist(store["presets"]))
		store["presets"] = list()
	if(!islist(store["model_defaults"]))
		store["model_defaults"] = list()

	var/list/active_layout = store["active"]
	for(var/organ_slot in get_cyborg_genital_slots())
		active_layout[organ_slot] = sanitize_cyborg_genital_layout_entry(active_layout[organ_slot])

	var/list/presets = store["presets"]
	var/list/preset_names = presets.Copy()
	for(var/preset_name in preset_names)
		var/list/preset_data = presets[preset_name]
		if(!islist(preset_data))
			presets -= preset_name
			continue
		var/list/sanitized_preset = list()
		for(var/organ_slot in get_cyborg_genital_slots())
			sanitized_preset[organ_slot] = sanitize_cyborg_genital_layout_entry(preset_data[organ_slot])
		presets[preset_name] = sanitized_preset

	while(length(presets) > 10)
		var/remove_name = preset_names[preset_names.len]
		presets -= remove_name
		preset_names.len--

	var/list/model_defaults = store["model_defaults"]
	var/list/model_keys = model_defaults.Copy()
	for(var/model_key in model_keys)
		var/list/model_data = model_defaults[model_key]
		if(!islist(model_data))
			model_defaults -= model_key
			continue
		var/list/sanitized_model_data = list()
		for(var/organ_slot in get_cyborg_genital_slots())
			sanitized_model_data[organ_slot] = sanitize_cyborg_genital_layout_entry(model_data[organ_slot])
		model_defaults[model_key] = sanitized_model_data

	return store

/mob/living/silicon/robot/proc/get_cyborg_genital_layout_store(client/player_client = client)
	var/datum/preferences/preferences = player_client?.prefs
	var/list/store = preferences?.read_preference(/datum/preference/blob/silicon_genital_layout_presets)
	if(!islist(store))
		store = list()
	return normalize_cyborg_genital_layout_store(deep_copy_list(store))

/mob/living/silicon/robot/proc/save_cyborg_genital_layout_store(list/store, client/player_client = client)
	var/datum/preferences/preferences = player_client?.prefs
	if(!preferences || !islist(store))
		return FALSE
	store = normalize_cyborg_genital_layout_store(store)
	preferences.write_preference(GLOB.preference_entries[/datum/preference/blob/silicon_genital_layout_presets], store)
	preferences.save_character(TRUE)
	cyborg_genital_layout = deep_copy_list(store["active"])
	return TRUE

/mob/living/silicon/robot/proc/refresh_cyborg_genital_layout(client/player_client = client)
	var/list/store = get_cyborg_genital_layout_store(player_client)
	cyborg_genital_layout = deep_copy_list(store["active"])

/mob/living/silicon/robot/proc/get_cyborg_genital_model_key()
	var/model_key = model?.cyborg_base_icon
	if(!istext(model_key) || !length(model_key))
		model_key = model?.name
	if(!istext(model_key) || !length(model_key))
		model_key = "default"
	return LOWER_TEXT(model_key)

/mob/living/silicon/robot/proc/get_cyborg_genital_model_label()
	if(istext(model?.name) && length(model.name))
		return model.name
	return "Current Model"

/mob/living/silicon/robot/proc/apply_cyborg_model_default_if_needed(client/player_client = client)
	var/model_key = get_cyborg_genital_model_key()
	if(last_cyborg_genital_model_key == model_key)
		return FALSE

	last_cyborg_genital_model_key = model_key
	if(!player_client?.prefs)
		return FALSE

	var/list/store = get_cyborg_genital_layout_store(player_client)
	var/list/model_default = store["model_defaults"]?[model_key]
	if(!islist(model_default))
		return FALSE

	store["active"] = deep_copy_list(model_default)
	return save_cyborg_genital_layout_store(store, player_client)

/mob/living/silicon/robot/proc/get_cyborg_genital_layout_entry(organ_slot)
	return sanitize_cyborg_genital_layout_entry(cyborg_genital_layout?[organ_slot])

/mob/living/silicon/robot/proc/is_cyborg_genital_visible_for_current_direction(organ_slot, list/layout_entry = null)
	return is_cyborg_genital_visible_for_direction(organ_slot, layout_entry, get_cyborg_genital_direction_key())

/mob/living/silicon/robot/proc/is_cyborg_genital_visible_for_direction(organ_slot, list/layout_entry = null, direction_key = null)
	var/list/direction_entry = get_cyborg_genital_direction_entry(organ_slot, layout_entry, direction_key)
	return !!direction_entry["visible"]

/mob/living/silicon/robot/proc/get_cyborg_genital_body_scale()
	return 1

/mob/living/silicon/robot/proc/get_cyborg_genital_offset_scale()
	return max(current_size || RESIZE_NORMAL, 0.25)

/mob/living/silicon/robot/proc/get_cyborg_genital_transform_offset()
	var/offset_scale = get_cyborg_genital_offset_scale()
	return list(
		"pixel_x" = round((ICON_SIZE_X - (ICON_SIZE_X * offset_scale)) * 0.5),
		"pixel_y" = round((ICON_SIZE_Y - (ICON_SIZE_Y * offset_scale)) * 0.5) + round(get_transform_translation_size(offset_scale)),
	)

/mob/living/silicon/robot/proc/get_cyborg_genital_offset_budget()
	return round(32 * max(get_cyborg_genital_offset_scale(), 1))

/mob/living/silicon/robot/proc/get_cyborg_genital_canvas_anchor_offset()
	var/body_scale = get_cyborg_genital_offset_scale()
	var/list/base_anchor_offset = get_cyborg_genital_canvas_anchor_base_offset(icon)
	return list(
		"pixel_x" = round((base_anchor_offset?["pixel_x"] || 0) * body_scale),
		"pixel_y" = round((base_anchor_offset?["pixel_y"] || 0) * body_scale),
	)

/mob/living/silicon/robot/proc/get_cyborg_genital_live_canvas_anchor_offset()
	var/body_scale = get_cyborg_genital_offset_scale()
	var/list/base_anchor_offset = get_cyborg_genital_canvas_anchor_base_offset(icon)
	return list(
		"pixel_x" = round(base_anchor_offset?["pixel_x"] || 0),
		"pixel_y" = round((base_anchor_offset?["pixel_y"] || 0) * body_scale),
	)

/mob/living/silicon/robot/proc/get_cyborg_genital_slot_name(organ_slot)
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
	return capitalize("[organ_slot]")

/mob/living/silicon/robot/proc/get_cyborg_genital_direction_label(direction_key)
	var/rest_stage_key = get_cyborg_genital_rest_stage_key(direction_key)
	if(rest_stage_key && rest_stage_key != direction_key)
		return get_cyborg_genital_direction_label(get_cyborg_genital_direction_from_rest_key(direction_key))
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
			return "Resting"
		if("sit")
			return "Sitting"
		if("bellyup")
			return "Belly Up"
		if("rest_deep")
			return "Deep Rest"
	return capitalize(direction_key)

/mob/living/silicon/robot/proc/get_cyborg_genital_sprite_preference_path(organ_slot)
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

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_state_slot(organ_slot)
	if(organ_slot == ORGAN_SLOT_SHEATH)
		return ORGAN_SLOT_PENIS
	return organ_slot

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_state_suffix(organ_slot, datum/sprite_accessory/genital/accessory, sprite_suffix)
	if(organ_slot != ORGAN_SLOT_TESTICLES)
		return sprite_suffix
	if(!accessory?.cyborg_direct_icon_states)
		return sprite_suffix
	if(accessory?.icon != 'modular_zzplurt/icons/mob/sprite_accessories/genitals/testicles_dogborg_onmob.dmi')
		return sprite_suffix
	if(findtext(sprite_suffix, "pair_") == 1)
		return copytext(sprite_suffix, length("pair_") + 1)
	return sprite_suffix

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_arousal_suffix(organ_slot, datum/sprite_accessory/genital/accessory, sprite_suffix, arousal_state)
	if(organ_slot != ORGAN_SLOT_PENIS)
		return sprite_suffix
	if(!accessory?.cyborg_direct_icon_states)
		return sprite_suffix
	if(!(arousal_state in list(AROUSAL_NONE, AROUSAL_PARTIAL, AROUSAL_FULL)))
		return sprite_suffix

	var/list/suffix_parts = splittext(sprite_suffix, "_")
	if(length(suffix_parts) < 3)
		return sprite_suffix

	suffix_parts[length(suffix_parts)] = "[arousal_state - AROUSAL_NONE]"
	return suffix_parts.Join("_")

/mob/living/silicon/robot/proc/read_cyborg_genital_sprite_choice(client/player_client, organ_slot)
	var/preference_path = get_cyborg_genital_sprite_preference_path(organ_slot)
	if(!preference_path)
		return null

	var/list/possible_values = get_silicon_genital_sprite_values(organ_slot)
	var/chosen_value = player_client?.prefs?.read_preference(preference_path)
	if(chosen_value in possible_values)
		return chosen_value

	var/datum/preference/choiced/preference_entry = GLOB.preference_entries[preference_path]
	var/default_value = preference_entry?.create_default_value()
	if(default_value in possible_values)
		return default_value

	if(length(possible_values))
		return possible_values[1]

	return null

/mob/living/silicon/robot/proc/get_cyborg_genital_sprite_choice(organ_slot)
	var/list/possible_values = get_silicon_genital_sprite_values(organ_slot)
	var/current_choice = cyborg_genital_sprite_choices?[organ_slot]
	if(current_choice in possible_values)
		return current_choice
	if(length(possible_values))
		return possible_values[1]
	return null

/mob/living/silicon/robot/proc/get_cyborg_genital_sprite_accessory(organ_slot)
	var/sprite_choice = get_cyborg_genital_sprite_choice(organ_slot)
	if(!sprite_choice)
		return null
	return SSaccessories.sprite_accessories[organ_slot]?[sprite_choice]

/mob/living/silicon/robot/proc/uses_cyborg_direct_genital_overlay(datum/sprite_accessory/genital/accessory)
	return !!accessory?.cyborg_direct_icon_states

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_icon_file(organ_slot, datum/sprite_accessory/genital/accessory, sprite_suffix)
	if(!accessory)
		return null

	if(organ_slot == ORGAN_SLOT_PENIS && accessory.cyborg_direct_massive_icon && get_cyborg_direct_genital_size_from_suffix(organ_slot, sprite_suffix) == 9)
		return accessory.cyborg_direct_massive_icon

	return accessory.icon

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_icon_state_name(organ_slot, datum/sprite_accessory/genital/accessory, sprite_suffix, color_layer = null, depth_group = null)
	var/icon_file = get_cyborg_direct_genital_icon_file(organ_slot, accessory, sprite_suffix)
	if(!icon_file)
		return null
	sprite_suffix = get_cyborg_direct_genital_state_suffix(organ_slot, accessory, sprite_suffix)

	if(organ_slot == ORGAN_SLOT_PENIS && icon_file == accessory?.cyborg_direct_massive_icon)
		if(depth_group == "DEFAULT")
			depth_group = null
		if(depth_group)
			return null
		if(color_layer && LOWER_TEXT(color_layer) != "primary")
			return null
		return accessory.cyborg_direct_massive_icon_state || "massive_cock"

	return get_cyborg_direct_genital_icon_state(organ_slot, sprite_suffix, color_layer, depth_group)

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_icon_state(organ_slot, sprite_suffix, color_layer = null, depth_group = null)
	if(depth_group == "DEFAULT")
		depth_group = null
	var/state_slot = get_cyborg_direct_genital_state_slot(organ_slot)
	var/list/state_parts = list("m", state_slot, sprite_suffix)
	if(color_layer)
		if(state_slot == ORGAN_SLOT_PENIS)
			if(depth_group == "UNDER" || depth_group == "OVER")
				state_parts += "FRONT"
				state_parts += depth_group
			else
				state_parts += "FRONT"
			state_parts += LOWER_TEXT(color_layer)
		else
			if(depth_group)
				state_parts += uppertext(depth_group)
			state_parts += uppertext(color_layer)
	return state_parts.Join("_")

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_display_body_layer(organ_slot)
	if(organ_slot == ORGAN_SLOT_PENIS || organ_slot == ORGAN_SLOT_SHEATH)
		return BODY_FRONT_LAYER
	return BODY_ADJ_LAYER

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_display_layer_for_group(organ_slot, depth_group)
	if(depth_group == "UNDER")
		return get_cyborg_genital_display_layer(BODY_ADJ_LAYER, organ_slot) + 0.005
	if(depth_group == "OVER")
		return get_cyborg_genital_display_layer(BODY_FRONT_LAYER, organ_slot) + 0.005
	return get_cyborg_genital_display_layer(get_cyborg_direct_genital_display_body_layer(organ_slot), organ_slot)

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_depth_groups(organ_slot, sprite_suffix, datum/sprite_accessory/genital/accessory)
	if(!get_cyborg_direct_genital_icon_file(organ_slot, accessory, sprite_suffix) || !length(sprite_suffix))
		return list()

	var/list/depth_groups = list()
	if(cyborg_direct_genital_icon_state_exists(organ_slot, sprite_suffix, accessory, "primary", "UNDER"))
		depth_groups += "UNDER"
	if(cyborg_direct_genital_icon_state_exists(organ_slot, sprite_suffix, accessory, "primary", "FRONT"))
		depth_groups += "FRONT"
	if(cyborg_direct_genital_icon_state_exists(organ_slot, sprite_suffix, accessory, "primary", "OVER"))
		depth_groups += "OVER"
	if(length(depth_groups))
		return depth_groups

	return list("DEFAULT")

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_color_layer_names(organ_slot, sprite_suffix, datum/sprite_accessory/genital/accessory, depth_group = null)
	var/icon_file = get_cyborg_direct_genital_icon_file(organ_slot, accessory, sprite_suffix)
	if(!icon_file || !length(sprite_suffix))
		return list()

	if(!SSaccessories.cached_mutant_icon_files[icon_file])
		SSaccessories.cached_mutant_icon_files[icon_file] = icon_states(new /icon(icon_file))

	var/list/cached_icon_states = SSaccessories.cached_mutant_icon_files[icon_file]
	var/list/color_layer_names = list()
	var/primary_state = get_cyborg_direct_genital_icon_state_name(organ_slot, accessory, sprite_suffix, "primary", depth_group)
	if(primary_state)
		if(primary_state in cached_icon_states)
			color_layer_names["1"] = "primary"
	var/secondary_state = get_cyborg_direct_genital_icon_state_name(organ_slot, accessory, sprite_suffix, "secondary", depth_group)
	if(secondary_state)
		if(secondary_state in cached_icon_states)
			color_layer_names["2"] = "secondary"
	var/tertiary_state = get_cyborg_direct_genital_icon_state_name(organ_slot, accessory, sprite_suffix, "tertiary", depth_group)
	if(tertiary_state)
		if(tertiary_state in cached_icon_states)
			color_layer_names["3"] = "tertiary"
	return color_layer_names

/mob/living/silicon/robot/proc/cyborg_direct_genital_icon_state_exists(organ_slot, sprite_suffix, datum/sprite_accessory/genital/accessory, color_layer = "primary", depth_group = null)
	var/icon_file = get_cyborg_direct_genital_icon_file(organ_slot, accessory, sprite_suffix)
	if(!icon_file || !length(sprite_suffix))
		return FALSE

	if(!SSaccessories.cached_mutant_icon_files[icon_file])
		SSaccessories.cached_mutant_icon_files[icon_file] = icon_states(new /icon(icon_file))

	var/list/cached_icon_states = SSaccessories.cached_mutant_icon_files[icon_file]
	var/state_name = get_cyborg_direct_genital_icon_state_name(organ_slot, accessory, sprite_suffix, color_layer, depth_group)
	if(!state_name)
		return FALSE
	return state_name in cached_icon_states

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_size_part_index(organ_slot, list/suffix_parts)
	if(!islist(suffix_parts) || !length(suffix_parts))
		return null

	if(organ_slot == ORGAN_SLOT_PENIS || organ_slot == ORGAN_SLOT_SHEATH)
		if(length(suffix_parts) < 3)
			return null
		return length(suffix_parts) - 1

	return length(suffix_parts)

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_size_from_suffix(organ_slot, sprite_suffix)
	if(!length(sprite_suffix))
		return null

	var/list/suffix_parts = splittext(sprite_suffix, "_")
	var/size_part_index = get_cyborg_direct_genital_size_part_index(organ_slot, suffix_parts)
	if(!size_part_index)
		return null

	var/size = text2num(suffix_parts[size_part_index])
	if(!isnum(size) || size < 1)
		return null

	return size

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_max_standard_source_size(organ_slot)
	switch(organ_slot)
		if(ORGAN_SLOT_PENIS, ORGAN_SLOT_SHEATH)
			return 7
		if(ORGAN_SLOT_TESTICLES)
			return TESTICLES_MAX_SIZE
	return null

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_max_standard_native_scale(organ_slot)
	switch(organ_slot)
		if(ORGAN_SLOT_PENIS, ORGAN_SLOT_SHEATH)
			return 7
		if(ORGAN_SLOT_TESTICLES)
			return TESTICLES_MAX_SIZE / 2
	return null

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_dynamic_scale_start(organ_slot)
	var/max_native_scale = get_cyborg_direct_genital_max_standard_native_scale(organ_slot)
	if(!max_native_scale)
		return null

	if(organ_slot == ORGAN_SLOT_TESTICLES)
		return max_native_scale + 0.25

	return max_native_scale + 0.5

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_standard_source_size(organ_slot, sprite_suffix, list/layout_entry = null)
	var/base_source_size = get_cyborg_direct_genital_size_from_suffix(organ_slot, sprite_suffix)
	if(!base_source_size)
		return null

	var/max_standard_source_size = get_cyborg_direct_genital_max_standard_source_size(organ_slot)
	if(!max_standard_source_size)
		return base_source_size

	return clamp(base_source_size, 1, max_standard_source_size)

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_overflow_sprite_suffix(organ_slot, datum/sprite_accessory/genital/accessory, sprite_suffix)
	if(!length(sprite_suffix))
		return null

	var/overflow_suffix = set_cyborg_direct_genital_size_suffix(organ_slot, sprite_suffix, 9)
	if(overflow_suffix == sprite_suffix)
		return null
	if(!cyborg_direct_genital_icon_state_exists(organ_slot, overflow_suffix, accessory))
		return null

	return overflow_suffix

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_scaled_base_suffix(organ_slot, sprite_suffix)
	if(!length(sprite_suffix))
		return sprite_suffix

	var/max_standard_source_size = get_cyborg_direct_genital_max_standard_source_size(organ_slot)
	if(!max_standard_source_size)
		return sprite_suffix

	return set_cyborg_direct_genital_size_suffix(organ_slot, sprite_suffix, max_standard_source_size)

/mob/living/silicon/robot/proc/set_cyborg_direct_genital_size_suffix(organ_slot, sprite_suffix, new_size)
	if(!length(sprite_suffix) || new_size < 1)
		return sprite_suffix

	var/list/suffix_parts = splittext(sprite_suffix, "_")
	var/size_part_index = get_cyborg_direct_genital_size_part_index(organ_slot, suffix_parts)
	if(!size_part_index)
		return sprite_suffix

	suffix_parts[size_part_index] = "[new_size]"
	return suffix_parts.Join("_")

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_source_sprite_suffix(organ_slot, datum/sprite_accessory/genital/accessory, sprite_suffix, list/layout_entry = null)
	layout_entry = sanitize_cyborg_genital_layout_entry(layout_entry)
	if(!(organ_slot in list(ORGAN_SLOT_PENIS, ORGAN_SLOT_TESTICLES, ORGAN_SLOT_SHEATH)) || !length(sprite_suffix))
		return sprite_suffix

	var/base_source_size = get_cyborg_direct_genital_standard_source_size(organ_slot, sprite_suffix, layout_entry)
	if(!base_source_size)
		return sprite_suffix
	sprite_suffix = set_cyborg_direct_genital_size_suffix(organ_slot, sprite_suffix, base_source_size)
	var/max_standard_source_size = get_cyborg_direct_genital_max_standard_source_size(organ_slot)
	if(!max_standard_source_size || base_source_size < max_standard_source_size)
		return sprite_suffix

	var/dynamic_scale_start = get_cyborg_direct_genital_dynamic_scale_start(organ_slot)
	if(!dynamic_scale_start || (layout_entry["scale"] || 1) < dynamic_scale_start)
		return sprite_suffix

	return get_cyborg_direct_genital_overflow_sprite_suffix(organ_slot, accessory, sprite_suffix) || get_cyborg_direct_genital_scaled_base_suffix(organ_slot, sprite_suffix)

/mob/living/silicon/robot/proc/cyborg_direct_genital_pixel_is_visible(pixel_color)
	if(!pixel_color)
		return FALSE
	if(length(pixel_color) >= 9 && LOWER_TEXT(copytext(pixel_color, 8, 10)) == "00")
		return FALSE
	return TRUE

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_visible_dimensions(organ_slot, datum/sprite_accessory/genital/accessory, sprite_suffix, list/layout_entry = null, dir_override = null)
	var/icon_file = get_cyborg_direct_genital_icon_file(organ_slot, accessory, sprite_suffix)
	if(!icon_file || !length(sprite_suffix))
		return null

	var/resolved_dir = dir_override || dir
	var/list/resolved_colors = get_cyborg_genital_overlay_colors(organ_slot, accessory, layout_entry)
	var/cache_key = "[icon_file]-[organ_slot]-[sprite_suffix]-[resolved_dir]-[resolved_colors[1]]-[resolved_colors[2]]-[resolved_colors[3]]-visible-dimensions"
	var/static/list/cached_visible_dimensions = list()
	if(cached_visible_dimensions[cache_key])
		return cached_visible_dimensions[cache_key]

	var/icon/flat_icon = build_cyborg_direct_genital_flat_icon(organ_slot, accessory, sprite_suffix, layout_entry, null, resolved_dir)
	if(!flat_icon)
		return null

	var/icon_width = flat_icon.Width()
	var/icon_height = flat_icon.Height()
	var/min_x = icon_width + 1
	var/max_x = 0
	var/min_y = icon_height + 1
	var/max_y = 0
	for(var/x in 1 to icon_width)
		for(var/y in 1 to icon_height)
			if(!cyborg_direct_genital_pixel_is_visible(flat_icon.GetPixel(x, y)))
				continue
			min_x = min(min_x, x)
			max_x = max(max_x, x)
			min_y = min(min_y, y)
			max_y = max(max_y, y)

	if(max_x < min_x || max_y < min_y)
		cached_visible_dimensions[cache_key] = list("width" = 0, "height" = 0)
	else
		cached_visible_dimensions[cache_key] = list("width" = (max_x - min_x) + 1, "height" = (max_y - min_y) + 1)

	return cached_visible_dimensions[cache_key]


/mob/living/silicon/robot/proc/get_cyborg_direct_genital_match_scale_for_dir(organ_slot, datum/sprite_accessory/genital/accessory, sprite_suffix, list/layout_entry = null, dir_override = null)
	if(!(organ_slot in list(ORGAN_SLOT_PENIS, ORGAN_SLOT_TESTICLES, ORGAN_SLOT_SHEATH)))
		return 1
	if(get_cyborg_direct_genital_size_from_suffix(organ_slot, sprite_suffix) != 9)
		return 1

	var/base_suffix_size = get_cyborg_direct_genital_max_standard_source_size(organ_slot)
	if(!base_suffix_size)
		return 1
	var/base_suffix = set_cyborg_direct_genital_size_suffix(organ_slot, sprite_suffix, base_suffix_size)
	if(base_suffix == sprite_suffix)
		return 1
	if(!cyborg_direct_genital_icon_state_exists(organ_slot, base_suffix, accessory))
		return 1

	var/list/base_dimensions = get_cyborg_direct_genital_visible_dimensions(organ_slot, accessory, base_suffix, layout_entry, dir_override)
	var/list/supersample_dimensions = get_cyborg_direct_genital_visible_dimensions(organ_slot, accessory, sprite_suffix, layout_entry, dir_override)
	var/base_width = base_dimensions?["width"] || 0
	var/base_height = base_dimensions?["height"] || 0
	var/supersample_width = supersample_dimensions?["width"] || 0
	var/supersample_height = supersample_dimensions?["height"] || 0
	if(base_width < 1 || base_height < 1 || supersample_width < 1 || supersample_height < 1)
		return 1

	var/width_ratio = base_width / supersample_width
	var/height_ratio = base_height / supersample_height
	return min(width_ratio, height_ratio)

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_match_scale(organ_slot, datum/sprite_accessory/genital/accessory, sprite_suffix, list/layout_entry = null)
	var/match_scale = get_cyborg_direct_genital_match_scale_for_dir(organ_slot, accessory, sprite_suffix, layout_entry)
	if(organ_slot != ORGAN_SLOT_PENIS || !accessory?.cyborg_direct_massive_icon)
		return match_scale
	if(get_cyborg_direct_genital_icon_file(organ_slot, accessory, sprite_suffix) != accessory.cyborg_direct_massive_icon)
		return match_scale

	for(var/cardinal_dir in list(NORTH, SOUTH, EAST, WEST))
		match_scale = min(match_scale, get_cyborg_direct_genital_match_scale_for_dir(organ_slot, accessory, sprite_suffix, layout_entry, cardinal_dir))

	return match_scale

/mob/living/silicon/robot/proc/get_cyborg_genital_color_layer_names(organ_slot, datum/sprite_accessory/genital/accessory)
	var/sprite_suffix = get_cyborg_genital_overlay_sprite_suffix(organ_slot, accessory)
	if(uses_cyborg_direct_genital_overlay(accessory))
		var/list/direct_color_layer_names = list()
		for(var/depth_group in get_cyborg_direct_genital_depth_groups(organ_slot, sprite_suffix, accessory))
			for(var/layer_index in get_cyborg_direct_genital_color_layer_names(organ_slot, sprite_suffix, accessory, depth_group))
				direct_color_layer_names[layer_index] = get_cyborg_direct_genital_color_layer_names(organ_slot, sprite_suffix, accessory, depth_group)[layer_index]
		if(!length(direct_color_layer_names))
			direct_color_layer_names = list("1" = "primary")
		return direct_color_layer_names

	var/overlay_builder_type = get_cyborg_genital_overlay_builder_type(organ_slot)
	if(!sprite_suffix || !overlay_builder_type)
		return list("1" = "primary")

	var/datum/bodypart_overlay/mutant/genital/overlay_builder = new overlay_builder_type
	overlay_builder.sprite_datum = accessory
	overlay_builder.sprite_suffix = sprite_suffix
	var/list/color_layer_names = overlay_builder.get_color_layer_names(sprite_suffix)
	if(!length(color_layer_names))
		color_layer_names = list("1" = "primary")
	qdel(overlay_builder)
	return color_layer_names


/mob/living/silicon/robot/proc/get_cyborg_genital_overlay_builder_type(organ_slot)
	switch(organ_slot)
		if(ORGAN_SLOT_PENIS)
			return /datum/bodypart_overlay/mutant/genital/penis
		if(ORGAN_SLOT_TESTICLES)
			return /datum/bodypart_overlay/mutant/genital/testicles
		if(ORGAN_SLOT_VAGINA)
			return /datum/bodypart_overlay/mutant/genital/vagina
		if(ORGAN_SLOT_ANUS)
			return /datum/bodypart_overlay/mutant/genital/anus
		if(ORGAN_SLOT_BREASTS)
			return /datum/bodypart_overlay/mutant/genital/breasts
	return null

/mob/living/silicon/robot/proc/get_cyborg_external_overlay_layer(body_layer)
	switch(body_layer)
		if(BODY_FRONT_LAYER)
			return EXTERNAL_FRONT
		if(BODY_ADJ_LAYER)
			return EXTERNAL_ADJACENT
		if(BODY_BEHIND_LAYER)
			return EXTERNAL_BEHIND
		if(BODY_FRONT_UNDER_CLOTHES)
			return EXTERNAL_FRONT_UNDER_CLOTHES
		if(ABOVE_BODY_FRONT_HEAD_LAYER)
			return EXTERNAL_FRONT_OVER
		if(HEAD_LAYER)
			return EXTERNAL_FRONT_ABOVE_HAIR
	return null

/mob/living/silicon/robot/proc/get_cyborg_genital_display_layer(body_layer, organ_slot)
	if(use_cyborg_side_occlusion(organ_slot))
		switch(body_layer)
			if(BODY_BEHIND_LAYER)
				return ABOVE_MOB_LAYER
			if(BODY_FRONT_UNDER_CLOTHES)
				return ABOVE_MOB_LAYER + 0.01
			if(BODY_ADJ_LAYER)
				return ABOVE_MOB_LAYER + 0.02
			if(BODY_FRONT_LAYER)
				return ABOVE_MOB_LAYER + 0.03
			if(HEAD_LAYER)
				return ABOVE_MOB_LAYER + 0.04
			if(ABOVE_BODY_FRONT_HEAD_LAYER)
				return ABOVE_MOB_LAYER + 0.05
	switch(body_layer)
		if(BODY_BEHIND_LAYER)
			return BELOW_MOB_LAYER
		if(BODY_FRONT_UNDER_CLOTHES)
			return ABOVE_MOB_LAYER + 0.01
		if(BODY_ADJ_LAYER)
			return ABOVE_MOB_LAYER + 0.02
		if(BODY_FRONT_LAYER)
			return ABOVE_MOB_LAYER + 0.03
		if(HEAD_LAYER)
			return ABOVE_MOB_LAYER + 0.04
		if(ABOVE_BODY_FRONT_HEAD_LAYER)
			return ABOVE_MOB_LAYER + 0.05
	return ABOVE_MOB_LAYER + 0.02

/mob/living/silicon/robot/proc/get_cyborg_genital_overlay_sprite_suffix(organ_slot, datum/sprite_accessory/genital/accessory)
	if(!accessory?.icon_state || accessory.icon_state == "none")
		return null

	var/list/layout_entry = get_cyborg_genital_layout_entry(organ_slot)
	var/obj/item/organ/genital/genital = build_cyborg_visual_genital(organ_slot, accessory, layout_entry)
	if(!genital)
		return null

	var/sprite_suffix = genital.sprite_suffix
	var/arousal_state = genital.aroused
	qdel(genital)
	if(uses_cyborg_direct_genital_overlay(accessory))
		sprite_suffix = get_cyborg_direct_genital_arousal_suffix(organ_slot, accessory, sprite_suffix, arousal_state)
		return get_cyborg_direct_genital_source_sprite_suffix(organ_slot, accessory, sprite_suffix, layout_entry)
	return sprite_suffix


/mob/living/silicon/robot/proc/get_cyborg_visual_genital_size(organ_slot, list/layout_entry = null)
	layout_entry = sanitize_cyborg_genital_layout_entry(layout_entry)
	var/scale = layout_entry["scale"]

	switch(organ_slot)
		if(ORGAN_SLOT_PENIS)
			return max(round(10 * scale), 1)
		if(ORGAN_SLOT_SHEATH)
			return max(round(10 * scale), 1)
		if(ORGAN_SLOT_TESTICLES)
			return clamp(round(2 * scale), 0, TESTICLES_MAX_SIZE)
		if(ORGAN_SLOT_BREASTS)
			return clamp(round(scale), BREASTS_MIN_SIZE, BREASTS_MAX_SIZE)

	return 1

/mob/living/silicon/robot/proc/get_cyborg_genital_generic_render_scale(organ_slot, list/layout_entry = null)
	layout_entry = sanitize_cyborg_genital_layout_entry(layout_entry)
	var/layout_scale = layout_entry["scale"] || 1
	var/render_scale = 1
	var/dynamic_scale_start

	switch(organ_slot)
		if(ORGAN_SLOT_PENIS, ORGAN_SLOT_SHEATH)
			dynamic_scale_start = get_cyborg_direct_genital_dynamic_scale_start(organ_slot)
			if(dynamic_scale_start && layout_scale > dynamic_scale_start)
				render_scale = layout_scale / dynamic_scale_start
		if(ORGAN_SLOT_TESTICLES)
			dynamic_scale_start = get_cyborg_direct_genital_dynamic_scale_start(organ_slot)
			if(dynamic_scale_start && layout_scale > dynamic_scale_start)
				render_scale = layout_scale / dynamic_scale_start
		else
			render_scale = layout_scale

	return render_scale * get_cyborg_genital_body_scale()

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_render_scale(organ_slot, datum/sprite_accessory/genital/accessory, sprite_suffix, list/layout_entry = null)
	layout_entry = sanitize_cyborg_genital_layout_entry(layout_entry)
	var/render_scale = 1
	var/source_size = get_cyborg_direct_genital_size_from_suffix(organ_slot, sprite_suffix)
	var/max_standard_source_size = get_cyborg_direct_genital_max_standard_source_size(organ_slot)
	var/dynamic_scale_start = get_cyborg_direct_genital_dynamic_scale_start(organ_slot)
	var/layout_scale = layout_entry["scale"] || 1
	if(!source_size || !max_standard_source_size || !dynamic_scale_start)
		return render_scale * get_cyborg_genital_body_scale()

	if(source_size == 9)
		var/match_scale = get_cyborg_direct_genital_match_scale(organ_slot, accessory, sprite_suffix, layout_entry)
		render_scale = match_scale * (layout_scale / dynamic_scale_start)
	else if(source_size >= max_standard_source_size && layout_scale >= dynamic_scale_start)
		render_scale = layout_scale / dynamic_scale_start

	return render_scale * get_cyborg_genital_body_scale()


/mob/living/silicon/robot/proc/build_cyborg_visual_genital(organ_slot, datum/sprite_accessory/genital/accessory, list/layout_entry = null)
	if(!accessory)
		return null

	var/obj/item/organ/genital/genital
	switch(organ_slot)
		if(ORGAN_SLOT_PENIS)
			genital = new /obj/item/organ/genital/penis
			var/obj/item/organ/genital/penis/penis = genital
			penis.girth = 9
			penis.sheath = SHEATH_NONE
			var/datum/sprite_accessory/genital/penis/penis_accessory = accessory
			penis.knotted = penis_accessory.knotted
			penis.override_string_knot = penis_accessory.override_string_knot
			penis.override_string_tie = penis_accessory.override_string_tie
		if(ORGAN_SLOT_SHEATH)
			genital = new /obj/item/organ/genital/penis
			var/obj/item/organ/genital/penis/penis = genital
			penis.girth = 9
			penis.sheath = SHEATH_NONE
			var/datum/sprite_accessory/genital/penis/penis_accessory = accessory
			penis.knotted = penis_accessory.knotted
			penis.override_string_knot = penis_accessory.override_string_knot
			penis.override_string_tie = penis_accessory.override_string_tie
		if(ORGAN_SLOT_TESTICLES)
			genital = new /obj/item/organ/genital/testicles
		if(ORGAN_SLOT_VAGINA)
			genital = new /obj/item/organ/genital/vagina
		if(ORGAN_SLOT_ANUS)
			genital = new /obj/item/organ/genital/anus
		if(ORGAN_SLOT_BREASTS)
			genital = new /obj/item/organ/genital/breasts

	if(!genital)
		return null

	genital.genital_name = accessory.name
	genital.genital_type = accessory.icon_state
	var/arousal_state = get_cyborg_genital_arousal_state(organ_slot)
	if(organ_slot == ORGAN_SLOT_SHEATH)
		arousal_state = AROUSAL_NONE
	else if(organ_slot == ORGAN_SLOT_BREASTS)
		arousal_state = AROUSAL_NONE
	else if(arousal_state == AROUSAL_CANT)
		arousal_state = AROUSAL_NONE
	genital.aroused = arousal_state
	genital.visibility_preference = GENITAL_ALWAYS_SHOW
	genital.genital_size = get_cyborg_visual_genital_size(organ_slot, layout_entry)
	genital.update_sprite_suffix()
	return genital


/mob/living/silicon/robot/proc/get_cyborg_genital_default_color(organ_slot, datum/sprite_accessory/genital/accessory)
	if(istext(accessory?.default_color) && findtext(accessory.default_color, "#") == 1)
		return accessory.default_color

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

	return null

/mob/living/silicon/robot/proc/get_cyborg_genital_overlay_colors(organ_slot, datum/sprite_accessory/genital/accessory, list/layout_entry = null)
	var/default_color = get_cyborg_genital_default_color(organ_slot, accessory) || "#ffffff"
	var/list/resolved_colors = list(default_color, default_color, default_color)
	var/list/custom_colors = sanitize_cyborg_genital_color_list(layout_entry?["colors"])
	for(var/index in 1 to 3)
		if(custom_colors[index])
			resolved_colors[index] = custom_colors[index]
	return resolved_colors

/mob/living/silicon/robot/proc/get_cyborg_genital_overlay_color(organ_slot, datum/sprite_accessory/genital/accessory, list/layout_entry = null)
	var/list/resolved_colors = get_cyborg_genital_overlay_colors(organ_slot, accessory, layout_entry)
	if(length(get_cyborg_genital_color_layer_names(organ_slot, accessory)) > 1)
		return resolved_colors
	return resolved_colors[1]

/mob/living/silicon/robot/proc/build_cyborg_direct_genital_flat_icon(organ_slot, datum/sprite_accessory/genital/accessory, sprite_suffix, list/layout_entry, depth_group = null, dir_override = null)
	var/icon_file = get_cyborg_direct_genital_icon_file(organ_slot, accessory, sprite_suffix)
	if(!icon_file)
		return null
	var/resolved_dir = dir_override || dir

	var/list/color_layers = get_cyborg_direct_genital_color_layer_names(organ_slot, sprite_suffix, accessory, depth_group)
	if(!length(color_layers))
		color_layers = list("1" = "primary")

	var/list/resolved_colors = get_cyborg_genital_overlay_colors(organ_slot, accessory, layout_entry)
	var/color_index = color_layers[1] ? 1 : text2num(color_layers[1])
	if(!isnum(color_index) || color_index < 1)
		color_index = 1

	var/base_state = get_cyborg_direct_genital_icon_state(organ_slot, sprite_suffix, color_layers["[color_index]"], depth_group)
	base_state = get_cyborg_direct_genital_icon_state_name(organ_slot, accessory, sprite_suffix, color_layers["[color_index]"], depth_group)
	if(!base_state)
		return null
	var/image/composite_image = image(icon = icon_file, icon_state = base_state)
	composite_image.color = resolved_colors[color_index] || "#ffffff"
	composite_image.dir = resolved_dir

	for(var/layer_index in color_layers)
		if(text2num(layer_index) == color_index)
			continue
		var/layer_state = get_cyborg_direct_genital_icon_state_name(organ_slot, accessory, sprite_suffix, color_layers[layer_index], depth_group)
		if(!layer_state)
			continue
		var/image/layer_image = image(icon = icon_file, icon_state = layer_state)
		layer_image.color = resolved_colors[text2num(layer_index)] || "#ffffff"
		layer_image.dir = resolved_dir
		layer_image.appearance_flags |= RESET_COLOR
		composite_image.add_overlay(layer_image)

	return getFlatIcon(composite_image, resolved_dir)

//Nuts so fat my ass had to add my own fucking nearest neighbor.
/mob/living/silicon/robot/proc/scale_cyborg_icon_nearest_neighbor(icon/source_icon, target_width, target_height)
	if(!source_icon || target_width < 1 || target_height < 1)
		return null

	var/source_width = source_icon.Width()
	var/source_height = source_icon.Height()
	if(source_width < 1 || source_height < 1)
		return null
	if(source_width == target_width && source_height == target_height)
		return source_icon

	var/icon/scaled_icon = icon('icons/blanks/32x32.dmi', "nothing")
	scaled_icon.Scale(target_width, target_height)

	for(var/dest_x in 1 to target_width)
		var/source_x = round(((dest_x - 0.5) * source_width / target_width) + 0.5)
		source_x = clamp(source_x, 1, source_width)
		for(var/dest_y in 1 to target_height)
			var/source_y = FLOOR(((dest_y - 1) * source_height / target_height) + 1, 1)
			source_y = clamp(source_y, 1, source_height)
			var/pixel_color = source_icon.GetPixel(source_x, source_y)
			if(!pixel_color)
				continue
			scaled_icon.DrawBox(pixel_color, dest_x, dest_y)

	return scaled_icon

/mob/living/silicon/robot/proc/get_cyborg_direct_genital_scaled_icon(organ_slot, datum/sprite_accessory/genital/accessory, sprite_suffix, list/layout_entry, render_scale, depth_group = null, dir_override = null)
	var/resolved_dir = dir_override || dir
	var/icon/flat_icon = build_cyborg_direct_genital_flat_icon(organ_slot, accessory, sprite_suffix, layout_entry, depth_group, resolved_dir)
	if(!flat_icon)
		return null

	var/list/icon_dimensions = get_icon_dimensions(flat_icon)
	var/target_width = max(round((icon_dimensions?["width"] || ICON_SIZE_X) * render_scale), 1)
	var/target_height = max(round((icon_dimensions?["height"] || ICON_SIZE_Y) * render_scale), 1)
	if(target_width == (icon_dimensions?["width"] || ICON_SIZE_X) && target_height == (icon_dimensions?["height"] || ICON_SIZE_Y))
		return flat_icon

	var/icon_file = get_cyborg_direct_genital_icon_file(organ_slot, accessory, sprite_suffix)
	var/list/resolved_colors = get_cyborg_genital_overlay_colors(organ_slot, accessory, layout_entry)
	var/cache_key = "[icon_file]-[organ_slot]-[sprite_suffix]-[depth_group || "DEFAULT"]-[resolved_dir]-[resolved_colors[1]]-[resolved_colors[2]]-[resolved_colors[3]]-[target_width]x[target_height]"
	var/static/list/cached_scaled_icons = list()
	if(!cached_scaled_icons[cache_key])
		cached_scaled_icons[cache_key] = scale_cyborg_icon_nearest_neighbor(flat_icon, target_width, target_height)

	return cached_scaled_icons[cache_key]

/mob/living/silicon/robot/proc/make_cyborg_direct_genital_overlay(organ_slot, datum/sprite_accessory/genital/accessory, list/layout_entry, sprite_suffix, render_scale, rotation, effective_pixel_x, effective_pixel_y, dir_override = null, list/direction_entry = null)
	var/resolved_dir = dir_override || dir
	var/list/direct_overlays = list()
	for(var/depth_group in get_cyborg_direct_genital_depth_groups(organ_slot, sprite_suffix, accessory))
		var/icon/flat_icon = get_cyborg_direct_genital_scaled_icon(organ_slot, accessory, sprite_suffix, layout_entry, render_scale, depth_group, resolved_dir)
		if(!flat_icon)
			continue

		var/display_layer = get_cyborg_direct_genital_display_layer_for_group(organ_slot, depth_group)
		var/mutable_appearance/genital_overlay = mutable_appearance(flat_icon, "", layer = get_cyborg_genital_priority_layer(display_layer, direction_entry))
		genital_overlay.alpha = alpha
		genital_overlay.dir = resolved_dir
		genital_overlay.appearance_flags |= PIXEL_SCALE | KEEP_APART
		genital_overlay.pixel_x = effective_pixel_x
		genital_overlay.pixel_y = effective_pixel_y
		if(rotation)
			var/matrix/rotation_transform = matrix()
			rotation_transform.Turn(rotation)
			genital_overlay.transform = rotation_transform
		direct_overlays += genital_overlay

	return direct_overlays

/mob/living/silicon/robot/proc/get_cyborg_genital_base_offsets(organ_slot, direction_key_override = null)
	var/list/automated_offsets = get_cyborg_genital_automated_base_offsets(organ_slot, direction_key_override)
	if(islist(automated_offsets))
		return automated_offsets

	var/family = get_cyborg_quad_model_family()
	var/is_dogborg = (family == "dog" || family == "pupdozer" || family == "hound")
	var/is_drake = (family == "drake")
	var/is_other_quad = !is_dogborg && !is_drake && !isnull(family)
	switch(organ_slot)
		if(ORGAN_SLOT_PENIS)
			return list("pixel_x" = 0, "pixel_y" = is_dogborg ? -18 : (is_drake ? -16 : (is_other_quad ? -14 : -1)))
		if(ORGAN_SLOT_SHEATH)
			return list("pixel_x" = 0, "pixel_y" = is_dogborg ? -18 : (is_drake ? -16 : (is_other_quad ? -14 : -1)))
		if(ORGAN_SLOT_TESTICLES)
			return list("pixel_x" = 0, "pixel_y" = is_dogborg ? -15 : (is_drake ? -13 : (is_other_quad ? -11 : 1)))
		if(ORGAN_SLOT_VAGINA)
			return list("pixel_x" = 0, "pixel_y" = is_dogborg ? -16 : (is_drake ? -15 : (is_other_quad ? -13 : 0)))
		if(ORGAN_SLOT_ANUS)
			return list("pixel_x" = 0, "pixel_y" = is_dogborg ? -16 : (is_drake ? -15 : (is_other_quad ? -13 : 0)))
	return list("pixel_x" = 0, "pixel_y" = 0)

/mob/living/silicon/robot/proc/get_cyborg_genital_direction_key()
	if(robot_resting)
		var/rest_direction_key = get_cyborg_genital_direction_key_for_dir(dir) || "south"
		switch(robot_resting)
			if(ROBOT_REST_NORMAL)
				return get_cyborg_genital_rest_direction_key("rest", rest_direction_key)
			if(ROBOT_REST_SITTING)
				return get_cyborg_genital_rest_direction_key("sit", rest_direction_key)
			if(ROBOT_REST_BELLY_UP)
				return get_cyborg_genital_rest_direction_key("bellyup", rest_direction_key)
			if(ROBOT_REST_SLEEP)
				return get_cyborg_genital_rest_direction_key("rest_deep", rest_direction_key)
		return get_cyborg_genital_rest_direction_key("rest", rest_direction_key)
	if(dir & NORTH)
		return "north"
	if(dir & SOUTH)
		return "south"
	if(dir & EAST)
		return "east"
	if(dir & WEST)
		return "west"
	return "south"

/mob/living/silicon/robot/proc/get_cyborg_genital_movement_frame_delays()
	var/list/automated_frame_delays = get_cyborg_automated_movement_frame_delays()
	return islist(automated_frame_delays) ? automated_frame_delays : null

/mob/living/silicon/robot/proc/get_cyborg_genital_movement_offsets()
	var/list/automated_offsets = get_cyborg_automated_movement_offsets()
	return length(automated_offsets) ? automated_offsets : null

/mob/living/silicon/robot/proc/get_cyborg_genital_idle_offsets()
	var/list/automated_offsets = get_cyborg_automated_idle_offsets()
	return length(automated_offsets) ? automated_offsets : null


/mob/living/silicon/robot/proc/stop_cyborg_genital_movement_animation(expected_deadline = null)
	var/was_moving = cyborg_genital_movement_active
	if(!isnull(expected_deadline) && expected_deadline != cyborg_genital_movement_deadline)
		return TRUE
	cyborg_genital_movement_active = FALSE
	cyborg_genital_movement_signature = null
	cyborg_genital_movement_deadline = 0
	cyborg_genital_movement_phase_start_time = 0
	cyborg_genital_last_move_time = 0
	cyborg_genital_last_move_interval = 0
	if(!was_moving)
		return TRUE
	if(animate_cyborg_genital_idle(TRUE, FALSE))
		return TRUE
	for(var/obj/effect/client_image_holder/cyborg_genital/holder as anything in cyborg_genital_image_holders)
		if(!istype(holder))
			continue
		holder.reset_cyborg_animation()
	return TRUE

/mob/living/silicon/robot/proc/animate_cyborg_genital_idle(refresh_only = FALSE, preserve_phase = TRUE)
	if(robot_resting || cyborg_genital_movement_active)
		return FALSE
	if(!preserve_phase || !cyborg_genital_idle_phase_start_time)
		cyborg_genital_idle_phase_start_time = world.time
		preserve_phase = FALSE

	var/list/offsets = get_cyborg_genital_idle_offsets()
	var/list/frame_delays = get_cyborg_automated_idle_frame_delays()
	var/list/timing_data = get_cyborg_genital_animation_timing_data(offsets, frame_delays)
	if(!islist(timing_data))
		return FALSE
	frame_delays = timing_data["frame_delays"]

	if(!LAZYLEN(cyborg_genital_image_holders))
		return FALSE

	for(var/obj/effect/client_image_holder/cyborg_genital/holder as anything in cyborg_genital_image_holders)
		if(!istype(holder))
			continue
		if(!can_cyborg_genital_animate(holder.cyborg_genital_organ_slot))
			holder.reset_cyborg_animation()
			continue
		holder.play_cyborg_movement_animation(offsets, frame_delays, -1, preserve_phase, "idle", cyborg_genital_idle_phase_start_time)
	return TRUE

/mob/living/silicon/robot/proc/animate_cyborg_genital_movement(refresh_only = FALSE, preserve_phase = null)
	if(robot_resting)
		stop_cyborg_genital_movement_animation()
		return FALSE

	if(cyborg_genital_movement_active && cyborg_genital_movement_deadline && world.time >= cyborg_genital_movement_deadline)
		cyborg_genital_movement_active = FALSE
		cyborg_genital_movement_signature = null
		cyborg_genital_movement_deadline = 0
		cyborg_genital_movement_phase_start_time = 0
		cyborg_genital_last_move_time = 0
		cyborg_genital_last_move_interval = 0

	var/direction_key = get_cyborg_genital_direction_key()
	var/family = get_cyborg_quad_model_family()
	var/list/offsets = get_cyborg_genital_movement_offsets()
	var/list/frame_delays = get_cyborg_genital_movement_frame_delays()
	var/movement_signature = "[family]-[direction_key]"
	var/signature_changed = cyborg_genital_movement_signature != movement_signature
	var/list/timing_data = get_cyborg_genital_animation_timing_data(offsets, frame_delays)
	if(!islist(timing_data))
		stop_cyborg_genital_movement_animation()
		return FALSE
	frame_delays = timing_data["frame_delays"]
	var/animation_timeout = 2
	if(isnull(preserve_phase))
		preserve_phase = refresh_only && cyborg_genital_movement_active && !signature_changed
	if(!preserve_phase || !cyborg_genital_movement_phase_start_time)
		cyborg_genital_movement_phase_start_time = world.time
		preserve_phase = FALSE
	if(!refresh_only)
		if(cyborg_genital_last_move_time > 0)
			cyborg_genital_last_move_interval = max(world.time - cyborg_genital_last_move_time, 1)
		cyborg_genital_last_move_time = world.time
		if(cyborg_genital_last_move_interval > 0)
			animation_timeout = max(cyborg_genital_last_move_interval + 1, animation_timeout)
	if(refresh_only && cyborg_genital_movement_deadline && world.time >= cyborg_genital_movement_deadline)
		stop_cyborg_genital_movement_animation()
		return FALSE

	if(!LAZYLEN(cyborg_genital_image_holders))
		cyborg_genital_movement_active = FALSE
		cyborg_genital_movement_signature = null
		cyborg_genital_movement_deadline = 0
		cyborg_genital_movement_phase_start_time = 0
		cyborg_genital_last_move_time = 0
		cyborg_genital_last_move_interval = 0
		return FALSE

	if(refresh_only || !cyborg_genital_movement_active || cyborg_genital_movement_signature != movement_signature)
		for(var/obj/effect/client_image_holder/cyborg_genital/holder as anything in cyborg_genital_image_holders)
			if(!istype(holder))
				continue
			if(!can_cyborg_genital_animate(holder.cyborg_genital_organ_slot))
				holder.reset_cyborg_animation()
				continue
			holder.play_cyborg_movement_animation(offsets, frame_delays, -1, preserve_phase, "movement", cyborg_genital_movement_phase_start_time)
	cyborg_genital_movement_active = TRUE
	cyborg_genital_movement_signature = movement_signature
	if(!refresh_only)
		cyborg_genital_movement_deadline = world.time + animation_timeout

	if(!refresh_only)
		addtimer(CALLBACK(src, PROC_REF(stop_cyborg_genital_movement_animation), cyborg_genital_movement_deadline), animation_timeout, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_DELETE_ME)

	return TRUE

/mob/living/silicon/robot/proc/build_cyborg_genital_management_ui_data()
	var/list/ui_data = list(
		"enabled" = LAZYLEN(toggleable_cyborg_genitals),
		"presetLimit" = 10,
		"presets" = list(),
		"genitals" = list(),
	)
	if(!ui_data["enabled"])
		return ui_data

	var/list/store = get_cyborg_genital_layout_store()
	var/list/presets = store["presets"]
	var/model_key = get_cyborg_genital_model_key()
	for(var/preset_name in presets)
		ui_data["presets"] += list(list("name" = preset_name))
	ui_data["model_name"] = get_cyborg_genital_model_label()
	ui_data["model_key"] = model_key
	ui_data["has_model_default"] = !!store["model_defaults"]?[model_key]

	for(var/organ_slot in get_cyborg_genital_slots())
		if(!(organ_slot in toggleable_cyborg_genitals))
			continue
		var/list/layout_entry = get_cyborg_genital_layout_entry(organ_slot)
		var/datum/sprite_accessory/genital/accessory = get_cyborg_genital_sprite_accessory(organ_slot)
		var/list/resolved_colors = get_cyborg_genital_overlay_colors(organ_slot, accessory, layout_entry)
		var/list/current_direction_entry = get_cyborg_genital_direction_entry(organ_slot, layout_entry)
		ui_data["genitals"] += list(list(
			"slot" = organ_slot,
			"name" = get_cyborg_genital_slot_name(organ_slot),
			"sprite" = get_cyborg_genital_sprite_choice(organ_slot),
			"visible" = !!simulated_genitals[organ_slot],
			"can_arouse" = can_cyborg_genital_arouse(organ_slot),
			"aroused" = get_cyborg_genital_arousal_state(organ_slot),
			"arousal_label" = get_cyborg_genital_arousal_label(get_cyborg_genital_arousal_state(organ_slot)),
			"pixel_x" = layout_entry["pixel_x"],
			"pixel_y" = layout_entry["pixel_y"],
			"rotation" = layout_entry["rotation"],
			"scale" = layout_entry["scale"],
			"direction_pixel_x" = current_direction_entry["pixel_x"],
			"direction_pixel_y" = current_direction_entry["pixel_y"],
			"direction_rotation" = current_direction_entry["rotation"],
			"direction_visible" = current_direction_entry["visible"],
			"scale_limit" = get_cyborg_genital_scale_limit(),
			"body_scale" = get_cyborg_genital_body_scale(),
			"offset_limit" = get_cyborg_genital_offset_budget(),
			"colors" = deep_copy_list(layout_entry["colors"]),
			"color_layers" = deep_copy_list(get_cyborg_genital_color_layer_names(organ_slot, accessory)),
			"resolved_colors" = deep_copy_list(resolved_colors),
			"preview_color" = resolved_colors[1],
			"advanced" = deep_copy_list(layout_entry["advanced"]),
		))

	return ui_data

/mob/living/silicon/robot/proc/update_cyborg_genital_layout_value(organ_slot, field_name, value, direction_key = null, arousal_state = null)
	if(!(organ_slot in get_cyborg_genital_slots()))
		return FALSE
	if(direction_key)
		if(!(direction_key in get_cyborg_genital_direction_keys()))
			return FALSE

	var/list/store = get_cyborg_genital_layout_store()
	var/list/active_layout = store["active"]
	var/list/layout_entry = sanitize_cyborg_genital_layout_entry(active_layout[organ_slot])

	if(direction_key)
		if(field_name != "visible" && field_name != "pixel_x" && field_name != "pixel_y" && field_name != "rotation" && field_name != "priority")
			return FALSE
		var/list/direction_entry = layout_entry["advanced"][direction_key]
		var/arousal_key = get_cyborg_genital_layout_arousal_key(organ_slot, arousal_state)
		if(arousal_key)
			var/list/arousal_entry = direction_entry["arousal"]?[arousal_key]
			if(!islist(arousal_entry))
				arousal_entry = list()
			arousal_entry[field_name] = value
			arousal_entry = sanitize_cyborg_genital_direction_override_entry(arousal_entry)
			if(length(arousal_entry))
				if(!islist(direction_entry["arousal"]))
					direction_entry["arousal"] = list()
				direction_entry["arousal"][arousal_key] = arousal_entry
			else if(islist(direction_entry["arousal"]))
				direction_entry["arousal"] -= arousal_key
				if(!length(direction_entry["arousal"]))
					direction_entry -= "arousal"
		else
			direction_entry[field_name] = value
		layout_entry["advanced"][direction_key] = sanitize_cyborg_genital_direction_entry(direction_entry)
	else
		if(field_name != "pixel_x" && field_name != "pixel_y" && field_name != "rotation" && field_name != "scale")
			return FALSE
		layout_entry[field_name] = value
		layout_entry = sanitize_cyborg_genital_layout_entry(layout_entry)

	active_layout[organ_slot] = layout_entry
	if(!save_cyborg_genital_layout_store(store))
		return FALSE

	update_cyborg_genital_appearance()
	return TRUE

/mob/living/silicon/robot/proc/build_cyborg_genital_description(organ_slot)
	if(!(organ_slot in toggleable_cyborg_genitals) || !simulated_genitals[organ_slot])
		return null

	var/datum/sprite_accessory/genital/accessory = get_cyborg_genital_sprite_accessory(organ_slot)
	if(!accessory)
		return null

	var/list/layout_entry = get_cyborg_genital_layout_entry(organ_slot)
	if(!is_cyborg_genital_visible_for_current_direction(organ_slot, layout_entry))
		return null
	var/obj/item/organ/genital/genital = build_cyborg_visual_genital(organ_slot, accessory, layout_entry)

	if(!genital)
		return null

	var/description = genital.get_description_string(accessory)
	qdel(genital)
	return description

/mob/living/silicon/robot/proc/get_visible_cyborg_genital_descriptions()
	var/list/descriptions = list()
	for(var/organ_slot in get_cyborg_genital_slots())
		var/description = build_cyborg_genital_description(organ_slot)
		if(description)
			descriptions += description
	return descriptions

/mob/living/silicon/robot/proc/has_visible_cyborg_genitals()
	return length(get_visible_cyborg_genital_descriptions())

/mob/living/silicon/robot/proc/reset_cyborg_genital_layout(organ_slot, direction_key = null, arousal_state = null)
	if(!(organ_slot in get_cyborg_genital_slots()))
		return FALSE
	if(direction_key)
		if(!(direction_key in get_cyborg_genital_direction_keys()))
			return FALSE

	var/list/store = get_cyborg_genital_layout_store()
	if(direction_key)
		var/list/layout_entry = sanitize_cyborg_genital_layout_entry(store["active"][organ_slot])
		var/list/direction_entry = layout_entry["advanced"][direction_key]
		var/arousal_key = get_cyborg_genital_layout_arousal_key(organ_slot, arousal_state)
		if(arousal_key)
			if(islist(direction_entry["arousal"]))
				direction_entry["arousal"] -= arousal_key
				if(!length(direction_entry["arousal"]))
					direction_entry -= "arousal"
			layout_entry["advanced"][direction_key] = sanitize_cyborg_genital_direction_entry(direction_entry)
		else
			layout_entry["advanced"][direction_key] = get_default_cyborg_genital_direction_entry()
		store["active"][organ_slot] = layout_entry
	else
		store["active"][organ_slot] = get_default_cyborg_genital_layout_entry()

	if(!save_cyborg_genital_layout_store(store))
		return FALSE

	update_cyborg_genital_appearance()
	return TRUE

/mob/living/silicon/robot/proc/prompt_set_cyborg_genital_color(organ_slot, color_index = 1)
	if(!(organ_slot in toggleable_cyborg_genitals))
		return FALSE
	if(!isnum(color_index) || color_index < 1 || color_index > 3)
		return FALSE

	var/list/store = get_cyborg_genital_layout_store()
	var/list/layout_entry = sanitize_cyborg_genital_layout_entry(store["active"][organ_slot])
	var/datum/sprite_accessory/genital/accessory = get_cyborg_genital_sprite_accessory(organ_slot)
	var/list/color_layers = get_cyborg_genital_color_layer_names(organ_slot, accessory)
	if(!color_layers["[color_index]"])
		return FALSE
	var/list/resolved_colors = get_cyborg_genital_overlay_colors(organ_slot, accessory, layout_entry)
	var/layer_name = capitalize("[color_layers["[color_index]"]]")
	var/new_color = tgui_color_picker(src, "Choose a [layer_name] color for [get_cyborg_genital_slot_name(organ_slot)].", "Reproduction Color", resolved_colors[color_index] || "#ffffff")
	if(isnull(new_color))
		return FALSE

	var/list/custom_colors = layout_entry["colors"]
	custom_colors[color_index] = sanitize_cyborg_genital_color(new_color)
	layout_entry["colors"] = custom_colors
	store["active"][organ_slot] = layout_entry
	if(!save_cyborg_genital_layout_store(store))
		return FALSE

	update_cyborg_genital_appearance()
	return TRUE

/mob/living/silicon/robot/proc/reset_cyborg_genital_color(organ_slot, color_index = 1)
	if(!(organ_slot in toggleable_cyborg_genitals))
		return FALSE
	if(!isnum(color_index) || color_index < 1 || color_index > 3)
		return FALSE

	var/list/store = get_cyborg_genital_layout_store()
	var/list/layout_entry = sanitize_cyborg_genital_layout_entry(store["active"][organ_slot])
	var/list/custom_colors = layout_entry["colors"]
	custom_colors[color_index] = null
	layout_entry["colors"] = custom_colors
	store["active"][organ_slot] = layout_entry
	if(!save_cyborg_genital_layout_store(store))
		return FALSE

	update_cyborg_genital_appearance()
	return TRUE

/mob/living/silicon/robot/proc/toggle_cyborg_genital_visibility(organ_slot)
	if(!(organ_slot in toggleable_cyborg_genitals))
		return FALSE
	simulated_genitals[organ_slot] = !simulated_genitals[organ_slot]
	update_cyborg_genital_appearance()
	return TRUE

/mob/living/silicon/robot/proc/prompt_save_cyborg_genital_preset()
	var/list/store = get_cyborg_genital_layout_store()
	var/list/presets = store["presets"]
	var/default_name = "Preset [length(presets) + 1]"
	var/preset_name = tgui_input_text(src, "Name this reproduction preset.", "Save Reproduction Preset", default_name, 32)
	if(isnull(preset_name))
		return FALSE

	preset_name = trim(html_encode(preset_name), 32)
	if(!length(preset_name))
		to_chat(src, span_warning("Preset names cannot be blank."))
		return FALSE
	if(!(preset_name in presets) && length(presets) >= 10)
		to_chat(src, span_warning("You can only keep 10 reproduction presets."))
		return FALSE

	presets[preset_name] = deep_copy_list(cyborg_genital_layout)
	if(!save_cyborg_genital_layout_store(store))
		return FALSE

	to_chat(src, span_notice("Saved reproduction preset \"[preset_name]\"."))
	return TRUE

/mob/living/silicon/robot/proc/save_cyborg_genital_model_default()
	var/list/store = get_cyborg_genital_layout_store()
	var/model_key = get_cyborg_genital_model_key()
	store["model_defaults"][model_key] = deep_copy_list(cyborg_genital_layout)
	if(!save_cyborg_genital_layout_store(store))
		return FALSE
	to_chat(src, span_notice("Saved reproduction default for [get_cyborg_genital_model_label()]."))
	return TRUE

/mob/living/silicon/robot/proc/load_cyborg_genital_model_default()
	var/list/store = get_cyborg_genital_layout_store()
	var/model_key = get_cyborg_genital_model_key()
	var/list/model_default = store["model_defaults"]?[model_key]
	if(!islist(model_default))
		return FALSE

	store["active"] = deep_copy_list(model_default)
	if(!save_cyborg_genital_layout_store(store))
		return FALSE

	update_cyborg_genital_appearance()
	to_chat(src, span_notice("Loaded reproduction default for [get_cyborg_genital_model_label()]."))
	return TRUE

/mob/living/silicon/robot/proc/clear_cyborg_genital_model_default()
	var/list/store = get_cyborg_genital_layout_store()
	var/model_key = get_cyborg_genital_model_key()
	if(!(model_key in store["model_defaults"]))
		return FALSE

	store["model_defaults"] -= model_key
	if(!save_cyborg_genital_layout_store(store))
		return FALSE

	to_chat(src, span_notice("Cleared reproduction default for [get_cyborg_genital_model_label()]."))
	return TRUE

/mob/living/silicon/robot/proc/load_cyborg_genital_preset(preset_name)
	var/list/store = get_cyborg_genital_layout_store()
	var/list/preset_data = store["presets"]?[preset_name]
	if(!islist(preset_data))
		return FALSE

	store["active"] = deep_copy_list(preset_data)
	if(!save_cyborg_genital_layout_store(store))
		return FALSE

	update_cyborg_genital_appearance()
	to_chat(src, span_notice("Loaded reproduction preset \"[preset_name]\"."))
	return TRUE

/mob/living/silicon/robot/proc/delete_cyborg_genital_preset(preset_name)
	var/list/store = get_cyborg_genital_layout_store()
	var/list/presets = store["presets"]
	if(!(preset_name in presets))
		return FALSE

	presets -= preset_name
	if(!save_cyborg_genital_layout_store(store))
		return FALSE

	to_chat(src, span_notice("Deleted reproduction preset \"[preset_name]\"."))
	return TRUE

/mob/living/silicon/robot/update_overlays()
	. = ..()
	var/mutable_appearance/drawover_overlay = build_cyborg_side_drawover_overlay()
	if(drawover_overlay)
		. += drawover_overlay

/mob/living/silicon/robot/proc/get_cyborg_genital_overlays()
	. = list()
	for(var/list/overlay_entry as anything in get_cyborg_genital_overlay_entries())
		. += overlay_entry["appearance"]

/mob/living/silicon/robot/proc/get_cyborg_genital_overlay_entries(dir_override = null)
	. = list()
	if(!LAZYLEN(toggleable_cyborg_genitals))
		return

	for(var/organ_slot in get_cyborg_genital_slots())
		if(!simulated_genitals[organ_slot])
			continue
		var/overlay_subindex = 1
		for(var/mutable_appearance/genital_overlay as anything in make_cyborg_genital_overlay(organ_slot, dir_override))
			. += list(list(
				"appearance" = genital_overlay,
				"organ_slot" = organ_slot,
				"overlay_subindex" = overlay_subindex,
			))
			overlay_subindex++


/mob/living/silicon/robot/proc/make_cyborg_genital_overlay(organ_slot, dir_override = null, direction_key_override = null, use_preview_canvas_anchor = FALSE)
	var/list/layout_entry = get_cyborg_genital_layout_entry(organ_slot)
	var/direction_key = direction_key_override || (dir_override ? get_cyborg_genital_direction_key_for_dir(dir_override) : get_cyborg_genital_direction_key())
	if(!is_cyborg_genital_visible_for_direction(organ_slot, layout_entry, direction_key))
		return list()

	var/datum/sprite_accessory/genital/accessory = get_cyborg_genital_sprite_accessory(organ_slot)
	var/sprite_suffix = get_cyborg_genital_overlay_sprite_suffix(organ_slot, accessory)
	if(!accessory?.icon || !sprite_suffix)
		return list()

	var/list/base_offset = get_cyborg_genital_base_offsets(organ_slot, direction_key)
	var/list/canvas_anchor_offset = use_preview_canvas_anchor ? get_cyborg_genital_canvas_anchor_offset() : get_cyborg_genital_live_canvas_anchor_offset()
	var/list/direction_entry = get_cyborg_genital_direction_entry(organ_slot, layout_entry, direction_key)
	var/overlay_color = get_cyborg_genital_overlay_color(organ_slot, accessory, layout_entry)
	var/list/appearances = list()
	var/offset_scale = get_cyborg_genital_offset_scale()

	var/render_scale
	if(uses_cyborg_direct_genital_overlay(accessory))
		render_scale = get_cyborg_direct_genital_render_scale(organ_slot, accessory, sprite_suffix, layout_entry)
	else
		render_scale = get_cyborg_genital_generic_render_scale(organ_slot, layout_entry)

	var/rotation = layout_entry["rotation"] + direction_entry["rotation"]
	var/matrix/genital_transform = matrix()
	if(!uses_cyborg_direct_genital_overlay(accessory))
		genital_transform.Scale(render_scale, render_scale)
	if(rotation)
		genital_transform.Turn(rotation)

	var/effective_pixel_x = ((base_offset["pixel_x"] + layout_entry["pixel_x"] + direction_entry["pixel_x"]) * offset_scale) + (canvas_anchor_offset?["pixel_x"] || 0)
	var/effective_pixel_y = ((base_offset["pixel_y"] + layout_entry["pixel_y"] + direction_entry["pixel_y"]) * offset_scale) + (canvas_anchor_offset?["pixel_y"] || 0)

	if(uses_cyborg_direct_genital_overlay(accessory))
		return make_cyborg_direct_genital_overlay(organ_slot, accessory, layout_entry, sprite_suffix, render_scale, rotation, effective_pixel_x, effective_pixel_y, dir_override, direction_entry)

	var/overlay_builder_type = get_cyborg_genital_overlay_builder_type(organ_slot)
	if(!overlay_builder_type)
		return list()

	var/datum/bodypart_overlay/mutant/genital/overlay_builder = new overlay_builder_type
	overlay_builder.sprite_datum = accessory
	overlay_builder.sprite_suffix = sprite_suffix
	overlay_builder.draw_color = overlay_color

	for(var/body_layer in accessory.relevent_layers)
		var/external_layer = get_cyborg_external_overlay_layer(body_layer)
		if(!external_layer)
			continue
		var/display_layer = get_cyborg_genital_display_layer(body_layer, organ_slot)
		var/list/generated_overlays = overlay_builder.get_overlay(external_layer, null)
		if(!length(generated_overlays))
			continue
		for(var/mutable_appearance/genital_overlay as anything in generated_overlays)
			genital_overlay.appearance_flags |= KEEP_APART
			genital_overlay.layer = get_cyborg_genital_priority_layer(display_layer, direction_entry)
			if(dir_override)
				genital_overlay.dir = dir_override
			genital_overlay.pixel_x = effective_pixel_x
			genital_overlay.pixel_y = effective_pixel_y
			genital_overlay.transform = genital_transform
			appearances += genital_overlay

	return appearances

/mob/living/silicon/robot/setDir(newdir)
	var/old_dir = dir
	. = ..()
	if(. != old_dir && !fast_refresh_cyborg_genital_direction(dir))
		update_cyborg_genital_appearance()
