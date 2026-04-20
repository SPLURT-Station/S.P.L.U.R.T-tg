/obj/effect/mob_spawn/corpse/human/syndicate
	name = "Syndicate Agent Corpse"
	outfit = /datum/outfit/syndicateagent

/datum/outfit/syndicateagent
	name = "Syndicate Agent"

	uniform = /obj/item/clothing/under/rank/syndicate/turtleneck
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/syndicateciv
	head = /obj/item/clothing/head/soft/sec/syndicate_cap
	mask = /obj/item/clothing/mask/gas/syndicate
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/corpse/agent
	implants = list(/obj/item/implant/weapons_auth)

/datum/id_trim/syndicom/corpse/agent
	assignment = "Syndicate Agent"
	trim_state = "trim_syndicate"
	department_color = COLOR_SYNDIE_RED
	subdepartment_color = COLOR_SYNDIE_RED
	sechud_icon_state = SECHUD_SYNDICATE
	access = list(ACCESS_SYNDICATE)

/obj/effect/mob_spawn/corpse/human/syndicate/operative
	name = "Syndicate Defense Operative Corpse"
	outfit = /datum/outfit/syndicateoperative

/datum/outfit/syndicateoperative
	name = "Syndicate Defense Operative"

	uniform = /obj/item/clothing/under/rank/syndicate/operative
	suit = /obj/item/clothing/suit/armor/vest/syndicate
	belt = /obj/item/storage/belt/military/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat
	ears = /obj/item/radio/headset/syndicateciv
	head = /obj/item/clothing/head/helmet/swat/syndicate
	mask = /obj/item/clothing/mask/gas/sechailer/syndicate
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/corpse/agent
	implants = list(/obj/item/implant/weapons_auth)

/datum/id_trim/syndicom/corpse/operative
	assignment = "Syndicate Defense Operative"
	trim_state = "trim_syndicate"
	department_color = COLOR_SYNDIE_RED
	subdepartment_color = COLOR_SECURITY_RED
	sechud_icon_state = SECHUD_SYNDICATE
	access = list(ACCESS_SYNDICATE, ACCESS_WEAPONS)
