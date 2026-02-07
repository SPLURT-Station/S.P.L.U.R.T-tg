/datum/action_group/listed/refresh_actions()
	// If the HUD is mid-rebuild and palette_actions is missing, bail out entirely.
	if(QDELETED(owner) || !owner?.palette_actions)
		return
	. = ..()
	owner.palette_actions.refresh_actions()
