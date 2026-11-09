// Admin-configured vent clogs. All additions are scoped to the custom subtype.
#define CUSTOM_CLOG_PLUNGE_TIME (6 SECONDS)
#define CUSTOM_CLOG_SLOWEST_TICKS 25
#define CUSTOM_CLOG_MAX_LIVING 100
#define CUSTOM_CLOG_MAX_MINUTES 60
#define CUSTOM_CLOG_ANY_MOB "Any mob (search all types)..."

/datum/round_event_control/vent_clog/custom
	name = "Ventilation Clog: Custom"
	typepath = /datum/round_event/vent_clog/custom
	description = "Configure vent, spawn intervals, mob choices, population cap, and duration."
	weight = 0
	max_occurrences = 0
	earliest_start = 0
	min_wizard_trigger_potency = NEVER_TRIGGERED_BY_WIZARDS
	max_wizard_trigger_potency = NEVER_TRIGGERED_BY_WIZARDS
	admin_setup = list(/datum/event_admin_setup/vent_clog_custom)

// The Force Event panel prompts first. Other admin event interfaces may call run_event directly; those must also complete the same confirmation sequence.
/datum/round_event_control/vent_clog/custom/run_event(random = FALSE, announce_chance_override = null, admin_forced = FALSE, event_cause)
	if(!admin_forced || !usr?.client || !check_rights(R_FUN, FALSE))
		return
	var/datum/event_admin_setup/vent_clog_custom/custom_setup = admin_setup[1]
	if(!custom_setup.configurations[usr.ckey])
		if(custom_setup.prompt_admins() == ADMIN_CANCEL_EVENT)
			return
	return ..()

/// One invocation's selections. No vent or mob is changed until Start is confirmed.
/datum/vent_clog_custom_configuration
	var/datum/weakref/vent_reference
	var/minimum_interval
	var/maximum_interval
	var/maximum_living = 10
	var/duration = 10 MINUTES
	var/list/mob_types = list()

/// Match the normal vent eligibility rules, and do not share an existing clog.
/proc/is_available_custom_clog_vent(obj/machinery/atmospherics/components/unary/vent_pump/candidate, datum/round_event/vent_clog/ignored_event)
	if(QDELETED(candidate) || candidate.welded)
		return FALSE
	var/turf/vent_turf = get_turf(candidate)
	var/area/vent_area = get_area(candidate)
	if(!vent_turf || !is_station_level(vent_turf.z) || !istype(vent_area, /area/station))
		return FALSE
	if(is_type_in_list(vent_area, GLOB.expected_erp_areas) || vent_turf.is_blocked_turf_ignore_climbable())
		return FALSE
	for(var/datum/round_event/vent_clog/other_clog as anything in SSevents.running)
		if(istype(other_clog) && other_clog != ignored_event && other_clog.vent == candidate)
			return FALSE
	return TRUE

/datum/round_event/vent_clog/custom
	fakeable = FALSE
	announce_when = 0
	/// Admin setup must explicitly authorize this event before it can start.
	var/configured = FALSE
	/// Bounds in event ticks, not deciseconds; converted from seconds during setup.
	var/minimum_spawn_ticks
	var/maximum_spawn_ticks
	var/configured_duration
	/// Real world.time deadline. No activeFor modulo, so there is no early second spawn.
	var/next_spawn_time
	var/list/mob_types = list()

/datum/round_event/vent_clog/custom/setup()
	// Do not call the normal setup: it randomizes the vent and overwrites the choices.
	if(!configured || !length(mob_types) || !is_available_custom_clog_vent(vent, src))
		kill()
		return
	end_when = CEILING(configured_duration, SSevents.wait) / SSevents.wait
	filth_spawn_types = list(
		/obj/effect/decal/cleanable/vomit,
		/obj/effect/decal/cleanable/insectguts,
		/obj/effect/decal/cleanable/blood/oil,
	)

/datum/round_event/vent_clog/custom/start()
	if(!configured || !is_available_custom_clog_vent(vent, src))
		kill()
		return
	. = ..()
	schedule_next_spawn()

/datum/round_event/vent_clog/custom/announce(fake)
	if(QDELETED(vent))
		return
	priority_announce("Unknown biological obstruction detected in the ventilation network. Blockage is believed to be in the [get_area_name(vent)].", "Ventilation Alert")

