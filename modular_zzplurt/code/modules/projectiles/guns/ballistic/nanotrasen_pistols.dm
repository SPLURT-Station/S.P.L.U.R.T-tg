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

/obj/item/storage/toolbox/guncase/skyrat/pistol/viceroy
	name = "\improper NTX-12 \"Viceroy\" Executive Pistol case"

/obj/item/storage/toolbox/guncase/skyrat/pistol/viceroy/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/viceroy(src)
	new /obj/item/ammo_box/magazine/viceroy(src)
	new /obj/item/ammo_box/magazine/viceroy(src)
	new /obj/item/ammo_box/magazine/viceroy(src)
