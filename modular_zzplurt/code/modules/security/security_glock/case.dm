/obj/item/storage/toolbox/guncase/skyrat/pistol/sec_glock
	name = "\improper 'Ladon' handgun case"
	icon = 'modular_zzplurt/icons/obj/weapons/sec_haul/gun_case.dmi'
	icon_state = "secsidearm"

/obj/item/storage/toolbox/guncase/skyrat/pistol/hos_glock
	name = "\improper 'Ladon' handgun case"
	icon = 'modular_zzplurt/icons/obj/weapons/sec_haul/gun_case.dmi'
	icon_state = "secsidearm"

/obj/item/storage/toolbox/guncase/skyrat/pistol/sec_glock/PopulateContents()
	. = ..()
	new /obj/item/ammo_box/magazine/security(src)

/obj/item/storage/toolbox/guncase/skyrat/pistol/hos_glock/PopulateContents()
	. = ..()
	new /obj/item/ammo_box/magazine/security(src)

/* Archived incase we want to revisit this in the future because I don't think I can do it justice in this pr
// NOTICE: ADD ANY NEW ITEM THAT ARE NORMALLY SPAWNED IN THE LOCKER, THIS COMPLETELY OVERRIDE THE CLOSET SPAWN!
/obj/structure/closet/secure_closet/security/sec/PopulateContents()
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/clothing/suit/armor/vest/alt/sec(src)
	new /obj/item/clothing/head/helmet/sec(src)
	new /obj/item/radio/headset/headset_sec(src)
	new /obj/item/radio/headset/headset_sec/alt(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/clothing/gloves/tackler/security(src)
	new /obj/item/splurtweaponspawner_case(src)
*/

/obj/structure/closet/secure_closet/warden/PopulateContents()
	. = ..()
	new /obj/item/splurtweaponspawner_case(src)
