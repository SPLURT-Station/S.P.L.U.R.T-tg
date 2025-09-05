/datum/design/wt550_ammo_rubber
	name = "WT-550/WT-551 Magazine (4.6x30mm Rubber-Tipped) (Less-Lethal)"
	desc = "A magazine for the WT-550/WT-551 Autorifle. Contains less-lethal rubber-tipped ammo."
	id = "wt550_ammo_rubber"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6)
	build_path = /obj/item/ammo_box/magazine/wt550m9/rubber
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/techweb_node/riot_supression/New() // OVERRIDE.
	design_ids += "wt550_ammo_rubber"
	design_ids += "s12g_rubber"
	design_ids += "s12g_bslug"
	design_ids += "s12g_br"
	design_ids += "s12g_incinslug"
	design_ids += "wt550_ammo_normal"
	design_ids += "m9mm_mag"
	design_ids += "m45_mag"
	design_ids += "solgrenade_mag"
	. = ..()

/obj/projectile/bullet/c46x30mm/rubber
	name = "4.6x30mm rubber-tipped bullet"
	damage = 5
	stamina = 15

	wound_bonus = CANT_WOUND
	exposed_wound_bonus = CANT_WOUND

	weak_against_armour = TRUE
	sharpness = NONE
	shrapnel_type = null
	embed_type = null

	ricochets_max = 3
	ricochet_incidence_leeway = 0
	ricochet_chance = 75
	ricochet_decay_damage = 0.8

/obj/item/gun/ballistic/automatic/wt550/security/rubber
	spawn_magazine_type = /obj/item/ammo_box/magazine/wt550m9/rubber

/obj/item/ammo_box/magazine/wt550m9/rubber
	name = "\improper WT-550 Rubber magazine"
	icon_state = "46x30mmt-20"
	base_icon_state = "46x30mmt"
	ammo_type = /obj/item/ammo_casing/c46x30mm/rubber
	caliber = CALIBER_46X30MM
	max_ammo = 20

/obj/item/ammo_casing/c46x30mm/rubber
	name = "4.6x30mm rubber-tipped bullet casing"
	desc = "A 4.6x30mm rubber-tipped bullet casing."
	projectile_type = /obj/projectile/bullet/c46x30mm/rubber
	can_be_printed = TRUE
	advanced_print_req = FALSE
	harmful = FALSE
	custom_materials = AMMO_MATS_BASIC

/datum/supply_pack/security/armory/wt550_ammo_rubber
	name = "WT-550/WT-551 Autorifle Ammo Crate (Rubber-Tipped)"
	desc = "Contains 4 magazines with less-lethal rubber-tipped rounds for the WT-551."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/ammo_box/magazine/wt550m9/rubber = 4)
	crate_name = "wt-550 magazine crate (rubber-tipped)"

/datum/supply_pack/security/armory/wt551
	name = "WT-551 Autorifle Crate"
	desc = "Contains a pair of WT-551 Autorifles pre-loaded with less-lethal rubber-tipped rounds. Additional ammo sold seperately. Backwards-compatible with WT-550 magazines. Nanotrasen reminds you that the other weapon is for a friend, and not for going guns akimbo."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/item/gun/ballistic/automatic/wt550/security/rubber = 2)
	crate_name = "wt-550 autorifle crate"

/obj/projectile/bullet/c10mm/rubber
	name = "10mm rubber bullet"
	damage = 10
	stamina = 40
	ricochets_max = 6
	ricochet_incidence_leeway = 0
	ricochet_chance = 130
	ricochet_decay_damage = 0.8
	shrapnel_type = null
	sharpness = NONE
	embed_type = null

/obj/item/ammo_casing/c10mm/rubber
	name = "10mm rubber bullet casing"
	desc = "A 10mm rubber bullet casing."
	projectile_type = /obj/projectile/bullet/c10mm/rubber
	harmful = FALSE

/obj/item/ammo_casing/c9mm/rubber
	name = "9x25mm Mk.12 rubber casing"
	desc = "A modern 9x25mm Mk.12 bullet casing. This less than lethal round sure hurts to get shot by, but causes little physical harm."
	projectile_type = /obj/projectile/bullet/c9mm/rubber
	harmful = FALSE

/obj/projectile/bullet/c9mm/rubber
	name = "9x25mm rubber bullet"
	icon_state = "pellet"
	damage = 18
	stamina = 32
	ricochets_max = 6
	ricochet_incidence_leeway = 0
	ricochet_chance = 180
	ricochet_decay_damage = 0.8
	shrapnel_type = null
	sharpness = NONE
	embed_type = null

/obj/item/ammo_box/c10mm/rubber
	name = "10mm auto rubber box"
	ammo_type = /obj/item/ammo_casing/c10mm/rubber

/obj/item/ammo_box/c9mm/rubber
	name = "9x25mm rubber box"
	ammo_type = /obj/item/ammo_casing/c9mm/rubber

/obj/item/ammo_casing/c34/rubber
	name = ".34 rubber bullet casing"
	desc = "A .34 rubber bullet casing."
	caliber = "c34acp"
	projectile_type = /obj/projectile/bullet/c34/rubber
	harmful = FALSE

/obj/projectile/bullet/c34/rubber
	name = ".34 rubber bullet"
	damage = 5
	stamina = 20
	wound_bonus = -75
	shrapnel_type = null
	sharpness = NONE
	embed_data = null

