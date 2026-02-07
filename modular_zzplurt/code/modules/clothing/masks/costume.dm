/obj/item/clothing/mask/templar
	name = "emotion mask"
	desc = "Express your happiness or hide your sorrows with this cultured cutout."
	icon = 'modular_zzplurt/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/mask.dmi'
	icon_state = "mask"
	base_icon_state = "mask"
	clothing_flags = MASKINTERNALS
	flags_inv = HIDESNOUT
	obj_flags = parent_type::obj_flags | INFINITE_RESKIN
	unique_reskin = list(
			"Smile" = "mask_smile",
			"Nerd" = "mask_nerd",
			"Squint" = "mask_squint",
			"Blegh" = "mask_blegh",
			"Sunglasses" = "mask_sunglasses",
			"Nosey" = "mask_nosey",
			"Sob" = "mask_sob"
	)


/obj/item/clothing/mask/joy/reskin_obj(mob/user)
	. = ..()
	user.update_worn_mask()
