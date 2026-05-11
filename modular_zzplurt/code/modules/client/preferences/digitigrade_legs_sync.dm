/// Keeps the standalone digitigrade legs preference in sync with the legacy DNA feature cache.
/datum/preferences/proc/sync_digitigrade_legs_feature(value)
	if(!(value in list(NORMAL_LEGS, DIGITIGRADE_LEGS)))
		return
	if(!islist(features))
		features = list()
	features[FEATURE_LEGS] = value

/datum/preferences/load_character_skyrat(list/save_data)
	. = ..()
	sync_digitigrade_legs_feature(save_data?["digitigrade_legs"])

/datum/preference/choiced/digitigrade_legs/post_write(value, datum/preferences/preferences)
	. = ..()
	preferences?.sync_digitigrade_legs_feature(value)
