// Sovereign (.460) //

/obj/item/ammo_box/magazine/sovereign
	name = "sovereign pistol magazine (.460 Ceres)"
	desc = "A .460 Ceres handgun magazine, suitable for the NTX-460E Pistol."
	icon = 'modular_zzplurt/icons/obj/guns/ammo.dmi'
	icon_state = "sovereign_mag-12"
	base_icon_state = "sovereign_mag"
	multiple_sprites = AMMO_BOX_PER_BULLET
	multiple_sprite_use_base = TRUE
	caliber = CALIBER_45
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 8

/obj/item/ammo_box/magazine/directive
	name = "directive pistol magazine (9x19mm)"
	desc = "A 9x19mm handgun magazine, suitable for the NTX-919E Pistol."
	icon = 'modular_zzplurt/icons/obj/guns/ammo.dmi'
	base_icon_state = "directive_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	multiple_sprite_use_base = TRUE
	caliber = CALIBER_9X19MM
	ammo_type = /obj/item/ammo_casing/c9x19mm
	max_ammo = 12

/obj/item/ammo_casing/c9x19mm
	name = "9x19mm casing"
	desc = "A 9x19mm bullet casing."
	caliber = CALIBER_9X19MM
	projectile_type = /obj/projectile/bullet/c9x19mm
	newtonian_force = 0.80

/obj/projectile/bullet/c9x19mm
	name = "9x19mm bullet"
	damage = 20
	embed_type = /datum/embedding/bullet/c9x19mm

/datum/embedding/bullet/c9x19mm
	embed_chance = 10
	fall_chance = 4
	jostle_chance = 3
	ignore_throwspeed_threshold = TRUE
	pain_stam_pct = 0.2
	pain_mult = 4
	jostle_pain_mult = 4
	rip_time = 1 SECONDS
