/datum/preference/choiced/phobia
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "phobia"
	savefile_identifier = PREFERENCE_CHARACTER
	should_update_preview = FALSE

/datum/preference/choiced/phobia/init_possible_values()
	return GLOB.phobia_types

/datum/preference/choiced/phobia/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return /datum/quirk/phobia::name in preferences.all_quirks

/datum/preference/choiced/phobia/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/choiced/secondary_phobia
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "secondary_phobia"
	savefile_identifier = PREFERENCE_CHARACTER
	should_update_preview = FALSE

/datum/preference/choiced/secondary_phobia/init_possible_values()
	return list("None") + GLOB.phobia_types

/datum/preference/choiced/secondary_phobia/create_default_value()
	return "None"

/datum/preference/choiced/secondary_phobia/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return /datum/quirk/phobia::name in preferences.all_quirks

/datum/preference/choiced/secondary_phobia/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/choiced/tertiary_phobia
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "tertiary_phobia"
	savefile_identifier = PREFERENCE_CHARACTER
	should_update_preview = FALSE

/datum/preference/choiced/tertiary_phobia/init_possible_values()
	return list("None") + GLOB.phobia_types

/datum/preference/choiced/tertiary_phobia/create_default_value()
	return "None"

/datum/preference/choiced/tertiary_phobia/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return /datum/quirk/phobia::name in preferences.all_quirks

/datum/preference/choiced/tertiary_phobia/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return
