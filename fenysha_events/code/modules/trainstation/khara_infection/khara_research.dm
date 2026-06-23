#define TECHWEB_NODE_KHARA_START "evt_khara_start"
#define TECHWEB_NODE_KHARA_BASIC "evt_khara_basic"
#define TECHWEB_NODE_KHARA_INITIAL_INFECTION "evt_khara_initinfection"
#define TECHWEB_NODE_KHARA_AMMUNITION_BASIC "evt_khara_combat"
#define TECHWEB_NODE_KHARA_AMMUNITION_ADVANCED "evt_khara_combatadv"
#define TECHWEB_NODE_KHARA_POSITIVE_BASIC "evt_khara_med_basic"
#define TECHWEB_NODE_KHARA_POSITIVE_ADVANCED "evt_khara_med_advanced"


/datum/design/khara_express_test
	name = "Экспресс тест 'Кхара'"
	desc = "Дизайн простой лаборатории, способной быстро определить наличие анти-тел Кхары в крови."
	id = "khara_test"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 1.5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/khara_express_test
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/obj/item/khara_express_test
	name = "Экспресс Тест 'Кхара'"
	desc = "Простой девайс представляющий из себя микроскопическую лабораторию, \
			способную проверку реакцию органики на клетки зараженные вирусом 'Кхара'"
	force = 0
	throwforce = 0
	icon = 'fenysha_events/icons/items/devices.dmi'
	icon_state = "kharatest"

	w_class = WEIGHT_CLASS_TINY

	var/disease_path = /datum/disease/khara
	VAR_PRIVATE/used = FALSE

/obj/item/khara_express_test/attacked_by(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!is_reagent_container(attacking_item))
		return ..()
	if(used)
		balloon_alert_to_viewers("Тестер уже использован!")
		return
	perform_test(attacking_item, user)

/obj/item/khara_express_test/proc/perform_test(obj/item/reagent_containers/container, mob/living/user)
	if(container.reagents.total_volume == 0)
		balloon_alert_to_viewers("Образец пуст!")
		return

	if(!container.reagents.has_reagent(/datum/reagent/blood))
		balloon_alert_to_viewers("В образце отсутствует кровь!")
		return

	if(!do_after(user, 3 SECONDS, src))
		return

	var/has_khara = FALSE
	for(var/datum/reagent/blood/blood_reagent as anything in container.reagents.reagent_list)
		if(!istype(blood_reagent))
			continue

		var/list/viruses = blood_reagent.data?["viruses"]
		if(!length(viruses))
			continue

		for(var/datum/disease/D as anything in viruses)
			if(istype(D, disease_path))
				has_khara = TRUE

	used = TRUE
	if(has_khara)
		balloon_alert_to_viewers("Обнаружен враждебный патоген!")
		icon_state = "kharatest_bad"
		playsound(src, 'sound/machines/beep/twobeep.ogg', vol = 50, vary = TRUE)
	else
		balloon_alert_to_viewers("Образец чист!")
		icon_state = "kharatest_good"
		playsound(src, 'sound/machines/buzz/buzz-two.ogg', vol = 40, vary = TRUE)

	update_appearance()

/datum/design/ranged_experi_scanner
	name = "Дистанционный сканер"
	desc = "Продвинутый дистанционный сканер, позволяющий сканировать цели на расстоянии. Как удобно!"
	id = "ranged_experiscaner"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = COIN_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/ranged_experi_scanner
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE


/obj/item/ranged_experi_scanner
	name = "Experi-Scanner"
	desc = "A handheld scanner used for completing the many experiments of modern science."
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'fenysha_events/icons/items/devices.dmi'
	icon_state = "ranged_scaner"
	inhand_icon_state = "export_scanner"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	sound_vary = TRUE
	pickup_sound = SFX_GENERIC_DEVICE_PICKUP
	drop_sound = SFX_GENERIC_DEVICE_DROP

	var/max_distance = 5
	var/datum/component/experiment_handler/handler = null

/obj/item/ranged_experi_scanner/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/ranged_experi_scanner/LateInitialize()
	var/static/list/handheld_signals = list(
		COMSIG_ITEM_PRE_ATTACK = TYPE_PROC_REF(/datum/component/experiment_handler, try_run_handheld_experiment),
		COMSIG_ITEM_AFTERATTACK = TYPE_PROC_REF(/datum/component/experiment_handler, ignored_handheld_experiment_attempt),
	)
	handler = AddComponent(/datum/component/experiment_handler, \
		allowed_experiments = list(/datum/experiment/scanning, /datum/experiment/physical), \
		disallowed_traits = EXPERIMENT_TRAIT_DESTRUCTIVE, \
		config_flags = EXPERIMENT_CONFIG_ALWAYS_ANNOUNCE, \
		experiment_signals = handheld_signals, \
	)

