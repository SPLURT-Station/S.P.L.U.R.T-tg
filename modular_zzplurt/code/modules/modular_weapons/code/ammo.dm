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
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 9,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 4,
	)

/obj/item/ammo_box/magazine/mps5/ap
	name = "\improper MP-S5 magazine (9x17mm AP)"
	icon_state = "smg9x17mmAP"
	base_icon_state = "smg9x17mmAP"
	ammo_type = /obj/item/ammo_casing/c9x17mm/ap
	custom_materials = list(
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 8,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 4,
	)

/obj/item/ammo_box/magazine/mps5/hp
	name = "\improper MP-S5 magazine (9x17mm HP)"
	icon_state = "smg9x17mmHP"
	base_icon_state = "smg9x17mmHP"
	ammo_type = /obj/item/ammo_casing/c9x17mm/hp
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 3,
	)

/obj/item/ammo_box/magazine/mps5/ihdf
	name = "\improper MP-S5 magazine (9x17mm Intelligent Dispersal Foam)"
	icon_state = "smg9x17mmDF"
	base_icon_state = "smg9x17mmDF"
	ammo_type = /obj/item/ammo_casing/c9x17mm/ihdf
	custom_materials = list(
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
	)

/obj/item/ammo_box/magazine/mps5/rubber
	name = "\improper MP-S5 magazine (9x17mm Rubber)"
	icon_state = "smg9x17mmR"
	base_icon_state = "smg9x17mmR"
	ammo_type = /obj/item/ammo_casing/c9x17mm/rubber
	custom_materials = list(
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 6,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
	)

// MP-S5 VIG CASINGS
/obj/item/ammo_casing/c9x17mm
	name = "9x17mm bullet casing"
	desc = "A 9x17mm bullet casing."
	projectile_type = /obj/projectile/bullet/c9x17mm
	caliber = CALIBER_9X17MM

/obj/item/ammo_casing/c9x17mm/ap
	name = "9x17mm armor-piercing bullet casing"
	desc = parent_type::desc + "This one fires an armor-piercing projectile."
	projectile_type = /obj/projectile/bullet/c9x17mm/ap
	custom_materials = AMMO_MATS_AP
	advanced_print_req = TRUE

/obj/item/ammo_casing/c9x17mm/hp
	name = "9x17mm hollow-point bullet casing"
	desc = parent_type::desc + "This one fires a hollow-point projectile. Very lethal to unarmored opponents."
	projectile_type = /obj/projectile/bullet/c9x17mm/hp
	advanced_print_req = TRUE

/obj/item/ammo_casing/c9x17mm/ihdf
	name = "9x17mm IHDF casing"
	desc = parent_type::desc + "This one fires a bullet of 'Intelligent High-Impact Dispersal Foam', which is best compared to a riot-grade foam dart."
	projectile_type = /obj/projectile/bullet/c9x17mm/ihdf
	harmful = FALSE

/obj/item/ammo_casing/c9x17mm/rubber
	name = "9x17mm rubber casing"
	desc = parent_type::desc + "This less than lethal round sure hurts to get shot by, but causes little physical harm."
	projectile_type = /obj/projectile/bullet/c9x17mm/rubber
	harmful = FALSE

/obj/item/ammo_casing/c9x17mm/holo_targetting
	name = "9x17mm Holo-Targetting casing"
	desc = parent_type::desc + "This one fires a bullet of 'Holo-Targetting Smart Munition'."
	projectile_type = /obj/projectile/bullet/c9x17mm/ht
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

/obj/projectile/bullet/c9x17mm/ht
	name = "9x17mm holo-targetting bullet"
	damage = 20
	wound_bonus = -15

/obj/projectile/bullet/c9x17mm/ht/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/designated_target = target
	designated_target.apply_status_effect(/datum/status_effect/designated_target)

// Bubber Related Ammo Override
/obj/item/ammo_casing/c9x17mm/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	if(istype(fired_from, /obj/item/gun/ballistic/automatic/pistol/sec_glock/smart))
		QDEL_NULL(loaded_projectile)
		loaded_projectile = new /obj/projectile/bullet/security/smart(src)
	return ..()

/obj/item/ammo_box/magazine/security
	name = "pistol magazine (9x17mm)"
	ammo_type = /obj/item/ammo_casing/c9x17mm
	caliber = CALIBER_9X17MM
	max_ammo = 16
	multitype = FALSE
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballisticmags.dmi'
	base_icon_state = "hpistol"
	icon_state = "hpistol"

/obj/item/ammo_box/magazine/security/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 2)]"

//In the rare edgecase fuckery bubber decides to add more ammo for the pistol, these exists to make it easier to override or remove
/obj/item/ammo_box/magazine/security/splurt_ap
	name = "pistol magazine (9x17mm Armour Piercing)"
	ammo_type = /obj/item/ammo_casing/c9x17mm/ap
	ammo_band_color = "#f8f8f8"
	ammo_band_icon = "+hpistol_ammo_band"

/obj/item/ammo_box/magazine/security/splurt_hp
	name = "pistol magazine (9x17mm Hollow Point)"
	ammo_type = /obj/item/ammo_casing/c9x17mm/hp
	ammo_band_color = "#df0a14"
	ammo_band_icon = "+hpistol_ammo_band"

/obj/item/ammo_box/magazine/security/splurt_rubber
	name = "pistol magazine (9x17mm Rubber)"
	ammo_type = /obj/item/ammo_casing/c9x17mm/rubber
	ammo_band_color = "#5c70da"
	ammo_band_icon = "+hpistol_ammo_band"

