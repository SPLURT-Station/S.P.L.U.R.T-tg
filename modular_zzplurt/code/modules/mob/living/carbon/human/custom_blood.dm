// Variables
/datum/species
	var/exotic_blood_color = BLOOD_COLOR_RED

/mob/living/carbon/get_blood_dna_list()
	. = ..()

	if(get_blood_id() != /datum/reagent/blood)
		return

	var/list/result = list()
	result.Insert(1, EXOTIC_BLOOD_COLOR_DNA) // Makes sure it's the first entry, and the rest of the list is after the non-bloodtype entry
	result[EXOTIC_BLOOD_COLOR_DNA] = dna?.species?.exotic_blood_color || BLOOD_COLOR_RED
	LAZYADD(result, .)
	return result

/mob/living/carbon/get_blood_data(blood_id)
	. = ..()
	if(blood_id != /datum/reagent/blood)
		return
	.["bloodcolor"] = dna.species.exotic_blood_color || BLOOD_COLOR_RED