/obj/item/ranged_experi_scanner/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(QDELETED(interacting_with) || QDELETED(user) || user.stat != CONSCIOUS)
		return
	if(get_dist(get_turf(src), interacting_with) > max_distance)
		balloon_alert(user, "Слишком далеко!")
		return
	handler.try_run_handheld_experiment(src, interacting_with, user, modifiers)

/**
 * Эксперимент: Сканирование образцов крови с вирусом Кхара
 */
/datum/experiment/scanning/blood_khara
	name = "Сканирование образцов крови с вирусом Кхара"
	description = "Проведите сканирование образцов крови, содержащих вирус Кхара."
	exp_tag = "Сканирование крови"
	allowed_experimentors = list(/obj/item/experi_scanner, /obj/item/ranged_experi_scanner, /obj/item/scanner_wand)
	required_atoms = list(/obj/item/reagent_containers = 1)
	/// Требуемый вирус
	var/datum/disease/required_disease = /datum/disease/khara

/datum/experiment/scanning/blood_khara/final_contributing_index_checks(datum/component/experiment_handler/experiment_handler, atom/target, typepath)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(target, /obj/item/reagent_containers))
		return FALSE
	return is_valid_scan_target(experiment_handler, target)

/datum/experiment/scanning/blood_khara/proc/is_valid_scan_target(datum/component/experiment_handler/experiment_handler, obj/item/reagent_containers/container)
	SHOULD_CALL_PARENT(TRUE)
	if(container.reagents.total_volume == 0)
		experiment_handler.announce_message("Образец крови пуст!")
		return FALSE

	if(!container.reagents.has_reagent(/datum/reagent/blood))
		experiment_handler.announce_message("В образце отсутствует кровь!")
		return FALSE

	for(var/datum/reagent/blood/blood_reagent as anything in container.reagents.reagent_list)
		if(!istype(blood_reagent))
			continue

		var/list/viruses = blood_reagent.data?["viruses"]
		if(!length(viruses))
			continue

		for(var/datum/disease/D as anything in viruses)
			if(istype(D, required_disease))
				return TRUE

	experiment_handler.announce_message("Вирус Кхара не обнаружен в образце крови!")
	return FALSE

/datum/experiment/scanning/blood_khara/serialize_progress_stage(atom/target, list/seen_instances)
	return EXPERIMENT_PROG_INT("Просканируйте [required_atoms[target]] образцов крови с вирусом [required_disease::name].", \
		seen_instances.len, required_atoms[target])

/**
 * Эксперимент: Сканирование заражённого человека (видимая болезнь Кхара)
 */
/datum/experiment/scanning/infected_human
	name = "Сканирование заражённого человека"
	description = "Проведите сканирование живого человека, поражённого вирусом Кхара."
	allowed_experimentors = list(/obj/item/experi_scanner, /obj/item/ranged_experi_scanner, /obj/item/scanner_wand)
	required_atoms = list(/mob/living/carbon/human = 1)
	/// Требуемый вирус
	var/datum/disease/required_disease = /datum/disease/khara
	/// Минимальная стадия болезни
	var/required_stage = 1
	/// Должна ли болезнь быть видимой (TRUE = без флагов невидимости)
	var/required_visible = TRUE

/datum/experiment/scanning/infected_human/final_contributing_index_checks(datum/component/experiment_handler/experiment_handler, atom/target, typepath)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(target))
		return FALSE
	return is_valid_scan_target(experiment_handler, target)

/datum/experiment/scanning/infected_human/proc/is_valid_scan_target(datum/component/experiment_handler/experiment_handler, mob/living/carbon/human/target)
	SHOULD_CALL_PARENT(TRUE)
	if(target.stat == DEAD)
		experiment_handler.announce_message("Цель мертва!")
		return FALSE

	if(!length(target.diseases))
		experiment_handler.announce_message("У цели нет активных заболеваний!")
		return FALSE

	for(var/datum/disease/D as anything in target.diseases)
		if(!istype(D, required_disease))
			continue

		// Проверка видимости
		if(required_visible && D.visibility_flags)
			continue

		// Проверка стадии
		if(D.stage >= required_stage)
			return TRUE

		experiment_handler.announce_message("Стадия вируса недостаточна! Требуется минимум [required_stage]-я стадия.")
		return FALSE

	experiment_handler.announce_message("Вирус [required_disease::name] не обнаружен!")
	return FALSE

