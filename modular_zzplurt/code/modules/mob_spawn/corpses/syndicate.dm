/obj/effect/mob_spawn/corpse/human/syndicateofficer
	name = "Syndicate Officer"
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"
	outfit = /datum/outfit/syndicateofficercorpse

/datum/outfit/syndicateofficercorpse
	name = "Syndicate Officer Corpse"
	uniform = /obj/item/clothing/under/syndicate/skyrat/tactical
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/syndicate/worn
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset
	mask = /obj/item/clothing/mask/gas/syndicate
	head = /obj/item/clothing/head/hats/hos/cap/syndicate/worn
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/advanced/black/syndicate_command/captain_id
	id_trim = /datum/id_trim/chameleon/operative/officer

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/worn
	armor_type = /datum/armor/armor_secjacket

/obj/item/clothing/head/hats/hos/cap/syndicate/worn
	armor_type = /datum/armor/cosmetic_sec

/datum/id_trim/chameleon/operative/officer
	assignment = "Syndicate Officer"
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	department_color = COLOR_SYNDIE_RED_HEAD
	subdepartment_color = COLOR_SYNDIE_RED
	big_pointer = TRUE
	pointer_color = COLOR_SYNDIE_RED

/obj/effect/mob_spawn/corpse/human/skeleton/syndicate
	name = "Syndicate Agent"
	mob_name = "old dusty skeleton"
	mob_species = /datum/species/skeleton
	outfit = /datum/outfit/oldsyndicate

/datum/outfit/oldsyndicate
	name = "Skeleton Syndicate Agent"
	id = /obj/item/card/id/advanced/chameleon/black
	id_trim = /datum/id_trim/chameleon/operative
	uniform = /obj/item/clothing/under/syndicate
	mask = /obj/item/clothing/mask/gas/syndicate
	ears = /obj/item/radio/headset/syndicateciv
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/black

/obj/effect/mob_spawn/corpse/human/skeleton/syndicate/no_id
	outfit = /datum/outfit/oldsyndicate/no_id

/datum/outfit/oldsyndicate/no_id
	name = "ID-Less Skeleton Syndicate Agent"
	id = null
	id_trim = null
