#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)

/obj/item/stack/sheet/iron/ghost_cafe_only_test
	ghost_cafe_only = TRUE

/obj/structure/closet/ghost_cafe_only_test
	ghost_cafe_only = TRUE

/obj/item/crowbar/ghost_cafe_only_test
	ghost_cafe_only = TRUE

/// Deliberately not in the allowlist: accepting every holding subtype would be unsafe.
/area/centcom/holding/ghost_cafe_only_test

/// These tests move real objects between real areas, including nested containers.
/datum/unit_test/ghost_cafe_only
	abstract_type = /datum/unit_test/ghost_cafe_only
	var/turf/cafe_turf
	var/turf/condo_turf
	var/turf/outside_turf
	var/turf/holding_turf
	var/list/original_areas
	var/list/original_area_registry

/datum/unit_test/ghost_cafe_only/New()
	..()
	original_areas = list()
	original_area_registry = list()
	cafe_turf = run_loc_floor_bottom_left
	condo_turf = get_step(cafe_turf, EAST)
	outside_turf = get_step(condo_turf, EAST)
	holding_turf = get_step(outside_turf, EAST)
	// Record the room before creating private, location-free area fixtures.
	for(var/turf/tile as anything in list(cafe_turf, condo_turf, outside_turf, holding_turf))
		original_areas[tile] = get_area(tile)
	var/list/test_areas = list()
	test_areas[cafe_turf] = make_test_area(/area/centcom/holding/cafe)
	test_areas[condo_turf] = make_test_area(/area/misc/condo)
	test_areas[outside_turf] = make_test_area(/area/space)
	test_areas[holding_turf] = make_test_area(/area/centcom/holding/ghost_cafe_only_test)
	for(var/turf/tile as anything in test_areas)
		tile.change_area(original_areas[tile], test_areas[tile])

/datum/unit_test/ghost_cafe_only/Destroy()
	for(var/turf/tile as anything in original_areas)
		// Flush pending removals before re-adding the same turf to its original area.
		original_areas[tile]:get_turfs_by_zlevel(tile.z)
		tile.change_area(get_area(tile), original_areas[tile])
	original_areas = null
	. = ..()
	// Deleting UNIQUE_AREA fixtures clears this registry; restore its prior entries.
	for(var/area_type in original_area_registry)
		if(original_area_registry[area_type])
			GLOB.areas_by_type[area_type] = original_area_registry[area_type]
		else
			GLOB.areas_by_type -= area_type
	original_area_registry = null

/datum/unit_test/ghost_cafe_only/proc/make_test_area(area_type)
	original_area_registry[area_type] = GLOB.areas_by_type[area_type]
	allocated += new area_type()
	return allocated[allocated.len]

/// Let the normal timer subsystem run the deferred deletion, with a bounded wait.
/datum/unit_test/ghost_cafe_only/proc/deletion_finished(obj/object)
	var/deadline = world.time + 2 SECONDS
	while(!QDELETED(object) && world.time < deadline)
		sleep(world.tick_lag)
	return QDELETED(object)

/datum/unit_test/ghost_cafe_only/direct_movement/Run()
	var/obj/item/stack/sheet/iron/object = allocate(/obj/item/stack/sheet/iron/ghost_cafe_only_test, cafe_turf)
	TEST_ASSERT(object.Move(condo_turf), "Marked item should move normally into an infinidorm")
	TEST_ASSERT(!QDELETED(object), "Allowed cafe-to-infinidorm movement must preserve the item")
	TEST_ASSERT(object.Move(outside_turf), "Marked item should reach the outside boundary")
	TEST_ASSERT(deletion_finished(object), "A marked item moved outside must be deleted")

/datum/unit_test/ghost_cafe_only/forced_movement/Run()
	var/obj/structure/closet/object = allocate(/obj/structure/closet/ghost_cafe_only_test, cafe_turf)
	object.forceMove(outside_turf)
	TEST_ASSERT(deletion_finished(object), "A marked structure teleported outside must be deleted")

/datum/unit_test/ghost_cafe_only/nested_containers/Run()
	var/obj/item/storage/backpack/outer = allocate(/obj/item/storage/backpack, cafe_turf)
	var/obj/item/storage/backpack/inner = allocate(/obj/item/storage/backpack, outer)
	var/obj/item/crowbar/first = allocate(/obj/item/crowbar/ghost_cafe_only_test, inner)
	var/obj/item/crowbar/second = allocate(/obj/item/crowbar/ghost_cafe_only_test, inner)
	var/obj/item/crowbar/unmarked = allocate(/obj/item/crowbar, inner)
	outer.forceMove(condo_turf)
	TEST_ASSERT(!QDELETED(first) && !QDELETED(second), "Nested marked siblings must survive allowed movement")
	outer.forceMove(outside_turf)
	TEST_ASSERT(deletion_finished(first), "The first nested marked sibling must be deleted")
	TEST_ASSERT(deletion_finished(second), "Deletion must not skip another nested marked sibling")
	TEST_ASSERT(!QDELETED(outer) && !QDELETED(inner) && !QDELETED(unmarked), "Unmarked containers and siblings must survive")

/datum/unit_test/ghost_cafe_only/reparenting/Run()
	var/obj/item/storage/backpack/bag = allocate(/obj/item/storage/backpack, cafe_turf)
	var/obj/item/stack/sheet/iron/object = allocate(/obj/item/stack/sheet/iron/ghost_cafe_only_test, cafe_turf)
	object.forceMove(bag)
	object.forceMove(cafe_turf)
	object.forceMove(bag)
	bag.forceMove(outside_turf)
	TEST_ASSERT(deletion_finished(object), "Picking up and dropping an item must not lose nested area tracking")

