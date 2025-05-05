/datum/techweb_node/mech_assembly/New()
	. = ..()
	design_ids |= "mech_armor_basic"

/datum/techweb_node/mech_light/New()
	. = ..()
	design_ids |= "mech_armor_light"

/datum/techweb_node/mech_assault/New()
	. = ..()
	design_ids |= "mech_armor_medium"

/datum/techweb_node/mech_heavy/New()
	. = ..()
	design_ids |= "mech_armor_heavy"
