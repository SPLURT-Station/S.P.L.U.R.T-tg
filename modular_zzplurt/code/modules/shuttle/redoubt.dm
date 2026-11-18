/obj/machinery/computer/shuttle/sbq_redoubt
	name = "SBQ Redoubt Helm Console"
	desc = "Used to control the SBQ Redoubt, it's caked in dust."
	circuit = /obj/item/circuitboard/computer/redoubt
	icon_state = MAP_SWITCH("computer", "/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate")
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	req_access = list(ACCESS_SYNDICATE_LEADER)
	shuttleId = "redoubt"
	possible_destinations = "redoubt_home;redoubt_away;redoubt_custom;whiteship_waystation;whiteship_lavaland"
	may_be_remote_controlled = FALSE

/obj/item/circuitboard/computer/redoubt
	name = "Redoubt Helm Console"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/computer/shuttle/sbq_redoubt

/obj/machinery/computer/camera_advanced/shuttle_docker/sbq_redoubt
	name = "SBQ Redoubt Navigation Computer"
	desc = "Used to designate a precise transit location for the SBQ Redoubt, you can see that it hasn't been used in years."
	circuit = /obj/item/circuitboard/computer/redoubt_shuttle_docker
	icon_state = MAP_SWITCH("computer", "/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate")
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	req_access = list(ACCESS_SYNDICATE_LEADER)
	shuttleId = "redoubt"
	lock_override = NONE
	shuttlePortId = "redoubt_custom"
	jump_to_ports = list("redoubt_home" = 1, "whiteship_waystation" = 1)
	view_range = 15
	designate_time = 100

/obj/item/circuitboard/computer/redoubt_shuttle_docker
	name = "Redoubt Navigation Computer"
	build_path = /obj/machinery/computer/camera_advanced/shuttle_docker/sbq_redoubt
	greyscale_colors = CIRCUIT_COLOR_SECURITY

/obj/docking_port/stationary/redoubt
	name = "SBQ Redoubt Landing Spot"
	shuttle_id = "redoubt_away"
	roundstart_template = /datum/map_template/shuttle/ruin/redoubt
	width = 38
	height = 18
	dwidth = 10
	dir = NORTH
