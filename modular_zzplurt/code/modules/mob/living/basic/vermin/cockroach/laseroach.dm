/// Laser-armed roaches. Kept separate from /glockroach so its bullet-casing
/// ranged component is never installed on these mobs.
/mob/living/basic/cockroach/laseroach
	name = "laseroach"
	desc = "A cockroach armed with a miniature Type 5 laser gun."
	icon = 'modular_zzplurt/icons/mob/living/basic/vermin/cockroach/laseroach.dmi'
	icon_state = "laseroach"
	icon_living = "laseroach"
	icon_dead = "laseroach_dead"
	melee_damage_lower = 2.5
	melee_damage_upper = 10
	obj_damage = 10
	gold_core_spawnable = HOSTILE_SPAWN
	ai_controller = /datum/ai_controller/basic_controller/cockroach/glockroach
	minion_path = /mob/living/basic/cockroach/laseroach/space_police
	/// Direct projectiles avoid creating any ammunition casings.
	var/laser_projectile_type = /obj/projectile/beam/laser
	/// Same firing sound as the standard laser gun's energy ammunition.
	var/laser_fire_sound = 'sound/items/weapons/laser.ogg'
	/// Same firing cooldown as a glockroach.
	var/ranged_cooldown = 1 SECONDS
	/// Subtypes can disable gun attacks while keeping the laseroach type hierarchy.
	var/laser_attacks_enabled = TRUE
	/// Direct-projectile burst settings; the standard laseroaches remain single-shot.
	var/laser_burst_shots = 1
	var/laser_burst_interval = 0.2 SECONDS

/mob/living/basic/cockroach/laseroach/Initialize(mapload)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL || !laser_attacks_enabled)
		return
	AddComponent( \
		/datum/component/ranged_attacks, \
		projectile_type = laser_projectile_type, \
		projectile_sound = laser_fire_sound, \
		burst_shots = laser_burst_shots, \
		burst_intervals = laser_burst_interval, \
		cooldown_time = ranged_cooldown, \
	)
	if(ranged_cooldown <= 1 SECONDS)
		AddComponent(/datum/component/ranged_mob_full_auto)

/// Keep ranged protection/attack commands when recruited by a regal rat.
/mob/living/basic/cockroach/laseroach/set_pet_commands()
	var/static/list/laseroach_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/protect_owner/glockroach,
		/datum/pet_command/follow,
		/datum/pet_command/attack/glockroach,
	)
	minion_commands = laseroach_commands

/// Alternate shell palette with the usual two HP; factions are unchanged.
/mob/living/basic/cockroach/laseroach/space_police
	name = "space police laseroach"
	health = 2
	maxHealth = 2
	desc = "A dark-shelled cockroach armed with a miniature Type 5 laser gun."
	icon_state = "laseroach_police"
	icon_living = "laseroach_police"
	icon_dead = "laseroach_police_dead"
	minion_path = null

/// Uses the actual Type 4 hellfire laser projectile.
/mob/living/basic/cockroach/laseroach/hellfire
	name = "hellfire laseroach"
	desc = "A cockroach armed with a miniature Type 4 hellfire laser gun."
	icon_state = "hellfire_laseroach"
	icon_living = "hellfire_laseroach"
	icon_dead = "hellfire_laseroach_dead"
	laser_projectile_type = /obj/projectile/beam/laser/hellfire
	minion_path = /mob/living/basic/cockroach/laseroach/hellfire/space_police

/// Alternate shell palette with two HP; retains the hellfire variant's attacks.
/mob/living/basic/cockroach/laseroach/hellfire/space_police
	name = "space police hellfire laseroach"
	health = 2
	maxHealth = 2
	desc = "A dark-shelled cockroach armed with a miniature Type 4 hellfire laser gun."
	icon_state = "hellfire_laseroach_police"
	icon_living = "hellfire_laseroach_police"
	icon_dead = "hellfire_laseroach_police_dead"
	minion_path = null

/// Roach-fired projectiles pass harmlessly through every cockroach subtype.
/mob/living/basic/cockroach/projectile_hit(obj/projectile/hitting_projectile, def_zone, piercing_hit = FALSE, blocked = null)
	if(istype(hitting_projectile.firer, /mob/living/basic/cockroach))
		return BULLET_ACT_FORCE_PIERCE
	return ..()
