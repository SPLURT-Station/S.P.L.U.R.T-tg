/obj/item/disk/bitrunning/ability/tier0
	name = "bitrunning program: cantrip"
	selectable_actions = list(
		/datum/action/cooldown/spell/shapeshift/minor_illusion,
		/datum/action/cooldown/spell/conjure_item/fire,
		/datum/action/cooldown/spell/conjure_item/water,
		/datum/action/cooldown/spell/conjure/cheese,
	)

/obj/item/disk/bitrunning/item/tier0
	name = "bitrunning gear: trinket"
	selectable_items = list(
		/obj/item/binoculars,
		/obj/item/stack/marker_beacon/thirty,
		/obj/item/storage/belt/military/snack/full,
		/obj/item/dice/d20,
		/obj/item/storage/pouch/medical/firstaid/stabilizer,
		/obj/item/storage/pouch/cin_medkit,
		/obj/item/storage/medkit/robotic_repair/preemo/stocked,
	)

/datum/orderable_item/bitrunning_tech/ability_tier0
	cost_per_order = 350
	purchase_path = /obj/item/disk/bitrunning/ability/tier0
	desc = "This disk contains a program that lets you cast Minor Illusion, Summon Cheese, Produce Flame, or Produce Water."

/datum/orderable_item/bitrunning_tech/item_tier0
	cost_per_order = 350
	purchase_path = /obj/item/disk/bitrunning/item/tier0
	desc = "This disk contains a program that lets you equip a pair of binoculars, thirty marker beacons, a snack rig, a D20, a stabilizer pouch, a robotic repair kit, or an empty colonial first-aid pouch."

/obj/item/disk/bitrunning/item/tierrelax
	name = "bitrunning gear: relaxation"
	selectable_items = list(
		/obj/item/summon_beacon/relax,
		/obj/item/storage/box/nif_ghost_box,
		/obj/item/storage/box/syndie_kit/chameleon/ghostcafe,
		/obj/item/survivalcapsule/luxury,
	)

/obj/item/summon_beacon/relax
	name = "relaxation machine beacon"
	icon_state = "sb_delivery"
	desc = "Once a vending machine is selected, delivers it to the target location."

	allowed_areas = list(
		/area/virtual_domain,
		/area/space/virtual_domain,
		/area/ruin/space/virtual_domain,
		/area/icemoon/underground/explored/virtual_domain,
		/area/lavaland/surface/outdoors/virtual_domain,
	)

	selectable_atoms = list(
		/obj/machinery/vending/autodrobe/bitrunning, // "AutoDrobe"
		/obj/machinery/vending/games/bitrunning, // "Good Clean Fun"
		/obj/machinery/vending/clothing/bitrunning, // "ClothesMate"
	)

	area_string = "virtual domains"
	supply_pod_stay = FALSE

/obj/item/summon_beacon/relax/equipped(mob/user, slot, initial)
	. = ..()
	if (!CONFIG_GET(flag/disable_erp_preferences) && user?.client?.prefs.read_preference(/datum/preference/toggle/master_erp_preferences))
		selectable_atoms += /obj/machinery/vending/dorms/bitrunning
	else
		selectable_atoms -= /obj/machinery/vending/dorms/bitrunning

/obj/item/storage/toolbox/guncase/wt550
	name = "wt-550 gun case"
	weapon_to_spawn = /obj/item/gun/ballistic/automatic/wt550
	extra_to_spawn = /obj/item/ammo_box/magazine/wt550m9


// Be warned, ye who dares to optimize the following bit of code, Initialize is required for vendors to be all_products_free = TRUE, for the code designed for circuits actually resets the value on iniitialize otherwise. be warned and do not spend hours debugging as your predecesors had.

/obj/machinery/vending/dorms/bitrunning/Initialize(mapload)
	. = ..()
	all_products_free = TRUE
	onstation = FALSE

/obj/machinery/vending/autodrobe/bitrunning/Initialize(mapload)
	. = ..()
	all_products_free = TRUE
	onstation = FALSE

/obj/machinery/vending/games/bitrunning/Initialize(mapload)
	. = ..()
	all_products_free = TRUE
	onstation = FALSE

/obj/machinery/vending/clothing/bitrunning/Initialize(mapload)
	. = ..()
	all_products_free = TRUE
	onstation = FALSE

/datum/orderable_item/bitrunning_tech/item_tierrelax
	cost_per_order = 250
	purchase_path = /obj/item/disk/bitrunning/item/tierrelax
	desc = "This disk contains a program that lets you equip a delivery beacon of vending machines aimed to help to relax, a quick-booting NIF package, a luxury survival capsule, or a set of chameleon clothing."

/obj/item/disk/bitrunning/item/tier1/Initialize(mapload)
	. = ..()
	selectable_items += list(
		/obj/item/storage/belt/military,
		/obj/item/book_of_babel,
		/obj/item/storage/toolbox/syndicate,
		/obj/item/knife/combat,
	)

