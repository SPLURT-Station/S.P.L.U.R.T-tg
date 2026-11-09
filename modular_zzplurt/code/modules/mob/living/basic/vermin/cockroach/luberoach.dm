/// A lubefish-colored cockroach whose death replaces insect guts with a lube splash.
/mob/living/basic/cockroach/luberoach
	name = "luberoach"
	desc = "A blue, striped cockroach with an exceptionally slippery shell."
	icon = 'modular_zzplurt/icons/mob/living/basic/vermin/cockroach/luberoach.dmi'
	icon_state = "luberoach"
	icon_living = "luberoach"
	icon_dead = "luberoach_dead"
	health = 1
	maxHealth = 1
	minion_path = null
	/// Manhattan radius: 2 gives a 5x5 bounding box containing 13 tiles.
	var/lube_splash_radius = 2
	/// Death and gibbing must never create the splash twice.
	var/lube_splashed = FALSE

/mob/living/basic/cockroach/luberoach/Initialize(mapload)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return
	RemoveElement(/datum/element/death_drops, /obj/effect/decal/cleanable/insectguts)
	RegisterSignal(src, COMSIG_LIVING_DEATH, PROC_REF(splash_lube))

/// The death signal also covers squashing/gibbing, like the original death-drops element.
/mob/living/basic/cockroach/luberoach/proc/splash_lube(mob/living/source, gibbed)
	SIGNAL_HANDLER
	if(lube_splashed)
		return
	lube_splashed = TRUE
	var/turf/center = get_turf(source)
	if(isnull(center))
		return
	// view() clips the splash to visible tiles; the distance check cuts off square corners.
	for(var/turf/open/floor_tile in view(lube_splash_radius, center))
		if(isspaceturf(floor_tile))
			continue
		if(abs(floor_tile.x - center.x) + abs(floor_tile.y - center.y) > lube_splash_radius)
			continue
		// Same wet-floor type and timing as exposing a turf to 6u of Super Duper Lube.
		floor_tile.MakeSlippery(TURF_WET_SUPERLUBE, 15 SECONDS, 12 SECONDS)

/mob/living/basic/cockroach/luberoach/super
	name = "superluberoach"
	desc = "A blue, striped cockroach with a red clown nose, a bad attitude and far too much lubricant."
	icon_state = "superluberoach"
	icon_living = "superluberoach"
	icon_dead = "superluberoach_dead"
	health = 2
	maxHealth = 2
	/// Radius 3 gives a 7x7 bounding box containing 25 tiles.
	lube_splash_radius = 3
	melee_damage_lower = 2
	melee_damage_upper = 4
	obj_damage = 5
	melee_attack_cooldown = 0.8 SECONDS
	gold_core_spawnable = HOSTILE_SPAWN
	ai_controller = /datum/ai_controller/basic_controller/cockroach/aggro

/mob/living/basic/cockroach/luberoach/super/Initialize(mapload)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return
	enable_clown_honking()

/// The superluberoach's health, factions and death splash, plus a pie cannon.
/mob/living/basic/cockroach/luberoach/super/ultra
	name = "ultra luberoach"
	desc = "A blue, striped cockroach with a red clown nose, far too much lubricant and a miniature pie cannon."
	icon_state = "ultraluberoach"
	icon_living = "ultraluberoach"
	icon_dead = "ultraluberoach_dead"
	ai_controller = /datum/ai_controller/basic_controller/cockroach/glockroach

/mob/living/basic/cockroach/luberoach/super/ultra/Initialize(mapload)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return
	AddComponent( \
		/datum/component/ranged_attacks, \
		projectile_type = /obj/projectile/clownroach_pie, \
		projectile_sound = 'sound/items/weapons/sonic_jackhammer.ogg', \
		cooldown_time = 2 SECONDS, \
	)
