#define ROLE_LZGAS "Lizard Gas Station Manager"

/obj/effect/mob_spawn/ghost_role/human/lavaland_gasstation
	name = "Gas Station Attendant"
	desc = "Seems like there's somebody inside, peacefully sleeping."
	prompt_name = "a gas station worker"
	outfit = /datum/outfit/lavaland_gasstation

/obj/effect/mob_spawn/ghost_role/human/lavaland_gasstation/manager
	name = "Gas Station Manager"
	prompt_name = "a gas station manager"
	outfit = /datum/outfit/lavaland_gasstation/manager
	you_are_text = "You are the manager of a Lizard's Gas Station close to a mining facility."
	flavour_text = "Graduating the Lizard's Gas prestigious university, whether by bad luck or poor decision on your part, you are now managing the most dangerous establishment!."

/datum/outfit/lavaland_gasstation
	name = "Lizard Gas Station Attendant"
	uniform = /obj/item/clothing/under/costume/lizardgas
	shoes = /obj/item/clothing/shoes/sneakers/black
	ears = /obj/item/instrument/piano_synth/headphones
	gloves = /obj/item/clothing/gloves/fingerless
	head = /obj/item/clothing/head/soft/purple
	l_pocket = /obj/item/modular_computer/pda
	id = /obj/item/card/id/advanced/lizardgas

/datum/outfit/lavaland_gasstation/manager
	name = "Lizard Gas Station Manager"
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/crowbar = 1,
		/obj/item/knife/combat/survival = 1,
		/obj/item/gun/ballistic/automatic/pistol/m1911 = 1,
		/obj/item/ammo_box/magazine/m45 = 3,
		)

