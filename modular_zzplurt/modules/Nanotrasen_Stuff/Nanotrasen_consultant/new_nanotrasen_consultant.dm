/datum/job/nanotrasen_consultant
	title = JOB_NT_REP
	description = "Represent Nanotrasen on the station, argue with the HoS about \
		why he can't just field execute people for petty theft, get drunk in your office."
	department_head = list("Nanotrasen High Command")
	head_announce = list(RADIO_CHANNEL_IAA)
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 600
	exp_required_type = EXP_TYPE_ADMIN //Temporary Original is EXP_TYPE_COMMAND
	exp_required_type_department = EXP_TYPE_ADMIN //Temporary Original is EXP_TYPE_INTERNAL
	exp_granted_type = EXP_TYPE_COMMAND
	config_tag = "NANOTRASEN_CONSULTANT"

	outfit = /datum/outfit/job/nanotrasen_consultant
	plasmaman_outfit = /datum/outfit/plasmaman/nanotrasen_consultant

	department_for_prefs = /datum/job_department/captain
	departments_list = list(
		/datum/job_department/command,
	)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_CMD

	mind_traits = list(HEAD_OF_STAFF_MIND_TRAITS)
	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_NANOTRASEN_CONSULTANT
	bounty_types = CIV_JOB_SEC

	mail_goodies = list(
		/obj/item/cigarette/cigar/havana = 20,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 15,
		/obj/item/reagent_containers/cup/glass/bottle/champagne = 10
	)
	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law)
	rpg_title = "Guild Advisor"
	job_flags = STATION_JOB_FLAGS | HEAD_OF_STAFF_JOB_FLAGS | JOB_BOLD_SELECT_TEXT | JOB_CANNOT_OPEN_SLOTS

	human_authority = JOB_AUTHORITY_HUMANS_ONLY

	voice_of_god_power = 1.4 //Command staff has authority

/datum/job/nanotrasen_consultant/get_captaincy_announcement(mob/living/captain)
	return "Due to severe staffing shortages, Nanotrasen Executive [captain.real_name] will act as Acting Captain until a real suitor arrives!"

/obj/effect/landmark/start/nanotrasen_consultant
	name = "Nanotrasen Consultant"
	icon_state = "Nanotrasen Consultant"
	icon = 'modular_zzplurt/icons/mob/effects/landmarks.dmi'

/obj/structure/closet/secure_closet/nanotrasen_consultant
	name = "nanotrasen consultant's locker"
	req_access = list(ACCESS_CENT_GENERAL, ACCESS_COMMAND)
	req_one_access = list()
	icon_state = "nt"
	icon = 'modular_zzplurt/icons/obj/closet.dmi'

