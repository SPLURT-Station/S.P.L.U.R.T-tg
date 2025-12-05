/datum/design/m9x17mm_mag
	name = "9x17mm MP-S5 Magazine (Lethal)"
	desc = "A standard magazine for the MP-S5 VIG, made to hold 30 bullets of 9x17mm."
	id = "m9x17mm_mag"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 18,
	)
	build_path = /obj/item/ammo_box/magazine/mps5
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/m9x17mm_mag_rubber
	name = "9x17mm Rubber MP-S5 Magazine (Less-Lethal)"
	desc = "A standard magazine for the MP-S5 VIG, made to hold 30 bullets of 9x17mm, this one is full of rubber-capped bullets \
	For use of disabling targets, while also breaking a few ribs. For those officers who have no issue with lawsuits."
	id = "m9x17mm_mag_rubber"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 10,
	)
	build_path = /obj/item/ammo_box/magazine/mps5/rubber
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/m9x17mm_mag_idhf
	name = "9x17mm Intelligent Dispersal Foam MP-S5 Magazine (Non-Lethal)"
	desc = "A standard magazine for the MP-S5 VIG, made to hold 30 bullets of 9x17mm, this one is full of advanced bullets full of \
	foam-capped bullets that expand the foam on impact, making the impact padded, however hitting them like a beanbag, knocking the air out of them."
	id = "m9x17mm_mag_idhf"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 12,
	)
	build_path = /obj/item/ammo_box/magazine/mps5/idhf
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/m9x17mm_mag_hp
	name = "9x17mm Hollow-Point MP-S5 Magazine (Very Lethal)"
	desc = "A standard magazine for the MP-S5 VIG, made to hold 30 bullets of 9x17mm, this one is full of bullets meant to shred unarmored personnel \
	better, NOT advised for security brutality!"
	id = "m9x17mm_mag_hp"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 12,
	)
	build_path = /obj/item/ammo_box/magazine/mps5/hp
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/m9x17mm_mag_ap
	name = "9x17mm Armor Piercing MP-S5 Magazine (Lethal)"
	desc = "A standard magazine for the MP-S5 VIG, made to hold 30 bullets of 9x17mm, this one is full of bullets that are meant for armored targets, \
	as they ignore as much armor of the target as it can, shredding right through. Nearly useless against unarmored targets though."
	id = "m9x17mm_mag_ap"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 12, /datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2
	)
	build_path = /obj/item/ammo_box/magazine/mps5/hp
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY
