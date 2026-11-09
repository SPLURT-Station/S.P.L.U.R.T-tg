/// Match the Warden's shotgun's 0.75 projectile multiplier on every beam.
/obj/projectile/beam/disabler/roach_warden/Initialize(mapload)
	. = ..()
	damage *= 0.75
	stamina *= 0.75

/// Inherit the actual three-pellet, 15-degree Warden shotgun energy charge.
/obj/item/ammo_casing/energy/laser/scatter/disabler/roach
	projectile_type = /obj/projectile/beam/disabler/roach_warden

/// Use the native pellet cloud, but never drop energy lenses as physical casings.
/datum/component/ranged_attacks/roach_disabler/async_fire_ranged_attack(mob/living/basic/firer, atom/target, modifiers)
	if(QDELETED(firer) || QDELETED(target))
		return
	firer.face_atom(target)
	playsound(firer, projectile_sound, 100, TRUE)
	var/obj/item/ammo_casing/energy/charge = new casing_type(firer)
	var/target_zone
	if(ismob(target))
		var/mob/target_mob = target
		target_zone = target_mob.get_random_valid_zone()
	else
		target_zone = ran_zone()
	var/fired = charge.fire_casing(target, firer, null, null, null, target_zone, 0, firer)
	// pellet_cloud defers deletion until its projectiles finish, if necessary.
	qdel(charge)
	if(fired)
		SEND_SIGNAL(parent, COMSIG_BASICMOB_POST_ATTACK_RANGED, target, modifiers)

/mob/living/basic/cockroach/disableroach
	name = "disableroach"
	desc = "A cockroach holding a tiny disabler with a suspiciously wide firing pattern."
	icon = 'modular_zzplurt/icons/mob/living/basic/vermin/cockroach/disableroach.dmi'
	icon_state = "disableroach"
	icon_living = "disableroach"
	icon_dead = "disableroach_dead"
	melee_damage_lower = 2.5
	melee_damage_upper = 10
	obj_damage = 10
	gold_core_spawnable = HOSTILE_SPAWN
	ai_controller = /datum/ai_controller/basic_controller/cockroach/glockroach
	minion_path = null
	var/ranged_cooldown = 2 SECONDS

/mob/living/basic/cockroach/disableroach/Initialize(mapload)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return
	AddComponent( \
		/datum/component/ranged_attacks/roach_disabler, \
		casing_type = /obj/item/ammo_casing/energy/laser/scatter/disabler/roach, \
		projectile_sound = 'modular_skyrat/modules/aesthetics/guns/sound/laser.ogg', \
		burst_shots = 1, \
		cooldown_time = ranged_cooldown, \
	)

/mob/living/basic/cockroach/disableroach/space_police
	name = "space police disableroach"
	desc = "A dark-shelled cockroach with a miniature scatter-firing disabler."
	health = 2
	maxHealth = 2
	icon_state = "disableroach_police"
	icon_living = "disableroach_police"
	icon_dead = "disableroach_police_dead"
