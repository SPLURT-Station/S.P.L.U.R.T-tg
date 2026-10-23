#define PHOBIA_NONE "None"

/datum/preference/choiced/phobia/secondary
	savefile_key = "secondary_phobia"
	can_randomize = FALSE

/datum/preference/choiced/phobia/secondary/init_possible_values()
	return list(PHOBIA_NONE) + GLOB.phobia_types

/datum/preference/choiced/phobia/secondary/create_default_value()
	return PHOBIA_NONE

/datum/preference/choiced/phobia/tertiary
	savefile_key = "tertiary_phobia"
	can_randomize = FALSE

/datum/preference/choiced/phobia/tertiary/init_possible_values()
	return list(PHOBIA_NONE) + GLOB.phobia_types

/datum/preference/choiced/phobia/tertiary/create_default_value()
	return PHOBIA_NONE

/obj/item/organ/brain/can_gain_trauma(datum/brain_trauma/trauma, resilience, natural_gain = FALSE)
	if(!ispath(trauma, /datum/brain_trauma/mild/phobia) && !istype(trauma, /datum/brain_trauma/mild/phobia))
		return ..()
	if(HAS_TRAIT(src, TRAIT_BRAIN_TRAUMA_IMMUNITY))
		return FALSE

	var/datum/brain_trauma/mild/phobia/trauma_path = trauma
	var/target_phobia_type
	if(ispath(trauma))
		target_phobia_type = initial(trauma_path.phobia_type)
	else
		target_phobia_type = trauma_path.phobia_type
		trauma_path = trauma.type

	if(!initial(trauma_path.can_gain))
		return FALSE
	if(!resilience)
		resilience = initial(trauma_path.resilience)

	var/resilience_tier_count = 0
	for(var/X in traumas)
		if(istype(X, /datum/brain_trauma/mild/phobia))
			var/datum/brain_trauma/mild/phobia/existing_phobia = X
			if(!target_phobia_type || existing_phobia.phobia_type == target_phobia_type)
				return FALSE
		var/datum/brain_trauma/T = X
		if(resilience == T.resilience)
			resilience_tier_count++

	var/max_traumas
	switch(resilience)
		if(TRAUMA_RESILIENCE_BASIC)
			max_traumas = TRAUMA_LIMIT_BASIC
		if(TRAUMA_RESILIENCE_SURGERY)
			max_traumas = TRAUMA_LIMIT_SURGERY
		if(TRAUMA_RESILIENCE_WOUND)
			max_traumas = TRAUMA_LIMIT_WOUND
		if(TRAUMA_RESILIENCE_LOBOTOMY)
			max_traumas = TRAUMA_LIMIT_LOBOTOMY
		if(TRAUMA_RESILIENCE_MAGIC)
			max_traumas = TRAUMA_LIMIT_MAGIC
		if(TRAUMA_RESILIENCE_ABSOLUTE)
			max_traumas = TRAUMA_LIMIT_ABSOLUTE

	if(natural_gain && resilience_tier_count >= max_traumas)
		return FALSE
	return TRUE

/datum/quirk/phobia
	icon = FA_ICON_SPAGHETTI_MONSTER_FLYING

/datum/quirk_constant_data/phobia
	customization_options = list(
		/datum/preference/choiced/phobia,
		/datum/preference/choiced/phobia/secondary,
		/datum/preference/choiced/phobia/tertiary,
	)

/datum/quirk/phobia/add(client/client_source)
	var/phobia = client_source?.prefs.read_preference(/datum/preference/choiced/phobia)
	if(!phobia)
		return

	var/list/phobias_to_add = list(phobia)
	var/secondary_phobia = client_source?.prefs.read_preference(/datum/preference/choiced/phobia/secondary)
	if(secondary_phobia && secondary_phobia != PHOBIA_NONE)
		phobias_to_add |= secondary_phobia
	var/tertiary_phobia = client_source?.prefs.read_preference(/datum/preference/choiced/phobia/tertiary)
	if(tertiary_phobia && tertiary_phobia != PHOBIA_NONE)
		phobias_to_add |= tertiary_phobia

	var/mob/living/carbon/human/human_holder = quirk_holder
	for(var/phobia_name in phobias_to_add)
		human_holder.gain_trauma(new /datum/brain_trauma/mild/phobia(phobia_name), TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/phobia/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	while(human_holder.has_trauma_type(/datum/brain_trauma/mild/phobia, TRAUMA_RESILIENCE_ABSOLUTE))
		human_holder.cure_trauma_type(/datum/brain_trauma/mild/phobia, TRAUMA_RESILIENCE_ABSOLUTE)

#undef PHOBIA_NONE
