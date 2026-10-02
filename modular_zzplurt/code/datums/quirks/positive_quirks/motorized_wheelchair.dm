/datum/quirk/motorized_wheelchair
	name = "Motorized Wheelchair"
	desc = "You start with a motorized wheelchair equipped with a charged cell and basic parts."
	icon = FA_ICON_CAR_BATTERY
	value = 3
	gain_text = span_notice("Your motorized wheelchair is ready.")
	medical_record_text = "Patient uses a motorized wheelchair for mobility."
	/// Reuse the starting wheelchair when Paraplegic is applied after this quirk.
	var/datum/weakref/wheelchair_ref

/datum/quirk/motorized_wheelchair/add_unique(client/client_source)
	var/turf/holder_turf = get_turf(quirk_holder)
	var/atom/movable/previous_seat = quirk_holder.buckled
	var/obj/structure/chair/spawn_chair = locate() in holder_turf
	var/seat_direction = previous_seat?.dir || spawn_chair?.dir
	if(previous_seat)
		previous_seat.unbuckle_mob(quirk_holder)

	var/obj/vehicle/ridden/wheelchair/motorized/wheels = get_wheelchair(holder_turf)
	if(seat_direction)
		wheels.setDir(seat_direction)
	wheels.buckle_mob(quirk_holder)

	// Replace the manual starting wheelchair when Paraplegic was applied first.
	if(quirk_holder.has_quirk(/datum/quirk/paraplegic) && (previous_seat?.type in list(/obj/vehicle/ridden/wheelchair, /obj/vehicle/ridden/wheelchair/gold)))
		qdel(previous_seat)

/// Returns the starting wheelchair, keeping its existing cell and parts when reused.
/datum/quirk/motorized_wheelchair/proc/get_wheelchair(turf/spawn_turf)
	var/obj/vehicle/ridden/wheelchair/motorized/wheels = wheelchair_ref?.resolve()
	if(QDELETED(wheels))
		wheels = new(spawn_turf)
		wheelchair_ref = WEAKREF(wheels)
	else
		wheels.forceMove(spawn_turf)
	return wheels

/datum/quirk/paraplegic/create_wheelchair(client/client_source, turf/spawn_turf)
	var/datum/quirk/motorized_wheelchair/motorized_quirk = quirk_holder.get_quirk(/datum/quirk/motorized_wheelchair)
	if(motorized_quirk)
		return motorized_quirk.get_wheelchair(spawn_turf)
	return ..()
