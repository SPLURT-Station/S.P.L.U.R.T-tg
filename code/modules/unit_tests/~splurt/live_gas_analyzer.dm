// Only the client-window boundary is replaced. Selection, tool dispatch and gas serialization are real.
/obj/item/analyzer/live_test
	var/open_requests = 0

/obj/item/analyzer/live_test/ui_interact(mob/user, datum/tgui/ui)
	open_requests++

/obj/item/analyzer/ranged/live_test
	var/open_requests = 0

/obj/item/analyzer/ranged/live_test/ui_interact(mob/user, datum/tgui/ui)
	open_requests++

/datum/unit_test/live_gas_analyzer
	abstract_type = /datum/unit_test/live_gas_analyzer
	var/mob/living/carbon/human/user
	var/obj/item/analyzer/live_test/scanner

/datum/unit_test/live_gas_analyzer/New()
	. = ..()
	user = allocate(/mob/living/carbon/human/consistent)
	ADD_TRAIT(user, TRAIT_LITERATE, TRAIT_SOURCE_UNIT_TESTS)
	ADD_TRAIT(user, TRAIT_PRESERVE_UI_WITHOUT_CLIENT, TRAIT_SOURCE_UNIT_TESTS)
	user.lighting_cutoff = LIGHTING_NIGHTVISION_THRESHOLD
	scanner = allocate(/obj/item/analyzer/live_test)
	user.put_in_hands(scanner)

/datum/unit_test/live_gas_analyzer/proc/read_mixes()
	var/list/data = scanner.ui_data(user)
	return data["gasmixes"]

/datum/unit_test/live_gas_analyzer/canister_live/Run()
	var/obj/machinery/portable_atmospherics/canister/target = allocate(__IMPLIED_TYPE__)
	var/datum/gas_mixture/air = target.return_analyzable_air()
	air.moles[/datum/gas/oxygen] = 20
	air.temperature = 300
	TEST_ASSERT(scanner.melee_attack_chain(user, target, list()), "Real canister tool dispatch must handle the scan.")
	TEST_ASSERT(scanner.open_requests == 1, "The tool action must request the UI once.")
	var/list/mixes = read_mixes()
	TEST_ASSERT(length(mixes) == 1, "Canister scan must contain one mixture.")
	var/list/before = mixes[1]
	TEST_ASSERT(before["total_moles"] == 20, "Initial gas amount must come from the canister.")
	air.moles[/datum/gas/oxygen] = 5
	air.moles[/datum/gas/nitrogen] = 30
	air.temperature = 450
	mixes = read_mixes()
	var/list/after = mixes[1]
	TEST_ASSERT(after["total_moles"] == 35 && after["temperature"] == 450, "Updates must read changed gas amount and temperature without another scan.")
	TEST_ASSERT(after["pressure"] == air.return_pressure() && after["pressure"] != before["pressure"], "Pressure must update from the live mixture.")
	TEST_ASSERT(length(after["gases"]) == 2, "Composition must include the newly added nitrogen.")
	TEST_ASSERT(scanner.open_requests == 1, "Reading updates must not repeat the interaction.")

/datum/unit_test/live_gas_analyzer/multiple_nodes/Run()
	var/obj/machinery/atmospherics/components/binary/pump/target = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(scanner.melee_attack_chain(user, target, list()), "Atmospheric component tool dispatch must open the UI.")
	var/list/mixes = read_mixes()
	TEST_ASSERT(length(mixes) == 2, "Both real pump nodes must remain visible, including vacuum.")
	var/list/first = mixes[1]
	var/list/second = mixes[2]
	TEST_ASSERT(findtext(first["name"], "Node 1") && findtext(second["name"], "Node 2"), "Node labels must stay distinct.")
	var/datum/gas_mixture/air = target.airs[2]
	air.moles[/datum/gas/oxygen] = 12
	air.temperature = 320
	mixes = read_mixes()
	first = mixes[1]
	second = mixes[2]
	TEST_ASSERT(first["total_moles"] == 0 && second["total_moles"] == 12, "Only the changed real node must update; vacuum remains represented.")

/datum/unit_test/live_gas_analyzer/switch_targets/Run()
	var/obj/machinery/portable_atmospherics/canister/first_target = allocate(__IMPLIED_TYPE__)
	var/obj/machinery/portable_atmospherics/canister/second_target = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(scanner.melee_attack_chain(user, first_target, list()), "First scan must dispatch.")
	TEST_ASSERT(scanner.melee_attack_chain(user, second_target, list()), "Second scan must dispatch.")
	var/datum/gas_mixture/first_air = first_target.return_analyzable_air()
	var/datum/gas_mixture/second_air = second_target.return_analyzable_air()
	first_air.moles[/datum/gas/oxygen] = 90
	second_air.moles[/datum/gas/nitrogen] = 7
	var/list/mixes = read_mixes()
	var/list/reading = mixes[1]
	TEST_ASSERT(reading["reference"] == REF(second_air) && reading["total_moles"] == 7, "Switching must stop reading the former target.")

