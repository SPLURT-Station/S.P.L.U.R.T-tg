/mob/living/update_transform(resize, rotate)
	if(fuzzy)
		appearance_flags &= ~PIXEL_SCALE
	else
		appearance_flags |= PIXEL_SCALE
	. = ..()
