
/datum/techweb_node/passive_implants/New()
	unlocked_designs += /datum/design/implant_gfluid
	. = ..()

/datum/techweb_node/cyber/cyber_organs_upgraded/New()
	unlocked_designs += /datum/design/cybernetic_brain_cortical
	. = ..()
