/obj/item/mecha_parts/mecha_equipment
	/// How much slowdown we apply when equipped - Higher means slower
	var/applied_slowdown = 1

/obj/item/mecha_parts/mecha_equipment/examine(mob/user)
	. = ..()
	if(applied_slowdown > 1)
		. += span_warning("When equipped onto a mech, [p_they()] will slow it down by [(applied_slowdown-1)*100]%.")
	else if(applied_slowdown < 1)
		. += span_notice("When equipped onto a mech, [p_they()] will speed it up by [(1-applied_slowdown)*100]%.")

/obj/item/mecha_parts/mecha_equipment/attach(obj/vehicle/sealed/mecha/new_mecha, attach_right)
	. = ..()
	chassis.movedelay *= applied_slowdown

/obj/item/mecha_parts/mecha_equipment/detach(atom/moveto)
	chassis.movedelay /= applied_slowdown
	return ..()
