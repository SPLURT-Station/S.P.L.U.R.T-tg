/obj/item/shield/energy
	light_system = OVERLAY_LIGHT
	light_range = 2
	light_power = 1
	light_on = FALSE
	light_color = LIGHT_COLOR_LIGHT_CYAN

/obj/item/shield/energy/advanced
	light_color = COLOR_SOFT_RED

/obj/item/shield/energy/bananium
	light_color = COLOR_YELLOW

/obj/item/shield/energy/cheap
	name = "cheap combat energy shield"
	desc = "A budget hardlight shield capable of deflecting most energy projectiles and providing adequate defense against a variety of other attacks. \
		A cost-reduced alternative to the models employed by Nanotrasen Deathsquads, it sacrifices some defensive strength and reliability in exchange for affordability. \
		Typically issued to Nanotrasen Asset Protection personnel."
	icon = 'modular_zzplurt/icons/obj/weapons/shields.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/back.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/equipment/shields_righthand.dmi'
	icon_state = "cheap_eshield"
	inhand_icon_state = "cheap_eshield"
	breakable_by_damage = TRUE
	light_color = LIGHT_COLOR_GREEN
	reflection_probability = 40 // Slightly cheap, so it's not too good.
