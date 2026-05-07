/mob/living/carbon/human/species/monkey/Initialize(mapload, mob/spawner)
	/* On initialisation, TRAIT_BORN_MONKEY is added to the monkey. In response, we append a proc that checks for the trait and removes it.
	We do this because TRAIT_BORN_MONKEY is only used to stop mutadone from affecting natural monkeys, but we want it to do that.
	This sucks, and I hate it, but it works and it's the only way I'm aware of to do this modularly. */
	. = ..()
	if(HAS_TRAIT(src, TRAIT_BORN_MONKEY))
		REMOVE_TRAIT(src, TRAIT_BORN_MONKEY, INNATE_TRAIT)
