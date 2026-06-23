#define MORPH_ENGINE_MODE_BARRIER (1 << 1)
#define MORPH_ENGINE_MODE_CONTAINMENT (1 << 2)
#define MORPH_ENGINE_MODE_ISOLATION (1 << 3)

GLOBAL_VAR(main_morph_engine)


/obj/effect/temp_visual/morph_engine_block
	name = "Shield"
	icon_state = "emppulse"
	color = COLOR_GREEN_GRAY

/datum/component/morph_engine_tracker
	var/atom/movable/atom_parent = null
	var/obj/machinery/morphological_engine/active_engine = null
	var/power_usage_per_block = BASE_MACHINE_ACTIVE_CONSUMPTION

/datum/component/morph_engine_tracker/Initialize(engine, power_to_block = BASE_MACHINE_ACTIVE_CONSUMPTION)
	. = ..()
	if(!engine)
		engine = GLOB.main_morph_engine
	if(!engine || !istype(engine, /obj/machinery/morphological_engine))
		return COMPONENT_INCOMPATIBLE

	active_engine = engine
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

	atom_parent = parent
	power_usage_per_block = power_to_block

/datum/component/morph_engine_tracker/RegisterWithParent()
	. = ..()
	RegisterSignal(atom_parent, COMSIG_MOVABLE_ATTEMPTED_MOVE, PROC_REF(on_parent_pre_move))
	if(isliving(atom_parent))
		RegisterSignal(atom_parent, COMSIG_MOB_CLICKON, PROC_REF(on_living_parent_clickon))

/datum/component/morph_engine_tracker/UnregisterFromParent()
	. = ..()
	UnregisterSignal(atom_parent, list(COMSIG_MOVABLE_ATTEMPTED_MOVE))
	if(isliving(atom_parent))
		UnregisterSignal(atom_parent, list(COMSIG_MOB_CLICKON))

/datum/component/morph_engine_tracker/proc/on_living_parent_clickon(mob/living/living_parent, atom/target, list/modifiers)
	SIGNAL_HANDLER

	if(!active_engine || !active_engine.on)
		return

	var/turf/target_turf = get_turf(target)
	if(!active_engine.is_protected_turf(target_turf))
		return

	if(living_parent.Adjacent(target_turf))
		new /obj/effect/temp_visual/morph_engine_block(target_turf)

	return COMSIG_MOB_CANCEL_CLICKON

/datum/component/morph_engine_tracker/proc/on_parent_pre_move(atom/movable/parent, newloc, direction)
	SIGNAL_HANDLER

	if(!active_engine || !active_engine.on)
		return

	var/turf/old_turf = get_turf(atom_parent)
	var/turf/new_turf = get_turf(newloc)
	if(!new_turf)
		return

	// Блокируем ТОЛЬКО попытку войти в защищённую зону (из незащищённой)
	// Внутри зоны - движение свободно, выход тоже свободен
	if(!(old_turf && !active_engine.is_protected_turf(old_turf) && active_engine.is_protected_turf(new_turf)))
		return

	if(!active_engine.can_block_movement(power_usage_per_block))
		return

	new /obj/effect/temp_visual/morph_engine_block(new_turf)
	addtimer(CALLBACK(src, PROC_REF(throw_back), atom_parent, old_turf), 1)

/datum/component/morph_engine_tracker/proc/throw_back(atom/movable/target, turf/old_loc)
	if(!target || QDELETED(target) || !old_loc)
		return

	target.throw_at(old_loc, get_dist(get_turf(target), old_loc), 10, atom_parent, FALSE, TRUE)
	to_chat(target, span_userdanger("Энергетическая волна выталкивает тебя!"))
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.take_overall_damage(20)

