/// Keeps the standalone digitigrade legs preference in sync with the legacy DNA feature cache.
/datum/preferences/proc/sync_digitigrade_legs_feature(value, list/save_data)
	if(!(value in list(NORMAL_LEGS, DIGITIGRADE_LEGS)))
		return
	if(!islist(features))
		features = list()
	features[FEATURE_LEGS] = value
	if(save_data)
		if(!islist(save_data["features"]))
			save_data["features"] = list()
		save_data["features"][FEATURE_LEGS] = value

/datum/preferences/load_character_skyrat(list/save_data)
	. = ..()
	sync_digitigrade_legs_feature(save_data?["digitigrade_legs"], save_data)

/datum/preference/choiced/digitigrade_legs/post_write(value, datum/preferences/preferences)
	. = ..()
	preferences?.sync_digitigrade_legs_feature(value)

/datum/preference/choiced/digitigrade_legs/proc/target_has_digitigrade_legs(mob/living/carbon/human/target)
	var/obj/item/bodypart/left_leg = target.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/right_leg = target.get_bodypart(BODY_ZONE_R_LEG)
	return (left_leg?.bodyshape & BODYSHAPE_DIGITIGRADE) && (right_leg?.bodyshape & BODYSHAPE_DIGITIGRADE)

/datum/preference/choiced/digitigrade_legs/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!preferences || !is_usable(preferences))
		return FALSE

	preferences.sync_digitigrade_legs_feature(value)

	var/has_digitigrade_legs = target_has_digitigrade_legs(target)
	if(value == target.dna.features[FEATURE_LEGS])
		if(value == DIGITIGRADE_LEGS && has_digitigrade_legs)
			return FALSE
		if(value == NORMAL_LEGS && !has_digitigrade_legs)
			return FALSE

	target.dna.features[FEATURE_LEGS] = value

	if(value == DIGITIGRADE_LEGS)
		target.dna.species.try_make_digitigrade(target)
	else if(value == NORMAL_LEGS)
		var/datum/species/fresh_species = new target.dna.species.type
		target.dna.species.bodypart_overrides = fresh_species.bodypart_overrides
	else
		return FALSE

	target.update_body()
	target.dna.species.replace_body(target, target.dna.species)
	target.update_underwear_on_bodytype_change()
	return TRUE
