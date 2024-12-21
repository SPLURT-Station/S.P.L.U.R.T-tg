/datum/preference/choiced/erp_status_extm
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "erp_status_pref_extm"

/datum/preference/choiced/erp_status_extm/init_possible_values()
	return list("Yes - Switch", "Yes - Dom", "Yes - Sub", "Yes", "Ask (L)OOC", "Check OOC Notes", "No")

/datum/preference/choiced/erp_status_extm/create_default_value()
	return "No"

/datum/preference/choiced/erp_status_extm/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	if(CONFIG_GET(flag/disable_erp_preferences))
		return FALSE

	return preferences.read_preference(/datum/preference/toggle/master_erp_preferences)

/datum/preference/choiced/erp_status_extm/deserialize(input, datum/preferences/preferences)
	if(CONFIG_GET(flag/disable_erp_preferences))
		return "No"
	if(!preferences.read_preference(/datum/preference/toggle/master_erp_preferences))
		return "No"
	. = ..()

/datum/preference/choiced/erp_status_extm/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced/erp_status_extmharm
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "erp_status_pref_extmharm"

/datum/preference/choiced/erp_status_extmharm/init_possible_values()
	return list("Yes - Switch", "Yes - Dom", "Yes - Sub", "Yes", "Ask (L)OOC", "Check OOC Notes", "No")

/datum/preference/choiced/erp_status_extmharm/create_default_value()
	return "No"

/datum/preference/choiced/erp_status_extmharm/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	if(CONFIG_GET(flag/disable_erp_preferences))
		return FALSE

	return preferences.read_preference(/datum/preference/toggle/master_erp_preferences)

/datum/preference/choiced/erp_status_extmharm/deserialize(input, datum/preferences/preferences)
	if(CONFIG_GET(flag/disable_erp_preferences))
		return "No"
	if(!preferences.read_preference(/datum/preference/toggle/master_erp_preferences))
		return "No"
	. = ..()

/datum/preference/choiced/erp_status_extmharm/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE
