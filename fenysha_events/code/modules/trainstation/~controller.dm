#define DEFAULT_TRANSITION (/datum/moving_turf_transition/plain_snow)

/datum/map_config
	// Whether this map is a train map
	var/trainstation = FALSE

SUBSYSTEM_DEF(train_controller)
	name = "Train Controller"
	wait = 1 SECONDS

	dependencies = list(
		/datum/controller/subsystem/mapping,
		/datum/controller/subsystem/daylight,
	)

	/// The global map along which the train moves
	VAR_FINAL/datum/train_global_map/global_map = null
	/// List of all known and loaded stations
	VAR_FINAL/list/known_stations = list()
	/// Stations sorted by region (only visible and non-abstract)
	VAR_FINAL/list/stations_by_regions = list()
	/// Order of regions for traversal (shuffled each time stations are connected)
	VAR_FINAL/list/region_order = list()
	/// Threat levels in numeric form for sorting
	VAR_FINAL/threat_levels_by_number = list(
		THREAT_LEVEL_SAFE = 0,
		THREAT_LEVEL_RISKY = 1,
		THREAT_LEVEL_DANGEROUS = 2,
		THREAT_LEVEL_HAZARDOUS = 3,
		THREAT_LEVEL_DEADLY = 4,
	)
	/// The station the train plans to arrive at next
	var/datum/train_station/planned_to_load = null
	/// The currently loaded station
	var/datum/train_station/loaded_station = null

	/// Direction of the train's movement (visual, for effects)
	var/abstract_moving_direction = EAST
	/// Whether movement is allowed without a working engine
	VAR_PRIVATE/no_engine_mode = FALSE
	VAR_PRIVATE/moving = FALSE
	VAR_PRIVATE/datum/looping_sound/global_sound/train_sound_loop/soundloop

	/// Whether train mode is active (turned off at round end, etc.)
	var/mode_active = FALSE

	/// List of active train events
	var/list/running_events

	/// List of station control terminals
	var/list/station_terminals

	/// How soon we want to change transition or reset it
	var/next_transition_time = 0
	/// The currently selected theme for objects/effects while the train is moving
	var/datum/train_object_spawner_theme/selected_theme = null
	/// Current transition theme, for auto_icon moving turfs
	var/datum/moving_turf_transition/transition_theme = null

	/// Reference to the train engine (turbine core)
	var/obj/machinery/power/train_turbine/core_rotor/train_engine = null
	/// Flag: a station is currently being loaded or unloaded
	var/loading = FALSE

	var/tain_starting = FALSE
	/// Minimum time between stations (even with a short distance on the map)
	var/minimum_travel_time = 7 MINUTES
	var/maximum_travel_time = 30 MINUTES
	/// How long it takes to move 1 unit of distance on the global map
	var/time_per_map_unit = 4 SECONDS
	/// Time remaining until the next station
	var/time_to_next_station
	/// Total travel time to the next station
	var/total_travel_time
	/// How many stations have already been visited this round
	var/stations_visited = 0
	/// The last real station the train departed from (for correct display on the map)
	var/datum/train_station/last_departed_station = null

/**
 * Getters
 */

/datum/controller/subsystem/train_controller/proc/is_moving()
	return moving

/datum/controller/subsystem/train_controller/proc/allow_spawning()
	if(loading)
		return FALSE
	if(loaded_station?.station_flags & TRAINSTATION_NO_SPAWNING)
		return FALSE
	if(transition_theme && transition_theme.transition)
		return FALSE

	return TRUE

/datum/controller/subsystem/train_controller/proc/check_trainstation()
	if(!SSmapping.current_map)
		return FALSE
	if(!SSmapping.current_map.trainstation)
		return FALSE
	return TRUE

/**
 * Initialization and loading
 */

