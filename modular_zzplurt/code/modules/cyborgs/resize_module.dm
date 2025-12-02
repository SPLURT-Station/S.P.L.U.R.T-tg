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
	. = ..()
	if(!. || HAS_TRAIT(borg, TRAIT_NO_TRANSFORM))
		return FALSE

	// All these conditions are to prevent this from being installed on borgs that either have been expanded/shrunk or have had a resizer already installed
	if(borg.hasExpanded)
		to_chat(usr, span_warning("This unit already has an expand module installed!"))
		return FALSE

	if(borg.hasShrunk)
		to_chat(usr, span_warning("This unit already has a shrink module installed!"))
		return FALSE

	if(borg.resized)
		to_chat(usr, span_warning("This unit already has an resizing module installed!"))
		return FALSE

	// SKYRAT EDIT ADDITION BEGIN
	if(TRAIT_R_EXPANDER_BLOCKED in borg.model.model_features)
		to_chat(usr, span_warning("This unit is unable to equip an resize module!"))
		return FALSE
	// SKYRAT EDIT ADDITION END

	// Let's the borg player themselves pick what size they want to be in percentage.
	resize_amount = tgui_input_number(borg, "Choose the percentage size of Resizing (70-250)","Resizer size setting")
	// We do not trust the input given, no matter if it's ran through tgui first, so we are sanitizing it to prevent any possible malicious inputs
	sanitize_integer(resize_amount, 70, 250, 160)

	// 250 is the current limit of what we allow for. A Drakeborg at such a size would be almost 5 tiles long.
	if(resize_amount >= 250 || !isnum(resize_amount) || resize_amount == null || resize_amount <= 0)
		resize_amount = 250

	// Agreed upon limit to prevent power gaming or people utilizing smaller borg sizes to make themselves harder to hit.
	if(resize_amount <= 70)
		resize_amount = 70
	to_chat(borg, span_notice("Resize set to [resize_amount]%"))

	ADD_TRAIT(borg, TRAIT_NO_TRANSFORM, REF(src))
	var/prev_lockcharge = borg.lockcharge
	borg.SetLockdown(TRUE)
	borg.set_anchored(TRUE)
	var/datum/effect_system/fluid_spread/smoke/smoke = new
	smoke.set_up(1, holder = borg, location = borg.loc)
	smoke.start()
	sleep(0.2 SECONDS)
	for(var/i in 1 to 4)
		playsound(borg, pick(
			'sound/items/tools/drill_use.ogg',
			'sound/items/tools/jaws_cut.ogg',
			'sound/items/tools/jaws_pry.ogg',
			'sound/items/tools/welder.ogg',
			'sound/items/tools/ratchet.ogg',
			), 80, TRUE, -1)
		sleep(1.2 SECONDS)
	if(!prev_lockcharge)
		borg.SetLockdown(FALSE)
	borg.set_anchored(FALSE)
	REMOVE_TRAIT(borg, TRAIT_NO_TRANSFORM, REF(src))
	borg.resized = TRUE
	borg.update_transform(resize_amount/100) // Divide by 100 to reach usable number so 160% / 100 will become 1.6 and 250% / 100 will be 2.5%

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
		"borg_upgrade_shrink"
	)
	// Adds the borg_upgrade_resize to the design pool.
	design_ids += list(
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
