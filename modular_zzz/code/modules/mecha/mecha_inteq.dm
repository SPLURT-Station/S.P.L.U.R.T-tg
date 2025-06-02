// Mech Beacon
/obj/item/choice_beacon/inteq_mech
	name = "InteQ mech beacon"
	desc = "To summon your own steel titan."

/obj/item/choice_beacon/inteq_mech/generate_display_names()
	var/static/list/ert_mech_list = list("Hermes" = /obj/vehicle/sealed/mecha/gygax/dark/hermes/loaded,
		"Ares" = /obj/vehicle/sealed/mecha/marauder/mauler/ares/loaded)
	if(!ert_mech_list)
		ert_mech_list = list()
		var/list/templist = typesof(/obj/item/storage/box/hero)
		for(var/V in templist)
			var/atom/A = V
			ert_mech_list[initial(A.name)] = A
	return ert_mech_list

///InteQ "Durand" Mecha
/obj/vehicle/sealed/mecha/marauder/mauler/ares
	desc = "Бог Войны среди Мехов. Разработки Солнечной Федерации дали нам Ареса. Бронированная машина будет давить ваших врагов."
	name = "\improper MIB-02 Ares"
	icon = 'modular_zzz/icons/obj/mecha/ares.dmi'
	icon_state = "ares"
	base_icon_state = "ares"
	ui_theme = "inteq"
	accesses = list(ACCESS_CENT_GENERAL)
	wreckage = /obj/structure/mecha_wreckage/ares

/obj/vehicle/sealed/mecha/marauder/mauler/ares/generate_actions()
	. = ..()
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_smoke)

////

/obj/vehicle/sealed/mecha/marauder/mauler/ares/loaded
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/radio, /obj/item/mecha_parts/mecha_equipment/air_tank/full, /obj/item/mecha_parts/mecha_equipment/thrusters/ion),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(/obj/item/mecha_parts/mecha_equipment/armor/antiproj_armor_booster),
	)

/obj/vehicle/sealed/mecha/marauder/mauler/ares/loaded/Initialize(mapload)
	. = ..()
	max_ammo()

/obj/vehicle/sealed/mecha/marauder/mauler/ares/loaded/populate_parts()
	cell = new /obj/item/stock_parts/power_store/cell/bluespace(src)
	scanmod = new /obj/item/stock_parts/scanning_module/triphasic(src)
	capacitor = new /obj/item/stock_parts/capacitor/quadratic(src)
	servo = new /obj/item/stock_parts/servo/femto(src)
	update_part_values()

////

/obj/structure/mecha_wreckage/ares
	name = "\improper MIB-02 Ares wreckage"
	icon = 'modular_zzz/icons/obj/mecha/ares.dmi'
	icon_state = "ares-broken"
	parts = list(
			/obj/item/mecha_parts/part/durand_torso,
			/obj/item/mecha_parts/part/durand_head,
			/obj/item/mecha_parts/part/durand_left_arm,
			/obj/item/mecha_parts/part/durand_right_arm,
			/obj/item/mecha_parts/part/durand_left_leg,
			/obj/item/mecha_parts/part/durand_right_leg)

///InteQ "Gygax" Mecha
/obj/vehicle/sealed/mecha/gygax/dark/hermes
	desc = "Отличный выбор для быстрых атак. Разработки Солнечной Федерации позволили нападать с флангов на металлической коннице. Гермес незаменим d своей маневренности и скорости."
	name = "\improper MIB-01 Hermes"
	base_icon_state = "hermes"
	icon = 'modular_zzz/icons/obj/mecha/hermes.dmi'
	icon_state = "hermes"
	ui_theme = "inteq"
	accesses = list(ACCESS_CENT_GENERAL)
	wreckage = /obj/structure/mecha_wreckage/hermes
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/radio, /obj/item/mecha_parts/mecha_equipment/air_tank/full, /obj/item/mecha_parts/mecha_equipment/thrusters/ion),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(/obj/item/mecha_parts/mecha_equipment/armor/antiemp_armor_booster/clandestine),
	)

/obj/vehicle/sealed/mecha/gygax/dark/hermes/generate_actions()
	. = ..()
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_smoke)

/obj/structure/mecha_wreckage/hermes
	name = "\improper MIB-01 Hermes wreckage"
	icon = 'modular_zzz/icons/obj/mecha/hermes.dmi'
	icon_state = "hermes-broken"
	parts = list(
			/obj/item/mecha_parts/part/durand_torso,
			/obj/item/mecha_parts/part/durand_head,
			/obj/item/mecha_parts/part/durand_left_arm,
			/obj/item/mecha_parts/part/durand_right_arm,
			/obj/item/mecha_parts/part/durand_left_leg,
			/obj/item/mecha_parts/part/durand_right_leg)

/obj/vehicle/sealed/mecha/gygax/dark/hermes/loaded/Initialize(mapload)
	. = ..()
	max_ammo()

/obj/vehicle/sealed/mecha/gygax/dark/hermes/loaded/populate_parts()
	cell = new /obj/item/stock_parts/power_store/cell/bluespace(src)
	scanmod = new /obj/item/stock_parts/scanning_module/triphasic(src)
	capacitor = new /obj/item/stock_parts/capacitor/quadratic(src)
	servo = new /obj/item/stock_parts/servo/femto(src)
	update_part_values()