/datum/controller/subsystem/train_controller/Initialize()
	var/list/map_traits = SSmapping.current_map.traits[1]
	if(!map_traits || !islist(map_traits))
		return
	var/is_trainstation = map_traits[ZTRAIT_TRAINSTATION] || FALSE
	if(!is_trainstation)
		return SS_INIT_NO_NEED

	mode_active = TRUE
	global_map = new()
	update_tittle_screen()
	running_events = list()
	soundloop = new(start_immediately = FALSE)
	RegisterSignal(SSticker, COMSIG_TICKER_ENTER_PREGAME, PROC_REF(on_enter_pregame))
	RegisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING, PROC_REF(on_round_start))
	RegisterSignal(SSdcs, COMSIG_GLOBAL_PLAYER_SETUP_FINISHED, PROC_REF(on_player_join))
	load_stations()
	connect_stations()
	global_map.generate()
	load_map()


/datum/controller/subsystem/train_controller/proc/on_player_join(datum/dcs, mob/living/joining)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(teleport_to_train), joining)

/datum/controller/subsystem/train_controller/proc/teleport_to_train(mob/living/joining)
	var/job_spawn_title = joining?.mind?.assigned_role?.title
	var/obj/effect/landmark/start/spawnpoint
	var/obj/effect/landmark/reserv_spawnpoint = null
	for(var/obj/effect/landmark/start/spawn_point as anything in GLOB.start_landmarks_list)
		if(spawn_point.name == job_spawn_title)
			spawnpoint = spawn_point
	if(!spawnpoint)
		reserv_spawnpoint = locate(/obj/effect/landmark/trainstation/crew_spawnpoint) in GLOB.landmarks_list
	var/turf/target_turf = spawnpoint ? get_turf(spawnpoint) : get_turf(reserv_spawnpoint)
	if(!target_turf)
		message_admins("Failed to spawn new character for [ADMIN_LOOKUPFLW(joining)]")
		return
	joining.forceMove(target_turf)

/datum/controller/subsystem/train_controller/proc/load_stations()
	for(var/path in subtypesof(/datum/train_station))
		known_stations += new path

/datum/controller/subsystem/train_controller/proc/connect_stations()
	if(!length(known_stations))
		return

	var/list/all_stations = known_stations.Copy()
	var/list/sort_by_region = list()

	for(var/datum/train_station/station in all_stations)
		if(!station.visible || (station.station_flags & TRAINSTATION_ABSCTRACT))
			continue
		if(!sort_by_region[station.region])
			sort_by_region[station.region] = list()
		sort_by_region[station.region] += station

	stations_by_regions.Cut()
	for(var/region in sort_by_region)
		var/list/sorted = sort_by_region[region]
		stations_by_regions[region] = sorted.Copy()

	for(var/region in stations_by_regions)
		var/list/region_stations = stations_by_regions[region]
		if(!length(region_stations))
			continue

		var/list/threat_groups = list()
		for(var/datum/train_station/S in region_stations)
			var/threat_num = threat_levels_by_number[S.threat_level] || 0
			if(!threat_groups[num2text(threat_num)])
				threat_groups[num2text(threat_num)] = list()
			threat_groups[num2text(threat_num)] += S

		var/list/ordered = list()
		for(var/threat_num in 0 to 4)
			if(threat_groups[num2text(threat_num)])
				ordered += threat_groups[num2text(threat_num)]
		stations_by_regions[region] = ordered

	var/list/region_keys = list()
	for(var/r in stations_by_regions)
		region_keys += r
	region_order = shuffle(region_keys)

	for(var/datum/train_station/TS in known_stations)
		TS.connect_stations()

/datum/controller/subsystem/train_controller/proc/pick_final_station()
	var/list/candidates = list()
	for(var/datum/train_station/S in known_stations)
		if(!S.visible)
			continue
		if(S.station_flags & TRAINSTATION_ABSCTRACT)
			continue
		if(!(S.station_flags & TRAINSTATION_FINAL_STATION))
			continue
		candidates += S

	if(!length(candidates))
		return null

	return pick(candidates)

