/obj/vehicle/sealed/mecha/ui_data(mob/user)
	var/list/data = ..()
	data["initial_slowdown"] = initial(movedelay)
	data["current_slowdown"] = movedelay
	//first plate that isnt broken takes the dibs for showing on the left side of the UI
	for(var/obj/item/mecha_parts/mecha_equipment/armor/armor in equip_by_category[MECHA_ARMOR])
		if(isnull(armor.max_mecha_hp) || (armor.mecha_hp <= 0))
			continue
		data["armor_integrity"] = armor.mecha_hp
		data["armor_integrity_max"] = armor.max_mecha_hp
		data["armor_name"] = armor.name
	//if none of the plates are good, take the first one IG
	if(!data["armor_name"])
		for(var/obj/item/mecha_parts/mecha_equipment/armor/armor in equip_by_category[MECHA_ARMOR])
			if(isnull(armor.max_mecha_hp))
				continue
			data["armor_integrity"] = armor.mecha_hp
			data["armor_integrity_max"] = armor.max_mecha_hp
			data["armor_name"] = armor.name
			break
	return data
