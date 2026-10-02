/datum/unit_test/motorized_wheelchair
	abstract_type = /datum/unit_test/motorized_wheelchair

/// Check the actual vehicle, stock parts, power cell, and occupied starting turf.
/datum/unit_test/motorized_wheelchair/proc/check_wheelchair(mob/living/carbon/human/holder)
	TEST_ASSERT(istype(holder.buckled, /obj/vehicle/ridden/wheelchair/motorized), "The holder should be buckled to a motorized wheelchair.")
	var/obj/vehicle/ridden/wheelchair/motorized/wheels = holder.buckled
	TEST_ASSERT_NOTNULL(wheels.power_cell, "The starting wheelchair should have a power cell.")
	TEST_ASSERT_EQUAL(length(wheels.component_parts), 3, "The starting wheelchair should have three stock parts.")
	var/servos = 0
	var/capacitors = 0
	for(var/datum/stock_part/part as anything in wheels.component_parts)
		TEST_ASSERT_EQUAL(part.tier, 1, "Starting wheelchair parts should be tier 1.")
		if(istype(part, /datum/stock_part/servo))
			servos++
		if(istype(part, /datum/stock_part/capacitor))
			capacitors++
	TEST_ASSERT_EQUAL(servos, 2, "The starting wheelchair should have two servos.")
	TEST_ASSERT_EQUAL(capacitors, 1, "The starting wheelchair should have one capacitor.")
	TEST_ASSERT_EQUAL(wheels.speed, 3, "Wheelchair speed should reflect its tier 1 servos.")
	TEST_ASSERT_EQUAL(wheels.power_efficiency, 1, "Wheelchair efficiency should reflect its tier 1 capacitor.")
	var/wheelchair_count = 0
	for(var/obj/vehicle/ridden/wheelchair/chair in get_turf(holder))
		if(!QDELETED(chair))
			wheelchair_count++
	TEST_ASSERT_EQUAL(wheelchair_count, 1, "The holder should start with exactly one wheelchair.")
	return wheels

/datum/unit_test/motorized_wheelchair/standalone

/datum/unit_test/motorized_wheelchair/standalone/Run()
	var/mob/living/carbon/human/holder = allocate(/mob/living/carbon/human/consistent)
	holder.add_quirk(/datum/quirk/motorized_wheelchair)
	var/datum/quirk/motorized_wheelchair/quirk = holder.get_quirk(/datum/quirk/motorized_wheelchair)
	TEST_ASSERT_EQUAL(quirk.value, 3, "The motorized wheelchair should cost three positive quirk points.")
	var/obj/vehicle/ridden/wheelchair/motorized/wheels = check_wheelchair(holder)
	TEST_ASSERT_NOTNULL(wheels, "The standalone quirk should supply a working wheelchair.")
	TEST_ASSERT_EQUAL(wheels.power_cell.charge, wheels.power_cell.maxcharge, "The starting power cell should be fully charged.")

/datum/unit_test/motorized_wheelchair/paraplegic_first

/datum/unit_test/motorized_wheelchair/paraplegic_first/Run()
	var/mob/living/carbon/human/holder = allocate(/mob/living/carbon/human/consistent)
	holder.add_quirk(/datum/quirk/paraplegic)
	var/obj/vehicle/ridden/wheelchair/manual_chair = holder.buckled
	holder.add_quirk(/datum/quirk/motorized_wheelchair)
	check_wheelchair(holder)
	TEST_ASSERT(QDELETED(manual_chair), "The original manual wheelchair should be replaced.")
	TEST_ASSERT(holder.has_trauma_type(/datum/brain_trauma/severe/paralysis/paraplegic), "Paraplegic should retain its paralysis trauma.")

/datum/unit_test/motorized_wheelchair/motorized_first

/datum/unit_test/motorized_wheelchair/motorized_first/Run()
	var/mob/living/carbon/human/holder = allocate(/mob/living/carbon/human/consistent)
	holder.add_quirk(/datum/quirk/motorized_wheelchair)
	var/obj/vehicle/ridden/wheelchair/motorized/original_chair = check_wheelchair(holder)
	TEST_ASSERT_NOTNULL(original_chair, "The motorized quirk should create its starting wheelchair.")
	var/obj/item/stock_parts/power_store/original_cell = original_chair.power_cell
	original_cell.charge -= original_chair.energy_usage
	var/remaining_charge = original_cell.charge
	holder.add_quirk(/datum/quirk/paraplegic)
	check_wheelchair(holder)
	TEST_ASSERT_EQUAL(holder.buckled, original_chair, "Paraplegic should reuse the original motorized wheelchair.")
	TEST_ASSERT_EQUAL(original_chair.power_cell, original_cell, "Reusing the wheelchair should keep its original cell.")
	TEST_ASSERT_EQUAL(original_cell.charge, remaining_charge, "Reusing the wheelchair should preserve its charge.")
	TEST_ASSERT(holder.has_trauma_type(/datum/brain_trauma/severe/paralysis/paraplegic), "Paraplegic should retain its paralysis trauma.")

/datum/unit_test/motorized_wheelchair/arrivals_seat

/datum/unit_test/motorized_wheelchair/arrivals_seat/Run()
	var/mob/living/carbon/human/holder = allocate(/mob/living/carbon/human/consistent)
	var/obj/structure/chair/arrival_seat = allocate(/obj/structure/chair)
	arrival_seat.setDir(EAST)
	arrival_seat.buckle_mob(holder)
	TEST_ASSERT_EQUAL(holder.buckled, arrival_seat, "The test passenger should start in the arrival seat.")
	holder.add_quirk(/datum/quirk/motorized_wheelchair)
	var/obj/vehicle/ridden/wheelchair/motorized/wheels = check_wheelchair(holder)
	TEST_ASSERT_NOTNULL(wheels, "The arrival passenger should receive a motorized wheelchair.")
	TEST_ASSERT_EQUAL(wheels.dir, EAST, "The wheelchair should face the same way as the arrival seat.")
	TEST_ASSERT(!QDELETED(arrival_seat), "The arrival seat should remain on the shuttle.")

/datum/unit_test/motorized_wheelchair/manual_default

/datum/unit_test/motorized_wheelchair/manual_default/Run()
	var/mob/living/carbon/human/holder = allocate(/mob/living/carbon/human/consistent)
	holder.add_quirk(/datum/quirk/paraplegic)
	TEST_ASSERT_NOTNULL(holder.buckled, "Paraplegic should still supply a starting wheelchair.")
	TEST_ASSERT_EQUAL(holder.buckled.type, /obj/vehicle/ridden/wheelchair, "Paraplegic alone should keep the manual starting wheelchair.")

/datum/unit_test/motorized_wheelchair/transfer

/datum/unit_test/motorized_wheelchair/transfer/Run()
	var/mob/living/carbon/human/holder = allocate(/mob/living/carbon/human/consistent)
	var/datum/quirk/motorized_wheelchair/quirk = allocate(/datum/quirk/motorized_wheelchair)
	quirk.add_to_holder(holder, quirk_transfer = TRUE)
	TEST_ASSERT_NULL(holder.buckled, "A transferred quirk should keep one-time spawn effects skipped.")
	TEST_ASSERT_NULL(locate(/obj/vehicle/ridden/wheelchair) in get_turf(holder), "A transferred quirk should leave the starting turf clear of new wheelchairs.")
