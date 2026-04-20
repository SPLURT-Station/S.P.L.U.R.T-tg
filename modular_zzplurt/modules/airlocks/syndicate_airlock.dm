/obj/machinery/door/airlock/syndicate
	name = "suspicious airlock"
	desc = "It opens and closes. Menacingly!"
	icon = 'modular_zzplurt/icons/obj/machines/syndicate_airlock.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_syndicate
	normal_integrity = 450

/obj/machinery/door/airlock/syndicate/glass
	desc = "It opens and closes. Menacingly!"
	opacity = FALSE
	glass = TRUE
	normal_integrity = 400

/obj/structure/door_assembly/door_assembly_syndicate
	name = "syndicate airlock assembly"
	icon = 'modular_zzplurt/icons/obj/machines/syndicate_airlock.dmi'
	base_name = "syndicate airlock"
	glass_type = /obj/machinery/door/airlock/syndicate/glass
	airlock_type = /obj/machinery/door/airlock/syndicate
