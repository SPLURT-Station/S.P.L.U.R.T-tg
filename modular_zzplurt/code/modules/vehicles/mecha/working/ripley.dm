/obj/vehicle/sealed/mecha/ripley
	movedelay = 1.275 //movespeed buff due to armor slowdown - originally 1.5
	max_integrity = 175 //integrity nerf to offset the armor buff - originally 200
	fast_pressure_step_in = 1.275 //movespeed buff due to armor slowdown - originally 1.5
	slow_pressure_step_in = 1.7 //movespeed buff due to armor slowdown - originally 1.5

/datum/armor/mecha_ripley
	melee = 20 //original: 40
	bullet = 10 //original: 20
	laser = 5 //original: 10

/obj/vehicle/sealed/mecha/ripley/update_pressure()
	. = ..()
	update_equipment_slowdown()

/obj/vehicle/sealed/mecha/ripley/cargo/Initialize(mapload)
	. = ..()
	for(var/obj/item/mecha_parts/mecha_equipment/armor/armor in equip_by_category[MECHA_ARMOR])
		armor.detach(loc)
		qdel(armor)

/datum/armor/mecha_ripley_mk2
	melee = 20 //original: 40
	bullet = 15 //original: 30
	laser = 15 //original: 30

/datum/armor/mecha_paddy
	melee = 20 //original: 20
	bullet = 10 //original: 20
	laser = 5 //original: 10
