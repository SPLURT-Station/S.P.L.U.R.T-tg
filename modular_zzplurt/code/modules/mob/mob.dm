/mob/proc/create_player_panel()
	QDEL_NULL(mob_panel)

	mob_panel = new(src)

/mob/Initialize(mapload)
	set_thirst(rand(NUTRITION_LEVEL_START_MIN, NUTRITION_LEVEL_START_MAX))
	. = ..()
	create_player_panel()

/mob/Destroy()
	QDEL_NULL(mob_panel)
	. = ..()

/mob/proc/restrained(ignore_grab)
	return

/mob/proc/is_muzzled()
	return FALSE
