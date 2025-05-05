/obj/vehicle/sealed/mecha
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
