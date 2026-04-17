// AN ACTUALLY balanced fucking blueshield gun
/obj/item/gun/energy/e_gun/stun/blueshield/balanced
	name = "NT-EG \"Defender\" Energy Rifle"
	desc = "A decommissioned Nanotrasen security rifle, the NT-EG \"Defender\" is a heavy energy weapon designed for non-lethal enforcement. \
		Capable of firing standard energy bolts, alongside some stun electrodes, it prioritizes control over lethality. This particular model is \
		a downgraded production variant of the original Tactical Energy Gun, assembled with lower-grade components—resulting in notably slow \
		recharge times and reduced efficiency. While reliable enough for basic use, it struggles to keep pace in prolonged engagements."
	ammo_type = list(/obj/item/ammo_casing/energy/electrode/blueshield, /obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser)
	charge_delay = 14
	can_charge = FALSE // This is really one of the only ways it could count as balanced.
	selfcharge = 1

// Literally such a small change it can sit here.
/obj/item/ammo_casing/energy/electrode/blueshield
	e_cost = LASER_SHOTS(6, STANDARD_CELL_CHARGE)

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
