#ifndef TRAIT_PERMA_HARD
#define TRAIT_PERMA_HARD "perma_hard"
#endif

#ifndef TRAIT_PERMA_SOFT
#define TRAIT_PERMA_SOFT "perma_soft"
#endif

GLOBAL_LIST_INIT(perma_arousal_traits_modular, list(
	"TRAIT_PERMA_HARD" = TRAIT_PERMA_HARD,
	"TRAIT_PERMA_SOFT" = TRAIT_PERMA_SOFT,
))

/hook/startup/proc/register_perma_arousal_traits()
	if(isnull(GLOB.traits_by_type[/mob/living/carbon/human]))
		GLOB.traits_by_type[/mob/living/carbon/human] = list()

	for(var/trait_name in GLOB.perma_arousal_traits_modular)
		GLOB.traits_by_type[/mob/living/carbon/human][trait_name] = GLOB.perma_arousal_traits_modular[trait_name]