/datum/round_event/vent_clog/custom/tick()
	if(QDELETED(vent) || !get_turf(vent))
		kill()
		return
	if(world.time < next_spawn_time)
		return
	life_check()
	if(length(living_mobs) < maximum_spawns)
		produce_mob()
	schedule_next_spawn()

/datum/round_event/vent_clog/custom/proc/schedule_next_spawn()
	spawn_delay = rand(minimum_spawn_ticks, maximum_spawn_ticks)
	next_spawn_time = world.time + spawn_delay * SSevents.wait

/datum/round_event/vent_clog/custom/produce_mob()
	if(!configured || !length(mob_types) || QDELETED(vent))
		return
	spawned_mob = pick(mob_types)
	return ..()

// Keep the exact vent chosen by the admin: destruction ends this event.
/datum/round_event/vent_clog/custom/vent_move(datum/source)
	SIGNAL_HANDLER
	kill()

/datum/round_event/vent_clog/custom/end()
	if(vent)
		clear_signals()
	return ..()

// A plunge can finish after expiry, or after another janitor already cleared this clog. The parent callback must not unregister signals from a null vent.
/datum/round_event/vent_clog/custom/clear_signals()
	if(vent)
		return ..()

// The parent kill only stops processing. Also remove vent callbacks on every exit, including plunging, external cancellation, and vent destruction.
/datum/round_event/vent_clog/custom/kill()
	if(vent)
		clear_signals()
	vent = null
	living_mobs.Cut()
	return ..()

/datum/event_admin_setup/vent_clog_custom
	/// Confirmed, single-use configurations, isolated by admin ckey.
	var/list/configurations = list()

