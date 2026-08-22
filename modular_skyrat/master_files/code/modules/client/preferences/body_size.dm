/datum/preference/numeric/body_size
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "body_size"
	minimum = BODY_SIZE_MIN
	maximum = BODY_SIZE_MAX
	step = 0.01

/datum/preference/numeric/body_size/is_accessible(datum/preferences/preferences)
	var/passed_initial_check = ..(preferences)
	return passed_initial_check

/datum/preference/numeric/body_size/apply_to_human(mob/living/carbon/human/target, value)
	//SPLURT EDIT CHANGE BEGIN - SIZECODE - Prefer update_size so size HP/mob_size/slowdown hooks apply
	//target.update_transform(value / target.current_size) - SPLURT EDIT - ORIGINAL
	target.update_size(value)
	//SPLURT EDIT CHANGE END

/datum/preference/numeric/body_size/create_default_value()
	return RESIZE_DEFAULT_SIZE
