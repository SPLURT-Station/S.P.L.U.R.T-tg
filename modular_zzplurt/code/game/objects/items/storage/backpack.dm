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

/datum/atom_skin/snail_shell
	abstract_type = /datum/atom_skin/snail_shell

/datum/atom_skin/snail_shell/conical
	preview_name = "Conical Shell"
	new_icon = 'modular_skyrat/master_files/icons/obj/clothing/backpacks.dmi'
	new_icon_state = "coneshell"
	new_worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/back.dmi'

/datum/atom_skin/snail_shell/round
	preview_name = "Round Shell"
	new_icon = 'icons/obj/storage/backpack.dmi'
	new_icon_state = "snailshell"
	new_worn_icon = 'icons/mob/clothing/back/backpack.dmi'

/datum/atom_skin/snail_shell/cinnamon
	preview_name = "Cinnamon Shell"
	new_icon = 'modular_skyrat/master_files/icons/obj/clothing/backpacks.dmi'
	new_icon_state = "cinnamonshell"
	new_worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/back.dmi'

/datum/atom_skin/snail_shell/caramel
	preview_name = "Caramel Shell"
	new_icon = 'modular_skyrat/master_files/icons/obj/clothing/backpacks.dmi'
	new_icon_state = "caramelshell"
	new_worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/back.dmi'

/datum/atom_skin/snail_shell/metal
	preview_name = "Metal Shell"
	new_icon = 'modular_skyrat/master_files/icons/obj/clothing/backpacks.dmi'
	new_icon_state = "mechashell"
	new_worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/back.dmi'

/datum/atom_skin/snail_shell/pyramid
	preview_name = "Pyramid Shell"
	new_icon = 'modular_skyrat/master_files/icons/obj/clothing/backpacks.dmi'
	new_icon_state = "pyramidshell"
	new_worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/back.dmi'

/datum/atom_skin/snail_shell/pyramid_ivory
	preview_name = "Ivory Pyramid Shell"
	new_icon = 'modular_skyrat/master_files/icons/obj/clothing/backpacks.dmi'
	new_icon_state = "pyramidshellwhite"
	new_worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/back.dmi'

/datum/atom_skin/snail_shell/spiral
	preview_name = "Spiral Shell"
	new_icon = 'modular_skyrat/master_files/icons/obj/clothing/backpacks.dmi'
	new_icon_state = "spiralshell"
	new_worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/back.dmi'

/datum/atom_skin/snail_shell/spiral_ivory
	preview_name = "Ivory Spiral Shell"
	new_icon = 'modular_skyrat/master_files/icons/obj/clothing/backpacks.dmi'
	new_icon_state = "spiralshellwhite"
	new_worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/back.dmi'

/datum/atom_skin/snail_shell/rocky
	preview_name = "Rocky Shell"
	new_icon = 'modular_skyrat/master_files/icons/obj/clothing/backpacks.dmi'
	new_icon_state = "rockshell"
	new_worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/back.dmi'

/datum/atom_skin/snail_shell/rocky_ivory
	preview_name = "Ivory Rocky Shell"
	new_icon = 'modular_skyrat/master_files/icons/obj/clothing/backpacks.dmi'
	new_icon_state = "rockshellwhite"
	new_worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/back.dmi'
