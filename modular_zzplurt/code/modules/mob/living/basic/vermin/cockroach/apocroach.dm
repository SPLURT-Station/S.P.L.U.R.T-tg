/// A black-ops MOD-armored cockroach with a miniature pulse destroyer.
/mob/living/basic/cockroach/laseroach/apocroach
	name = "apocroach"
	desc = "A black-and-crimson armored cockroach carrying a tiny pulse destroyer."
	icon = 'modular_zzplurt/icons/mob/living/basic/vermin/cockroach/apocroach.dmi'
	icon_state = "apocroach"
	icon_living = "apocroach"
	icon_dead = "apocroach_dead"
	health = 50
	maxHealth = 50
	armor_type = /datum/armor/mod_theme_apocryphal
	responsory_armor_enabled = TRUE
	laser_projectile_type = /obj/projectile/beam/pulse
	laser_fire_sound = 'modular_skyrat/modules/aesthetics/guns/sound/pulse.ogg'
	ranged_cooldown = 1 SECONDS
	minion_path = null

/mob/living/basic/cockroach/laseroach/apocroach/Initialize(mapload)
	enable_modsuit_space_support()
	return ..()

/mob/living/basic/cockroach/laseroach/apocroach/unarmed
	name = "unarmed apocroach"
	desc = "A cockroach armored in the colors of an apocryphal MODsuit. Its pulse destroyer is missing."
	icon_state = "apocroach_unarmed"
	icon_living = "apocroach_unarmed"
	icon_dead = "apocroach_unarmed_dead"
	laser_attacks_enabled = FALSE
	ai_controller = /datum/ai_controller/basic_controller/cockroach/aggro
	melee_damage_lower = 2
	melee_damage_upper = 4
	obj_damage = 5
	melee_attack_cooldown = 0.8 SECONDS
