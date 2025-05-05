/obj/vehicle/sealed/mecha/justice/set_safety(mob/user)
	. = ..()
	update_equipment_slowdown()

/datum/armor/mecha_justice
	melee = 15 //original: 30
	bullet = 10 //original: 20
	laser = 10 //original: 20
