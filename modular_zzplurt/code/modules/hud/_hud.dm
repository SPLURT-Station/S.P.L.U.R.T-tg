/datum/hud
	var/atom/movable/screen/focus_toggle

/datum/hud/human/Destroy()
	focus_toggle = null
	. = ..()
