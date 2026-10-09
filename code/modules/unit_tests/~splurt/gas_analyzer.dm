/// A canister click must select a live target, rather than just cache a chat scan.
/datum/unit_test/gas_analyzer_live_canister/Run()
	var/mob/living/carbon/human/consistent/user = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	var/obj/item/analyzer/analyzer = allocate(/obj/item/analyzer, user)
	var/obj/machinery/portable_atmospherics/canister/canister = allocate(/obj/machinery/portable_atmospherics/canister, get_step(user, EAST))
	canister.air_contents.adjust_gas(/datum/gas/oxygen, 10)
	TEST_ASSERT(canister.tool_act(user, analyzer, list()), "Canister did not handle the analyzer tool interaction")
	TEST_ASSERT_EQUAL(analyzer.last_atmos_target?.resolve(), canister, "Canister click did not select the gas UI's target")
	var/list/data = analyzer.ui_data(user)
	var/list/mixes = data["gasmixes"]
	TEST_ASSERT_EQUAL(length(mixes), 1, "Canister should produce one gas mixture")
	var/list/initial_mix = mixes[1]
	TEST_ASSERT_EQUAL(initial_mix["total_moles"], 10, "Initial canister reading is incorrect")

	canister.air_contents.adjust_gas(/datum/gas/oxygen, 5)
	canister.air_contents.temperature = 350
	data = analyzer.ui_data(user)
	mixes = data["gasmixes"]
	var/list/updated_mix = mixes[1]
	TEST_ASSERT_EQUAL(updated_mix["total_moles"], 15, "Gas UI did not update without another click")
	TEST_ASSERT_EQUAL(updated_mix["temperature"], 350, "Gas UI did not refresh the temperature")
	TEST_ASSERT_EQUAL(updated_mix["pressure"], canister.air_contents.return_pressure(), "Gas UI did not refresh the pressure")

	analyzer.ranged_scan_distance = 0
	canister.air_contents.adjust_gas(/datum/gas/oxygen, 5)
	data = analyzer.ui_data(user)
	mixes = data["gasmixes"]
	var/list/out_of_range_mix = mixes[1]
	TEST_ASSERT_EQUAL(out_of_range_mix["total_moles"], 15, "Gas UI refreshed a target outside the scan range")

	qdel(canister)
	data = analyzer.ui_data(user)
	TEST_ASSERT_NOTNULL(data, "Deleted scan target broke the gas UI")
	TEST_ASSERT_NULL(analyzer.last_atmos_target?.resolve(), "Gas UI retained a deleted canister")

/// Self-use and fallback scans should also select their actual atmospheric target.
/datum/unit_test/gas_analyzer_turf_scan/Run()
	var/mob/living/carbon/human/consistent/user = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	var/obj/item/analyzer/analyzer = allocate(/obj/item/analyzer, user)
	analyzer.attack_self(user, list())
	TEST_ASSERT_EQUAL(analyzer.last_atmos_target?.resolve(), get_turf(user), "Self-use did not select the local atmosphere")

	var/obj/item/target = allocate(/obj/item, get_step(user, EAST))
	analyzer.interact_with_atom(target, user, list())
	TEST_ASSERT_EQUAL(analyzer.last_atmos_target?.resolve(), get_turf(target), "Non-atmospheric object did not fall back to its turf")
