/obj/vehicle/sealed/mecha/phazon
	movedelay = 1.7 //movespeed buff due to armor slowdown - originally 2
	max_integrity = 175 //integrity nerf to offset the armor buff - originally 200
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 3,
		MECHA_POWER = 1,
		MECHA_ARMOR = 1,
	) //just one armor, no more plox

/datum/armor/mecha_phazon
	melee = 15 //original: 30
	bullet = 15 //original: 30
	laser = 15 //original: 30
