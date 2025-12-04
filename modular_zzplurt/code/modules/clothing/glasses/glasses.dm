/obj/item/clothing/glasses/contact
	name = "contact lenses"
	desc = "Prescription contact lenses, a miracle of science."
	icon = 'modular_zzplurt/icons/obj/clothing/glasses.dmi'
	worn_icon = 'modular_zzplurt/icons/obj/clothing/glasses.dmi'
	worn_icon_state = "nothing"
	icon_state = "contact_lenses"
	clothing_traits = list(TRAIT_NEARSIGHTED_CORRECTED)

/obj/item/clothing/glasses/hud/administrative
	name = "administrative HUD"
	desc = "A heads-up display that scans the humanoids in view and provides accurate data about their ID status."
	icon = 'modular_zzplurt/icons/obj/clothing/glasses.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/eyes.dmi'
	icon_state = "adminhud"
	clothing_traits = list(TRAIT_SECURITY_HUD_ID_ONLY)
	glass_colour_type = /datum/client_colour/glass_colour/lightblue

/obj/item/clothing/glasses/hud/administrative/sunglasses
	name = "administrative HUDSunglasses"
	desc = "Sunglasses with a administrative HUD."
	icon_state = "sunhudadmin"
	flash_protect = FLASH_PROTECTION_FLASH
	flags_cover = GLASSESCOVERSEYES
	tint = 1

/obj/item/clothing/glasses/hud/administrative/sunglasses/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/hudsunsecremoval)
