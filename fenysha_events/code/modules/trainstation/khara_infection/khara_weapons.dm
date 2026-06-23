/obj/projectile/bullet/anti_khara
	name = "Anti-khara bullet"
	icon = 'icons/obj/weapons/guns/projectiles.dmi'
	icon_state = "smartgun"
	color = COLOR_ASSEMBLY_GREEN
	damage = 30
	damage_type = BRUTE
	armor_flag = BULLET
	hitsound_wall = SFX_RICOCHET
	sharpness = SHARP_POINTY
	impact_effect_type = /obj/effect/temp_visual/impact_effect/anti_khara
	shrapnel_type = null
	embed_type = null
	wound_bonus = 0
	wound_falloff_tile = -5
	embed_falloff_tile = -3

	var/khara_damage = 50

/obj/projectile/bullet/anti_khara/on_hit(atom/target, blocked = 0, pierce_hit)
	if(isliving(target))
		var/mob/living/L = target
		if(!is_khara_creature(L))
			return BULLET_ACT_FORCE_PIERCE
		else
			L.take_overall_damage(khara_damage)
	return ..()

/obj/projectile/bullet/anti_khara/can_hit_target(atom/target, direct_target, ignore_loc, cross_failed)
	if(isliving(target))
		var/mob/living/L = target
		if(!is_khara_creature(L))
			return FALSE
	return ..()

/obj/projectile/bullet/anti_khara/Bump(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!is_khara_creature(L))
			return FALSE
	return ..()

/obj/projectile/bullet/anti_khara/strong
	khara_damage = 80
	speed = 4

/obj/projectile/bullet/anti_khara/shotgun
	khara_damage = 10
	speed = 1

/obj/projectile/bullet/anti_khara/smart
	khara_damage = 30
	speed = 1.3
	color = COLOR_BLUE_GRAY
	impact_effect_type = /obj/effect/temp_visual/impact_effect/anti_khara/smart

/obj/projectile/bullet/anti_khara/smart/shotgun
	khara_damage = 7
	speed = 1

/obj/item/ammo_casing
	var/anti_khara = FALSE

/**
 * ППШКИ / ТЯЖЁЛЫЕ КАЛИБРЫ
 */

/obj/item/ammo_casing/p50/anti_khara
	name = ".50 BMG anti-Khara casing"
	desc = "A .50 BMG anti-Khara round casing."
	projectile_type = /obj/projectile/bullet/anti_khara/strong
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.5
	)
	anti_khara = TRUE

/obj/item/ammo_casing/c46x30mm/anti_khara
	name = "4.6x30mm anti-Khara bullet casing"
	desc = "A 4.6x30mm anti-Khara bullet casing."
	projectile_type = /obj/projectile/bullet/anti_khara
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.2,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.6
	)
	anti_khara = TRUE

/obj/item/ammo_casing/c46x30mm/anti_khara/smart
	name = "4.6x30mm smart anti-Khara bullet casing"
	desc = "A 4.6x30mm smart anti-Khara bullet casing."
	projectile_type = /obj/projectile/bullet/anti_khara/smart
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.3,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.0
	)
	anti_khara = TRUE

/obj/item/ammo_casing/c46x30mm/anti_khara/smart/ready_proj(atom/target, mob/living/user, quiet, zone_override, atom/fired_from)
	if(is_khara_creature(target))
		loaded_projectile.set_homing_target(target)
		new /obj/effect/temp_visual/smartgun_target(get_turf(target))
	return ..()

/obj/item/ammo_casing/c45/anti_khara
	name = ".45 anti-Khara bullet casing"
	desc = "A .45 anti-Khara bullet casing."
	projectile_type = /obj/projectile/bullet/anti_khara
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.7
	)
	anti_khara = TRUE

/**
 * ДРОБОВИКИ
 */

