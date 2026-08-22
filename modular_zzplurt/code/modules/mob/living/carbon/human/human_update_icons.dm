#define RESOLVE_ICON_STATE(worn_item) (worn_item.worn_icon_state || worn_item.icon_state)

/mob/living/carbon/human/regenerate_icons()
	. = ..()
	if(.)
		return
	update_worn_shirt()
	update_worn_bra()
	update_worn_underwear()
	update_worn_wrists()
	update_worn_ears_extra()
	update_worn_socks()

/mob/living/carbon/human/update_worn_underwear()
	remove_overlay(UNDERWEAR_LAYER)
	hud_used?.update_inventory_slot(ITEM_SLOT_UNDERWEAR)

	if(w_underwear)
		var/obj/item/clothing/underwear/briefs/undies = w_underwear

		if(underwear_visibility & UNDERWEAR_HIDE_UNDIES)
			return

		var/target_overlay = undies.icon_state
		var/mutable_appearance/underwear_overlay
		var/icon_file = 'modular_zzplurt/icons/mob/clothing/underwear.dmi'
		var/handled_by_bodyshape = TRUE
		var/digi
		var/woman
		var/female_sprite_flags = istype(undies) ? undies.female_sprite_flags : NONE
		var/mutant_styles = NONE

		if((bodyshape & BODYSHAPE_DIGITIGRADE) && (undies.supports_variations_flags & CLOTHING_DIGITIGRADE_VARIATION))
			icon_file = undies.worn_icon_digi || DIGITIGRADE_UNDERWEAR_FILE
			digi = TRUE
			if(undies.worn_icon_digi == undies.worn_icon)
				target_overlay += "_d"
		else if(bodyshape & BODYSHAPE_CUSTOM)
			icon_file = dna.species.generate_custom_worn_icon(OFFSET_UNDERWEAR, w_underwear, src)

		if(!dna.species.no_gender_shaping && dna.species.sexes && (bodyshape & BODYSHAPE_HUMANOID) && physique == FEMALE && !(female_sprite_flags & NO_FEMALE_UNIFORM))
			woman = TRUE
			if(digi && !(female_sprite_flags & FEMALE_UNIFORM_DIGI_FULL))
				female_sprite_flags &= ~FEMALE_UNIFORM_FULL
				female_sprite_flags |= FEMALE_UNIFORM_TOP_ONLY

		if(digi)
			mutant_styles |= STYLE_DIGI

		if(!icon_exists(icon_file, RESOLVE_ICON_STATE(undies)))
			icon_file = DEFAULT_UNDERWEAR_FILE
			handled_by_bodyshape = FALSE

		underwear_overlay = undies.build_worn_icon(
			default_layer = UNDERWEAR_LAYER,
			default_icon_file = icon_file,
			isinhands = FALSE,
			female_uniform = woman ? female_sprite_flags : null,
			override_state = target_overlay,
			override_file = handled_by_bodyshape ? icon_file : null,
			mutant_styles = mutant_styles,
		)

		if(undies.flags_1 & IS_PLAYER_COLORABLE_1)
			underwear_overlay.color = underwear_color
			undies.color = underwear_color

		var/obj/item/bodypart/chest/my_chest = get_bodypart(BODY_ZONE_CHEST)
		my_chest?.worn_underwear_offset?.apply_offset(underwear_overlay)

		overlays_standing[UNDERWEAR_LAYER] = underwear_overlay
		apply_overlay(UNDERWEAR_LAYER)

	update_body_parts()

