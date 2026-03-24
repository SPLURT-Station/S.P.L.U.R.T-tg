/datum/techweb_node/augmentation/New()
	var/list/extra_design_ids = list(
		"borg_upgrade_bellyriding_harness",
	)
	LAZYADD(design_ids, extra_design_ids)
	. = ..()
