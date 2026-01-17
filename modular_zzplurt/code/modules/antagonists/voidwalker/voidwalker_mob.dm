// mmm buff these motherfuckers
#define WALL_CONVERT_STRENGTH 35

/mob/living/basic/voidwalker

	maxHealth = 135 // SPLURT change, decreased to 135 from 150 so the seccies aren't playing whackamole
	health = 135 // SPLURT change, balanced to 135 from 150 so the seccies aren't playing whackamole
	damage_coeff = list(BRUTE = 1.3, BURN = 0.6, TOX = 0, STAMINA = 1, OXY = 0)

	obj_damage = 20 // SPLURT change, increased to 20 from 15

	melee_damage_lower = 17 // SPLURT change, increased to 16 from 12
	melee_damage_upper = 23 // SPLURT change, increased to 22 from 15

	kidnap_time = 5 SECONDS // SPLURT change, decreased to 5 seconds from 6 seconds

/mob/living/basic/voidwalker/try_convert_wall(turf/closed/wall/our_wall)

	COOLDOWN_START(src, wall_conversion, 30 SECONDS) // SPLURT change, let there be walls (reduced to 30 seconds from 60 seconds)
