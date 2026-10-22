/datum/quirk/phobia
	// Override icon
	icon = FA_ICON_SPAGHETTI_MONSTER_FLYING

/datum/quirk_constant_data/phobia
	customization_options = list(
		/datum/preference/choiced/phobia,
		/datum/preference/choiced/phobia/secondary,
		/datum/preference/choiced/phobia/tertiary,
	)

/datum/quirk/phobia/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/list/selected_phobias = list()
	for(var/pref_type in list(/datum/preference/choiced/phobia, /datum/preference/choiced/phobia/secondary, /datum/preference/choiced/phobia/tertiary))
		var/phobia = client_source?.prefs.read_preference(pref_type)
		if(!phobia || phobia == "none" || (phobia in selected_phobias))
			continue
		selected_phobias += phobia
		human_holder.gain_trauma(new /datum/brain_trauma/mild/phobia(phobia), TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/phobia/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/organ/brain/brain = human_holder.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!brain)
		return
	for(var/datum/brain_trauma/mild/phobia/phobia_trauma in brain.get_traumas_type(/datum/brain_trauma/mild/phobia, TRAUMA_RESILIENCE_ABSOLUTE))
		qdel(phobia_trauma)

/obj/item/organ/brain/can_gain_trauma(datum/brain_trauma/trauma, resilience, natural_gain = FALSE)
	if(istype(trauma, /datum/brain_trauma/mild/phobia))
		if(HAS_TRAIT(src, TRAIT_BRAIN_TRAUMA_IMMUNITY))
			return FALSE
		var/datum/brain_trauma/mild/phobia/new_phobia = trauma
		for(var/datum/brain_trauma/mild/phobia/existing_phobia in traumas)
			if(existing_phobia.phobia_type == new_phobia.phobia_type)
				return FALSE
		return TRUE
	return ..()

/datum/preference/choiced/phobia/secondary
	savefile_key = "secondary_phobia"

/datum/preference/choiced/phobia/secondary/init_possible_values()
	return list("none") + GLOB.phobia_types

/datum/preference/choiced/phobia/secondary/create_default_value()
	return "none"

/datum/preference/choiced/phobia/tertiary
	savefile_key = "tertiary_phobia"

/datum/preference/choiced/phobia/tertiary/init_possible_values()
	return list("none") + GLOB.phobia_types

/datum/preference/choiced/phobia/tertiary/create_default_value()
	return "none"
