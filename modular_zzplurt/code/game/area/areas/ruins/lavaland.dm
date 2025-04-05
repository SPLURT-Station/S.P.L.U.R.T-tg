// /area/ruin/unpowered/ash_walkers - // Making Ash Walkers camp invincible for rad-storms (Moon-Station bug =p)
/datum/weather/rad_storm/New()
	. = ..()
	protected_areas += /area/ruin/unpowered/ash_walkers