/datum/controller/subsystem/train_controller/proc/load_map()
	load_train()
	load_startpoint()

/datum/controller/subsystem/train_controller/proc/load_train()
	var/datum/map_template/train/train_template = new()
	var/obj/effect/landmark/trainstation/train_spawnpoint/spawnpoint = locate() in GLOB.landmarks_list
	if(!spawnpoint || !istype(spawnpoint))
		stack_trace("Failed to load train, no available spawnpoints!")
		return
	var/turf/actual_spawnpoint = get_turf(spawnpoint)
	if(!actual_spawnpoint)
		stack_trace("Failed to load train, spawnpoint out of bounds!")
		return
	train_template.load(actual_spawnpoint, centered = FALSE)

/datum/controller/subsystem/train_controller/proc/load_startpoint()
	load_station(/datum/train_station/abandoned_depo, stop_moving = FALSE, hide_for_players = FALSE, announce = FALSE)

/datum/controller/subsystem/train_controller/proc/on_enter_pregame()
	SIGNAL_HANDLER
	// First announce the game rules
	announce_game()
	set_station_name("Trainstation 13")
	addtimer(CALLBACK(src, PROC_REF(set_lobby_screen)), 5 SECONDS)

/datum/controller/subsystem/train_controller/proc/on_round_start()
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(refresh_train_lights))
	addtimer(CALLBACK(src, PROC_REF(show_current_station_logo)), 15 SECONDS)

/datum/controller/subsystem/train_controller/proc/refresh_train_lights()
	for(var/obj/machinery/light/light as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/light))
		if(!light.light)
			continue
		var/range = light.light_range
		light.set_light(0)
		light.set_light(range)
		CHECK_TICK

/**
 * Working with stations
 */

/datum/controller/subsystem/train_controller/proc/connect_terminals()
	if(!station_terminals || !length(station_terminals))
		return
	for(var/obj/machinery/computer/trainstation_control/control in station_terminals)
		control.set_station(loaded_station)

/datum/controller/subsystem/train_controller/proc/on_station_unloaded()

/datum/controller/subsystem/train_controller/proc/unload_station(datum/train_station/to_unload, hide_for_players = TRUE)
	if(!to_unload)
		return
	to_unload.unload_station(CALLBACK(src, PROC_REF(on_station_unloaded)))

/datum/controller/subsystem/train_controller/proc/on_station_loaded()

/datum/controller/subsystem/train_controller/proc/load_station(path_or_instance, stop_moving = FALSE, hide_for_players = TRUE, announce = TRUE)
	var/datum/train_station/to_load = null
	if(ispath(path_or_instance, /datum/train_station))
		to_load = locate(path_or_instance) in known_stations
	else if(istype(path_or_instance, /datum/train_station))
		to_load = path_or_instance

	if(!to_load)
		CRASH("Failed to load station [path_or_instance], invalid path!")
	var/list/screens = null
	if(hide_for_players)
		for(var/mob/living/L in GLOB.alive_player_list)
			var/atom/movable/screen/fullscreen/flash/black/station_loading/LS = L.overlay_fullscreen("station_loading", /atom/movable/screen/fullscreen/flash/black/station_loading)

			LS.apply_to(L)
			ADD_TRAIT(L, TRAIT_NO_TRANSFORM, REF(src))
			LAZYADD(screens, L)
	if(loaded_station)
		unload_station(loaded_station, hide_for_players)

	loading = TRUE
	loaded_station = to_load
	loaded_station.pre_load()

	var/result = to_load.load_station(CALLBACK(src, PROC_REF(on_station_loaded)))
	if(screens && islist(screens) && length(screens))
		for(var/mob/living/L in screens)
			REMOVE_TRAIT(L, TRAIT_NO_TRANSFORM, REF(src))
			L.clear_fullscreen("station_loading")

	if(!result)
		loading = FALSE
		return

	if(stop_moving)
		stop_moving()

	if(announce && !(loaded_station.station_flags & TRAINSTATION_ABSCTRACT))
		show_station_logo(to_load)

	connect_terminals()
	SEND_SIGNAL(src, COMSIG_TRAINSTATION_LOADED, loaded_station)
	loading = FALSE

	if(loaded_station.station_flags & TRAINSTATION_NO_FORKS)
		return

