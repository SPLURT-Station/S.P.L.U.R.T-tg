/obj/item/gun/energy/e_gun/asterion
	name = "\improper NT 'Asterion' Personal Defense E-Pistol"
	desc = "A unique, and compact energy pistol with a sleek design referencing the more famous Antique laser gun, all you're missing is the hellfire lasers and cool engravings! It's similar frame to the Antique makes it easier to carry. One of the alternate models that was mass-produced, usually administered to Nanotrasen Executives. Proves to be very efficient with two settings: disable and kill."
	icon = 'modular_zzplurt/icons/obj/guns/ntc_gun.dmi'
	icon_state = "asterion"
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_righthand.dmi'
	ammo_x_offset = 2
	recoil = 0.2

/obj/item/gun/energy/e_gun/asterion/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)
