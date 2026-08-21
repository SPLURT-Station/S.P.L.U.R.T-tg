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
 * * Code that disables the printing of expand/shrink modules.
 */

#define TECHWEB_NODE_BORG_OLD_SIZE "old_size"

/mob/living/silicon/robot
	/// Tracks whether the cyborg is currently at a non-default preference size.
	var/resized = FALSE

/mob/living/silicon/robot/ResetModel()
	if(resized)
		// Resets the transformation, I do not FULLY understand how this works but this will make the robot ALWAYS return to original size, no matter the size inputted.
		transform = null
		resized = FALSE

	. = ..()

/datum/techweb_node/augmentation/New()
	. = ..()
	// Removes the shrink and expander from the pool of designs the crew can print, used so there's only one option to use for resizing rather than commenting out those lines of code
	design_ids -= list(
		"borg_upgrade_expand",
		"borg_upgrade_shrink"
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