/obj/machinery/morphological_engine
	name = "\improper Морфологический двигатель"
	desc = "Сфера покрытая множеством проводов, труб и техических отверстий, источает слабый, еле слышимый гул вблизи. \
			Панель внизу - имеет несколько настроек, обозначенные буквами IV, VIII, XX. Под ними - надпись. 'Морфологический двигатель'"
	icon = 'fenysha_events/icons/machinery/64x64.dmi'
	icon_state = "morf_engine"
	opacity = FALSE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	flags_1 = SUPERMATTER_IGNORES_1
	processing_flags = START_PROCESSING_MANUALLY
	base_pixel_x = -16
	pixel_x = -16

	idle_power_usage = 1 KILO WATTS
	critical_machine = TRUE

	var/enabled_power_usage = 0

	VAR_PRIVATE/list/protected_areas = null
	/// Список всех зон, что находятся под нашей защитой
	VAR_PRIVATE/list/area_type_cache = null
	/// Список зон(в том числе их под-типов), что будут защищены двигателем
	var/list/protected_area_types = list(/area/trainstation/indoors/train)
	/// Текущий режим в котором работает морфологический двигатель
	var/mode = NONE
	/// Включен ли морфологический двигатель
	var/on = FALSE
	/// Является ли этот двигатель главным
	var/main_engine = FALSE

	/// Временный режим, который выбран для применения после калибровки
	var/pending_mode = 0
	/// Шаг открытия панели доступа (0 - закрыта, 1-3 - этапы)
	var/access_step = 0
	/// Шаг калибровки режимов (0 - не начата, 1-3 - этапы)
	var/calibration_step = 0
	/// Повреждён ли двигатель
	var/damaged = FALSE

	var/radio_channel = null
	/// Наше радио для передаи сообщений
	var/obj/item/radio/radio
	/// Ключ внутри нашего радио
	var/radio_key = /obj/item/encryptionkey/headset_eng

	COOLDOWN_DECLARE(turn_power_cd)
	COOLDOWN_DECLARE(change_mode_cd)
	COOLDOWN_DECLARE(damage_khara_cd)
	COOLDOWN_DECLARE(make_dizzy_cd)

/obj/machinery/morphological_engine/Initialize(mapload)
	. = ..()
	build_area_cache()
	radio = new(src)
	radio.keyslot = new radio_key
	radio.set_listening(FALSE)
	radio.recalculateChannels()

	SSpoints_of_interest.make_point_of_interest(src)
	if(main_engine && !GLOB.main_morph_engine)
		GLOB.main_morph_engine = src

/obj/machinery/morphological_engine/Destroy(force)
	. = ..()

	if(GLOB.main_morph_engine == src)
		GLOB.main_morph_engine = null

/obj/machinery/morphological_engine/examine(mob/user)
	. = ..()
	if(on)
		. += span_warning("Глаза напрягаются от попытки наблюдения за двигателем.")
		if(isliving(user))
			var/mob/living/living_user = user
			if(!living_user.is_eyes_covered())
				var/obj/item/organ/eyes/eyes = living_user.get_organ_slot(ORGAN_SLOT_EYES)
				if(eyes)
					eyes.apply_organ_damage(5)

	if(damaged)
		. += span_danger("Двигатель повреждён и нестабилен! Требуется ремонт.")

	if(access_step > 0 || calibration_step > 0)
		. += span_notice("Панель управления открыта для настройки режимов.")

	if(mode & MORPH_ENGINE_MODE_BARRIER)
		. += span_notice("<b>Режим барьера - включен.</b> Двигатель будет создавать силовой барьер, \
							что не даст мутантам Кхары физически пройти через него.")
	if(mode & MORPH_ENGINE_MODE_CONTAINMENT)
		. += span_notice("<b>Режим сдерживание - включен.</b> Двигатель будет эммитировать аномальную радиацию, \
							что будет замедлять развитие клеток Кхары в пределах зоны сдерживания.")
	if(mode & MORPH_ENGINE_MODE_ISOLATION)
		. += span_notice("<b>Режим изоляции - включен.</b> Двигатель будет эммитировать силовые волны - разрушая клетки Кхары \
							в пределах зоны сдерживания, значительно снижая её распространение. Внимание - этот режим \
							значительно повышает энергопотребление и может навредить всем больным.")

	if(on)
		. += span_warning("Текущее энергопотребление: [enabled_power_usage] ватт")

/obj/machinery/morphological_engine/proc/build_area_cache()
	if(!protected_area_types || !islist(protected_area_types) || !length(protected_area_types))
		return
	area_type_cache = list()
	for(var/area_type as anything in protected_area_types)
		area_type_cache |= typecacheof(area_type)

/obj/machinery/morphological_engine/proc/is_protected_area(area/A)
	if(!A)
		return FALSE
	if(!area_type_cache || !is_type_in_typecache(A.type, area_type_cache) || !protected_areas[A])
		return FALSE
	return TRUE