/datum/unit_test/live_gas_analyzer/self_and_turf/Run()
	scanner.attack_self(user, list())
	TEST_ASSERT(scanner.open_requests == 1 && scanner.scanning_environment, "Self-use must open a live environment scan.")
	var/turf/next_tile = get_step(run_loc_floor_bottom_left, EAST)
	user.forceMove(next_tile)
	var/list/mixes = read_mixes()
	var/list/reading = mixes[1]
	var/datum/gas_mixture/air = next_tile.return_analyzable_air()
	TEST_ASSERT(reading["reference"] == REF(air), "Self-use must follow the held analyzer into its new environment.")
	scanner.interact_with_atom(run_loc_floor_bottom_left, user, list())
	TEST_ASSERT(!scanner.scanning_environment, "Explicit turf selection must stop following the environment.")
	mixes = read_mixes()
	reading = mixes[1]
	air = run_loc_floor_bottom_left.return_analyzable_air()
	TEST_ASSERT(reading["reference"] == REF(air), "Explicit turf scan must read the selected turf.")
	var/obj/item/pen/no_air = allocate(__IMPLIED_TYPE__, next_tile)
	scanner.interact_with_atom(no_air, user, list())
	mixes = read_mixes()
	reading = mixes[1]
	air = next_tile.return_analyzable_air()
	TEST_ASSERT(reading["reference"] == REF(air), "Objects without analyzable air must retain the turf fallback.")

/datum/unit_test/live_gas_analyzer/range/Run()
	var/turf/remote_tile = get_step(get_step(run_loc_floor_bottom_left, EAST), EAST)
	var/obj/machinery/portable_atmospherics/canister/target = allocate(__IMPLIED_TYPE__, remote_tile)
	scanner.interact_with_atom(target, user, list())
	TEST_ASSERT(scanner.open_requests == 0 && !length(read_mixes()), "Ordinary scanner must reject a target two tiles away.")
	var/obj/item/analyzer/ranged/live_test/ranged = allocate(__IMPLIED_TYPE__)
	user.put_in_hands(ranged)
	ranged.ranged_interact_with_atom(target, user, list())
	var/list/data = ranged.ui_data(user)
	TEST_ASSERT(ranged.open_requests == 1 && length(data["gasmixes"]) == 1, "Actual ranged subtype must select a visible remote canister.")
	var/turf/out_of_range = locate(user.x + ranged.ranged_scan_distance + 1, user.y, user.z)
	TEST_ASSERT(out_of_range, "Integration map must provide a tile beyond ranged scanner reach.")
	target.forceMove(out_of_range)
	data = ranged.ui_data(user)
	TEST_ASSERT(!length(data["gasmixes"]), "Moving beyond reach must clear the old displayed reading.")
	target.forceMove(remote_tile)
	data = ranged.ui_data(user)
	TEST_ASSERT(length(data["gasmixes"]) == 1, "Returning within reach must resume live readings.")

/datum/unit_test/live_gas_analyzer/deletion_and_nullspace/Run()
	var/obj/machinery/portable_atmospherics/canister/target = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(scanner.melee_attack_chain(user, target, list()), "Initial scan must work.")
	target.moveToNullspace()
	TEST_ASSERT(!length(read_mixes()), "A nullspace target must not leave stale readings.")
	target.forceMove(run_loc_floor_bottom_left)
	TEST_ASSERT(length(read_mixes()) == 1, "A restored target must be read again.")
	qdel(target)
	TEST_ASSERT(!length(read_mixes()), "A deleted weak target must clear readings safely.")
	scanner.attack_self(user, list())
	scanner.moveToNullspace()
	TEST_ASSERT(!length(read_mixes()), "A nullspace device must not retain environment readings.")
	TEST_ASSERT(scanner.ui_status(user, scanner.ui_state(user)) == UI_CLOSE, "Unavailable device must close its UI.")