/datum/controller/subsystem/train_controller/proc/show_current_station_logo(silent = FALSE)
	if(loaded_station)
		show_station_logo(loaded_station, silent)

/datum/controller/subsystem/train_controller/proc/show_station_logo(datum/train_station/station, silent = FALSE)
	for(var/mob/player in GLOB.player_list)
		if(!silent)
			SEND_SOUND(player, 'fenysha_events/sounds/effects/station_logo.ogg')
		new /atom/movable/screen/station_logo(null, null, station.name, station.creator, player.client)


/datum/controller/subsystem/train_controller/proc/set_movement_theme(datum/train_object_spawner_theme/new_theme)
	var/datum/train_object_spawner_theme/selected = null
	if(ispath(new_theme))
		selected = GLOB.train_spwaner_themes[new_theme]
	else if(istype(new_theme, /datum/train_object_spawner_theme))
		selected = new_theme

	if(!selected)
		stack_trace("Trying set null movement theme!")
		return

	if(selected_theme)
		selected_theme.on_deselected()

	selected_theme = selected
	selected_theme.on_selected()

	for(var/obj/effect/landmark/trainstation/object_spawner/spawner in GLOB.train_object_spawners)
		spawner.set_theme(selected)


/datum/controller/subsystem/train_controller/proc/change_transition(type_or_instance, instant = FALSE)
	var/datum/moving_turf_transition/transition = null

	if(ispath(type_or_instance, /datum/moving_turf_transition))
		if(transition_theme && (type_or_instance == transition_theme.type))
			return
		transition = new type_or_instance()
	else if(istype(type_or_instance, /datum/moving_turf_transition))
		transition = type_or_instance
		if(transition_theme && (transition == transition_theme))
			return // Why would it happen?
		else if(transition_theme && (transition.type == transition_theme.type))
			qdel(transition)
			return //We already on it

	if(!transition)
		CRASH("Train controller try to change current transition with [type_or_instance] use instance or type instead!")

	transition_theme = transition
	if(!instant)
		transition.start_transition()
	else
		transition.process_instant()

/datum/controller/subsystem/train_controller/proc/reset_transition()
	change_transition(DEFAULT_TRANSITION)

/**
 * Movement control
 */

/datum/controller/subsystem/train_controller/proc/attempt_start(delay = 15 SECONDS)
	if(moving || tain_starting)
		return
	if(loaded_station && loaded_station.blocking_moving)
		return
	if(!check_start())
		return
	if(!planned_to_load)
		return

	var/station_abstract = (loaded_station.station_flags & TRAINSTATION_ABSCTRACT) ? TRUE : FALSE
	var/msg = "The train will start moving in [DisplayTimeText(delay)]! \
			[station_abstract ? "" : "Prepare for departure from station [loaded_station.name]."]"
	priority_announce(msg, "Train Departure")
	tain_starting = TRUE
	loaded_station.pre_unload()
	addtimer(CALLBACK(src, PROC_REF(start_moving), FALSE, TRUE, 0), delay)

/datum/controller/subsystem/train_controller/proc/check_start()
	if(SEND_SIGNAL(src, COMSIG_TRAIN_TRY_MOVE) & COMPONENT_BLOCK_TRAIN_MOVEMENT)
		return FALSE
	if(!train_engine && !no_engine_mode)
		return FALSE
	if(!train_engine.is_active() && !no_engine_mode)
		return FALSE
	return TRUE

