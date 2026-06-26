GLOBAL_LIST_INIT(all_elevators, list())

#define SOUND_ELEVATOR_MOVE 'fenysha_events/sounds/effects/elevator_sounds.ogg'


/proc/get_or_create_elevator(id)
	var/datum/elevator/E = GLOB.all_elevators[id]

	if(E)
		return E

	E = new
	E.elevator_id = id

	GLOB.all_elevators[id] = E

	return E


/datum/elevator
	var/elevator_id
	var/time_per_floor = 3 SECONDS
	var/current_floor = 1
	var/moving = FALSE
	var/music_enabled = TRUE
	var/music_channel = 2
	var/sfx_channel = 1

	var/list/elevator_turfs_by_floor = list()
	var/list/buttons_by_floor = list()
	var/list/doors_by_floor = list()

	var/list/all_buttons = list()
	var/list/request_queue = list()


/datum/elevator/proc/num_to_floor(num)
	return "floor_[num]"

/datum/elevator/proc/floor_to_num(floor)
	return text2num(replacetext(floor, "floor_", ""))

/datum/elevator/proc/is_valid_floor(floor)
	var/floor_key = num_to_floor(floor)
	return !!elevator_turfs_by_floor[floor_key]

/datum/elevator/proc/floor_amount()
	return length(buttons_by_floor)

/datum/elevator/proc/register_turf(turf/T, floor)
	if(!T)
		return

	var/floor_key = num_to_floor(floor)
	if(!elevator_turfs_by_floor[floor_key])
		elevator_turfs_by_floor[floor_key] = list()
	elevator_turfs_by_floor[floor_key] += T


/datum/elevator/proc/unregister_turf(turf/T, floor)
	var/floor_key = num_to_floor(floor)
	var/list/L = elevator_turfs_by_floor[floor_key]

	if(!L)
		return

	L -= T
	if(!length(L))
		elevator_turfs_by_floor -= floor_key


/datum/elevator/proc/register_button(obj/machinery/button/elevator_control/B)
	if(!B)
		return
	B.control = src

	all_buttons |= B

	var/floor_key = num_to_floor(B.floor)
	if(!buttons_by_floor[floor_key])
		buttons_by_floor[floor_key] = list()
	buttons_by_floor[floor_key] |= B


/datum/elevator/proc/unregister_button(obj/machinery/button/elevator_control/B)
	if(!B)
		return

	all_buttons -= B

	var/floor_key = num_to_floor(B.floor)
	var/list/L = buttons_by_floor[floor_key]

	if(L)
		L -= B


/datum/elevator/proc/register_door(obj/machinery/door/poddoor/story/elevator/D)
	if(!D)
		return

	var/floor_key = num_to_floor(D.floor)
	if(!doors_by_floor[floor_key])
		doors_by_floor[floor_key] = list()
	doors_by_floor[floor_key] |= D


/datum/elevator/proc/unregister_door(obj/machinery/door/poddoor/story/elevator/D)
	if(!D)
		return

	var/floor_key = num_to_floor(D.floor)
	var/list/L = doors_by_floor[floor_key]
	if(L)
		L -= D


/datum/elevator/proc/call_to_floor(floor)
	if(!is_valid_floor(floor))
		return

	if(floor == current_floor)
		return

	var/floor_key = num_to_floor(floor)
	if(floor_key in request_queue)
		return

	request_queue += floor_key

	if(!moving)
		process_queue()


/datum/elevator/proc/request_floor(floor)
	if(!is_valid_floor(floor))
		return
	if((floor == current_floor) || (num_to_floor(floor) in request_queue))
		return
	request_queue += num_to_floor(floor)


/datum/elevator/proc/process_queue()
	while(request_queue.len > 0)
		moving = TRUE
		var/target_floor = request_queue[1]
		request_queue.Cut(1, 2)

		var/target_floor_num = floor_to_num(target_floor)
		move_to_floor(target_floor_num)
		moving = FALSE


/datum/elevator/proc/move_to_floor(target_floor)
	if(target_floor == current_floor)
		return

	if(!is_valid_floor(target_floor))
		return

	close_floor(current_floor)
	broadcast_elevator_sound(SOUND_ELEVATOR_MOVE, sfx_channel, volume=70)

	var/floor_delta = abs(target_floor - current_floor)
	var/travel_time = floor_delta * time_per_floor

	sleep(travel_time)

	move_platform(current_floor, target_floor)
	current_floor = target_floor

	// announce_floor(current_floor)
	open_floor(current_floor)


/datum/elevator/proc/move_platform(old_floor, new_floor)
	var/list/old_turfs = get_floor_turfs(old_floor)
	var/list/new_turfs = get_floor_turfs(new_floor)

	if(!old_turfs || !new_turfs)
		return

	for(var/turf/old_turf in old_turfs)
		for(var/turf/new_turf in new_turfs)
			if(old_turf && new_turf)
				for(var/atom/movable/m in old_turf.contents)
					m.forceMove(new_turf)

/datum/elevator/proc/close_floor(floor)
	var/floor_key = num_to_floor(floor)
	var/list/L = doors_by_floor[floor_key]

	if(!L)
		return

	for(var/obj/machinery/door/poddoor/story/elevator/D in L)
		D.close()


