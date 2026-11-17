/datum/techweb_node/riot_supression/New()
	design_ids += "m9x17mm_mag"
	design_ids += "m9x17mm_mag_rubber"
	design_ids += "m9x17mm_mag_ihdf"
	design_ids += "m9x17mm_mag_hp"
	design_ids += "m9x17mm_mag_ap"
	design_ids += "m9x17mm_pmag_hp"
	design_ids += "m9x17mm_pmag_ap"
	design_ids += "rt45c"
	design_ids += "rt45c_hv"
	. = ..()

/datum/techweb_node/ballistic/New()
	design_ids += "wt458_kit"
	. = ..()

/datum/techweb_node/basic_arms/New()
	design_ids -= "m9mm_sec_speedloader"
	design_ids -= "m9mm_sec"
	. = ..()

/datum/techweb_node/syndicate_basic/New()
	design_ids += "rt45c_hv_sl"
	design_ids += "rt45c_sl"
	. = ..()
