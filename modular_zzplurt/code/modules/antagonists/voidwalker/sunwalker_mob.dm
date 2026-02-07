// oh yeah baby it's toaste time
/mob/living/basic/voidwalker/sunwalker

	melee_damage_lower = 20 // SPLURT change, decreased to 20 from 25
	melee_damage_upper = 32 // SPLURT change, increased to 30 from 25

	health = 180 // SPLURT change, decreased to 180 from 200
	maxHealth = 180 // SPLURT change, decreased to 180 from 200
	damage_coeff = list(BRUTE = 2, BURN = 0.25, TOX = 0, STAMINA = 1, OXY = 0) // SPLURT change, they're the sun, why wouldn't they be near-immune to burn? + weakness to brute for balance

	obj_damage = 38 // SPLURT change, decreased to 38 from 50

	hotspot_temperature = 750 // SPLURT change, decreased to 750 from 1000
	/// Gas volume passively exposed to our temperature
	hotspot_volume = 50 // SPLURT change, decreased to 50 from 100

	/// Water damage we take on any exposure
	water_damage = 25 // SPLURT change, increased to 25 from 20
