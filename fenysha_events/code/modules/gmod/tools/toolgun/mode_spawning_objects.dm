/datum/toolgun_mode/spawning/objects
	name = "Objects"
	desc = "Use the type and object browser to quickly create almost any object."
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
		/obj/item/toolgun, // Don't want these to be spammed
		/obj/item/physgun/advanced/admin, // BAN FOR PROP SPAM
		/obj/item/debug/omnitool/item_spawner,
		/obj/item/gun/magic/wand/death, // I think nobody wants to be killed just like that
		/obj/item/storage/box/debugtools,
		/obj/item/mod/control/pre_equipped/debug, // And this too,
	)

/datum/toolgun_mode/spawning/objects/get_root_type()
	return /obj

/datum/toolgun_mode/spawning/objects/get_default_type()
	return /obj

/datum/toolgun_mode/spawning/objects/get_root_path_text()
	return "/obj"
