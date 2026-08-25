/datum/dna
	var/last_capped_size //For some reason this feels dirty... I suppose it should go somewhere else

/mob/living/carbon/human/hardset_dna(unique_identity, list/mutation_index, list/default_mutation_genes, newreal_name, newblood_type, datum/species/mrace, newfeatures, list/mutations, force_transfer_mutations)
	. = ..()
	// Body size lives on the mob (current_size), not DNA features anymore.
	adjust_mobsize(get_size(src))

/datum/dna/copy_dna(datum/dna/new_dna)
	. = ..()
	if(holder)
		holder.adjust_mobsize(get_size(holder))

/mob/living/carbon/set_species(datum/species/mrace, icon_update, pref_load, replace_missing, list/override_features, list/override_mutantparts, list/override_markings)
	. = ..()
	adjust_mobsize(get_size(src))

/datum/preference/choiced/species/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	. = ..()
	target.adjust_mobsize(get_size(target))
