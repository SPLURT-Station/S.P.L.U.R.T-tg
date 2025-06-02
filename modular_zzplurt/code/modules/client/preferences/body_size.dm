/datum/preference/toggle/scaled_appearance
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "scaled_appearance"
	default_value = FALSE

/datum/preference/toggle/scaled_appearance/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.fuzzy = value
	target.regenerate_icons()
