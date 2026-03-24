/obj/item/storage/backpack/sloogshell
	name = "Sloog shell"
	desc = "A large shell, belonging to probably a very large snail or slug... Wait... It can store things?"
	icon = 'modular_zzplurt/icons/obj/storage.dmi'
	icon_state = "sloog_backpack"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/64_back.dmi'
	worn_x_dimension = 64
	alternate_worn_layer = ABOVE_BODY_FRONT_LAYER

/obj/item/storage/backpack/snail_replica
	name = "decorative snail shell"
	desc = "A replica snail shell that functions as a regular backpack. Perfect for snail enthusiasts!"
	icon_state = "snailshell"
	worn_icon_state = "snailshell"
	inhand_icon_state = null
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	alternate_worn_layer = ABOVE_BODY_FRONT_LAYER

/obj/item/storage/backpack/snail_replica/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/snail_shell)

