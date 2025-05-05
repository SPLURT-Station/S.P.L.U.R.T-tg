/obj/vehicle/sealed/mecha/ripley/cargo/Initialize(mapload)
	. = ..()
	for(var/obj/item/mecha_parts/mecha_equipment/armor/armor in equip_by_category[MECHA_ARMOR])
		armor.detach(loc)
		qdel(armor)

/obj/vehicle/sealed/mecha/ripley/update_pressure()
	. = ..()
	move_delay *= get_equipment_slowdown()
