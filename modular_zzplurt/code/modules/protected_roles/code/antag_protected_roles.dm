/**
 * Jobs that should not roll antagonist.
 *
 * Populates SSstation.antag_protected_roles, which storyteller always merges into
 * restricted_roles (unlike protected_roles on antagonist events, which is config-gated).
 * Replaces the old unused antagonist_restricted job var removed in Bubber #5930.
 */
/datum/controller/subsystem/processing/station/Initialize()
	. = ..()
	antag_protected_roles |= list(
		/datum/job/allamerican::title,
		JOB_BRIDGE_ASSISTANT,
		JOB_HUMAN_AI,
		JOB_SECURITY_CYBORG,
		JOB_VETERAN_ADVISOR,
	)
