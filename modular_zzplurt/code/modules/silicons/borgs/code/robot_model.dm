/obj/item/robot_model/standard/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Assaultron" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "assaultron_standard"),
		"RoboMaid" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "robomaid_sd"),
	)

/obj/item/robot_model/service/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Assaultron" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "assaultron_service"),
		"Meka (Dapper)" = list(SKIN_ICON_STATE = "mekaserve_alt2", SKIN_ICON = CYBORG_ICON_SPLURT_TALL, SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_UNIQUETIP, TRAIT_R_TALL), TALL_HAT_OFFSET),
	)

/obj/item/robot_model/engineering/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Assaultron" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "assaultron_engi"),
		"RoboMaid" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "robomaid_eng"),
	)

/obj/item/robot_model/medical/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Assaultron" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "assaultron_medical"),
		"RoboMaid" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "robomaid_med"),
		"Paramedic Drake" = list(SKIN_ICON = CYBORG_ICON_MED_SPLURT_WIDE, SKIN_ICON_STATE = "draketrauma", SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_WIDE), DRAKE_HAT_OFFSET),
	)

/obj/item/robot_model/security/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Assaultron" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "assaultron_sec"),
		"RoboMaid" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "robomaid_sec"),
		"Feline" = list(SKIN_ICON = CYBORG_ICON_SPLURT_WIDE, SKIN_ICON_STATE = "vixmed-b", SKIN_FEATURES = list(TRAIT_R_WIDE, TRAIT_R_SMALL), BORGI_HAT_OFFSET),
	)

/obj/item/robot_model/peacekeeper/Initialize(mapload) //adds the sec skins to peacekeeper
	. = ..()
	borg_skins |= list(
		"Assaultron" = list(SKIN_ICON = CYBORG_ICON_SPLURT, SKIN_ICON_STATE = "assaultron_sec"),
		"Feline" = list(SKIN_ICON = CYBORG_ICON_SPLURT_WIDE, SKIN_ICON_STATE = "vixmed-b", SKIN_FEATURES = list(TRAIT_R_WIDE, TRAIT_R_SMALL), BORGI_HAT_OFFSET),
	)

// Sleeper overlay sprite, icon file + body state -> belly prefix. Prefix + _g / _r is the icon state.
GLOBAL_LIST_INIT(sleeper_belly_prefixes, list(
	"[CYBORG_ICON_SERVICE_WIDE]|k69" = "ksleeper",
	"[CYBORG_ICON_SERVICE_WIDE]|k50" = "ksleeper",
	"[CYBORG_ICON_SERVICE_WIDE]|drakeserv" = "drakeservsleeper",
	"[CYBORG_ICON_SERVICE_WIDE]|valeserv" = "valeservsleeper",
	"[CYBORG_ICON_MINING_WIDE]|blade" = "bladesleeper",
	"[CYBORG_ICON_MINING_WIDE]|valemine" = "valeminesleeper",
	"[CYBORG_ICON_MINING_WIDE]|drakemine" = "drakeminesleeper",
	"[CYBORG_ICON_MINING_WIDE]|otiec" = "otiecsleeper",
	"[CYBORG_ICON_MINING_WIDE]|cargohound" = "cargohound-sleeper",			// red only
	"[CYBORG_ICON_MINING_WIDE]|cargohounddark" = "cargohounddark-sleeper",
	"[CYBORG_ICON_ENG_WIDE]|pupdozer" = "dozersleeper",
	"[CYBORG_ICON_ENG_WIDE]|valeeng" = "valeengsleeper",
	"[CYBORG_ICON_ENG_WIDE]|engihound" = "engihoundsleeper",
	"[CYBORG_ICON_ENG_WIDE]|engihounddark" = "engihounddarksleeper",
	"[CYBORG_ICON_ENG_WIDE]|otiee" = "otieesleeper",
	"[CYBORG_ICON_ENG_WIDE]|drakeeng" = "drakeengsleeper",					// red only
	"[CYBORG_ICON_JANI_WIDE]|scrubpup" = "jsleeper",
	"[CYBORG_ICON_JANI_WIDE]|otiej" = "otiejsleeper",
	"[CYBORG_ICON_JANI_WIDE]|J9" = "J9-sleeper",
	"[CYBORG_ICON_MED_WIDE]|medihound" = "msleeper",
	"[CYBORG_ICON_MED_WIDE]|medihounddark" = "mdsleeper",
	"[CYBORG_ICON_MED_WIDE]|valemed" = "valemedsleeper",
	"[CYBORG_ICON_MED_WIDE]|drakemed" = "drakemedsleeper",
	"[CYBORG_ICON_PEACEKEEPER_WIDE]|drakepeace" = "drakepeacesleeper",
	"[CYBORG_ICON_PEACEKEEPER_WIDE]|valepeace" = "valepeacesleeper",
	"[CYBORG_ICON_SEC_WIDE]|k9" = "ksleeper",
	"[CYBORG_ICON_SEC_WIDE]|k9dark" = "k9darksleeper",
	"[CYBORG_ICON_SEC_WIDE]|drakesec" = "drakesecsleeper",
	"[CYBORG_ICON_SEC_WIDE]|oties" = "otiessleeper",
	"[CYBORG_ICON_SEC_WIDE]|valesec" = "valesecsleeper",
	"[CYBORG_ICON_CARGO_WIDE]|drakecargo" = "drakecargosleeper",
	"[CYBORG_ICON_CARGO_WIDE]|valecargo" = "valecargosleeper",
	"[CYBORG_ICON_CARGO_WIDE]|cargohound" = "cargohound-sleeper",
	"[CYBORG_ICON_CARGO_WIDE]|cargohounddark" = "cargohounddark-sleeper",
))
	// Commented out until sprites are recolored and moved into the proper state
