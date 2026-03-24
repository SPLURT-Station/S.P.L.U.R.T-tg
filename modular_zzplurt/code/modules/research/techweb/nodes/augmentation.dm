/datum/techweb_node/augmentation/New()
	. = ..()
	design_ids -= list(
		"borg_upgrade_expand",
		"borg_upgrade_shrink"
	)
	design_ids += list(
		"borg_upgrade_resize",
		"borg_upgrade_bellyriding_harness",
	)
