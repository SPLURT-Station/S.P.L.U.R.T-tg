// SPLURT ADDITION - Bodymorph Presets UI for alter_form action
// Overrides change_form() to add "Presets" tab

/datum/action/innate/alter_form/splurt
	// No changes to existing vars - we just override change_form()

/datum/action/innate/alter_form/splurt/change_form(mob/living/carbon/human/alterer)
	var/selected_alteration = show_radial_menu(
		alterer,
		alterer,
		list(
			"Body Colours" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "slime_rainbow"),
			"DNA" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "dna"),
			"Hair" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "scissors"),
			"Markings" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "rainbow_spraycan"),
			"Presets" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "slime_rainbow"),
		),
		tooltips = TRUE,
	)
	switch(selected_alteration)
		if("Body Colours")
			alter_colours(alterer)
		if("DNA")
			alter_dna(alterer)
		if("Hair")
			alter_hair(alterer)
		if("Markings")
			alter_markings(alterer)
		if("Presets")
			alter_presets(alterer)

// Presets management UI
/datum/action/innate/alter_form/splurt/proc/alter_presets(mob/living/carbon/human/alterer)
	if(!alterer?.client)
		return

	var/datum/bodymorph_presets/bp = alterer.client.get_bodymorph_presets()
	var/list/preset_names = list("Cancel")
	for(var/i = 1, i <= length(bp.presets), i++)
		preset_names += "[bp.presets[i]["name"]]"

	var/list/options = list("Add Current as New Preset", "Load a Preset")
	if(length(bp.presets) > 0)
		options += "Manage Presets"
	if(bp.has_base_preset())
		options += "Load Base Character"

	var/choice = tgui_input_list(alterer, "Bodymorph Presets", "Presets", options)
	if(!choice || choice == "Cancel")
		return

	switch(choice)
		if("Add Current as New Preset")
			add_new_preset(alterer, bp)
		if("Load a Preset")
			load_preset_menu(alterer, bp)
		if("Manage Presets")
			manage_presets_menu(alterer, bp)
		if("Load Base Character")
			load_base_preset(alterer, bp)

/datum/action/innate/alter_form/splurt/proc/add_new_preset(mob/living/carbon/human/alterer, datum/bodymorph_presets/bp)
	var/preset_name = tgui_input_text(alterer, "Enter a name for this preset", "New Preset", max_length = 50)
	if(!preset_name || !preset_name.Trim())
		return

	var/list/preset_data = capture_bodymorph_preset(alterer)
	if(!preset_data)
		alterer.balloon_alert(alterer, "failed to capture preset!")
		return
	preset_data["name"] = preset_name.Trim()

	if(bp.add_preset(preset_data))
		log_game("BODYMORPH: [key_name(alterer)] saved preset '[preset_name]'")
		alterer.balloon_alert(alterer, "preset saved!")
	else
		alterer.balloon_alert(alterer, "failed to save preset!")

/datum/action/innate/alter_form/splurt/proc/load_preset_menu(mob/living/carbon/human/alterer, datum/bodymorph_presets/bp)
	if(length(bp.presets) == 0)
		alterer.balloon_alert(alterer, "no presets saved!")
		return

	var/list/preset_choices = list("Cancel")
	for(var/i = 1, i <= length(bp.presets), i++)
		preset_choices += "[bp.presets[i]["name"]]"

	var/selected = tgui_input_list(alterer, "Select a preset to load", "Load Preset", preset_choices)
	if(!selected || selected == "Cancel")
		return

	var/index = preset_choices.Find(selected) - 2 // -1 for "Cancel", -1 for 1-indexing
	if(index < 1 || index > length(bp.presets))
		return

	var/list/preset = bp.presets[index]
	if(apply_bodymorph_preset(alterer, preset))
		alterer.balloon_alert(alterer, "preset loaded!")
	else
		alterer.balloon_alert(alterer, "failed to apply preset!")

/datum/action/innate/alter_form/splurt/proc/manage_presets_menu(mob/living/carbon/human/alterer, datum/bodymorph_presets/bp)
	if(length(bp.presets) == 0)
		alterer.balloon_alert(alterer, "no presets to manage!")
		return

	var/list/preset_choices = list("Cancel")
	for(var/i = 1, i <= length(bp.presets), i++)
		preset_choices += "[bp.presets[i]["name"]]"

	var/selected = tgui_input_list(alterer, "Select a preset to manage", "Manage Presets", preset_choices)
	if(!selected || selected == "Cancel")
		return

	var/index = preset_choices.Find(selected) - 2
	if(index < 1 || index > length(bp.presets))
		return

	var/list/preset = bp.presets[index]
	var/manage_choice = tgui_input_list(alterer, "What do you want to do with '[preset["name"]]'?", "Manage Preset", list("Load", "Rename", "Overwrite with Current", "Delete", "Cancel"))

	switch(manage_choice)
		if("Load")
			if(apply_bodymorph_preset(alterer, preset))
				alterer.balloon_alert(alterer, "preset loaded!")
			else
				alterer.balloon_alert(alterer, "failed to apply preset!")
		if("Rename")
			var/new_name = tgui_input_text(alterer, "Enter new name", "Rename Preset", default = preset["name"], max_length = 50)
			if(new_name && new_name.Trim())
				preset["name"] = new_name.Trim()
				bp.update_preset(index, preset)
				alterer.balloon_alert(alterer, "preset renamed!")
		if("Overwrite with Current")
			var/list/new_data = capture_bodymorph_preset(alterer)
			if(new_data)
				new_data["name"] = preset["name"] // Keep the same name
				bp.update_preset(index, new_data)
				log_game("BODYMORPH: [key_name(alterer)] overwrote preset '[preset["name"]]'")
				alterer.balloon_alert(alterer, "preset updated!")
			else
				alterer.balloon_alert(alterer, "failed to update preset!")
		if("Delete")
			var/confirm = tgui_alert(alterer, "Are you sure you want to delete '[preset["name"]]'?", "Delete Preset", list("Delete", "Cancel"))
			if(confirm == "Delete")
				bp.remove_preset(index)
				log_game("BODYMORPH: [key_name(alterer)] deleted preset '[preset["name"]]'")
				alterer.balloon_alert(alterer, "preset deleted!")

/datum/action/innate/alter_form/splurt/proc/load_base_preset(mob/living/carbon/human/alterer, datum/bodymorph_presets/bp)
	var/list/base = bp.get_base_preset()
	if(!length(base))
		alterer.balloon_alert(alterer, "no base character saved!")
		return

	if(apply_bodymorph_preset(alterer, base, silent = TRUE))
		log_game("BODYMORPH: [key_name(alterer)] loaded base character preset")
		alterer.balloon_alert(alterer, "base character loaded!")
	else
		alterer.balloon_alert(alterer, "failed to apply base!")
