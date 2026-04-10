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
	name = "directive pistol magazine (9x25mm)"
	desc = "A 9x25mm handgun magazine, suitable for the NTX-925E Pistol."
	icon = 'modular_zzplurt/icons/obj/guns/ammo.dmi'
	base_icon_state = "directive_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	multiple_sprite_use_base = TRUE
	caliber = CALIBER_9MM
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 12
