// --------------------
// BASE
// --------------------

/mob/living/basic/trooper/nanotrasen
	name = "\improper Nanotrasen Private Security Private"
	desc = "A member of Nanotrasen's private security, an underpaid security force. They seem rather unpleased to meet you."
	maxHealth = 125
	health = 125
	melee_damage_lower = 10
	melee_damage_upper = 15
	faction = list(ROLE_DEATHSQUAD)
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity
	ai_controller = /datum/ai_controller/basic_controller/trooper

/mob/living/basic/trooper/nanotrasen/assess_threat(judgement_criteria, lasercolor, datum/callback/weaponcheck)
	return -10 // Respect our troops

// --------------------
// VARIANTS
// --------------------

/mob/living/basic/trooper/nanotrasen/corporal
	name = "\improper Nanotrasen Private Security Corporal"
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/corporal
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/corporal

/mob/living/basic/trooper/nanotrasen/sergeant
	name = "\improper Nanotrasen Private Security Sergeant"
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant

// --------------------
// MELEE BASE
// --------------------

/mob/living/basic/trooper/nanotrasen/melee
	desc = "A member of Nanotrasen's private security, an underpaid security force. They seem rather unpleased to meet you. They are armed with an stun baton."
	melee_damage_lower = 35
	melee_damage_upper = 35
	melee_damage_type = STAMINA
	attack_verb_continuous = "beats"
	attack_verb_simple = "beat"
	attack_sound = 'sound/items/weapons/egloves.ogg'
	r_hand = /obj/item/melee/baton/security/loaded
	light_range = 1.5
	light_power = 0.5
	light_color = LIGHT_COLOR_ORANGE
	var/projectile_deflect_chance = 0

/mob/living/basic/trooper/nanotrasen/melee/projectile_hit(obj/projectile/hitting_projectile, def_zone, piercing_hit, blocked)
	if(prob(projectile_deflect_chance))
		visible_message(span_danger("[src] blocks [hitting_projectile] with its shield!"))
		return BULLET_ACT_BLOCK
	return ..()

// --------------------
// VARIANTS
// --------------------

/mob/living/basic/trooper/nanotrasen/melee/corporal
	name = "\improper Nanotrasen Private Security Corporal"
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/corporal
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/corporal

/mob/living/basic/trooper/nanotrasen/melee/sergeant
	name = "\improper Nanotrasen Private Security Sergeant"
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant

// --------------------
// MELEE + SHIELD BASE
// --------------------

/mob/living/basic/trooper/nanotrasen/melee/shield
	desc = "A member of Nanotrasen's private security, an underpaid security force. They seem rather unpleased to meet you. They are armed with an stun baton and riot shield."
	projectile_deflect_chance = 45
	l_hand = /obj/item/shield/riot

// --------------------
// VARIANTS
// --------------------

/mob/living/basic/trooper/nanotrasen/melee/shield/corporal
	name = "\improper Nanotrasen Private Security Corporal"
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/corporal
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/corporal

/mob/living/basic/trooper/nanotrasen/melee/shield/sergeant
	name = "\improper Nanotrasen Private Security Sergeant"
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant

// --------------------
// RANGED BASE
// --------------------

/mob/living/basic/trooper/nanotrasen/ranged
	desc = "A member of Nanotrasen's private security, an underpaid security force. They seem rather unpleased to meet you. They are armed with an M1911."
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged
	r_hand = /obj/item/gun/ballistic/automatic/pistol/m1911
	/// Type of bullet we use
	var/casingtype = /obj/item/ammo_casing/c45
	/// Sound to play when firing weapon
	var/projectilesound = 'sound/items/weapons/gun/pistol/shot_alt.ogg'
	/// number of burst shots
	var/burst_shots
	/// Time between taking shots
	var/ranged_cooldown = 1 SECONDS

