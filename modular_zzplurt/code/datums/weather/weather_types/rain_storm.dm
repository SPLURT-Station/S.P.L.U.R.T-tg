// This sucks HARDER but not as any fault of it's own.
/datum/weather/particle/rain_storm/no_thunder
	target_trait = ZTRAIT_RAINSTORM_NOTHUNDER
	weather_flags = (WEATHER_TURFS | WEATHER_MOBS | WEATHER_BAROMETER)

/datum/weather/particle/rain_storm/no_thunder/forever_storm
	target_trait = ZTRAIT_RAINSTORM_INFINITE
	telegraph_duration = 0

	weather_flags = (WEATHER_TURFS | WEATHER_ENDLESS | WEATHER_MOBS | WEATHER_BAROMETER)

	probability = 0
