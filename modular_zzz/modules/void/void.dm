GLOBAL_LIST_EMPTY(void) // That's fucking Void.
GLOBAL_LIST_EMPTY(void_door_or_monster_spawn) // All floors, to random spawn monster or escape door.
GLOBAL_VAR_INIT(is_void_already_spawned, FALSE)

/mob/living/carbon/proc/send_to_void()
	if(!check_rights(R_ADMIN))
		return

	if(!iscarbon(src))
		to_chat(usr, "This can only be used on instances of type /mob/living/carbon.", confidential = TRUE)
		return

	if(isAI(src))
		to_chat(usr, "This cannot be used on instances of type /mob/living/silicon/ai.", confidential = TRUE)
		return

	if(tgui_alert(usr, "Send [key_name(src)] to Void?", "Message", list("Yes", "No")) != "Yes")
		return

	if(GLOB.is_void_already_spawned == FALSE)
		new /obj/structure/void_safe_door(pick(GLOB.void_door_or_monster_spawn))
		new /mob/living/basic/void_monster(pick(GLOB.void_door_or_monster_spawn))
		GLOB.is_void_already_spawned = TRUE

	forceMove(pick(GLOB.void))
	to_chat(src, span_narsiesmall("WHAT'S WRONG WITH YOU, MATE?"), confidential = TRUE)
	log_admin("[key_name(src)] has sent [key_name(src)] to Void!")
	message_admins("[key_name_admin(usr)] has sent [key_name_admin(src)] to Void!")

/// Landmarks ///
// Teleport to Void
/obj/effect/landmark/voidspawn
	name = "voidteleport"
	icon_state = "x"

/obj/effect/landmark/voidspawn/Initialize(mapload)
	..()
	GLOB.void += loc
	return INITIALIZE_HINT_QDEL

// Void Floor
/turf/open/indestructible/void
	icon = 'modular_zzz/icons/void/goon-void.dmi'
	icon_state = "void"
	name = "VOID"
	desc = "VOID"

/turf/open/indestructible/void/Initialize(mapload)
	. = ..()
	GLOB.void_door_or_monster_spawn += src
	new /obj/effect/step_trigger/void(src)

// Void Wall
/turf/closed/indestructible/void
	icon = 'modular_zzz/icons/void/goon-void.dmi'
	icon_state = "void-wall"
	name = "VOID"
	desc = "VOID?"

// Effects and trigger
/obj/effect/particle_effect/sparks/void_fissure
	name = "void"
	icon = 'modular_zzz/icons/void/goon-void.dmi'
	icon_state = "fissure"
	light_color = LIGHT_COLOR_LAVENDER
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/particle_effect/sparks/void_fissure/LateInitialize()
	flick(icon_state, src)
	playsound(src, 'modular_zzz/sounds/void/sound.ogg', 30, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, use_reverb = TRUE)
	QDEL_IN(src, 30)

/obj/effect/step_trigger/void
	icon = 'modular_zzz/icons/void/goon-void.dmi'
	icon_state = "step_trigger"
	mobs_only = TRUE

/obj/effect/step_trigger/void/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_EXITED = PROC_REF(on_exited),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/step_trigger/void/proc/on_exited(datum/source, H as mob|obj)
	if(ismob(H))
		var/mob/AM = H
		if(prob(40))
			activate_void(AM)

/obj/effect/step_trigger/void/proc/activate_void(mob/living/carbon/triggerer)
	var/obj/effect/particle_effect/sparks/void_fissure/void_hueta = new /obj/effect/particle_effect/sparks/void_fissure(src.loc)
	animate(void_hueta, pixel_z = 0, pixel_x = 0, time = 8, easing = LINEAR_EASING)
	if(!istype(triggerer, /mob/living/basic/void_monster) && prob(6))
		var/sound/sound = sound('modular_zzz/sounds/void/trip_blast.wav')
		sound.environment = 23
		sound.volume = 100
		SEND_SOUND(triggerer.client, sound)
		triggerer.emote("scream")
		triggerer.overlay_fullscreen("screamers", /atom/movable/screen/fullscreen/screamers, rand(1, 23))
		triggerer.clear_fullscreen("screamers", rand(15, 60))

// Area
/area/centcom/void
	requires_power = FALSE
	default_gravity = STANDARD_GRAVITY
	name = "void"
	ambient_buzz = 'modular_zzz/sounds/void/void.ogg'
	ambient_buzz_vol = 30

// Void Light
/obj/effect/light_emitter/void
	light_color = LIGHT_COLOR_LAVENDER
	set_cap = 1
	set_luminosity = 5

// Safe Door for Escape
/obj/structure/void_safe_door
	name = "ESCAPE TO REALITY"
	desc = "7733995462"
	icon = 'modular_zzz/icons/void/goon-void.dmi'
	icon_state = "door"
	light_color = LIGHT_COLOR_FIRE

/obj/structure/void_safe_door/Initialize(mapload)
	. = ..()
	set_light(4, 1)

