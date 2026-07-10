/area/centcom/central_command_areas
	name = "Central Command Snowy Plains"
	ambience_index = AMBIENCE_MINING
	sound_environment = SOUND_AREA_ICEMOON
	airlock_wires = /datum/wires/airlock/centcom

/datum/wires/airlock/centcom
	dictionary_key = /datum/wires/airlock/centcom
	proper_name = "CentCom Airlock"

/area/centcom/central_command_areas/control
	name = "CentCom Central Hallway"
	icon_state = "centcom"
	ambience_index = AMBIENCE_GENERIC
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/centcom/central_command_areas/control/main
	name = "CentCom Central Control Office"
	icon_state = "centcom_control"
	ambience_index = AMBIENCE_GENERIC
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/centcom/central_command_areas/control/closet
	name = "CentCom Auxiliary Announcement Closet"
	icon_state = "centcom_control"
	ambience_index = AMBIENCE_DANGER
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/centcom/central_command_areas/evacuation/lounge
	name = "CentCom Recovery Wing Lounge"
	icon_state = "centcom"
	ambience_index = AMBIENCE_GENERIC
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/centcom/central_command_areas/evacuation/sec
	name = "CentCom Recovery Wing Security Post"
	icon_state = "centcom"
	ambience_index = AMBIENCE_DANGER
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/centcom/central_command_areas/evacuation/med
	name = "CentCom Recovery Wing Medical Post"
	icon_state = "centcom"
	ambience_index = AMBIENCE_MEDICAL
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/centcom/central_command_areas/evacuation/checkpoint
	name = "CentCom Recovery Wing Security Checkpoint"
	icon_state = "centcom"
	ambience_index = AMBIENCE_DANGER
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/centcom/central_command_areas/evacuation/ai_storage
	name = "CentCom Recovery Wing AI Storage"
	icon_state = "centcom"
	ambience_index = AMBIENCE_GENERIC
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/centcom/tdome
	name = "CentCom Thunderdome"
	icon_state = "thunder"
	ambience_index = AMBIENCE_GENERIC
	airlock_wires = /datum/wires/airlock/centcom
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/centcom/tdome/arena
	name = "CentCom Thunderdome Arena"
	icon_state = "thunder"
	area_flags = parent_type::area_flags | UNLIMITED_FISHING //for possible testing purposes

/area/centcom/tdome/administration
	name = "CentCom Thunderdome Administrative Observation"
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR

/area/centcom/tdome/observation
	name = "CentCom Thunderdome Wing"

/area/centcom/tdome/observation/observation
	name = "CentCom Thunderdome Observation"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/centcom/tdome/observation/bar
	name = "CentCom Thunderdome Bar"

/area/centcom/tdome/observation/kitchen
	name = "CentCom Thunderdome kitchen"

/area/centcom/central_command_areas/morgue
	name = "CentCom Morgue"
	icon_state = "centcom"
	ambience_index = AMBIENCE_SPOOKY
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/centcom/central_command_areas/secpost
	name = "CentCom Security Post"
	icon_state = "centcom"
	ambience_index = AMBIENCE_GENERIC
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/centcom/central_command_areas/medpost
	name = "CentCom Medical Post"
	icon_state = "centcom"
	ambience_index = AMBIENCE_MEDICAL
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/centcom/central_command_areas/supplypod
	name = "CentCom Supplypod Loading Bay"
	icon_state = "supplypod"
	ambience_index = AMBIENCE_ENGI
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/centcom/central_command_areas/ferry
	name = "CentCom Executive Operations Wing"
	icon_state = "centcom_ferry"
	ambience_index = AMBIENCE_GENERIC
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/centcom/central_command_areas/ferry/dock
	name = "CentCom Executive Operations Docking Bay"
	icon_state = "centcom_ferry"

/area/centcom/central_command_areas/ferry/control
	name = "CentCom Executive Operations Control"
	icon_state = "centcom_ferry"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/centcom/central_command_areas/admin
	name = "CentCom Administrative Sector"
	icon_state = "centcom_admin"
	ambience_index = AMBIENCE_DANGER
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	ambientsounds = list(
		'sound/ambience/security/ambidet1.ogg',
		'sound/ambience/security/ambidet2.ogg',
		)

/area/centcom/central_command_areas/admin/front
	name = "CentCom Administrative Front Office"
	icon_state = "centcom_admin"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/centcom/central_command_areas/admin/commander
	name = "CentCom Administrative Commander's Office"
	icon_state = "centcom_admin"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/centcom/central_command_areas/admin/briefing
	name = "CentCom Administrative Conference Room"
	icon_state = "centcom_admin"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/centcom/central_command_areas/briefing
	name = "CentCom Emergency Reponse Team Briefing Room"
	icon_state = "centcom_briefing"
	ambience_index = AMBIENCE_DANGER
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/centcom/central_command_areas/supply
	name = "CentCom Logistics Office"
	icon_state = "centcom_supply"
	ambience_index = AMBIENCE_ENGI
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/centcom/central_command_areas/supply/bay
	name = "CentCom Logistics Bay"
	icon_state = "centcom_supply"

/area/centcom/central_command_areas/supply/control
	name = "CentCom Logistics Control Office"
	icon_state = "centcom_supply"

/area/centcom/central_command_areas/fore
	name = "CentCom Corporate Security & Logistics Wing"
	icon_state = "centcom_fore"
	ambience_index = AMBIENCE_GENERIC
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/centcom/central_command_areas/prison
	name = "CentCom Corporate Security Prison Wing"
	icon_state = "centcom_prison"
	ambience_index = AMBIENCE_DANGER
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/centcom/central_command_areas/prison/security
	name = "CentCom Corporate Security Center"
	icon_state = "centcom_prison"

/area/centcom/central_command_areas/prison/commander
	name = "CentCom Corporate Security Commander's Office"
	icon_state = "centcom_prison"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/centcom/central_command_areas/prison/equipment
	name = "CentCom Corporate Security Equipment Room"
	icon_state = "centcom_prison"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/centcom/central_command_areas/prison/cells
	name = "CentCom Corporate Security Prison Cells"
	icon_state = "centcom_cells"
	ambience_index = AMBIENCE_MINING

/area/centcom/central_command_areas/evacuation/ship
	name = "CentCom Pod Recovery Outpost"
	icon_state = "centcom_evacuation_ship"
	ambience_index = AMBIENCE_GENERIC
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/centcom/central_command_areas/evacuation/ship/med
	name = "CentCom Pod Recovery Infirmary"
	ambience_index = AMBIENCE_MEDICAL

/area/centcom/central_command_areas/evacuation/ship/bar
	name = "CentCom Pod Recovery Lounge"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/centcom/central_command_areas/evacuation/ship/lobby
	name = "CentCom Pod Recovery Lobby"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
