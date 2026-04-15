/obj/item/gun/ballistic/automatic/bulwark
	name = "\improper NTS-24 \"Bulwark\" Assault Rifle"
	desc = "A rare command-grade rifle issued only to Nanotrasen Private Security Captains, seldom seen in the field. \
		Its deployment signals immediate escalation beyond routine operations. Featuring a polished wooden grip and a large \
		Nanotrasen logo emblazoned on the stock, the Bulwark blends legacy styling with modern design. More than a weapon, \
		it's a clear mark of authority. Chambered in 6.8mm Caseless."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballistic_64x32.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_righthand.dmi'
	icon_state = "bulwark"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "bulwark"
	accepted_magazine_type = /obj/item/ammo_box/magazine/c68
	fire_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_shot.ogg'
	rack_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_rack.ogg'
	bolt_drop_sound = 'sound/items/weapons/gun/general/bolt_drop.ogg'
	eject_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_eject.ogg'
	eject_empty_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_eject.ogg'
	load_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_insert.ogg'
	burst_delay = 2
	can_suppress = TRUE
	empty_indicator = TRUE
	burst_size = 1
	actions_types = list()
	mag_display = TRUE

/obj/item/gun/ballistic/automatic/bulwark/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.22 SECONDS)

/obj/item/gun/ballistic/automatic/bulwark/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/gun/ballistic/automatic/bulwark/examine_more(mob/user)
	. = ..()

	. += "Nanotrasen deliberately modeled the Bulwark after legacy ballistic rifles like the M16 platform, \
	citing \"combat familiarity'\" as a key factor in high-stress situations. By preserving a centuries-proven \
	layout while integrating modern materials and smart systems, they ensured that any trained officer could \
	instinctively operate it. Unlike experimental energy weapons, the Bulwark represents reliability over \
	innovation, a weapon that works the same way every time, whether planetside or in vacuum. For Private \
	Security Captains, it serves as both a practical tool and a psychological anchor: something familiar in \
	environments where very little is."

	return .

/obj/item/gun/ballistic/automatic/bulwark/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 28, \
		overlay_y = 12)
