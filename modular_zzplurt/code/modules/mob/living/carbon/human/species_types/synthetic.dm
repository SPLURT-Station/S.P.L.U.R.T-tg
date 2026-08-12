/datum/species/synthetic
	mutantbladder = /obj/item/organ/bladder/cybernetic

/datum/species/synthetic/New()
	var/list/extra_inherent_traits = list(
		TRAIT_NOTHIRST
	)
	LAZYADD(inherent_traits, extra_inherent_traits)
	. = ..()

/obj/item/organ/brain/synth/Initialize(mapload) //speech bubble addition
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "machine", BUBBLE_ICON_PRIORITY_ORGAN)
