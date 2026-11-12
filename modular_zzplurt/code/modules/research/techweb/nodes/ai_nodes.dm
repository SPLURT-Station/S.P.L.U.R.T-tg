/// Remove robocop module from AI research node
/datum/techweb_node/ai/New()
	. = ..()
	unlocked_designs -= /datum/design/board/robocop_module