/obj/machinery/morphological_engine/proc/is_protected_turf(turf/T)
	if(!is_protected_area(get_area(T)))
		return FALSE
	return TRUE

/obj/machinery/morphological_engine/proc/can_block_movement(power_to_block)
	if(!(mode & MORPH_ENGINE_MODE_BARRIER) || !on || !use_energy(power_to_block))
		return FALSE
	return TRUE

/obj/machinery/morphological_engine/proc/should_slow_khara()
	return on && (mode & MORPH_ENGINE_MODE_CONTAINMENT)

/obj/machinery/morphological_engine/proc/should_kill_khara()
	return on && (mode & MORPH_ENGINE_MODE_ISOLATION)

/obj/machinery/morphological_engine/proc/turn_on(mob/user)
	if(on || damaged)
		return FALSE
	if(!COOLDOWN_FINISHED(src, turn_power_cd))
		to_chat(user, span_warning("Двигатель ещё не остыл после предыдущего включения!"))
		return FALSE
	enabled_power_usage = 0

	if(mode & MORPH_ENGINE_MODE_BARRIER)
		enabled_power_usage += 20 KILO WATTS
	if(mode & MORPH_ENGINE_MODE_CONTAINMENT)
		enabled_power_usage += 40 KILO WATTS
	if(mode & MORPH_ENGINE_MODE_ISOLATION)
		enabled_power_usage += 100 KILO WATTS

	on = TRUE
	protect_areas()

	for(var/mob/living/L in GLOB.alive_player_list)
		if(!is_protected_turf(get_turf(L)))
			continue
		flash_color(L, flash_color = COLOR_NAVY, flash_time = 3 SECONDS)
		to_chat(L, span_notice("Ты ощущаешь, как твое тело обвалакивает экзотическая материя."))
		new /obj/effect/temp_visual/morph_engine_block(get_turf(L))

	radio.talk_into(
		src,
		"ВНИМАНИЕ: Морфологический двигатель - включен.",
		radio_channel,
		list(SPAN_COMMAND)
	)

	update_appearance()
	begin_processing()
	visible_message(span_notice("[src] издаёт низкий гул и активируется."))
	COOLDOWN_START(src, turn_power_cd, 60 SECONDS)
	return TRUE

/obj/machinery/morphological_engine/proc/turn_off(mob/user)
	if(!on)
		return FALSE

	radio.talk_into(
		src,
		"ВНИМАНИЕ: Морфологический двигатель - выключен.",
		radio_channel,
		list(SPAN_COMMAND)
	)

	enabled_power_usage = 0
	on = FALSE
	update_appearance()
	end_processing()
	cleanup_areas()
	visible_message(span_notice("[src] затихает и деактивируется."))
	COOLDOWN_START(src, turn_power_cd, 60 SECONDS)
	return TRUE

/obj/machinery/morphological_engine/proc/protect_areas()
	for(var/area_type in area_type_cache)
		var/list/instances = get_areas(area_type, FALSE)
		if(!length(instances))
			continue
		for(var/area/instance in instances)
			if(!instance || instance.z != z)
				continue
			if(should_slow_khara())
				ADD_TRAIT(instance, TRAIT_AREA_MORPENGINE, REF(src))
			if(should_kill_khara())
				ADD_TRAIT(instance, TRAIT_AREA_MORPENGINE_HAZARD, REF(src))
			LAZYADDASSOC(protected_areas, instance, TRUE)

/obj/machinery/morphological_engine/proc/cleanup_areas()
	for(var/area/A in protected_areas)
		REMOVE_TRAIT(A, TRAIT_AREA_MORPENGINE, REF(src))
		REMOVE_TRAIT(A, TRAIT_AREA_MORPENGINE_HAZARD, REF(src))
	protected_areas = null

/obj/machinery/morphological_engine/process()
	if(!on)
		return PROCESS_KILL

	if(!powered() || !use_energy(enabled_power_usage))
		balloon_alert_to_viewers("Недостаточное питание - отключение!")
		turn_off()
		return


