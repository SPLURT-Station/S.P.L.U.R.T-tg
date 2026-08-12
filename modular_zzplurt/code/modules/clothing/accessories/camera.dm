/**
 * Bodycamera subtype of Camera
 * Meant to make sure AIs and such cannot use this as pure vision,
 * and can't be 'disabled' by roundstart, though that really shouldn't happen anyway.
 */
/obj/machinery/camera/bodycamera
	start_active = TRUE
	internal_light = FALSE

/obj/machinery/camera/bodycamera/on_start_watching(datum/source)
	. = ..()
	var/viewer = (ismob(usr) ? key_name(usr) : "UNKNOWN")
	log_game("BODYCAM VIEW: [viewer] started viewing [src] ([c_tag]) via [source] at [loc_name(src)].")
