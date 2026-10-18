// Tier 5 Power Cell

/obj/item/stock_parts/power_store/cell/abductor
	name = "abductor power cell"
	desc = "A rechargeable alien power cell."
	icon = 'modular_zzplurt/icons/obj/machines/cell_charger.dmi'
	icon_state = "abcell"
	emp_damage_modifier = 6
	maxcharge = STANDARD_CELL_CHARGE * 50
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 0.8,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 1.6,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 1.6,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 1.2,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT,
		/datum/material/alloy/alien = SMALL_MATERIAL_AMOUNT * 0.5,
	)
	chargerate = STANDARD_CELL_RATE * 3

/obj/item/stock_parts/power_store/cell/abductor/empty
	empty = TRUE
