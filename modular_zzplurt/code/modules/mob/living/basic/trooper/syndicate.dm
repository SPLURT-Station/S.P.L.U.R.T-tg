/// Syndicate troopers
/mob/living/basic/trooper/splurt/syndicate
	name = "Syndicate Agent"
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be unarmed."
	faction = list(ROLE_SYNDICATE)
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate
	gender = MALE

/mob/living/basic/trooper/splurt/syndicate/melee
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a knife."
	death_message = "collapses to the ground, their knife clattering against the ground."
	loot = list(/obj/item/knife/combat)
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	r_hand = /obj/item/knife/combat

///////////////Guns////////////

/mob/living/basic/trooper/splurt/syndicate/ranged
	name = "Syndicate Defense Operative"
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a Ansem pistol."
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/operative
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/operative
	maxHealth = 120
	health = 120
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged
	death_message = "collapses to the ground, their gun hitting the ground."
	loot = list(/obj/effect/spawner/random/syndicate_ansem)
	r_hand = /obj/item/gun/ballistic/automatic/pistol/clandestine
	/// Type of bullet we use
	var/casingtype = /obj/item/ammo_casing/c10mm
	/// Sound to play when firing weapon
	var/projectilesound = 'sound/items/weapons/gun/pistol/shot.ogg'
	/// number of burst shots
	var/burst_shots
	/// Time between taking shots
	var/ranged_cooldown = 1 SECONDS

/mob/living/basic/trooper/splurt/syndicate/ranged/assault
	name = "Syndicate Assault Operative"
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a Suppressed Ansem pistol."
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/operative/assault
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/operative/assault
	maxHealth = 140
	health = 140
	loot = list(/obj/effect/spawner/random/syndicate_ansem_suppressed)
	projectilesound = 'sound/items/weapons/gun/pistol/shot_suppressed.ogg'

/obj/item/gun/ballistic/automatic/pistol/clandestine/suppressed/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/S = new(src)
	install_suppressor(S)

/obj/effect/spawner/random/syndicate_ansem_suppressed
	name = "suppressed ansem spawner"
	spawn_loot_chance = 100
	loot = list( // 95% chance for a exploded gun, 10% chance of ansem
		/obj/item/gun/ballistic/automatic/pistol/clandestine/suppressed = 1,
		/obj/effect/decal/cleanable/generic = 9,
	)

/obj/effect/spawner/random/syndicate_ansem
	name = "ansem spawner"
	spawn_loot_chance = 100
	loot = list( // 95% chance for a exploded gun, 10% chance of ansem
		/obj/item/gun/ballistic/automatic/pistol/clandestine = 1,
		/obj/effect/decal/cleanable/generic = 9,
	)

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
	name = "Syndicate Defense Operative"
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a C-20r SMG."
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/operative
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/operative
	maxHealth = 120
	health = 120
	casingtype = /obj/item/ammo_casing/c45
	projectilesound = 'sound/items/weapons/gun/smg/shot.ogg'
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged/burst
	death_message = "collapses to the ground, their gun self-destructing as it hits the ground."
	loot = list(/obj/effect/decal/cleanable/generic) // 0% chance for a c20-r.
	burst_shots = 3
	ranged_cooldown = 3 SECONDS
	r_hand = /obj/item/gun/ballistic/automatic/c20r

/mob/living/basic/trooper/splurt/syndicate/ranged/smg/assault
	name = "Syndicate Assault Operative"
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/operative/assault
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/operative/assault
	maxHealth = 140
	health = 140

/mob/living/basic/trooper/splurt/syndicate/ranged/shotgun
	name = "Syndicate Defense Operative"
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a Renoster Shotgun."
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/operative
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/operative
	maxHealth = 120
	health = 120
	casingtype = /obj/item/ammo_casing/shotgun/buckshot
	projectilesound = 'modular_skyrat/modules/modular_weapons/sounds/shotgun_heavy.ogg'
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged/shotgunner
	death_message = "collapses to the ground, their gun hitting the ground."
	loot = list(/obj/effect/spawner/random/syndicate_renoster)
	burst_shots = 1
	ranged_cooldown = 2 SECONDS
	r_hand = /obj/item/gun/ballistic/shotgun/riot/sol/evil

/mob/living/basic/trooper/splurt/syndicate/ranged/shotgun/assault
	name = "Syndicate Assault Operative"
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a Bulldog Shotgun."
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/operative/assault
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/operative/assault
	maxHealth = 140
	health = 140
	projectilesound = 'sound/items/weapons/gun/shotgun/shot_alt.ogg'
	death_message = "collapses to the ground, their gun self-destructing as it hits the ground."
	loot = list(/obj/effect/decal/cleanable/generic) // 0% chance for a bulldog.
	burst_shots = 2
	ranged_cooldown = 3 SECONDS
	r_hand = /obj/item/gun/ballistic/shotgun/bulldog

/obj/effect/spawner/random/syndicate_renoster
	name = "renoster spawner"
	spawn_loot_chance = 100
	loot = list( // 95% chance for a exploded gun, 5% chance of renoster shotgun
		/obj/item/gun/ballistic/shotgun/riot/sol/evil = 0.5,
		/obj/effect/decal/cleanable/generic = 9.5,
	)

/mob/living/basic/trooper/splurt/syndicate/ranged/smg/lieutenant
	name = "Syndicate Executive Officer"
	desc = "A high-ranking member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a M-90gl Carbine, they look very tough, fighting is not advised."
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/lieutenant
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/lieutenant
	maxHealth = 220
	health = 220
	casingtype = /obj/item/ammo_casing/a223
	projectilesound = 'sound/items/weapons/gun/smg/shot_alt.ogg'
	ranged_cooldown = 4 SECONDS
	death_message = "collapses to the ground, their gun self-destructing as it hits the ground."
	loot = list(/obj/effect/decal/cleanable/generic) // 0% chance for a M90.
	r_hand = /obj/item/gun/ballistic/automatic/m90

/mob/living/basic/trooper/splurt/syndicate/ranged/smg/captain
	name = "Syndicate Commanding Officer"
	desc = "Nearly the highest ranking member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a L6 SAW, they look INCREDIBLY tough, run while you still can."
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/captain
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/captain
	maxHealth = 280
	health = 280
	casingtype = /obj/item/ammo_casing/m7mm
	projectilesound = 'sound/items/weapons/gun/l6/shot.ogg'
	burst_shots = 6
	ranged_cooldown = 5 SECONDS
	death_message = "collapses to the ground, their gun self-destructing as it hits the ground."
	loot = list(/obj/effect/decal/cleanable/generic) // 0% chance for a L6-SAW.
	r_hand = /obj/item/gun/ballistic/automatic/l6_saw
