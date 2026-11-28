// AN ACTUALLY balanced fucking blueshield gun
/obj/item/gun/energy/e_gun/stun/blueshield/balanced
	name = "NT-EG \"Defender\" Energy Rifle"
	desc = "A decommissioned Nanotrasen security rifle, the NT-EG \"Defender\" is a heavy energy weapon designed for non-lethal defense. \
		Capable of firing standard energy bolts, alongside some stun electrodes, it prioritizes control over lethality. This particular model is \
		a downgraded production variant of the original Tactical Energy Gun, assembled with lower-grade components, resulting in notably slow \
		recharge times and reduced efficiency. While reliable enough for basic use, it struggles to keep pace in prolonged engagements."
	ammo_type = list(/obj/item/ammo_casing/energy/electrode/old, /obj/item/ammo_casing/energy/disabler/hos, /obj/item/ammo_casing/energy/laser/hos/blueshield)
	cell_type = /obj/item/stock_parts/power_store/cell/hos_gun
	recoil = 0.5
	charge_delay = 6
	can_charge = FALSE // This is really one of the only ways it could count as balanced.
	selfcharge = 1

// Literally such a small change it can sit here.
/obj/item/ammo_casing/energy/laser/hos/blueshield
	e_cost = LASER_SHOTS(16, STANDARD_CELL_CHARGE * 1.2) // It's not really pistol-sized.

/obj/item/gun/energy/e_gun/stun/blueshield/balanced/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/gun/energy/e_gun/stun/blueshield/balanced/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/energy/e_gun/stun/blueshield/balanced/examine_more(mob/user)
	. = ..()

	. += "Originally issued to Emergency Response Teams and high-risk security units, the Defender was intended as a cost-effective alternative \
	to the more advanced tactical models. As newer, faster-charging platforms entered service, the Defender series was gradually phased out and \
	relegated to surplus or low-priority assignments.\
	<br>\
	<br>\
	Though no longer standard issue, the Defender still sees occasional use in backwater facilities, underfunded departments, or in the hands of \
	blueshield personnel, whoom can't argue about equipment. Outdated and sluggish, it remains a symbol of Nanotrasen's pragmatic approach, when \
	top-tier gear isn't available, something \"good enough\" will have to do."

	return .

/obj/item/gun/energy/e_gun/blueshield/balanced
	name = "NT-SR4 \"Aegis\" Energy Revolver"
	desc = "A Nanotrasen-issued energy revolver designed for Blueshield personnel. Uses a rotating capacitor system that slowly self-recharges \
		between shots, ensuring consistent readiness without external power. Heavier than standard sidearms, with a reinforced frame suitable for \
		close-quarters use. Cleanly marked and built to corporate standards."
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/hos/blueshield/revolver, /obj/item/ammo_casing/energy/laser/hellfire/blueshield)
	recoil = 0.4
	charge_delay = 5
	force = 10 // Let's not smash sulls in. What are sulls?
	throwforce = 5

/obj/item/ammo_casing/energy/disabler/hos/blueshield/revolver
	e_cost = LASER_SHOTS(12, STANDARD_CELL_CHARGE * 1.2)

/obj/item/ammo_casing/energy/laser/hellfire/blueshield
	e_cost = LASER_SHOTS(6, STANDARD_CELL_CHARGE * 1.2)

/obj/item/gun/energy/e_gun/blueshield/balanced/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/gun/energy/e_gun/blueshield/balanced/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/energy/e_gun/blueshield/balanced/examine_more(mob/user)
	. = ..()

	. += "The NT-SR4 \"Aegis\" was developed by Nanotrasen to provide Blueshields with a reliable, self-sufficient sidearm for executive \
		protection duties. Its revolver-style capacitor system reduces dependency on charging infrastructure while maintaining predictable performance.\
		<br>\
		<br>\
		Issued exclusively to authorized protection personnel, the Aegis reflects Nanotrasen's priority on control, reliability, and the uninterrupted \
		safety of command staff."

	return .

/obj/item/gun/energy/e_gun/asterion
	name = "\improper NTX-9 \"Asterion\" Executive Energy Pistol"
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
	recoil = 0.4
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
/obj/item/gun/energy/modular_laser_rifle/carbine/recharging/ert
	cell_type = /obj/item/stock_parts/power_store/cell/upgraded
	charge_sections = 3
	expanded_examine_text = "The Hoshi carbine is the latest line of man-portable Marsian weapons platforms from \
		Cybersun Industries. Like her older sister weapon, the Hyeseong rifle, CI used funding aid provided by TerraGov \
		to develop a portable weapon fueled by a proprietary generator rumored to be fueled by superstable plasma. A \
		lithe and mobile weapon, the Hoshi stars in close-quarters battle, trickshots, and area-of-effect blasts; though \
		ineffective at ranged combat. Her onboard machine intelligence, at first devised to support the operator and \
		manage the internal reactor, was originally shipped with a more energetic personality-- since influenced by 'negligence' \
		from users in wiping the intelligence's memory before resale or transport."

/obj/item/gun/energy/modular_laser_rifle/ert
	cell_type = /obj/item/stock_parts/power_store/cell/upgraded/plus
