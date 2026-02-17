
/datum/supply_pack/security/armory/sec_glock_ammo_fancy
	name = "'Murphy' Service Pistol Specialized Ammo Crate"
	desc = "Contains 5 magazines with various types of rounds for the 'Murphy' service pistol."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/obj/item/ammo_box/magazine/security/true_strike = 1,
		/obj/item/ammo_box/magazine/security/dumdum = 1,
		/obj/item/ammo_box/magazine/security/hotshot = 1,
		/obj/item/ammo_box/magazine/security/iceblox = 1,
		/obj/item/ammo_box/magazine/security/flare = 1,
	)
	crate_name = "'Murphy' service pistol specialized ammo crate"
	access_view = ACCESS_WEAPONS
