/datum/techweb_node/mech_assembly/New()
	. = ..()
	design_ids |= "mech_armor_basic"

/datum/techweb_node/mech_combat/New()
	. = ..()
	design_ids |= "mech_armor_light"
	design_ids |= "mech_armor_heavy"