/obj/item/ammo_box/magazine/security/splurt_ihdf
	name = "pistol magazine (9x17mm Intelligent Dispersal Foam)"
	ammo_type = /obj/item/ammo_casing/c9x17mm/ihdf
	ammo_band_color = "#7c50a1"
	ammo_band_icon = "+hpistol_ammo_band"

//Holo targetting, override Rocket Eject
/obj/item/ammo_box/magazine/security/rocket
	name = "pistol magazine (9x17mm Holo Targetting)"
	desc = "Contains specialised holo-targetting round that burns on impact.  With a small charge inside that sparks on ejection, this one has less room for ammo and a lethal velocity to it's ejections."
	ammo_type = /obj/item/ammo_casing/c9x17mm/holo_targetting
	max_ammo = 12
	base_icon_state = "hpistol_ht"
	murphy_eject_sound = 'sound/items/weapons/gun/general/rocket_launch.ogg'
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballisticmags.dmi'
	ammo_band_icon = "+hpistol_ammo_band"
	ammo_band_color = "#aa6300"

// .45 RT

/obj/item/ammo_box/magazine/internal/cylinder/romtech45
	ammo_type = /obj/item/ammo_casing/c45rt
	caliber = CALIBER_45RT
	max_ammo = 6

//speedloader these are only obtainable via illegal tech or traitor uplink
/obj/item/ammo_box/speedloader/c45rt
	name = "speed loader (.45 RT)"
	desc = "Designed to quickly reload six-chamber .45 Romulus Technology revolver."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/misc_ammo.dmi'
	icon_state = "45"
	base_icon_state = "45"
	ammo_type = /obj/item/ammo_casing/c45rt
	max_ammo = 6
	caliber = CALIBER_45RT
	ammo_band_icon = "+45_ammo_band"
	ammo_band_color = null
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3)

/obj/item/ammo_box/speedloader/c45rt/hv
	name = "speed loader (.45 RT High Velocity)"
	ammo_type = /obj/item/ammo_casing/c45rt/hv
	ammo_band_color = COLOR_AMMO_TRUESTRIKE

/obj/item/ammo_box/speedloader/c45rt/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-base"

/obj/item/ammo_box/speedloader/c45rt/update_overlays()
	. = ..()
	if(!LAZYLEN(stored_ammo))
		return
	for(var/inserted_ammo in 1 to stored_ammo.len)
		var/obj/item/ammo_casing/c45rt/boolet = stored_ammo[inserted_ammo]
		. += "45-[boolet::lead_or_nuh]-[inserted_ammo]"

/obj/item/ammo_casing/c45rt
	name = ".45 RT heavy revolver bullet"
	desc = "A rimmed cartridge with a solid steel core, incredible stopping power"
	icon = 'modular_zzplurt/icons/obj/weapons/guns/misc_ammo.dmi'
	icon_state = "magnum"
	caliber = CALIBER_45RT
	projectile_type = /obj/projectile/bullet/c45rt
	var/lead_or_nuh = "lead"

/obj/item/ammo_casing/c45rt/hv
	name = ".45 RT high velocity bullet"
	desc = "A rimmed cartridge with more propellant and a shaped armour piercing cap, less stopping power"
	icon_state = "magnum_hv"
	projectile_type = /obj/projectile/bullet/c45rt/hv
	lead_or_nuh = "nuh"

/obj/projectile/bullet/c45rt
	name = "heavy .45 revolver bullet"
	damage = 30
	wound_bonus = -25
	stamina = 9

/obj/projectile/bullet/c45rt/hv
	name = "high velocity .45 revolver bullet"
	damage = 24
	armour_penetration = 30
	speed = 1.6
	stamina = 0

//WT550 4.6x30mm Override
/obj/projectile/bullet/c46x30mm
	wound_bonus = 0
	armour_penetration = 10

/obj/projectile/bullet/c46x30mm/ap
	armour_penetration = 45

// PRIVATE SECURITY AR AMMO CODE

/obj/item/ammo_box/magazine/c68
	name = "Bulwark rifle magazine (6.8mm Caseless)"
	desc = "A magazine loaded with 6.8mm caseless rounds, specifically used for modern Nanotrasen rifles."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballisticmags.dmi'
	icon_state = "ar68mm"
	base_icon_state = "ar68mm"
	ammo_type = /obj/item/ammo_casing/c68
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	multiple_sprite_use_base = TRUE
	caliber = CALIBER_68MM
	max_ammo = 30
	multitype = FALSE

/obj/item/ammo_casing/c68
	name = "6.8mm caseless round"
	desc = "A high-velocity caseless round used in modern Nanotrasen rifles."
	icon_state = "223-casing"
	caliber = CALIBER_68MM
	projectile_type = /obj/projectile/bullet/c68
	advanced_print_req = TRUE

/obj/item/ammo_casing/c68/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/projectile/bullet/c68
	name = "6.8mm caseless bullet"
	damage = 27
	armour_penetration = 20
	wound_bonus = -15
	wound_falloff_tile = 0

//Rigid Storage and things that we probably should less-shitcode
//Why care for balance in ERP server? Because the average players aren't good
/obj/item/storage/pouch/extended_casing_pouch
	name = "large revolver casing pouch"
	desc = "A large pouch with straps for holding loose revolver casing and nothing else.."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/misc_ammo.dmi'
	icon_state = "reloadpouch"

/obj/item/storage/pouch/extended_casing_pouch/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.max_total_storage = 24
	atom_storage.max_slots = 24
	atom_storage.numerical_stacking = FALSE
	atom_storage.can_hold = typecacheof(list( /obj/item/ammo_casing/c357, /obj/item/ammo_casing/c38, /obj/item/ammo_casing/c45rt))
