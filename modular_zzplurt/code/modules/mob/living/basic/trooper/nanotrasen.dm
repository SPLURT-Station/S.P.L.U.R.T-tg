/// Nanotrasen Private Security forces
/mob/living/basic/trooper/nanotrasen
	name = "\improper Nanotrasen Private Security Operative"
	desc = "A low-ranked operative of Nanotrasen's Private Security. As much as it may be good to see them, they aren't happy to see you.."
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity

/mob/living/basic/trooper/nanotrasen/baton
	r_hand = /obj/item/melee/baton/security/loaded
	attack_verb_continuous = "beats"
	attack_verb_simple = "beat"
	attack_sound = 'sound/items/weapons/egloves.ogg'
	light_range = 1.5
	light_power = 0.5
	light_color = LIGHT_COLOR_ORANGE
	melee_damage_type = STAMINA
	var/projectile_deflect_chance = 0

/mob/living/basic/trooper/nanotrasen/baton/projectile_hit(obj/projectile/hitting_projectile, def_zone, piercing_hit, blocked)
	if(prob(projectile_deflect_chance))
		visible_message(span_danger("[src] blocks [hitting_projectile] with its shield!"))
		return BULLET_ACT_BLOCK
	return ..()

/mob/living/basic/trooper/nanotrasen/baton/shielded
	l_hand = /obj/item/shield/riot/tele
	projectile_deflect_chance = 50

/mob/living/basic/trooper/nanotrasen/ranged/smg
	name = "\improper Nanotrasen Private Security Sergeant"
	desc = "A mid-ranked sergeant of Nanotrasen's Private Security. As much as it may be good to see them, they aren't happy to see you.."
	corpse = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant
	mob_spawner = /obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant

/mob/living/basic/trooper/nanotrasen/ranged/commander
	name = "\improper Nanotrasen Private Security Commander"
	desc = "A high-ranked Commander of Nanotrasen's Private Security. As much as it may be good to see them, they aren't happy to see you.."

	casingtype = /obj/item/ammo_casing/a223
	burst_shots = 4
	ranged_cooldown = 3 SECONDS
	projectilesound = 'sound/items/weapons/gun/smg/shot.ogg'
	r_hand = /obj/item/gun/ballistic/automatic/ar
	corpse = /obj/effect/mob_spawn/corpse/human/nanotrasenassaultsoldier
	mob_spawner = /obj/effect/mob_spawn/corpse/human/nanotrasenassaultsoldier

/mob/living/basic/trooper/nanotrasen/peaceful
	desc = "A low-ranked operative of Nanotrasen's Private Security."

/mob/living/basic/trooper/nanotrasen/ranged/peaceful
	desc = "A low-ranked operative of Nanotrasen's Private Security."
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged/peaceful

/mob/living/basic/trooper/nanotrasen/ranged/peaceful/Initialize(mapload)
	. = ..()
	var/datum/callback/retaliate_callback = CALLBACK(src, PROC_REF(ai_retaliate_behaviour))
	AddComponent(/datum/component/ai_retaliate_advanced, retaliate_callback)

/mob/living/basic/trooper/nanotrasen/ranged/smg/peaceful
	desc = "A mid-ranked sergeant of Nanotrasen's Private Security."

/mob/living/basic/trooper/nanotrasen/ranged/commander/peaceful
	desc = "A high-ranked Commander of Nanotrasen's Private Security."
	ai_controller = /datum/ai_controller/basic_controller/trooper/ranged/peaceful
