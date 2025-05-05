/datum/action/vehicle/sealed/mecha/skyfall/land()
	. = ..()
	chassis.movedelay *= chassis.get_equipment_slowdown()
