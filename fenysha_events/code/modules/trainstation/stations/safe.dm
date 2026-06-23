/datum/train_station/near_station/abandoned_depo
	name = "Station Area - Abandoned Depot"
	map_path = "_maps/modular_events/trainstation/nearstations/static_abandoned_train_depo.dmm"


/datum/train_station/abandoned_depo
	name = "Gairen Railway Depot"
	desc = "An evacuated depot located in the immediate vicinity of the city of Gairen, \
			right behind the grounds of the factory that, until recently, produced the most modern trains in the region. \
			Now silence reigns here, broken only by the creak of metal in the wind and the occasional pop of shattered glass in the abandoned cars. \
			The radio beacon has been silent for several weeks now."
	map_path = "_maps/modular_events/trainstation/abandoned_train_depot.dmm"
	creator = "Fenysha"
	possible_nearstations = list(/datum/train_station/near_station/abandoned_depo)
	possible_next = list(/datum/train_station/gairen)

	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_NO_SELECTION | TRAINSTATION_BLOCKING


/datum/train_station/gairen
	name = "City of Gairen"
	desc = "An industrial city in the north of the country - once one of the most important transport and production hubs. \
			Dozens of factories, smoking chimneys, endless conveyors and the rumble of trains around the clock. \
			Now the city is going through hard times: many enterprises have shut down, the streets have emptied, and a heavy smell of rust and abandonment hangs over the factories. \
			The station's radio beacon broadcasts an old announcement about \"temporary safety measures\", but the announcer's voice has long since been replaced by an automatic loop."
	map_path = "_maps/modular_events/trainstation/start_city.dmm"
	creator = "Kierri & Fenysha"
	ambience_sounds = list('fenysha_events/sounds/thefinalstation/piano_loop.ogg' = 33 SECONDS)

	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_NO_SELECTION | TRAINSTATION_BLOCKING | TRAINSTATION_LOCAL_CENTER


/datum/train_station/deep_forest
	name = "Deep Forest"
	creator = "Fenysha"

	region = TRAINSTATION_REGION_THUNDRA
	map_path = "_maps/modular_events/trainstation/deep_forest.dmm"
	possible_nearstations = list(/datum/train_station/near_station/static_mountaints)

	// You can add a description if you want to enhance the atmosphere
	desc = "A dense, almost impassable forest where light barely penetrates. \
			The old rails have long been overgrown with moss and young trees, and the path ahead is lost in the green darkness. \
			There is no radio beacon here, no landmarks - only silence and the feeling that someone is watching you from behind the trees."