/obj/machinery/morphological_engine/attack_hand(mob/living/user, list/modifiers)
	add_fingerprint(user)
	if(access_step > 0 || calibration_step > 0)
		to_chat(user, span_warning("Панель открыта — сначала завершите настройку!"))
		return

	if(!COOLDOWN_FINISHED(src, turn_power_cd))
		to_chat(user, span_warning("Двигатель ещё не остыл после предыдущего переключения!"))
		return

	balloon_alert_to_viewers("Переключение настроек!")
	if(!do_after(user, 10 SECONDS, src))
		balloon_alert_to_viewers("Переключение прервано!")
		return
	if(on)
		balloon_alert_to_viewers("Двигатель - выключен!")
		turn_off(user)
	else
		balloon_alert_to_viewers("Двигатель - включен!")
		turn_on(user)

/obj/machinery/morphological_engine/attackby(obj/item/I, mob/living/user, params)
	if(damaged && I.tool_behaviour != TOOL_WELDER)
		return ..()


	if(!on && access_step < 3 && calibration_step == 0)
		switch(access_step)
			if(0)
				if(I.tool_behaviour == TOOL_SCREWDRIVER)
					if(do_after(user, 2 SECONDS, target = src))
						access_step = 1
						I.play_tool_sound(src)
						to_chat(user, span_notice("Вы аккуратно открутили крепления панели управления."))
						visible_message(span_notice("[user] откручивает панель на [src]."))
						return TRUE
					return

			if(1)
				if(I.tool_behaviour == TOOL_WRENCH)
					if(do_after(user, 2 SECONDS, target = src))
						access_step = 2
						I.play_tool_sound(src)
						to_chat(user, span_notice("Вы затянули болты внутренних контуров."))
						visible_message(span_notice("[user] подтягивает болты [src]."))
						return TRUE
					return

			if(2)
				if(I.tool_behaviour == TOOL_WELDER)
					if(!I.use_tool(src, user, 3 SECONDS, volume = 50))
						return
					access_step = 3
					to_chat(user, span_notice("Вы заварили герметичные соединения панели."))
					visible_message(span_notice("[user] заваривает панель [src]."))
					do_mode_selection(user)
					return TRUE

	if(access_step == 3 && calibration_step >= 0)
		switch(calibration_step)
			if(0)
				if(I.tool_behaviour == TOOL_SCREWDRIVER)
					if(do_after(user, 5 SECONDS, target = src))
						if(prob(20))
							fail_calibration(user)
							return TRUE
						calibration_step = 1
						I.play_tool_sound(src)
						to_chat(user, span_notice("Калибровочные винты выставлены в новые позиции."))
						return TRUE
					return

			if(1)
				if(I.tool_behaviour == TOOL_WRENCH)
					if(do_after(user, 5 SECONDS, target = src))
						if(prob(20))
							fail_calibration(user)
							return TRUE
						calibration_step = 2
						I.play_tool_sound(src)
						to_chat(user, span_notice("Крепления излучателей Морф-двигателя надёжно подтянуты."))
						return TRUE
					return

			if(2)
				if(I.tool_behaviour == TOOL_WELDER)
					if(!I.use_tool(src, user, 8 SECONDS, volume = 60))
						return
					if(prob(20))
						fail_calibration(user)
						return TRUE

					mode = pending_mode
					access_step = 0
					calibration_step = 0
					pending_mode = 0
					visible_message(span_boldnotice("[src] издаёт стабильный гул — калибровка завершена успешно!"))
					to_chat(user, span_notice("Режимы морфологического двигателя успешно настроены."))
					COOLDOWN_START(src, change_mode_cd, 30 SECONDS)
					return TRUE

	if(on)
		to_chat(user, span_warning("Невозможно проводить настройку, пока двигатель включён!"))
		return ..()

	return ..()


/obj/machinery/morphological_engine/proc/create_radial_choice(name, image, info)
	var/datum/radial_menu_choice/choise = new()
	choise.name = name
	choise.info = info
	choise.image = image
	return choise

