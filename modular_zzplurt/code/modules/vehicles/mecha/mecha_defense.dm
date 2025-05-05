/obj/vehicle/sealed/mecha/run_atom_armor(damage_amount, damage_type, damage_flag = 0, attack_dir, armour_penetration = 0)
	var/damage_taken = ..()
	if((damage_taken > 0) && !ignore_flat_reduction)
		for(var/obj/item/mecha_parts/mecha_equipment/armor/mech_armor in equip_by_category[MECHA_ARMOR])
			if(!isnull(mech_armor.max_flat_mecha_hp) && (mech_armor.flat_mecha_hp <= 0))
				continue
			var/flat_armor = mech_armor.flat_armor?.get_rating(damage_flag)
			if(!flat_armor)
				continue
			damage_taken = max(0, damage_taken - (flat_armor * max(0, 100 - armour_penetration)/100))
	return damage_taken
