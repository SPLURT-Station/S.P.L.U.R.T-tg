/datum/design/oscula_kit
	name = "Oscillating Sword Kit (Lethal/Anti Teleport)"
	desc = "A kit to infuse your sword with the power of bluespace and briefly prevent teleportation. Woes upon any wizard that you may face"
	id = "oscula_kit"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 15, /datum/material/bluespace = SHEET_MATERIAL_AMOUNT * 10, /datum/material/diamond =SHEET_MATERIAL_AMOUNT * 3.5, /datum/material/titanium = HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/weaponcrafting/gunkit/nuclear
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_KITS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY
	autolathe_exportable = FALSE
