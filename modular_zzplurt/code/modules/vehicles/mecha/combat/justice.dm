/obj/vehicle/sealed/mecha/justice/set_safety(mob/user)
	. = ..()
	move_delay *= get_equipment_slowdown()
