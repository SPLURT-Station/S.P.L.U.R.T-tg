/datum/techweb_node/biotech/New()
	var/list/extra_designs = list(
		"sex_research"
	)
	LAZYADD(design_ids, extra_designs)
	. = ..()