/obj/item/ammo_casing/shotgun/anti_khara
	name = "anti-Khara slug"
	desc = "A 12 gauge slug designed to disrupt Khara-infected biomass."
	icon_state = "stunshell"
	projectile_type = /obj/projectile/bullet/anti_khara/strong
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.0
	)
	anti_khara = TRUE

/obj/item/ammo_casing/shotgun/buckshot/anti_khara
	name = "anti-Khara buckshot shell"
	desc = "A 12 gauge shell loaded with pellets optimized against Khara tissue."
	icon_state = "gshell"
	projectile_type = /obj/projectile/bullet/anti_khara/shotgun
	pellets = 7
	variance = 16
	randomspread = TRUE
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.8,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.2
	)
	anti_khara = TRUE

/obj/item/ammo_casing/shotgun/buckshot/anti_khara/smart
	name = "smart anti-Khara buckshot shell"
	desc = "A 12 gauge shell with smart pellets capable of trajectory correction toward Khara targets."
	icon_state = "gshell"
	projectile_type = /obj/projectile/bullet/anti_khara/smart/shotgun
	pellets = 6
	variance = 18
	randomspread = TRUE
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3.0,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.8
	)
	anti_khara = TRUE

/obj/item/ammo_casing/shotgun/buckshot/anti_khara/smart/ready_proj(atom/target, mob/living/user, quiet, zone_override, atom/fired_from)
	if(is_khara_creature(target))
		loaded_projectile.set_homing_target(target)
		new /obj/effect/temp_visual/smartgun_target(get_turf(target))
	return ..()

/**
 * ПИСТОЛЕТНЫЕ КАЛИБРЫ
 */

/obj/item/ammo_casing/c10mm/anti_khara
	name = "10mm anti-Khara bullet casing"
	desc = "A 10mm bullet casing loaded with compound engineered to disrupt Khara biomass."
	projectile_type = /obj/projectile/bullet/anti_khara
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.8,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.8
	)
	anti_khara = TRUE

/obj/item/ammo_casing/c10mm/anti_khara/smart
	name = "10mm smart anti-Khara bullet casing"
	desc = "A 10mm bullet with micro-guidance system tuned to Khara biological signatures."
	projectile_type = /obj/projectile/bullet/anti_khara/smart
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.0,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.3
	)
	anti_khara = TRUE

/obj/item/ammo_casing/c10mm/anti_khara/smart/ready_proj(atom/target, mob/living/user, quiet, zone_override, atom/fired_from)
	if(is_khara_creature(target))
		loaded_projectile.set_homing_target(target)
		new /obj/effect/temp_visual/smartgun_target(get_turf(target))
	return ..()

/obj/item/ammo_casing/c9mm/anti_khara
	name = "9mm anti-Khara bullet casing"
	desc = "A 9mm bullet casing containing payload optimized against Khara-infected tissue."
	projectile_type = /obj/projectile/bullet/anti_khara
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.6,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.7
	)
	anti_khara = TRUE

/obj/item/ammo_casing/c9mm/anti_khara/smart
	name = "9mm smart anti-Khara bullet casing"
	desc = "A 9mm round with integrated guidance for tracking Khara entities."
	projectile_type = /obj/projectile/bullet/anti_khara/smart
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.8,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.1
	)
	anti_khara = TRUE

/obj/item/ammo_casing/c9mm/anti_khara/smart/ready_proj(atom/target, mob/living/user, quiet, zone_override, atom/fired_from)
	if(is_khara_creature(target))
		loaded_projectile.set_homing_target(target)
		new /obj/effect/temp_visual/smartgun_target(get_turf(target))
	return ..()

/obj/item/ammo_casing/a50ae/anti_khara
	name = ".50AE anti-Khara bullet casing"
	desc = "A high-caliber .50AE round specially formulated to penetrate and degrade dense Khara biomass."
	projectile_type = /obj/projectile/bullet/anti_khara/strong
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3.0,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.4
	)
	anti_khara = TRUE

/**
 * ВИНТОВОЧНЫЕ КАЛИБРЫ
 */

