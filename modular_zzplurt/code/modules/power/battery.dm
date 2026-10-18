// Tier 5 Power Battery

/obj/item/stock_parts/power_store/battery/abductor
	name = "abductor megacell"
	desc = "A rechargeable alien megacell."
	icon = 'modular_zzplurt/icons/obj/machines/cell_charger.dmi'
	icon_state = "abcellbig"
	maxcharge = STANDARD_BATTERY_CHARGE * 50
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.2,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.6,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 1.6,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 1.2,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT,
		/datum/material/alloy/alien = SMALL_MATERIAL_AMOUNT * 0.5,
	)
	chargerate = STANDARD_BATTERY_RATE * 3

/obj/item/stock_parts/power_store/battery/abductor/empty
	empty = TRUE
