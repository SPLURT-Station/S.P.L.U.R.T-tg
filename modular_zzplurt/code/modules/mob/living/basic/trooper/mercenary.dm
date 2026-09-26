/mob/living/basic/trooper/mercenary
	name = "\improper Mercenary"
	desc = "A unaffiliated mercenary, they follow where the paycheck leads."
	maxHealth = 120
	health = 120
	faction = list(ROLE_SYNDICATE)
	corpse = /obj/effect/mob_spawn/corpse/human/mercenary
	mob_spawner = /obj/effect/mob_spawn/corpse/human/mercenary
	death_message = "collapses to the ground."

/mob/living/basic/trooper/mercenary/melee //dude with a knife and no shields
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	r_hand = /obj/item/knife/combat
	loot = list(/obj/item/knife/combat)
	var/projectile_deflect_chance = 0

/mob/living/basic/trooper/mercenary/melee/projectile_hit(obj/projectile/hitting_projectile, def_zone, piercing_hit, blocked)
	if(prob(projectile_deflect_chance))
		visible_message(span_danger("[src] blocks [hitting_projectile] with its shield!"))
		return BULLET_ACT_BLOCK
	return ..()

/mob/living/basic/trooper/mercenary/melee/sword
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/blade1.ogg'
	armour_penetration = 35
	projectile_deflect_chance = 25
	light_range = 2
	light_power = 2.5
	light_color = LIGHT_COLOR_GREEN
	r_hand = /obj/item/melee/energy/sword/saber/green

///////////////Guns////////////

/mob/living/basic/trooper/mercenary/ranged
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged
	r_hand = /obj/item/gun/ballistic/revolver/c38
	loot = list(/obj/item/gun/ballistic/revolver/c38)
	/// Type of bullet we use
	var/casingtype = /obj/item/ammo_casing/c38
	/// Sound to play when firing weapon
	var/projectilesound = 'sound/items/weapons/gun/revolver/shot.ogg'
	/// number of burst shots
	var/burst_shots
	/// Time between taking shots
	var/ranged_cooldown = 1 SECONDS

/mob/living/basic/trooper/mercenary/ranged/Initialize(mapload)
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

/mob/living/basic/trooper/mercenary/ranged/smg
	casingtype = /obj/item/ammo_casing/c46x30mm
	projectilesound = 'modular_zzplurt/sound/items/weapons/gun/wt458_shot.ogg'
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged/burst
	burst_shots = 2
	ranged_cooldown = 2 SECONDS
	r_hand = /obj/item/gun/ballistic/automatic/wt458
	loot = list(/obj/item/gun/ballistic/automatic/wt458)

/mob/living/basic/trooper/mercenary/ranged/shotgun
	casingtype = /obj/item/ammo_casing/shotgun/buckshot //buckshot (up to 72.5 brute) fired in a two-round burst
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged/shotgunner
	ranged_cooldown = 1 SECONDS
	r_hand = /obj/item/gun/ballistic/shotgun/lethal
	loot = list(/obj/item/gun/ballistic/shotgun/lethal)

/mob/living/basic/trooper/mercenary/ranged/smg/commander
	name = "\improper Mercenary Commander"
	desc = "A unaffiliated mercenary commanding officer, they follow, and lead where the paycheck goes."
	maxHealth = 200
	health = 200
	burst_shots = 4
	ranged_cooldown = 3 SECONDS
	corpse = /obj/effect/mob_spawn/corpse/human/mercenary/commander
	mob_spawner = /obj/effect/mob_spawn/corpse/human/mercenary/commander
	r_hand = /obj/item/gun/ballistic/automatic/wt550
	loot = list(/obj/item/gun/ballistic/automatic/wt550)
