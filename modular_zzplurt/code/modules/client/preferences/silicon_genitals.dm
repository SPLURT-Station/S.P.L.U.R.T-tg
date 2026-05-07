/proc/get_silicon_genital_sprite_values(organ_slot)
	return get_genital_sprite_values(organ_slot, TRUE)

/datum/preference/toggle/silicon_genitals_toggle
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "silicon_genitals_toggle"
	default_value = FALSE

/datum/preference/toggle/silicon_genitals_toggle/is_accessible(datum/preferences/preferences)
	if(!..())
		return FALSE
	return !CONFIG_GET(flag/disable_erp_preferences) && preferences.read_preference(/datum/preference/toggle/master_erp_preferences)

/datum/preference/toggle/silicon_genitals_toggle/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/choiced/silicon_genital_sprite
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	abstract_type = /datum/preference/choiced/silicon_genital_sprite
	var/organ_slot
	var/datum/sprite_accessory/default_accessory_type

/datum/preference/choiced/silicon_genital_sprite/init_possible_values()
	return get_silicon_genital_sprite_values(organ_slot)

/datum/preference/choiced/silicon_genital_sprite/create_default_value()
	return initial(default_accessory_type.name)

/datum/preference/choiced/silicon_genital_sprite/is_accessible(datum/preferences/preferences)
	if(CONFIG_GET(flag/disable_erp_preferences))
		return FALSE
	if(!..())
		return FALSE
	if(!preferences.read_preference(/datum/preference/toggle/master_erp_preferences))
		return FALSE
	return preferences.read_preference(/datum/preference/toggle/silicon_genitals_toggle)

/datum/preference/choiced/silicon_genital_sprite/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/choiced/silicon_genital_sprite/penis
	savefile_key = "silicon_penis_sprite"
	main_feature_name = "Silicon Penis"
	organ_slot = ORGAN_SLOT_PENIS
	default_accessory_type = /datum/sprite_accessory/genital/penis/none

/datum/preference/choiced/silicon_genital_sprite/sheath
	savefile_key = "silicon_sheath_sprite"
	main_feature_name = "Silicon Sheath"
	organ_slot = ORGAN_SLOT_SHEATH
	default_accessory_type = /datum/sprite_accessory/genital/penis/sheath/none

/datum/preference/choiced/silicon_genital_sprite/testicles
	savefile_key = "silicon_testicles_sprite"
	main_feature_name = "Silicon Testicles"
	organ_slot = ORGAN_SLOT_TESTICLES
	default_accessory_type = /datum/sprite_accessory/genital/testicles/none

/datum/preference/choiced/silicon_genital_sprite/vagina
	savefile_key = "silicon_vagina_sprite"
	main_feature_name = "Silicon Vagina"
	organ_slot = ORGAN_SLOT_VAGINA
	default_accessory_type = /datum/sprite_accessory/genital/vagina/none

/datum/preference/blob/silicon_genital_layout_presets
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "silicon_genital_layout_presets"

/datum/preference/blob/silicon_genital_layout_presets/create_default_value()
	return list(
		"active" = list(),
		"presets" = list(),
	)
