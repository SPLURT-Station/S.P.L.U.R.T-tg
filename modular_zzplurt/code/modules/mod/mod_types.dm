/obj/item/mod/control/pre_equipped/mining/Initialize(mapload, new_theme, new_skin, new_core)
	applied_modules += list(
		/obj/item/mod/module/visor/meson,
	)
	default_pins += list(
		/obj/item/mod/module/visor/meson,
	)
	return ..()