/datum/experiment/scanning/infected_human/serialize_progress_stage(atom/target, list/seen_instances)
	var/visible_text = required_visible ? " (вирус должен быть видимым при сканировании)" : ""
	return EXPERIMENT_PROG_INT("Просканируйте человека, заражённого вирусом [required_disease::name], на [required_stage]-й стадии или выше.[visible_text]", \
		seen_instances.len, required_atoms[target])

/datum/experiment/scanning/infected_human/late_khara
	required_stage = 7

/datum/experiment/scanning/infected_human/true_khara
	required_disease = /datum/disease/true_khara

/**
 * Эксперимент: Сканирование существ, поражённых Кхара
 */
/datum/experiment/scanning/khara_creature
	name = "Сканирование пораженных Кхара существ"
	description = "Проведите сканирование существ, обращённых вирусом Кхара."
	performance_hint = "Поражённые Кхара в основном состоят из мышечной ткани. Их легко замедлить шоковым оружием."
	allowed_experimentors = list(/obj/item/experi_scanner, /obj/item/ranged_experi_scanner, /obj/item/scanner_wand)

	var/required_count = 3
	var/required_cast = KHARA_CAST_LESSER
	var/mob/living/basic/khara_mutant/restricted_type = null
	var/exploration_text = "Подойдут самые примитивные формы — например, мясные пауки."

/datum/experiment/scanning/khara_creature/New(datum/techweb/techweb)
	required_atoms = list(/mob/living/basic/khara_mutant = required_count)
	return ..()

/datum/experiment/scanning/khara_creature/final_contributing_index_checks(datum/component/experiment_handler/experiment_handler, atom/target, typepath)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(target, /mob/living/basic/khara_mutant))
		return FALSE
	return is_valid_scan_target(experiment_handler, target)

/datum/experiment/scanning/khara_creature/proc/is_valid_scan_target(datum/component/experiment_handler/experiment_handler, mob/living/basic/khara_mutant/target)
	SHOULD_CALL_PARENT(TRUE)
	if(restricted_type && !istype(target, restricted_type))
		experiment_handler.announce_message("Неподходящий тип мутанта!")
		return FALSE

	if(target.cast != required_cast)
		experiment_handler.announce_message("Мутант принадлежит другой касте!")
		return FALSE

	return TRUE

/datum/experiment/scanning/khara_creature/serialize_progress_stage(atom/target, list/seen_instances)
	return EXPERIMENT_PROG_INT("Просканируйте [required_atoms[target]] пораженных Кхара касты [required_cast]. [exploration_text]", \
		seen_instances.len, required_atoms[target])

/datum/experiment/scanning/khara_creature/adapted
	required_cast = KHARA_CAST_ADAPTED
	required_count = 2
	exploration_text = "Подойдут адаптированные формы — жнецы и арахниды."

/datum/experiment/scanning/khara_creature/assimilating
	required_cast = KHARA_CAST_ASSIMILATING
	required_count = 1
	exploration_text = "Подойдут ассимилирующие формы — распространители."


/datum/aas_config_entry/khara_research
	name = "Science Alert: Прогресс исследования Кхара"
	modifiable = FALSE
	announcement_lines_map = list(
		"Message" = "Получена новая информация о вирусе Кхара: «%KHARA_DATA»"
	)
	vars_and_tooltips_map = list(
		"KHARA_DATA" = "будет заменено на текст исследования"
	)


/datum/techweb_node/khara
	var/document_to_spawn = null
	var/research_text = null

/datum/techweb_node/khara/on_station_research(atom/research_source)
	. = ..()
	var/channels_to_use = announce_channels
	if(istype(research_source, /obj/machinery/computer/rdconsole))
		var/obj/machinery/computer/rdconsole/console = research_source
		var/obj/item/circuitboard/computer/rdconsole/board = console.circuit
		if(board.obj_flags & EMAGGED)
			channels_to_use = list(RADIO_CHANNEL_COMMON)

	if(length(channels_to_use) && research_text)
		aas_config_announce(/datum/aas_config_entry/khara_research, list("KHARA_DATA" = research_text), null, channels_to_use)

	if(document_to_spawn && research_source)
		research_source.visible_message(span_notice("Печатается важный исследовательский документ!"))
		new document_to_spawn(get_turf(research_source))


