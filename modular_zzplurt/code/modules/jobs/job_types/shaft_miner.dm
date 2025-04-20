/datum/job/shaft_miner/New()
	. = ..()
	liver_traits ||= list()
	liver_traits |= TRAIT_CARGO_METABOLISM