/obj/structure/void_safe_door/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	return attack_hand(user)

/obj/structure/void_safe_door/interact(mob/user)
	. = ..()
	if(ismob(user))
		if(user.client?.ckey)
			to_chat(user, span_narsiesmall("Lucky one. For first time. WAKE UP NOW."))
			user.forceMove(pick(GLOB.station_turfs))
			if(istype(user, /mob/living/carbon))
				after_interact(user)

/obj/structure/void_safe_door/proc/after_interact(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/M = user
		M.AdjustParalyzed(60)
		M.adjustBruteLoss(30)
		var/sound/sound = sound('modular_zzz/sounds/void/trip_blast.wav')
		sound.environment = 23
		sound.volume = 200
		SEND_SOUND(M.client, sound)
		INVOKE_ASYNC(M, TYPE_PROC_REF(/mob, emote), "scream")
		M.overlay_fullscreen("flash_void", /atom/movable/screen/fullscreen/flash/black)
		sleep(5 SECONDS)
		M.clear_fullscreen("flash_void", rand(15, 60))

// Warning // Screamers and Monster //

// Screamers
/atom/movable/screen/fullscreen/screamers
	icon = 'modular_zzz/icons/ruzone_went_up.dmi'
	plane = SPLASHSCREEN_PLANE
	screen_loc = "CENTER-7,SOUTH"
	icon_state = ""

// Monster
/mob/living/basic/void_monster
	name = "\improper The fuck?"
	desc = "Their eyes follow you."
	icon = 'modular_zzz/icons/void/babaika.dmi'
	icon_state = "babaika"
	health = 200000
	maxHealth = 200000
	ai_controller = /datum/ai_controller/basic_controller/void_monster
	var/user_name

	hud_possible = list(ANTAG_HUD)

	lighting_cutoff_red = 15
	lighting_cutoff_green = 10
	lighting_cutoff_blue = 25

	sight = SEE_SELF|SEE_MOBS|SEE_OBJS|SEE_TURFS

	gender = NEUTER
	combat_mode = TRUE
	mob_biotypes = MOB_HUMANOID
	gold_core_spawnable = NO_SPAWN

	response_help_continuous = "touches"
	response_help_simple = "touch"
	response_disarm_continuous = "pushes"
	response_disarm_simple = "push"

	speed = 0.5
	maxHealth = 50000
	health = 50000
	obj_damage = 100
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/effects/hallucinations/look_up2.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	melee_attack_cooldown = 2 SECONDS

	faction = list(FACTION_STATUE)
	speak_emote = list("TURN AROUND!")
	death_message = "Uuugh... It's unreal..."
	unsuitable_atmos_damage = 0
	unsuitable_cold_damage = 0
	unsuitable_heat_damage = 0

/mob/living/basic/void_monster/examine(mob/user)
	. = ..()
	if(user.client?.ckey)
		user_name = user.client.ckey
	else
		user_name = user.name
	desc = "It's me? [user_name]???"
	death_message = "I will find you in the REALITY, [user_name]!"

/mob/living/basic/void_monster/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/squeak, list('sound/effects/hallucinations/radio_static.ogg' = 1), 100, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

/datum/ai_controller/basic_controller/void_monster
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_AGGRO_RANGE = 14,
	)

	ai_movement = /datum/ai_movement/jps
	idle_behavior = /datum/idle_behavior/walk_near_target/void
	planning_subtrees = list(
		/datum/ai_planning_subtree/find_and_hunt_target/void_monster,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

/datum/idle_behavior/walk_near_target/void
	walk_chance = 25
	minimum_distance = 5

//
/datum/ai_planning_subtree/find_and_hunt_target/void_monster
	target_key = BB_LOW_PRIORITY_HUNTING_TARGET
	finding_behavior = /datum/ai_behavior/find_hunt_target/void_monster
	hunting_behavior = /datum/ai_behavior/hunt_target/unarmed_attack_target/void_monster
	hunt_targets = list(/mob/living/carbon)
	hunt_range = 30

/datum/ai_behavior/hunt_target/unarmed_attack_target/void_monster
	hunt_cooldown = 1 SECONDS
	always_reset_target = TRUE

/datum/ai_behavior/find_hunt_target/void_monster

/datum/ai_behavior/find_hunt_target/void_monster/valid_dinner(mob/living/source, mob/living/carbon/dinner, radius)
	if(dinner.stat == DEAD)
		return FALSE

	return can_see(source, dinner, radius)

// Cameras
/obj/machinery/computer/camera_advanced/void_cam
	name = "Strange Camera Control Console"
	networks = list("void")
	circuit = /obj/item/circuitboard/computer/void_cam

/obj/item/circuitboard/computer/void_cam
	name = "Strange Camera Control Console"
	build_path = /obj/machinery/computer/camera_advanced/void_cam

/obj/machinery/camera/xray/void
	name = "strange camera"
	desc = "Why is it here?"
	network = list("void")

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/camera/xray/void, 0)
