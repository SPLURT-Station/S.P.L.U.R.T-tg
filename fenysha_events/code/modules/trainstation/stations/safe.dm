/datum/train_station/near_station/abandoned_depo
	name = "Пристанционная зона — Заброшенное депо"
	map_path = "_maps/modular_events/trainstation/nearstations/static_abandoned_train_depo.dmm"


/datum/train_station/abandoned_depo
	name = "Железнодорожное депо Гайрена"
	desc = "Эвакуированное депо, расположенное в непосредственной близости от города Гайрен, \
			прямо за территорией завода, который ещё недавно выпускал самые современные поезда региона. \
			Сейчас здесь царит тишина, нарушаемая лишь скрипом металла на ветру и редкими хлопками лопнувших стёкол в заброшенных вагонах. \
			Радиомаяк молчит уже несколько недель."
	map_path = "_maps/modular_events/trainstation/abandoned_train_depot.dmm"
	creator = "Fenysha"
	possible_nearstations = list(/datum/train_station/near_station/abandoned_depo)
	possible_next = list(/datum/train_station/gairen)

	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_NO_SELECTION | TRAINSTATION_BLOCKING


/datum/train_station/gairen
	name = "Город Гайрен"
	desc = "Промышленный город на севере страны — когда-то один из важнейших транспортных и производственных узлов. \
			Десятки заводов, дымящих труб, бесконечные конвейеры и гул поездов круглые сутки. \
			Сейчас город переживает тяжёлые времена: многие предприятия остановлены, улицы опустели, а над заводами висит тяжёлый запах ржавчины и заброшенности. \
			Радиомаяк станции передаёт старое объявление о «временных мерах безопасности», но голос диктора давно сменился на автоматический цикл."
	map_path = "_maps/modular_events/trainstation/start_city.dmm"
	creator = "Kierri & Fenysha"
	ambience_sounds = list('fenysha_events/sounds/thefinalstation/piano_loop.ogg' = 33 SECONDS)

	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_NO_SELECTION | TRAINSTATION_BLOCKING | TRAINSTATION_LOCAL_CENTER


/datum/train_station/deep_forest
	name = "Глубокий лес"
	creator = "Fenysha"

	region = TRAINSTATION_REGION_THUNDRA
	map_path = "_maps/modular_events/trainstation/deep_forest.dmm"
	possible_nearstations = list(/datum/train_station/near_station/static_mountaints)

	// Можно добавить описание, если хочешь усилить атмосферу
	desc = "Густой, почти непроходимый лес, куда почти не проникает свет. \
			Старые рельсы давно заросли мхом и молодыми деревьями, а путь вперёд теряется в зелёной темноте. \
			Здесь нет радиомаяка, нет ориентиров — только тишина и ощущение, что за тобой кто-то наблюдает из-за деревьев."
