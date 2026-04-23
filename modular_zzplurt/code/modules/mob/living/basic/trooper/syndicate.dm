/// Syndicate troopers
/mob/living/basic/trooper/splurt/syndicate
	name = "Syndicate Agent"
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be unarmed."
	faction = list(ROLE_SYNDICATE)
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate
	ai_controller = /datum/ai_controller/basic_controller/trooper/syndicate
	gender = MALE

/mob/living/basic/trooper/splurt/syndicate/melee
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a combat knife."
	death_message = "collapses to the ground, their knife clattering against the ground."
	loot = list(/obj/item/knife/combat) // 100% chance for a combat knife.
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	r_hand = /obj/item/knife/combat
	var/projectile_deflect_chance = 0

/mob/living/basic/trooper/splurt/syndicate/melee/sword
	name = "Syndicate Defense Operative"
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a energy sword."
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/operative
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/operative
	maxHealth = 120
	health = 120
	death_message = "collapses to the ground, their energy sword self-destructing as it hits the ground."
	loot = list(/obj/effect/decal/cleanable/generic) // 0% chance for a esword.
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_sound = 'sound/items/weapons/blade1.ogg'
	armour_penetration = 35
	projectile_deflect_chance = 30
	light_range = 3
	light_power = 1
	light_color = COLOR_SOFT_RED
	r_hand = /obj/item/melee/energy/sword/saber/red

/mob/living/basic/trooper/splurt/syndicate/melee/sword/projectile_hit(obj/projectile/hitting_projectile, def_zone, piercing_hit, blocked)
	if(prob(projectile_deflect_chance))
		visible_message(span_danger("[src] blocks [hitting_projectile]!"))
		return BULLET_ACT_BLOCK
	return ..()

/mob/living/basic/trooper/splurt/syndicate/melee/sword/shield
	name = "Syndicate Assault Operative"
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a energy sword and shield."
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/operative/assault
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/operative/assault
	maxHealth = 140
	health = 140
	death_message = "collapses to the ground, their energy sword and shield self-destructing as it hits the ground."
	loot = list(/obj/effect/decal/cleanable/generic) // 0% chance for a esword and shield.
	projectile_deflect_chance = 40
	l_hand = /obj/item/shield/energy

///////////////Guns////////////

/mob/living/basic/trooper/splurt/syndicate/ranged
	name = "Syndicate Defense Operative"
	desc = "A member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a Ansem pistol."
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/operative
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/operative
	maxHealth = 120
	health = 120
	ai_controller = /datum/ai_controller/basic_controller/trooper/syndicate/ranged
	death_message = "collapses to the ground, their gun hitting the ground."
	loot = list(/obj/effect/spawner/random/syndicate_ansem) // 5% chance for a ansem.
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
	burst_shots = 2
	ranged_cooldown = 1.25 SECONDS
	loot = list(/obj/effect/spawner/random/syndicate_ansem_suppressed) // 4% chance for a suppressed ansem.
	projectilesound = 'sound/items/weapons/gun/pistol/shot_suppressed.ogg'

/obj/item/gun/ballistic/automatic/pistol/clandestine/suppressed/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/S = new(src)
	install_suppressor(S)

/obj/effect/spawner/random/syndicate_ansem_suppressed
	name = "suppressed ansem spawner"
	loot = list( // 96% chance for a exploded gun, 4% chance of ansem
		/obj/effect/decal/cleanable/generic = 96,
		/obj/item/gun/ballistic/automatic/pistol/clandestine/suppressed = 4,
	)

/obj/effect/spawner/random/syndicate_ansem
	name = "ansem spawner"
	loot = list( // 95% chance for a exploded gun, 5% chance of ansem
		/obj/effect/decal/cleanable/generic = 95,
		/obj/item/gun/ballistic/automatic/pistol/clandestine = 5,
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
	ai_controller = /datum/ai_controller/basic_controller/trooper/syndicate/ranged/burst
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
	ai_controller = /datum/ai_controller/basic_controller/trooper/syndicate/ranged/shotgunner
	death_message = "collapses to the ground, their gun hitting the ground."
	loot = list(/obj/effect/spawner/random/syndicate_renoster) // 2% chance for a renoster.
	burst_shots = 1
	ranged_cooldown = 1 SECONDS
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
	loot = list( // 98% chance for a exploded gun, 2% chance of renoster shotgun
		/obj/effect/decal/cleanable/generic = 98,
		/obj/item/gun/ballistic/shotgun/riot/sol/evil = 2,
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
	ranged_cooldown = 2 SECONDS
	death_message = "collapses to the ground, their gun self-destructing as it hits the ground."
	loot = list(/obj/effect/decal/cleanable/generic) // 0% chance for a M90.
	r_hand = /obj/item/gun/ballistic/automatic/m90

/mob/living/basic/trooper/splurt/syndicate/melee/sword/captain
	name = "Syndicate Commanding Officer"
	desc = "Nearly the highest ranking member of The Syndicate, those who wish death upon Nanotrasen, the megacorporation. They appear to be armed with a double-bladed energy sword, they look INCREDIBLY tough, run while you still can."
	corpse = /obj/effect/mob_spawn/corpse/human/syndicate/captain
	mob_spawner = /obj/effect/mob_spawn/corpse/human/syndicate/captain
	maxHealth = 280
	health = 280
	light_range = 6
	projectile_deflect_chance = 60
	death_message = "collapses to the ground, their double-bladed energy sword self-destructing as it hits the ground."
	loot = list(/obj/effect/decal/cleanable/generic) // 0% chance for a Desword.
	r_hand = /obj/item/dualsaber/red/wielded

/obj/item/dualsaber/red/wielded
	desc = "If you have this, contact a coder."
	icon_state = "dualsaberred1"
	inhand_icon_state = "dualsaberred1"

/obj/item/modular_computer/pda/syndicate_real
	name = "suspicious pda"
	desc = "A small portable microcomputer. It radiates with evil energy."
	icon_state = "/obj/item/modular_computer/pda/syndicate_real"
	device_theme = PDA_THEME_SYNDICATE
	comp_light_luminosity = 6.3
	light_color = COLOR_RED
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick
	greyscale_colors = "#33333D#61423F#820A16"
	long_ranged = TRUE

/obj/item/modular_computer/pda/nukeops/Initialize(mapload)
	. = ..()
	emag_act(forced = TRUE)
	var/datum/computer_file/program/messenger/msg = locate() in stored_files
	if(msg)
		msg.invisible = TRUE
