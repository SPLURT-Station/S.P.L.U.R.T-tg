/obj/item/lighter/bright/gunlighter
	name = "\improper Ancient Revolver"
	desc = "At first glance this seems to be a normal revolver, but there's no ammunition... Turns out, it's a lighter, one of a kind!"
	icon = 'modular_zzplurt/icons/obj/cigarettes.dmi'
	icon_state = "gunlightertilted"
	inhand_icon_state = null
	worn_icon_state = "lighter"
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_lefthand.dmi'
	//Fingie hurty = Bad
	fancy = TRUE
	///The max amount of fuel the lighter can hold.
	maximum_fuel = 10

/obj/item/lighter/bright/gunlighter/create_lighter_overlay()
	return null
