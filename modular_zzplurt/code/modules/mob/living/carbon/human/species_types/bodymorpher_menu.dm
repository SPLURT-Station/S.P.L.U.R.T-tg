#define BODYMORPHER_PRESET_BASE_KEY "base"
#define BODYMORPHER_PRESET_CUSTOM_KEY "custom"
#define BODYMORPHER_PRESET_BASE_NAME "Base Character"
#define BODYMORPHER_PRESET_LIMIT 20
#define BODYMORPHER_PRESET_NAME_MAX 32

/datum/action/innate/alter_form
	var/base_preset_synced = FALSE

/datum/action/innate/alter_form/Destroy(force, ...)
	SStgui.close_uis(src)
	return ..()

/datum/action/innate/alter_form/Grant(mob/grant_to)
	. = ..()
	if(!ishuman(grant_to))
		return
	sync_base_preset(grant_to)

/datum/action/innate/alter_form/Remove(mob/remove_from)
	SStgui.close_uis(src)
	return ..()

/datum/action/innate/alter_form/Activate()
	var/mob/living/carbon/human/alterer = owner
	if(!ishuman(alterer))
		return
	if(slime_restricted && !isjellyperson(alterer))
		return
	alterer.visible_message(
		span_notice("[owner] [shapeshift_text]"),
		span_notice("You focus intently on altering your body while standing perfectly still...")
	)
	ui_interact(alterer)

/datum/action/innate/alter_form/ui_interact(mob/user, datum/tgui/ui)
	var/mob/living/carbon/human/alterer = owner
	if(ishuman(alterer))
		ensure_base_preset(alterer)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BodyMorpher", name)
		ui.open()

/datum/action/innate/alter_form/ui_state(mob/user)
	return GLOB.always_state

/datum/action/innate/alter_form/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/carbon/human/alterer = owner
	if(!ishuman(alterer))
		return data
	ensure_base_preset(alterer)

	data["action_name"] = name
	data["owner_name"] = alterer.real_name
	data["preset_limit"] = BODYMORPHER_PRESET_LIMIT
	data["presets"] = build_bodymorpher_preset_ui_data(alterer)
	return data

/datum/action/innate/alter_form/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/alterer = owner
	if(!ishuman(alterer) || ui.user != alterer)
		return FALSE

	var/list/before_state
	switch(action)
		if("alter_colours")
			before_state = capture_bodymorpher_snapshot(alterer)
			alter_colours(alterer)
			log_bodymorph_if_changed(alterer, before_state, "changed body colours")
			SStgui.update_uis(src)
			return TRUE
		if("alter_dna")
			before_state = capture_bodymorpher_snapshot(alterer)
			alter_dna(alterer)
			log_bodymorph_if_changed(alterer, before_state, "changed their DNA profile")
			SStgui.update_uis(src)
			return TRUE
		if("alter_hair")
			before_state = capture_bodymorpher_snapshot(alterer)
			alter_hair(alterer)
			log_bodymorph_if_changed(alterer, before_state, "changed their hair")
			SStgui.update_uis(src)
			return TRUE
		if("alter_markings")
			before_state = capture_bodymorpher_snapshot(alterer)
			alter_markings(alterer)
			log_bodymorph_if_changed(alterer, before_state, "changed their markings")
			SStgui.update_uis(src)
			return TRUE
		if("save_preset")
			return prompt_save_bodymorpher_preset(alterer)
		if("load_preset")
			return load_bodymorpher_preset_by_key(alterer, params["preset"])
		if("delete_preset")
			return delete_bodymorpher_preset_by_key(alterer, params["preset"])

	return FALSE

/datum/action/innate/alter_form/proc/get_bodymorpher_preferences(mob/living/carbon/human/alterer)
	return alterer?.client?.prefs

/datum/action/innate/alter_form/proc/get_bodymorpher_preset_store(mob/living/carbon/human/alterer)
	var/datum/preferences/preferences = get_bodymorpher_preferences(alterer)
	var/list/store = preferences?.read_preference(/datum/preference/blob/bodymorpher_presets)
	if(!islist(store))
		store = list()
	store = deep_copy_list(store)
	if(!islist(store[BODYMORPHER_PRESET_CUSTOM_KEY]))
		store[BODYMORPHER_PRESET_CUSTOM_KEY] = list()
	return store