/datum/unit_test/ghost_cafe_only/unmarked_objects/Run()
	var/obj/item/stack/sheet/iron/object = allocate(/obj/item/stack/sheet/iron, cafe_turf)
	TEST_ASSERT(!object.ghost_cafe_only, "Existing objects must default to unrestricted")
	object.forceMove(outside_turf)
	sleep(2 * world.tick_lag)
	TEST_ASSERT(!QDELETED(object), "An unmarked object must remain unaffected")

/datum/unit_test/ghost_cafe_only/unlisted_holding/Run()
	var/obj/item/stack/sheet/iron/object = allocate(/obj/item/stack/sheet/iron/ghost_cafe_only_test, cafe_turf)
	object.forceMove(holding_turf)
	TEST_ASSERT(deletion_finished(object), "An unrelated holding subarea must not be accepted by inheritance")

/datum/unit_test/ghost_cafe_only/nullspace/Run()
	var/obj/item/stack/sheet/iron/object = allocate(/obj/item/stack/sheet/iron/ghost_cafe_only_test, cafe_turf)
	object.moveToNullspace()
	sleep(2 * world.tick_lag)
	TEST_ASSERT(!QDELETED(object), "Temporary nullspace must not trigger recursive destruction")
	object.forceMove(outside_turf)
	TEST_ASSERT(deletion_finished(object), "Reappearing outside after nullspace must still delete the item")

/datum/unit_test/ghost_cafe_only/initial_outside_area/Run()
	var/obj/item/stack/sheet/iron/object = allocate(/obj/item/stack/sheet/iron/ghost_cafe_only_test, outside_turf)
	TEST_ASSERT(deletion_finished(object), "A marked object initialized outside must not remain available for use")

/datum/unit_test/ghost_cafe_only/trait_cleanup/Run()
	var/obj/item/stack/sheet/iron/object = allocate(/obj/item/stack/sheet/iron/ghost_cafe_only_test, cafe_turf)
	object.become_area_sensitive("ghost_cafe_only_test_other_source")
	object.RemoveElement(/datum/element/ghost_cafe_only)
	TEST_ASSERT(HAS_TRAIT(object, TRAIT_AREA_SENSITIVE), "Detaching must preserve another system's area sensitivity")
	object.lose_area_sensitivity("ghost_cafe_only_test_other_source")
	TEST_ASSERT(!HAS_TRAIT(object, TRAIT_AREA_SENSITIVE), "Detaching must remove only this element's trait source")
	TEST_ASSERT(!object.important_recursive_contents?[RECURSIVE_CONTENTS_AREA_SENSITIVE], "Detaching must leave no stale recursive entry")

/datum/unit_test/ghost_cafe_only/stack_merging/Run()
	var/obj/item/stack/sheet/iron/marked = allocate(/obj/item/stack/sheet/iron, cafe_turf, 5, FALSE)
	// Use an instance flag, as a mapper does, rather than a subtype that masks copy bugs.
	marked.ghost_cafe_only = TRUE
	marked.AddElement(/datum/element/ghost_cafe_only)
	var/obj/item/stack/sheet/iron/unmarked = allocate(/obj/item/stack/sheet/iron, cafe_turf, 5, FALSE)
	TEST_ASSERT(!marked.can_merge(unmarked), "Marked materials must not merge into unrestricted materials")
	TEST_ASSERT(!unmarked.can_merge(marked), "Unrestricted materials must not merge into marked materials")
	// Reagent crafting benches call merge() directly, without can_merge().
	TEST_ASSERT(!marked.merge(unmarked), "Direct machinery merging must not launder marked materials")
	TEST_ASSERT(!unmarked.merge(marked), "Direct reverse merging must also reject mixed restrictions")
	TEST_ASSERT(marked.amount == 5, "A rejected merge must preserve marked materials")
	TEST_ASSERT(unmarked.amount == 5, "A rejected merge must preserve unrestricted materials")
	marked.forceMove(outside_turf)
	unmarked.forceMove(outside_turf)
	TEST_ASSERT(deletion_finished(marked), "Marked materials must remain restricted after a merge attempt")
	TEST_ASSERT(!QDELETED(unmarked), "Unrestricted materials must remain unchanged")

/datum/unit_test/ghost_cafe_only/stack_splitting/Run()
	var/obj/item/stack/sheet/iron/marked = allocate(/obj/item/stack/sheet/iron, cafe_turf, 5, FALSE)
	marked.ghost_cafe_only = TRUE
	marked.AddElement(/datum/element/ghost_cafe_only)
	var/obj/item/stack/sheet/iron/split = marked.split_stack(2)
	TEST_ASSERT_NOTNULL(split, "A marked material stack should still split normally")
	allocated += split
	TEST_ASSERT(!initial(split.ghost_cafe_only), "This fixture must exercise a mapped instance flag")
	TEST_ASSERT(split.ghost_cafe_only, "Split materials must inherit the instance flag")
	split.forceMove(condo_turf)
	TEST_ASSERT(!QDELETED(split), "Split materials must survive inside an allowed area")
	split.forceMove(outside_turf)
	TEST_ASSERT(deletion_finished(split), "Splitting must not bypass the area restriction")

#endif