/obj/machinery/morphological_engine/proc/do_mode_selection(mob/user)
	if(access_step < 3 || !user || !Adjacent(user))
		return

	if(!pending_mode)
		pending_mode = mode

	var/continue_choosing = TRUE
	while(continue_choosing && Adjacent(user) && !QDELETED(src) && !damaged)
		for(var/i)
		var/list/radial_choices = list(
			"toggle_barrier" = create_radial_choice("Барьер ([pending_mode & MORPH_ENGINE_MODE_BARRIER ? "ВКЛ" : "ВЫКЛ"])"),
			"toggle_containment" = create_radial_choice("Сдерживание ([pending_mode & MORPH_ENGINE_MODE_CONTAINMENT ? "ВКЛ" : "ВЫКЛ"])"),
			"toggle_isolation" = create_radial_choice("Изоляция ([pending_mode & MORPH_ENGINE_MODE_ISOLATION ? "ВКЛ" : "ВЫКЛ"])"),
			"confirm" = create_radial_choice("Подтвердить изменения"),
		)

		var/choice = show_radial_menu(user, get_turf(src), radial_choices, radius = 24, require_near = TRUE, tooltips = TRUE)
		if(!choice || !Adjacent(user))
			continue_choosing = FALSE
			break

		switch(choice)
			if("toggle_barrier")
				pending_mode |= MORPH_ENGINE_MODE_BARRIER
				to_chat(user, span_notice("Режим Барьера переключён."))
			if("toggle_containment")
				pending_mode |= MORPH_ENGINE_MODE_CONTAINMENT
				to_chat(user, span_notice("Режим Сдерживания переключён."))
			if("toggle_isolation")
				pending_mode |= MORPH_ENGINE_MODE_ISOLATION
				to_chat(user, span_notice("Режим Изоляции переключён."))
			if("confirm")
				if(pending_mode == mode)
					to_chat(user, span_warning("Вы не изменили режимы."))
					pending_mode = NONE
					return
				to_chat(user, span_boldnotice("Режимы выбраны. Переход к калибровке..."))
				calibration_step = 0
				continue_choosing = FALSE

/obj/machinery/morphological_engine/proc/fail_calibration(mob/user)
	visible_message(span_danger("[src] внезапно перегружается! Искры вылетают из панели!"))
	do_sparks(5, FALSE, src)
	calibration_step = 0


/obj/item/paper/guides/fenysha_events/morph_engine
	name = "Бумага — «Краткое руководство по Морфологическому двигателю!»"
	default_raw_text = "<B>Морфологический двигатель — полное руководство</B><BR>\
	<HR>\
	<B>Назначение</B><BR>\
	Двигатель защищает внутренние помещения поезда от мутации Кхары.<BR>\
	Создаёт силовые поля, аномальную радиацию и волны, блокируя, замедляя и уничтожая клетки Кхары.<BR>\
	Это главный (и единственный) двигатель поезда.<BR>\
	<HR>\
	<B>Три режима работы(совмещаются)</B><BR>\
	- <B>Барьер</B> (20 кВт): физический энергетический барьер.<BR>\
	  Мутанты Кхары НЕ МОГУТ войти в зону, силовая волна выбрасывает назад.<BR>\
	  Внутри помещений и выход — свободны.<BR>\
	- <B>Сдерживание</B> (40 кВт): аномальная радиация.<BR>\
	  Замедляет развитие и распространение клеток Кхары в зоне.<BR>\
	- <B>Изоляция</B> (100 кВт): силовые волны.<BR>\
	  Активно разрушает клетки Кхары, сильно снижая заражение.<BR>\
	  <B>ВНИМАНИЕ:</B> очень высокое потребление энергии + может навредить ВСЕМ заражённым в зоне!<BR>\
	<HR>\
	<B>Как изменить режимы (только когда двигатель ВЫКЛЮЧЕН)</B><BR>\
	1. Отвёрткой — открутить панель.<BR>\
	2. Гаечным ключом — подтянуть внутренние болты.<BR>\
	3. Сваркой — заварить герметичные соединения.<BR>\
	4. В меню: нажмите на нужные режимы (Барьер / Сдерживание / Изоляция) — они переключаются.<BR>\
		Нажмите «Подтвердить изменения».<BR>\
	5. Калибровка (после подтверждения):<BR>\
		- Отвёртка<BR>\
		- Гаечный ключ<BR>\
		- Сварка<BR>\
	<B>ВНИМАНИЕ:</B> на каждом шаге калибровки — есть шанс провала!<BR>\
	После успешной калибровки режимы зафиксированы.<BR>\
	<HR>\
	<B>Дополнительно</B><BR>\
	- При включении все живые в зоне действия, могут получть легкое недомагание.<BR>\
	- Если панель открыта — сначала завершите настройку или калибровку.<BR>\
	- Главный двигатель один на всю станцию.<BR>\
	Удачи, инженер! Не дайте Кхаре прорваться."
