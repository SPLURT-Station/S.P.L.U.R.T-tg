/*
*	S.M.A.R.T. RIFLE
*/

/obj/item/gun/ballistic/automatic/smartrifle
	name = "\improper OP-15 'S.M.A.R.T.' rifle"
	desc = "Suppressive Manual Action Reciprocating Taser rifle. A modified version of an Armadyne heavy machine gun fitted to fire miniature shock-bolts."

	icon = 'modular_zzplurt/icons/obj/weapons/guns/smartrifle.dmi'
	icon_state = "smartrifle"

	righthand_file = 'modular_zzplurt/icons/obj/weapons/guns/inhands/righthand40x32.dmi'
	lefthand_file = 'modular_zzplurt/icons/obj/weapons/guns/inhands/lefthand40x32.dmi'
	inhand_icon_state = "smartrifle_worn"

	worn_icon = 'modular_zzplurt/icons/obj/weapons/guns/smartrifle.dmi'
	worn_icon_state = "smartrifle_worn"

	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK

	accepted_magazine_type = /obj/item/ammo_box/magazine/smartrifle
	actions_types = null
	can_suppress = FALSE
	mag_display = TRUE
	mag_display_ammo = TRUE
	empty_alarm = TRUE
	tac_reloads = FALSE
	bolt_type = BOLT_TYPE_STANDARD
	semi_auto = FALSE

	fire_sound = 'modular_zzplurt/code/modules/smartrifle/sound/smartrifle_fire.ogg'
	rack_sound = 'modular_zzplurt/code/modules/smartrifle/sound/smartrifle_cock.ogg'
	lock_back_sound = 'modular_zzplurt/code/modules/smartrifle/sound/smartrifle_open.ogg'
	bolt_drop_sound = 'modular_zzplurt/code/modules/smartrifle/sound/smartrifle_cock.ogg'
	load_sound = 'modular_zzplurt/code/modules/smartrifle/sound/smartrifle_magin.ogg'
	load_empty_sound = 'modular_zzplurt/code/modules/smartrifle/sound/smartrifle_magin.ogg'
	eject_sound = 'modular_zzplurt/code/modules/smartrifle/sound/smartrifle_magout.ogg'
	load_empty_sound = 'modular_zzplurt/code/modules/smartrifle/sound/smartrifle_magout.ogg'

	var/recharge_time = 4 SECONDS
	var/recharging = FALSE

/obj/item/gun/ballistic/automatic/smartrifle/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_REMOVED)

/obj/item/gun/ballistic/automatic/smartrifle/process_chamber()
	. = ..()
	recharging = TRUE
	addtimer(CALLBACK(src, PROC_REF(recharge)), recharge_time)

/obj/item/gun/ballistic/automatic/smartrifle/proc/recharge()
	recharging = FALSE
	playsound(src, 'sound/items/weapons/kinetic_reload.ogg', 60, 1)

/obj/item/gun/ballistic/automatic/smartrifle/can_shoot()
	. = ..()
	if(recharging)
		return FALSE

/obj/item/gun/ballistic/automatic/smartrifle/update_icon()
	. = ..()
	if(!magazine)
		icon_state = "smartrifle_open"
	else
		icon_state = "smartrifle_closed"

/obj/item/ammo_box/magazine/smartrifle
	name = "\improper SMART-Rifle magazine"
	icon = 'modular_zzplurt/icons/obj/weapons/guns/smartmag.dmi'
	icon_state = "smartrifle"
	ammo_type = /obj/item/ammo_casing/smartrifle
	caliber = "smartrifle"
	max_ammo = 5
	multiple_sprites = AMMO_BOX_PER_BULLET

/obj/item/gun/ballistic/automatic/smartrifle/nomag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/smartrifle/scoped
	name = "\improper OP-10 'S.M.A.R.T.' Rifle";
	desc = "Suppressive Manual Action Reciprocating Taser rifle. A gauss rifle fitted to fire miniature shock-bolts. Looks like this one is pretty heavy, but it has a scope on it.";
	recharge_time = 6 SECONDS;
	recoil = 3;
	slowdown = 0.25;

/obj/item/gun/ballistic/automatic/smartrifle/scoped/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.5)


/obj/structure/closet/secure_closet/smartrifle
	name = "smartrifle locker"
	req_access = list(ACCESS_ARMORY)
	icon_state = "shotguncase"

/obj/structure/closet/secure_closet/smartrifle/PopulateContents()
	. = ..()
	new /obj/item/gun/ballistic/automatic/smartrifle/nomag(src)
	new /obj/item/ammo_box/magazine/smartrifle(src)
	new /obj/item/ammo_box/magazine/smartrifle(src)
	new /obj/item/ammo_box/magazine/smartrifle(src)


//Cargo order pack - 2400 credits

/datum/supply_pack/security/armory/smartrifle
	name = "OP-15 'S.M.A.R.T.' Rifle Crate"
	desc = "Contains the OP-15 Suppressive Manual Action Reciprocating Taser Rifle, as well as three spare magazines."
	cost = CARGO_CRATE_VALUE * 12
	contains = list(/obj/item/gun/ballistic/automatic/smartrifle/nomag = 1,
		/obj/item/ammo_box/magazine/smartrifle = 3,
	)
	crate_name = "OP-15 SMART-Rifle Crate"