// НОДЫ ИССЛЕДОВАНИЯ + СООТВЕТСТВУЮЩИЕ ДОКУМЕНТЫ


/datum/techweb_node/khara_start
	id = TECHWEB_NODE_KHARA_START
	starting_node = TRUE
	display_name = "Информация о наличии в мире вируса Кхара"
	description = "Вы получили данные о наличии в мире вируса Кхара."
	experiments_to_unlock = list(/datum/experiment/scanning/blood_khara)

/datum/techweb_node/khara/khara_basic
	id = TECHWEB_NODE_KHARA_BASIC
	display_name = "Базовая информация о вирусе Кхара"
	description = "Получены первичные данные о вирусе Кхара и его характеристиках."
	prereq_ids = list(TECHWEB_NODE_CHEM_SYNTHESIS, TECHWEB_NODE_KHARA_START)
	design_ids = list(
		"khara_test",
		"ranged_experiscaner",
	)

	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	required_experiments = list(/datum/experiment/scanning/blood_khara)
	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE)
	document_to_spawn = /obj/item/paper/khara_basic_research

	research_text = "Первичные исследования показали, что вирус Кхара обладает крайне высокой устойчивостью к изменениям температуры, \
					особенно к высоким значениям. Однако радиоактивное излучение оказывает выраженное негативное воздействие на заражённые клетки. \
					Введение пациенту технеция-99 может значительно замедлить прогрессирование болезни."

/obj/item/paper/khara_basic_research
	name = "Отчёт: Базовые исследования вируса Кхара"
	default_raw_text = \
	"<center><b>ОТЧЁТ ИССЛЕДОВАТЕЛЬСКОГО ОТДЕЛА</b></center>\
	<BR>\
	<b>Тема:</b> Базовая информация о вирусе Кхара<BR>\
	<BR>\
	Первичные исследования показали, что вирус Кхара обладает крайне высокой устойчивостью к изменениям температуры, особенно к высоким значениям. Однако радиоактивное излучение оказывает выраженное негативное воздействие на заражённые клетки. Введение пациенту технеция-99 может значительно замедлить прогрессирование болезни.\
	<BR><BR>\
	<b>СЕКРЕТНО — УРОВЕНЬ III</b><BR>\
	Документ является конфиденциальным. Запрещено копирование. Запрещено обсуждение вне научного и медицинского персонала. Запрещено оставлять без охраны.\
	<BR><BR>\
	— Исследовательский отдел"

/datum/techweb_node/khara/khara_initial_infection
	id = TECHWEB_NODE_KHARA_INITIAL_INFECTION
	display_name = "Механизм развития вируса Кхара"
	description = "Получена информация о развитии вируса в организме и методах противодействия."
	prereq_ids = list(TECHWEB_NODE_KHARA_BASIC, TECHWEB_NODE_MEDBAY_EQUIP_ADV)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 2)
	required_experiments = list(/datum/experiment/scanning/infected_human, /datum/experiment/scanning/khara_creature)
	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY)
	document_to_spawn = /obj/item/paper/khara_initial_infection_research
	experiments_to_unlock = list(/datum/experiment/scanning/khara_creature/adapted)

	research_text = "Исследование живых и заражённых образцов выявило, что некоторые химикаты способны эффективно противодействовать созданиям Кхара. \
					Анацея, голопередол и резадон способны обращать вспять развитие заражённых клеток и частично лечить больных. \
					Кроме того, ткань мутантов обладает высокой восприимчивостью к физическому урону — оружие ближнего боя особенно эффективно против них."

/obj/item/paper/khara_initial_infection_research
	name = "Отчёт: Механизм развития вируса Кхара"
	default_raw_text = \
	"<center><b>ОТЧЁТ ИССЛЕДОВАТЕЛЬСКОГО ОТДЕЛА</b></center>\
	<BR>\
	<b>Тема:</b> Механизм развития вируса Кхара и методы противодействия<BR>\
	<BR>\
	Исследование живых и заражённых образцов выявило, что некоторые химикаты способны эффективно противодействовать созданиям Кхара. Анацея, голопередол и резадон способны обращать вспять развитие заражённых клеток и частично лечить больных. Кроме того, ткань мутантов обладает высокой восприимчивостью к физическому урону — оружие ближнего боя особенно эффективно против них.\
	<BR><BR>\
	<b>СЕКРЕТНО — УРОВЕНЬ III</b><BR>\
	Документ является конфиденциальным. Запрещено копирование. Запрещено обсуждение вне научного и медицинского персонала. Запрещено оставлять без охраны.\
	<BR><BR>\
	— Исследовательский отдел"

