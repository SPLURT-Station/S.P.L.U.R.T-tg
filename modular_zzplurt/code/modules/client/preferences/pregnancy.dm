// Abstract types to cut down on copypasta

/datum/preference/numeric/pregnancy
	abstract_type = /datum/preference/numeric/pregnancy

/datum/preference/numeric/pregnancy/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	if(CONFIG_GET(flag/disable_erp_preferences))
		return FALSE

	return preferences.read_preference(/datum/preference/toggle/master_erp_preferences)

/datum/preference/numeric/pregnancy/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/toggle/pregnancy
	abstract_type = /datum/preference/toggle/pregnancy

/datum/preference/toggle/pregnancy/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	if(CONFIG_GET(flag/disable_erp_preferences))
		return FALSE

	return preferences.read_preference(/datum/preference/toggle/master_erp_preferences)

/datum/preference/toggle/pregnancy/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced/pregnancy
	abstract_type = /datum/preference/choiced/pregnancy

/datum/preference/choiced/pregnancy/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	if(CONFIG_GET(flag/disable_erp_preferences))
		return FALSE

	return preferences.read_preference(/datum/preference/toggle/master_erp_preferences)

/datum/preference/choiced/pregnancy/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/// Chance to get pregnant when someone climaxes inside you, simple stuff
/datum/preference/numeric/pregnancy/chance
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "pregnancy_chance"
	minimum = PREGNANCY_CHANCE_MINIMUM
	maximum = PREGNANCY_CHANCE_MAXIMUM

/datum/preference/numeric/pregnancy/chance/create_default_value()
	return PREGNANCY_CHANCE_DEFAULT

/// Pregnancy duration in minutes
/datum/preference/numeric/pregnancy/duration
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "pregnancy_duration"
	minimum = PREGNANCY_DURATION_MINIMUM
	maximum = PREGNANCY_DURATION_MAXIMUM

/datum/preference/numeric/pregnancy/duration/create_default_value()
	return PREGNANCY_DURATION_DEFAULT

/// If enabled, health analyzers will not show that you are a pregnancy - No relation to cryptocurrencies
/datum/preference/toggle/pregnancy/cryptic
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "pregnancy_cryptic"
	default_value = FALSE

/// If enabled, eggs from pregnancy will be inert
/datum/preference/toggle/pregnancy/inert
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "pregnancy_inert"
	default_value = TRUE

/// If enabled, pregnancy makes your belly become bigger
/datum/preference/toggle/pregnancy/belly_inflation
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "pregnancy_belly_inflation"
	default_value = TRUE

/// If enabled, the vagina is a valid organ for insemination
/datum/preference/toggle/pregnancy/vaginal_insemination
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "pregnancy_insemination_vagina"
	default_value = TRUE

/// If enabled, the anus is a valid organ for insemination
/datum/preference/toggle/pregnancy/anal_insemination
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "pregnancy_insemination_anus"
	default_value = FALSE

/// If enabled, the mouth is a valid organ for insemination
/datum/preference/toggle/pregnancy/oral_insemination
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "pregnancy_insemination_mouth"
	default_value = FALSE

/// Type of egg used for oviposition
/datum/preference/choiced/pregnancy/egg_skin
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "pregnancy_egg_skin"

/datum/preference/choiced/pregnancy/egg_skin/create_default_value()
	return GLOB.pregnancy_egg_skins[GLOB.pregnancy_egg_skins.Find("Chicken") || 1]

/datum/preference/choiced/pregnancy/egg_skin/init_possible_values()
	return assoc_to_keys(GLOB.pregnancy_egg_skins)