/mob/living/carbon/human/update_worn_shirt()
	remove_overlay(SHIRT_LAYER)
	hud_used?.update_inventory_slot(ITEM_SLOT_SHIRT)

	if(istype(w_shirt, /obj/item/clothing/underwear/shirt))
		var/obj/item/clothing/underwear/shirt/undershirt = w_shirt

		if(underwear_visibility & UNDERWEAR_HIDE_SHIRT)
			return

		var/target_overlay = undershirt.icon_state
		var/mutable_appearance/shirt_overlay
		var/icon_file = 'modular_zzplurt/icons/mob/clothing/underwear.dmi'
		var/handled_by_bodyshape = TRUE
		var/digi
		var/woman
		var/female_sprite_flags = w_shirt.female_sprite_flags
		var/mutant_styles = NONE

		if((bodyshape & BODYSHAPE_DIGITIGRADE) && (undershirt.supports_variations_flags & CLOTHING_DIGITIGRADE_VARIATION))
			icon_file = undershirt.worn_icon_digi || DIGITIGRADE_SHIRT_FILE
			digi = TRUE
			if(undershirt.worn_icon_digi == undershirt.worn_icon)
				target_overlay += "_d"
		else if(bodyshape & BODYSHAPE_CUSTOM)
			icon_file = dna.species.generate_custom_worn_icon(OFFSET_SHIRT, w_shirt, src)

		if(!dna.species.no_gender_shaping && dna.species.sexes && (bodyshape & BODYSHAPE_HUMANOID) && physique == FEMALE && !(female_sprite_flags & NO_FEMALE_UNIFORM))
			woman = TRUE
			if(digi && !(female_sprite_flags & FEMALE_UNIFORM_DIGI_FULL))
				female_sprite_flags &= ~FEMALE_UNIFORM_FULL
				female_sprite_flags |= FEMALE_UNIFORM_TOP_ONLY

		if(digi)
			mutant_styles |= STYLE_DIGI

		if(!icon_exists(icon_file, RESOLVE_ICON_STATE(undershirt)))
			icon_file = DEFAULT_SHIRT_FILE
			handled_by_bodyshape = FALSE

		shirt_overlay = undershirt.build_worn_icon(
			default_layer = SHIRT_LAYER,
			default_icon_file = icon_file,
			isinhands = FALSE,
			female_uniform = woman ? female_sprite_flags : null,
			override_state = target_overlay,
			override_file = handled_by_bodyshape ? icon_file : null,
			mutant_styles = mutant_styles,
		)

		if(undershirt.flags_1 & IS_PLAYER_COLORABLE_1)
			shirt_overlay.color = undershirt_color
			undershirt.color = undershirt_color

		var/obj/item/bodypart/chest/my_chest = get_bodypart(BODY_ZONE_CHEST)
		my_chest?.worn_shirt_offset?.apply_offset(shirt_overlay)

		overlays_standing[SHIRT_LAYER] = shirt_overlay
		apply_overlay(SHIRT_LAYER)

	update_body_parts()

/mob/living/carbon/human/update_worn_bra()
	remove_overlay(BRA_LAYER)
	hud_used?.update_inventory_slot(ITEM_SLOT_BRA)

	if(istype(w_bra, /obj/item/clothing/underwear/shirt/bra))
		var/obj/item/clothing/underwear/shirt/bra/bra = w_bra

		if(underwear_visibility & UNDERWEAR_HIDE_BRA)
			return

		var/target_overlay = bra.icon_state
		var/mutable_appearance/bra_overlay
		var/icon_file = 'modular_zzplurt/icons/mob/clothing/underwear.dmi'
		var/handled_by_bodyshape = TRUE
		var/digi
		var/woman
		var/female_sprite_flags = w_bra.female_sprite_flags
		var/mutant_styles = NONE

		if((bodyshape & BODYSHAPE_DIGITIGRADE) && (bra.supports_variations_flags & CLOTHING_DIGITIGRADE_VARIATION))
			icon_file = bra.worn_icon_digi || DIGITIGRADE_SHIRT_FILE
			digi = TRUE
			if(bra.worn_icon_digi == bra.worn_icon)
				target_overlay += "_d"
		else if(bodyshape & BODYSHAPE_CUSTOM)
			icon_file = dna.species.generate_custom_worn_icon(OFFSET_SHIRT, w_bra, src)

		if(!dna.species.no_gender_shaping && dna.species.sexes && (bodyshape & BODYSHAPE_HUMANOID) && physique == FEMALE && !(female_sprite_flags & NO_FEMALE_UNIFORM))
			woman = TRUE
			if(digi && !(female_sprite_flags & FEMALE_UNIFORM_DIGI_FULL))
				female_sprite_flags &= ~FEMALE_UNIFORM_FULL
				female_sprite_flags |= FEMALE_UNIFORM_TOP_ONLY

		if(digi)
			mutant_styles |= STYLE_DIGI

		if(!icon_exists(icon_file, RESOLVE_ICON_STATE(bra)))
			icon_file = DEFAULT_SHIRT_FILE
			handled_by_bodyshape = FALSE

		bra_overlay = bra.build_worn_icon(
			default_layer = BRA_LAYER,
			default_icon_file = icon_file,
			isinhands = FALSE,
			female_uniform = woman ? female_sprite_flags : null,
			override_state = target_overlay,
			override_file = handled_by_bodyshape ? icon_file : null,
			mutant_styles = mutant_styles,
		)

		if(bra.flags_1 & IS_PLAYER_COLORABLE_1)
			bra_overlay.color = bra_color
			bra.color = bra_color

		var/obj/item/bodypart/chest/my_chest = get_bodypart(BODY_ZONE_CHEST)
		my_chest?.worn_shirt_offset?.apply_offset(bra_overlay)

		overlays_standing[BRA_LAYER] = bra_overlay
		apply_overlay(BRA_LAYER)

	update_body_parts()

