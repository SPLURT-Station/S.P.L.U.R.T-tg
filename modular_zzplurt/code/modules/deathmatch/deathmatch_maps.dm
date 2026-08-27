/datum/lazy_template/deathmatch/centcom
	name = "Central Command"
	desc = "An Intern uprising has begun, be the last one standing."
	max_players = 12
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/intern, /datum/outfit/deathmatch_loadout/intern/head)
	map_name = "centcom"
	key = "centcom"

/datum/outfit/deathmatch_loadout/intern
	name = "Deathmatch: CentCom Intern loadout"
	display_name = "CentCom Intern"
	desc = "A simple intern loadout."
	uniform = /obj/item/clothing/under/rank/centcom/intern
	belt = /obj/item/melee/baton
	back = /obj/item/storage/backpack/satchel
	box = /obj/item/storage/box/survival
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/black

/datum/outfit/deathmatch_loadout/intern/head
	name = "Deathmatch: CentCom Head Intern loadout"
	display_name = "CentCom Head Intern"
	desc = "A simple head intern loadout."
	head = /obj/item/clothing/head/hats/intern
	suit = /obj/item/clothing/suit/armor/vest/alt
	belt = /obj/item/melee/baton/security/loaded