/datum/action/innate/alter_form/proc/save_bodymorpher_preset_store(mob/living/carbon/human/alterer, list/store)
	var/datum/preferences/preferences = get_bodymorpher_preferences(alterer)
	if(!preferences || !islist(store))
		return FALSE
	preferences.write_preference(GLOB.preference_entries[/datum/preference/blob/bodymorpher_presets], store)
	preferences.save_character(TRUE)
	return TRUE

/datum/action/innate/alter_form/proc/sync_base_preset(mob/living/carbon/human/alterer)
	var/list/store = get_bodymorpher_preset_store(alterer)
	store[BODYMORPHER_PRESET_BASE_KEY] = capture_bodymorpher_snapshot(alterer, BODYMORPHER_PRESET_BASE_NAME, TRUE)
	if(save_bodymorpher_preset_store(alterer, store))
		base_preset_synced = TRUE

/datum/action/innate/alter_form/proc/ensure_base_preset(mob/living/carbon/human/alterer)
	var/list/store = get_bodymorpher_preset_store(alterer)
	if(islist(store[BODYMORPHER_PRESET_BASE_KEY]))
		base_preset_synced = TRUE
		return TRUE
	sync_base_preset(alterer)
	store = get_bodymorpher_preset_store(alterer)
	return islist(store[BODYMORPHER_PRESET_BASE_KEY])

/datum/action/innate/alter_form/proc/capture_bodymorpher_snapshot(mob/living/carbon/human/alterer, preset_name = null, is_base = FALSE)
	var/list/hair = list(
		"hairstyle" = alterer.hairstyle,
		"hair_color" = alterer.hair_color,
		"facial_hairstyle" = alterer.facial_hairstyle,
		"facial_hair_color" = alterer.facial_hair_color,
	)
	var/list/dna = list(
		"body_size" = alterer.dna.features["body_size"],
		"gender" = alterer.gender,
		"physique" = alterer.physique,
	)
	var/list/mutant_colors = list(
		"primary" = alterer.dna.features[FEATURE_MUTANT_COLOR],
		"secondary" = alterer.dna.features[FEATURE_MUTANT_COLOR_TWO],
		"tertiary" = alterer.dna.features[FEATURE_MUTANT_COLOR_THREE],
	)
	var/list/genitals = list(
		"breasts_lactation" = alterer.dna.features["breasts_lactation"],
		"breasts_size" = alterer.dna.features["breasts_size"],
		"penis_girth" = alterer.dna.features["penis_girth"],
		"penis_size" = alterer.dna.features["penis_size"],
		"penis_sheath" = alterer.dna.features["penis_sheath"],
		"penis_taur_mode" = alterer.dna.features["penis_taur_mode"],
		"balls_size" = alterer.dna.features["balls_size"],
		"butt_size" = alterer.dna.features["butt_size"],
		"belly_size" = alterer.dna.features["belly_size"],
	)
	return list(
		"name" = preset_name || "",
		"is_base" = is_base,
		"hair" = hair,
		"dna" = dna,
		"mutant_colors" = mutant_colors,
		"body_markings" = deep_copy_list(alterer.dna.species.body_markings),
		"mutant_bodyparts" = deep_copy_list(alterer.dna.species.mutant_bodyparts),
		"genitals" = genitals,
	)

/datum/action/innate/alter_form/proc/build_bodymorpher_preset_ui_data(mob/living/carbon/human/alterer)
	var/list/store = get_bodymorpher_preset_store(alterer)
	var/list/presets = list()
	var/list/base_preset = store[BODYMORPHER_PRESET_BASE_KEY]
	if(islist(base_preset))
		presets += list(build_bodymorpher_ui_entry(BODYMORPHER_PRESET_BASE_KEY, base_preset, TRUE))
	var/list/custom_presets = store[BODYMORPHER_PRESET_CUSTOM_KEY]
	for(var/preset_name in custom_presets)
		var/list/preset_data = custom_presets[preset_name]
		if(!islist(preset_data))
			continue
		presets += list(build_bodymorpher_ui_entry(preset_name, preset_data, FALSE))
	return presets

