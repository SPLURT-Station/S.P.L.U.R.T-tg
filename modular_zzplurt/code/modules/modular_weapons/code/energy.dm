/obj/item/gun/energy/laser/assault/security
	name = "\improper Type 5B assault laser rifle"
	desc = "The Type 5 Heat Delivery System Assault Variant B, developed by Nanotrasen. The workhorse of Nanotrasen's security forces and paramilitary organizations.  Albeit at a slightly slower firerate, it can fires in burst and features a taser mode"
	icon = 'modular_zzplurt/icons/obj/weapons/guns/wide_guns.dmi'
	icon_state = "assault_laser"
	inhand_icon_state = "assault_laser"
	worn_icon_state = "assault_laser"
	fire_delay = 3
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun/assault, /obj/item/ammo_casing/energy/electrode/weaker)

	fire_sound = 'sound/items/weapons/taser3.ogg'

/obj/item/ammo_casing/energy/electrode/weaker
	projectile_type = /obj/projectile/energy/electrode/weaker
	e_cost = LASER_SHOTS(10, STANDARD_CELL_CHARGE)

/obj/projectile/energy/electrode/weaker
	tase_stamina = 12.5
	speed = 1.65
