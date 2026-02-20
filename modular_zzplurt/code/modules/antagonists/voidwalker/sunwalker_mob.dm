// oh yeah baby it's toaste time
/mob/living/basic/voidwalker/sunwalker

	melee_damage_lower = 20 // SPLURT change, decreased to 20 from 25
	melee_damage_upper = 32 // SPLURT change, increased to 30 from 25

	health = 180 // SPLURT change, decreased to 180 from 200
	maxHealth = 180 // SPLURT change, decreased to 180 from 200
	damage_coeff = list(BRUTE = 2, BURN = 0.25, TOX = 0, STAMINA = 1, OXY = 0) // SPLURT change, they're the sun, why wouldn't they be near-immune to burn? + weakness to brute for balance

	obj_damage = 38 // SPLURT change, decreased to 38 from 50

	hotspot_volume = 75 // SPLURT change, decreased to 75 from 100

	/// Water damage we take on any exposure
	water_damage = 25 // SPLURT change, increased to 25 from 20

	flags_1 = SUPERMATTER_IGNORES_1

	/// Abilities enabled for kidnapping
	can_do_abductions = TRUE

/mob/living/basic/voidwalker/sunwalker/unique_setup()
	. = ..()

	AddComponent(/datum/component/regenerator, brute_per_second = 2, burn_per_second = 2, outline_colour = regenerate_colour, regen_check = CALLBACK(src, PROC_REF(can_regen)))

/mob/living/basic/voidwalker/sunwalker/examine(mob/user)
	. = ..()

	if(!iscarbon(user))
		return

	// MY EYEESSS!!!
	var/mob/living/carbon/carbon = user
	if(carbon.get_eye_protection() < 1)
		var/obj/item/organ/eyes/burning_orbs = locate() in carbon.organs
		burning_orbs?.apply_organ_damage(20)
