/datum/sprite_accessory/ears/mutant/avali
	recommended_species = list(SPECIES_AVALI)

/datum/sprite_accessory/ears/mutant/avali/regular
	name = "Avali Ears (Default)"
	icon_state = "avali_default"

/datum/sprite_accessory/tails/mammal/avali
	recommended_species = list(SPECIES_AVALI)

/datum/sprite_accessory/tails/mammal/avali/regular
	name = "Avali Tail (Default)"
	icon_state = "avali_default"

// HAIR

/datum/sprite_accessory/avali_hair
	icon = 'modular_zzplurt/code/modules/avali/sprites/hair.dmi'
	key = "avali_hair"
	recommended_species = list(SPECIES_AVALI)
	relevent_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER)
	default_color = DEFAULT_MATRIXED
	organ_type = /obj/item/organ/avali_hair

/datum/sprite_accessory/avali_hair/none
	name = SPRITE_ACCESSORY_NONE
	icon_state = "none"
	factual = FALSE
	natural_spawn = FALSE

/datum/sprite_accessory/avali_hair/bigponytail
	name = "Avali Big Ponytail"
	icon_state = "bigponytail"
	color_src = USE_MATRIXED_COLORS


/datum/sprite_accessory/avali_hair/cockatiel
	name = "Avali Cockatiel"
	icon_state = "cockatiel"
	color_src = USE_MATRIXED_COLORS

/datum/sprite_accessory/avali_hair/cockatoo
	name = "Avali Cockatoo"
	icon_state = "cockatoo"
	color_src = USE_MATRIXED_COLORS

/datum/sprite_accessory/avali_hair/dualfeather
	name = "Avali Dual Feather"
	icon_state = "dualfeather"
	color_src = USE_MATRIXED_COLORS

/datum/sprite_accessory/avali_hair/hooked
	name = "Avali Hooked"
	icon_state = "hooked"
	color_src = USE_MATRIXED_COLORS

/datum/sprite_accessory/avali_hair/jay
	name = "Avali Jay"
	icon_state = "crestjay"
	color_src = USE_MATRIXED_COLORS

/datum/sprite_accessory/avali_hair/longfeather
	name = "Avali Long Feather"
	icon_state = "longfeather"
	color_src = USE_MATRIXED_COLORS

/datum/sprite_accessory/avali_hair/punk
	name = "Avali Punk"
	icon_state = "punk"
	color_src = USE_MATRIXED_COLORS

/obj/item/organ/avali_hair
	name = "Avali Crest Feathers"
	desc = "Objectively fluffy and long."
	icon = 'modular_zzplurt/code/modules/avali/sprites/hair.dmi'
	icon_state = "bigponytail"

	mutantpart_key = "avali_hair"
	mutantpart_info = list(MUTANT_INDEX_NAME = "None", MUTANT_INDEX_COLOR_LIST = list("#FFFFFF"))
	external_bodyshapes = NONE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_CREST_FEATHERS

	restyle_flags = EXTERNAL_RESTYLE_ENAMEL

	bodypart_overlay = /datum/bodypart_overlay/mutant/avali_hair

/datum/bodypart_overlay/mutant/avali_hair
	layers = ALL_EXTERNAL_OVERLAYS
	feature_key = "avali_hair"

/datum/bodypart_overlay/mutant/avali_hair/get_global_feature_list()
	return SSaccessories.sprite_accessories["avali_hair"]
/*
/datum/bodypart_overlay/mutant/avali_hair/can_draw_on_bodypart(mob/living/carbon/human/human, datum/preferences/preferences)
	var/species_path = preferences?.read_preference(/datum/preference/choiced/species)
	if(!ispath(species_path, /datum/species/avali)) // This is what we do so it doesn't show up on non-avali.
		return

	return ..()
*/