/mob/living/carbon/human/update_worn_wrists()
	remove_overlay(WRISTS_LAYER)
	hud_used?.update_inventory_slot(ITEM_SLOT_WRISTS)

	if(wrists)
		var/icon_file = 'modular_zzplurt/icons/mob/clothing/wrists.dmi'

		var/mutant_override = FALSE
		if(bodyshape & BODYSHAPE_CUSTOM)
			var/species_icon_file = dna.species.generate_custom_worn_icon(OFFSET_WRISTS, wrists, src)
			if(species_icon_file)
				icon_file = species_icon_file
				mutant_override = TRUE

		var/mutable_appearance/wrists_overlay = wrists.build_worn_icon(default_layer = WRISTS_LAYER, default_icon_file = icon_file, override_file = mutant_override ? icon_file : null)

		overlays_standing[WRISTS_LAYER] = wrists_overlay
	apply_overlay(WRISTS_LAYER)

/mob/living/carbon/human/update_worn_ears_extra()
	remove_overlay(EARS_EXTRA_LAYER)
	hud_used?.update_inventory_slot(ITEM_SLOT_EARS_RIGHT)

	var/obj/item/bodypart/head/my_head = get_bodypart(BODY_ZONE_HEAD)
	if(isnull(my_head)) //decapitated
		return

	if(ears_extra)
		if(obscured_slots & HIDEEARS)
			return

		var/icon_file = 'icons/mob/clothing/ears.dmi'

		var/mutant_override = FALSE
		if(bodyshape & BODYSHAPE_CUSTOM)
			var/species_icon_file = dna.species.generate_custom_worn_icon(OFFSET_EARS, ears_extra, src)
			if(species_icon_file)
				icon_file = species_icon_file
				mutant_override = TRUE

		var/mutable_appearance/ears_overlay = ears_extra.build_worn_icon(default_layer = EARS_EXTRA_LAYER, default_icon_file = icon_file, override_file = mutant_override ? icon_file : null)

		if(!mutant_override)
			my_head.worn_ears_offset?.apply_offset(ears_overlay)
		overlays_standing[EARS_EXTRA_LAYER] = ears_overlay
	apply_overlay(EARS_EXTRA_LAYER)

