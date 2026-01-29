/datum/species/xeno
	mutant_organs = list(
		/obj/item/organ/alien/plasmavessel/roundstart,
		/obj/item/organ/alien/resinspinner,
		)
/datum/species/xeno/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "Sun",
		SPECIES_PERK_NAME = "Heat Sensitive",
		SPECIES_PERK_DESC = "Much like their feral ancestors, Xenomorph Hybrids are hypersensitive to heat and burn damage."
	))
	return to_add
