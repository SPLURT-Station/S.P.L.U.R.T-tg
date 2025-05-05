/obj/vehicle/sealed/mecha
	movedelay = 0.85 SECONDS //faster, gets slower when equipment (mostly armor) is applied
	max_integrity = 200 //integrity nerf to offset the armor buff
	internal_damage_threshold = 10 //integrity nerf to offset the armor buff
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
	move_delay *= get_equipment_slowdown()

/// Returns movespeed multipliers for the mecha, mostly for the sake of armor slowdown
/obj/vehicle/sealed/mecha/proc/get_equipment_slowdown()
	var/slowdown = 1
	for(var/obj/item/mecha_parts/mecha_equipment/equipment in flat_equipment)
		slowdown *= equipment.applied_slowdown
	return FLOOR(slowdown, 0.01)
