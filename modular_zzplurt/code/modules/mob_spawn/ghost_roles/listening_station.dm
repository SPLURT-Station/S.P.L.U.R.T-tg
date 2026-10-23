/obj/effect/mob_spawn/ghost_role/human/lavaland_syndicate/comms/splurt
	name = "MI13 Communications Agent"
	prompt_name = "a MI13 comms agent"
	you_are_text = "You are a syndicate agent from MI13, assigned to a small listening post station situated near your hated enemy's top secret research facility: Space Station 13."
	flavour_text = "Monitor enemy activity as best you can, and try to keep a low profile. Use the communication equipment to provide support to any field agents, and sow disinformation to throw Nanotrasen off your trail. Do not let the base fall into enemy hands!"
	important_text = "DO NOT abandon the base, you are not an antag. You however are free to defend yourself and your base."
	outfit = /datum/outfit/lavaland_syndicate/comms/mi13
	icon = 'modular_skyrat/modules/cryosleep/icons/cryogenics.dmi'
	icon_state = "cryopod"

/obj/effect/mob_spawn/ghost_role/human/lavaland_syndicate/comms/splurt/Destroy()
	new /obj/machinery/cryopod(drop_location())
	return ..()

/datum/outfit/lavaland_syndicate/comms/mi13
	name = "MI13 Communications Agent"
	id = /obj/item/card/id/advanced/chameleon/elite/black
	id_trim = /datum/id_trim/chameleon/operative/mi13/comms
	uniform = /obj/item/clothing/under/syndicate/skyrat/tactical
	suit = /obj/item/clothing/suit/hooded/wintercoat/skyrat/syndicate
	suit_store = /obj/item/gun/ballistic/automatic/pistol/clandestine
	mask = /obj/item/clothing/mask/chameleon/gps
	back = /obj/item/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset/syndicate/alt
	shoes = /obj/item/clothing/shoes/combat
	l_pocket = /obj/item/melee/energy/sword/saber/red
	belt = /obj/item/storage/belt/utility/full/powertools
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/black
	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/lavaland_syndicate/comms/mi13/post_equip(mob/living/carbon/human/syndicate, visuals_only = FALSE)
	syndicate.add_faction(ROLE_SYNDICATE)

/datum/id_trim/chameleon/operative/mi13
	assignment = "MI13 Operative"

/datum/id_trim/chameleon/operative/mi13/comms
	assignment = "MI13 Communications Agent"
	department_color = COLOR_SYNDIE_RED
	subdepartment_color = COLOR_SYNDIE_RED_HEAD
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SYNDICATE, ACCESS_ROBOTICS)
