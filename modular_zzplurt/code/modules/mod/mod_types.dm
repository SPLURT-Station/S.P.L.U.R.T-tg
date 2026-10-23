/obj/item/mod/control/pre_equipped/mining/Initialize(mapload, new_theme, new_skin, new_core)
	applied_modules += list(
		/obj/item/mod/module/visor/meson,
	)
	default_pins += list(
		/obj/item/mod/module/visor/meson,
	)
	return ..()

/obj/item/mod/control/pre_equipped/asset_protection
	theme = /datum/mod_theme/asset_protection
	starting_frequency = MODLINK_FREQ_CENTCOM
	applied_cell = /obj/item/stock_parts/power_store/cell/bluespace
	req_access = list(ACCESS_CENT_OFFICER)
	applied_modules = list(
		/obj/item/mod/module/storage/bluespace,
		/obj/item/mod/module/welding,
		/obj/item/mod/module/emp_shield/advanced,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/projectile_dampener,
		/obj/item/mod/module/status_readout,
	)
	default_pins = list(
		/obj/item/mod/module/jetpack,
	)

/obj/item/mod/control/pre_equipped/asset_protection/officer
	applied_modules = list(
		/obj/item/mod/module/storage/bluespace,
		/obj/item/mod/module/hat_stabilizer,
		/obj/item/mod/module/welding,
		/obj/item/mod/module/emp_shield/advanced,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/projectile_dampener,
		/obj/item/mod/module/status_readout,
	)

/obj/item/mod/control/pre_equipped/responsory/commander
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/hat_stabilizer,
		/obj/item/mod/module/welding,
		/obj/item/mod/module/emp_shield,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/quick_cuff,
		/obj/item/mod/module/jetpack
	)
