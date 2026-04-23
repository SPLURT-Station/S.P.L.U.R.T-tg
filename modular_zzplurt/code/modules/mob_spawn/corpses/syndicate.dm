/obj/effect/mob_spawn/corpse/human/syndicate
	name = "Syndicate Agent Corpse"
	hairstyle = "Crewcut"
	facial_hairstyle = "Shaved"
	gender = MALE
	outfit = /datum/outfit/syndicateagent

/datum/outfit/syndicateagent
	name = "Syndicate Agent"

	uniform = /obj/item/clothing/under/rank/syndicate/turtleneck
	belt = /obj/item/modular_computer/pda/syndicate_real
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/syndicateciv
	head = /obj/item/clothing/head/soft/sec/syndicate_cap
	mask = /obj/item/clothing/mask/gas/syndicate
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/corpse/agent
	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/syndicateagent/post_equip(mob/living/carbon/human/syndicate, visualsOnly = FALSE)
	var/obj/item/card/id/id_card = syndicate.wear_id
	if(istype(id_card))
		id_card.registered_name = syndicate.real_name
		id_card.update_label()
		id_card.update_icon()
	handlebank(syndicate)
	return ..()

/datum/id_trim/syndicom/corpse/agent
	assignment = "Syndicate Agent"
	trim_state = "trim_syndicate"
	department_color = COLOR_SYNDIE_RED
	subdepartment_color = COLOR_SYNDIE_RED
	sechud_icon_state = SECHUD_SYNDICATE
	access = list(ACCESS_SYNDICATE)

/obj/effect/mob_spawn/corpse/human/syndicate/operative
	name = "Syndicate Defense Operative Corpse"
	outfit = /datum/outfit/syndicatedefenseoperative

/datum/outfit/syndicatedefenseoperative
	name = "Syndicate Defense Operative"

	uniform = /obj/item/clothing/under/rank/syndicate/operative
	suit = /obj/item/clothing/suit/armor/vest/syndicate
	belt = /obj/item/storage/belt/military/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat
	ears = /obj/item/radio/headset/syndicateciv
	head = /obj/item/clothing/head/beret/sec/syndicate_operative
	mask = /obj/item/clothing/mask/gas/syndicate
	back = /obj/item/storage/backpack/satchel/sec/redsec
	r_pocket = /obj/item/modular_computer/pda/syndicate_real
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/corpse/operative
	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/syndicatedefenseoperative/post_equip(mob/living/carbon/human/syndicate, visualsOnly = FALSE)
	var/obj/item/card/id/id_card = syndicate.wear_id
	if(istype(id_card))
		id_card.registered_name = syndicate.real_name
		id_card.update_label()
		id_card.update_icon()
	handlebank(syndicate)
	return ..()

/datum/id_trim/syndicom/corpse/operative
	assignment = "Syndicate Defense Operative"
	trim_state = "trim_syndicate"
	department_color = COLOR_SYNDIE_RED
	subdepartment_color = COLOR_SECURITY_RED
	sechud_icon_state = SECHUD_SYNDICATE
	access = list(ACCESS_SYNDICATE, ACCESS_WEAPONS)

/obj/effect/mob_spawn/corpse/human/syndicate/operative/assault
	name = "Syndicate Assault Operative Corpse"
	outfit = /datum/outfit/syndicateassaultoperative

/datum/outfit/syndicateassaultoperative
	name = "Syndicate Assault Operative"

	uniform = /obj/item/clothing/under/rank/syndicate/operative/tactical
	suit = /obj/item/clothing/suit/armor/vest/syndicate
	belt = /obj/item/storage/belt/military/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset/syndicateciv
	head = /obj/item/clothing/head/helmet/swat/syndicate
	mask = /obj/item/clothing/mask/gas/sechailer/syndicate
	back = /obj/item/storage/backpack/satchel/sec/redsec
	r_pocket = /obj/item/modular_computer/pda/syndicate_real
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/corpse/operative/assault
	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/syndicateassaultoperative/post_equip(mob/living/carbon/human/syndicate, visualsOnly = FALSE)
	var/obj/item/card/id/id_card = syndicate.wear_id
	if(istype(id_card))
		id_card.registered_name = syndicate.real_name
		id_card.update_label()
		id_card.update_icon()
	handlebank(syndicate)
	return ..()

/datum/id_trim/syndicom/corpse/operative/assault
	assignment = "Syndicate Assault Operative"
	department_color = COLOR_SYNDIE_RED
	subdepartment_color = COLOR_SYNDIE_RED_HEAD

/obj/effect/mob_spawn/corpse/human/syndicate/lieutenant
	name = "Syndicate Executive Officer Corpse"
	outfit = /datum/outfit/syndicatelieutenant

/datum/outfit/syndicatelieutenant
	name = "Syndicate Executive Officer"

	uniform = /obj/item/clothing/under/rank/syndicate/lieutenant
	suit = /obj/item/clothing/suit/armor/syndicate_overcoat/fake
	belt = /obj/item/modular_computer/pda/syndicate_real
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset/syndicateciv/command/empty
	head = /obj/item/clothing/head/beret/syndicate_lieutenant/fake
	mask = /obj/item/clothing/mask/gas/syndicate
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/corpse/lieutenant
	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/syndicatelieutenant/post_equip(mob/living/carbon/human/syndicate, visualsOnly = FALSE)
	var/obj/item/card/id/id_card = syndicate.wear_id
	if(istype(id_card))
		id_card.registered_name = syndicate.real_name
		id_card.update_label()
		id_card.update_icon()
	handlebank(syndicate)
	return ..()

/datum/id_trim/syndicom/corpse/lieutenant
	assignment = "Syndicate Executive Officer"
	trim_state = "trim_syndicate"
	department_color = COLOR_SYNDIE_RED_HEAD
	subdepartment_color = COLOR_SYNDIE_RED
	sechud_icon_state = SECHUD_SYNDICATE_HEAD
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER, ACCESS_WEAPONS)

/obj/effect/mob_spawn/corpse/human/syndicate/captain
	name = "Syndicate Commanding Officer Corpse"
	outfit = /datum/outfit/syndicatecaptain

/datum/outfit/syndicatecaptain
	name = "Syndicate Commanding Officer"

	uniform = /obj/item/clothing/under/rank/syndicate/captain
	suit = /obj/item/clothing/suit/armor/syndicate_greatcoat/fake
	belt = /obj/item/modular_computer/pda/syndicate_real
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset/syndicateciv/command/empty
	head = /obj/item/clothing/head/hats/syndicate_cap/fake
	mask = /obj/item/clothing/mask/gas/syndicate
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced/black/syndicate_command
	id_trim = /datum/id_trim/syndicom/corpse/captain
	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/syndicatecaptain/post_equip(mob/living/carbon/human/syndicate, visualsOnly = FALSE)
	var/obj/item/card/id/id_card = syndicate.wear_id
	if(istype(id_card))
		id_card.registered_name = syndicate.real_name
		id_card.update_label()
		id_card.update_icon()
	handlebank(syndicate)
	return ..()

/datum/id_trim/syndicom/corpse/captain
	assignment = "Syndicate Commanding Officer"
	trim_state = "trim_captain"
	department_color = COLOR_SYNDIE_RED_HEAD
	subdepartment_color = COLOR_SYNDIE_RED_HEAD
	sechud_icon_state = SECHUD_SYNDICATE_HEAD
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER, ACCESS_WEAPONS)

