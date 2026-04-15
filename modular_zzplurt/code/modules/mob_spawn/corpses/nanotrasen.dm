/obj/effect/mob_spawn/corpse/human/privatesecurity
	name = "Nanotrasen Private Security Private"
	outfit = /datum/outfit/nanotrasenprivate

/datum/outfit/nanotrasenprivate
	name = "NT Private Security Private Corpse"

	uniform = /obj/item/clothing/under/rank/security/splurt/ntps
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/black
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen/ntps
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/corpse/private_security/pvt
	accessory = /obj/item/clothing/accessory/rank/private
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/nanotrasenprivate/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/nanotrasenprivate/pre_equip(mob/living/carbon/human/H)
	. = ..()

	uniform = pick(list(
		/obj/item/clothing/under/rank/security/splurt/ntps,
		/obj/item/clothing/under/rank/security/splurt/ntps/turtleneck,
		/obj/item/clothing/under/rank/security/splurt/ntps/fatigues
	))

	head = pick(list(
		/obj/item/clothing/head/security_garrison/ntps,
		/obj/item/clothing/head/soft/sec/ntps,
		/obj/item/clothing/head/beret/sec/ntps,
		/obj/item/clothing/head/helmet/swat/nanotrasen/ntps
	))

/datum/id_trim/centcom/corpse/private_security/pvt
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_PRIVATE
	subdepartment_color = COLOR_SECURITY_RED
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_WEAPONS)
	big_pointer = FALSE
	honorifics = list("Pvt.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	pointer_color = COLOR_CENTCOM_BLUE

/obj/effect/mob_spawn/corpse/human/privatesecurity/corporal
	name = JOB_CENTCOM_PRIVATE_SECURITY_CORPORAL
	outfit = /datum/outfit/nanotrasencorporal

/datum/outfit/nanotrasencorporal
	name = "NT Private Security Corporal Corpse"

	uniform = /obj/item/clothing/under/rank/security/splurt/ntps/corporal
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/black
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen/ntps
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/corpse/private_security/cpl
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/nanotrasencorporal/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/nanotrasencorporal/pre_equip(mob/living/carbon/human/H)
	. = ..()

	uniform = pick(list(
		/obj/item/clothing/under/rank/security/splurt/ntps/corporal,
		/obj/item/clothing/under/rank/security/splurt/ntps/corporal/turtleneck
	))

/datum/id_trim/centcom/corpse/private_security/cpl
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_CORPORAL
	subdepartment_color = COLOR_SECURITY_RED
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_WEAPONS)
	big_pointer = FALSE
	honorifics = list("Cpl.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	pointer_color = COLOR_CENTCOM_BLUE

/obj/effect/mob_spawn/corpse/human/privatesecurity/sergeant
	name = JOB_CENTCOM_PRIVATE_SECURITY_SERGEANT
	outfit = /datum/outfit/nanotrasensergeant

/datum/outfit/nanotrasensergeant
	name = "NT Private Security Sergeant Corpse"

	uniform = /obj/item/clothing/under/rank/security/splurt/ntps/sergeant
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/black
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen/ntps/sergeant
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/centcom/corpse/private_security/sgt
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/nanotrasensergeant/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/outfit/nanotrasensergeant/pre_equip(mob/living/carbon/human/H)
	. = ..()

	uniform = pick(list(
		/obj/item/clothing/under/rank/security/splurt/ntps/sergeant,
		/obj/item/clothing/under/rank/security/splurt/ntps/sergeant/turtleneck
	))

/datum/id_trim/centcom/corpse/private_security/sgt
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_SERGEANT
	subdepartment_color = COLOR_SECURITY_RED
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_STORAGE, ACCESS_SECURITY, ACCESS_MECH_SECURITY, ACCESS_WEAPONS)
	big_pointer = TRUE
	honorifics = list("Sgt.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	pointer_color = COLOR_CENTCOM_BLUE

/obj/effect/mob_spawn/corpse/human/privatesecurity/captain
	name = JOB_CENTCOM_PRIVATE_SECURITY_CAPTAIN
	outfit = /datum/outfit/nanotrasencaptain

/datum/outfit/nanotrasencaptain
	name = "NT Private Security Captain Corpse"

	uniform = /obj/item/clothing/under/rank/security/splurt/ntps/captain
	suit = /obj/item/clothing/suit/armor/vest
	belt = /obj/item/storage/belt/security/webbing/peacekeeper/armadyne
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/beret/sec/ntps/captain
	back = /obj/item/storage/backpack/satchel/sec/redsec
	id = /obj/item/card/id/advanced/platinum
	id_trim = /datum/id_trim/centcom/corpse/private_security/cpt
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/nanotrasencaptain/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/id_trim/centcom/corpse/private_security/cpt
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_CAPTAIN
	subdepartment_color = COLOR_SECURITY_RED
	access = list(ACCESS_CENT_CAPTAIN, ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_STORAGE, ACCESS_SECURITY, ACCESS_MECH_SECURITY, ACCESS_WEAPONS)
	big_pointer = TRUE
	honorifics = list("Cpt.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	pointer_color = COLOR_CENTCOM_BLUE

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

/datum/outfit/nanotrasenbridgeofficer/bigderelict/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/id_trim/centcom/corpse/bridge_officer/bigderelict
	assignment = JOB_TRADEPOST_COORDINATOR
	subdepartment_color = COLOR_CARGO_BROWN
	access = list(ACCESS_CENT_CAPTAIN, ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CARGO, ACCESS_WEAPONS)
	big_pointer = TRUE
	honorifics = list("Exec.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	pointer_color = COLOR_CENTCOM_BLUE

/obj/effect/mob_spawn/corpse/human/bridgeofficer/shuttle8532
	name = JOB_NANOTRASEN_LIEUTENANT
	outfit = /datum/outfit/nanotrasenbridgeofficer/shuttle8532

/datum/outfit/nanotrasenbridgeofficer/shuttle8532
	name = "Nanotrasen Lieutenant"

	ears = /obj/item/radio/headset/heads/nanotrasen/empty
	uniform = /obj/item/clothing/under/rank/nanotrasen/official/turtleneck
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/combat
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/card/id/advanced/platinum
	id_trim = /datum/id_trim/centcom/corpse/bridge_officer/shuttle8532
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/nanotrasenbridgeofficer/shuttle8532/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()

/datum/id_trim/centcom/corpse/bridge_officer/shuttle8532
	assignment = JOB_NANOTRASEN_LIEUTENANT
	subdepartment_color = COLOR_CENTCOM_BLUE
	access = list(ACCESS_CENT_CAPTAIN, ACCESS_CENT_GENERAL)
	big_pointer = TRUE
	honorifics = list("Lt.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	pointer_color = COLOR_CENTCOM_BLUE

/obj/item/radio/headset/heads/nanotrasen/empty
	keyslot = null
	keyslot2 = null

// MODULAR PRIVATE SECURITY CORPSES, at least to the best of my abilities.
/obj/effect/mob_spawn/corpse/human/nanotrasensoldier
	name = JOB_CENTCOM_PRIVATE_SECURITY_PRIVATE
	outfit = /datum/outfit/nanotrasenprivate

/obj/effect/mob_spawn/corpse/human/nanotrasenassaultsoldier
	name = JOB_CENTCOM_PRIVATE_SECURITY_CORPORAL
	outfit = /datum/outfit/nanotrasencorporal