/obj/item/ammo_casing/strilka310/anti_khara
	name = ".310 Strilka anti-Khara bullet casing"
	desc = "A .310 Strilka block of red powder formulated to disrupt Khara biomass."
	icon_state = "310-casing"
	projectile_type = /obj/projectile/bullet/anti_khara
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.2,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.0
	)
	anti_khara = TRUE

/obj/item/ammo_casing/strilka310/anti_khara/smart
	name = ".310 Strilka smart anti-Khara bullet casing"
	desc = "A .310 Strilka propellant block with embedded micro-guidance tuned to Khara signatures."
	icon_state = "310-casing"
	projectile_type = /obj/projectile/bullet/anti_khara/smart
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.4,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.6
	)
	anti_khara = TRUE

/obj/item/ammo_casing/strilka310/anti_khara/smart/ready_proj(atom/target, mob/living/user, quiet, zone_override, atom/fired_from)
	if(is_khara_creature(target))
		loaded_projectile.set_homing_target(target)
		new /obj/effect/temp_visual/smartgun_target(get_turf(target))
	return ..()

/obj/item/ammo_casing/a223/anti_khara
	name = ".223 anti-Khara bullet casing"
	desc = "A .223 bullet casing loaded with payload engineered to degrade Khara-infected tissue."
	icon_state = "223-casing"
	projectile_type = /obj/projectile/bullet/anti_khara
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.0,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.9
	)
	anti_khara = TRUE

/obj/item/ammo_casing/a223/anti_khara/smart
	name = ".223 smart anti-Khara bullet casing"
	desc = "A .223 round with integrated targeting electronics for Khara priority targets."
	icon_state = "223-casing"
	projectile_type = /obj/projectile/bullet/anti_khara/smart
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.2,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.4
	)
	anti_khara = TRUE

/obj/item/ammo_casing/a223/anti_khara/smart/ready_proj(atom/target, mob/living/user, quiet, zone_override, atom/fired_from)
	if(is_khara_creature(target))
		loaded_projectile.set_homing_target(target)
		new /obj/effect/temp_visual/smartgun_target(get_turf(target))
	return ..()

/**
 * ПУЛЕМЁТНЫЙ КАЛИБР
 */

/obj/item/ammo_casing/m7mm/anti_khara
	name = "7mm anti-Khara bullet casing"
	desc = "A 7mm bullet casing loaded with specialized compound to disrupt and degrade Khara biomass."
	icon_state = "762-casing"
	projectile_type = /obj/projectile/bullet/anti_khara
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.1
	)
	anti_khara = TRUE

/obj/item/ammo_casing/m7mm/anti_khara/smart
	name = "7mm smart anti-Khara bullet casing"
	desc = "A 7mm round with micro-guidance electronics calibrated to seek out Khara biological signatures."
	icon_state = "762-casing"
	projectile_type = /obj/projectile/bullet/anti_khara/smart
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.7,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.7
	)
	anti_khara = TRUE

/obj/item/ammo_casing/m7mm/anti_khara/smart/ready_proj(atom/target, mob/living/user, quiet, zone_override, atom/fired_from)
	if(is_khara_creature(target))
		loaded_projectile.set_homing_target(target)
		new /obj/effect/temp_visual/smartgun_target(get_turf(target))
	return ..()



/datum/design/anti_khara_ammunition
	name = "Диск Анти-Кхара аммуниции"
	desc = "Диск наполненный обновленными данными для верстака печати патронов. Эта аммуниция может эффективно бороться с пораждениями Кхары."
	id = "anti_khara_ammunition"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/disk/ammo_workbench/advanced/anti_khara
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY


/obj/item/disk/ammo_workbench/advanced/anti_khara
	name = "диск боеприпасов типа 'Анти-Кхара'"
	desc = "Содержит данные по изготовлению особенных боеприпасов, что эффективно поражают создания Кхары - игнорируя обычных людей."

