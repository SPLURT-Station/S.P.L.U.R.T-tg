/obj/machinery/door/airlock/centcom/standard
	name = "centcom airlock"
	icon = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/centcom/centcom_new.dmi'
	overlays_file = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/station/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_centcom_new
	can_be_glass = TRUE

/obj/machinery/door/airlock/centcom/standard/glass
	name = "centcom glass airlock"
	opacity = FALSE
	glass = TRUE
	normal_integrity = 800

/obj/machinery/door/airlock/centcom/commander
	name = "centcom commander airlock"
	icon = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/centcom/commander.dmi'
	overlays_file = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/station/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_centcom_com

/obj/machinery/door/airlock/centcom/security
	name = "centcom security airlock"
	icon = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/centcom/security.dmi'
	overlays_file = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/station/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_centcom_sec
	can_be_glass = TRUE

/obj/machinery/door/airlock/centcom/security/glass
	name = "centcom security glass airlock"
	opacity = FALSE
	glass = TRUE
	normal_integrity = 800

/obj/machinery/door/airlock/centcom/medical
	name = "centcom medical airlock"
	icon = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/centcom/medical.dmi'
	overlays_file = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/station/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_centcom_med
	can_be_glass = TRUE

/obj/machinery/door/airlock/centcom/medical/glass
	name = "centcom medical glass airlock"
	opacity = FALSE
	glass = TRUE
	normal_integrity = 800

/obj/machinery/door/airlock/centcom/cargo
	name = "centcom logistics airlock"
	icon = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/centcom/cargo.dmi'
	overlays_file = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/station/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_centcom_crg
	can_be_glass = TRUE

/obj/machinery/door/airlock/centcom/cargo/glass
	name = "centcom logistics glass airlock"
	opacity = FALSE
	glass = TRUE
	normal_integrity = 800

/obj/machinery/door/airlock/centcom/engineering
	name = "centcom engineering airlock"
	icon = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/centcom/engineering.dmi'
	overlays_file = 'modular_skyrat/modules/aesthetics/airlock/icons/airlocks/station/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_centcom_eng
	can_be_glass = TRUE

/obj/machinery/door/airlock/centcom/engineering/glass
	name = "centcom engineering glass airlock"
	opacity = FALSE
	glass = TRUE
	normal_integrity = 800

/obj/machinery/door/airlock/highsecurity/centcom
	name = "hardened high tech security airlock"
	normal_integrity = 1500
	security_level = 6
	explosion_block = 2
	damage_deflection = 30

/obj/machinery/door/airlock/vault/centcom
	name = "hardened vault door"
	normal_integrity = 2000
	security_level = 6
	explosion_block = 2
	damage_deflection = 30