/obj/item/disk/bitrunning/item/tier2/Initialize(mapload)
	. = ..()
	selectable_items -= list(
		/obj/item/gun/ballistic/automatic/pistol,
	)
	selectable_items += list(
		/obj/item/storage/toolbox/guncase/clandestine,
		/obj/item/storage/toolbox/guncase/wt550,
		/obj/item/autosurgeon/syndicate/hackerman/bitrunning,
		/obj/item/clothing/head/helmet,
		/obj/item/melee/energy/sword/saber/blue,
		/obj/item/storage/medkit/expeditionary,
		/obj/item/katana,
		/obj/item/shield/riot/tele,
		/obj/item/gun/energy/modular_laser_rifle/carbine,
		/obj/item/syndicate_contacts,
	)

/obj/item/autosurgeon/syndicate/hackerman/bitrunning
	name = "hacking arm implanter"

/obj/item/disk/bitrunning/item/tier3/Initialize(mapload)
	. = ..()
	selectable_items -= list(
		/obj/item/gun/energy/e_gun/nuclear,
	)
	selectable_items += list(
		/obj/item/autosurgeon/syndicate/nodrop/bitrunning,
		/obj/item/gun/energy/modular_laser_rifle,
		/obj/item/minigunpack,
	)

/obj/item/autosurgeon/syndicate/nodrop/bitrunning
	name = "anti-drop implanter"

/obj/item/disk/bitrunning/ability/tier1/Initialize(mapload)
	. = ..()
	selectable_actions += list(
		/datum/action/cooldown/spell/touch/lay_on_hands,
		/datum/action/cooldown/spell/conjure/flare,
	)
	selectable_actions -= list(
		/datum/action/cooldown/spell/conjure/cheese,
	)

/obj/item/disk/bitrunning/ability/tier2/Initialize(mapload)
	. = ..()
	selectable_actions += list(
		/datum/action/cooldown/adrenaline,
		/datum/action/cooldown/spell/charge,
		/datum/action/cooldown/mob_cooldown/dash,
		/datum/action/cooldown/spell/teleport/radius_turf/blink/bitrunning,
		/datum/action/cooldown/spell/tap/bitrunning,
		/datum/action/cooldown/spell/summonitem,
	)

/datum/action/cooldown/spell/tap/bitrunning
	name = "Data Tap"
	desc = "Resets all spell cooldowns but weakens your connection, lowering your avatar's max health when used."
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/teleport/radius_turf/blink/bitrunning
	name = "Corrupt Position"
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	invocation = "CEE'OCEE TEH-HALL!" // coc testinghall
	desc = "Randomly teleports you a short distance. May prove unreliable in cramped areas or near domain limits."

/datum/action/cooldown/spell/chuuni_invocations/bitrunning
	name = "Slice of Life Data Torrent"
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/obj/item/disk/bitrunning/ability/tier3/Initialize(mapload)
	. = ..()
	selectable_actions += list(
		/datum/action/cooldown/spell/shapeshift/juggernaut,
		/datum/action/cooldown/spell/shapeshift/wraith,
		/datum/action/cooldown/spell/death_loop,
		/datum/action/cooldown/spell/chuuni_invocations/bitrunning,
	)

/datum/orderable_item/bitrunning_tech/item_tier1
	desc = "This disk contains a program that lets you equip a medical beamgun, a C4 explosive, a box of infinite pizza, a tactical toolbox, a combat knife, or a military webbing."

/datum/orderable_item/bitrunning_tech/item_tier2
	desc = "This disk contains a program that lets you equip a luxury medipen, a pistol case, a rifle case, an armour vest, a helmet, an energy sword, a katana, a modular laser carbine, an expeditionary medkit, a ballistic shield, flashproof contacts, or a hacker implant."

/datum/orderable_item/bitrunning_tech/item_tier3
	desc = "This disk contains a program that lets you equip a Hyeseong laser rifle, a laser minigun pack, a dual bladed energy sword, a minibomb, or an anti-drop implanter."

/datum/orderable_item/bitrunning_tech/ability_tier1
	desc = "This disk contains a program that lets you cast Summon Light Source, Lesser Heal, or Mending Touch."

/datum/orderable_item/bitrunning_tech/ability_tier2
	desc = "This disk contains a program that lets you cast Fireball, Lightning Bolt, Forcewall, Adrenaline Rush, Dash, Blink, Data Tap, Instant Summons, or Charge Item."

/datum/orderable_item/bitrunning_tech/ability_tier3
	desc = "This disk contains a program that lets you shapeshift into a lesser ashdrake, a polar bear, a holy juggernaut, or a holy wraith; or learn Death Loop or Chuuni Invocations."
