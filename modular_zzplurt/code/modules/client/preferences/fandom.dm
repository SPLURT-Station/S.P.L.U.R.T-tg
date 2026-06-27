/datum/preference/choiced/fandom
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "fandom"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/fandom/create_default_value()
	return "Clown"

/datum/preference/choiced/fandom/init_possible_values()
	return GLOB.fandom_choices.Copy()

/datum/preference/choiced/fandom/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE

	return "Partisan Ideologue" in preferences.all_quirks

/datum/preference/choiced/fandom/apply_to_human(mob/living/carbon/human/target, value)
	return
