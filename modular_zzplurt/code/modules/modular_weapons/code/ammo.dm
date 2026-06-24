// MP-S5 VIG MAGAZINES
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
	multitype = FALSE

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

// M45A5 MAGAZINES

/obj/item/ammo_box/magazine/m45a5
	name = "\improper M45A5 pistol magazine (.460 Rowland)"
	desc = "A magazine for the M45A5 chambered in .460 Rowland, holds ten rounds."
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/romulus_technology/ammo.dmi'
	icon_state = "rowlandmodular"
	base_icon_state = "rowlandmodular"
	ammo_type = /obj/item/ammo_casing/c460rowland
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	multiple_sprite_use_base = TRUE
	caliber = CALIBER_460ROWLAND
	max_ammo = 10
	multitype = FALSE

/obj/item/ammo_box/magazine/m45a5/ap
	name = "\improper M45A5 pistol magazine (.460 Rowland AP)"
	ammo_type = /obj/item/ammo_casing/c460rowland/ap

// VICEROY MAGAZINES

/obj/item/ammo_box/magazine/viceroy
	name = "NTX-12 pistol magazine (9x25mm Mk.12)"
	desc = "A standard 9x25mm Mk.12 magazine for the NTX-12 \"Viceroy\", contains 12 bullets."
	icon = 'modular_zzplurt/icons/obj/guns/ammo.dmi'
	icon_state = "viceroy_mag"
	base_icon_state = "viceroy_mag"
	ammo_type = /obj/item/ammo_casing/c9mm
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	multiple_sprite_use_base = TRUE
	caliber = CALIBER_9MM
	max_ammo = 12
	multitype = FALSE

// MP-S5 VIG CASINGS

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
	name = "9x17mm IHDF bullet casing"
	desc = "A 9x17mm bullet casing. This one fires a bullet of 'Intelligent High-Impact Dispersal Foam', which is best compared to a riot-grade foam dart."
	projectile_type = /obj/projectile/bullet/c9x17mm/ihdf
	harmful = FALSE

/obj/item/ammo_casing/c9x17mm/rubber
	name = "9x17mm rubber bullet casing"
	desc = "A 9x17mm bullet casing. This less than lethal round sure hurts to get shot by, but causes little physical harm."
	projectile_type = /obj/projectile/bullet/c9x17mm/rubber
	harmful = FALSE

// M45A5 CASINGS

/obj/item/ammo_casing/c460rowland
	name = ".460 Rowland bullet casing"
	desc = "A .460 Rowland bullet casing."
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/romulus_technology/ammo.dmi'
	icon_state = "sl-casing"
	projectile_type = /obj/projectile/bullet/c460rowland
	caliber = CALIBER_460ROWLAND
	advanced_print_req = TRUE

/obj/item/ammo_casing/c460rowland/ap
	name = ".460 Rowland armor-piercing bullet casing"
	desc = "A .460 Rowland bullet casing. This one fires an armor-piercing projectile."
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/romulus_technology/ammo.dmi'
	icon_state = "sr-casing"
	projectile_type = /obj/projectile/bullet/c460rowland/ap
	custom_materials = AMMO_MATS_AP
	advanced_print_req = TRUE

// MP-S5 VIG PROJECTILES
/obj/projectile/bullet/c9x17mm
	name = "9x17mm bullet"
	damage = 16
	wound_bonus = -5
	exposed_wound_bonus = 5
	embed_falloff_tile = -3

/obj/projectile/bullet/c9x17mm/ap
	name = "9x17mm armor-piercing bullet"
	damage = 13
	armour_penetration = 35
	embed_type = null
	shrapnel_type = null

/obj/projectile/bullet/c9x17mm/hp
	name = "9x17mm fragmenting bullet"
	damage = 26
	weak_against_armour = TRUE

/obj/projectile/bullet/c9x17mm/ihdf
	name = "9x17mm IHDF bullet"
	damage = 9
	damage_type = STAMINA
	embed_type = /datum/embedding/bullet/c9x17mm_ihdf

/datum/embedding/bullet/c9x17mm_ihdf
	embed_chance = 20
	fall_chance = 4
	jostle_chance = 2
	pain_mult = 3
	pain_stam_pct = 1
	ignore_throwspeed_threshold = TRUE
	jostle_pain_mult = 4
	rip_time = 1 SECONDS

/obj/projectile/bullet/c9x17mm/rubber
	name = "9x17mm rubber bullet"
	icon_state = "pellet"
	damage = 7
	stamina = 16
	ricochets_max = 3
	ricochet_incidence_leeway = 0
	ricochet_chance = 150
	ricochet_decay_damage = 0.9
	shrapnel_type = null
	sharpness = NONE
	embed_type = null

// M45A5 PROJECTILES

/obj/projectile/bullet/c460rowland
	name = ".460 Rowland bullet"
	damage = 40
	stamina = 15 //knock the winds outta ya
	wound_bonus = -5
	stamina_falloff_tile = 0.3

/obj/projectile/bullet/c460rowland/ap
	name = ".460 Rowland armor-piercing bullet"
	damage = 30
	wound_bonus = -25
	armour_penetration = 40
	damage_falloff_tile = 0
	stamina_falloff_tile = 0
	embed_type = null
	shrapnel_type = null

//WT550 4.6x30mm Override
/obj/projectile/bullet/c46x30mm
	wound_bonus = 0
	armour_penetration = 10

/obj/projectile/bullet/c46x30mm/ap
	armour_penetration = 45
