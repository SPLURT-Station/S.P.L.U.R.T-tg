/datum/techweb_node/alien_theory
	id = TECHWEB_NODE_ALIEN_THEORY
	display_name = "Alien Theory"
	description = "Abductors theoretical stock parts."
	prereq_ids = list(TECHWEB_NODE_ALIENTECH, TECHWEB_NODE_PARTS_BLUESPACE)
	design_ids = list(
		"abductor_capacitor",
		"abductor_scanning",
		"abductor_servo",
		"abductor_micro_laser",
		"abductor_matter_bin",
		"abductorbeaker",
		"abductor_cell",
		"abductor_battery",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	discount_experiments = list(/datum/experiment/scanning/points/slime/hard = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)

