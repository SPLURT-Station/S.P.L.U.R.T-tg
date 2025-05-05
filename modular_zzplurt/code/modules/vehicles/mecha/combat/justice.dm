/obj/vehicle/sealed/mecha/justice/set_safety(mob/user)
	. = ..()
	movedelay *= get_equipment_slowdown()
