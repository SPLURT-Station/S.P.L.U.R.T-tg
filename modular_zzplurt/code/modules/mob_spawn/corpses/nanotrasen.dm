// Job Defines
#define JOB_CENTCOM_PRIVATE_SECURITY_OPERATIVE "Nanotrasen Private Security Operative"
#define JOB_CENTCOM_PRIVATE_SECURITY_MEDIC "Nanotrasen Private Security Specialist"
#define JOB_CENTCOM_PRIVATE_SECURITY_SERGEANT "Nanotrasen Private Security Sergeant"
#define JOB_CENTCOM_PRIVATE_SECURITY_COMMANDER "Nanotrasen Private Security Commander"
#define JOB_TRADEPOST_COORDINATOR "Tradepost Coordinator"


/obj/effect/mob_spawn/corpse/human/privatesecurity
	name = JOB_CENTCOM_PRIVATE_SECURITY_OPERATIVE
	outfit = /datum/outfit/nanotrasenoperative

/datum/outfit/nanotrasenoperative
	name = "NT Private Security Operative Corpse"

	uniform = /obj/item/clothing/under/rank/security/nanotrasen
	suit = /obj/item/clothing/suit/armor/vest
	belt = /obj/item/storage/belt/security/redsec
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/black
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/corpse/private_security/lr
	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/rank

/datum/id_trim/centcom/corpse/private_security/lr
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_OPERATIVE
	subdepartment_color = COLOR_SECURITY_RED
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_WEAPONS)
	big_pointer = FALSE
	honorifics = list("Operative")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/obj/effect/mob_spawn/corpse/human/privatesecurity/medic
	name = JOB_CENTCOM_PRIVATE_SECURITY_MEDIC
	outfit = /datum/outfit/nanotrasenmedic

/datum/outfit/nanotrasenmedic
	name = "NT Private Security Specialist Corpse"

	uniform = /obj/item/clothing/under/rank/security/nanotrasen/mr
	suit = /obj/item/clothing/suit/armor/vest
	belt = /obj/item/storage/belt/medical/privsec
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/nitrile
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/corpse/private_security/lr
	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/rank/corporal

/datum/id_trim/centcom/corpse/private_security/med
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_MEDIC
	subdepartment_color = COLOR_MEDICAL_BLUE
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_MEDICAL, ACCESS_WEAPONS)
	big_pointer = FALSE
	honorifics = list("Combat Medic")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant
	name = JOB_CENTCOM_PRIVATE_SECURITY_SERGEANT
	outfit = /datum/outfit/nanotrasensergeant

/datum/outfit/nanotrasensergeant
	name = "NT Private Security Sergeant Corpse"

	uniform = /obj/item/clothing/under/rank/security/nanotrasen/hr
	suit = /obj/item/clothing/suit/armor/vest
	belt = /obj/item/storage/belt/security/redsec
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/black
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen/hr
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/centcom/corpse/private_security/mr
	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/rank/sergeant

/datum/id_trim/centcom/corpse/private_security/mr
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_SERGEANT
	subdepartment_color = COLOR_SECURITY_RED
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_WEAPONS)
	big_pointer = FALSE
	honorifics = list("Sergeant")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/obj/effect/mob_spawn/corpse/human/privatesecurity/commander
	name = JOB_CENTCOM_PRIVATE_SECURITY_COMMANDER
	outfit = /datum/outfit/nanotrasencommander

/datum/outfit/nanotrasencommander
	name = "NT Private Security Commander Corpse"

	uniform = /obj/item/clothing/under/rank/security/nanotrasen/hr
	suit = /obj/item/clothing/suit/armor/vest
	belt = /obj/item/storage/belt/security/webbing/peacekeeper/armadyne/privsec
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen/commander
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced/platinum
	id_trim = /datum/id_trim/centcom/corpse/private_security/hr
	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/rank/officer/captain

/datum/id_trim/centcom/corpse/private_security/hr
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_COMMANDER
	subdepartment_color = COLOR_SECURITY_RED
	access = list(ACCESS_CENT_CAPTAIN, ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_WEAPONS)
	big_pointer = TRUE
	honorifics = list("Commander")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/corpse/private_security/hr/New()
	. = ..()

	access |= SSid_access.get_flag_access_list(ACCESS_FLAG_COMMON)

/obj/effect/mob_spawn/corpse/human/bridgeofficer/bigderelict
	name = JOB_TRADEPOST_COORDINATOR
	outfit = /datum/outfit/nanotrasenbridgeofficer/bigderelict

/datum/outfit/nanotrasenbridgeofficer/bigderelict
	name = "Tradepost Coordinator Corpse"

	ears = /obj/item/radio/headset/headset_cent/empty
	uniform = /obj/item/clothing/under/rank/centcom/official
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/card/id/advanced/platinum
	id_trim = /datum/id_trim/centcom/corpse/bridge_officer/bigderelict
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/nanotrasenbridgeofficer/bigderelict/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()
	return ..()

/datum/id_trim/centcom/corpse/bridge_officer/bigderelict
	assignment = JOB_TRADEPOST_COORDINATOR
	subdepartment_color = COLOR_CARGO_BROWN
	access = list(ACCESS_CENT_CAPTAIN, ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CARGO, ACCESS_WEAPONS)

// Clothing | Because I don't wanna take forever on this port.
/obj/item/clothing/under/rank/security/nanotrasen
	name = "private security uniform"
	desc = "A classic red tactical security uniform for Nanotrasen's private security force, complete with a Nanotrasen logo belt buckle."
	icon = 'modular_zzplurt/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/under/security.dmi'
	worn_icon_digi = 'modular_zzplurt/icons/mob/clothing/under/security_digi.dmi'
	icon_state = "nanotrasenlr"

/obj/item/clothing/under/rank/security/nanotrasen/mr
	name = "private security senior uniform"
	desc = "A classic red tactical security uniform for Nanotrasen's private security force, complete with a silver Nanotrasen logo belt buckle, as well as silver ranking on the shoulders and wrists."
	icon_state = "nanotrasenmr"

/obj/item/clothing/under/rank/security/nanotrasen/hr
	name = "private security officer uniform"
	desc = "A classic red tactical security uniform for Nanotrasen's private security force, complete with a golden Nanotrasen logo belt buckle, as well as gold ranking on the shoulders and wrists."
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
