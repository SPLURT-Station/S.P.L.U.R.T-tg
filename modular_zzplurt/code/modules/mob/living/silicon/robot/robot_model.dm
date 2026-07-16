/obj/item/robot_model/affairs
	name = "Internal Affairs"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/melee/baton/telescopic,
		/obj/item/stamp/nanotrasen/cyborg,
		/obj/item/stamp/denied,
		/obj/item/pen/fountain/nanotrasen/cyborg,
		/obj/item/clipboard/cyborg,
		/obj/item/borg/apparatus/bureaucratic_manipulator,
		/obj/item/rsf,
		/obj/item/hand_labeler/cyborg,
		/obj/item/megaphone/command,
		/obj/item/extinguisher/mini,
		/obj/item/weldingtool/electric,
		/obj/item/crowbar/cyborg,
	)
	radio_channels = list(RADIO_CHANNEL_IAA)
	cyborg_base_icon = "valeia"
	model_select_icon = "nanotrasen"
	model_traits = list(TRAIT_NEGATES_GRAVITY, TRAIT_PUSHIMMUNE)
	hat_offset = list("north" = list(0, 3), "south" = list(0, 3), "east" = list(1, 3), "west" = list(-1, 3))

	borg_skins = list(
		"Drake" = list(SKIN_ICON_STATE = "drakeia", SKIN_ICON = 'modular_zzplurt/icons/mob/robot/affairs/widerobot.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_WIDE), DRAKE_HAT_OFFSET),
		"Vale" = list(SKIN_ICON_STATE = "valeia", SKIN_ICON = 'modular_zzplurt/icons/mob/robot/affairs/widerobot.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_WIDE), VALE_HAT_OFFSET),
		"NiKA" = list(SKIN_ICON_STATE = "fmekaia", SKIN_ICON = 'modular_zzplurt/icons/mob/robot/affairs/tallrobot.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_UNIQUETIP, TRAIT_R_TALL), TALL_HAT_OFFSET),
		"NiKO" = list(SKIN_ICON_STATE = "mmekaia", SKIN_ICON = 'modular_zzplurt/icons/mob/robot/affairs/tallrobot.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_UNIQUETIP, TRAIT_R_TALL), TALL_HAT_OFFSET),
		"Raptor" = list(SKIN_ICON_STATE = "raptoria", SKIN_ICON = 'modular_zzplurt/icons/mob/robot/affairs/largerobot.dmi', SKIN_FEATURES = list(TRAIT_R_UNIQUEWRECK, TRAIT_R_WIDE), RAPTOR_HAT_OFFSET)
	)

/obj/item/robot_model/affairs/do_transform_animation()
	..()
	to_chat(loc, span_userdanger("While you have picked the internal affairs model, you still have to follow your laws, Special Operation Procedures and Space Law \
	are apart of what you should concern yourself with. You prioritize corporate control of the station, you are not a Central Command-sent borg, nor do you have \
	more authority than the Captain."))
