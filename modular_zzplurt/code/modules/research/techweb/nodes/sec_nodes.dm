/datum/techweb_node/riot_supression/New()
	unlocked_designs += /datum/design/m9x17mm_mag
	unlocked_designs += /datum/design/m9x17mm_mag_rubber
	unlocked_designs += /datum/design/m9x17mm_mag_ihdf
	unlocked_designs += /datum/design/m9x17mm_mag_hp
	unlocked_designs += /datum/design/m9x17mm_mag_ap
	. = ..()

/datum/techweb_node/ballistic/New()
	unlocked_designs += /datum/design/wt458_kit
	. = ..()
