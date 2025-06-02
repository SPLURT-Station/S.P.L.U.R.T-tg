/obj/item/clothing/neck/cloak/tendercloak
	name = "bayou old mantle"
	desc = "This is a very shabby (and time-worn) cape, it smells funny of silt."
	icon = 'modular_zzz/icons/obj/clothing/neck.dmi'
	worn_icon = 'modular_zzz/icons/mob/clothing/neck.dmi'
	worn_icon_digi = 'modular_zzz/icons/mob/clothing/neck.dmi'
	icon_state = "ten_neck"

/obj/item/clothing/neck/corvuspendant
	name = "Corvus Pendant"
	desc = "Ravens in black with eyes so keen, steal pendants bright with silver sheen."
	icon = 'modular_zzz/icons/obj/clothing/neck.dmi'
	icon_state = "cp"
	worn_icon = 'modular_zzz/icons/mob/clothing/neck.dmi'
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	uses_advanced_reskins = TRUE
	unique_reskin = list(
		"Corvus Pendant" = list(
			RESKIN_ICON_STATE = "pendant",
			RESKIN_WORN_ICON_STATE = "pendant"
		),
		"Corvus Cape" = list(
			RESKIN_ICON_STATE = "cape",
			RESKIN_WORN_ICON_STATE = "cape"
		)
	)
