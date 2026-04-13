/obj/item/gun/energy/e_gun/asterion
	name = "\improper NTX-9 \"Asterion\" Executive Energy Sidearm"
	desc = "A refined but cost-conscious alternative to the Captain's Antique, the NTX-9 \"Asterion\" is an executive-grade \
		energy pistol designed for prestige without excess. It features a dual-mode emitter for disable and lethal discharges, \
		housed in a streamlined frame with subtle gold accents and a polished wooden grip. While lacking the handcrafted complexity of \
		its inspiration, the Asterion maintains dependable performance and a distinctly authoritative presence. As far as you know though, \
		it's basically the same as a standard-issue energy gun, aside from the compact frame. It would've been too expensive to afford to \
		distribute hellfire into each and every mass-produced model of this line of weaponry."
	icon = 'modular_zzplurt/icons/obj/guns/ntc_gun.dmi'
	icon_state = "asterion"
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_righthand.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/asterion, /obj/item/ammo_casing/energy/lasergun/asterion)
	ammo_x_offset = 2
	recoil = 0.3
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gun/energy/e_gun/asterion/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/gun/energy/e_gun/asterion/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/energy/e_gun/asterion/examine_more(mob/user)
	. = ..()

	. += "The NTX-9 \"Asterion\" was introduced after internal demand grew for a weapon that captured the prestige of the Captain's Antique \
		without the cost or rarity. Nanotrasen's solution was to replicate the aesthetic and functionality in a more scalable \
		design, using modern manufacturing instead of artisanal methods. Though some captains quietly mock it as a \"boardroom replica\", \
		the Asterion has become a common sight among executives, valued not just as a weapon, but as a symbol that authority can be \
		standardized, packaged, and issued on demand."

	return .

/obj/item/ammo_casing/energy/disabler/asterion
	e_cost = LASER_SHOTS(16, STANDARD_CELL_CHARGE)

/obj/item/ammo_casing/energy/lasergun/asterion
	e_cost = LASER_SHOTS(12, STANDARD_CELL_CHARGE)

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