/datum/techweb_node/khara/khara_ammunition_basic
	id = TECHWEB_NODE_KHARA_AMMUNITION_BASIC
	display_name = "Базовое вооружение против заражённых Кхара"
	description = "Получены чертежи специальных боеприпасов и оружия для борьбы с поражёнными."
	design_ids = list(
		"anti_khara_ammunition",
		"anti_khara_weapon_sword",
	)
	prereq_ids = list(TECHWEB_NODE_KHARA_INITIAL_INFECTION, TECHWEB_NODE_BEAM_WEAPONS)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 3)
	required_experiments = list(/datum/experiment/scanning/khara_creature/adapted)
	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY, RADIO_CHANNEL_COMMON, RADIO_CHANNEL_SUPPLY)
	document_to_spawn = /obj/item/paper/khara_ammunition_basic_research
	experiments_to_unlock = list(/datum/experiment/scanning/khara_creature/assimilating)

	research_text = "Дальнейшие исследования мутантов высоких каст показали, что все поражённые Кхара обладают коллективным сознанием и способны \
					обмениваться информацией на расстоянии. Это позволило создать боеприпасы, улавливающие данный сигнал и наносящие \
					урон исключительно созданиям Кхара, игнорируя обычных людей. Кроме того, теперь для создания доступна линейка особенного Анти-кхара оружия."

/obj/item/paper/khara_ammunition_basic_research
	name = "Отчёт: Базовое вооружение против Кхара"
	default_raw_text = \
	"<center><b>ОТЧЁТ ИССЛЕДОВАТЕЛЬСКОГО ОТДЕЛА</b></center>\
	<BR>\
	<b>Тема:</b> Базовое вооружение против заражённых Кхара<BR>\
	<BR>\
	Дальнейшие исследования мутантов высоких каст показали, что все поражённые Кхара обладают коллективным сознанием и способны обмениваться информацией на расстоянии. Это позволило создать боеприпасы, улавливающие данный сигнал и наносящие урон исключительно созданиям Кхара, игнорируя обычных людей. Кроме того, теперь для создания доступна линейка особенного Анти-кхара оружия.\
	<BR><BR>\
	<b>СЕКРЕТНО — УРОВЕНЬ IV</b><BR>\
	Документ является конфиденциальным. Запрещено копирование. Запрещено обсуждение вне научного и охранного персонала. Запрещено оставлять без охраны.\
	<BR><BR>\
	— Исследовательский отдел"

/datum/techweb_node/khara/khara_ammunition_advanced
	id = TECHWEB_NODE_KHARA_AMMUNITION_ADVANCED
	display_name = "Продвинутое анти-Кхара вооружение"
	description = "Получены чертежи продвинутого оружия для уничтожения крупных колоний заражённых."
	prereq_ids = list(TECHWEB_NODE_KHARA_AMMUNITION_BASIC)
	design_ids = list(
		"anti_khara_grenade",
		"anti_khara_weapon_greatsword",
		"anti_khara_weapon_spear",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 4)
	required_experiments = list(/datum/experiment/scanning/khara_creature/assimilating)
	announce_channels = list(RADIO_CHANNEL_SUPPLY, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY)
	document_to_spawn = /obj/item/paper/khara_ammunition_advanced_research

	research_text = "Исследования самых массивных мутантов позволили синтезировать чертежи продвинутых гранат, генерирующих особое энергетическое поле, \
					в котором инфекция Кхара не способна существовать. А так же самого продвинутого оружия ближнего боя."

/obj/item/paper/khara_ammunition_advanced_research
	name = "Отчёт: Продвинутое анти-Кхара вооружение"
	default_raw_text = \
	"<center><b>ОТЧЁТ ИССЛЕДОВАТЕЛЬСКОГО ОТДЕЛА</b></center>\
	<BR>\
	<b>Тема:</b> Продвинутое вооружение против колоний Кхара<BR>\
	<BR>\
	Исследования самых массивных мутантов позволили синтезировать чертежи продвинутых гранат, генерирующих особое энергетическое поле, в котором инфекция Кхара не способна существовать.\
	<BR><BR>\
	<b>СЕКРЕТНО — УРОВЕНЬ IV</b><BR>\
	Документ является конфиденциальным. Запрещено копирование. Запрещено обсуждение вне научного и охранного персонала. Запрещено оставлять без охраны.\
	<BR><BR>\
	— Исследовательский отдел"