/datum/controller/subsystem/train_controller/proc/pick_theme()
	for(var/theme_type in shuffle(GLOB.train_spwaner_themes.Copy()))
		var/datum/train_object_spawner_theme/theme = GLOB.train_spwaner_themes[theme_type]
		if(!theme.allow_selection)
			continue
		return theme

/datum/controller/subsystem/train_controller/proc/start_moving(force = FALSE, unload_station = TRUE)
	if(moving)
		return
	if((loaded_station && loaded_station.blocking_moving) && !force)
		return
	if(!check_start() && !force)
		return
	if(!planned_to_load)
		if(!force)
			return
		planned_to_load = pick(loaded_station.possible_next)

	// Remember the last real departure station (for the global map)
	if(loaded_station && !(loaded_station.station_flags & TRAINSTATION_ABSCTRACT) && !istype(loaded_station, /datum/train_station/train_backstage))
		last_departed_station = loaded_station

	if(!(loaded_station.station_flags & TRAINSTATION_ABSCTRACT))
		var/time_to_next
		if(global_map && planned_to_load?.map_object && loaded_station.map_object)
			var/datum/trainmap_object/start_obj = loaded_station.map_object
			var/datum/trainmap_object/end_obj = planned_to_load.map_object
			var/dx = end_obj.position_x - start_obj.position_x
			var/dy = end_obj.position_y - start_obj.position_y
			var/dist = sqrt(dx*dx + dy*dy)
			time_to_next = dist * time_per_map_unit
			if(time_to_next < minimum_travel_time)
				time_to_next = minimum_travel_time
			if(time_to_next > maximum_travel_time)
				time_to_next = maximum_travel_time
		else
			time_to_next = rand(minimum_travel_time, maximum_travel_time)
		total_travel_time = time_to_next
		time_to_next_station = time_to_next
		stations_visited += 1

	moving = TRUE

	if(unload_station && !istype(loaded_station, /datum/train_station/train_backstage))
		load_station(/datum/train_station/train_backstage, FALSE, TRUE, FALSE)

	if(last_departed_station && last_departed_station.exit_transition)
		change_transition(last_departed_station.exit_transition, TRUE)
		if(last_departed_station.exit_transition_time > 0)
			next_transition_time = world.time + last_departed_station.exit_transition_time
		else
			next_transition_time = INFINITY

	if(!transition_theme)
		change_transition(DEFAULT_TRANSITION, TRUE)
		set_movement_theme(pick_theme())
		next_transition_time = INFINITY


	SSmoving_turfs.on_train_start()
	soundloop.start()
	sound_to_playing_players('fenysha_events/sounds/steam_short.ogg', volume = 60)
	tain_starting = FALSE
	SEND_SIGNAL(src, COMSIG_TRAIN_BEGIN_MOVING)

/datum/controller/subsystem/train_controller/proc/stop_moving()
	if(!moving)
		return
	moving = FALSE
	SSmoving_turfs.on_train_stop()
	soundloop.stop(FALSE)
	sound_to_playing_players('fenysha_events/sounds/steam_long.ogg', volume = 60)
	if(no_engine_mode)
		no_engine_mode = FALSE
	SEND_SIGNAL(src, COMSIG_TRAIN_STOP_MOVING)

/datum/controller/subsystem/train_controller/fire(resumed)
	if(length(running_events))
		for(var/datum/round_event/evt in running_events)
			evt.process()

	if(!moving)
		return

	if((!train_engine || !train_engine.is_active()) && !no_engine_mode)
		stop_moving()
		return

	if(next_transition_time && ((world.time - next_transition_time) >= 0))
		change_transition(DEFAULT_TRANSITION)

	if(planned_to_load && planned_to_load.enter_transition && (time_to_next_station <= planned_to_load.enter_transition_time))
		change_transition(planned_to_load.enter_transition)

	if(moving && planned_to_load && time_to_next_station >= 0)
		time_to_next_station -= wait
		if(time_to_next_station <= 0)
			time_to_next_station = 0
			stop_moving()
			load_station(planned_to_load, stop_moving = TRUE, hide_for_players = TRUE, announce = TRUE)
			planned_to_load = null