/datum/unit_test/live_gas_analyzer/viewer_access/Run()
	scanner.attack_self(user, list())
	TEST_ASSERT(length(read_mixes()) == 1, "Fixture must initially be able to read.")
	ADD_TRAIT(user, TRAIT_ILLITERATE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(!length(read_mixes()), "Losing literacy must remove readable data.")
	TEST_ASSERT(scanner.ui_status(user, scanner.ui_state(user)) == UI_CLOSE, "Losing literacy must close an already open UI.")
	REMOVE_TRAIT(user, TRAIT_ILLITERATE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(length(read_mixes()) == 1, "Restoring literacy must permit fresh readings.")
	var/obj/structure/closet/closed_container = allocate(__IMPLIED_TYPE__)
	scanner.forceMove(closed_container)
	TEST_ASSERT(!length(read_mixes()), "A scanner behind an inaccessible containment boundary must not expose data.")

/datum/unit_test/live_gas_analyzer/contained_target/Run()
	var/obj/item/tank/internals/oxygen/target = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(scanner.melee_attack_chain(user, target, list()), "Actual oxygen tank must be analyzable.")
	TEST_ASSERT(length(read_mixes()) == 1, "Tank must supply its single gas mixture.")
	var/obj/structure/closet/closed_container = allocate(__IMPLIED_TYPE__)
	target.forceMove(closed_container)
	TEST_ASSERT(!length(read_mixes()), "An already selected tank moved into a closed closet must become unreadable.")
	target.forceMove(run_loc_floor_bottom_left)
	TEST_ASSERT(length(read_mixes()) == 1, "Accessible tank must resume fresh readings.")

/datum/unit_test/live_gas_analyzer/cross_z/Run()
	var/obj/machinery/portable_atmospherics/canister/target = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(scanner.melee_attack_chain(user, target, list()), "Initial scan must work.")
	var/turf/other_level = locate(run_loc_floor_bottom_left.x, run_loc_floor_bottom_left.y, run_loc_floor_bottom_left.z == 1 ? 2 : 1)
	TEST_ASSERT(other_level, "The native integration map must provide another z-level.")
	target.forceMove(other_level)
	TEST_ASSERT(!length(read_mixes()), "Same x/y on another z-level must not leak readings.")

/datum/unit_test/live_gas_analyzer/reference_and_diagnostics/Run()
	scanner.attack_self(user, list())
	var/atom/previous = scanner.scan_target_ref.resolve()
	var/list/handbook = scanner.ui_static_data(user)
	TEST_ASSERT(handbook["gasInfo"] == GLOB.gas_handbook && handbook["reactionInfo"] == GLOB.reaction_handbook, "Both existing handbooks must remain available.")
	scanner.attack_self_secondary(user, list())
	TEST_ASSERT(scanner.open_requests == 2 && scanner.scan_target_ref.resolve() == previous, "Opening the handbook must preserve the selected reading.")
	scanner.cooldown = TRUE
	TEST_ASSERT(scanner.click_alt(user) == CLICK_ACTION_BLOCKING, "Barometer cooldown must still block activation.")
	scanner.cooldown = FALSE
	var/area/test_area = get_area(user)
	TEST_ASSERT(!test_area.outdoors, "Barometer regression fixture must be indoors.")
	TEST_ASSERT(scanner.click_alt(user) == CLICK_ACTION_BLOCKING && !scanner.cooldown, "Indoor barometer must retain its early return without starting a timer.")
	var/obj/item/assembly/signaler/anomaly/core = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(scanner.melee_attack_chain(user, core, list()), "Anomaly core diagnostic must still handle the tool action.")
	TEST_ASSERT(scanner.scan_target_ref.resolve() == previous && scanner.open_requests == 2, "Specialized diagnostics must not replace the gas selection or open a gas scan.")
	var/obj/effect/anomaly/anomaly = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(scanner.ranged_interact_with_atom(anomaly, user, list()) == ITEM_INTERACT_SUCCESS, "Anomaly effect diagnostic must retain its special ranged dispatch.")
	TEST_ASSERT(scanner.scan_target_ref.resolve() == previous && scanner.open_requests == 2, "Anomaly effect diagnostics must leave the live gas scan intact.")

/datum/unit_test/live_gas_analyzer/camera_upgrade/Run()
	var/obj/machinery/camera/camera = allocate(__IMPLIED_TYPE__)
	camera.panel_open = TRUE
	TEST_ASSERT(!camera.isXRay(TRUE), "Fixture camera must initially have no x-ray upgrade.")
	TEST_ASSERT(scanner.melee_attack_chain(user, camera, list()), "Real camera interaction must still consume the analyzer as an upgrade.")
	TEST_ASSERT(camera.isXRay(TRUE) && QDELETED(scanner), "The camera upgrade must retain its original effect and analyzer consumption.")
