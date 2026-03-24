/datum/job/nanotrasen_crew_trainer
	title = JOB_NT_TRN
	description = "Train and educate crew on how to do their job, be the guide they need."
	department_head = list(JOB_NT_REP)
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_NTC
	minimal_player_age = 14
	exp_requirements = 600
	exp_required_type = EXP_TYPE_ADMIN //Temporary Original is EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_ADMIN //Temporary Original is EXP_TYPE_COMMAND
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "NANOTRASEN_CREW_TRAINER"

	outfit = /datum/outfit/job/nanotrasen_crew_trainer
	plasmaman_outfit = /datum/outfit/plasmaman/nanotrasen_consultant

	department_for_prefs = /datum/job_department/assistant

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_CIV

	liver_traits = list(TRAIT_PRETENDER_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_NANOTRASEN_CREW_TRAINER

	family_heirlooms = list(/obj/item/banner/command/mundane)

	mail_goodies = list(
		/obj/item/storage/fancy/cigarettes = 1,
		/obj/item/pen/fountain = 1,
	)
	rpg_title = "Guild Mentor"
	allow_bureaucratic_error = FALSE
	job_flags = STATION_JOB_FLAGS | JOB_ANTAG_BLACKLISTED | JOB_CANNOT_OPEN_SLOTS
	human_authority = JOB_AUTHORITY_NON_HUMANS_ALLOWED

/obj/effect/landmark/start/nanotrasen_crew_trainer
	name = "Nanotrasen Crew Trainer"
	icon_state = "Nanotrasen Crew Trainer"
	icon = 'modular_zzplurt/icons/mob/effects/landmarks.dmi'

/datum/outfit/job/nanotrasen_crew_trainer
	name = "Nanotrasen Crew Trainer"
	jobtype = /datum/job/nanotrasen_crew_trainer

	belt = /obj/item/modular_computer/pda/nanotrasen_trainer
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/nanotrasen
	gloves = /obj/item/clothing/gloves/color/black
	uniform =  /obj/item/clothing/under/rank/nanotrasen/nanotrasen_intern
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/sneakers/black
	backpack_contents = list(
		/obj/item/melee/baton/telescopic/bronze = 1,
		)

	skillchips = list(/obj/item/skillchip/disk_verifier)

	backpack = /obj/item/storage/backpack/blueshield
	satchel = /obj/item/storage/backpack/satchel/blueshield
	duffelbag = /obj/item/storage/backpack/duffelbag/blueshield
	messenger = /obj/item/storage/backpack/messenger/blueshield

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/bubber/acc_medal/neckpin

	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/job/nanotrasen_crew_trainer

/obj/item/storage/bag/garment/nanotrasen_crew_trainer
	name = "nanotrasen crew trainers's garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the Nanotrasen Crew Trainer."

/obj/item/storage/bag/garment/nanotrasen_crew_trainer/PopulateContents()
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/glasses/hud/civilian(src)
	new /obj/item/clothing/glasses/hud/civilian(src)
	new /obj/item/clothing/under/rank/nanotrasen/nanotrasen_intern(src)
	new /obj/item/clothing/under/rank/nanotrasen/nanotrasen_intern(src)
	new /obj/item/clothing/under/rank/nanotrasen/official(src)
	new /obj/item/clothing/under/rank/nanotrasen/official(src)
	new /obj/item/clothing/under/rank/nanotrasen/official/turtleneck(src)
	new /obj/item/clothing/under/rank/nanotrasen/official/turtleneck(src)
	new /obj/item/clothing/under/rank/nanotrasen/tactical(src)
	new /obj/item/clothing/under/rank/nanotrasen/tactical(src)
	new /obj/item/clothing/under/rank/nanotrasen/tactical/skirt(src)
	new /obj/item/clothing/under/rank/nanotrasen/tactical/skirt(src)
	new /obj/item/clothing/suit/armor/vest/alt(src)
	new /obj/item/clothing/suit/armor/vest/alt(src)
	new /obj/item/clothing/neck/large_scarf/nanotrasen(src)
	new /obj/item/clothing/neck/large_scarf/nanotrasen(src)
	new /obj/item/clothing/suit/hooded/wintercoat/nanotrasen(src)
	new /obj/item/clothing/suit/hooded/wintercoat/nanotrasen(src)
	new /obj/item/clothing/head/hats/intern/nanotrasen(src)
	new /obj/item/clothing/head/hats/intern/nanotrasen(src)
	new /obj/item/clothing/head/hats/nanotrasen_cap/lowrank(src)
	new /obj/item/clothing/head/hats/nanotrasen_cap/lowrank(src)
	new /obj/item/clothing/head/beret/nanotrasen_formal(src)
	new /obj/item/clothing/head/beret/nanotrasen_formal(src)
	new /obj/item/clothing/mask/gas/atmos/nanotrasen(src)
	new /obj/item/clothing/mask/gas/atmos/nanotrasen(src)

/obj/structure/closet/secure_closet/nanotrasen_crew_trainer
	name = "nanotrasen crew trainer's locker"
	req_access = list()
	req_one_access = list(ACCESS_CENT_GENERAL)
	icon_state = "ntt"
	icon = 'modular_zzplurt/icons/obj/closet.dmi'

/obj/structure/closet/secure_closet/nanotrasen_crew_trainer/PopulateContents()
	..()
	new /obj/item/storage/backpack/satchel/leather(src)
	new /obj/item/storage/backpack/satchel/leather(src)
	new /obj/item/storage/photo_album/personal(src)
	new /obj/item/storage/bag/garment/nanotrasen_crew_trainer(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/clipboard(src)
	new /obj/item/clipboard(src)

/obj/item/modular_computer/pda/nanotrasen_trainer
	name = "nanotrasen PDA"
	icon_state = "/obj/item/modular_computer/pda/nanotrasen_trainer"
	greyscale_colors = "#42B5A6#B4B9C6"
	inserted_item = /obj/item/pen/fountain
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/records/medical,
	)

/obj/item/modular_computer/pda/nanotrasen_trainer/Initialize(mapload)
	. = ..()
	for(var/datum/computer_file/program/messenger/messenger_app in stored_files)
		messenger_app.spam_mode = TRUE