/datum/techweb_node/khara/khara_positive_basic
	id = TECHWEB_NODE_KHARA_POSITIVE_BASIC
	display_name = "Альтернативное развитие вируса Кхара"
	description = "Получена информация о положительных мутациях, вызываемых вирусом."
	prereq_ids = list(TECHWEB_NODE_KHARA_INITIAL_INFECTION)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 3)
	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY, RADIO_CHANNEL_COMMON)
	document_to_spawn = /obj/item/paper/khara_positive_basic_research
	experiments_to_unlock = list(/datum/experiment/scanning/infected_human/true_khara, /datum/experiment/scanning/infected_human/late_khara)

	research_text = "Несмотря на высокий уровень опасности, вирус Кхара в редких случаях вызывает обратную реакцию. \
					Некоторые организмы вместо мутаций получают выдающиеся физические способности. Вероятность положительной мутации крайне мала и \
					сильно зависит от индивидуальных особенностей подопытного. Необходимо продолжить изучение перерождённых субъектов.\
					Их отличительная черта — полностью белые глаза."

/obj/item/paper/khara_positive_basic_research
	name = "Отчёт: Альтернативное развитие вируса Кхара"
	default_raw_text = \
	"<center><b>ОТЧЁТ ИССЛЕДОВАТЕЛЬСКОГО ОТДЕЛА</b></center>\
	<BR>\
	<b>Тема:</b> Альтернативное развитие вируса Кхара<BR>\
	<BR>\
	Несмотря на высокий уровень опасности, вирус Кхара в редких случаях вызывает обратную реакцию. Некоторые организмы вместо мутаций получают выдающиеся физические способности. Вероятность положительной мутации крайне мала и сильно зависит от индивидуальных особенностей подопытного. Необходимо продолжить изучение перерождённых субъектов. Их отличительная черта — полностью белые глаза.\
	<BR><BR>\
	<b>СЕКРЕТНО — УРОВЕНЬ IV</b><BR>\
	Документ является конфиденциальным. Запрещено копирование. Запрещено обсуждение вне научного и медицинского персонала. Запрещено оставлять без охраны.\
	<BR><BR>\
	— Исследовательский отдел"

/datum/techweb_node/khara/khara_positive_advanced
	id = TECHWEB_NODE_KHARA_POSITIVE_ADVANCED
	display_name = "Перерождённые вирусом Кхара"
	description = "Подробная информация о положительном эффекте вируса и его использовании."
	prereq_ids = list(TECHWEB_NODE_KHARA_POSITIVE_BASIC)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 2)
	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY, RADIO_CHANNEL_COMMON)
	document_to_spawn = /obj/item/paper/khara_positive_advanced_research
	required_experiments = list(/datum/experiment/scanning/infected_human/true_khara)

	research_text = "В крайне редких случаях вирус Кхара действительно действует как лекарство. Высокий интеллект, \
					превосходные физические качества и сильные личностные черты значительно повышают шанс перерождения. \
					Перерождённые субъекты, судя по всему, обладают практически бессмертием. \
					Единственный способ остановить регенерацию — отделить голову или извлечь мозг."

/obj/item/paper/khara_positive_advanced_research
	name = "Отчёт: Перерождённые вирусом Кхара"
	default_raw_text = \
	"<center><b>ОТЧЁТ ИССЛЕДОВАТЕЛЬСКОГО ОТДЕЛА</b></center>\
	<BR>\
	<b>Тема:</b> Перерождённые вирусом Кхара<BR>\
	<BR>\
	В крайне редких случаях вирус Кхара действительно действует как лекарство. Высокий интеллект, превосходные физические качества и сильные личностные черты значительно повышают шанс перерождения. Перерождённые субъекты, судя по всему, обладают практически бессмертием. Единственный способ остановить регенерацию — отделить голову или извлечь мозг.\
	<BR><BR>\
	<b>СЕКРЕТНО — УРОВЕНЬ V</b><BR>\
	Документ является конфиденциальным. Запрещено копирование. Запрещено обсуждение вне научного и медицинского персонала. Запрещено оставлять без охраны.\
	<BR><BR>\
	— Исследовательский отдел"