// Chassis icon global list; sheet of corrected _r states.
//GLOBAL_LIST_INIT(sleeper_red_icons, list(
//	"[CYBORG_ICON_ENG_WIDE]" = 'modular_zzplurt/icons/mob/robot/sleeper_r/sleeper_r_eng.dmi',
//	"[CYBORG_ICON_JANI_WIDE]" = 'modular_zzplurt/icons/mob/robot/sleeper_r/sleeper_r_jani.dmi',
//	"[CYBORG_ICON_MED_WIDE]" = 'modular_zzplurt/icons/mob/robot/sleeper_r/sleeper_r_med.dmi',
//	"[CYBORG_ICON_MINING_WIDE]" = 'modular_zzplurt/icons/mob/robot/sleeper_r/sleeper_r_mine.dmi',
//	"[CYBORG_ICON_PEACEKEEPER_WIDE]" = 'modular_zzplurt/icons/mob/robot/sleeper_r/sleeper_r_pk.dmi',
//	"[CYBORG_ICON_SEC_WIDE]" = 'modular_zzplurt/icons/mob/robot/sleeper_r/sleeper_r_sec.dmi',
//	"[CYBORG_ICON_SERVICE_WIDE]" = 'modular_zzplurt/icons/mob/robot/sleeper_r/sleeper_r_serv.dmi',
//	"[CYBORG_ICON_CARGO_WIDE]" = 'modular_zzplurt/icons/mob/robot/sleeper_r/sleeper_r_cargo.dmi',
//	"[CYBORG_ICON_SPLURT_WIDE]" = 'modular_zzplurt/icons/robot/sleeper_r/sleeper_r_splurt.dmi',
//))

GLOBAL_LIST_INIT(vale_dogborg_bodies, list(
	"valeserv", "valemine", "valeeng", "J9", "valemed", "valepeace", "valesec", "valecargo",
))

// Wide skins that already have a belly prefix and are not hounds/vales
// The trait makes transform_to() call dogborg_equip(). The prefix list is unchanged.
GLOBAL_LIST_INIT(altborg_sleeper_bodies, list(
	"drakeserv",
	"blade", "drakemine", "otiec",
	"pupdozer", "otiee", "drakeeng",
	"otiej",
	"drakemed",
	"drakepeace",
	"drakesec", "oties",
	"drakecargo",
))

/obj/item/robot_model/be_transformed_to(obj/item/robot_model/old_model, forced = FALSE)
	. = ..() // original skin copy, then the knotting cleanup
	if(!.)
		return
	// Misses are null on purpose. A reskin off a hound must not keep msleeper
	sleeper_overlay = GLOB.sleeper_belly_prefixes["[cyborg_icon_override]|[cyborg_base_icon]"]
	if((cyborg_base_icon in GLOB.vale_dogborg_bodies) || (cyborg_base_icon in GLOB.altborg_sleeper_bodies) || (istype(src, /obj/item/robot_model/sci) && cyborg_base_icon == "vale"))
		model_features = model_features.Copy()
		model_features += TRAIT_R_DOGBORG

/obj/item/robot_model/transform_to(new_config_type, forced = FALSE, transform = TRUE)
	RegisterSignal(src, COMSIG_QDELETING, PROC_REF(dump_sleeper_on_delete))
	. = ..()
	if(!QDELETED(src))
		UnregisterSignal(src, COMSIG_QDELETING) // player backed out of the radial

/obj/item/robot_model/proc/dump_sleeper_on_delete(datum/source)
	SIGNAL_HANDLER
	var/mob/living/silicon/robot/cyborg = loc
	if(!istype(cyborg))
		return
	for(var/obj/item/dogborg/sleeper/old_sleeper in src)
		old_sleeper.go_out(null, cyborg)
