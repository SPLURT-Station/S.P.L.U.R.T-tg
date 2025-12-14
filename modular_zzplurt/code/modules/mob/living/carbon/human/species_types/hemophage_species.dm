/**
 * This file was used to edit the Hemophage species.
 * Due to community feedback, it has been disabled.
 * Please do not re-enable this file unless you know what you're doing.
 */

/datum/species/hemophage/New()
	// Remove traits
	inherent_traits -= list(
		TRAIT_NOBREATH,
		TRAIT_VIRUSIMMUNE,
	)

	// Restore lungs
	mutantlungs = /datum/species::mutantlungs

	// Disable veteran restriction
	// /veteran_only = FALSE Veteran cut from the Bubberstation build.

	// Return original
	. = ..()

// Disabled due to community feedback
/*
// Called when a mob gains this species
/datum/species/hemophage/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons = TRUE)
	. = ..()

	// Add profane penalties
	human_who_gained_species.AddElementTrait(TRAIT_CHAPEL_WEAKNESS, SPECIES_HEMOPHAGE, /datum/element/chapel_weakness)
	human_who_gained_species.AddElementTrait(TRAIT_HOLYWATER_WEAKNESS, SPECIES_HEMOPHAGE, /datum/element/holywater_weakness)

// Called when a mob loses this species
/datum/species/hemophage/on_species_loss(mob/living/carbon/human/human_target, datum/species/new_species, pref_load)
	. = ..()

	// Remove profane penalties
	REMOVE_TRAIT(human_target, TRAIT_CHAPEL_WEAKNESS, SPECIES_HEMOPHAGE)
	REMOVE_TRAIT(human_target, TRAIT_HOLYWATER_WEAKNESS, SPECIES_HEMOPHAGE)

// Replace Hemophage bite with Bloodfledge variant
/datum/component/organ_corruption/tongue
	// Replace with new bite type
	tongue_action_type = /datum/action/cooldown/bloodfledge/bite/corrupted_tongue
*/
