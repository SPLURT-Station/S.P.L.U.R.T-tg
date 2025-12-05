/obj/item/ammo_box/magazine/mps5
	name = "\improper MP-S5 magazine (9x17mm)"
	desc = "A 9x17mm magazine for the MP-S5 VIG, contains 30 bullets."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballisticmags.dmi'
	icon_state = "smg9x17mm"
	base_icon_state = "smg9x17mm"
	ammo_type = /obj/item/ammo_casing/c9x17mm
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	multiple_sprite_use_base = TRUE
	caliber = CALIBER_9X17MM
	max_ammo = 30

/obj/item/ammo_box/magazine/mps5/ap
	name = "\improper MP-S5 magazine (9x17mm AP)"
	icon_state = "smg9x17mmAP"
	base_icon_state = "smg9x17mmAP"
	ammo_type = /obj/item/ammo_casing/c9x17mm/ap

/obj/item/ammo_box/magazine/mps5/hp
	name = "\improper MP-S5 magazine (9x17mm HP)"
	icon_state = "smg9x17mmHP"
	base_icon_state = "smg9x17mmHP"
	ammo_type = /obj/item/ammo_casing/c9x17mm/hp

/obj/item/ammo_box/magazine/mps5/ihdf
	name = "\improper MP-S5 magazine (9x17mm Intelligent Dispersal Foam)"
	icon_state = "smg9x17mmDF"
	base_icon_state = "smg9x17mmDF"
	ammo_type = /obj/item/ammo_casing/c9x17mm/ihdf

/obj/item/ammo_box/magazine/mps5/rubber
	name = "\improper MP-S5 magazine (9x17mm Rubber)"
	icon_state = "smg9x17mmR"
	base_icon_state = "smg9x17mmR"
	ammo_type = /obj/item/ammo_casing/c9x17mm/rubber

/obj/item/ammo_casing/c9x17mm
	name = "9x17mm bullet casing"
	desc = "A 9x17mm bullet casing."
	projectile_type = /obj/projectile/bullet/c9x17mm
	caliber = CALIBER_9X17MM

/obj/item/ammo_casing/c9x17mm/ap
	name = "9x17mm armor-piercing bullet casing"
	desc = "A 9x17mm bullet casing. This one fires an armor-piercing projectile."
	projectile_type = /obj/projectile/bullet/c9x17mm/ap
	custom_materials = AMMO_MATS_AP
	advanced_print_req = TRUE

/obj/item/ammo_casing/c9x17mm/hp
	name = "9x17mm hollow-point bullet casing"
	desc = "A 9x17mm bullet casing. This one fires a hollow-point projectile. Very lethal to unarmored opponents."
	projectile_type = /obj/projectile/bullet/c9x17mm/hp
	advanced_print_req = TRUE

/obj/item/ammo_casing/c9x17mm/ihdf
	name = "9x17mm IHDF casing"
	desc = "A 9x17mm bullet casing. This one fires a bullet of 'Intelligent High-Impact Dispersal Foam', which is best compared to a riot-grade foam dart."
	projectile_type = /obj/projectile/bullet/c9x17mm/ihdf
	harmful = FALSE

/obj/item/ammo_casing/c9x17mm/rubber
	name = "9x17mm rubber casing"
	desc = "A 9x17mm bullet casing. This less than lethal round sure hurts to get shot by, but causes little physical harm."
	projectile_type = /obj/projectile/bullet/c9x17mm/rubber
	harmful = FALSE

/obj/projectile/bullet/c9x17mm
	name = "9x17mm bullet"
	damage = 16
	wound_bonus = -5
	exposed_wound_bonus = 5
	embed_falloff_tile = -3

/obj/projectile/bullet/c9x17mm/ap
	name = "9x17mm armor-piercing bullet"
	damage = 13
	armour_penetration = 40
	embed_type = null
	shrapnel_type = null

/obj/projectile/bullet/c9x17mm/hp
	name = "9x17mm fragmenting bullet"
	damage = 26
	weak_against_armour = TRUE

/obj/projectile/bullet/c9x17mm/ihdf
	name = "9x17mm IHDF bullet"
	damage = 18
	damage_type = STAMINA
	embed_type = /datum/embedding/bullet/c9x17mm_ihdf

/datum/embedding/bullet/c9x17mm_ihdf
	embed_chance = 0
	fall_chance = 4
	jostle_chance = 3
	pain_mult = 4
	pain_stam_pct = 0.3
	ignore_throwspeed_threshold = TRUE
	jostle_pain_mult = 5
	rip_time = 1 SECONDS

/obj/projectile/bullet/c9x17mm/rubber
	name = "9x17mm rubber bullet"
	icon_state = "pellet"
	damage = 13
	stamina = 27
	ricochets_max = 3
	ricochet_incidence_leeway = 0
	ricochet_chance = 150
	ricochet_decay_damage = 0.4
	shrapnel_type = null
	sharpness = NONE
	embed_type = null
