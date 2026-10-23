/obj/item/analyzer
	/// Weakref to the atom whose gas mixture is currently being tracked in the UI
	var/datum/weakref/tracked_scan_target

/obj/item/analyzer/Destroy()
	STOP_PROCESSING(SSobj, src)
	tracked_scan_target = null
	return ..()

/obj/item/analyzer/process(seconds_per_tick)
	if(!LAZYLEN(open_uis) || !refresh_tracked_scan())
		tracked_scan_target = null
		return PROCESS_KILL

/// Returns the atom whose air should be read for a tracked target. Using the analyzer in hand tracks its surroundings.
/obj/item/analyzer/proc/get_air_source(atom/target)
	return target == src ? get_turf(src) : target

/// Refreshes the cached gasmix data from the tracked target while it remains valid and within scan range.
/obj/item/analyzer/proc/refresh_tracked_scan()
	var/atom/target = tracked_scan_target?.resolve()
	var/atom/air_source = get_air_source(target)
	var/turf/analyzer_turf = get_turf(src)
	var/turf/target_turf = get_turf(air_source)
	if(QDELETED(target) || QDELETED(air_source) || !analyzer_turf || !target_turf || analyzer_turf.z != target_turf.z || get_dist(analyzer_turf, target_turf) > ranged_scan_distance)
		return FALSE
	if(!air_source.return_analyzable_air())
		return FALSE
	on_analyze(src, air_source)
	return TRUE

/// Scans the target into the GasAnalyzer UI and starts live refreshing instead of printing to chat.
/obj/item/analyzer/proc/scan_to_ui(mob/user, atom/target)
	var/atom/air_source = get_air_source(target)
	if(!air_source?.return_analyzable_air())
		return FALSE
	if(isliving(user))
		playsound(user, SFX_INDUSTRIAL_SCAN, 20, TRUE, -2, TRUE, FALSE)
		user.visible_message(span_notice("[user] uses the analyzer on [icon2html(air_source, viewers(user))] [air_source]."), ignored_mobs = user)
	tracked_scan_target = WEAKREF(target)
	on_analyze(src, air_source)
	START_PROCESSING(SSobj, src)
	ui_interact(user)
	return TRUE
