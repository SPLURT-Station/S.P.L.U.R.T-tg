/// Syndicate troopers
/mob/living/basic/trooper/splurt/syndicate
	name = "Syndicate Agent"
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be unarmed."
	faction = list(ROLE_SYNDICATE)
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate


/mob/living/basic/trooper/splurt/syndicate/melee
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a knife."
	loot = list(/obj/item/knife/combat/survival)
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	r_hand = /obj/item/knife/combat/survival
	var/projectile_deflect_chance = 0

///////////////Guns////////////

/mob/living/basic/trooper/splurt/syndicate/ranged
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/operative
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/operative
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged
	r_hand = /obj/item/gun/ballistic/automatic/pistol/clandestine
	/// Type of bullet we use
	var/casingtype = /obj/item/ammo_casing/c10mm
	/// Sound to play when firing weapon
	var/projectilesound = 'sound/items/weapons/gun/pistol/shot.ogg'
	/// number of burst shots
	var/burst_shots
	/// Time between taking shots
	var/ranged_cooldown = 1 SECONDS

/mob/living/basic/trooper/splurt/syndicate/ranged/Initialize(mapload)
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

/mob/living/basic/trooper/splurt/syndicate/ranged/smg
	casingtype = /obj/item/ammo_casing/c45
	projectilesound = 'sound/items/weapons/gun/smg/shot.ogg'
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged/burst
	burst_shots = 3
	ranged_cooldown = 3 SECONDS
	r_hand = /obj/item/gun/ballistic/automatic/c20r

/mob/living/basic/trooper/splurt/syndicate/ranged/smg/lieutenant
	casingtype = /obj/item/ammo_casing/a223
	projectilesound = 'sound/items/weapons/gun/smg/shot_alt.ogg'
	ranged_cooldown = 4 SECONDS
	r_hand = /obj/item/gun/ballistic/automatic/m90

/mob/living/basic/trooper/splurt/syndicate/ranged/smg/captain
	casingtype = /obj/item/ammo_casing/m7mm
	projectilesound = 'sound/items/weapons/gun/l6/shot.ogg'
	burst_shots = 6
	ranged_cooldown = 5 SECONDS
	r_hand = /obj/item/gun/ballistic/automatic/l6_saw
