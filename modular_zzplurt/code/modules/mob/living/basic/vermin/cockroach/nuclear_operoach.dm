/// A MOD-armored cockroach with a miniature Bulldog. Separate from /glockroach
/// and /laseroach so only this casing-based ranged component is installed.
/mob/living/basic/cockroach/nuclear_operoach
	name = "nuclear operoach"
	desc = "A crimson-armored cockroach with green optics and a tiny Bulldog shotgun."
	icon = 'modular_zzplurt/icons/mob/living/basic/vermin/cockroach/nuclear_operoach.dmi'
	icon_state = "nuclear_operoach"
	icon_living = "nuclear_operoach"
	icon_dead = "nuclear_operoach_dead"
	health = 30
	maxHealth = 30
	armor_type = /datum/armor/mod_theme_syndicate
	responsory_armor_enabled = TRUE
	melee_damage_lower = 2.5
	melee_damage_upper = 10
	obj_damage = 10
	gold_core_spawnable = HOSTILE_SPAWN
	ai_controller = /datum/ai_controller/basic_controller/cockroach/glockroach
	minion_path = null
	/// Match the glockroach's single-shot cooldown.
	var/ranged_cooldown = 1 SECONDS
	var/shotgun_attacks_enabled = TRUE

/mob/living/basic/cockroach/nuclear_operoach/Initialize(mapload)
	enable_modsuit_space_support()
	. = ..()
	if(. == INITIALIZE_HINT_QDEL || !shotgun_attacks_enabled)
		return
	// This is the actual Bulldog drum's ammunition: six milspec buckshot pellets.
	// The ranged component fires a real shell and leaves its spent casing behind.
	AddComponent( \
		/datum/component/ranged_attacks, \
		casing_type = /obj/item/ammo_casing/shotgun/buckshot/milspec, \
		projectile_sound = 'sound/items/weapons/gun/shotgun/shot_alt.ogg', \
		burst_shots = 1, \
		cooldown_time = ranged_cooldown, \
	)
	if(ranged_cooldown <= 1 SECONDS)
		AddComponent(/datum/component/ranged_mob_full_auto)

/mob/living/basic/cockroach/nuclear_operoach/unarmed
	name = "unarmed nuclear operoach"
	desc = "A crimson-armored cockroach with green optics. Its tiny shotgun is missing."
	icon_state = "nuclear_operoach_unarmed"
	icon_living = "nuclear_operoach_unarmed"
	icon_dead = "nuclear_operoach_unarmed_dead"
	shotgun_attacks_enabled = FALSE
	ai_controller = /datum/ai_controller/basic_controller/cockroach/aggro
	melee_damage_lower = 2
	melee_damage_upper = 4
	obj_damage = 5
	melee_attack_cooldown = 0.8 SECONDS
