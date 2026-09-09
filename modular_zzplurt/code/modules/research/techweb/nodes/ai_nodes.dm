/// Remove robocop module from AI research node, and add the lewd lawset modules
/datum/techweb_node/ai/New()
	. = ..()
	design_ids -= "robocop_module"
	design_ids |= list("slut_module", "shebang_module", "milker_module", "vore_pred_module")

/// Mark robocop design as ignored by unit tests
/datum/design/board/robocop_module
	id = DESIGN_ID_IGNORE
