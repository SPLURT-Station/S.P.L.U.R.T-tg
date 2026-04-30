/datum/species/slugcat/
	name = "Slugcat"
	id = "SPECIES_SLUGCAT"
	sexes = TRUE
	plural_form = "Slugcats"
	meat = obj/item/food/meat/slab/human/mutant/slugcat
	inherent_traits = list(
		TRAIT_AMPHIBIOUS,
		TRAIT_EASILY_WOUNDED,
		TRAIT_WET_FOR_LONGER,
		TRAIT_HATED_BY_DOGS,
		TRAIT_HIGH_VALUE_RANSOM, //slugcats are rare in EROS, unless they get popular.
		TRAIT_FERAL_BITER,
		TRAIT_THROWINGARMS,
		TRAIT_LIGHT_DRINKER,
		TRAIT_SKITTISH,
		TRAIT_CATLIKE_GRACE,

	)
	//they are wet rodents that bite and throw at you and clean pipes.

/datum/species/proc/get_species_lore()
	SHOULD_CALL_PARENT(FALSE)
	RETURN_TYPE(/list)

	//stack_trace("Species [name] ([type]) did not have lore set, and is a selectable roundstart race! Override get_species_lore.") // SKYRAT EDIT REMOVAL
	return list("No species lore set, file a bug report!")
// to be continued. *sniff
