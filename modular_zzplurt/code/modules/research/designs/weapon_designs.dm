/datum/design/m9x17mm_mag
	name = "9x17mm MP-S5 Magazine (Lethal)"
	desc = "A standard magazine for the MP-S5 VIG, made to hold 30 bullets of 9x17mm."
	id = "m9x17mm_mag"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 18, /datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 8
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
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 6, /datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 12
	)
	build_path = /obj/item/ammo_box/magazine/mps5/rubber
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/m9x17mm_mag_ihdf
	name = "9x17mm Intelligent Dispersal Foam MP-S5 Magazine (Non-Lethal)"
	desc = "A standard magazine for the MP-S5 VIG, made to hold 30 bullets of 9x17mm, this one is full of advanced bullets full of \
	foam-capped bullets that expand the foam on impact, making the impact padded, however hitting them like a beanbag, knocking the air out of them."
	id = "m9x17mm_mag_ihdf"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 4, /datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 8
	)
	build_path = /obj/item/ammo_box/magazine/mps5/ihdf
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
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 12, /datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 6, /datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 8
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
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 8, /datum/material/titanium = SHEET_MATERIAL_AMOUNT * 8, /datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 8
	)
	build_path = /obj/item/ammo_box/magazine/mps5/ap
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

// Handgun Magazine starts hereeeeee!
//Yes this does mean overall we're doing less damage  per magazine. However part of the necesscitie for this changge is that it makes the handgun more solid all rounder rather than something you throw away.
// In an ideal scenario, you want an absolute trust in your firearm or at the very least find it not as much a burden to carry.
/datum/design/m9x17mm_pmag
	name = "9x17mm Handgun Magazine (Lethal)"
	desc = "A standard magazine for all 9mm security pistol, holds 16 rounds of 9x17mm."
	id = "m9x17mm_pmag"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 4, /datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 3
	)
	build_path = /obj/item/ammo_box/magazine/security
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/m9x17mm_pmag_rubber
	name = "9x17mm Rubber Handgun Magazine (Less-Lethal)"
	desc = "A standard magazine for all 9mm security pistol, holds 16 rounds of 9x17mm, this one is full of rubber-capped bullets \
	For use of disabling targets, while also breaking a few ribs. For those officers who have no issue with lawsuits."
	id = "m9x17mm_pmag_rubber"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 2, /datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 2
	)
	build_path = /obj/item/ammo_box/magazine/security/splurt_rubber
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/m9x17mm_pmag_ihdf
	name = "9x17mm Intelligent Dispersal Foam Handgun Magazine (Non-Lethal)"
	desc = "A standard magazine for all 9mm security pistol, holds 16 rounds of 9x17mm, this one is full of advanced bullets full of \
	foam-capped bullets that expand the foam on impact, making the impact padded, however hitting them like a beanbag, knocking the air out of them."
	id = "m9x17mm_pmag_ihdf"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 2, /datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 1
	)
	build_path = /obj/item/ammo_box/magazine/security/splurt_ihdf
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/m9x17mm_pmag_hp
	name = "9x17mm Hollow-Point Pistol Magazine (Very Lethal)"
	desc = "A standard magazine for all 9mm security pistol, holds 16 rounds of 9x17mm, this one is full of bullets meant to shred unarmored personnel \
	better, NOT advised for security brutality!"
	id = "m9x17mm_pmag_hp"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 6, /datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 6, /datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 4
	)
	build_path = /obj/item/ammo_box/magazine/security/splurt_hp
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/m9x17mm_pmag_ap
	name = "9x17mm Armor Piercing Pistol Magazine (Lethal)"
	desc = "A standard magazine for all 9mm security pistol, holds 16 rounds of 9x17mm, this one is full of bullets that are meant for armored targets, \
	as they ignore as much armor of the target as it can, shredding right through. Nearly useless against unarmored targets though."
	id = "m9x17mm_pmag_ap"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 4, /datum/material/titanium = SHEET_MATERIAL_AMOUNT * 4, /datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 6
	)
	build_path = /obj/item/ammo_box/magazine/security/splurt_ap
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY
// Misc items
/datum/design/rt45c
	name = ".45 Romulus Heavy Revolver Cartridge (Lethal)"
	desc = "A cartridge for the all pistols chambered in .45 RT, You almost wish they'd make a speedloader of these things."
	id = "rt45c"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 4
	)
	build_path = /obj/item/ammo_casing/c45rt
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/rt45c_hv
	name = ".45 Romulus Heavy Revolver Cartridge (Lethal)"
	desc = "A cartridge for the all pistols chambered in .45 RT, High velocity projectile yield higher penetration but has reduced stopping power"
	id = "rt45c_hv"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 4, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 4
	)
	build_path = /obj/item/ammo_casing/c45rt/hv
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/rt45c_sl
	name = ".45 Heavy Speedloader (Lethal)"
	desc = "A speed loader for .45 Romulus Technology Cartridges. For when you really need to fulfill a promise"
	id = "rt45c_sl"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 6
	)
	build_path = /obj/item/ammo_casing/c45rt
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/rt45c_sl
	name = ".45 Heavy Speedloader (Lethal)"
	desc = "A speed loader for .45 Romulus Technology Cartridges. For when you really need to fulfill a promise"
	id = "rt45c_hv_sl"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 6, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 6
	)
	build_path = /obj/item/ammo_casing/c45rt
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

// Special Weapon Kit

/datum/design/wt458_kit
	name = "WT-458 Conversion Kit (Very Lethal)"
	desc = "Turn your fully automatic gun into a 3 round burst-firing gun with dual magazine port."
	id = "wt458_kit"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 30, /datum/material/iron = SHEET_MATERIAL_AMOUNT * 16, /datum/material/titanium = SHEET_MATERIAL_AMOUNT * 10)
	build_path = /obj/item/weaponcrafting/gunkit/wt458_kit
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_KITS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY
	autolathe_exportable = FALSE
