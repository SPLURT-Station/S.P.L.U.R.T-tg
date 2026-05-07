/obj/item/chisel/ashwalker
	name = "primitive chisel"
	desc = "Where there is a will there is a way; the tool head of this chisel is fashioned from bone shaped when it was fresh and then left to calcify in iron rich water, to make a strong head for all your carving needs."
	icon = 'modular_zzplurt/icons/obj/ashwalker_tools.dmi'
	icon_state = "chisel"
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)

	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	toolspeed = 4

/datum/crafting_recipe/ash_recipe/ash_chisel
	name = "Ash Chisel"
	result = /obj/item/chisel/ashwalker
