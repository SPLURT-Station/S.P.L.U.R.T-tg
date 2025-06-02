/obj/item/clothing/mask/gas/syndicate
	icon = 'modular_zzz/icons/obj/clothing/masks/mask.dmi'
	worn_icon = 'modular_zzz/icons/mob/clothing/mask.dmi'
	// worn_icon_muzzled = 'modular_zzz/icons/mob/clothing/mask_muzzled.dmi'

/obj/item/clothing/mask/gas/syndicate/cool_version
	name = "Tactical Catcrin Gasmask"
	desc = "A mask with a red visor and special filters. It seems to have a kind of cat whiskers on it."
	icon_state = "syndicate_cool"
	actions_types = list(/datum/action/item_action/maskhalt)

/datum/action/item_action/maskhalt
	name = "HALT!"

/obj/item/clothing/mask/gas/syndicate/cool_version/verb/maskhalt()
	set category = "Object"
	set name = "HALT!"
	set src in usr
	if(!isliving(usr))
		return
	if(!can_use(usr))
		return

	var/frase
	frase = input("Какую фразу вы хотите сказать через преобразователь в маске?","") as text

	if(frase)
		usr.audible_message("<b>[usr]</b> exclaims, \"<font color='red' size='4'><b>[frase]</b></font>\"")
		switch(rand(0,3))
			if(0)
				playsound(src.loc, 'modular_zzz/sounds/misc/catcrin_halt0.ogg', 100, 1)
			if(1)
				playsound(src.loc, 'modular_zzz/sounds/misc/catcrin_halt1.ogg', 100, 1)
			if(2)
				playsound(src.loc, 'modular_zzz/sounds/misc/catcrin_halt2.ogg', 100, 1)
			if(3)
				playsound(src.loc, 'modular_zzz/sounds/misc/catcrin_halt3.ogg', 100, 1)

/obj/item/clothing/mask/gas/syndicate/cool_version/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/maskhalt))
		maskhalt()

/obj/item/clothing/mask/gas/syndicate/blackcool_version
	name = "CFIS Gasmask"
	desc = "Tactical gasmask for Catcrin Foreign Intelligence Service operatives. The compact mask has dark glass and small filters in the front part of the mask with breath venting."
	icon_state = "syndicate_blackcool"

/obj/item/clothing/mask/gas/syndicate/yekitezh
	name = "M1062"
	desc = "Standard military issue gas mask, it replaced the previous M55 gas mask series in Yekitezh Army."
	icon_state = "m1062"

/obj/item/clothing/mask/gas/syndicate/yekitezh_red
	name = "M1062-B"
	desc = "Standard military gas mask of the Yekitezh Army, except this one optimized with glowing red lenses and black coverage for 'tactical' issues."
	icon_state = "m1062b"

/obj/item/clothing/mask/gas/syndicate/cool_version/judas_version
	name = "Andromeda Mask"
	desc = "A close-fitting tactical mask used by shark-like species. It has moderate protection against ballistic damage and a flap for closed breathing."
	icon_state = "akula_mask"
