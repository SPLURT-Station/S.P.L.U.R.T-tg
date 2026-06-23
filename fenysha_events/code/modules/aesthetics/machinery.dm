// Airlocks
/obj/machinery/door/airlock/shuttle/ferry
	icon = 'fenysha_events/icons/machinery/airlocks/shuttle2/erokez.dmi'
	overlays_file = 'fenysha_events/icons/machinery/airlocks/shuttle2/overlays.dmi'

/obj/machinery/door/airlock/external/wagon
	icon = 'fenysha_events/icons/machinery/airlocks/shuttle2/wagon.dmi'
	overlays_file = 'fenysha_events/icons/machinery/airlocks/shuttle2/overlays.dmi'

/obj/machinery/door/airlock/hos
	icon = 'fenysha_events/icons/machinery/airlocks/hos.dmi'

// Switches

/obj/machinery/light_switch/default_on

/obj/machinery/light_switch/default_on/post_machine_initialize()
	. = ..()
	set_lights(TRUE)

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/light_switch/default_on, 26)