/obj/item/disk/ammo_workbench/advanced/anti_khara/on_bench_install(obj/machinery/ammo_workbench/bench)
	// bench.allowed_antikhara = TRUE
	bench.update_ammotypes()




/obj/item/gun/energy/anti_khara
	name = "Анти-Кхара бластер"
	desc = "Продвинутый энергетический бластер испускающую пучки энергии колебающиеся на особой частоте. \
			Тонкая настройка позволяет им атаковать исключительно абоминации Кхары - игнорируя другие живые цели."
	icon_state = "instagibgreen"
	inhand_icon_state = "instagibgreen"
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = list(
		/obj/item/ammo_casing/energy/anti_khara,
		/obj/item/ammo_casing/energy/anti_khara/smart,
	)
	cell_type = /obj/item/stock_parts/power_store/cell/high
	clumsy_check = FALSE
	selfcharge = TRUE
	self_charge_amount = 1000
	automatic_charge_overlays = FALSE


/obj/item/gun/energy/anti_khara/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2)

/obj/item/gun/energy/anti_khara/update_icon_state()
	. = ..()
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	if(istype(shot, /obj/item/ammo_casing/energy/anti_khara/smart))
		inhand_icon_state = "instagibblue"
		icon_state = "instagibblue"
	else
		inhand_icon_state = "instagibgreen"
		icon_state = "instagibgreen"

/obj/item/gun/energy/anti_khara/examine(mob/user)
	. = ..()
	. += span_hypnophrase("Это невероятное оружие. \n")

	if(selfcharge)
		. += span_boldnicegreen("Ядро оружие автоматически восстанавливает энергию в нем.")
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	if(istype(shot, /obj/item/ammo_casing/energy/anti_khara/smart))
		. += span_boldnotice("Включен умный режим стрельбы с доводкой по цели.")
	else
		. += span_boldnotice("Включен усиленный режим стрельбы с повышенным уроном.")



/obj/item/ammo_casing/energy/anti_khara
	projectile_type = /obj/projectile/energy/anti_khara
	select_name = "anti-khara"
	e_cost = LASER_SHOTS(100, STANDARD_CELL_CHARGE * 10)

/obj/item/ammo_casing/energy/anti_khara/smart
	projectile_type = /obj/projectile/energy/anti_khara/smart
	e_cost = LASER_SHOTS(30, STANDARD_CELL_CHARGE * 10)
	select_name = "smart anti-khara"

/obj/item/ammo_casing/energy/anti_khara/smart/ready_proj(atom/target, mob/living/user, quiet, zone_override, atom/fired_from)
	if(is_khara_creature(target))
		loaded_projectile.set_homing_target(target)
		new /obj/effect/temp_visual/smartgun_target(get_turf(target))
	return ..()



/obj/projectile/energy/anti_khara
	name = "anti-khara bolt"
	icon_state = "spell"
	damage = 0
	damage_type = BRUTE
	armor_flag = ENERGY
	impact_effect_type = /obj/effect/temp_visual/impact_effect/anti_khara

	var/smart = FALSE
	var/khara_damage = 45

/obj/projectile/energy/anti_khara/Initialize(mapload)
	. = ..()
	if(!smart)
		var/matrix/big = matrix()
		big.Scale(2, 2,)
		animate(src, transform = big, time = 3 SECONDS)

/obj/effect/temp_visual/impact_effect/anti_khara
	icon_state = "mech_toxin"
	duration = 5

/obj/effect/temp_visual/impact_effect/anti_khara/smart
	icon_state = "shieldsparkles"

/obj/projectile/energy/anti_khara/smart
	name = "anti-khara smart bolt"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/anti_khara/smart
	smart = TRUE
	khara_damage = 25
	range = 10
	homing_turn_speed = 10
	homing_inaccuracy_min = 1
	homing_inaccuracy_max = 1

/obj/projectile/energy/anti_khara/on_hit(atom/target, blocked = 0, pierce_hit)
	if(isliving(target))
		var/mob/living/L = target
		if(!is_khara_creature(L))
			return BULLET_ACT_FORCE_PIERCE
		else
			L.take_overall_damage(khara_damage)
	return ..()

