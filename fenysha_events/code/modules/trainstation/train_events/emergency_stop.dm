/datum/round_event_control/train_event/emergency_stop
	name = "Emergency Stop"
	description = "Forcibly makes the train perform an emergency braking"
	category = "Trainstation"
	typepath = /datum/round_event/train_event/emergency_stop

	/// Target station for the emergency stop
	var/datum/train_station/emergy_station = null

/datum/round_event_control/train_event/emergency_stop/can_spawn_event(players_amt, allow_magic)
	// The event can only run if the train is already moving
	if(!SStrain_controller.is_moving())
		return FALSE
	return ..()

/datum/round_event_control/train_event/emergency_stop/preRunEvent()
	if(!SStrain_controller.is_moving())
		return EVENT_CANT_RUN
	return ..()


/datum/round_event/train_event/emergency_stop
	announce_when = 3          // Announcement 3 seconds after the event starts
	start_when = 30            // Braking begins 30 seconds after the announcement
	end_when = 1000            // Duration of the event (long enough for the train to stop)
	fakeable = FALSE           // Cannot be faked as a fake event

	/// The station the train is forced to make an emergency stop at
	var/datum/train_station/to_load = null
	/// The previously planned station (to restore after the event)
	var/datum/train_station/planned_previous = null

/datum/round_event/train_event/emergency_stop/setup()
	var/datum/round_event_control/train_event/emergency_stop/evt = control
	if(!evt || !istype(evt) || !evt.emergy_station)
		kill()
		return

	to_load = evt.emergy_station
	RegisterSignal(SStrain_controller, COMSIG_TRAINSTATION_LOADED, PROC_REF(on_emergency_loaded), TRUE)

/datum/round_event/train_event/emergency_stop/announce(fake)
	priority_announce("Due to unforeseen circumstances along the route, the train will make an emergency stop at station [to_load.name]. \
						Prepare for abrupt braking within the next 30 seconds!", "EMERGENCY STOP", 'fenysha_events/sounds/train_horn.ogg')


/datum/round_event/train_event/emergency_stop/start()
	// Remember where the train was going before the event
	planned_previous = SStrain_controller.planned_to_load

	// Forcibly redirect to the emergency station
	SStrain_controller.planned_to_load = to_load
	SStrain_controller.time_to_next_station = 0  // Begin braking immediately

	// Effects for all passengers on the station level
	for(var/mob/living/passanger in GLOB.alive_mob_list)
		if(!is_station_level(passanger.z))
			continue
		to_chat(passanger, span_userdanger("The train braked sharply! You were violently jolted!"))
		passanger.Knockdown(3 SECONDS)
		passanger.throw_at(get_step(passanger, REVERSE_DIR(SStrain_controller.abstract_moving_direction)), 3, 2, spin = TRUE)

/datum/round_event/train_event/emergency_stop/proc/on_emergency_loaded()
	SIGNAL_HANDLER

	UnregisterSignal(SStrain_controller, COMSIG_TRAINSTATION_LOADED)

	// After arriving at the emergency station, restore the previous route plan
	SStrain_controller.planned_to_load = planned_previous

	// End the event
	kill()


/datum/round_event_control/train_event/emergency_stop/station_a13
	name = "Emergency Stop - station A13"
	emergy_station = /datum/train_station/emergency_station_a13
