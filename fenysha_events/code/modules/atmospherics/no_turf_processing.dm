/*
 * Hardcoded disable of atmospherics active-turf processing.
 *
 * The LINDA active-turf simulation (gas equalization between open turfs and the
 * excited-group machinery that drives it) is the single biggest source of lag
 * when map templates are loaded at runtime: every freshly loaded open turf gets
 * fed through add_to_active(), forms excited groups, and then churns through
 * process_cell() for many ticks until it settles.
 *
 * This is gated behind SSair.disable_turf_processing (default FALSE, so vanilla
 * atmospherics is untouched unless something flips the toggle on). Set it to TRUE
 * - e.g. before/around a heavy template load - to stop turf simulation from
 * spiking the server.
 *
 * Two overrides are needed because turfs reach the active list through two paths:
 *   - add_to_active()        -> the normal runtime entry point (fires, breaches,
 *                               atmos_spawn_air, shuttles, and crucially every
 *                               turf loaded by a template). No-oping this kills
 *                               the per-turf activation work itself.
 *   - process_active_turfs() -> the per-tick consumer. setup_allturfs() and a few
 *                               other places shove turfs onto active_turfs
 *                               directly (bypassing add_to_active), so we also
 *                               make the processing step itself a no-op to
 *                               guarantee zero CPU spent on turf simulation no
 *                               matter how a turf got onto the list.
 *
 * Pipenets, atmos machinery (vents/scrubbers/etc.), hotspots and the rest of
 * SSair are untouched - only turf-to-turf gas movement is disabled.
 */

/datum/controller/subsystem/air
	/// When TRUE, turf-to-turf gas simulation is disabled (see file header).
	/// Defaults to FALSE so vanilla atmospherics runs unless explicitly toggled,
	/// e.g. SSair.disable_turf_processing = TRUE.
	var/disable_turf_processing = TRUE

/// Never enroll a turf into active processing while disabled. See file header.
/datum/controller/subsystem/air/add_to_active(turf/open/activate, blockchanges = FALSE)
	if(disable_turf_processing)
		return
	return ..()

/// Skip spending a tick on active turfs while turf simulation is disabled.
/datum/controller/subsystem/air/process_active_turfs(resumed = FALSE)
	if(disable_turf_processing)
		return
	return ..()
