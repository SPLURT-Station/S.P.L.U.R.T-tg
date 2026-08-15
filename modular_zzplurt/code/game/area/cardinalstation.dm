/area/station/commons/vacant_room/food
	name = "\improper Vacant Food Stall Commissary"

/area/station/commons/vacant_room/commissary/two
	name = "\improper Vacant Commissary #2"

/area/station/holodeck/prison
	name = "\improper Workshop Holodeck"

/area/station/medical/booth
	name = "\improper Medical Booth"

/area/station/science/nanite
	name = "\improper Nanite Lab"
	icon = 'modular_zzplurt/icons/area/areas_station.dmi'
	icon_state = "nanite"

/area/station/security/checkpoint/engineering/engicargo
	name = "Security Post - Engicargo"
	icon_state = "checkpoint_engi"

/area/station/service/coffeeshop
	name = "\improper Coffee Shop"
	icon_state = "cafeteria"

/area/station/command/bridge/hallway
	name = "\improper Bridge Hallway"

/area/shuttle/abandoned/hallway
	name = "Abandoned Ship Hallway"

/area/shuttle/abandoned/restroom
	name = "Abandoned Ship Restroom"

/area/shuttle/abandoned/external
	name = "Abandoned Ship External Hull"
	icon = 'icons/area/areas_misc.dmi'
	icon_state = "space_near"
	requires_power = TRUE
	always_unpowered = TRUE
	static_lighting = TRUE
	base_lighting_alpha = 0
	base_lighting_color = null
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	area_flags = NO_GRAVITY
	outdoors = TRUE
	ambience_index = AMBIENCE_SPACE
	flags_1 = CAN_BE_DIRTY_1
	sound_environment = SOUND_AREA_SPACE
	ambient_buzz = null //Space is deafeningly quiet
