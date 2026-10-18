////////////////////////////////////////
//////////////////Power/////////////////
////////////////////////////////////////

/datum/design/abductor_cell
	name = "Abductor Power Cell"
	desc = "A power cell that holds 400 KW of energy."
	id = "abductor_cell"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 8, /datum/material/gold = SMALL_MATERIAL_AMOUNT * 1.2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 1.6, /datum/material/diamond = SMALL_MATERIAL_AMOUNT * 1.6, /datum/material/titanium =SMALL_MATERIAL_AMOUNT * 3, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT, /datum/material/alloy/alien = SMALL_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/stock_parts/power_store/cell/abductor/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_5
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/abductor_battery
	name = "Abductor Megacell"
	desc = "A battery that holds 400 KW of energy."
	id = "abductor_battery"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 12, /datum/material/gold = SMALL_MATERIAL_AMOUNT * 1.2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.6, /datum/material/diamond = SMALL_MATERIAL_AMOUNT * 1.6, /datum/material/titanium =SMALL_MATERIAL_AMOUNT * 3, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT, /datum/material/alloy/alien = SMALL_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/stock_parts/power_store/battery/abductor/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_5
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING
