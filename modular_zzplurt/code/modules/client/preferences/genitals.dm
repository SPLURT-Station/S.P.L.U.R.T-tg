//butt
/datum/preference/choiced/genital/butt
	savefile_key = "feature_butt"
	relevant_mutant_bodypart = ORGAN_SLOT_BUTT
	default_accessory_type = /datum/sprite_accessory/genital/butt/none

/datum/preference/toggle/genital_skin_tone/butt
	savefile_key = "butt_skin_tone"
	relevant_mutant_bodypart = ORGAN_SLOT_BUTT
	genital_pref_type = /datum/preference/choiced/genital/butt

/datum/preference/toggle/genital_skin_tone/butt/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["butt_uses_skintones"] = value

/datum/preference/toggle/genital_skin_color/butt
	savefile_key = "butt_skin_color"
	relevant_mutant_bodypart = ORGAN_SLOT_BUTT
	genital_pref_type = /datum/preference/choiced/genital/butt

/datum/preference/toggle/genital_skin_color/butt/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!..()) // Don't apply it if it failed the check in the parent.
		value = FALSE

	target.dna.features["butt_uses_skincolor"] = value

/datum/preference/numeric/butt_size
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "butt_size"
	relevant_mutant_bodypart = ORGAN_SLOT_BUTT
	minimum = BUTT_MIN_SIZE
	maximum = BUTT_MAX_SIZE

/datum/preference/numeric/butt_size/is_accessible(datum/preferences/preferences)
	var/passed_initial_check = ..(preferences)
	var/allowed = preferences.read_preference(/datum/preference/toggle/allow_mismatched_parts)
	var/erp_allowed = preferences.read_preference(/datum/preference/toggle/master_erp_preferences) && preferences.read_preference(/datum/preference/toggle/allow_genitals)
	var/part_enabled = is_factual_sprite_accessory(relevant_mutant_bodypart, preferences.read_preference(/datum/preference/choiced/genital/butt))
	return erp_allowed && part_enabled && (passed_initial_check || allowed)

/datum/preference/numeric/butt_size/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["butt_size"] = value

/datum/preference/numeric/butt_size/create_default_value()
	return BUTT_MIN_SIZE

/datum/preference/tri_color/genital/butt
	savefile_key = "butt_color"
	relevant_mutant_bodypart = ORGAN_SLOT_BUTT
	type_to_check = /datum/preference/choiced/genital/butt
	skin_color_type = /datum/preference/toggle/genital_skin_color/butt

/datum/preference/tri_bool/genital/butt
	savefile_key = "butt_emissive"
	relevant_mutant_bodypart = ORGAN_SLOT_BUTT
	type_to_check = /datum/preference/choiced/genital/butt
	skin_color_type = /datum/preference/toggle/genital_skin_color/butt



//butthole
/datum/preference/choiced/genital/anus/deserialize(input, datum/preferences/preferences)
	if(preferences.read_preference(/datum/preference/choiced/genital/butt) == SPRITE_ACCESSORY_NONE && input != SPRITE_ACCESSORY_NONE)
		return /datum/sprite_accessory/genital/anus/normal::name
	. = ..()

/datum/preference/toggle/genital_skin_tone/anus
	savefile_key = "anus_skin_tone"
	relevant_mutant_bodypart = ORGAN_SLOT_ANUS
	genital_pref_type = /datum/preference/choiced/genital/anus

/datum/preference/toggle/genital_skin_tone/anus/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["anus_uses_skintones"] = value

/datum/preference/toggle/genital_skin_color/anus
	savefile_key = "anus_skin_color"
	relevant_mutant_bodypart = ORGAN_SLOT_ANUS
	genital_pref_type = /datum/preference/choiced/genital/anus

/datum/preference/toggle/genital_skin_color/anus/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!..()) // Don't apply it if it failed the check in the parent.
		value = FALSE

	target.dna.features["anus_uses_skincolor"] = value


/datum/preference/tri_color/genital/anus
	savefile_key = "anus_color"
	relevant_mutant_bodypart = ORGAN_SLOT_ANUS
	type_to_check = /datum/preference/choiced/genital/anus
	skin_color_type = /datum/preference/toggle/genital_skin_color/anus

/datum/preference/tri_bool/genital/anus
	savefile_key = "anus_emissive"
	relevant_mutant_bodypart = ORGAN_SLOT_ANUS
	type_to_check = /datum/preference/choiced/genital/anus
	skin_color_type = /datum/preference/toggle/genital_skin_color/anus

// BELLY
/datum/preference/choiced/genital/belly
	savefile_key = "feature_belly"
	relevant_mutant_bodypart = ORGAN_SLOT_BELLY
	default_accessory_type = /datum/sprite_accessory/genital/belly/none

/datum/preference/numeric/belly_size
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "belly_size"
	relevant_mutant_bodypart = ORGAN_SLOT_BELLY
	minimum = BELLY_MIN_SIZE
	maximum = BELLY_MAX_SIZE

/datum/preference/numeric/belly_size/create_default_value()
	return 1