/datum/controller/subsystem/train_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TrainMovementController")
		ui.open()

/datum/controller/subsystem/train_controller/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/controller/subsystem/train_controller/ui_data(mob/user)
	var/list/data = list()
	data["moving"] = moving
	data["num_turfs"] = length(SSmoving_turfs.to_process)
	data["stations"] = list()
	data["planned_station"] = planned_to_load?.name || "None"
	data["time_to_next_station"] = time_to_next_station
	data["total_travel_time"] = total_travel_time
	data["possible_next"] = list()
	for(var/datum/train_station/station in known_stations)
		if(!station.visible)
			continue
		data["stations"] += list(
			list(
				"name" = station.name,
				"type" = station.type,
			)
		)
	data["current_station"] = loaded_station?.name || "None"
	data["blocking"] = loaded_station?.blocking_moving || FALSE
	return data

/datum/controller/subsystem/train_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("open_vv")
			if(!check_rights(R_ADMIN))
				return
			usr.client.debug_variables(src)
		if("choose_next")
			var/raw_id = params["station_type"]
			if(!istext(raw_id))
				return

			var/station_path_text = raw_id
			var/hash_pos = findtext(raw_id, "#")
			if(hash_pos)
				station_path_text = copytext(raw_id, 1, hash_pos)

			var/station_type = text2path(station_path_text)
			if(!station_type)
				return

			var/datum/train_station/next = locate(station_type) in known_stations
			if(next && loaded_station && (next in loaded_station.possible_next))
				planned_to_load = next
			return TRUE
		if("start_moving")
			if(!train_engine || !train_engine.is_active())
				no_engine_mode = TRUE
			start_moving(force = TRUE)
			return TRUE
		if("stop_moving")
			stop_moving()
			return TRUE
		if("set_speed")
			var/new_speed = params["speed"]
			if(isnum(new_speed) && new_speed > 0)
				return TRUE
		if("set_cooldown")
			var/new_cd = params["cooldown"]
			if(isnum(new_cd) && new_cd > 0)
				return TRUE
		if("load_station")
			var/raw_id = params["station_type"]
			if(!istext(raw_id))
				return

			var/station_path_text = raw_id
			var/hash_pos = findtext(raw_id, "#")
			if(hash_pos)
				station_path_text = copytext(raw_id, 1, hash_pos)

			var/station_type = text2path(station_path_text)
			if(!station_type)
				return

			var/confirm = tgui_alert(usr, "Are you sure want to load station [raw_id]?", "Station loading", list("Yes", "Nevermind"))
			if(confirm != "Yes")
				return

			INVOKE_ASYNC(src, PROC_REF(load_station), station_type)
			return TRUE
		if("unload_station")
			if(loaded_station)
				INVOKE_ASYNC(src, PROC_REF(unload_station), loaded_station)
				loaded_station = null
				return TRUE

ADMIN_VERB(open_train_controller, R_ADMIN, "Open train controller", "Open active train controller.", ADMIN_CATEGORY_EVENTS)
	SStrain_controller.ui_interact(usr)

/obj/effect/mapping_helpers/ztrait_injector/trainstation
	traits_to_add = list(ZTRAIT_NOPARALLAX = TRUE, ZTRAIT_NOXRAY = TRUE, ZTRAIT_NOPHASE = TRUE, ZTRAT_TRAINSTATION = TRUE, ZTRAIT_BASETURF = /turf/open/space)


/atom/movable/screen/station_logo
	icon_state = "blank"
	plane = HUD_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	screen_loc = "CENTER-7,CENTER-7"

	var/fade_delay = 7 SECONDS
	var/client/parent = null

