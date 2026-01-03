/datum/techweb_node/anti_eldritch
	id = "anti_eldritch"
	display_name = "Anti Eldritch Research"
	description = "In five continents, smiths have whispered the same words to the iron. Murderers have been known to whisper these words, too. And adepts, of course. These words are spoken in ritual to inspire an unmerciful Change."
	prereq_ids = list(TECHWEB_NODE_ANOMALY_RESEARCH)
	design_ids = list(
		"oscula_kit",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SECURITY)
	required_experiments = list(/datum/experiment/scanning/points/anomalies)
