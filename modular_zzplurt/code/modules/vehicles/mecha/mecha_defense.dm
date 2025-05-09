/obj/vehicle/sealed/mecha/run_atom_armor(damage_amount, damage_type, damage_flag = 0, attack_dir, armour_penetration = 0)
	var/damage_taken = ..()
	if(damage_flag)
		var/all_flat_armor = 0
		if(!ignore_armor_equipment_reduction && (damage_taken > 0))
			for(var/obj/item/mecha_parts/mecha_equipment/armor/mech_armor in equip_by_category[MECHA_ARMOR])
				if(!isnull(mech_armor.max_mecha_hp) && (mech_armor.mecha_hp <= 0))
					continue
				var/multi_armor
				if(mech_armor.armor_mod)
					var/datum/armor/multi_armor_datum = get_armor_by_type(mech_armor.armor_mod)
					multi_armor = multi_armor_datum.get_rating(damage_flag)
					multi_armor = clamp(PENETRATE_ARMOUR(multi_armor, armour_penetration), min(multi_armor, 0), 100)
				damage_taken = max(0, damage_taken * (100 - multi_armor) * 0.01)
				if(mech_armor.flat_armor)
					all_flat_armor += (mech_armor.flat_armor.get_rating(damage_flag) * ((100 - armour_penetration) * 0.01))
		damage_taken = max(0, damage_taken - all_flat_armor)
	return round(damage_taken, DAMAGE_PRECISION)