/mob/living/basic/trooper/nanotrasen/ranged/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/ranged_attacks,\
		casing_type = casingtype,\
		projectile_sound = projectilesound,\
		cooldown_time = ranged_cooldown,\
		burst_shots = burst_shots,\
	)
	if (ranged_cooldown <= 1 SECONDS)
		AddComponent(/datum/component/ranged_mob_full_auto)

// --------------------
// RANGED VARIANTS
// --------------------

/mob/living/basic/trooper/nanotrasen/ranged/corporal
	name = "\improper Nanotrasen Private Security Corporal"
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/corporal
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/corporal

/mob/living/basic/trooper/nanotrasen/ranged/sergeant
	name = "\improper Nanotrasen Private Security Sergeant"
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant

// --------------------
// SMG BASE
// --------------------

/mob/living/basic/trooper/nanotrasen/ranged/smg
	desc = "A member of Nanotrasen's private security, an underpaid security force. They seem rather unpleased to meet you. They are armed with a WT-550."
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged/burst
	casingtype = /obj/item/ammo_casing/c46x30mm
	projectilesound = 'sound/items/weapons/gun/smg/shot.ogg'
	r_hand = /obj/item/gun/ballistic/automatic/wt550
	burst_shots = 3
	ranged_cooldown = 3 SECONDS

// --------------------
// SMG VARIANTS
// --------------------

/mob/living/basic/trooper/nanotrasen/ranged/smg/corporal
	name = "\improper Nanotrasen Private Security Corporal"
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/corporal
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/corporal

/mob/living/basic/trooper/nanotrasen/ranged/smg/sergeant
	name = "\improper Nanotrasen Private Security Sergeant"
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant

/mob/living/basic/trooper/nanotrasen/ranged/smg/mps5
	desc = "A member of Nanotrasen's private security, an underpaid security force. They seem rather unpleased to meet you. They are armed with a MP-S5 VIG."
	casingtype = /obj/item/ammo_casing/c9x17mm
	projectilesound = 'modular_zzplurt/sound/items/weapons/gun/mp5_shot.ogg'
	r_hand = /obj/item/gun/ballistic/automatic/mps5
	burst_shots = 5
	ranged_cooldown = 2 SECONDS

/mob/living/basic/trooper/nanotrasen/ranged/smg/mps5/corporal
	name = "\improper Nanotrasen Private Security Corporal"
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/corporal
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/corporal

/mob/living/basic/trooper/nanotrasen/ranged/smg/mps5/sergeant
	name = "\improper Nanotrasen Private Security Sergeant"
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant

// --------------------
// SPECIAL UNITS
// --------------------

/mob/living/basic/trooper/nanotrasen/ranged/captain
	name = "\improper Nanotrasen Private Security Captain"
	desc = "Effectively a field officer of Nanotrasen's private security, an underpaid security force. They seem rather unpleased to meet you. They are armed with a NTS-24 Assault Rifle."
	casingtype = /obj/item/ammo_casing/c68
	maxHealth = 150
	health = 150
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged/burst
	casingtype = /obj/item/ammo_casing/c68
	burst_shots = 3
	projectilesound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_shot.ogg'
	ranged_cooldown = 3 SECONDS
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/captain
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/captain
	r_hand = /obj/item/gun/ballistic/automatic/bulwark

/mob/living/basic/trooper/nanotrasen/ranged/assault
	name = "\improper Nanotrasen ERT Security Officer"
	desc = "A member of Nanotrasen's Emergency Response Team. Contact Central Command if you see them, prepare to die if you're spotted off-station. They are armed with a Hoshi modular laser carbine."
	maxHealth = 200
	health = 200
	unsuitable_atmos_damage = 0
	minimum_survivable_temperature = 0
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged
	casingtype = /obj/item/ammo_casing/energy/cybersun_small_hellfire
	projectilesound = 'modular_zubbers/sound/weapons/laser.ogg'
	ranged_cooldown = 1 SECONDS
	corpse = /obj/effect/gibspawner/human
	mob_spawner = /obj/effect/mob_spawn/corpse/human/nanotrasenelitesoldier
	r_hand = /obj/item/gun/energy/modular_laser_rifle/carbine

