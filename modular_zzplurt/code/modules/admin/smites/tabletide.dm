/datum/smite/tabletide
	name = "Table Tideslam"

/datum/smite/tabletide/effect(client/user, mob/living/target)
	. = ..()
	priority_announce(html_decode("[target] has brought the wrath of the gods upon themselves and is now being tableslammed across the station. Please stand by."), "Table Tideslam")
	var/list/areas = list()
	for(var/area/A in GLOB.areas)
		if(A.z == SSmapping.station_start)
			areas += A
	SEND_SOUND(target, sound('modular_zzplurt/sound/misc/slamofthenorthstar.ogg', volume=60))
	for(var/area/A in areas)
		for(var/obj/structure/table/T in A)
			T.tablepush(target, target)
			sleep(1)
