/datum/round_event_control/train_event/emergency_stop
	name = "Аварийная остановка"
	description = "Принудительно заставляет поезд совершить экстренное торможение"
	category = "Trainstation"
	typepath = /datum/round_event/train_event/emergency_stop

	/// Целевая станция для аварийной остановки
	var/datum/train_station/emergy_station = null

/datum/round_event_control/train_event/emergency_stop/can_spawn_event(players_amt, allow_magic)
	// Событие может запуститься только если поезд уже в движении
	if(!SStrain_controller.is_moving())
		return FALSE
	return ..()

/datum/round_event_control/train_event/emergency_stop/preRunEvent()
	if(!SStrain_controller.is_moving())
		return EVENT_CANT_RUN
	return ..()


/datum/round_event/train_event/emergency_stop
	announce_when = 3          // Объявление через 3 секунды после старта события
	start_when = 30            // Начало торможения через 30 секунд после объявления
	end_when = 1000            // Длительность события (достаточно, чтобы поезд остановился)
	fakeable = FALSE           // Нельзя подделать как фейковое событие

	/// Станция, на которую поезд вынужден экстренно остановиться
	var/datum/train_station/to_load = null
	/// Предыдущая запланированная станция (чтобы вернуть после события)
	var/datum/train_station/planned_previous = null

/datum/round_event/train_event/emergency_stop/setup()
	var/datum/round_event_control/train_event/emergency_stop/evt = control
	if(!evt || !istype(evt) || !evt.emergy_station)
		kill()
		return

	to_load = evt.emergy_station
	RegisterSignal(SStrain_controller, COMSIG_TRAINSTATION_LOADED, PROC_REF(on_emergency_loaded), TRUE)

/datum/round_event/train_event/emergency_stop/announce(fake)
	priority_announce("В связи с непредвиденными обстоятельствами на пути следования поезд совершит экстренную остановку на станции [to_load.name]. \
						Приготовьтесь к резкому торможению в течение ближайших 30 секунд!", "АВАРИЙНАЯ ОСТАНОВКА", 'fenysha_events/sounds/train_horn.ogg')


/datum/round_event/train_event/emergency_stop/start()
	// Запоминаем, куда поезд собирался ехать до события
	planned_previous = SStrain_controller.planned_to_load

	// Принудительно перенаправляем на аварийную станцию
	SStrain_controller.planned_to_load = to_load
	SStrain_controller.time_to_next_station = 0  // Немедленное начало торможения

	// Эффекты для всех пассажиров на уровне станции
	for(var/mob/living/passanger in GLOB.alive_mob_list)
		if(!is_station_level(passanger.z))
			continue
		to_chat(passanger, span_userdanger("Поезд резко затормозил! Вас сильно тряхнуло!"))
		passanger.Knockdown(3 SECONDS)
		passanger.throw_at(get_step(passanger, REVERSE_DIR(SStrain_controller.abstract_moving_direction)), 3, 2, spin = TRUE)

/datum/round_event/train_event/emergency_stop/proc/on_emergency_loaded()
	SIGNAL_HANDLER

	UnregisterSignal(SStrain_controller, COMSIG_TRAINSTATION_LOADED)

	// После прибытия на аварийную станцию возвращаем предыдущий план маршрута
	SStrain_controller.planned_to_load = planned_previous

	// Завершаем событие
	kill()


/datum/round_event_control/train_event/emergency_stop/station_a13
	name = "Аварийная остановка — станция A13"
	emergy_station = /datum/train_station/emergency_station_a13
