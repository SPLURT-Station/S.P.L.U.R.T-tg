/datum/unit_test/cyborg_size
	abstract_type = /datum/unit_test/cyborg_size

/datum/unit_test/cyborg_size/proc/make_preferences(size = 100)
	var/datum/client_interface/mock_client = allocate(/datum/client_interface)
	var/datum/preferences/preferences = allocate(/datum/preferences, mock_client)
	var/datum/preference/numeric/cyborg_size/entry = GLOB.preference_entries[/datum/preference/numeric/cyborg_size]
	preferences.write_preference(entry, size)
	return preferences

/datum/unit_test/cyborg_size/proc/make_borg()
	var/mob/living/silicon/robot/borg = allocate(/mob/living/silicon/robot)
	borg.model.transform_to(/obj/item/robot_model/standard, forced = TRUE, transform = FALSE)
	return borg

/datum/unit_test/cyborg_size/preference_validation/Run()
	var/datum/preference/numeric/cyborg_size/entry = GLOB.preference_entries[/datum/preference/numeric/cyborg_size]
	TEST_ASSERT_EQUAL(entry.create_default_value(), 100, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(entry.deserialize("85"), 85, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(entry.deserialize(null), 100, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(entry.deserialize("invalid"), 100, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(entry.deserialize(1), 100, "Out-of-range saved values should use the standard default.")
	TEST_ASSERT_EQUAL(entry.deserialize(999), 100, "Out-of-range saved values should use the standard default.")
	TEST_ASSERT_EQUAL(entry.deserialize(70), 70, "The minimum valid size should survive loading.")
	TEST_ASSERT_EQUAL(entry.deserialize(250), 250, "The maximum valid size should survive loading.")
	TEST_ASSERT_EQUAL(entry.deserialize(entry.serialize(85)), 85, "Cyborg size should match the expected preference and hardware state.")
	var/datum/preferences/preferences = make_preferences(85)
	TEST_ASSERT_EQUAL(preferences.read_preference(/datum/preference/numeric/cyborg_size), 85, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(entry.category, PREFERENCE_CATEGORY_SILICON_PREFS, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(entry.savefile_identifier, PREFERENCE_CHARACTER, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT(preferences.save_character(TRUE), "The character size preference should save successfully.")
	preferences.save_preferences()
	preferences = allocate(/datum/preferences, preferences.parent)
	TEST_ASSERT_EQUAL(preferences.read_preference(/datum/preference/numeric/cyborg_size), 85, "A new preferences datum should load the saved character size.")

/datum/unit_test/cyborg_size/default_size/Run()
	var/mob/living/silicon/robot/borg = make_borg()
	var/matrix/original_transform = matrix(borg.transform)
	TEST_ASSERT(!borg.apply_preferred_cyborg_size(make_preferences()), "Default size should preserve ordinary starting hardware.")
	TEST_ASSERT(!borg.resized, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(length(borg.upgrades), 0, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(borg.transform.a, original_transform.a, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(borg.transform.e, original_transform.e, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT(!borg.apply_preferred_cyborg_size(null), "Clientless borgs should retain the default.")

/datum/unit_test/cyborg_size/resize_and_rebuild/Run()
	var/mob/living/silicon/robot/borg = make_borg()
	var/datum/preferences/preferences = make_preferences(70)
	TEST_ASSERT(borg.apply_preferred_cyborg_size(preferences), "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT(borg.resized, "Cyborg size should match the expected preference and hardware state.")
	var/obj/item/borg/upgrade/resize/resizer = locate() in borg.upgrades
	TEST_ASSERT_NOTNULL(resizer, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(resizer.loc, borg, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(resizer.resize_amount, 70, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(round(borg.transform.a, 0.01), 0.7, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(round(borg.transform.e, 0.01), 0.7, "Cyborg size should match the expected preference and hardware state.")
	borg.model.rebuild_modules()
	TEST_ASSERT(!borg.apply_preferred_cyborg_size(preferences), "Rebuilding should retain the installed resizer without another scale multiplication.")
	TEST_ASSERT_EQUAL(length(borg.upgrades), 1, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(round(borg.transform.a, 0.01), 0.7, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT(!HAS_TRAIT(borg, TRAIT_NO_TRANSFORM), "Cyborg size should match the expected preference and hardware state.")
	resizer.forceMove(get_turf(borg))
	TEST_ASSERT(!borg.resized, "Removing starting hardware should clear its resize state.")
	TEST_ASSERT_EQUAL(length(borg.upgrades), 0, "Removing starting hardware should clear the upgrade list.")
	TEST_ASSERT_EQUAL(round(borg.transform.a, 0.01), 1, "Removing starting hardware should restore the ordinary scale.")
	TEST_ASSERT(borg.apply_preferred_cyborg_size(preferences), "The saved preference should apply again after hardware removal.")
	TEST_ASSERT_EQUAL(round(borg.transform.a, 0.01), 0.7, "Reapplying the preference should scale exactly once.")

/datum/unit_test/cyborg_size/reset_and_reselect/Run()
	var/mob/living/silicon/robot/borg = make_borg()
	var/datum/preferences/preferences = make_preferences(250)
	TEST_ASSERT(borg.apply_preferred_cyborg_size(preferences), "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(round(borg.transform.a, 0.01), 2.5, "Cyborg size should match the expected preference and hardware state.")
	borg.ResetModel()
	sleep(4 SECONDS)
	TEST_ASSERT(!borg.resized, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(length(borg.upgrades), 0, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT(!borg.apply_preferred_cyborg_size(preferences), "Unselected model should wait for module selection.")
	borg.model.transform_to(/obj/item/robot_model/standard, forced = TRUE, transform = FALSE)
	TEST_ASSERT(borg.apply_preferred_cyborg_size(preferences), "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(length(borg.upgrades), 1, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(round(borg.transform.a, 0.01), 2.5, "Cyborg size should match the expected preference and hardware state.")

/datum/unit_test/cyborg_size/blocked_chassis/Run()
	var/mob/living/silicon/robot/borg = make_borg()
	var/datum/preferences/preferences = make_preferences(85)
	borg.hasExpanded = TRUE
	TEST_ASSERT(!borg.apply_preferred_cyborg_size(preferences), "Cyborg size should match the expected preference and hardware state.")
	borg.hasExpanded = FALSE
	borg.hasShrunk = TRUE
	TEST_ASSERT(!borg.apply_preferred_cyborg_size(preferences), "Cyborg size should match the expected preference and hardware state.")
	borg.hasShrunk = FALSE
	borg.model.model_features += TRAIT_R_EXPANDER_BLOCKED
	TEST_ASSERT(!borg.apply_preferred_cyborg_size(preferences), "Cyborg size should match the expected preference and hardware state.")
	borg.model.model_features -= TRAIT_R_EXPANDER_BLOCKED
	ADD_TRAIT(borg, TRAIT_NO_TRANSFORM, "unit_test")
	TEST_ASSERT(!borg.apply_preferred_cyborg_size(preferences), "Cyborg size should match the expected preference and hardware state.")
	REMOVE_TRAIT(borg, TRAIT_NO_TRANSFORM, "unit_test")
	borg.shell = TRUE
	TEST_ASSERT(!borg.apply_preferred_cyborg_size(preferences), "Cyborg size should match the expected preference and hardware state.")
	borg.shell = FALSE
	TEST_ASSERT_EQUAL(length(borg.upgrades), 0, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT(!borg.resized, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT(borg.apply_preferred_cyborg_size(preferences), "Cyborg size should match the expected preference and hardware state.")

/datum/unit_test/cyborg_size/model_animation/Run()
	var/mob/living/silicon/robot/borg = allocate(/mob/living/silicon/robot)
	var/datum/client_interface/mock_client = allocate(/datum/client_interface)
	borg.mock_client = mock_client
	mock_client.prefs = make_preferences(85)
	borg.model.transform_to(/obj/item/robot_model/standard, forced = TRUE)
	sleep(4 SECONDS)
	TEST_ASSERT(!HAS_TRAIT(borg, TRAIT_NO_TRANSFORM), "The starting resizer should wait until model transformation finishes.")
	TEST_ASSERT(borg.resized, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT_EQUAL(length(borg.upgrades), 1, "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT(abs(borg.transform.a - 0.85) < 0.001, "The real animation should apply the saved 85% size within matrix precision.")
	TEST_ASSERT(!borg.apply_preferred_cyborg_size(), "Cyborg size should match the expected preference and hardware state.")
	TEST_ASSERT(abs(borg.transform.a - 0.85) < 0.001, "Reapplying the saved preference should retain the same 85% size.")
