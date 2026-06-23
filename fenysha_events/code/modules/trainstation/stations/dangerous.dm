/datum/train_station/emergency_station_a13
	name = "Аварийная станция A13"
	desc = "Секретная военная станция без единой опознавательной надписи или эмблемы. \
			Здесь нет платформы, нет освещения, нет даже намёка на то, что поезда должны здесь останавливаться. \
			По слухам, её существование официально отрицается. Радиомаяк молчит."
	map_path = "_maps/modular_events/trainstation/emergency_a13.dmm"
	creator = "Fenysha"
	visible = FALSE

	station_type = TRAINSTATION_TYPE_MILITARY
	threat_level = THREAT_LEVEL_RISKY
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_NO_FORKS | TRAINSTATION_NO_SELECTION | TRAINSTATION_BLOCKING


/datum/train_station/infected_laboratory
	name = "Город Гайдзинь"
	map_path = "_maps/modular_events/trainstation/infected_lab.dmm"
	desc = "Огромный город с населением более полутора миллионов человек до недавнего времени. \
			Научный центр региона: десятки исследовательских институтов, принадлежащих крупнейшим корпорациям. \
			Сейчас радиомаяк передаёт зацикленное сообщение об эвакуации, начатой три дня назад. \
			Голос в эфире звучит устало и надтреснуто, будто запись уже много раз перезаписывалась."
	creator = "Fenysha & v1s1ti"

	station_type = TRAINSTATION_TYPE_CITY
	threat_level = THREAT_LEVEL_DANGEROUS
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_NO_SELECTION | TRAINSTATION_BLOCKING | TRAINSTATION_LOCAL_CENTER


/datum/train_station/start_point
	name = "Юнион Плаза"
	map_path = "_maps/modular_events/trainstation/plasa.dmm"
	creator = "Fenysha"
	station_flags = TRAINSTATION_NO_SELECTION | TRAINSTATION_BLOCKING | TRAINSTATION_FINAL_STATION
	desc = "Крупнейший научно-исследовательский комплекс вблизи густонаселённого мегаполиса. \
			Здесь находился головной институт по изучению болезни Кхара. \
			Официально — это конечная станция маршрута. \
			Неофициально — место, откуда уже никто не возвращался."
	station_type = TRAINSTATION_TYPE_MILITARY
	threat_level = THREAT_LEVEL_DEADLY
	region = TRAINSTATION_REGION_THUNDRA
	required_stations = 8

/datum/train_station/heart_of_infections
	name = "Сердце инфекции"
	map_path = "_maps/modular_events/trainstation/bossfight_map.dmm"
	creator = "V1SITY"

	station_flags = TRAINSTATION_ABSCTRACT | TRAINSTATION_BLOCKING
	station_type = TRAINSTATION_TYPE_MILITARY
	threat_level = THREAT_LEVEL_DEADLY
	region = TRAINSTATION_REGION_THUNDRA

/datum/train_station/military_house
	name = "Военная база Гайдзинь"
	creator = "Fenysha & TYWONKA"
	map_path = "_maps/modular_events/trainstation/military_side.dmm"
	desc = "Военная база, непосредственно примыкающая к городу Гайдзинь. \
			Последние сутки радиомаяк передаёт один и тот же текст: «Эвакуация начата. Гражданскому населению запрещено приближаться». \
			Голос механический, без интонаций. Кажется, человек давно уже не нажимал кнопку записи."
	station_type = TRAINSTATION_TYPE_MILITARY
	threat_level = THREAT_LEVEL_DANGEROUS
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_BLOCKING


/datum/train_station/missle_military_side
	name = "Военная база Роузвилль"
	creator = "v1s1ti & Fenysha"
	map_path = "_maps/modular_events/trainstation/missle_military_side.dmm"
	desc = "Одна из крупнейших военных баз региона, расположенная неподалёку от города Роузвилль. \
			Здесь дислоцированы несколько ракетных дивизионов стратегического назначения. \
			Радиомаяк передаёт тревожное сообщение об эвакуации, но тон голоса звучит скорее как предупреждение, чем как просьба о помощи."
	station_type = TRAINSTATION_TYPE_MILITARY
	threat_level = THREAT_LEVEL_DEADLY
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_BLOCKING | TRAINSTATION_LOCAL_CENTER


/datum/train_station/warehouses
	name = "Заброшенные склады"
	creator = "Fenysha & TYWONKA"
	map_path = "_maps/modular_events/trainstation/warehouse.dmm"
	desc = "Ряд огромных заброшенных складских комплексов с маленькой грузовой станцией сбоку. \
			Радиомаяк молчит уже несколько лет. Только ветер завывает в разбитых воротах и где-то вдалеке скрипят ржавые контейнеры."
	threat_level = THREAT_LEVEL_RISKY
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_BLOCKING


/datum/train_station/near_station/lost_dam
	name = "Пристанционная зона — Заброшенная плотина"
	map_path = "_maps/modular_events/trainstation/nearstations/static_lost_dam.dmm"


/datum/train_station/lost_dam
	name = "Гидроэлектростанция Пенроуз"
	creator = "Mold & Fenysha"
	desc = "Гигантская гидроэлектростанция в окрестностях города Пенроуз. \
			Несмотря на полное отсутствие персонала, радиомаяк всё ещё работает и передаёт короткое сообщение: «Станция функционирует в штатном режиме». \
			Турбины продолжают гудеть даже сейчас."
	threat_level = THREAT_LEVEL_HAZARDOUS
	region = TRAINSTATION_REGION_THUNDRA
	map_path = "_maps/modular_events/trainstation/lost_dam.dmm"
	possible_nearstations = list(/datum/train_station/near_station/lost_dam)


/datum/train_station/mines
	name = "Заброшенные шахты"
	creator = "Fenysha"
	map_path = "_maps/modular_events/trainstation/abandoned_mines.dmm"
	desc = "Огромный заброшенный шахтный комплекс с десятками километров выработок и пещер. \
			Радиомаяк станции не подаёт никаких сигналов уже очень давно. Только эхо капающей воды и редкие обвалы где-то в глубине."
	threat_level = THREAT_LEVEL_RISKY
	region = TRAINSTATION_REGION_THUNDRA
	possible_nearstations = list(/datum/train_station/near_station/static_mountaints)
	station_flags = TRAINSTATION_BLOCKING


/datum/train_station/collapsed_lab
	name = "Неопознанная структура"
	creator = "Mold & Fenysha"
	map_path = "_maps/modular_events/trainstation/collapsed_lab.dmm"
	desc = "Спутники не могут точно классифицировать объект. \
			Большая часть строения обрушена, но радиомаяк всё ещё работает и передаёт короткий, повторяющийся SOS-сигнал. \
			Сигнал идёт уже несколько недель без перерыва."
	threat_level = THREAT_LEVEL_DEADLY
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_BLOCKING
	required_stations = 5


/datum/train_station/radiosphere
	name = "Массивная структура"
	creator = "Fenysha & Mold"
	map_path = "_maps/modular_events/trainstation/radiosphere.dmm"
	desc = "Огромный объект неизвестного назначения, который спутники не могут опознать. \
			Вокруг него наблюдаются сильнейшие радиопомехи — все частоты забиты белым шумом и обрывками чужих голосов. \
			Иногда в помехах можно разобрать слова… но лучше не пытаться."
	threat_level = THREAT_LEVEL_DEADLY
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_BLOCKING
	required_stations = 5

	ambience_sounds = list('fenysha_events/sounds/radiosphere_loop1.ogg' = 40 SECONDS)
