//Straight ctrl+c -> ctrl+v of the clown rift and code, but with vermin
/datum/round_event_control/plague_rift
	name = "Plague rift"
	category = EVENT_CATEGORY_JANITORIAL
	description = "Opens up a rift and throws a mess of vermin and other filth out of it."
	typepath = /datum/round_event/plague_rift

	track = EVENT_TRACK_MODERATE
	tags = list(TAG_NEUTRAL)
	admin_setup = list(/datum/event_admin_setup/set_location/plague_rift
)

	weight = 8
	max_occurrences = 1

/datum/round_event/plague_rift
	announce_when = 8 EVENT_SECONDS
	start_when = 2 EVENT_SECONDS
	var/area/impact_area
	var/obj/effect/plague_rift/rift
	/// Admin selected location
	var/turf/impact_turf

/datum/round_event/plague_rift/setup()
	if(impact_turf)
		impact_area = get_area(impact_turf)
	else
		impact_area = find_area()
		impact_turf = get_valid_turf(impact_area)

/datum/round_event/plague_rift/start()
	rift = new /obj/effect/plague_rift(impact_turf)
	announce_to_ghosts(rift)

/datum/round_event/plague_rift/announce(fake)
	priority_announce("Enroachening energy impact detected at [impact_area.name].")

/datum/round_event/plague_rift/proc/find_area()
	var/static/list/allowed_areas
	if(isnull(allowed_areas))
		var/static/list/safe_area_types = typecacheof(list(
			/area/station/ai/satellite/chamber,
			/area/station/ai/upload/chamber,
			/area/station/science/ordnance/bomb,
			/area/station/solars,
			/area/station/maintenance,
			/area/station/commons/dorms,
		))
		allowed_areas = make_associative(GLOB.the_station_areas) - safe_area_types
	var/list/possible_areas = typecache_filter_list(GLOB.areas, allowed_areas)
	if (length(possible_areas))
		return pick(possible_areas)

/datum/round_event/plague_rift/proc/get_valid_turf(target_area)
	var/list/possible_turfs = list()
	for(var/turf/possible_turf as anything in get_area_turfs(target_area))
		if (isspaceturf(possible_turf))
			continue
		if (possible_turf.is_blocked_turf(exclude_mobs = TRUE))
			continue
		if (islava(possible_turf))
			continue
		if (ischasm(possible_turf))
			continue
		possible_turfs += possible_turf

	return pick(possible_turfs)

/datum/event_admin_setup/set_location/plague_rift
	input_text = "Spawn rift at your current area?"

/datum/event_admin_setup/set_location/plague_rift/apply_to_event(datum/round_event/plague_rift/event)
	event.impact_turf = chosen_turf


