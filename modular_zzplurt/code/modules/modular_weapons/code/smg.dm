/obj/item/gun/ballistic/automatic/mps5
	name = "\improper MP-S5 VIG"
	desc = "A Nanotrasen security submachine gun, the MP-S5 was manufactured by Nanotrasen specifically to be \
		a rugged workhorse for station security. Though long since surpassed by other manufacturers, the VIG \
		remains a reliable standby in auxiliary armories and is still favored by veteran officers who trust \
		its no-nonsense performance. Chambered in 9x17mm."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "mp5"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "arg"
	accepted_magazine_type = /obj/item/ammo_box/magazine/mps5
	fire_sound = 'modular_zzplurt/sound/items/weapons/gun/mp5_shot.ogg'
	burst_delay = 2
	can_suppress = FALSE
	burst_size = 1
	actions_types = list()
	mag_display = TRUE

/obj/item/gun/ballistic/automatic/mps5/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.18 SECONDS)

/obj/item/gun/ballistic/automatic/mps5/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)