/obj/projectile/energy/anti_khara/can_hit_target(atom/target, direct_target, ignore_loc, cross_failed)
	if(isliving(target))
		var/mob/living/L = target
		if(!is_khara_creature(L))
			return FALSE
	return ..()

/obj/projectile/energy/anti_khara/Bump(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!is_khara_creature(L))
			return FALSE
	return ..()


/datum/design/anti_khara_weapon
	id = "anti_khara_weapon_debug"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 15,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 1.5,
	)
	build_path = /obj/item/melee/anti_khara
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_MELEE
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SECURITY

/datum/design/anti_khara_weapon/sword
	id = "anti_khara_weapon_sword"
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 15,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/melee/anti_khara/sword

/datum/design/anti_khara_weapon/great_sword
	id = "anti_khara_weapon_greatsword"
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 25,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 5,
	)
	build_path = /obj/item/melee/anti_khara/great_sword

/datum/design/anti_khara_weapon/great_sword
	id = "anti_khara_weapon_spear"
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 8,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 1,
	)
	build_path = /obj/item/melee/anti_khara/spear


/// Я интегрировал компонент transormating в оружие, потому что да
/obj/item/melee/anti_khara
	name = "Анти-Кхара оружие"
	desc = "Специализированное оружие против созданий Кхары. Изготовлено из высокопрочного армированного титана с уникальным сплавом, \
			который позволяет наносить дополнительные разрушительные эффекты этим существам."
	icon = 'fenysha_events/icons/items/melee/anti_khara.dmi'
	lefthand_file = 'fenysha_events/icons/items/inhand/melee/anti_khara_left.dmi'
	righthand_file = 'fenysha_events/icons/items/inhand/melee/anti_khara_right.dmi'
	custom_materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3.5)
	item_flags = SLOWS_WHILE_IN_HAND | NEEDS_PERMIT
	resistance_flags = NONE
	force = 0
	throwforce = 0

	/// Развёрнуто ли оружие (активное состояние)
	var/deployed = FALSE

	var/active_force = 30
	var/khara_damage = 35
	var/active_throwforce = 30
	var/active_throw_speed = 3
	var/active_sharpness = SHARP_EDGED
	var/active_hitsound = 'sound/items/weapons/bladeslice.ogg'
	var/active_w_class = WEIGHT_CLASS_HUGE

	var/list/active_attack_verb_continuous = list("attacks", "slashes", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	var/list/active_attack_verb_simple = list("attack", "slash", "slice", "tear", "lacerate", "rip", "dice", "cut")

	var/force_off
	var/throwforce_off
	var/throw_speed_off
	var/w_class_off
	var/sharpness_off
	var/hitsound_off
	var/list/attack_verb_continuous_off
	var/list/attack_verb_simple_off

	var/special_des = \
	"Это — <b>Анти-Кхара оружие</b>. \
	Специальная настройка лезвия и уникальный сплав материала позволяют эффективно атаковать создания Кхары, \
	нанося им дополнительные повреждения и визуальные эффекты пробития."

/obj/item/melee/anti_khara/examine(mob/user)
	. = ..()
	. += span_notice("Альт. клик - для того, чтобы развернуть")
	. += span_notice(special_des)


/obj/item/melee/anti_khara/get_all_tool_behaviours()
	return list(TOOL_SAW)

/obj/item/melee/anti_khara/Initialize(mapload)
	. = ..()


	force_off = force
	throwforce_off = throwforce
	throw_speed_off = throw_speed
	w_class_off = w_class
	sharpness_off = sharpness
	hitsound_off = hitsound
	attack_verb_continuous_off = attack_verb_continuous?.Copy()
	attack_verb_simple_off = attack_verb_simple?.Copy()
	ADD_TRAIT(src, TRAIT_ALWAYS_PENETRAIT_KHARA, INNATE_TRAIT)

	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(
		/datum/component/butchering, \
		speed = 5 SECONDS, \
		butcher_sound = active_hitsound, \
	)

/obj/item/melee/anti_khara/update_icon_state()
	. = ..()
	if(deployed)
		icon_state = "[base_icon_state]_deployed"
		inhand_icon_state = icon_state
	else
		icon_state = base_icon_state
		inhand_icon_state = base_icon_state


/obj/item/melee/anti_khara/click_alt(mob/user)
	if(!istype(user) || loc != user || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return

	toggle_deploy(user)

/obj/item/melee/anti_khara/proc/toggle_deploy(mob/user)
	deployed = !deployed

	if(deployed)
		set_deployed()
	else
		set_undeployed()

	tool_behaviour = (deployed ? TOOL_SAW : NONE)

	if(user)
		balloon_alert(user, "[name] [deployed ? "развёрнуто" : "свёрнуто"]")

	update_appearance(UPDATE_ICON_STATE)

/obj/item/melee/anti_khara/proc/set_deployed()
	ADD_TRAIT(src, TRAIT_TRANSFORM_ACTIVE, REF(src))

	sharpness = active_sharpness
	force = active_force
	throwforce = active_throwforce
	throw_speed = active_throw_speed
	hitsound = active_hitsound
	update_weight_class(active_w_class)

	if(LAZYLEN(active_attack_verb_continuous))
		attack_verb_continuous = active_attack_verb_continuous
	if(LAZYLEN(active_attack_verb_simple))
		attack_verb_simple = active_attack_verb_simple

/obj/item/melee/anti_khara/proc/set_undeployed()
	REMOVE_TRAIT(src, TRAIT_TRANSFORM_ACTIVE, REF(src))

	sharpness = sharpness_off
	force = force_off
	throwforce = throwforce_off
	throw_speed = throw_speed_off
	hitsound = hitsound_off
	update_weight_class(w_class_off)

	if(LAZYLEN(attack_verb_continuous_off))
		attack_verb_continuous = attack_verb_continuous_off
	if(LAZYLEN(attack_verb_simple_off))
		attack_verb_simple = attack_verb_simple_off

/obj/item/melee/anti_khara/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	if(!deployed)
		return
	if(is_khara_creature(target) && isliving(target))
		var/mob/living/khara_mob = target
		khara_mob.take_overall_damage(khara_damage)
		new /obj/effect/temp_visual/impact_effect/anti_khara(get_turf(target))

/obj/item/melee/anti_khara/sword
	name = "Анти-кхара клинок"
	desc = "Длинный, элегантный клинок из усиленного титана с анти-кхара покрытием. \
			Рукоять идеально лежит в ладони, а лезвие издаёт тихий, угрожающий гул энергии. "
	base_icon_state = "sword"
	icon_state = "sword"
	inhand_icon_state = "sword"

	attack_speed = 1.3 SECONDS
	active_force = 20
	khara_damage = 20
	active_sharpness = 40
	active_throwforce = 20
	armour_penetration = 20
	wound_bonus = 20

/obj/item/melee/anti_khara/great_sword
	name = "Усиленный Анти-кхара клинок"
	desc = "Массивный двуручный клинок из титана и пластали, созданный для сокрушительных ударов. \
			Каждый взмах требует силы, но в развёрнутом состоянии он пробивает любую защиту созданий Кхары."
	base_icon_state = "greatsword"
	icon_state = "greatsword"
	inhand_icon_state = "greatsword"

	attack_speed = CLICK_CD_MELEE * 3
	demolition_mod = 3
	active_force = 40
	khara_damage = 50
	active_sharpness = 50
	active_throwforce = 30
	armour_penetration = 50
	wound_bonus = 45

	var/attack_cooldown = 2 SECONDS
	COOLDOWN_DECLARE(attack_cd)

#define CHECKFLAGS (IGNORE_USER_LOC_CHANGE|IGNORE_TARGET_LOC_CHANGE)

/obj/item/melee/anti_khara/great_sword/set_deployed()
	. = ..()
	slowdown = 1

/obj/item/melee/anti_khara/great_sword/set_undeployed()
	. = ..()
	slowdown = initial(slowdown)

/obj/item/melee/anti_khara/great_sword/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!deployed)
		return FALSE

	if(!COOLDOWN_FINISHED(src, attack_cd))
		return FALSE

	user.adjust_stamina_loss(5)
	new /obj/effect/temp_visual/telegraphing/boss_hit(get_turf(target_mob))
	if(!do_after(user, 0.5 SECONDS, target_mob, CHECKFLAGS, \
		extra_checks = CALLBACK(src, PROC_REF(check_adjacent), user, target_mob), \
		max_interact_count = 1))

		user.adjust_stamina_loss(15)
		COOLDOWN_START(src, attack_cd, 0.5 SECONDS)
		return FALSE
	if(!user.Adjacent(target_mob))
		return FALSE

	. = ..()
	if(.)
		user.Knockdown()
		user.visible_message(span_warning("[user] валится на пол, провалив тяжёлый взмах [src]!"))
		return

	COOLDOWN_START(src, attack_cd, attack_cooldown)
	target_mob.Knockdown()
	target_mob.Stun(1 SECONDS)
	user.adjust_stamina_loss(20)

#undef CHECKFLAGS

/obj/item/melee/anti_khara/great_sword/proc/check_adjacent(mob/living/user, mob/living/target_mob)
	if(!deployed)
		return FALSE
	if(QDELETED(user) || QDELETED(target_mob))
		return FALSE
	if(!user.Adjacent(target_mob))
		return FALSE
	return TRUE

/obj/item/melee/anti_khara/spear
	name = "Анти-кхара копьё"
	desc = "Лёгкое, идеально сбалансированное копьё с длинным острым наконечником из специального анти-кхара сплава. \
			Позволяет атаковать на расстоянии, нанося точные колющие удары, которые особенно эффективны против созданий Кхары."
	base_icon_state = "spear"
	icon_state = "spear"
	inhand_icon_state = "spear"

	attack_speed = CLICK_CD_MELEE * 2
	active_force = 15
	reach = 2
	khara_damage = 15
	armour_penetration = 50
	wound_bonus = 20

/obj/item/melee/anti_khara/spear/set_deployed()
	. = ..()
	reach = 2

/obj/item/melee/anti_khara/spear/set_undeployed()
	. = ..()
	reach = 1

/obj/item/melee/baseball_bat/metal
	name = "metal baseball bat"
	desc = "This bat is made of highly armored material."
	icon_state = "baseball_bat_metal"
	inhand_icon_state = "baseball_bat_metal"
	custom_materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3.5)
	resistance_flags = NONE
	force = 25
	throwforce = 25
	mob_thrower = FALSE
	block_sound = 'sound/items/weapons/effects/batreflect.ogg'

/datum/design/anti_khara_grenade
	id = "anti_khara_grenade"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 1,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 1.5,
	)
	build_path = /obj/item/grenade/anti_khara
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/obj/item/grenade/anti_khara
	name = "Анти-Кхара граната"
	desc = "Экстремально эффективная граната испускающая низко-волновую радиацию, что эффективно пораждает клетки Кхары."
	icon_state = "timeg"
	inhand_icon_state = "emp"

/obj/item/grenade/anti_khara/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return
	var/turf/kaboom_turf = get_turf(src)

	for(var/atom/movable/AM in circle_range(kaboom_turf, 4))
		new /obj/effect/temp_visual/impact_effect/anti_khara(get_turf(AM))
		if(is_khara_creature(AM))
			var/mob/living/khara_mutant= AM
			var/dist = get_dist(kaboom_turf, AM)

			khara_mutant.take_overall_damage(round(150 / dist), round(50 / dist), 45)
			to_chat(khara_mutant, span_userdanger("Энергетическая волна - терзает твое тело!"))

	qdel(src)
