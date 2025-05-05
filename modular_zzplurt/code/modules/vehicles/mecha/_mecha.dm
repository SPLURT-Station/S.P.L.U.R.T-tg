/obj/vehicle/sealed/mecha
	internal_damage_probability = 30 //makes internal damage more likely, since armor is more common
	/**
	 * Ignore armor plate flat damage reduction while set to TRUE, useful in damage code
	 * A bit janky, but adding another argument to run_atom_armor() would be worse IMHO
	 */
	var/ignore_flat_reduction = FALSE

/obj/vehicle/sealed/mecha/Initialize(mapload, built_manually)
	if(!built_manually && equip_by_category[MECHA_ARMOR] && !length(equip_by_category[MECHA_ARMOR]))
		equip_by_category[MECHA_ARMOR] += /obj/item/mecha_parts/mecha_equipment/armor/basic
	return ..()

/obj/vehicle/sealed/mecha/toggle_overclock(forced_state)
	. = ..()
	update_equipment_slowdown()

/// Updates the mech's move delay, multiplying it by the equipment slowdown
/obj/vehicle/sealed/mecha/proc/update_equipment_slowdown()
	movedelay = CEILING(movedelay * get_equipment_slowdown(), 0.01)
	return movedelay

/// Returns movespeed multipliers for the mecha, mostly for the sake of armor slowdown
/obj/vehicle/sealed/mecha/proc/get_equipment_slowdown()
	var/slowdown = 1
	for(var/obj/item/mecha_parts/mecha_equipment/equipment in flat_equipment)
		slowdown *= equipment.applied_slowdown
	return CEILING(slowdown, 0.01)