/mob/living/basic/trooper/nanotrasen/ranged/assault/lead
	name = "\improper Nanotrasen ERT Commander"
	desc = "A commanding officer of Nanotrasen's Emergency Response Team. Contact Central Command if you see them, prepare to die if you're spotted off-station. They are armed with a Hyeseong modular laser rifle."
	maxHealth = 225
	health = 225
	casingtype = /obj/item/ammo_casing/energy/cybersun_big_kill
	mob_spawner = /obj/effect/mob_spawn/corpse/human/nanotrasenelitecommander
	r_hand = /obj/item/gun/energy/modular_laser_rifle

/mob/living/basic/trooper/nanotrasen/ranged/assault/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)
	set_light(4)

/mob/living/basic/trooper/nanotrasen/ranged/elite
	name = "Deathsquad Trooper"
	desc = "A member of Nanotrasen's Deathsquad, THE elite strike team. Central Command won't help you, prepare to die if you're spotted. They are armed with a Pulse Rifle."
	maxHealth = 250
	health = 250
	unsuitable_atmos_damage = 0
	minimum_survivable_temperature = 0
	casingtype = /obj/item/ammo_casing/energy/laser/pulse
	projectilesound = 'sound/items/weapons/pulse.ogg'
	ranged_cooldown = 5 SECONDS
	corpse = /obj/effect/gibspawner/human
	mob_spawner = /obj/effect/mob_spawn/corpse/human/nanotrasendeathsquad
	r_hand = /obj/item/gun/energy/pulse

/mob/living/basic/trooper/nanotrasen/ranged/elite/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)
	set_light_color(COLOR_RED)
	set_light(4)

/// I'm leaving this one because I really can't be bothered to edit skyrat maps.
/mob/living/basic/trooper/nanotrasen/peaceful
	desc = "A member of Nanotrasen's private security, an underpaid security force."
	ai_controller = /datum/ai_controller/basic_controller/trooper/peaceful

/mob/living/basic/trooper/nanotrasen/peaceful/Initialize(mapload)
	. = ..()
	var/datum/callback/retaliate_callback = CALLBACK(src, PROC_REF(ai_retaliate_behaviour))
	AddComponent(/datum/component/ai_retaliate_advanced, retaliate_callback)

/mob/living/basic/trooper/nanotrasen/proc/ai_retaliate_behaviour(mob/living/attacker)
	if (!istype(attacker))
		return
	for (var/mob/living/basic/trooper/nanotrasen/potential_trooper in oview(src, 7))
		potential_trooper.ai_controller.insert_blackboard_key_lazylist(BB_BASIC_MOB_RETALIATE_LIST, attacker)

/mob/living/basic/trooper/nanotrasen/ranged/smg/peaceful
	desc = "A member of Nanotrasen's private security, an underpaid security force. They are armed with an WT-550."
	ai_controller = /datum/ai_controller/basic_controller/trooper/peaceful

/mob/living/basic/trooper/nanotrasen/ranged/smg/peaceful/Initialize(mapload)
	. = ..()
	var/datum/callback/retaliate_callback = CALLBACK(src, PROC_REF(ai_retaliate_behaviour))
	AddComponent(/datum/component/ai_retaliate_advanced, retaliate_callback)

/mob/living/basic/trooper/nanotrasen/proc/ai_retaliate_behaviour(mob/living/attacker)
	if (!istype(attacker))
		return
	for (var/mob/living/basic/trooper/nanotrasen/potential_trooper in oview(src, 7))
		potential_trooper.ai_controller.insert_blackboard_key_lazylist(BB_BASIC_MOB_RETALIATE_LIST, attacker)
