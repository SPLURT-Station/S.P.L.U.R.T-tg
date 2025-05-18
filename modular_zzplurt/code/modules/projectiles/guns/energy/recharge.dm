// self-reloading weapons need their ammo hud updated whenever reload() is called
/obj/item/gun/energy/recharge/reload()
	. = ..()
	SEND_SIGNAL(src, COMSIG_UPDATE_AMMO_HUD)
