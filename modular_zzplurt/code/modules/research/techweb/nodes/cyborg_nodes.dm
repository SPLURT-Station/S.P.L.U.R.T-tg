
/datum/techweb_node/passive_implants/New()
	var/list/extra_designs = list(
		"implant_gfluid",
	)
	LAZYADD(design_ids, extra_designs)
	. = ..()

/datum/techweb_node/cyber/cyber_organs_upgraded/New()
	var/list/extra_designs = list(
		"cybernetic_brain_cortical"
	)
	LAZYADD(design_ids, extra_designs)
	. = ..()
