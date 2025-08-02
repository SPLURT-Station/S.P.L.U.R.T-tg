/obj/item/clothing/shoes/invisiboots
	name = "invisifiber footwraps"
	desc = "A set of transparent fibers used for wrapping claws or paws."
	icon = 'modular_zzplurt/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/shoes.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	icon_state = "foot_wraps_transparent"
	worn_icon_state = "none"
	// No overlay, because they're invisible!

/obj/item/clothing/shoes/jackboots/toeless
	name = "toe-less jackboots"
	desc = "Modified pair of jackboots, particularly friendly to those species whose toes hold claws."
	icon = 'modular_zzplurt/icons/obj/clothing/shoes.dmi'
	icon_state = "jackboots-toeless"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/shoes.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/shoes_digi.dmi'

/obj/item/clothing/shoes/jackboots/tall
	name = "tall jackboots"
	desc = "A pair of knee-high jackboots, complete with heels. All style, all the time."
	icon = 'modular_zzplurt/icons/obj/clothing/shoes.dmi'
	icon_state = "jackboots-tall"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/shoes.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/shoes_digi.dmi'

/obj/item/clothing/shoes/jackboots/tall/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('modular_zzplurt/sound/effects/footstep/highheel1.ogg' = 1,'modular_zzplurt/sound/effects/footstep/highheel2.ogg' = 1), 20)

/obj/item/clothing/shoes/workboots/toeless
	name = "toe-less workboots"
	desc = "A pair of toe-less work boots designed for use in industrial settings. Modified for species whose toes have claws."
	icon = 'modular_zzplurt/icons/obj/clothing/shoes.dmi'
	icon_state = "workboots-toeless"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/shoes.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/shoes_digi.dmi'

/* They exist nonmodularly and adding them causes issues with the loadout.
/obj/item/clothing/shoes/highheels
	name = "high heels"
	desc = "They make the wearer appear taller, and more noisey!"
	icon_state = "highheels"
	icon = 'modular_zzplurt/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/feet.dmi'
*/

/obj/item/clothing/shoes/highheel_sandals
	name = "high-heel sandals"
	desc = "A pair of high-heel sandals"
	icon = 'modular_zzplurt/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/shoes.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/shoes_digi.dmi'
	icon_state = "highheel_sandals"

/obj/item/clothing/shoes/highheel_sandals/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('modular_zzplurt/sound/effects/footstep/highheel1.ogg' = 1,'modular_zzplurt/sound/effects/footstep/highheel2.ogg' = 1), 20)

/obj/item/clothing/shoes/clown_shoes/clussy_heels
	name = "Clussy heels"
	desc = "The silliest footjob of all time."
	icon = 'modular_zzplurt/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/shoes.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/shoes_digi.dmi'
	icon_state = "clussy_heels"

/obj/item/clothing/shoes/jackboots/puttee
	name = "Putte Boots"
	desc = "A World War 1 era set of wool british puttees wrapped over the leg and boots."
	icon = 'modular_zzplurt/icons/obj/clothing/shoes.dmi'
	icon_state = "puttee"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/shoes.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/shoes_digi.dmi'

/obj/item/clothing/shoes/hightops
	name = "hightop sneakers"
	desc = "A comfortable looking pair of high top sneakers, for the skater in you."
	icon = 'modular_zzplurt/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/shoes.dmi'
	icon_state = "hightops"
	post_init_icon_state = "hightops"
	icon_state_preview = "hightops"
	greyscale_config = /datum/greyscale_config/hightops
	greyscale_config_worn = /datum/greyscale_config/hightops/worn
	greyscale_config_worn_digi = /datum/greyscale_config/hightops/worn/digi
	greyscale_colors = "#232228#FFFFFF"
	flags_1 = IS_PLAYER_COLORABLE_1

/datum/greyscale_config/hightops
	name = "Hightops"
	icon_file = 'modular_zzplurt/icons/obj/clothing/shoes.dmi'
	json_config = 'modular_zzplurt/code/datums/greyscale/json_configs/hightops.json'

/datum/greyscale_config/hightops/worn
	name = "Hightops (Worn)"
	icon_file = 'modular_zzplurt/icons/mob/clothing/shoes.dmi'

/datum/greyscale_config/hightops/worn/digi
	name = "Hightops (Worn, digi)"
	icon_file = 'modular_zzplurt/icons/mob/clothing/shoes_digi.dmi'