/datum/event_admin_setup/vent_clog_custom/prompt_admins()
	var/mob/admin = usr
	if(!admin?.client || !check_rights(R_FUN, FALSE))
		return ADMIN_CANCEL_EVENT
	configurations -= admin.ckey
	var/datum/vent_clog_custom_configuration/configuration = new
	var/list/vent_choices = list()
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/candidate as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/atmospherics/components/unary/vent_pump))
		if(!is_available_custom_clog_vent(candidate))
			continue
		var/turf/vent_turf = get_turf(candidate)
		var/label = "[get_area_name(candidate)] - [candidate.id_tag || candidate.name] ([vent_turf.x], [vent_turf.y], [vent_turf.z]) #[length(vent_choices) + 1]"
		vent_choices[label] = WEAKREF(candidate)
	if(!length(vent_choices))
		to_chat(admin, span_warning("Custom vent clog cancelled: no eligible station vents are available."))
		return ADMIN_CANCEL_EVENT
	var/chosen_vent = tgui_input_list(admin, "Choose a vent. Search by area name, vent ID, or coordinates. Ineligiible vents are excluded.", event_control.name, sort_list(vent_choices))
	if(isnull(chosen_vent))
		return ADMIN_CANCEL_EVENT
	configuration.vent_reference = vent_choices[chosen_vent]

	var/tick_seconds = SSevents.wait / (1 SECONDS)
	var/minimum_ticks = CEILING(CUSTOM_CLOG_PLUNGE_TIME, SSevents.wait) / SSevents.wait
	var/minimum_seconds = minimum_ticks * tick_seconds
	var/maximum_seconds = CUSTOM_CLOG_SLOWEST_TICKS * tick_seconds
	var/timing_help = "Plunging takes 6 seconds. Normal minor clogs spawn every [10 * tick_seconds]-[15 * tick_seconds] seconds; the slowest default is [maximum_seconds] seconds. Inputs round UP to the next event tick ([tick_seconds] seconds)."
	var/minimum_interval = prompt_number(admin, "Minimum seconds between spawn attempts ([minimum_seconds]-[maximum_seconds]). [timing_help]", 10 * tick_seconds, maximum_seconds, minimum_seconds)
	if(isnull(minimum_interval))
		return ADMIN_CANCEL_EVENT
	configuration.minimum_interval = CEILING(minimum_interval SECONDS, SSevents.wait) / SSevents.wait
	var/maximum_interval = prompt_number(admin, "Maximum seconds between spawn attempts ([configuration.minimum_interval * tick_seconds]-[maximum_seconds]). Use the same value as the minimum for a fixed interval. [timing_help]", max(15 * tick_seconds, configuration.minimum_interval * tick_seconds), maximum_seconds, configuration.minimum_interval * tick_seconds)
	if(isnull(maximum_interval))
		return ADMIN_CANCEL_EVENT
	configuration.maximum_interval = CEILING(maximum_interval SECONDS, SSevents.wait) / SSevents.wait
	configuration.maximum_living = prompt_number(admin, "Maximum living mobs produced by this clog at once (1-[CUSTOM_CLOG_MAX_LIVING]).", 10, CUSTOM_CLOG_MAX_LIVING, 1)
	if(isnull(configuration.maximum_living))
		return ADMIN_CANCEL_EVENT
	var/duration_minutes = prompt_number(admin, "Maximum event duration in minutes (1-[CUSTOM_CLOG_MAX_MINUTES]).", 10, CUSTOM_CLOG_MAX_MINUTES, 1)
	if(isnull(duration_minutes))
		return ADMIN_CANCEL_EVENT
	configuration.duration = duration_minutes MINUTES

	while(TRUE)
		var/mob_type = prompt_mob(admin)
		if(isnull(mob_type))
			return ADMIN_CANCEL_EVENT
		configuration.mob_types |= mob_type
		var/add_another = tgui_alert(admin, "Selected [length(configuration.mob_types)] unique mob type(s). Add another?", event_control.name, list("Yes", "No", "Cancel"))
		if(add_another == "No")
			break
		if(add_another != "Yes")
			return ADMIN_CANCEL_EVENT

	var/obj/machinery/atmospherics/components/unary/vent_pump/selected_vent = configuration.vent_reference.resolve()
	if(!is_available_custom_clog_vent(selected_vent))
		to_chat(admin, span_warning("Custom vent clog cancelled: the selected vent is no longer available."))
		return ADMIN_CANCEL_EVENT
	var/turf/selected_turf = get_turf(selected_vent)
	var/list/summary = list(
		"Vent: [get_area_name(selected_vent)] - [selected_vent.id_tag || selected_vent.name] ([selected_turf.x], [selected_turf.y], [selected_turf.z])",
		"Spawn interval: [configuration.minimum_interval * tick_seconds]-[configuration.maximum_interval * tick_seconds] seconds",
		"Maximum living mobs: [configuration.maximum_living]",
		"Maximum duration: [duration_minutes] minutes",
		"One mob spawns immediately. Later spawns choose randomly from:",
	)
	for(var/mob/mob_type as anything in configuration.mob_types)
		summary += "[initial(mob_type.name)] ([mob_type])"
	var/confirmation = tgui_alert(admin, summary.Join("\n"), "Confirm [event_control.name]", list("Start", "Cancel"))
	if(confirmation != "Start")
		return ADMIN_CANCEL_EVENT
	// All input procs sleep. Recheck permission and the vent after the last one.
	if(!admin.client || !check_rights(R_FUN, FALSE) || !is_available_custom_clog_vent(selected_vent))
		to_chat(admin, span_warning("Custom vent clog cancelled: permission or vent availability changed."))
		return ADMIN_CANCEL_EVENT
	configurations[admin.ckey] = configuration

/datum/event_admin_setup/vent_clog_custom/apply_to_event(datum/round_event/vent_clog/custom/event)
	var/datum/vent_clog_custom_configuration/configuration = configurations[usr.ckey]
	configurations -= usr.ckey
	if(!configuration)
		return
	event.vent = configuration.vent_reference.resolve()
	event.minimum_spawn_ticks = configuration.minimum_interval
	event.maximum_spawn_ticks = configuration.maximum_interval
	event.maximum_spawns = configuration.maximum_living
	event.configured_duration = configuration.duration
	event.mob_types = configuration.mob_types.Copy()
	event.configured = TRUE
	log_admin("[key_name(usr)] configured a custom vent clog at [AREACOORD(event.vent)]: intervals [configuration.minimum_interval * SSevents.wait / (1 SECONDS)]-[configuration.maximum_interval * SSevents.wait / (1 SECONDS)] seconds, living cap [event.maximum_spawns], duration [configuration.duration / (1 MINUTES)] minutes, mobs [configuration.mob_types.Join(", ")].")

