// Illegal stun baton upgrade for peacekeeper borgs
/obj/item/borg/upgrade/stunbaton
	name = "cyborg stun baton module"
	desc = "An augmentation that equips a peacekeeper cyborg with a rechargeable stun baton, drastically increasing their ability to incapacitate targets."
	icon_state = "module_security"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/peacekeeper)
	items_to_add = list(/obj/item/melee/baton/security/loaded)

/obj/item/borg/upgrade/stunbaton/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)
