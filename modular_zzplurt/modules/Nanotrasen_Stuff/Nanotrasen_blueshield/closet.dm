/obj/structure/closet/secure_closet/blueshield
	name = "blueshield's locker"
	icon_state = "bs"
	icon = 'modular_skyrat/master_files/icons/obj/closet.dmi'
	req_access = list(ACCESS_CENT_OFFICER)

/obj/structure/closet/secure_closet/blueshield/New()
	..()
	new /obj/item/storage/briefcase/secure(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/storage/medkit/tactical/blueshield(src)
	new /obj/item/gun/energy/e_gun(src)
	new /obj/item/storage/bag/garment/blueshield(src)
	new /obj/item/mod/control/pre_equipped/blueshield(src)
	new /obj/item/storage/box/glasseskit(src)
	new /obj/item/storage/medkit/brute(src)
	new /obj/item/armorkit/blueshield(src)
	new /obj/item/armorkit/helmet/blueshield(src)
