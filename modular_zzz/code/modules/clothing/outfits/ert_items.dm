/obj/item/storage/box/centcom
	name = "box"
	desc = "It's just an ordinary box."
	icon_state = "internals_large"

/obj/item/storage/box/centcom/PopulateContents()
	var/static/items_inside = list(
		/obj/item/clothing/mask/gas/sechailer = 1,
		/obj/item/tank/internals/emergency_oxygen/double = 1,
		/obj/item/reagent_containers/hypospray/medipen/atropine = 2,
		/obj/item/reagent_containers/hypospray/medipen/salacid = 1,
		/obj/item/pinpointer/nuke = 1,
		/obj/item/crowbar/power/syndicate = 1,
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/m223_ammo
	name = "box with ammo"
	icon_state = "secbox"

/obj/item/storage/box/m223_ammo/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/m223 = 7,
		)
	generate_items_inside(items_inside,src)

/obj/item/melee/energy/sword/ert
	name = "Standart Energy Sword"
	desc = "To serve the Mega-Corporation."
	light_color = "#2d7ea1"
	sword_color_icon = "blue"

/obj/item/storage/belt/military/ert_min/PopulateContents()
	new /obj/item/knife/combat(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)

/obj/item/storage/belt/military/ert_max/PopulateContents()
	new /obj/item/melee/energy/sword/ert(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)

/obj/item/storage/medkit/tactical/premium/ert
	name = "ERT Medical Kit"
	desc = "May or may not contain traces of lead."
	icon_state = "medkit_tactical_premium"
	inhand_icon_state = "medkit-tactical-premium"
	grind_results = list(/datum/reagent/lead = 10)
	storage_type = /datum/storage/medkit/tactical/premium

/obj/item/storage/medkit/tactical/premium/ert/PopulateContents()
	if(empty)
		return
	var/static/list/items_inside = list(
		/obj/item/healthanalyzer/advanced = 1,
		/obj/item/stack/medical/suture/medicated = 2,
		/obj/item/stack/medical/mesh/advanced = 2,
		/obj/item/reagent_containers/applicator/patch/synthflesh = 12,
		/obj/item/storage/pill_bottle/penacid = 1,
		/obj/item/reagent_containers/hypospray/combat/nanites = 1,
		/obj/item/stack/medical/gauze = 2,
		/obj/item/storage/box/bandages = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/clothing/suit/space/ntrauma/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/gun/ballistic,
		/obj/item/gun/energy,
		/obj/item/knife/combat,
		/obj/item/melee/baton,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/restraints/handcuffs,
		/obj/item/storage/belt/holster/detective,
		/obj/item/storage/belt/holster/nukie,
		/obj/item/storage/belt/holster/energy,
		/obj/item/gun/ballistic/shotgun/automatic/combat/compact,
		/obj/item/pen/red/security,
		/obj/item/gun/microfusion,
	)
