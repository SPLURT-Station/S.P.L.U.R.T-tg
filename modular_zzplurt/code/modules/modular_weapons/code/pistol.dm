/obj/item/gun/ballistic/automatic/pistol/m1911/gold
	name = "Gold-Trimmed M1911"
	desc = "A classic .460 ceres handgun with a small magazine capacity. Now much more expensive for those antique collectors!"
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/romulus_technology/pistol.dmi'
	icon_state = "m1911"

/obj/item/gun/ballistic/automatic/pistol/m1911/gold/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/gun/ballistic/automatic/pistol/m45a5
	name = "M45A5 \"Goliath\" Heavy Service Pistol"
	desc = "A large-frame, semi-automatic sidearm chambered in .460 Rowland, the M45A5 \"Goliath\" is built for sheer stopping power. \
		Its reinforced construction and high-pressure recoil system give it a profile reminiscent of old Desert Eagle-pattern pistols, delivering \
		immense force at the cost of heavy recoil and limited practicality. Reliable and brutally effective, it excels at close-range to mid-range \
		engagements where power matters more than finesse."
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/romulus_technology/pistol.dmi'
	icon_state = "m45a5"
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/m45a5
	can_suppress = FALSE
	special_mags = TRUE
	recoil = 2.5
	fire_delay = 1 SECONDS
	force = 10
	fire_sound = 'modular_skyrat/modules/modular_weapons/sounds/pistol_heavy.ogg'

/obj/item/gun/ballistic/automatic/pistol/m45a5/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_ROMTECH)

/obj/item/gun/ballistic/automatic/pistol/m45a5/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/automatic/pistol/m45a5/examine_more(mob/user)
	. = ..()

	. += "Originally designed by Romulus Technology during the early stages of the NRI-Sol Border War, the M45A5 was born out of necessity \
		rather than ambition. Trade embargoes and tightening restrictions left the Romulus Federation cut off from traditional weapons suppliers, \
		forcing rapid domestic development. \
		<br>\
		<br>\
		Drawing from an advanced Sol-based design, the pistol was pushed into production with little time for \
		refinement—simple in appearance, but devastatingly effective in practice. Despite its unassuming profile, the weapon quickly became more than \
		just a tool of war. As the newly formed Romulus National Army adopted it en masse, the M45A5 grew into a symbol of resistance and self-reliance. \
		Older NRI-pattern weapons, once standard issue, came to represent an era of foreign dependence and political pressure—one the Federation was \
		eager to leave behind. \
		<br>\
		<br>\
		To those who carried it, the Goliath was never just a sidearm. It was a reminder of hardship, of independence hard-won, \
		and of a future no longer dictated by outside powers. Weapons cannot bring back what was lost—but in the hands of the Romulus people, this one \
		ensured there was still something left to protect."

	return .

/obj/item/gun/ballistic/automatic/pistol/viceroy
	name = "\improper NTX-12 \"Viceroy\" Executive Pistol"
	desc = "A premium sidearm issued exclusively to high-ranking Nanotrasen executives, \
		the NTX-12 \"Viceroy\" is designed for both personal defense and quiet authority, \
		the Viceroy combines compact ergonomics with reinforced internal systems capable of \
		handling its unusually powerful round. Chambered in 9x25mm Mk.12. Its angular slide \
		and dense barrel assembly reflect its purpose: controlled, decisive force in the hands \
		of those who command it. A polished polymer grip with embedded smart-sensor nodes ensures \
		user-specific recoil compensation, making it both secure and effortless to wield."
	icon = 'modular_zzplurt/icons/obj/guns/48x32_nt_guns.dmi'
	icon_state = "viceroy"
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/viceroy
	can_suppress = FALSE
	recoil = 0.25
	fire_delay = 0.15 // fuck if I know if this changes anything.
	fire_sound = 'modular_skyrat/modules/modular_weapons/sounds/pistol_light.ogg'
	rack_sound = 'sound/items/weapons/gun/pistol/rack.ogg'
	lock_back_sound = 'sound/items/weapons/gun/pistol/slide_lock.ogg'
	bolt_drop_sound = 'sound/items/weapons/gun/pistol/slide_drop.ogg'

/obj/item/gun/ballistic/automatic/pistol/viceroy/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/gun/ballistic/automatic/pistol/viceroy/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/automatic/pistol/viceroy/examine_more(mob/user)
	. = ..()

	. += "The NTX-12 \"Viceroy\" was commissioned following a series of high-profile security \
	breaches targeting Nanotrasen's upper management aboard deep-space installations. Standard-issue \
	sidearms were deemed insufficient—not due to lack of lethality, but due to a failure in presence. \
	Executives needed something that was not only effective, but symbolic. And then the Viceroy was created."

	return .
