/datum/techweb_node/riot_supression/New()
	unlocked_designs += "m9x17mm_mag"
	unlocked_designs += "m9x17mm_mag_rubber"
	unlocked_designs += "m9x17mm_mag_ihdf"
	unlocked_designs += "m9x17mm_mag_hp"
	unlocked_designs += "m9x17mm_mag_ap"
	unlocked_designs += "m9x17mm_pmag_hp"
	unlocked_designs += "m9x17mm_pmag_ap"
	unlocked_designs += "rt45c"
	unlocked_designs += "rt45c_hv"
	. = ..()

/datum/techweb_node/ballistic/New()
	unlocked_designs += /datum/design/wt458_kit
	. = ..()

/datum/techweb_node/basic_arms/New()
	unlocked_designs -= "m9mm_sec_speedloader"
	unlocked_designs -= "m9mm_sec"
	. = ..()

/datum/techweb_node/syndicate_basic/New()
	unlocked_designs += "rt45c_hv_sl"
	unlocked_designs += "rt45c_sl"
	. = ..()