/datum/action/innate/alter_form/proc/build_bodymorpher_ui_entry(preset_key, list/preset_data, is_base)
	var/list/dna = preset_data["dna"]
	var/list/mutant_bodyparts = preset_data["mutant_bodyparts"]
	return list(
		"id" = preset_key,
		"name" = preset_data["name"] || preset_key,
		"is_base" = is_base,
		"gender" = dna?["gender"] || "Unset",
		"body_size" = round((dna?["body_size"] || 1) * 100),
		"mutant_part_count" = length(mutant_bodyparts),
	)

/datum/action/innate/alter_form/proc/prompt_save_bodymorpher_preset(mob/living/carbon/human/alterer)
	var/list/store = get_bodymorpher_preset_store(alterer)
	var/list/custom_presets = store[BODYMORPHER_PRESET_CUSTOM_KEY]
	var/preset_name = tgui_input_text(alterer, "Name this bodymorph preset.", "Save Preset", max_length = BODYMORPHER_PRESET_NAME_MAX)
	if(!preset_name)
		return FALSE
	preset_name = copytext_char(preset_name, 1, BODYMORPHER_PRESET_NAME_MAX + 1)
	if(!length(preset_name))
		return FALSE
	if(preset_name == BODYMORPHER_PRESET_BASE_NAME)
		to_chat(alterer, span_warning("That preset name is reserved."))
		return FALSE
	if(!(preset_name in custom_presets) && length(custom_presets) >= BODYMORPHER_PRESET_LIMIT)
		to_chat(alterer, span_warning("You can only save up to [BODYMORPHER_PRESET_LIMIT] bodymorph presets."))
		return FALSE
	if(preset_name in custom_presets)
		var/overwrite = tgui_alert(alterer, "Overwrite the existing preset '[preset_name]'?", "Overwrite Preset", list("Yes", "No"))
		if(overwrite != "Yes")
			return FALSE
	custom_presets[preset_name] = capture_bodymorpher_snapshot(alterer, preset_name, FALSE)
	if(!save_bodymorpher_preset_store(alterer, store))
		return FALSE
	SStgui.update_uis(src)
	return TRUE

/datum/action/innate/alter_form/proc/load_bodymorpher_preset_by_key(mob/living/carbon/human/alterer, preset_key)
	var/list/store = get_bodymorpher_preset_store(alterer)
	var/list/preset = get_bodymorpher_preset_by_key(store, preset_key)
	if(!islist(preset))
		return FALSE
	if(!apply_bodymorpher_preset(alterer, preset))
		return FALSE
	log_bodymorph_event(alterer, "loaded the '[preset["name"] || preset_key]' preset")
	SStgui.update_uis(src)
	return TRUE

/datum/action/innate/alter_form/proc/delete_bodymorpher_preset_by_key(mob/living/carbon/human/alterer, preset_key)
	if(preset_key == BODYMORPHER_PRESET_BASE_KEY)
		return FALSE
	var/list/store = get_bodymorpher_preset_store(alterer)
	var/list/custom_presets = store[BODYMORPHER_PRESET_CUSTOM_KEY]
	if(!(preset_key in custom_presets))
		return FALSE
	var/delete_choice = tgui_alert(alterer, "Delete the preset '[preset_key]'?", "Delete Preset", list("Delete", "Cancel"))
	if(delete_choice != "Delete")
		return FALSE
	custom_presets -= preset_key
	if(!save_bodymorpher_preset_store(alterer, store))
		return FALSE
	SStgui.update_uis(src)
	return TRUE

/datum/action/innate/alter_form/proc/get_bodymorpher_preset_by_key(list/store, preset_key)
	if(preset_key == BODYMORPHER_PRESET_BASE_KEY)
		return store[BODYMORPHER_PRESET_BASE_KEY]
	var/list/custom_presets = store[BODYMORPHER_PRESET_CUSTOM_KEY]
	return custom_presets[preset_key]

