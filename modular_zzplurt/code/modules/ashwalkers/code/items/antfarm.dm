// ====================
// ANT FARM OVERRIDES
// ====================

// Override ore list
/obj/structure/antfarm
	density = FALSE
	ore_list = list(
		/obj/item/stack/ore/iron = 20,
		/obj/item/stack/ore/glass/basalt = 20,
		/obj/item/stack/ore/plasma = 10,
		/obj/item/stack/ore/silver = 8,
		/obj/item/xenoarch/strange_rock = 16,
		/obj/item/stack/stone = 5,
		/obj/item/stack/sheet/mineral/coal = 3,
		/obj/item/stack/ore/titanium = 8,
		/obj/item/stack/ore/uranium = 3,
		/obj/item/stack/ore/gold = 3,
		/obj/item/stack/ore/bluespace_crystal = 1,
		/obj/item/stack/ore/diamond = 3,
		/obj/item/stack/ore/bananium = 1,
	)

// Override the nearby‑farm check logic inside Initialize()
/obj/structure/antfarm/Initialize(mapload)
	. = ..(INITIALIZE_HINT_LATELOAD)
	if(!mapload)
		var/turf/src_turf = get_turf(src)
		if(!src_turf.GetComponent(/datum/component/simple_farm))
			src_turf.balloon_alert_to_viewers("must be on farmable surface")
			return INITIALIZE_HINT_QDEL

		// Modified range
		for(var/obj/structure/antfarm/found_farm in range(1, get_turf(src)))
			if(found_farm == src)
				continue

			src_turf.balloon_alert_to_viewers("Cannot build on top of another farm")
			return INITIALIZE_HINT_QDEL

	START_PROCESSING(SSobj, src)
	COOLDOWN_START(src, ant_timer, 30 SECONDS)
