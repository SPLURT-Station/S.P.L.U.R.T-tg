/mob/living/silicon/robot/cyborg_genital_alignment_live_probe
	name = "cyborg genital alignment live probe"
	invisibility = INVISIBILITY_ABSTRACT
	cell = null
	radio = null

/mob/living/silicon/robot/cyborg_genital_alignment_live_probe/Initialize(mapload)
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

/mob/living/silicon/robot/cyborg_genital_alignment_live_probe/Destroy()
	if(ispath(cell))
		cell = null
	if(ispath(radio))
		radio = null
	return ..()

/mob/living/silicon/robot/cyborg_genital_alignment_live_probe/check_held_item_sprites(obj/item/checked_item)
	return FALSE

/datum/unit_test/cyborg_genital_preview_alignment

/datum/unit_test/cyborg_genital_preview_alignment/proc/configure_probe(mob/living/silicon/robot/robot, obj/item/robot_model/model, list/model_data, selected_size, selected_dir)
	robot.model = model
	model.name = model_data["variant_name"] || model.name
	model.cyborg_icon_override = model_data["icon"] || model.cyborg_icon_override
	model.cyborg_base_icon = model_data["icon_state"] || model.cyborg_base_icon
	var/list/skin_features = model_data["skin_features"]
	model.model_features = islist(skin_features) ? skin_features.Copy() : list()
	robot.icon = model.cyborg_icon_override || robot.icon
	robot.icon_state = model.cyborg_base_icon
	robot.dir = selected_dir
	robot.current_size = selected_size
	robot.transform = matrix().Scale(selected_size)
	robot.robot_resting = FALSE
	robot.cyborg_genital_layout = list()
	robot.cyborg_genital_layout[ORGAN_SLOT_PENIS] = robot.get_default_cyborg_genital_layout_entry()
	robot.cyborg_genital_sprite_choices = list()
	robot.cyborg_genital_sprite_choices[ORGAN_SLOT_PENIS] = /datum/sprite_accessory/genital/penis/dogborg::name
	robot.cyborg_genital_arousal_states = list()
	robot.cyborg_genital_arousal_states[ORGAN_SLOT_PENIS] = AROUSAL_NONE
	robot.simulated_genitals = list()
	robot.simulated_genitals[ORGAN_SLOT_PENIS] = TRUE
	robot.toggleable_cyborg_genitals = list(ORGAN_SLOT_PENIS)
	robot.cyborg_genital_appearance_revision++
	robot.cyborg_genital_idle_phase_start_time = world.time
	robot.cyborg_genital_movement_active = FALSE
	robot.cyborg_genital_movement_signature = null
	robot.model?.update_tallborg()
	robot.model?.update_quadruped()

/datum/unit_test/cyborg_genital_preview_alignment/proc/build_probe(type, model_type, list/model_data, selected_size, selected_dir)
	var/mob/living/silicon/robot/robot = allocate(type)
	var/obj/item/robot_model/model = new model_type(robot)
	configure_probe(robot, model, model_data, selected_size, selected_dir)
	return robot

/datum/unit_test/cyborg_genital_preview_alignment/proc/get_body_scale_offset(selected_size)
	return list(
		"pixel_x" = round((ICON_SIZE_X - (ICON_SIZE_X * selected_size)) * 0.5),
		"pixel_y" = round((ICON_SIZE_Y - (ICON_SIZE_Y * selected_size)) * 0.5) + round((selected_size - RESIZE_NORMAL) * (ICON_SIZE_Y * 0.5)),
	)

/datum/unit_test/cyborg_genital_preview_alignment/proc/get_render_record(mob/living/silicon/robot/robot, selected_dir)
	var/direction_key = robot.get_cyborg_genital_direction_key()
	var/list/base_genital_overlays = robot.make_cyborg_genital_overlay(ORGAN_SLOT_PENIS, selected_dir, direction_key)
	if(!length(base_genital_overlays))
		return null

	var/mutable_appearance/genital_overlay = base_genital_overlays[1]
	genital_overlay.plane = FLOAT_PLANE
	return cyborg_character_get_rendered_genital_icon_data(robot, genital_overlay, ORGAN_SLOT_PENIS, 1, selected_dir)

/datum/unit_test/cyborg_genital_preview_alignment/proc/check_case(model_name, variant_name)
	var/list/model_catalog = cyborg_character_ensure_model_catalog()
	if(!(model_name in model_catalog) || !(variant_name in model_catalog[model_name]))
		TEST_FAIL("Missing cyborg model case [model_name] / [variant_name].")
		return

	var/model_type = cyborg_character_ensure_model_list()[model_name]
	if(!model_type)
		TEST_FAIL("Missing cyborg model type for [model_name].")
		return

	var/list/model_data = cyborg_character_get_model_icon_data(model_name, variant_name)
	model_data["variant_name"] = variant_name
	var/list/sizes = list(RESIZE_NORMAL, 1.6, 2.5)
	var/list/directions = list(SOUTH, EAST, WEST)

	for(var/selected_size in sizes)
		for(var/selected_dir in directions)
			var/mob/living/silicon/robot/live_robot = build_probe(/mob/living/silicon/robot/cyborg_genital_alignment_live_probe, model_type, model_data, selected_size, selected_dir)
			var/mob/living/silicon/robot/preview_robot = build_probe(/mob/living/silicon/robot/cyborg_character_catalog_host, model_type, model_data, selected_size, selected_dir)
			var/list/live_render = get_render_record(live_robot, selected_dir)
			var/list/preview_render = get_render_record(preview_robot, selected_dir)
			if(!islist(live_render) || !islist(preview_render))
				TEST_FAIL("Missing genital render data for [model_name] / [variant_name], size [selected_size], dir [selected_dir]. live=[islist(live_render)] preview=[islist(preview_render)]")
				continue

			var/list/body_scale_offset = get_body_scale_offset(selected_size)
			var/live_relative_x = (live_render["pixel_x"] || 0) - (body_scale_offset["pixel_x"] || 0)
			var/live_relative_y = (live_render["pixel_y"] || 0) - (body_scale_offset["pixel_y"] || 0)
			var/preview_relative_x = (preview_render["pixel_x"] || 0) - (body_scale_offset["pixel_x"] || 0)
			var/preview_relative_y = (preview_render["pixel_y"] || 0) - (body_scale_offset["pixel_y"] || 0)

			if(live_render["width"] != preview_render["width"] || live_render["height"] != preview_render["height"] || live_relative_x != preview_relative_x || live_relative_y != preview_relative_y)
				TEST_FAIL("[model_name] / [variant_name] size [selected_size] dir [selected_dir] live=(px [live_render["pixel_x"]], py [live_render["pixel_y"]], rel [live_relative_x],[live_relative_y], size [live_render["width"]]x[live_render["height"]]) preview=(px [preview_render["pixel_x"]], py [preview_render["pixel_y"]], rel [preview_relative_x],[preview_relative_y], size [preview_render["width"]]x[preview_render["height"]]) body_scale_offset=([body_scale_offset["pixel_x"]],[body_scale_offset["pixel_y"]])")

/datum/unit_test/cyborg_genital_preview_alignment/Run()
	check_case("Peacekeeper", "Drake")
	check_case("Peacekeeper", "Meka")