/datum/action/innate/alter_form/proc/apply_bodymorpher_preset(mob/living/carbon/human/alterer, list/preset)
	if(!islist(preset))
		return FALSE

	var/list/mutant_colors = preset["mutant_colors"]
	if(islist(mutant_colors))
		apply_bodymorpher_color(alterer, FEATURE_MUTANT_COLOR, mutant_colors["primary"])
		apply_bodymorpher_color(alterer, FEATURE_MUTANT_COLOR_TWO, mutant_colors["secondary"])
		apply_bodymorpher_color(alterer, FEATURE_MUTANT_COLOR_THREE, mutant_colors["tertiary"])

	var/list/hair = preset["hair"]
	if(islist(hair))
		if(hair["hairstyle"] in SSaccessories.hairstyles_list)
			alterer.set_hairstyle(hair["hairstyle"], update = FALSE)
		if(hair["facial_hairstyle"] in SSaccessories.facial_hairstyles_list)
			alterer.set_facial_hairstyle(hair["facial_hairstyle"], update = FALSE)
		if(istext(hair["hair_color"]))
			alterer.set_haircolor(sanitize_hexcolor(hair["hair_color"]), update = FALSE)
		if(istext(hair["facial_hair_color"]))
			alterer.set_facial_haircolor(sanitize_hexcolor(hair["facial_hair_color"]), update = FALSE)

	var/list/dna = preset["dna"]
	if(islist(dna))
		var/new_body_size = sanitize_float(dna["body_size"], BODY_SIZE_MIN, BODY_SIZE_MAX, 0.01, alterer.dna.features["body_size"])
		alterer.update_size(new_body_size)
		if(dna["gender"] in list(MALE, FEMALE, PLURAL, NEUTER))
			alterer.gender = dna["gender"]
		if(dna["physique"] in list(MALE, FEMALE))
			alterer.physique = dna["physique"]

	var/list/body_markings = sanitize_bodymorpher_markings(preset["body_markings"])
	if(islist(body_markings))
		alterer.dna.species.body_markings = body_markings

	apply_bodymorpher_mutant_parts(alterer, preset["mutant_bodyparts"])
	apply_bodymorpher_genitals(alterer, preset["genitals"])

	alterer.dna.update_ui_block(/datum/dna_block/identity/gender)
	alterer.mutant_renderkey = ""
	alterer.update_body(is_creating = TRUE)
	alterer.update_body_parts()
	alterer.update_mutations_overlay()
	alterer.update_clothing(ALL)
	return TRUE

/datum/action/innate/alter_form/proc/apply_bodymorpher_color(mob/living/carbon/human/alterer, feature_key, color_value)
	if(!istext(color_value))
		return
	alterer.dna.features[feature_key] = sanitize_hexcolor(color_value)
	switch(feature_key)
		if(FEATURE_MUTANT_COLOR)
			alterer.dna.update_uf_block(/datum/dna_block/feature/mutant_color)
		if(FEATURE_MUTANT_COLOR_TWO)
			alterer.dna.update_uf_block(/datum/dna_block/feature/mutant_color/two)
		if(FEATURE_MUTANT_COLOR_THREE)
			alterer.dna.update_uf_block(/datum/dna_block/feature/mutant_color/three)

/datum/action/innate/alter_form/proc/sanitize_bodymorpher_markings(list/body_markings)
	if(!islist(body_markings))
		return null
	var/list/sanitized = list()
	for(var/zone in body_markings)
		var/list/zone_markings = body_markings[zone]
		if(!islist(zone_markings))
			continue
		for(var/marking_key in zone_markings)
			if(!GLOB.body_markings[marking_key])
				continue
			if(!islist(sanitized[zone]))
				sanitized[zone] = list()
			sanitized[zone][marking_key] = zone_markings[marking_key]
	return sanitized

/datum/action/innate/alter_form/proc/get_bodymorpher_mutant_blocks(mob/living/carbon/human/alterer)
	var/list/mutant_part_list = list()
	for(var/datum/dna_block/feature/mutant/block as anything in subtypesof(/datum/dna_block/feature/mutant))
		if(CONFIG_GET(flag/disable_erp_preferences) && (block::feature_key in ORGAN_ERP_LIST))
			continue
		mutant_part_list[block::feature_key] = block
	return mutant_part_list

