////////////////////////////////////////
/////////////Stock Parts////////////////
////////////////////////////////////////

//Capacitors
/datum/design/abductor_capacitor
	name = "Abductor Capacitor"
	desc = "A stock part used in the construction of various devices."
	id = "abductor_capacitor"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2, /datum/material/gold =SMALL_MATERIAL_AMOUNT, /datum/material/diamond =SMALL_MATERIAL_AMOUNT, /datum/material/alloy/alien =SMALL_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/stock_parts/capacitor/abductor
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_5
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

//Scanning modules
/datum/design/abductor_scanning
	name = "Abductor Scanning Module"
	desc = "A stock part used in the construction of various devices."
	id = "abductor_scanning"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2, /datum/material/diamond = SMALL_MATERIAL_AMOUNT*0.3, /datum/material/bluespace = SMALL_MATERIAL_AMOUNT*0.5, /datum/material/alloy/alien = SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/stock_parts/scanning_module/abductor
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_5
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

//Maipulators
/datum/design/abductor_servo
	name = "Abductor Servo"
	desc = "A stock part used in the construction of various devices."
	id = "abductor_servo"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/diamond = SMALL_MATERIAL_AMOUNT*0.3, /datum/material/titanium = SMALL_MATERIAL_AMOUNT*0.3, /datum/material/alloy/alien = SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/stock_parts/servo/abductor
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_5
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

//Micro-lasers
/datum/design/abductor_micro_laser
	name = "Abductor Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	id = "abductor_micro_laser"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2, /datum/material/uranium =SMALL_MATERIAL_AMOUNT, /datum/material/diamond = SMALL_MATERIAL_AMOUNT*0.6, /datum/material/alloy/alien = SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/stock_parts/micro_laser/abductor
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_5
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

//Matter bins
/datum/design/abductor_matter_bin
	name = "Abductor Matter Bin"
	desc = "A stock part used in the construction of various devices."
	id = "abductor_matter_bin"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*2.5, /datum/material/diamond =SMALL_MATERIAL_AMOUNT, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT, /datum/material/alloy/alien = SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/stock_parts/matter_bin/abductor
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_5
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE
