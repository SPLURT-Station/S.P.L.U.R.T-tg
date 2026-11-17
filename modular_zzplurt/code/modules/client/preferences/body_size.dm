/datum/preference/toggle/scaled_appearance
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "scaled_appearance"
	default_value = FALSE

/datum/preference/toggle/scaled_appearance/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.fuzzy = value
	target.regenerate_icons()


/datum/preference/numeric/cyborg_size
	category = PREFERENCE_CATEGORY_SILICON_PREFS
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "cyborg_size"
	should_update_preview = FALSE
	minimum = 0.7
	maximum = 2.5
	step = 0.01

/datum/preference/numeric/cyborg_size/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/numeric/cyborg_size/create_default_value()
	return 1
