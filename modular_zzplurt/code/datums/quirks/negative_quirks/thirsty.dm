/datum/quirk/thirsty
	name = "Thirsty"
	desc = "You become thirsty twice as quickly. Make sure to drink plenty of fluids!"
	value = -2
	gain_text = span_danger("You're beginning to feel parched again.")
	lose_text = span_notice("Your elevated craving for water begins dying down.")
	medical_record_text = "Patient's body is half as effective at retaining liquids, necessitating drinking twice as many liquids per day than usual for their species."
	mob_trait = TRAIT_THIRSTY
	hardcore_value = 1
	species_blacklist = list(SPECIES_SYNTH, SPECIES_PROTEAN) //Splurt Edit
	icon = FA_ICON_GLASS_WATER
	mail_goodies = list (
		/obj/item/reagent_containers/cup/glass/waterbottle = 1
	)


/datum/quirk/thirsty/add(client/client_source)
	// Define quirk mob
	var/mob/living/carbon/human/H = quirk_holder

	// Set hunger multiplier
	if(istype(H))
		H.physiology?.thirst_mod *= 2

/datum/quirk/thirsty/remove()
	// Define quirk mob
	var/mob/living/carbon/human/H = quirk_holder

	// Revert hunger multiplier
	if(istype(H))
		H.physiology?.thirst_mod /= 2

