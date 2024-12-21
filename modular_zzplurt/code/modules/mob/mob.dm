/mob/proc/create_player_panel()
	QDEL_NULL(mob_panel)

	mob_panel = new(src)

/mob/Initialize()
	. = ..()
	create_player_panel()

/mob/Destroy()
	QDEL_NULL(mob_panel)
	. = ..()

/mob/proc/restrained(ignore_grab)
	return

/mob/proc/is_muzzled()
	return FALSE