/mob/living/carbon/human/update_worn_socks()
	remove_overlay(SOCKS_LAYER)

	if(num_legs < 2 || get_taur_mode())
		return

	hud_used?.update_inventory_slot(ITEM_SLOT_SOCKS)

	if(istype(w_socks, /obj/item/clothing/underwear/socks))
		var/obj/item/clothing/underwear/socks/worn_item = w_socks

		if(underwear_visibility & UNDERWEAR_HIDE_SOCKS)
			return

		var/target_overlay = worn_item.icon_state
		var/icon_file = DEFAULT_SOCKS_FILE
		var/mutant_override = FALSE

		if((bodyshape & BODYSHAPE_DIGITIGRADE) && (worn_item.supports_variations_flags & CLOTHING_DIGITIGRADE_VARIATION))
			var/obj/item/bodypart/leg = src.get_bodypart(BODY_ZONE_L_LEG)
			if(leg.limb_id == "digitigrade" || leg.bodyshape & BODYSHAPE_DIGITIGRADE)
				icon_file = worn_item.worn_icon_digi || DIGITIGRADE_SOCKS_FILE
				mutant_override = TRUE

				if(worn_item.worn_icon_digi == worn_item.worn_icon)
					target_overlay = "[worn_item.icon_state]_d"
					worn_item.worn_icon_state = target_overlay
		else if(!(bodyshape & BODYSHAPE_DIGITIGRADE) && worn_item.worn_icon_state && !isnull(worn_item.worn_icon_state))
			if(findtext(worn_item.worn_icon_state, "_d"))
				target_overlay = initial(worn_item.icon_state)
				worn_item.worn_icon_state = initial(worn_item.icon_state)

		if(!mutant_override && bodyshape & BODYSHAPE_CUSTOM)
			var/species_icon_file = dna.species.generate_custom_worn_icon(OFFSET_SOCKS, w_socks, src)
			if(species_icon_file)
				icon_file = species_icon_file
				mutant_override = TRUE

		if(bodyshape & BODYSHAPE_HIDE_SHOES)
			return

		var/mutable_appearance/socks_overlay = w_socks.build_worn_icon(
			default_layer = SOCKS_LAYER,
			default_icon_file = icon_file,
			override_file = mutant_override ? icon_file : null
		)

		if(!socks_overlay)
			return

		var/feature_y_offset = 0
		for (var/body_zone in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
			var/obj/item/bodypart/leg/my_leg = get_bodypart(body_zone)
			if(isnull(my_leg))
				continue
			var/list/foot_offset = my_leg.worn_foot_offset?.get_offset()
			if (foot_offset && foot_offset["y"] > feature_y_offset)
				feature_y_offset = foot_offset["y"]

		if(worn_item.flags_1 & IS_PLAYER_COLORABLE_1)
			socks_overlay.color = socks_color
			worn_item.color = socks_color

		socks_overlay.pixel_y += feature_y_offset
		overlays_standing[SOCKS_LAYER] = socks_overlay

	apply_overlay(SOCKS_LAYER)

	update_body_parts()

// Function for updating back sprites
/mob/living/carbon/human/update_worn_back()
	. = ..()

	// Check for hidden backpack trait
	if(HAS_TRAIT(src, TRAIT_HIDE_BACKPACK))
		// Define back overlays
		var/mutable_appearance/back_overlay = overlays_standing[BACK_LAYER]

		// Check for existing overlay
		if(back_overlay)
			// Remove overlays
			remove_overlay(BACK_LAYER)

/**
 * Helper functions to synchronize and update underwear when body types change
 */

/**
 * Updates all underwear items after leg/body type changes
 * This ensures that preview and in-game rendering remain consistent
 * Call this whenever digitigrade legs or other body types that affect clothing are changed
 */
/mob/living/carbon/human/proc/update_underwear_on_bodytype_change()
	// Force update all underwear items
	update_worn_underwear()
	update_worn_socks()
	update_worn_shirt()
	update_worn_bra()

	// Since we're changing body type, make sure colors are properly applied
	if(w_underwear && (w_underwear.flags_1 & IS_PLAYER_COLORABLE_1))
		w_underwear.color = underwear_color

	if(w_socks && (w_socks.flags_1 & IS_PLAYER_COLORABLE_1))
		w_socks.color = socks_color
		// Force update socks icon for digitigrade legs
		if((bodyshape & BODYSHAPE_DIGITIGRADE) && (w_socks.supports_variations_flags & CLOTHING_DIGITIGRADE_VARIATION))
			// Update the icon state for digitigrade if needed
			if(w_socks.worn_icon_digi == w_socks.worn_icon)
				var/digit_state = "[w_socks.icon_state]_d"
				// This ensures the correct icon state is used for the current leg type
				w_socks.worn_icon_state = digit_state
		else if(!(bodyshape & BODYSHAPE_DIGITIGRADE) && w_socks.worn_icon_state)
			// Revert back to normal state when changing from digi to normal
			w_socks.worn_icon_state = initial(w_socks.worn_icon_state)

	if(w_shirt && (w_shirt.flags_1 & IS_PLAYER_COLORABLE_1))
		w_shirt.color = undershirt_color

	if(w_bra && (w_bra.flags_1 & IS_PLAYER_COLORABLE_1))
		w_bra.color = bra_color

	// Update the body parts to ensure everything renders correctly
	update_body_parts()

/mob/living/carbon/human/update_body(is_creating)
	update_nails()
	. = ..()

/// Extra Inventory: never draw underwear prefs as BODY_LAYER accessory overlays.
/mob/living/carbon/human/get_underwear_overlays()
	return list()

/**
 * Syncs preference underwear strings into Extra Inventory worn items, then refreshes worn overlays.
 * Preference names still live on the mob (underwear/undershirt/socks/bra); visuals come from w_* items.
 */
/mob/living/carbon/human/proc/update_underwear()
	var/dummy_test = istype(src, /mob/living/carbon/human/dummy) && (usr?.client?.prefs.preview_pref == PREVIEW_PREF_NAKED || usr?.client?.prefs.preview_pref == PREVIEW_PREF_NAKED_AROUSED)

	if(HAS_TRAIT(src, TRAIT_NO_UNDERWEAR) || dummy_test)
		dropItemToGround(w_underwear)
		dropItemToGround(w_bra)
		dropItemToGround(w_shirt)
		dropItemToGround(w_socks)
		return

	var/list/obj/item/clothing/underwear/worn_underwear = list()

	var/datum/sprite_accessory/clothing/underwear/underwear_accessory = (underwear && underwear != "Nude" && !(underwear_visibility & UNDERWEAR_HIDE_UNDIES)) ? SSaccessories.underwear_list[underwear] : null
	var/obj/item/briefs = sync_underwear_slot(ITEM_SLOT_UNDERWEAR, w_underwear, underwear_accessory?.briefs_obj)
	if(briefs)
		worn_underwear += briefs

	var/datum/sprite_accessory/clothing/bra/bra_accessory = (bra && bra != "Nude" && !(underwear_visibility & UNDERWEAR_HIDE_BRA)) ? SSaccessories.bra_list[bra] : null
	var/obj/item/bra_item = sync_underwear_slot(ITEM_SLOT_BRA, w_bra, bra_accessory?.bra_obj)
	if(bra_item)
		worn_underwear += bra_item

	var/datum/sprite_accessory/clothing/undershirt/undershirt_accessory = (undershirt && undershirt != "Nude" && !(underwear_visibility & UNDERWEAR_HIDE_SHIRT)) ? SSaccessories.undershirt_list[undershirt] : null
	var/obj/item/shirt = sync_underwear_slot(ITEM_SLOT_SHIRT, w_shirt, undershirt_accessory?.shirt_obj)
	if(shirt)
		worn_underwear += shirt

	var/can_wear_socks = socks && socks != "Nude" && num_legs >= 2 && !get_taur_mode() && !(underwear_visibility & UNDERWEAR_HIDE_SOCKS)
	var/datum/sprite_accessory/clothing/socks/socks_accessory = can_wear_socks ? SSaccessories.socks_list[socks] : null
	var/obj/item/socks_item = sync_underwear_slot(ITEM_SLOT_SOCKS, w_socks, socks_accessory?.socks_obj)
	if(socks_item)
		worn_underwear += socks_item

	// Character preview dummies need inventory flags for proper rendering
	if(istype(src, /mob/living/carbon/human/dummy))
		for(var/obj/item/clothing/underwear/underwear_obj as anything in worn_underwear)
			if(QDELETED(underwear_obj))
				continue
			underwear_obj.item_flags |= IN_INVENTORY

/**
 * Ensures the given Extra Inventory slot matches the accessory's linked clothing typepath.
 * Returns the equipped item (if any) for dummy bookkeeping.
 */
/mob/living/carbon/human/proc/sync_underwear_slot(slot, obj/item/clothing/underwear/current_item, desired_type)
	if(!desired_type)
		if(current_item)
			dropItemToGround(current_item)
		return null

	if(current_item)
		if(current_item.type == desired_type)
			return current_item
		dropItemToGround(current_item)

	var/obj/item/clothing/underwear/new_item = new desired_type(src)
	equip_to_slot_or_del(new_item, slot)
	return new_item

/mob/living/carbon/human/proc/update_nails()
	if(!nail_style)
		return

	remove_overlay(BODY_LAYER)

	if(HAS_TRAIT(src, TRAIT_HUSK) || HAS_TRAIT(src, TRAIT_INVISIBLE_MAN))
		return

	var/list/standing = list()

	var/mutable_appearance/nail_overlay = mutable_appearance('modular_zzplurt/icons/mobs/nails.dmi', "nails", -BODY_LAYER)
	nail_overlay.color = nail_color
	standing += nail_overlay
	if(standing.len)
		overlays_standing[BODY_LAYER] = standing
	apply_overlay(BODY_LAYER)

#undef RESOLVE_ICON_STATE
