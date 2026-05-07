/proc/apply_corpse_rank_name(mob/living/carbon/human/H, rank_abbr)
	if(!H)
		return

	var/original_name = H.real_name

	// Prevent double-prefixing
	if(findtext(original_name, rank_abbr) == 1)
		return

	var/new_name = "[rank_abbr] [original_name]"

	// Update character name
	H.fully_replace_character_name(original_name, new_name)

	// Sync ID
	var/obj/item/card/id/W = H.wear_id
	if(W)
		W.registered_name = new_name
		W.update_label()
		W.update_icon()

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
	head = /obj/item/clothing/head/soft/sec/ntps
	back = /obj/item/storage/backpack/satchel/sec
	ears = /obj/item/radio/headset/headset_cent/empty/privsec
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/corpse/private_security/pvt
	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/rank/private

/datum/outfit/nanotrasenprivate/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	apply_corpse_rank_name(H, "Pvt.")

/datum/id_trim/centcom/corpse/private_security/pvt
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_PRIVATE
	subdepartment_color = COLOR_SECURITY_RED
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_WEAPONS)
	big_pointer = FALSE
	honorifics = list("Pvt.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	pointer_color = COLOR_CENTCOM_BLUE

/obj/effect/mob_spawn/corpse/human/privatesecurity/specialist
	name = "Nanotrasen Private Security Specialist"
	outfit = /datum/outfit/nanotrasenspecialist

/datum/outfit/nanotrasenspecialist
	name = "NT Private Security Specialist Corpse"

	uniform = /obj/item/clothing/under/rank/security/splurt/ntps
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/black
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/beret/sec/medical
	belt = /obj/item/storage/belt/security/webbing/peacekeeper
	back = /obj/item/storage/backpack/satchel/sec
	ears = /obj/item/radio/headset/headset_cent/empty/privsec
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/corpse/private_security/spc
	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/rank/specialist

/datum/outfit/nanotrasenspecialist/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	apply_corpse_rank_name(H, "Spc.")

/datum/id_trim/centcom/corpse/private_security/spc
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_SPECIALIST
	subdepartment_color = COLOR_MEDICAL_BLUE
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_MEDICAL, ACCESS_CENT_LIVING, ACCESS_WEAPONS)
	big_pointer = FALSE
	honorifics = list("Spc.")
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
	back = /obj/item/storage/backpack/satchel/sec
	ears = /obj/item/radio/headset/headset_cent/empty/privsec
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/corpse/private_security/cpl
	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/rank/corporal

/datum/outfit/nanotrasencorporal/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	apply_corpse_rank_name(H, "Cpl.")

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
	back = /obj/item/storage/backpack/satchel
	ears = /obj/item/radio/headset/headset_cent/empty/privsec
	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/centcom/corpse/private_security/sgt
	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/rank/sergeant

/datum/outfit/nanotrasensergeant/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	apply_corpse_rank_name(H, "Sgt.")

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
	belt = /obj/item/storage/belt/security/webbing/privsec
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen/commander
	back = /obj/item/storage/backpack/satchel/sec
	id = /obj/item/card/id/advanced/platinum
	id_trim = /datum/id_trim/centcom/corpse/private_security/cpt
	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/rank/officer/captain

/datum/outfit/nanotrasencaptain/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	apply_corpse_rank_name(H, "Cpt.")

/datum/id_trim/centcom/corpse/private_security/cpt
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_CAPTAIN
	subdepartment_color = COLOR_SECURITY_RED
	access = list(ACCESS_CENT_CAPTAIN, ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_STORAGE, ACCESS_SECURITY, ACCESS_MECH_SECURITY, ACCESS_WEAPONS)
	big_pointer = TRUE
	honorifics = list("Cpt.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	pointer_color = COLOR_CENTCOM_BLUE

/obj/effect/mob_spawn/corpse/human/commander // just to stop the complaining.
	name = JOB_CENTCOM_PRIVATE_SECURITY_CAPTAIN
	outfit = /datum/outfit/nanotrasencaptain

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

/obj/effect/mob_spawn/corpse/human/nanotrasendeathsquad
	name = "\improper Nanotrasen Deathsquad Corpse"
	outfit = /datum/outfit/nanotrasendeathsquadcorpse
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"

/datum/outfit/nanotrasendeathsquadcorpse
	name = "\improper NT Deathsquad Corpse"
	uniform = /obj/item/clothing/under/rank/centcom/commander
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	back = /obj/item/mod/control/pre_equipped/apocryphal
	id = /obj/item/card/id/advanced/black/deathsquad
	id_trim = /datum/id_trim/centcom/deathsquad

/obj/effect/mob_spawn/corpse/human/nanotrasenelitecommander
	name = "\improper Nanotrasen Elite Commander Corpse"
	outfit = /datum/outfit/nanotrasenelitecommandercorpse
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"

/datum/outfit/nanotrasenelitecommandercorpse
	name = "\improper NT Elite Commander Corpse"
	uniform = /obj/item/clothing/under/rank/centcom/military
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	back = /obj/item/mod/control/pre_equipped/responsory/commander
	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/ert/security
