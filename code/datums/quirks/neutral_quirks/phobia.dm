/datum/quirk/phobia
	name = "Phobia"
	desc = "You are irrationally afraid of something."
	icon = FA_ICON_SPIDER
	value = 0
	medical_record_text = "Patient has an irrational fear of something."
	mail_goodies = list(/obj/item/clothing/glasses/blindfold, /obj/item/storage/pill_bottle/psicodine)
	/// Brain traumas added by this quirk so they can all be removed cleanly
	var/list/datum/brain_trauma/mild/phobia/applied_phobias

/datum/quirk_constant_data/phobia
	associated_typepath = /datum/quirk/phobia
	customization_options = list(
		/datum/preference/choiced/phobia,
		/datum/preference/choiced/secondary_phobia,
		/datum/preference/choiced/tertiary_phobia,
	)

// Phobia will follow you between transfers
/datum/quirk/phobia/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/list/selected_phobias = list()

	var/primary = client_source?.prefs.read_preference(/datum/preference/choiced/phobia)
	if(primary)
		selected_phobias |= primary

	var/secondary = client_source?.prefs.read_preference(/datum/preference/choiced/secondary_phobia)
	if(secondary && secondary != "None")
		selected_phobias |= secondary

	var/tertiary = client_source?.prefs.read_preference(/datum/preference/choiced/tertiary_phobia)
	if(tertiary && tertiary != "None")
		selected_phobias |= tertiary

	for(var/phobia_choice in selected_phobias)
		var/datum/brain_trauma/mild/phobia/new_trauma = new(phobia_choice)
		if(human_holder.gain_trauma(new_trauma, TRAUMA_RESILIENCE_ABSOLUTE))
			LAZYADD(applied_phobias, new_trauma)
		else
			qdel(new_trauma)

/datum/quirk/phobia/remove()
	QDEL_LIST(applied_phobias)
