/// Tests that gas analyzer scans fill its UI data and keep it in sync with the scanned air.
/datum/unit_test/gas_analyzer_live_ui

/datum/unit_test/gas_analyzer_live_ui/Run()
	var/mob/living/carbon/human/consistent/user = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	var/obj/item/analyzer/analyzer = allocate(/obj/item/analyzer)
	user.put_in_hands(analyzer)
	var/obj/machinery/portable_atmospherics/canister/oxygen/canister = allocate(/obj/machinery/portable_atmospherics/canister/oxygen, get_step(run_loc_floor_bottom_left, EAST))

	TEST_ASSERT(analyzer.scan_to_ui(user, canister), "Scanning a canister should succeed")
	TEST_ASSERT_EQUAL(analyzer.tracked_scan_target?.resolve(), canister, "The analyzer should track the scanned canister")
	TEST_ASSERT_EQUAL(length(analyzer.last_gasmix_data), 1, "A canister scan should produce one gas mixture")
	var/scanned_temperature = analyzer.last_gasmix_data[1]["temperature"]

	canister.air_contents.temperature = scanned_temperature + 100
	TEST_ASSERT(analyzer.refresh_tracked_scan(), "Refreshing an adjacent canister should succeed")
	TEST_ASSERT_EQUAL(analyzer.last_gasmix_data[1]["temperature"], scanned_temperature + 100, "The UI data should follow the canister's new temperature")

	TEST_ASSERT_EQUAL(analyzer.process(SSOBJ_DT), PROCESS_KILL, "The analyzer should stop processing with no UI open")
	TEST_ASSERT_NULL(analyzer.tracked_scan_target, "The analyzer should drop its target when it stops processing")

	analyzer.scan_to_ui(user, canister)
	canister.forceMove(run_loc_floor_top_right)
	TEST_ASSERT(!analyzer.refresh_tracked_scan(), "Refreshing should fail once the canister is out of range")

	TEST_ASSERT(analyzer.scan_to_ui(user, analyzer), "Scanning in hand should succeed")
	TEST_ASSERT_EQUAL(analyzer.tracked_scan_target?.resolve(), analyzer, "An in-hand scan should track the analyzer itself")
	TEST_ASSERT_EQUAL(analyzer.last_gasmix_data[1]["name"], format_text(capitalize(LOWER_TEXT(run_loc_floor_bottom_left.name))), "An in-hand scan should read the turf the user stands on")