/// Preserve cancellation with native inputs too: tgui_input_number's legacy fallback clamps null to the minimum, losing the user's Cancel action.
/datum/event_admin_setup/vent_clog_custom/proc/prompt_number(mob/admin, message, default_value, maximum_value, minimum_value)
	if(!admin.client)
		return null
	if(admin.client.prefs.read_preference(/datum/preference/toggle/tgui_input))
		return tgui_input_number(admin, message, event_control.name, default_value, maximum_value, minimum_value)
	var/chosen_number = input(admin, message, event_control.name, default_value) as null|num
	if(isnull(chosen_number))
		return null
	return clamp(round(chosen_number), minimum_value, maximum_value)

/datum/event_admin_setup/vent_clog_custom/proc/prompt_mob(mob/admin)
	var/list/mob_choices = list()
	for(var/mob/mob_type as anything in get_standard_mob_types())
		mob_choices["[initial(mob_type.name)] ([mob_type])"] = mob_type
	mob_choices = sort_list(mob_choices)
	// Deliberately append the custom choice last, below the standard clog mobs.
	mob_choices[CUSTOM_CLOG_ANY_MOB] = CUSTOM_CLOG_ANY_MOB
	var/chosen = tgui_input_list(admin, "Choose a standard vent clog mob or search all mob types.", event_control.name, mob_choices)
	if(isnull(chosen))
		return null
	var/mob_type = mob_choices[chosen]
	if(mob_type == CUSTOM_CLOG_ANY_MOB)
		var/list/all_mobs = get_all_mob_choices()
		var/chosen_custom = tgui_input_list(admin, "Search by mob name or type path.", event_control.name, all_mobs)
		if(isnull(chosen_custom))
			return null
		mob_type = all_mobs[chosen_custom]
	if(!ispath(mob_type, /mob) || (mob_type in get_abstract_types()))
		to_chat(admin, span_warning("Custom vent clog cancelled: that is not a concrete mob type."))
		return null
	return mob_type

/datum/event_admin_setup/vent_clog_custom/proc/get_all_mob_choices()
	var/static/list/all_mobs
	if(isnull(all_mobs))
		all_mobs = list()
		for(var/mob/mob_type as anything in valid_subtypesof(/mob))
			all_mobs["[initial(mob_type.name)] ([mob_type])"] = mob_type
		all_mobs = sort_list(all_mobs)
	return all_mobs

/// Union of Minor, Major, Critical, Strange, and Bubber's Extreme presets.
/datum/event_admin_setup/vent_clog_custom/proc/get_standard_mob_types()
	return list(
		/mob/living/basic/butterfly,
		/mob/living/basic/cockroach,
		/mob/living/basic/cockroach/bloodroach,
		/mob/living/basic/spider/maintenance,
		/mob/living/basic/mouse,
		/mob/living/basic/snail,
		/mob/living/basic/clown_bug,
		/mob/living/basic/bee,
		/mob/living/basic/cockroach/hauberoach,
		/mob/living/basic/spider/giant,
		/mob/living/basic/mouse/rat,
		/mob/living/basic/bee/toxin,
		/mob/living/basic/carp,
		/mob/living/basic/cockroach/glockroach,
		/mob/living/basic/bear,
		/mob/living/basic/cockroach/glockroach/mobroach,
		/mob/living/basic/goose,
		/mob/living/basic/lightgeist,
		/mob/living/basic/mothroach,
		/mob/living/basic/mushroom,
		/mob/living/basic/viscerator,
		/mob/living/basic/pet/gondola,
		/mob/living/basic/slime/random,
		/mob/living/basic/mining/cazador,
		/mob/living/basic/mining/scorpion,
	)

#undef CUSTOM_CLOG_PLUNGE_TIME
#undef CUSTOM_CLOG_SLOWEST_TICKS
#undef CUSTOM_CLOG_MAX_LIVING
#undef CUSTOM_CLOG_MAX_MINUTES
#undef CUSTOM_CLOG_ANY_MOB
