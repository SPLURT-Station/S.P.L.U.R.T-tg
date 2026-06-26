/datum/map_template/train_station
	name = "Train Station Template"
	returns_created_atoms = TRUE

/datum/train_station
	/// Name of the station
	var/name = "Train station"
	/// Full description of the station
	var/desc = "A generic train station"
	/// Station flags, see the file fenysha_events/__DEFINES/trainstation.dm for details
	var/station_flags = NONE
	/// Whether this station is visible in the train_controller menu; if FALSE - also prevents the station from being selected as the next one
	var/visible = TRUE
	/// How many stations the train needs to visit before this station
	var/required_stations = 0
	/// Maximum number of visits for this station
	var/maximum_visits = 1
	/// How many times this station has been visited
	var/visited = 0
	/// Whether a password is required to unlock this station
	var/required_password = TRUE
	/// Creator of this station, will be displayed when it is visited
	var/creator = "Fenysha"
	/// Threat level at the station
	var/threat_level = THREAT_LEVEL_SAFE
	/// Region in which this station is located
	var/region = "None"
	/// Type of the station
	var/station_type = "unknown"


	/// Overmap object representing this station
	var/datum/trainmap_object/map_object
	/// Path to the station map, automatically creates a template for it
	var/map_path
	/// list() - ambient sounds that play at this station
	var/ambience_sounds = null
	/// List of possible station surroundings (generated above the train)
	var/list/possible_nearstations = list(
		/datum/train_station/near_station/static_default,
		/datum/train_station/near_station/static_mountaints,
	)

	/// What transition we want to set on leaving this station
	var/exit_transition
	/// How long it takes to end exit transition, -1 - means it stay until next transition change
	var/exit_transition_time = -1

	/// What transition we want to use before entering this station
	var/enter_transition
	/// How long before arrival at the station will set enter_transition
	var/enter_transition_time = 60 SECONDS

	/// Possible next stations. Empty by default and will be filled on load, but can be set in advance
	var/list/possible_next = list()
	// Whether this station blocks the train's movement, will be set automatically if the station has the TRAINSTATION_BLOCKING flag
	var/blocking_moving = FALSE

	VAR_PRIVATE/datum/looping_sound/global_sound/station_loop_soound = null
	VAR_PRIVATE/datum/map_template/template = null
	VAR_PRIVATE/list/docking_turfs = list()
	VAR_PRIVATE/datum/train_station/near_station/loaded_nearstation = null
	VAR_PRIVATE/unlock_password


/datum/train_station/New()
	. = ..()
	template = new /datum/map_template(map_path, "Train station - [name]", TRUE)
	template.returns_created_atoms = TRUE
	SSmapping.map_templates[template.name] = template

	if(ambience_sounds)
		create_ambience()

	map_object = new()
	map_object.name = name
	map_object.desc = desc
	map_object.associated_station = src
	map_object.set_position(0, 0)

/datum/train_station/proc/create_ambience()
	station_loop_soound = new(start_immediately = FALSE)
	station_loop_soound.create_from_list(ambience_sounds)

/datum/train_station/proc/connect_stations()
	for(var/i in 1 to length(possible_next))
		var/path = possible_next[i]
		var/datum/train_station/st = locate(path) in SStrain_controller.known_stations
		if(st)
			possible_next[i] = st
		else
			stack_trace("Invalid possible_next path [path] for station [type]")

	if(station_flags & TRAINSTATION_NO_NEARSTATION)
		return

	for(var/i in 1 to length(possible_nearstations))
		var/path = possible_nearstations[i]
		var/datum/train_station/st = locate(path) in SStrain_controller.known_stations
		if(st)
			possible_nearstations[i] = st
		else
			stack_trace("Invalid possible_nearstations path [path] for station [type]")

/datum/train_station/proc/get_spawnpoint()
	return locate(/obj/effect/landmark/trainstation/station_spawnpoint) in GLOB.landmarks_list

/datum/train_station/proc/get_spawn_offset(turf/spawn_turf)
	var/offset_x = spawn_turf.x
	var/offset_y = spawn_turf.y - template.height + 1
	var/offset_z = spawn_turf.z
	return list("x" = offset_x, "y" = offset_y, "z" = offset_z)


