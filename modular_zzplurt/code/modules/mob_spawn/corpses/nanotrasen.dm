// Job Defines
#define JOB_CENTCOM_PRIVATE_SECURITY_OPERATIVE "Nanotrasen Private Security Operative"
#define JOB_CENTCOM_PRIVATE_SECURITY_SERGEANT "Nanotrasen Private Security Sergeant"
#define JOB_CENTCOM_PRIVATE_SECURITY_COMMANDER "Nanotrasen Private Security Commander"
#define JOB_TRADEPOST_COORDINATOR "Tradepost Coordinator"


/obj/effect/mob_spawn/corpse/human/privatesecurity
	name = JOB_CENTCOM_PRIVATE_SECURITY_OPERATIVE
	outfit = /datum/outfit/nanotrasenoperative

/datum/outfit/nanotrasenoperative
	name = "Nanotrasen Private Security Operative"

	uniform = /obj/item/clothing/under/rank/security/nanotrasen
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/corpse/private_security/lr
	implants = list(/obj/item/implant/mindshield)

/datum/id_trim/centcom/corpse/private_security/lr
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_OPERATIVE
	subdepartment_color = COLOR_SECURITY_RED
	access = list(ACCESS_CENT_GENERAL)

/obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant
	name = JOB_CENTCOM_PRIVATE_SECURITY_SERGEANT
	outfit = /datum/outfit/nanotrasensergeant

/datum/outfit/nanotrasensergeant
	name = "Nanotrasen Private Security Sergeant"

	uniform = /obj/item/clothing/under/rank/security/nanotrasen/hr
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen/hr
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/centcom/corpse/private_security/mr
	implants = list(/obj/item/implant/mindshield)

/datum/id_trim/centcom/corpse/private_security/mr
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_SERGEANT
	subdepartment_color = COLOR_SECURITY_RED
	access = list(ACCESS_CENT_GENERAL)

/obj/effect/mob_spawn/corpse/human/privatesecurity/commander
	name = JOB_CENTCOM_PRIVATE_SECURITY_COMMANDER
	outfit = /datum/outfit/nanotrasencommander

/datum/outfit/nanotrasencommander
	name = "Nanotrasen Private Security Commander"

	uniform = /obj/item/clothing/under/rank/security/nanotrasen/hr
	suit = /obj/item/clothing/suit/armor/vest
	belt = /obj/item/storage/belt/security/webbing/peacekeeper/armadyne
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen/commander
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced/platinum
	id_trim = /datum/id_trim/centcom/corpse/private_security/hr
	implants = list(/obj/item/implant/mindshield)

/datum/id_trim/centcom/corpse/private_security/hr
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_COMMANDER
	subdepartment_color = COLOR_SECURITY_RED
	access = list(ACCESS_CENT_CAPTAIN, ACCESS_CENT_GENERAL)

/obj/effect/mob_spawn/corpse/human/bridgeofficer/bigderelict
	name = JOB_TRADEPOST_COORDINATOR
	outfit = /datum/outfit/nanotrasenbridgeofficer/bigderelict

/datum/outfit/nanotrasenbridgeofficer/bigderelict
	name = "Tradepost Coordinator"

	ears = /obj/item/radio/headset/headset_cent/empty
	uniform = /obj/item/clothing/under/rank/centcom/official
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/card/id/advanced/platinum
	id_trim = /datum/id_trim/centcom/corpse/bridge_officer/bigderelict
	implants = list(/obj/item/implant/mindshield)

/datum/id_trim/centcom/corpse/bridge_officer/bigderelict
	assignment = JOB_TRADEPOST_COORDINATOR
	subdepartment_color = COLOR_CARGO_BROWN
	access = list(ACCESS_CENT_CAPTAIN, ACCESS_CENT_GENERAL)

// Clothing | Because I don't wanna take forever on this port.
/obj/item/clothing/under/rank/security/nanotrasen
	name = "private security uniform"
	desc = "A classic red tactical security uniform for Nanotrasen's private security force, complete with a Nanotrasen logo belt buckle."
	icon = 'modular_zzplurt/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/under/security.dmi'
	icon_state = "nanotrasenlr"

/obj/item/clothing/under/rank/security/nanotrasen/hr
	name = "private security officer uniform"
	desc = "A classic red tactical security uniform for Nanotrasen's private security force, complete with a golden Nanotrasen logo belt buckle, as well as gold ranking on the shoulders and wrists."
	icon = 'modular_zzplurt/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/under/security.dmi'
	icon_state = "nanotrasenhr"

/obj/item/clothing/head/helmet/swat/nanotrasen/hr
	name = "\improper SWAT officer helmet"
	desc = "An extremely robust helmet with the Nanotrasen logo emblazoned on the top in gold, worn by Nanotrasen Private Security's NCOs."
	icon = 'modular_zzplurt/icons/obj/clothing/head.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/head.dmi'
	icon_state = "swathr"

/obj/item/clothing/head/helmet/swat/nanotrasen/commander
	name = "\improper private security beret"
	desc = "A robust beret in red, with a golden Nanotrasen logo badge on it, you feel whoever's wearing this must be some commanding officer."
	icon = 'modular_zzplurt/icons/obj/clothing/head.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/head.dmi'
	icon_state = "swatcomm"
