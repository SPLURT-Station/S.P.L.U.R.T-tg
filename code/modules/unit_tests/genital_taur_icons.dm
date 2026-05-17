/datum/unit_test/genital_taur_icons

/datum/unit_test/genital_taur_icons/Run()
	var/mob/living/carbon/human/consistent/test_subject = allocate(/mob/living/carbon/human/consistent)
	test_subject.dna.species.mutant_bodyparts[FEATURE_TAUR] = list(MUTANT_INDEX_NAME = "Cow", MUTANT_INDEX_COLOR_LIST = list("#FFFFFF", "#FFFFFF", "#FFFFFF"))
	test_subject.dna.features["penis_taur_mode"] = TRUE

	var/datum/sprite_accessory/genital/testicles/testicles = allocate(/datum/sprite_accessory/genital/testicles/pair)
	TEST_ASSERT_EQUAL(testicles.get_special_icon(test_subject), 'modular_skyrat/master_files/icons/mob/sprite_accessory/genitals/taur_testicles_onmob.dmi', "Taur testicles used the wrong on-mob icon file.")
