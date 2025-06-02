/datum/techweb_node/hud/New()
	var/list/extra_design_ids = list(
		"nifsoft_storage_concealment",
		"nifsoft_rapid_disrobe",
		"nifsoft_gfluid",
	)
	LAZYADD(design_ids, extra_design_ids)
	. = ..()
