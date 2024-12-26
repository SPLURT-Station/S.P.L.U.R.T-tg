/datum/preferences
	var/list/favorite_interactions

/datum/preference/choiced_list
    var/should_generate_icons = FALSE
    var/list/cached_values
    var/main_feature_name
    abstract_type = /datum/preference/choiced_list

/datum/preference/choiced_list/proc/get_choices()
    SHOULD_NOT_OVERRIDE(TRUE)
    if (isnull(cached_values))
        cached_values = init_possible_values()
        ASSERT(cached_values.len)
    return cached_values

/datum/preference/choiced_list/proc/get_choices_serialized()
    SHOULD_NOT_OVERRIDE(TRUE)
    var/list/serialized_choices = list()
    for (var/choice in get_choices())
        serialized_choices += serialize(choice)
    return serialized_choices

/datum/preference/choiced_list/proc/init_possible_values()
    CRASH("`init_possible_values()` was not implemented for [type]!")

/datum/preference/choiced_list/proc/icon_for(value)
    SHOULD_CALL_PARENT(FALSE)
    SHOULD_NOT_SLEEP(TRUE)
    CRASH("`icon_for()` was not implemented for [type], even though should_generate_icons = TRUE!")

/datum/preference/choiced_list/is_valid(value)
    return value in get_choices()

/datum/preference/choiced_list/deserialize(input, datum/preferences/preferences)
    return sanitize_inlist(input, get_choices(), create_default_value())

/datum/preference/choiced_list/create_default_value()
    return pick(get_choices())

/datum/preference/choiced_list/compile_constant_data()
    var/list/data = list()
    var/list/choices = list()
    for (var/choice in get_choices())
        choices += choice
    data["choices"] = choices
    if (should_generate_icons)
        var/list/icons = list()
        for (var/choice in choices)
            icons[choice] = get_spritesheet_key(choice)
        data["icons"] = icons
    if (!isnull(main_feature_name))
        data["name"] = main_feature_name
    return data



/datum/preference/choiced_list/favorite_interactions
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "favorite_interactions"

/datum/preference/choiced_list/favorite_interactions/init_possible_values()
	return subtypesof(/datum/interaction)

/datum/preference/choiced_list/favorite_interactions/create_default_value()
	return null

/datum/preference/choiced_list/favorite_interactions/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return TRUE

/datum/preference/choiced_list/favorite_interactions/deserialize(input, datum/preferences/preferences)
	if(!preferences.read_preference(/datum/preference/choiced_list/favorite_interactions))
		return null
	. = ..()

/datum/preference/choiced_list/favorite_interactions/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/choiced_list/favorite_interactions/apply_to_client(client/client, value)
	client.prefs.favorite_interactions = value

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


/datum/preference/numeric/erp_lust_tolerance
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "erp_lust_tolerance_pref"
	savefile_identifier = PREFERENCE_CHARACTER

	minimum = 75
	maximum = 200

/datum/preference/choiced/erp_lust_tolerance/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	if(CONFIG_GET(flag/disable_erp_preferences))
		return FALSE

	return preferences.read_preference(/datum/preference/toggle/master_erp_preferences)

/datum/preference/numeric/erp_lust_tolerance/apply_to_human(mob/living/carbon/human/target, value)
	target.lust_tolerance = value

/datum/preference/numeric/erp_lust_tolerance/create_informed_default_value(datum/preferences/preferences)
	return 100


//--

/datum/preference/numeric/erp_sexual_potency
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "erp_sexual_potency_pref"
	savefile_identifier = PREFERENCE_CHARACTER

	minimum = 10
	maximum = 25

/datum/preference/choiced/erp_sexual_potency/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	if(CONFIG_GET(flag/disable_erp_preferences))
		return FALSE

	return preferences.read_preference(/datum/preference/toggle/master_erp_preferences)

/datum/preference/numeric/erp_sexual_potency/apply_to_human(mob/living/carbon/human/target, value)
	target.sexual_potency = value

/datum/preference/numeric/erp_sexual_potency/create_informed_default_value(datum/preferences/preferences)
	return 15
