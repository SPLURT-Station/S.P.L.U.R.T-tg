/datum/techweb_node/bio_scan/New()
	var/list/extra_designs = list(
		"sex_research"
	)
	LAZYADD(design_ids, extra_designs)
	. = ..()
