/datum/design/m9mm_sec_rubber
	name = "Magazine (9x25mm Murphy Rubber) (Less-Lethal)"
	desc = "Designed to slide in and out of a 9mm 'Murphy' service pistol. This magazine is loaded with rubber rounds for non-lethal takedowns."
	id = "m9mm_sec_rubber"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/ammo_box/magazine/security/rubber
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY
