/area/misc/condo/burn_the_sheets(atom/movable/gone)
	var/room_number = condo_number
	if(SScondos.should_preserve_condo(src, gone))
		log_game("[gone] has left condo [condo_number].")
		return
	. = ..()
	SScondos.splurt_forget_room(room_number)