/datum/train_station/proc/load_station(datum/callback/load_callback, silent = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!template)
		return FALSE
	var/start_time = world.realtime
	var/obj/effect/landmark/trainstation/spawnpoint = get_spawnpoint()
	if(!spawnpoint)
		stack_trace("Failed to load train station [name], no available spawnpoints!")
		return FALSE

	var/list/spawn_offset = get_spawn_offset(get_turf(spawnpoint))
	if(!islist(spawn_offset) || length(spawn_offset) != 3)
		stack_trace("Failed to load train station [name], invalid spawn offset!")
		return FALSE
	var/offset_x = spawn_offset["x"]
	var/offset_y = spawn_offset["y"]
	var/offset_z = spawn_offset["z"]

	var/turf/actual_spawnpoint = locate(offset_x, offset_y, offset_z)
	if(!actual_spawnpoint)
		stack_trace("Failed to load train station [name], template out of bounds")
		return FALSE
	var/bounds = template.load(actual_spawnpoint, centered = FALSE)

	docking_turfs = block(
		bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ],
		bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]
	)
	if(template.width < world.maxx)
		create_indestructible_borders(actual_spawnpoint)

	if((islist(possible_nearstations) && length(possible_nearstations)) && !(station_flags & TRAINSTATION_NO_NEARSTATION))
		var/datum/train_station/our_neatstation = pick(possible_nearstations)
		if(our_neatstation && our_neatstation.load_station(silent = TRUE))
			loaded_nearstation = our_neatstation

	var/load_in = world.realtime - start_time
	if(!silent)
		message_admins("TRAINSTATION: Loaded station [name] in [time2text(load_in, "ss")] seconds!")
	if(load_callback)
		load_callback.Invoke()
	after_load()
	return TRUE


/datum/train_station/proc/create_indestructible_borders(turf/bottom_left)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/left_x = bottom_left.x - 1
	var/right_x = bottom_left.x + template.width
	var/start_y = bottom_left.y
	var/end_y = bottom_left.y + template.height - 1
	var/z = bottom_left.z

	for(var/y = start_y to end_y)
		var/turf/left_turf = locate(left_x, y, z)
		if(left_turf)
			left_turf.ChangeTurf(/turf/closed/indestructible/train_border)
			docking_turfs += left_turf


	for(var/y = start_y to end_y)
		var/turf/right_turf = locate(right_x, y, z)
		if(right_turf)
			right_turf.ChangeTurf(/turf/closed/indestructible/train_border)
			docking_turfs += right_turf
	if(right_x <= world.maxx)
		var/turf/corner = locate(right_x, end_y, z)
		if(!corner)
			return
		for(var/x = right_x to world.maxx)
			var/turf/top_turf = locate(x, end_y, z)
			if(top_turf)
				top_turf.ChangeTurf(/turf/closed/indestructible/train_border)
				docking_turfs += top_turf

/datum/train_station/proc/generate_password()
	var/static/list/possible_letters = \
		list("1", "2", "3",
			"4", "5", "6",
			"7", "8", "9", "0")
	var/new_pass = ""
	for(var/i = 1 to 5)
		new_pass += pick(possible_letters)
	return new_pass

/datum/train_station/proc/get_password()
	return unlock_password

/datum/train_station/proc/is_right_code(code)
	if(trim(code) != trim(unlock_password))
		return FALSE
	return TRUE

/datum/train_station/proc/pre_load()
	if(required_password)
		unlock_password = generate_password()

/datum/train_station/proc/after_load()
	if(station_flags & TRAINSTATION_BLOCKING)
		blocking_moving = TRUE
	if(station_loop_soound)
		station_loop_soound.start()

/datum/train_station/proc/pre_unload()
	return

/datum/train_station/proc/unload_station(datum/callback/unload_callback)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/obj/effect/landmark/trainstation/crew_spawnpoint/crew_mover = locate() in GLOB.landmarks_list

	Master.StartLoadingMap()
	for(var/turf/T in docking_turfs)
		for(var/atom/movable/AM in T.contents)
			if(HAS_TRAIT(AM, TRAIT_NO_STATION_UNLOAD))
				continue
			if(isliving(AM))
				var/mob/living/living = AM
				if(crew_mover && living.client)
					living.forceMove(get_turf(crew_mover))
					to_chat(living, span_warning("You barely made it to the train before it departed!"))
					continue
			if(isobserver(AM))
				continue
			POOL_ASYNC_RELEASE(AM)
		T.ChangeTurf(/turf/baseturf_bottom)
		T.baseturfs = /turf/baseturf_bottom
	docking_turfs.Cut()
	template.created_atoms = null
	if(unload_callback)
		unload_callback.Invoke()
	Master.StopLoadingMap()
	if(loaded_nearstation)
		loaded_nearstation.unload_station()
		loaded_nearstation = null
	after_unload()

/datum/train_station/proc/after_unload()
	if(station_loop_soound)
		station_loop_soound.stop()


/datum/train_station/near_station
	name = "Near station"
	station_flags = TRAINSTATION_ABSCTRACT | TRAINSTATION_NO_FORKS | TRAINSTATION_NO_SELECTION | TRAINSTATION_NO_NEARSTATION
	possible_nearstations = null
	visible = FALSE

/datum/train_station/near_station/get_spawnpoint()
	return locate(/obj/effect/landmark/trainstation/nearstation_spawnpoint) in GLOB.landmarks_list

/datum/train_station/near_station/get_spawn_offset(turf/spawn_turf)
	return list("x" = spawn_turf.x, "y" = spawn_turf.y, "z" = spawn_turf.z)
