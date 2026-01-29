/datum/preference/toggle/mutant_toggle/avali_crest_feathers
	savefile_key = "avali_crest_feathers_toggle"
	relevant_mutant_bodypart = "avali_hair"

/datum/preference/choiced/mutant_choice/crest_feathers
	savefile_key = "avali_feature_crest_feathers"
	relevant_mutant_bodypart = "avali_hair"
	type_to_check = /datum/preference/toggle/mutant_toggle/avali_crest_feathers
	default_accessory_type = /datum/sprite_accessory/avali_hair/none

/datum/preference/tri_color/crest_feathers_color
	savefile_key = "avali_crest_feathers_color"
	relevant_mutant_bodypart = "avali_hair"
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	type_to_check = /datum/preference/toggle/mutant_toggle/avali_crest_feathers
