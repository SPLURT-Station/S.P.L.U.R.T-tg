/// Remove robocop module from AI research node
/datum/techweb_node/ai/New()
	. = ..()
	design_ids -= "robocop_module"

/// Mark robocop design as ignored by unit tests
/datum/design/board/robocop_module
	id = DESIGN_ID_IGNORE
