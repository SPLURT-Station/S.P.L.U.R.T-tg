/datum/loadout_item
	var/can_be_colored = TRUE
	var/donator_tier = DONATOR_TIER_NONE

/datum/loadout_item/New(category)
	. = ..()
	if((donator_tier || LAZYLEN(ckeywhitelist)) && !donator_only)
		donator_only = TRUE
	if((donator_only || LAZYLEN(ckeywhitelist)) && !donator_tier)
		donator_tier = DONATOR_TIER_1

/datum/loadout_item/to_ui_data()
	var/list/data = ..()
	data["donator_tier"] = donator_tier
	return data

/datum/loadout_item/get_item_information()
	. = ..()
	if(donator_tier)
		. += list(FA_ICON_MONEY_BILL = "Tier [donator_tier] Donator only")

/datum/loadout_item/handle_loadout_action(datum/preference_middleware/loadout/manager, mob/user, action, params)
	. = ..()

	switch(action)
		if("select_simple_color")
			if(can_be_colored && !can_be_greyscale)
				return set_item_simple_color(manager, user)

/datum/loadout_item/on_equip_item(obj/item/equipped_item, datum/preferences/preference_source, list/preference_list, mob/living/carbon/human/equipper, visuals_only)
	. = ..()

	ASSERT(!isnull(equipped_item))

	var/list/item_details = preference_list[item_path]

	// SPLURT ADDITION START: Simple item color (changes color var directly)
	if(can_be_colored && item_details?[INFO_COLOR])
		equipped_item.color = item_details[INFO_COLOR]
		. |= equipped_item.slot_flags
	// SPLURT ADDITION END

/datum/loadout_item/get_ui_buttons()
	. = ..()

	if(can_be_colored && !can_be_greyscale)
		UNTYPED_LIST_ADD(., list(
			"label" = "Simple recolor",
			"act_key" = "select_simple_color",
			"button_icon" = FA_ICON_PALETTE,
			"active_key" = INFO_COLOR,
		))

/// Opens a color picker for directly coloring the item.
/datum/loadout_item/proc/set_item_simple_color(datum/preference_middleware/loadout/manager, mob/user)
	var/list/loadout = manager.get_current_loadout()
	if(!loadout?[item_path])
		return FALSE

	var/current_color = loadout[item_path][INFO_COLOR] || "#FFFFFF"
	var/new_color = tgui_color_picker(user, "Choose a color for [name]:", "Color Selection", current_color)
	if(!new_color)
		return FALSE

	loadout = manager.get_current_loadout() // Make sure no shenanigans happened
	if(!loadout?[item_path])
		return FALSE

	loadout[item_path][INFO_COLOR] = new_color
	manager.save_current_loadout(loadout)
	return TRUE  // update UI
