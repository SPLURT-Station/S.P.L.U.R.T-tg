/mob/living/carbon/human/calculate_affecting_pressure(pressure)
	if(istype(loc, /obj/item/dogborg/sleeper))
		return ONE_ATMOSPHERE
	return ..()

/mob/living/carbon/human/get_heat_protection(temperature)
	if(istype(loc, /obj/item/dogborg/sleeper))
		return FIRE_IMMUNITY_MAX_TEMP_PROTECT
	return ..()

/mob/living/carbon/human/get_cold_protection(temperature)
	if(istype(loc, /obj/item/dogborg/sleeper))
		return FIRE_IMMUNITY_MAX_TEMP_PROTECT
	return ..()

/mob/living/carbon/breathe(seconds_per_tick, times_fired)
	// You don't need to breath inside of a medihound sleeper... apparently.
	if(istype(loc, /obj/item/dogborg/sleeper))
		return
	return ..()
