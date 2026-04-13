/obj/item/gun/ballistic/automatic/pistol/directive
	name = "\improper NTX-925E \"Directive\" Executive Pistol"
	desc = "The NTX-925E \"Directive\" is a refined, high-velocity sidearm tailored for \
		precision and reliability. Standard-issue for executive officers operating outside secure \
		installations, it balances manageable recoil with superior penetration and accuracy, making \
		it ideal for controlled engagements, chambered in 9x25mm."
	icon = 'modular_zzplurt/icons/obj/guns/48x32_nt_guns.dmi'
	icon_state = "directive"
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/directive
	can_suppress = FALSE
	recoil = 0.3
	fire_sound = 'modular_skyrat/modules/modular_weapons/sounds/pistol_light.ogg'
	rack_sound = 'sound/items/weapons/gun/pistol/rack.ogg'
	lock_back_sound = 'sound/items/weapons/gun/pistol/slide_lock.ogg'
	bolt_drop_sound = 'sound/items/weapons/gun/pistol/slide_drop.ogg'

/obj/item/gun/ballistic/automatic/pistol/directive/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/gun/ballistic/automatic/pistol/directive/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/automatic/pistol/directive/examine_more(mob/user)
	. = ..()

	. += "The Directive was introduced as a practical counterpart to heavier executive weapons, \
		emphasizing efficiency and control. It is commonly favored by officers who prioritize situational \
		awareness and measured response over brute force. Its modular design allows integration with \
		corporate-standard smart targeting systems and biometric locks."

	return .

/obj/item/storage/toolbox/guncase/skyrat/pistol/directive
	name = "\improper NTX-925E \"Directive\" Executive Pistol case"

/obj/item/storage/toolbox/guncase/skyrat/pistol/directive/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/directive(src)
	new /obj/item/ammo_box/magazine/directive(src)
	new /obj/item/ammo_box/magazine/directive(src)
	new /obj/item/ammo_box/magazine/directive(src)
