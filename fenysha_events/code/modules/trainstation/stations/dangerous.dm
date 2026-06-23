/datum/train_station/emergency_station_a13
	name = "Emergency Station A13"
	desc = "A secret military station without a single identifying inscription or emblem. \
			There is no platform here, no lighting, not even a hint that trains are supposed to stop here. \
			Rumor has it that its existence is officially denied. The radio beacon is silent."
	map_path = "_maps/modular_events/trainstation/emergency_a13.dmm"
	creator = "Fenysha"
	visible = FALSE

	station_type = TRAINSTATION_TYPE_MILITARY
	threat_level = THREAT_LEVEL_RISKY
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_NO_FORKS | TRAINSTATION_NO_SELECTION | TRAINSTATION_BLOCKING


/datum/train_station/infected_laboratory
	name = "City of Gaidzin"
	map_path = "_maps/modular_events/trainstation/infected_lab.dmm"
	desc = "An enormous city with a population of more than one and a half million people, until recently. \
			The scientific center of the region: dozens of research institutes belonging to the largest corporations. \
			Now the radio beacon broadcasts a looped evacuation message that began three days ago. \
			The voice on the air sounds tired and cracked, as if the recording has been re-recorded many times already."
	creator = "Fenysha & v1s1ti"

	station_type = TRAINSTATION_TYPE_CITY
	threat_level = THREAT_LEVEL_DANGEROUS
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_NO_SELECTION | TRAINSTATION_BLOCKING | TRAINSTATION_LOCAL_CENTER


/datum/train_station/start_point
	name = "Union Plaza"
	map_path = "_maps/modular_events/trainstation/plasa.dmm"
	creator = "Fenysha"
	station_flags = TRAINSTATION_NO_SELECTION | TRAINSTATION_BLOCKING | TRAINSTATION_FINAL_STATION
	desc = "The largest research complex near a densely populated megalopolis. \
			This is where the head institute for the study of Khara disease was located. \
			Officially - this is the final station of the route. \
			Unofficially - the place from which no one ever returned."
	station_type = TRAINSTATION_TYPE_MILITARY
	threat_level = THREAT_LEVEL_DEADLY
	region = TRAINSTATION_REGION_THUNDRA
	required_stations = 8

/datum/train_station/heart_of_infections
	name = "Heart of Infection"
	map_path = "_maps/modular_events/trainstation/bossfight_map.dmm"
	creator = "V1SITY"

	station_flags = TRAINSTATION_ABSCTRACT | TRAINSTATION_BLOCKING
	station_type = TRAINSTATION_TYPE_MILITARY
	threat_level = THREAT_LEVEL_DEADLY
	region = TRAINSTATION_REGION_THUNDRA

/datum/train_station/military_house
	name = "Gaidzin Military Base"
	creator = "Fenysha & TYWONKA"
	map_path = "_maps/modular_events/trainstation/military_side.dmm"
	desc = "A military base directly adjoining the city of Gaidzin. \
			For the last day the radio beacon has been broadcasting the same text: \"Evacuation has begun. Civilians are forbidden to approach.\" \
			The voice is mechanical, without intonation. It seems no one has pressed the record button in a long time."
	station_type = TRAINSTATION_TYPE_MILITARY
	threat_level = THREAT_LEVEL_DANGEROUS
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_BLOCKING


/datum/train_station/missle_military_side
	name = "Roseville Military Base"
	creator = "v1s1ti & Fenysha"
	map_path = "_maps/modular_events/trainstation/missle_military_side.dmm"
	desc = "One of the largest military bases in the region, located not far from the city of Roseville. \
			Several strategic missile divisions are stationed here. \
			The radio beacon broadcasts an alarming evacuation message, but the tone of the voice sounds more like a warning than a plea for help."
	station_type = TRAINSTATION_TYPE_MILITARY
	threat_level = THREAT_LEVEL_DEADLY
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_BLOCKING | TRAINSTATION_LOCAL_CENTER


/datum/train_station/warehouses
	name = "Abandoned Warehouses"
	creator = "Fenysha & TYWONKA"
	map_path = "_maps/modular_events/trainstation/warehouse.dmm"
	desc = "A row of enormous abandoned warehouse complexes with a small cargo station off to the side. \
			The radio beacon has been silent for several years now. Only the wind howls through the broken gates and somewhere in the distance rusty containers creak."
	threat_level = THREAT_LEVEL_RISKY
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_BLOCKING


/datum/train_station/near_station/lost_dam
	name = "Station Area - Abandoned Dam"
	map_path = "_maps/modular_events/trainstation/nearstations/static_lost_dam.dmm"


/datum/train_station/lost_dam
	name = "Penrose Hydroelectric Station"
	creator = "Mold & Fenysha"
	desc = "A gigantic hydroelectric station in the vicinity of the city of Penrose. \
			Despite the complete absence of personnel, the radio beacon still works and broadcasts a short message: \"Station operating in normal mode.\" \
			The turbines keep humming even now."
	threat_level = THREAT_LEVEL_HAZARDOUS
	region = TRAINSTATION_REGION_THUNDRA
	map_path = "_maps/modular_events/trainstation/lost_dam.dmm"
	possible_nearstations = list(/datum/train_station/near_station/lost_dam)


/datum/train_station/mines
	name = "Abandoned Mines"
	creator = "Fenysha"
	map_path = "_maps/modular_events/trainstation/abandoned_mines.dmm"
	desc = "An enormous abandoned mining complex with dozens of kilometers of tunnels and caves. \
			The station's radio beacon has not given any signals for a very long time. Only the echo of dripping water and the occasional cave-in somewhere in the depths."
	threat_level = THREAT_LEVEL_RISKY
	region = TRAINSTATION_REGION_THUNDRA
	possible_nearstations = list(/datum/train_station/near_station/static_mountaints)
	station_flags = TRAINSTATION_BLOCKING


/datum/train_station/collapsed_lab
	name = "Unidentified Structure"
	creator = "Mold & Fenysha"
	map_path = "_maps/modular_events/trainstation/collapsed_lab.dmm"
	desc = "Satellites cannot precisely classify the object. \
			Most of the building has collapsed, but the radio beacon still works and broadcasts a short, repeating SOS signal. \
			The signal has been going for several weeks without interruption."
	threat_level = THREAT_LEVEL_DEADLY
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_BLOCKING
	required_stations = 5


/datum/train_station/radiosphere
	name = "Massive Structure"
	creator = "Fenysha & Mold"
	map_path = "_maps/modular_events/trainstation/radiosphere.dmm"
	desc = "An enormous object of unknown purpose that satellites cannot identify. \
			The strongest radio interference is observed around it - all frequencies are jammed with white noise and fragments of alien voices. \
			Sometimes you can make out words in the interference... but it's better not to try."
	threat_level = THREAT_LEVEL_DEADLY
	region = TRAINSTATION_REGION_THUNDRA
	station_flags = TRAINSTATION_BLOCKING
	required_stations = 5

	ambience_sounds = list('fenysha_events/sounds/radiosphere_loop1.ogg' = 40 SECONDS)
