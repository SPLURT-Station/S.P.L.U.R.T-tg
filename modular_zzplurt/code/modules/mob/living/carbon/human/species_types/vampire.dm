/datum/species/human/vampire/New()
	var/list/extra_inherent_traits = list(
		TRAIT_NOTHIRST
	)
	LAZYADD(inherent_traits, extra_inherent_traits)
	. = ..()
