/obj/vehicle/sealed/mecha
	internal_damage_probability = 30 //makes internal damage more likely, since armor is more common
	/**
	 * Ignore armor plate damage reduction while set to TRUE, useful in damage code
	 * A bit janky, but adding another argument to run_atom_armor() would be worse IMHO
	 */
	var/ignore_armor_equipment_reduction = FALSE

/datum/armor/sealed_mecha
	melee = 10 //original: 20
	bullet = 5 //original: 10

/obj/vehicle/sealed/mecha/Initialize(mapload, built_manually)
	if(!built_manually && equip_by_category[MECHA_ARMOR] && !length(equip_by_category[MECHA_ARMOR]))
		equip_by_category[MECHA_ARMOR] += /obj/item/mecha_parts/mecha_equipment/armor/basic
	return ..()

/obj/vehicle/sealed/mecha/update_overlays()
	. = ..()
	for(var/obj/item/mecha_parts/mecha_equipment/armor/mech_armor in equip_by_category[MECHA_ARMOR])
		if(!mech_armor.mecha_overlay_icon)
			continue
		var/mutable_appearance/armor_appearance = mutable_appearance(mech_armor.mecha_overlay_icon, icon_state)
		armor_appearance.color = mech_armor.mecha_overlay_color
		if(!isnull(mech_armor.max_mecha_hp) && (mech_armor.mecha_hp <= 0))
			var/mutable_appearance/damage_overlay = mutable_appearance('icons/effects/item_damage.dmi', "itemdamaged")
			damage_overlay.blend_mode = BLEND_INSET_OVERLAY
			armor_appearance.overlays += damage_overlay
		. += armor_appearance
		break

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
