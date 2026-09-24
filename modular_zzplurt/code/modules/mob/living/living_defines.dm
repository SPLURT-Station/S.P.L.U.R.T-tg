/mob/living
	var/datum/action/sizecode_smallsprite/small_sprite = new
	var/fuzzy = FALSE
	var/additional_minimum_arousal = 0 // for things like hexacrocin OD
	// Citadel-style controls: right click opens the context menu by default instead of requiring shift+right click.
	shift_to_open_context_menu = FALSE
