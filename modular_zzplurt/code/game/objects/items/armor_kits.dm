/obj/item/armorkit
	name = "rampart armor kit"
	desc = "A standard Nanotrasen security nanite armoring kit, for reinforcing outerwear."
	icon = 'modular_zzplurt/icons/obj/reinforcekits.dmi'
	icon_state = "sec_armor_kit"
	w_class = WEIGHT_CLASS_SMALL

	var/obj/item/clothing/target_armor = /obj/item/clothing/suit/armor/vest/alt/sec // Holds the typepath of the armor.
	var/datum/armor/actual_armor // Holds the real datum of the armor.
	var/target_slot = ITEM_SLOT_OCLOTHING
	var/change_allowed = TRUE
	var/list/target_allowed // = GLOB.security_vest_allowed
	var/target_body_parts_covered = CHEST

	var/armor_text = "standard Nanotrasen security armored vest"
	var/target_prefix = "rampart"

/obj/item/armorkit/Initialize(mapload)
	. = ..()
	var/armor_type = target_armor::armor_type
	if(ispath(armor_type))
		actual_armor = get_armor_by_type(armor_type)
	else
		actual_armor = get_armor_by_type(/datum/armor/none)
	target_allowed = GLOB.security_vest_allowed // You're killing me here.

/obj/item/armorkit/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/used = FALSE

	if(!isobj(interacting_with))
		return NONE

	var/obj/item/target = interacting_with
	var/obj/item/clothing/C = target

	if(!C)
		return NONE

	if(istype(C, /obj/item/clothing/suit/mod) || istype(C, /obj/item/clothing/head/mod))
		to_chat(user, "<span class = 'notice'>You can't reinforce MODsuit parts with [src].</span>")
		return NONE

	if(!(target.slot_flags & target_slot))
		to_chat(user, "<span class = 'notice'>You can't reinforce [target] with [src].</span>")
		return NONE

	var/datum/armor/curr_armor = C.get_armor()

	for(var/curr_stat in ARMOR_LIST_DAMAGE())
		if(curr_armor.get_rating(curr_stat) < actual_armor.get_rating(curr_stat))
			used = TRUE

	if(used)
		if(change_allowed)
			C.allowed = target_allowed
		C.body_parts_covered = target_body_parts_covered
		C.set_armor(actual_armor)
		C.cold_protection = target_armor::cold_protection
		C.min_cold_protection_temperature = target_armor::min_cold_protection_temperature
		C.heat_protection = target_armor::heat_protection
		C.max_heat_protection_temperature = target_armor::max_heat_protection_temperature
		C.max_integrity = target_armor::max_integrity
		C.resistance_flags = target_armor::resistance_flags
		user.visible_message("<span class = 'notice'>[user] reinforces [C] with [src].</span>", \
		"<span class = 'notice'>You reinforce [C] with [src], making it as protective as \a [armor_text].</span>")
		C.name = "[target_prefix] [C.name]"
		qdel(src)
		return ITEM_INTERACT_SUCCESS

	to_chat(user, "<span class = 'notice'>You don't need to reinforce [C] any further.")
	return NONE

/obj/item/armorkit/helmet
	name = "rampart headgear kit"
	desc = "A standard Nanotrasen security nanite armoring kit, for reinforcing hats or other headgear."
	icon_state = "sec_helmet_kit"

	target_armor = /obj/item/clothing/head/helmet
	target_slot = ITEM_SLOT_HEAD
	change_allowed = FALSE
	target_body_parts_covered = HEAD
	// target_allowed = GLOB.security_vest_allowed

	armor_text = "standard Nanotrasen security helmet"
	// target_prefix = "rampart"

/obj/item/armorkit/blueshield
	name = "aegis armor kit"
	desc = "An elite Nanotrasen nanite armoring kit, for reinforcing outerwear."
	icon_state = "blueshield_armor_kit"

	target_armor = /obj/item/clothing/suit/armor/vest/blueshield
	// target_slot = ITEM_SLOT_OCLOTHING
	// change_allowed = TRUE
	// target_allowed = GLOB.security_vest_allowed

	armor_text = "elite Nanotrasen blueshield armored vest"
	target_prefix = "aegis"

/obj/item/armorkit/helmet/blueshield
	name = "aegis headgear kit"
	desc = "An elite Nanotrasen security nanite armoring kit, for reinforcing hats or other headgear."
	icon_state = "blueshield_helmet_kit"

	target_armor = /obj/item/clothing/head/beret/blueshield
	// target_slot = ITEM_SLOT_HEAD
	// change_allowed = FALSE
	// target_allowed = GLOB.security_vest_allowed

	armor_text = "elite Nanotrasen blueshield helmet"
	target_prefix = "aegis"
