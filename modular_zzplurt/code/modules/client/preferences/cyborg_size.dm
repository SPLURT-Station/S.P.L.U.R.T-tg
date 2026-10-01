/datum/preference/numeric/cyborg_size
	category = PREFERENCE_CATEGORY_SILICON_PREFS
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "cyborg_size"
	should_update_preview = FALSE
	minimum = 70
	maximum = 250

/datum/preference/numeric/cyborg_size/create_default_value()
	return 100

/datum/preference/numeric/cyborg_size/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return