/datum/action/innate/alter_form/proc/apply_bodymorpher_mutant_parts(mob/living/carbon/human/alterer, list/desired_parts)
	var/list/mutant_part_blocks = get_bodymorpher_mutant_blocks(alterer)
	var/list/current_parts = deep_copy_list(alterer.dna.species.mutant_bodyparts)
	if(!islist(desired_parts))
		desired_parts = list()

	for(var/current_key in current_parts)
		if((current_key in available_choices) && !(current_key in desired_parts))
			apply_single_bodymorpher_mutant_part(alterer, current_key, null, mutant_part_blocks)

	for(var/desired_key in desired_parts)
		if(!(desired_key in available_choices))
			continue
		apply_single_bodymorpher_mutant_part(alterer, desired_key, desired_parts[desired_key], mutant_part_blocks)

/datum/action/innate/alter_form/proc/apply_single_bodymorpher_mutant_part(mob/living/carbon/human/alterer, mutant_key, list/preset_part, list/mutant_part_blocks)
	var/datum/sprite_accessory/selected_sprite_accessory
	if(!islist(preset_part))
		selected_sprite_accessory = get_bodymorpher_removal_accessory(mutant_key)
	else
		var/selected_name = preset_part[MUTANT_INDEX_NAME]
		if(!(selected_name in available_choices[mutant_key]))
			return FALSE
		selected_sprite_accessory = SSaccessories.sprite_accessories[mutant_key][selected_name]

	if(!selected_sprite_accessory)
		return FALSE

	alterer.mutant_renderkey = ""
	if(!selected_sprite_accessory.factual)
		if(selected_sprite_accessory.organ_type)
			var/obj/item/organ/organ_path = selected_sprite_accessory.organ_type
			var/slot = initial(organ_path.slot)
			var/obj/item/organ/got_organ = alterer.get_organ_slot(slot)
			if(got_organ)
				got_organ.Remove(alterer)
				qdel(got_organ)
		alterer.dna.species.mutant_bodyparts -= mutant_key
		alterer.dna.mutant_bodyparts -= mutant_key
	else
		if(selected_sprite_accessory.organ_type)
			var/robot_organs = HAS_TRAIT(alterer, TRAIT_ROBOTIC_DNA_ORGANS)
			var/obj/item/organ/organ_path = selected_sprite_accessory.organ_type
			var/slot = initial(organ_path.slot)
			var/obj/item/organ/got_organ = alterer.get_organ_slot(slot)
			if(got_organ)
				got_organ.Remove(alterer)
				qdel(got_organ)

			var/obj/item/organ/replacement_organ = SSwardrobe.provide_type(selected_sprite_accessory.organ_type)
			replacement_organ.sprite_accessory_flags = selected_sprite_accessory.flags_for_organ
			replacement_organ.relevant_layers = selected_sprite_accessory.relevent_layers

			var/list/new_acc_list = list()
			new_acc_list[MUTANT_INDEX_NAME] = selected_sprite_accessory.name
			var/list/saved_color = preset_part?[MUTANT_INDEX_COLOR_LIST]
			if(!islist(saved_color))
				saved_color = selected_sprite_accessory.get_default_color(alterer.dna.features, alterer.dna.species)
			new_acc_list[MUTANT_INDEX_COLOR_LIST] = deep_copy_list(saved_color)
			alterer.dna.species.mutant_bodyparts[mutant_key] = new_acc_list
			alterer.dna.mutant_bodyparts[mutant_key] = new_acc_list.Copy()

			if(robot_organs)
				replacement_organ.organ_flags |= ORGAN_ROBOTIC
			replacement_organ.build_from_dna(alterer.dna, mutant_key)
			replacement_organ.Insert(alterer, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		else
			var/list/new_acc_list = list()
			new_acc_list[MUTANT_INDEX_NAME] = selected_sprite_accessory.name
			var/list/saved_color = preset_part?[MUTANT_INDEX_COLOR_LIST]
			if(!islist(saved_color))
				saved_color = selected_sprite_accessory.get_default_color(alterer.dna.features, alterer.dna.species)
			new_acc_list[MUTANT_INDEX_COLOR_LIST] = deep_copy_list(saved_color)
			alterer.dna.species.mutant_bodyparts[mutant_key] = new_acc_list
			alterer.dna.mutant_bodyparts[mutant_key] = new_acc_list.Copy()

		if(mutant_part_blocks[mutant_key])
			alterer.dna.update_uf_block(mutant_part_blocks[mutant_key])
	return TRUE

/datum/action/innate/alter_form/proc/get_bodymorpher_removal_accessory(mutant_key)
	var/list/options = available_choices[mutant_key]
	if(!islist(options))
		return null
	for(var/option_name in options)
		var/datum/sprite_accessory/option = SSaccessories.sprite_accessories[mutant_key][option_name]
		if(!option?.factual)
			return option
	return null

/datum/action/innate/alter_form/proc/apply_bodymorpher_genitals(mob/living/carbon/human/alterer, list/genital_data)
	if(!islist(genital_data))
		return

	var/obj/item/organ/genital/breasts/breasts = alterer.get_organ_slot(ORGAN_SLOT_BREASTS)
	if(breasts)
		if(!isnull(genital_data["breasts_lactation"]))
			alterer.dna.features["breasts_lactation"] = !!genital_data["breasts_lactation"]
			breasts.lactates = alterer.dna.features["breasts_lactation"]
		if(!isnull(genital_data["breasts_size"]))
			alterer.dna.features["breasts_size"] = genital_data["breasts_size"]
			breasts.set_size(alterer.dna.features["breasts_size"])

	var/obj/item/organ/genital/penis/penis = alterer.get_organ_slot(ORGAN_SLOT_PENIS)
	if(penis)
		if(!isnull(genital_data["penis_size"]))
			alterer.dna.features["penis_size"] = genital_data["penis_size"]
			penis.set_size(alterer.dna.features["penis_size"])
		if(!isnull(genital_data["penis_girth"]))
			alterer.dna.features["penis_girth"] = min(genital_data["penis_girth"], max(alterer.dna.features["penis_size"] - 1, 1))
			penis.girth = alterer.dna.features["penis_girth"]
		if(genital_data["penis_sheath"] in SHEATH_MODES)
			alterer.dna.features["penis_sheath"] = genital_data["penis_sheath"]
			penis.sheath = genital_data["penis_sheath"]
		if(!isnull(genital_data["penis_taur_mode"]))
			alterer.dna.features["penis_taur_mode"] = !!genital_data["penis_taur_mode"]

	var/obj/item/organ/genital/testicles/testicles = alterer.get_organ_slot(ORGAN_SLOT_TESTICLES)
	if(testicles && !isnull(genital_data["balls_size"]))
		alterer.dna.features["balls_size"] = genital_data["balls_size"]
		testicles.set_size(alterer.dna.features["balls_size"])

	var/obj/item/organ/genital/butt/butt = alterer.get_organ_slot(ORGAN_SLOT_BUTT)
	if(butt && !isnull(genital_data["butt_size"]))
		alterer.dna.features["butt_size"] = genital_data["butt_size"]
		butt.set_size(alterer.dna.features["butt_size"])

	var/obj/item/organ/genital/belly/belly = alterer.get_organ_slot(ORGAN_SLOT_BELLY)
	if(belly && !isnull(genital_data["belly_size"]))
		alterer.dna.features["belly_size"] = genital_data["belly_size"]
		belly.set_size(alterer.dna.features["belly_size"])

/datum/action/innate/alter_form/proc/log_bodymorph_if_changed(mob/living/carbon/human/alterer, list/before_state, detail)
	var/list/after_state = capture_bodymorpher_snapshot(alterer)
	if(json_encode(before_state) == json_encode(after_state))
		return
	log_bodymorph_event(alterer, detail)

/datum/action/innate/alter_form/proc/log_bodymorph_event(mob/living/carbon/human/alterer, detail)
	alterer.log_message("used [name] to [detail].", LOG_GAME)

#undef BODYMORPHER_PRESET_BASE_KEY
#undef BODYMORPHER_PRESET_CUSTOM_KEY
#undef BODYMORPHER_PRESET_BASE_NAME
#undef BODYMORPHER_PRESET_LIMIT
#undef BODYMORPHER_PRESET_NAME_MAX
