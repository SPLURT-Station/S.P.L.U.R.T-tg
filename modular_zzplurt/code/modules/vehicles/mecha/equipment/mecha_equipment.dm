/obj/item/mecha_parts/mecha_equipment
	/// How much slowdown we apply when equipped - Higher means slower
	var/applied_slowdown = 1

/obj/item/mecha_parts/mecha_equipment/attach(obj/vehicle/sealed/mecha/new_mecha, attach_right)
	. = ..()
	chassis.movedelay *= applied_slowdown

/obj/item/mecha_parts/mecha_equipment/detach(atom/moveto)
	chassis.movedelay /= applied_slowdown
	return ..()