/datum/preference/numeric/belly_size/is_accessible(datum/preferences/preferences)
	var/passed_initial_check = ..(preferences)
	var/allowed = preferences.read_preference(/datum/preference/toggle/allow_mismatched_parts)
	var/erp_allowed = preferences.read_preference(/datum/preference/toggle/master_erp_preferences) && preferences.read_preference(/datum/preference/toggle/allow_genitals)
	var/part_enabled = is_factual_sprite_accessory(relevant_mutant_bodypart, preferences.read_preference(/datum/preference/choiced/genital/belly))
	return erp_allowed && part_enabled && (passed_initial_check || allowed)

/datum/preference/numeric/belly_size/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["belly_size"] = value


/datum/preference/toggle/genital_skin_tone/belly
	savefile_key = "belly_skin_tone"
	relevant_mutant_bodypart = ORGAN_SLOT_BELLY
	genital_pref_type = /datum/preference/choiced/genital/belly

/datum/preference/toggle/genital_skin_tone/belly/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["belly_uses_skintones"] = value

/datum/preference/toggle/genital_skin_color/belly
	savefile_key = "belly_skin_color"
	relevant_mutant_bodypart = ORGAN_SLOT_BELLY
	genital_pref_type = /datum/preference/choiced/genital/belly

/datum/preference/toggle/genital_skin_color/belly/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!..()) // Don't apply it if it failed the check in the parent.
		value = FALSE

	target.dna.features["belly_uses_skincolor"] = value


/datum/preference/tri_color/genital/belly
	savefile_key = "belly_color"
	relevant_mutant_bodypart = ORGAN_SLOT_BELLY
	type_to_check = /datum/preference/choiced/genital/belly
	skin_color_type = /datum/preference/toggle/genital_skin_color/belly

/datum/preference/tri_bool/genital/belly
	savefile_key = "belly_emissive"
	relevant_mutant_bodypart = ORGAN_SLOT_BELLY
	type_to_check = /datum/preference/choiced/genital/belly
	skin_color_type = /datum/preference/toggle/genital_skin_color/belly

// Genital fluid preferences base type
/datum/preference/choiced/genital_fluid
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	abstract_type = /datum/preference/choiced/genital_fluid
	var/datum/preference/choiced/genital/genital_pref
	var/feature_key // The key used in dna.features to store the fluid type

/datum/preference/choiced/genital_fluid/init_possible_values()
	if(!SSinteractions.genital_fluids_paths)
		SSinteractions.prepare_genital_fluids()
	return sort_list(SSinteractions.genital_fluids_paths)

/datum/preference/choiced/genital_fluid/is_accessible(datum/preferences/preferences)
	var/passed_initial_check = ..(preferences)
	var/allowed = preferences.read_preference(/datum/preference/toggle/allow_mismatched_parts)
	var/erp_allowed = !CONFIG_GET(flag/disable_erp_preferences) && preferences.read_preference(/datum/preference/toggle/master_erp_preferences) && preferences.read_preference(/datum/preference/toggle/allow_genitals)
	var/part_enabled = is_factual_sprite_accessory(relevant_mutant_bodypart, preferences.read_preference(genital_pref))
	return erp_allowed && part_enabled && (passed_initial_check || allowed) && preferences.read_preference(/datum/preference/toggle/erp/custom_genital_fluids)

/datum/preference/choiced/genital_fluid/deserialize(input, datum/preferences/preferences)
	if(!is_accessible(preferences))
		return create_default_value()
	. = ..()

/datum/preference/choiced/genital_fluid/apply_to_human(mob/living/carbon/human/target, value)
	if(!target.dna.mutant_bodyparts[relevant_mutant_bodypart])
		return FALSE
	target.dna.features[feature_key] = SSinteractions.genital_fluids_paths[value]

// Testicles fluid preference
/datum/preference/choiced/genital_fluid/testicles
	savefile_key = "testicles_fluid"
	relevant_mutant_bodypart = ORGAN_SLOT_TESTICLES
	genital_pref = /datum/preference/choiced/genital/testicles
	feature_key = "testicles_fluid"

/datum/preference/choiced/genital_fluid/testicles/create_default_value()
	return /datum/reagent/consumable/cum::name

// Breasts fluid preference
/datum/preference/choiced/genital_fluid/breasts
	savefile_key = "breasts_fluid"
	relevant_mutant_bodypart = ORGAN_SLOT_BREASTS
	genital_pref = /datum/preference/choiced/genital/breasts
	feature_key = "breasts_fluid"

/datum/preference/choiced/genital_fluid/breasts/create_default_value()
	return /datum/reagent/consumable/milk::name

// Vagina fluid preference
/datum/preference/choiced/genital_fluid/vagina
	savefile_key = "vagina_fluid"
	relevant_mutant_bodypart = ORGAN_SLOT_VAGINA
	genital_pref = /datum/preference/choiced/genital/vagina
	feature_key = "vagina_fluid"

/datum/preference/choiced/genital_fluid/vagina/create_default_value()
	return /datum/reagent/consumable/femcum::name

// Cumflation preferences
/datum/preference/toggle/erp/cumflates_partners
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "cumflates_partners_pref"

/datum/preference/toggle/erp/cumflates_partners/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

// Knotting preferences
/datum/preference/toggle/erp/knots_partners
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "knots_partners_pref"

/datum/preference/toggle/erp/knots_partners/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return
