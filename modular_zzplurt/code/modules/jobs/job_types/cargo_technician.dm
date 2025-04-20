/datum/job/cargo_technician/New()
	. = ..()
	liver_traits ||= list()
	liver_traits |= TRAIT_CARGO_METABOLISM
