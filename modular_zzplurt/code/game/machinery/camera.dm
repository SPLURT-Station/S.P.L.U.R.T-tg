/obj/machinery/camera/preset/centcom
	name = "CentCom security camera"
	desc = "A heavy-duty security camera, it looks pretty strong."
	network = list("CentCom")
	start_active = TRUE
	max_integrity = 450

/obj/machinery/camera/preset/centcom/Initialize(mapload)
	. = ..()
	upgradeEmpProof()

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/camera/preset/centcom, 0)
