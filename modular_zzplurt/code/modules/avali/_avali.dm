/datum/species/avali
	name = "Avali"
	id = SPECIES_AVALI
	no_gender_shaping = TRUE
	inherent_traits = list(
	TRAIT_ADVANCEDTOOLUSER,
	TRAIT_CAN_STRIP,
	TRAIT_LITERATE,
	TRAIT_MUTANT_COLORS,
	TRAIT_NO_HUSK,
	)
	digitigrade_customization = DIGITIGRADE_FORCED
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 1.0
	mutanttongue = /obj/item/organ/tongue/avali
	coldmod = 1
	heatmod = 1.2
	exotic_bloodtype = BLOOD_TYPE_AVALI
	bodytemp_normal = 193 // -50C
	bodytemp_heat_damage_limit = 330 // 57C
	bodytemp_cold_damage_limit = 120 // -113C
	species_language_holder = /datum/language_holder/avali
	mutantears = /obj/item/organ/ears/avali
	mutantlungs = /obj/item/organ/lungs/adaptive/cold
	body_size_restricted = TRUE
	bodypart_overrides = list(
	BODY_ZONE_HEAD = /obj/item/bodypart/head/mutant/avali,
	BODY_ZONE_CHEST = /obj/item/bodypart/chest/mutant/avali,
	BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/mutant/avali,
	BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/mutant/avali,
	BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/mutant/avali,
	BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/mutant/avali,
	)
	mutant_organs = list(
		/obj/item/organ/avali_hair = "None",
	)
	meat = /obj/item/food/meat/slab/chicken/human


/obj/item/organ/tongue/avali
	liked_foodtypes = MEAT | GORE | VEGETABLES
	disliked_foodtypes = GROSS | GRAIN | NUTS | DAIRY

/datum/language_holder/avali
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/schechi = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/schechi = list(LANGUAGE_ATOM))

/obj/item/organ/ears/avali
	name = "avali ears"
	desc = "A set of four long rabbit-like ears, an Avali's main tool while hunting. Naturally extremely sensitive to loud sounds."
	damage_multiplier = 1.5
	overrides_sprite_datum_organ_type = TRUE
	bodypart_overlay = /datum/bodypart_overlay/mutant/ears

/datum/species/avali/prepare_human_for_preview(mob/living/carbon/human/avali)
	var/base_color = "#c0965f"
	var/ear_color = "#e4c49b"

	avali.dna.features[FEATURE_MUTANT_COLOR] = base_color
	avali.dna.mutant_bodyparts[FEATURE_EARS] = list(MUTANT_INDEX_NAME = "Avali Ears (Default)", MUTANT_INDEX_COLOR_LIST = list(ear_color, ear_color, ear_color))
	avali.dna.mutant_bodyparts[FEATURE_TAIL_GENERIC] = list(MUTANT_INDEX_NAME = "Avali Tail (Default)", MUTANT_INDEX_COLOR_LIST = list(base_color, base_color, ear_color))
	regenerate_organs(avali, src, visual_only = TRUE)
	avali.update_body(TRUE)

/datum/species/avali/get_default_mutant_bodyparts()
	return list(
		"tail" = list("Avali Tail (Default)", TRUE),
		"ears" = list("Avali Ears (Default)", TRUE),
		"legs" = list("Digitigrade Legs", FALSE),
	)

/datum/species/avali/create_pref_unique_perks()
	var/list/perk_descriptions = list()

	perk_descriptions += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_RUNNING,
		SPECIES_PERK_NAME = "Tablerunning",
		SPECIES_PERK_DESC = "A being of extreme agility, you can jump on tables just by running into them!"
	))

	return perk_descriptions

/datum/species/avali/get_species_description()
	return list(
		"Resembling something like a cross between a large rabbit, and avian. Avali stand bipedally, with digitigrade pose, usually appearing slightly tilted forward. Their arms are slightly longer than humans, ending in three-fingered hands with small claws. Their heads are elongated and beak-like, with large eyes and a set of four long ears atop their heads. Their bodies are covered in short fur, often in shades of brown, grey, or white. Avali have a pair of large, feathered wings folded against their backs, which they use for gliding rather than powered flight. They are known for their agility and keen senses, their sight is weaker than most species, due to dim light conditions on their homeworld, but are have amazing hearing ability.",
	)
