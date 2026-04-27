/area/misc/condo/burn_the_sheets(atom/movable/gone)
	if(SScondos.should_preserve_condo(src, gone))
		log_game("[gone] has left condo [condo_number].")
		return
	. = ..()
