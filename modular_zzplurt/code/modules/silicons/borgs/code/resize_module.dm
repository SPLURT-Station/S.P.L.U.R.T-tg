/**
 * Borg Resizer
 * A borg module that will let the borg player themselves pick what specific size in percentage they want to be.
 *
 * Primarily utilises code from old Splurt Base alongside code from SPLURT-TG's expander borg module.
 *
 * This file is completely modular, disabling it will revert all changes made to the code base and re-enable the expander/shrinker for the crew.
 * The expander and shrinker is available always to the borg panel utilized by admins
 *
 * File contains the following:
 * * Defines for the Robot base to ensure that the resizer can't be installed if it already has been installed.
 * * Code for the Resizer module that lets the borg player pick the percentage of a size they want to be at.
 * * Design so the crew has access to this module at round start
 * * Code that disables the printing of expand/shrink modules.
 */

#define TECHWEB_NODE_BORG_OLD_SIZE "old_size"

/mob/living/silicon/robot
	// If the borg has been resized already, utilized to prevent people from inserting yet another borg resizer module and possibly causing sprite size issues.
	var/resized = FALSE

/obj/item/borg/upgrade/resize
	name = "borg resizer"
	desc = "A cyborg resizer, it makes a cyborg grow/shrink to different sizes." //Could probably use a different description
	icon_state = "module_general"
	// Standard resize percentage, makes the borg the same size an expander would have made them unless specified otherwise
	var/resize_amount = 160

// Lets a roboticist pick the size for the borg itself if they know about the feature, will also let them make ai shells have a setting
/obj/item/borg/upgrade/resize/attack_self(mob/user, modifiers)
	if(src && !user.incapacitated && in_range(user,src))
		resize_amount = resize_amount = tgui_input_number(user, "Choose the percentage size of Resizing (70-250)","Resizer size setting")
		if(src && resize_amount && !user.incapacitated && in_range(user,src))
			sanitize_integer(resize_amount, 70, 250, 160) //sanitize_integer won't work!
			if(resize_amount >= 250 || !isnum(resize_amount) || resize_amount == null)
				resize_amount = 250
			if(resize_amount <= 70)
				resize_amount = 70
			to_chat(user, span_notice("Expand set to [resize_amount]%."))
			return resize_amount

/obj/item/borg/upgrade/resize/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	to_chat(user, span_warning("Cyborg chassis size is now selected in character preferences. This module is obsolete."))
	return FALSE

/obj/item/borg/upgrade/resize/deactivate(mob/living/silicon/robot/borg, mob/living/user = usr)
	. = ..()
	if(!.)
		return .
	if (borg.resized)
		borg.resized = FALSE

/mob/living/silicon/robot/ResetModel()
	if (resized)
		// Resets the transformation, I do not FULLY understand how this works but this will make the robot ALWAYS return to original size, no matter the size inputted.
		transform = null
		resized = FALSE

	. = ..()

// Borg Resize Module Design
/datum/design/borg_upgrade_resize
	name = "Resize Module"
	id = "borg_upgrade_resize"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/resize
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*1,
		/datum/material/titanium =SHEET_MATERIAL_AMOUNT * 2.5,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL
	)

/datum/techweb_node/augmentation/New()
	. = ..()
	// Removes the shrink and expander from the pool of designs the crew can print, used so there's only one option to use for resizing rather than commenting out those lines of code
	design_ids -= list(
		"borg_upgrade_expand",
		"borg_upgrade_shrink",
		"borg_upgrade_resize"
	)

/datum/techweb_node/old_resize
	id = TECHWEB_NODE_BORG_OLD_SIZE
	display_name = "Old Expander Tech"
	description = "If you're seeing this, then something has gone horribly, horribly wrong"
	design_ids = list(
		"borg_upgrade_expand",
		"borg_upgrade_shrink"
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	hidden = TRUE

#undef TECHWEB_NODE_BORG_OLD_SIZE