/datum/elevator/proc/open_floor(floor)
	var/floor_key = num_to_floor(floor)
	var/list/L = doors_by_floor[floor_key]

	if(!L)
		return

	for(var/obj/machinery/door/poddoor/story/elevator/D in L)
		D.open()


/datum/elevator/proc/has_floor(floor)
	return is_valid_floor(floor)


/datum/elevator/proc/get_floor_turfs(floor)
	var/floor_key = num_to_floor(floor)
	return elevator_turfs_by_floor[floor_key]


/datum/elevator/proc/get_floor_doors(floor)
	var/floor_key = num_to_floor(floor)
	return doors_by_floor[floor_key]



/datum/elevator/proc/broadcast_elevator_sound(sound_file, channel = 1, volume = 100, loop = 0)
	if(!sound_file)
		return

	var/list/elevator_mobs = get_elevator_occupants()

	for(var/mob/m in elevator_mobs)
		if(m.client)
			SEND_SOUND(m, sound(sound_file, repeat = loop, wait = 0, volume = volume, channel = channel))


/datum/elevator/proc/announce_floor(floor)
	var/list/elevator_mobs = get_elevator_occupants()
	var/floor_name = get_floor_name(floor)

	for(var/mob/m in elevator_mobs)
		to_chat(m, span_notice("<b>DING!</b> Arriving at [floor_name]..."))


/datum/elevator/proc/get_floor_name(floor)
	switch(floor)
		if(1)
			return "Floor 1 - Lobby"
		if(2)
			return "Floor 2 - Office"
		if(3)
			return "Floor 3 - Storage"
		else
			return "Floor [floor]"


/datum/elevator/proc/get_elevator_occupants()
	var/list/occupants = list()
	var/list/turfs = list()


	for(var/floor_key in elevator_turfs_by_floor)
		turfs += elevator_turfs_by_floor[floor_key]

	for(var/turf/T in turfs)
		for(var/mob/m in T.contents)
			occupants += m

	return occupants


/datum/elevator/proc/start_music()
	if(!music_enabled)
		return

/datum/elevator/proc/stop_music()
	broadcast_elevator_sound(null, music_channel)


/obj/machinery/button/elevator_control
	name = "elevator call button"
	desc = "Press this button to call the elevator"
	base_icon_state = "tram"
	icon_state = "tram"

	var/floor = 1

	var/elevator_id
	var/datum/elevator/control


/obj/machinery/button/elevator_control/Initialize(mapload)
	. = ..()

	control = get_or_create_elevator(elevator_id)
	control.register_button(src)
	AddElement(/datum/element/contextual_screentip_bare_hands, lmb_text = "Use elevator")

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/button/elevator_control, 32)


/obj/machinery/button/elevator_control/Destroy()
	if(control)
		control.unregister_button(src)

	return ..()


/obj/machinery/button/elevator_control/interact(mob/user)
	if(!control)
		return FALSE

	var/is_inside_elevator = FALSE
	var/list/floor_turfs = control.get_floor_turfs(floor)
	if(length(floor_turfs) && (get_turf(src) in floor_turfs))
		is_inside_elevator = TRUE

	var/should_advanced_view = control.floor_amount() > 2

	if(!is_inside_elevator)
		control.call_to_floor(floor)
		user.visible_message(span_notice("[user] presses the elevator button."),
			span_notice("You press the elevator call button for [floor] floor."))
		return TRUE

	else if(!should_advanced_view && is_inside_elevator)
		if(control.floor_amount() == floor)
			control.move_to_floor(control.floor_amount() - 1)
		else
			control.move_to_floor(control.floor_amount())

		user.visible_message(span_notice("[user] presses the elevator button."),
			span_notice("You press the elevator call button for another floor."))
		return TRUE

	else if(should_advanced_view && is_inside_elevator)
		var/list/available_floors = list()
		for(var/floor in control.buttons_by_floor)
			available_floors[floor] = control.floor_to_num(floor)
		var/picked = tgui_input_list(user, "What floor?", "Elevator", available_floors)
		control.move_to_floor(available_floors[picked])
		return TRUE
	return TRUE


/obj/machinery/door/poddoor/story/elevator
	name = "elevator door"
	desc = "Automated elevator door"

	var/floor = 1
	var/elevator_id
	var/datum/elevator/control


/obj/machinery/door/poddoor/story/elevator/Initialize(mapload)
	. = ..()

	control = get_or_create_elevator(elevator_id)
	control.register_door(src)


/obj/machinery/door/poddoor/story/elevator/Destroy()
	if(control)
		control.unregister_door(src)

	return ..()

/obj/effect/mapping_helpers/elevator_turf_marker
	name = "Elevator Turf Marker"
	desc = "Marks a turf as part of an elevator shaft"

	late = TRUE
	invisibility = INVISIBILITY_ABSTRACT

	var/floor = 1
	var/elevator_id


/obj/effect/mapping_helpers/elevator_turf_marker/LateInitialize()
	var/datum/elevator/E = get_or_create_elevator(elevator_id)

	E.register_turf(get_turf(src), floor)

	qdel(src)