/obj/item/ammo_casing/a223/rubber
	name = ".277 rubber bullet casing"
	desc = "A .277 rubber bullet casing.\
	<br><br>\
	<i>RUBBER: Less than lethal ammo. Deals both stamina damage and regular damage.</i>"
	projectile_type = /obj/projectile/bullet/a223/rubber
	harmful = FALSE

/obj/projectile/bullet/a223/rubber
	name = ".277 rubber bullet"
	damage = 10
	armour_penetration = 10
	stamina = 30
	ricochets_max = 6
	ricochet_incidence_leeway = 0
	ricochet_chance = 130
	ricochet_decay_damage = 0.7
	shrapnel_type = null
	sharpness = NONE
	embed_data = null
	wound_bonus = -50

/obj/item/ammo_casing/c45/rubber
	name = ".460 Ceres rubber bullet casing"
	desc = "A .460 bullet casing.\
	<br><br>\
	<i>RUBBER: Less than lethal ammo. Deals both stamina damage and regular damage.</i>"
	projectile_type = /obj/projectile/bullet/c45/rubber
	harmful = FALSE

/obj/projectile/bullet/c45/rubber
	name = ".460 Ceres rubber bullet"
	damage = 10
	stamina = 30
	ricochets_max = 6
	ricochet_incidence_leeway = 0
	ricochet_chance = 130
	ricochet_decay_damage = 0.7
	shrapnel_type = null
	sharpness = NONE
	embed_data = null
	wound_bonus = -50

/obj/item/ammo_casing/strilka310/rubber
	name = ".310 Strilka rubber bullet casing"
	desc = "A .310 rubber bullet casing. Casing is a bit of a fib, there isn't one.\
	<br><br>\
	<i>RUBBER: Less than lethal ammo. Deals both stamina damage and regular damage.</i>"

	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/xhihao_light_arms/ammo.dmi'
	icon_state = "310-casing-rubber"

	projectile_type = /obj/projectile/bullet/strilka310/rubber
	harmful = FALSE

/obj/projectile/bullet/strilka310/rubber
	name = ".310 rubber bullet"
	damage = 15
	stamina = 55
	ricochets_max = 5
	ricochet_incidence_leeway = 0
	ricochet_chance = 130
	ricochet_decay_damage = 0.7
	shrapnel_type = null
	sharpness = NONE
	embed_data = null

/obj/item/ammo_box/c310_cargo_box/rubber
	name = "ammo box (.310 Strilka rubber)"
	desc = "A box of .310 Strilka rubber rifle rounds, holds ten cartridges."

	icon_state = "310_box_rubber"

	ammo_type = /obj/item/ammo_casing/strilka310/rubber

/obj/item/ammo_casing/c27_54cesarzowa/rubber
	name = ".27-54 Cesarzowa rubber bullet casing"
	desc = "A purple-bodied caseless cartridge home to a small projectile with a flat rubber tip."

	icon_state = "27-54cesarzowa_rubber"

	projectile_type = /obj/projectile/bullet/c27_54cesarzowa/rubber

/obj/projectile/bullet/c27_54cesarzowa/rubber
	name = ".27-54 Cesarzowa rubber bullet"
	stamina = 20
	damage = 10
	weak_against_armour = TRUE
	wound_bonus = -30
	exposed_wound_bonus = -10

/obj/item/ammo_box/c27_54cesarzowa/rubber
	name = "ammo box (.27-54 Cesarzowa rubber)"
	desc = "A box of .27-54 Cesarzowa rubber pistol rounds, holds eighteen cartridges."

	icon_state = "27-54cesarzowa_box_rubber"

	ammo_type = /obj/item/ammo_casing/c27_54cesarzowa/rubber

/obj/item/ammo_box/magazine/m9mm/stendo/rubber
	name = "pistol magazine (9x25mm Rubber)"
	ammo_type = /obj/item/ammo_casing/c9mm/rubber
	base_icon_state = "g18_b"

/obj/item/ammo_box/magazine/m9mm/rubber
	name = "pistol magazine (9x25mm Rubber)"
	ammo_type = /obj/item/ammo_casing/c9mm/rubber
	base_icon_state = "9x19pB"

/datum/design/c45_rubber
	name = ".45 Bouncy Rubber Ball"
	id = "c45_rubber"
	build_type = AUTOLATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7.5,
	)
	build_path = /obj/item/ammo_casing/c45/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)

/datum/design/c46x30mm_rubber
	name = "4.6x30mm Rubber Bullet"
	id = "c46x30mm_rubber"
	build_type = AUTOLATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7.5
	)
	build_path = /obj/item/ammo_casing/c46x30mm/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)

/datum/design/strilka310_rubber
	name = ".310 Rubber Bullet (Less Lethal)"
	id = "astrilka310_rubber"
	build_type = AUTOLATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/ammo_casing/strilka310/rubber
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)

/obj/item/ammo_box/c34/rubber
	name = "ammo box (.34 rubber)"
	ammo_type = /obj/item/ammo_casing/c34/rubber

/obj/item/ammo_box/c46x30mm/rubber
	name = "ammo box (4.6x30mm rubber)"
	ammo_type = /obj/item/ammo_casing/c46x30mm/rubber

/datum/armament_entry/company_import/vitezstvi/ammo_boxes/strilka_rubber
	item_type = /obj/item/ammo_box/c310_cargo_box/rubber
