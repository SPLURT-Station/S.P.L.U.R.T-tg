/obj/vehicle/sealed/mecha/ripley
	movedelay = 1.275 //movespeed buff due to armor slowdown - originally 1.5
	max_integrity = 175 //integrity nerf to offset the armor buff - originally 200

/obj/vehicle/sealed/mecha/ripley/update_pressure()
	. = ..()
	update_equipment_slowdown()

/obj/vehicle/sealed/mecha/ripley/cargo/Initialize(mapload)
	. = ..()
	for(var/obj/item/mecha_parts/mecha_equipment/armor/armor in equip_by_category[MECHA_ARMOR])
		armor.detach(loc)
		qdel(armor)
