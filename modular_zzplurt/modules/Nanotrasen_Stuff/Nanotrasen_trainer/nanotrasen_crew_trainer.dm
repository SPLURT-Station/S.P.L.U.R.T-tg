/datum/job/nanotrasen_crew_trainer
	title = JOB_NT_TRN
	rpg_title = "Guild Adviser"
	description = "Placeholder (YOU ARE NOT COMMAND)"
	department_head = list(JOB_NT_REP)
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "Nanotrasen Consultant"
	minimal_player_age = 14
	exp_requirements = 300
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "NANOTRASEN_CREW_TRAINER"

	department_for_prefs = /datum/job_department/iaa

	departments_list = list(
		/datum/job_department/iaa,
	)

	outfit = /datum/outfit/job/nanotrasen_consultant
	plasmaman_outfit = /datum/outfit/plasmaman/nanotrasen_consultant

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_CIV

	display_order = JOB_DISPLAY_ORDER_NANOTRASEN_TRAINER
	bounty_types = CIV_JOB_BASIC

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law)

	mail_goodies = list(
		/obj/item/cigarette/cigar/havana = 20,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 15,
		/obj/item/reagent_containers/cup/glass/bottle/champagne = 10
	)

	job_flags = STATION_JOB_FLAGS | JOB_BOLD_SELECT_TEXT | JOB_CANNOT_OPEN_SLOTS

/datum/outfit/job/nanotrasen_crew_trainer
	name = "Nanotrasen Crew Trainer"
	jobtype = /datum/job/nanotrasen_crew_trainer

	belt = /obj/item/modular_computer/pda/nanotrasen_trainer
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/nanotrasen
	uniform =  /obj/item/clothing/under/rank/nanotrasen/nanotrasen_intern
	suit = /obj/item/clothing/suit/armor/vest/alt
	suit_store = /obj/item/melee/baton/telescopic
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black

	skillchips = list(/obj/item/skillchip/disk_verifier)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag
	messenger = /obj/item/storage/backpack/messenger

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/bubber/acc_medal/neckpin

	chameleon_extras = list()

	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/job/nanotrasen_consultant


/obj/item/storage/bag/garment/nanotrasen_crew_trainer
	name = "nanotrasen crew trainers's garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the Nanotrasen Crew Trainer."

/obj/item/storage/bag/garment/nanotrasen_crew_trainer/PopulateContents()
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/gloves/color/black(src)
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
	new /obj/item/clothing/suit/hooded/wintercoat/nanotrasen(src)
	new /obj/item/clothing/head/hats/intern/nanotrasen(src)
	new /obj/item/clothing/head/hats/nanotrasen_cap/lowrank(src)
	new /obj/item/clothing/head/beret/nanotrasen_formal(src)

/obj/effect/landmark/start/nanotrasen_crew_trainer
	name = "Nanotrasen Crew Trainer"
	icon_state = "Nanotrasen Crew Trainer"
	icon = 'modular_zzplurt/icons/mob/effects/landmarks.dmi'

/obj/structure/closet/secure_closet/nanotrasen_crew_trainer
	name = "nanotrasen crew trainer's locker"
	req_access = list()
	req_one_access = list(ACCESS_CENT_GENERAL)
	icon_state = "ntt"
	icon = 'modular_zzplurt/icons/obj/closet.dmi'

/obj/structure/closet/secure_closet/nanotrasen_crew_trainer/PopulateContents()
	..()
	new /obj/item/storage/backpack/satchel/leather(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/pet_carrier(src)
	new /obj/item/storage/photo_album/personal(src)
	new /obj/item/storage/bag/garment/nanotrasen_crew_trainer(src)

/obj/item/modular_computer/pda/nanotrasen_trainer
	name = "nanotrasen PDA"
	icon_state = "/obj/item/modular_computer/pda/nanotrasen_trainer"
	greyscale_colors = "#227291#B4B9C6"
