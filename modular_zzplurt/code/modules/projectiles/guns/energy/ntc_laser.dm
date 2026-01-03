/obj/item/gun/energy/e_gun/asterion
	name = "\improper NT `Asterion` Personal Defense E-Pistol"
	desc = "A unique, and compact energy pistol with a sleek design referencing older laser guns. One of the alternate models, usually administered to Nanotrasen executives. Proves to be very efficient with two settings: disable and kill."
	icon = 'modular_zzplurt/icons/obj/guns/ntc_gun.dmi'
	icon_state = "asterion"
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_righthand.dmi'
	ammo_x_offset = 2
	w_class = WEIGHT_CLASS_BULKY

/obj/item/gun/energy/e_gun/asterion/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)
