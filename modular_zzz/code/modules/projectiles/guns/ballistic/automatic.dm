/obj/item/gun/ballistic/automatic/ar/ak12
	name = "\improper AK-12 rifle"
	desc = "Простая в использовании Автоматическая Винтовка. Её придумали ещё столетия назад, а популярна она и по сей день."
	icon = 'modular_zzz/icons/obj/weapons/ballistic.dmi'
	icon_state = "ak12"
	inhand_icon_state = "ak12"
	lefthand_file = 'modular_zzz/icons/mob/inhands/weapons/lefthand.dmi'
	righthand_file = 'modular_zzz/icons/mob/inhands/weapons/righthand.dmi'
	accepted_magazine_type = /obj/item/ammo_box/magazine/ak12
	fire_sound = 'modular_zzz/sounds/ak12_fire.ogg'

/obj/item/gun/ballistic/automatic/ar/ak12/pink
	name = "\improper Pink AK-12 rifle"
	icon_state = "akr12"

/obj/item/gun/ballistic/automatic/ar/ak12/pink/fire_sounds()
	fire_sound = pick('modular_zzplurt/sound/interactions/moan_m0.ogg', 'modular_zzplurt/sound/interactions/moan_m4.ogg', \
	'modular_zzplurt/sound/interactions/moan_m5.ogg', 'modular_zzplurt/sound/interactions/moan_m6.ogg', \
	'modular_zzplurt/sound/interactions/moan_m7.ogg', 'modular_zzplurt/sound/interactions/moan_m12.ogg', \
	'modular_zzplurt/sound/interactions/moan_f2.ogg', 'modular_zzz/sounds/ak12_fire.ogg', 'modular_zzz/sounds/ak12_fire.ogg', \
	'modular_zzz/sounds/ak12_fire.ogg', 'modular_zzz/sounds/ak12_fire.ogg', 'modular_zzz/sounds/ak12_fire.ogg', \
	'modular_zzz/sounds/ak12_fire.ogg', 'modular_zzz/sounds/ak12_fire.ogg', 'modular_zzz/sounds/ak12_fire.ogg', \
	'modular_zzz/sounds/ak12_fire.ogg', 'modular_zzz/sounds/ak12_fire.ogg', 'modular_zzz/sounds/ak12_fire.ogg', \
	'modular_zzz/sounds/ak12_fire.ogg', 'modular_zzz/sounds/ak12_fire.ogg', 'modular_zzz/sounds/ak12_fire.ogg')
	. = ..()

/obj/item/gun/ballistic/automatic/ar/ak12/pink/update_icon_state()
	. = ..()
	if(magazine)
		icon_state = "akr12"
	else
		icon_state = "akr12_e"

/obj/item/ammo_box/magazine/ak12
	name = "\improper AK-12 magazine"
	desc = "Магазин, способный держать 30 патронов калибра 5.56мм."
	icon = 'modular_zzz/icons/obj/weapons/ammo.dmi'
	icon_state = "ak12_mag"
	ammo_type = /obj/item/ammo_casing/a556
	caliber = "a556"
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/ak12/ap
	name = "\improper AK-12 armor-piercing magazine"
	desc = "Магазин, способный держать 30 супер-бронепробивающих патронов калибра 5.56мм."
	ammo_type = /obj/item/ammo_casing/a556/ap

/obj/item/ammo_box/magazine/ak12/hp
	name = "\improper AK-12 hollow-point magazine"
	desc = "Магазин, способный держать 30 разрывных патронов калибра 5.56мм."
	ammo_type = /obj/item/ammo_casing/a556/hp

/obj/item/ammo_casing/a556
	name = "5.56mm bullet casing"
	desc = "A 5.56mm bullet casing."
	caliber = "a556"
	projectile_type = /obj/projectile/bullet/a556

/obj/item/ammo_casing/a556/ap
	name = "5.56mm armor-piercing bullet casing"
	desc = "A 5.56mm armor-piercing bullet casing."
	projectile_type = /obj/projectile/bullet/a556_ap

/obj/item/ammo_casing/a556/hp
	name = "5.56mm hollow-point bullet casing"
	desc = "A 5.56mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/a556_hp

/obj/projectile/bullet/a556
	name = "5.56mm bullet"
	damage = 35
	armour_penetration = 30
	wound_bonus = -40

/obj/projectile/bullet/a556_hp
	name = "5.56mm hollow-point bullet"
	damage = 70
	wound_bonus = 10
	weak_against_armour = TRUE

/obj/projectile/bullet/a556_ap
	name = "5.56mm armor-piercing bullet"
	damage = 30
	armour_penetration = 100
	projectile_phasing =  PASSTABLE | PASSGLASS | PASSGRILLE | PASSCLOSEDTURF | PASSMACHINE | PASSSTRUCTURE | PASSDOORS

/obj/item/storage/box/ak12_ammo
	name = "box with ammo"
	icon_state = "secbox"

/obj/item/storage/box/ak12_ammo/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ak12 = 3,
		/obj/item/ammo_box/magazine/ak12/ap = 2,
		/obj/item/ammo_box/magazine/ak12/hp = 2,
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/ak12_ammo/pink
	name = "box with ammo"
	icon_state = "secbox"

/obj/item/storage/box/ak12_ammo/pink/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ak12/pink = 3,
		/obj/item/ammo_box/magazine/ak12/ap/pink = 2,
		/obj/item/ammo_box/magazine/ak12/hp/pink = 2,
		)
	generate_items_inside(items_inside,src)

/obj/item/ammo_box/magazine/ak12/pink
	name = "\improper Pink AK-12 magazine"
	icon_state = "akr12_mag"

/obj/item/ammo_box/magazine/ak12/ap/pink
	name = "\improper Pink AK-12 armor-piercing magazine"
	icon_state = "akr12_mag"

/obj/item/ammo_box/magazine/ak12/hp/pink
	name = "\improper Pink AK-12 hollow-point magazine"
	icon_state = "akr12_mag"
