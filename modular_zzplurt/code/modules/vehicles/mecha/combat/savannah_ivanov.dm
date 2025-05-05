/obj/vehicle/sealed/mecha/savannah_ivanov
	movedelay = 2.55 //movespeed buff due to armor slowdown - originally 3
	max_integrity = 385 //integrity nerf to offset the armor buff - originally 450

/datum/action/vehicle/sealed/mecha/skyfall/land()
	. = ..()
	chassis.update_equipment_slowdown()

/datum/armor/mecha_savannah_ivanov
	melee = 23 //original: 45
	bullet = 20 //original: 40
	laser = 15 //original: 30
