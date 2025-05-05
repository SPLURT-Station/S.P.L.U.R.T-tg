/obj/vehicle/sealed/mecha/ui_data(mob/user)
	var/list/data = ..()
	//first plate that isnt broken takes the dibs for showing on the left side of the UI
	for(var/obj/item/mecha_parts/mecha_equipment/armor/armor in equip_by_category[MECHA_ARMOR])
		if(isnull(armor.max_flat_mecha_hp) || (armor.flat_mecha_hp <= 0))
			continue
		data["flat_armor_integrity"] = armor.flat_mecha_hp
		data["flat_armor_integrity_max"] = armor.max_flat_mecha_hp
		data["flat_armor_name"] = armor.name
	//if none of the plates are good, take the first one IG
	if(!data["flat_armor_name"])
		for(var/obj/item/mecha_parts/mecha_equipment/armor/armor in equip_by_category[MECHA_ARMOR])
			if(isnull(armor.max_flat_mecha_hp))
				continue
			data["flat_armor_integrity"] = armor.flat_mecha_hp
			data["flat_armor_integrity_max"] = armor.max_flat_mecha_hp
			data["flat_armor_name"] = armor.name
			break
	return data