/atom/movable/screen/station_logo/Initialize(mapload, datum/hud/hud_owner, station_name, creator, client/to_show)
	. = ..()
	parent = to_show
	parent.screen += src
	var/icon_size = world.icon_size
	maptext = {"<div style="font:'Small Fonts'">[station_name]\ncreated by [creator]</div>"}
	maptext_height = icon_size * 6
	maptext_width = icon_size * 24
	var/list/client_view = splittext(parent.view, "x")
	var/view_y = 15
	var/view_x = 21
	if(LAZYLEN(client_view) == 2)
		view_x = client_view[1]
		view_y = client_view[2]
	maptext_x = ((icon_size * view_x) + round(icon_size * 0.5)) * 13
	maptext_y = ((icon_size * view_y) + round(icon_size * 0.5)) * 13
	transform.Translate(10, 10)
	ASYNC
		rollem()

/atom/movable/screen/station_logo/proc/rollem()
	sleep(3 SECONDS)
	animate(src, alpha = 0, time = fade_delay, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(src, PROC_REF(fadeout)), fade_delay + 0.1 SECONDS)

/atom/movable/screen/station_logo/proc/fadeout()
	parent.screen -= src
	qdel(src)


/atom/movable/screen/fullscreen/flash/black/station_loading
	var/text_phrase = "Loading"
	var/list/loading_phrases = list(
		"Installing railways",
		"Hugging tesharies",
		"Fixing lights",
		"Feeding coders",
		"Placing turfs",
		"Cleaning khara",
		"Subscrubing to signals",
		"Updating turf atmos"
	)

	var/phrase_index = 1
	var/dot_count = 0
	var/timer_id
	var/last_phrase_change = 0

	var/update_interval = 1 SECONDS
	var/atom/movable/screen/text/load_phrases
	var/datum/hud/owner_hud

/atom/movable/screen/fullscreen/flash/black/station_loading/proc/apply_to(mob/living)
	load_phrases = new(src)

	owner_hud = living.hud_used
	owner_hud.always_visible_inventory += load_phrases
	owner_hud.hud_version = HUD_STYLE_NOHUD
	owner_hud.show_hud(owner_hud.hud_version)

	var/icon_size = world.icon_size

	load_phrases.maptext_height = icon_size * 6
	load_phrases.maptext_width = icon_size * 24
	load_phrases.maptext_x = 380
	load_phrases.maptext_y = 100

	last_phrase_change = world.time
	phrase_index = rand(1, length(loading_phrases))
	text_phrase = loading_phrases[phrase_index]

	update_loading_text(TRUE)

/atom/movable/screen/fullscreen/flash/black/station_loading/Destroy()
	if(timer_id)
		deltimer(timer_id)
		timer_id = null

	owner_hud.always_visible_inventory -= load_phrases
	owner_hud.hud_version = HUD_STYLE_STANDARD
	owner_hud.show_hud(owner_hud.hud_version)

	QDEL_NULL(load_phrases)
	. = ..()

/atom/movable/screen/fullscreen/flash/black/station_loading/proc/get_next_phrase()
	phrase_index++
	if(phrase_index > length(loading_phrases))
		phrase_index = 1

	return loading_phrases[phrase_index]


/atom/movable/screen/fullscreen/flash/black/station_loading/proc/update_loading_text(first = FALSE)
	if(!first && (world.time - last_phrase_change) >= 4 SECONDS)
		last_phrase_change = world.time
		text_phrase = get_next_phrase()

	dot_count = (dot_count + 1) % 5
	var/dots = ""
	for(var/i = 1, i <= dot_count, i++)
		dots += "."

	load_phrases.maptext = {"<div style="font:'Small Fonts'">[text_phrase][dots]</div>"}
	timer_id = addtimer(CALLBACK(src, PROC_REF(update_loading_text), FALSE), update_interval, TIMER_STOPPABLE)

/datum/looping_sound/global_sound/train_sound_loop
	sounds_to_play = list(
		'fenysha_events/sounds/loop_trainride.ogg' = 63 SECONDS,
	)
