#define MECHA_SNOWFLAKE_ID_ARMOR "armor_snowflake"

/obj/item/mecha_parts/mecha_equipment/armor
	applied_slowdown = 1.175
	/// Max health points inside the mecha, when null it will apply damage reduction regardless
	var/max_flat_mecha_hp
	/// Current health points inside a mecha for purposes of flat damage reduction, when it reaches 0, no more damage reduction
	var/flat_mecha_hp
	/// Basically flat damage reduction that gets applied after the mech's normal armor datum does it's thing
	var/datum/armor/flat_armor

/datum/armor/flat_mecha_armor
	acid = 0
	bio = 0
	bomb = 0
	bullet = 0
	consume = 0
	energy = 0
	laser = 0
	fire = 0
	melee = 0
	wound = 0

/obj/item/mecha_parts/mecha_equipment/armor/Initialize(mapload)
	. = ..()
	if(flat_armor)
		flat_armor = get_armor_by_type(flat_armor)
	flat_mecha_hp = max_flat_mecha_hp

/obj/item/mecha_parts/mecha_equipment/armor/Destroy()
	. = ..()
	flat_armor = null

/obj/item/mecha_parts/mecha_equipment/armor/examine(mob/user)
	. = ..()
	. += span_notice("[EXAMINE_HINT("Examine more")] to inspect armor values applied to mechs...")
	if(flat_armor)
		if(!isnull(max_flat_mecha_hp))
			switch(flat_mecha_hp / max_flat_mecha_hp)
				if(1 to INFINITY)
					. += span_notice("[p_Theyre()] in perfect condition.")
				if(0.75 to 1)
					. += span_notice("[p_Theyre()] in good condition.")
				if(0.5 to 0.75)
					. += span_warning("[p_Theyre()] in average condition.")
				if(0.25 to 0.5)
					. += span_warning("[p_Theyre()] in bad condition.")
				if(0 to 0.25)
					. += span_danger("[p_Theyre()] falling apart!")
				if(-INFINITY to 0)
					. += span_danger("[p_Theyre()] fractured and will no longer protect mechs!")

/obj/item/mecha_parts/mecha_equipment/armor/examine_more(mob/user)
	. = ..()
	var/list/readout = list()

	var/added_damage_header = FALSE
	if(armor_mod)
		var/datum/armor/armor_mod = get_armor_by_type(src.armor_mod)
		added_damage_header = FALSE
		for(var/damage_key in ARMOR_LIST_DAMAGE())
			var/rating = armor_mod.get_rating(damage_key)
			if(!rating)
				continue
			if(!added_damage_header)
				readout += "<b><u>MULTIPLICATIVE ARMOR (I-X)</u></b>"
				added_damage_header = TRUE
			readout += "[armor_to_protection_name(damage_key)] [armor_to_protection_class(rating)]"
	if(flat_armor)
		added_damage_header = FALSE
		for(var/damage_key in ARMOR_LIST_DAMAGE())
			var/rating = flat_armor.get_rating(damage_key)
			if(!rating)
				continue
			if(!added_damage_header)
				readout += "<b><u>FLAT ARMOR (I-X)</u></b>"
				added_damage_header = TRUE
			readout += "[armor_to_protection_name(damage_key)] [armor_to_protection_class(rating)]"

	var/added_durability_header = FALSE
	if(armor_mod)
		var/datum/armor/armor_mod = get_armor_by_type(src.armor_mod)
		added_durability_header = FALSE
		for(var/durability_key in ARMOR_LIST_DURABILITY())
			var/rating = armor_mod.get_rating(durability_key)
			if(!rating)
				continue
			if(!added_durability_header)
				readout += "<b><u>MULTIPLICATIVE DURABILITY (I-X)</u></b>"
				added_durability_header = TRUE
			readout += "[armor_to_protection_name(durability_key)] [armor_to_protection_class(rating)]"
	if(flat_armor)
		added_durability_header = FALSE
		for(var/durability_key in ARMOR_LIST_DURABILITY())
			var/rating = flat_armor.get_rating(durability_key)
			if(!rating)
				continue
			if(!added_durability_header)
				readout += "<b><u>FLAT DURABILITY (I-X)</u></b>"
				added_durability_header = TRUE
			readout += "[armor_to_protection_name(durability_key)] [armor_to_protection_class(rating)]"

	if(!length(readout))
		readout += "No armor or durability information available."

	var/formatted_readout = span_notice("<b>PROTECTION CLASSES</b><hr>[jointext(readout, "\n")]")
	. += boxed_message(formatted_readout)

/obj/item/mecha_parts/mecha_equipment/armor/get_snowflake_data()
	return list(
		"snowflake_id" = MECHA_SNOWFLAKE_ID_ARMOR,
		"flat_armor_integrity" = flat_mecha_hp,
		"flat_armor_integrity_max" = max_flat_mecha_hp,
	)

/obj/item/mecha_parts/mecha_equipment/armor/basic
	name = "Basic mech armor"
	desc = "Sacrificial plate of metal, designed to increase survivability. Standard issue for civillian grade exosuits."
	icon = 'modular_zzplurt/icons/obj/devices/mecha_equipment.dmi'
	icon_state = "mech_armor_basic"
	iconstate_name = "melee"
	protect_name = "Basic Armor"
	max_flat_mecha_hp = 100
	flat_mecha_hp = 100
	flat_armor = /datum/armor/flat_mecha_armor/basic

/datum/armor/flat_mecha_armor/basic
	bomb = 15
	bullet = 5
	energy = 2
	laser = 3
	melee = 5
