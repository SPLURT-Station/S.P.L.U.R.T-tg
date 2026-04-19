// AN ACTUALLY balanced fucking blueshield gun
/obj/item/gun/energy/e_gun/stun/blueshield/balanced
	name = "NT-EG \"Defender\" Energy Rifle"
	desc = "A decommissioned Nanotrasen security rifle, the NT-EG \"Defender\" is a heavy energy weapon designed for non-lethal enforcement. \
		Capable of firing standard energy bolts, alongside some stun electrodes, it prioritizes control over lethality. This particular model is \
		a downgraded production variant of the original Tactical Energy Gun, assembled with lower-grade components—resulting in notably slow \
		recharge times and reduced efficiency. While reliable enough for basic use, it struggles to keep pace in prolonged engagements."
	ammo_type = list(/obj/item/ammo_casing/energy/electrode/sec, /obj/item/ammo_casing/energy/disabler/hos, /obj/item/ammo_casing/energy/laser/hos/blueshield)
	cell_type = /obj/item/stock_parts/power_store/cell/hos_gun
	charge_delay = 11
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
	top-tier gear isn't available, something “good enough” will have to do."

	return .

/obj/item/gun/energy/e_gun/blueshield/balanced
	name = "NT-SR4 \"Aegis\" Energy Revolver"
	desc = "A Nanotrasen-issued energy revolver designed for Blueshield personnel. Uses a rotating capacitor system that slowly self-recharges \
		between shots, ensuring consistent readiness without external power. Heavier than standard sidearms, with a reinforced frame suitable for \
		close-quarters use. Cleanly marked and built to corporate standards."
	charge_delay = 6

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
