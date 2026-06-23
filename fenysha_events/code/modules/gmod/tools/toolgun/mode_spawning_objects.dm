/datum/toolgun_mode/spawning/objects
	name = "Обьекты"
	desc = "Используйте браузер типов и обьектов, чтобы быстро создавать почти любые обьекты."
	mode_key = "spawn"
	type_blacklist = list(
		/obj/effect,
		/obj/loop_spawner,
		/obj/narsie,
		/obj/singularity,
		/obj/tear_in_reality,
		/obj/cascade_portal,
		/obj/energy_ball,
		/obj/docking_port,
		/obj/pathfind_guy,
		/obj/item/toolgun, // Не хочу, чтобы ими спамили
		/obj/item/physgun/advanced/admin, // БАН ЗА ПРОП СПАМ
		/obj/item/debug/omnitool/item_spawner,
		/obj/item/gun/magic/wand/death, // Думаю никому не хочется, чтобы его убили просто так
		/obj/item/storage/box/debugtools,
		/obj/item/mod/control/pre_equipped/debug, // И это тоже,
	)

/datum/toolgun_mode/spawning/objects/get_root_type()
	return /obj

/datum/toolgun_mode/spawning/objects/get_default_type()
	return /obj

/datum/toolgun_mode/spawning/objects/get_root_path_text()
	return "/obj"
