/datum/atom_skin/templar_mask
	abstract_type = /datum/atom_skin/templar_mask
	change_base_icon_state = TRUE

/datum/atom_skin/templar_mask/smile
	preview_name = "Smile"
	new_icon_state = "mask_smile"

/datum/atom_skin/templar_mask/nerd
	preview_name = "Nerd"
	new_icon_state = "mask_nerd"

/datum/atom_skin/templar_mask/squint
	preview_name = "Squint"
	new_icon_state = "mask_squint"

/datum/atom_skin/templar_mask/blegh
	preview_name = "Blegh"
	new_icon_state = "mask_blegh"

/datum/atom_skin/templar_mask/sunglasses
	preview_name = "Sunglasses"
	new_icon_state = "mask_sunglasses"

/datum/atom_skin/templar_mask/nosey
	preview_name = "Nosey"
	new_icon_state = "mask_nosey"

/datum/atom_skin/templar_mask/sob
	preview_name = "Sob"
	new_icon_state = "mask_sob"

/obj/item/clothing/mask/templar
	name = "emotion mask"
	desc = "Express your happiness or hide your sorrows with this cultured cutout."
	icon = 'modular_zzplurt/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/mask.dmi'
	icon_state = "mask"
	base_icon_state = "mask"
	clothing_flags = MASKINTERNALS
	flags_inv = HIDESNOUT

/obj/item/clothing/mask/templar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/templar_mask, infinite = TRUE)
