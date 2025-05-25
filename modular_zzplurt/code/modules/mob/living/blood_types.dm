/datum/blood_type/get_color(dynamic = FALSE, list/blood_DNA)
	var/original_color = color
	if(LAZYLEN(blood_DNA) && blood_DNA[EXOTIC_BLOOD_COLOR_DNA])
		color = blood_DNA[EXOTIC_BLOOD_COLOR_DNA]

	. = ..()

	color = original_color
