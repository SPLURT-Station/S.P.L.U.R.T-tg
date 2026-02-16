/datum/blood_type/avali
	name = BLOOD_TYPE_AVALI
	dna_string = "Avali DNA"
	color = /datum/reagent/consumable/ammonia_blood::color
	reagent_type = /datum/reagent/consumable/ammonia_blood

/datum/reagent/consumable/ammonia_blood
	name = "Ammonia-Based Blood"
	description = "The blood of Avali, allowing them to operate under extreme cold conditions."
	nutriment_factor = 5
	color = "#1094ff"
	taste_description = "nothing can be more bitter than this."
	chemical_flags = REAGENT_BLOOD_REGENERATING