/obj/structure/closet/secure_closet/nanotrasen_consultant/PopulateContents()
	..()
	new /obj/item/storage/backpack/satchel/leather(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/pet_carrier(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/computer_disk/command/captain(src)
	new /obj/item/radio/headset/heads/nanotrasen(src)
	new /obj/item/storage/photo_album/ntc(src)
	new /obj/item/bedsheet/nanotrasen(src)
	new /obj/item/storage/bag/garment/nanotrasen_consultant(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/storage/briefcase/central_command(src)
	new /obj/item/camera_film(src)
	new /obj/item/camera_film(src)
	new /obj/item/camera(src)
	new /obj/item/tape(src)
	new /obj/item/tape(src)
	new /obj/item/taperecorder(src)
	new /obj/item/hand_labeler(src)
	new /obj/item/assembly/flash/handheld(src)

/obj/item/storage/bag/garment/nanotrasen_consultant
	name = "nanotrasen consultant's garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the Nanotrasen Consultant."

/obj/item/storage/bag/garment/nanotrasen_consultant/PopulateContents()
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/glasses/hud/civilian/sunglasses(src)
	new /obj/item/clothing/gloves/combat(src)
	new /obj/item/clothing/gloves/captain/nanotrasen(src)
	new /obj/item/clothing/neck/mantle/ntcmantle(src)
	new /obj/item/clothing/under/rank/nanotrasen/commander(src)
	new /obj/item/clothing/under/rank/nanotrasen/commander/skirt(src)
	new /obj/item/clothing/under/rank/nanotrasen/commander/turtleneck(src)
	new /obj/item/clothing/under/rank/nanotrasen/tactical/gold(src)
	new /obj/item/clothing/under/rank/nanotrasen/tactical/gold/skirt(src)
	new /obj/item/clothing/suit/hooded/wintercoat/nanotrasen/gold(src)
	new /obj/item/clothing/neck/large_scarf/nanotrasen(src)
	new /obj/item/clothing/head/beret/nanotrasen_formal/gold(src)
	new /obj/item/clothing/head/hats/nanotrasenhat(src)
	new /obj/item/clothing/head/hats/nanotrasen_cap(src)
	new /obj/item/clothing/head/hats/warden/drill/nanotrasen/nt(src)
	new /obj/item/clothing/suit/armor/nanotrasen_formal(src)
	new /obj/item/clothing/suit/armor/nanotrasen_greatcoat(src)
	new /obj/item/clothing/suit/armor/vest/capcarapace/nanotrasen(src)
	new /obj/item/clothing/suit/armor/vest/nt_officerfake(src)
	new /obj/item/clothing/mask/gas/atmos/nanotrasen(src)

/obj/item/clothing/accessory/medal/gold/nanotrasen_consultant
	name = "medal of diplomacy"
	desc = "A golden medal awarded exclusively to those promoted to the rank of Nanotrasen Consultant. It signifies the diplomatic abilities of said individual and their sheer dedication to Nanotrasen."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/storage/photo_album/ntc
	name = "photo album (Nanotrasen Consultant)"
	icon_state = "album_blue"
	persistence_id = "NTC"

/obj/item/pen/fountain/nanotrasen
	name = "nanotrasen fountain pen"
	desc = "It's an expensive blue fountain pen. The case may be plastic, but that gold is real!"
	icon = 'modular_zzplurt/icons/obj/service/bureaucracy.dmi'
	icon_state = "pen-fountain-nt"
	colour = "#0d5374"
	custom_materials = list(/datum/material/gold = SMALL_MATERIAL_AMOUNT*7.5)

/mob/living/basic/pet/dog/corgi/lisa
	icon = 'modular_zzplurt/icons/mob/pets.dmi'

/obj/item/clothing/accessory/bubber/acc_medal/neckpin/nanotrasen
	name = "\improper Nanotrasen Executive neckpin"
	icon_state = "/obj/item/clothing/accessory/bubber/acc_medal/neckpin"
	post_init_icon_state = "ntpin"
	greyscale_colors = "#FFD351#E09100"

/obj/item/modular_computer/pda/heads/nanotrasen_consultant
	name = "nanotrasen executive PDA"
	icon_state = "/obj/item/modular_computer/pda/heads/nanotrasen_consultant"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick/head
	greyscale_colors = "#42B5A6#DAE0F0#B4B9C6"
	inserted_disk = /obj/item/computer_disk/command/captain
	inserted_item = /obj/item/pen/fountain/nanotrasen
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/job_management,
	)

/obj/item/clothing/neck/large_scarf/nanotrasen
	name = "corporate striped scarf"
	desc = "Ready to rule."
	icon_state = "/obj/item/clothing/neck/large_scarf/nanotrasen"
	greyscale_colors = "#42B5A6#DAE0F0"
	armor_type = /datum/armor/large_scarf_syndie

/datum/outfit/plasmaman/nanotrasen_consultant
	name = "Nanotrasen Consultant Plasmaman"

	uniform = /obj/item/clothing/under/plasmaman/centcom_official
	gloves = /obj/item/clothing/gloves/captain //Too iconic to be replaced with a plasma version
	head = /obj/item/clothing/head/helmet/space/plasmaman/centcom_official

/datum/outfit/job/nanotrasen_consultant
	name = "Nanotrasen Consultant"
	jobtype = /datum/job/nanotrasen_consultant

	belt = /obj/item/gun/energy/e_gun/asterion
	glasses = /obj/item/clothing/glasses/hud/civilian/sunglasses
	ears = /obj/item/radio/headset/heads/nanotrasen
	gloves = /obj/item/clothing/gloves/combat
	uniform =  /obj/item/clothing/under/rank/nanotrasen/commander
	suit = /obj/item/clothing/suit/armor/nanotrasen_greatcoat
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/hats/nanotrasen_cap
	r_pocket = /obj/item/modular_computer/pda/heads/nanotrasen_consultant
	backpack_contents = list(
		/obj/item/melee/baton/telescopic/silver = 1,
		)

	pda_slot = ITEM_SLOT_RPOCKET
	skillchips = list(/obj/item/skillchip/disk_verifier)

	backpack = /obj/item/storage/backpack/blueshield
	satchel = /obj/item/storage/backpack/satchel/blueshield
	duffelbag = /obj/item/storage/backpack/duffelbag/blueshield
	messenger = /obj/item/storage/backpack/messenger/blueshield

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/bubber/acc_medal/neckpin/nanotrasen

	chameleon_extras = list(/obj/item/gun/energy/e_gun/asterion, /obj/item/stamp/nanotrasen)

	id = /obj/item/card/id/advanced/platinum
	id_trim = /datum/id_trim/job/nanotrasen_consultant

/area/station/command/heads_quarters/nt_rep
	name = "Nanotrasen Internal Affairs Office"
