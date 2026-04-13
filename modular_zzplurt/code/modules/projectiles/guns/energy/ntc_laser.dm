/obj/item/gun/energy/e_gun/asterion
	name = "\improper NT 'Asterion' Personal Defense E-Pistol"
	desc = "A unique, and compact energy pistol with a sleek design referencing the more famous Antique laser gun, all you're missing is the hellfire lasers and cool engravings! It's similar frame to the Antique makes it easier to carry. One of the alternate models that was mass-produced, usually administered to Nanotrasen Executives. Proves to be very efficient with two settings: disable and kill."
	icon = 'modular_zzplurt/icons/obj/guns/ntc_gun.dmi'
	icon_state = "asterion"
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_righthand.dmi'
	ammo_x_offset = 2
	recoil = 0.4
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gun/energy/e_gun/asterion/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/gun/energy/pulse/pistol/m1911
	icon = 'modular_zzplurt/icons/obj/guns/48x32_nt_guns.dmi'

/obj/item/gun/energy/pulse/pistol/m1911/fake_ntc // Basically a glorified smoothbore disabler, it's a joke and that's all that is.
	name = "\improper M1911-D"
	desc = "A compact pulse core in a classic handgun frame for Nanotrasen officers. It's not the size of the gun, it's the size of the hole it puts through people.. Wait, why does it have a crank?"
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/smoothbore)
	cell_type = /obj/item/stock_parts/power_store/cell
	spread = 22.5

/obj/item/gun/energy/pulse/pistol/m1911/fake_ntc/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/crank_recharge, \
		charging_cell = get_cell(), \
		charge_amount = STANDARD_CELL_CHARGE, \
		cooldown_time = 2 SECONDS, \
		charge_sound = 'sound/items/weapons/laser_crank.ogg', \
		charge_sound_cooldown_time = 1.8 SECONDS, \
		charge_move = IGNORE_USER_LOC_CHANGE, \
	)
