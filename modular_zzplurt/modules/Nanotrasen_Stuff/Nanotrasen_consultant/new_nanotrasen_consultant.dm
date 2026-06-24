GLOBAL_VAR_INIT(ntc_safe_combo, generate_safe_combo())

/proc/generate_safe_combo()
	var/list/L = list()
	for(var/i in 1 to 2) // matches number_of_tumblers
		L += rand(0, 99)
	return L

/datum/job/nanotrasen_consultant
	title = JOB_NT_REP
	description = "Represent Nanotrasen on the station, inform people about SOP, and Space Law. Command your \
		Crew Trainers to efficiently train crew, step into security and command issues as seen fit to resolve them. \
		Be the HR you always wanted to be. Sit in your office and get drunk."
	supervisors = list("Nanotrasen High Command")
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	head_announce = list("Internal Affairs")
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Nanotrasen High Command"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 600
	exp_required_type = EXP_TYPE_ADMIN //Temporary Original is EXP_TYPE_COMMAND
	exp_required_type_department = EXP_TYPE_ADMIN //Temporary Original is EXP_TYPE_INTERNAL
	exp_granted_type = EXP_TYPE_COMMAND
	config_tag = "NANOTRASEN_CONSULTANT"

	outfit = /datum/outfit/job/nanotrasen_consultant
	plasmaman_outfit = /datum/outfit/plasmaman/nanotrasen_consultant
	departments_list = list(
		/datum/job_department/central,
		/datum/job_department/command,
	)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_CMD

	mind_traits = list(HEAD_OF_STAFF_MIND_TRAITS)
	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_NANOTRASEN_CONSULTANT
	bounty_types = CIV_JOB_SEC

	mail_goodies = list(
		/obj/item/coin/silver = 30,
		/obj/item/reagent_containers/cup/glass/mug/nanotrasen = 30,
		/obj/item/storage/fancy/cigarettes/cigars/cohiba = 20,
		/obj/item/soap/nanotrasen = 20,
		/obj/item/coin/gold = 15,
		/obj/item/coin/titanium = 15,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 15,
		/obj/item/reagent_containers/cup/glass/bottle/rum = 15,
		/obj/item/reagent_containers/cup/glass/bottle/vodka = 15,
		/obj/item/coin/plasma = 15,
		/obj/item/reagent_containers/cup/glass/bottle/champagne = 10,
		/obj/item/coin/diamond = 10,
		/obj/item/reagent_containers/cup/glass/bottle/vodka/badminka = 5,
		/obj/item/reagent_containers/cup/glass/bottle/absinthe/premium = 5,
		/obj/item/reagent_containers/cup/glass/bottle/rum/aged = 5,
		/obj/item/sign/flag/syndicate = 5,
		/obj/item/coin/bananium = 1
	)

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law,/obj/item/sign/flag/nanotrasen)
	rpg_title = "Guild Advisor"
	job_flags = STATION_JOB_FLAGS | HEAD_OF_STAFF_JOB_FLAGS | JOB_BOLD_SELECT_TEXT | JOB_CANNOT_OPEN_SLOTS

	human_authority = JOB_AUTHORITY_HUMANS_ONLY

	voice_of_god_power = 1.4 //Command staff has authority

/datum/job/nanotrasen_consultant/get_captaincy_announcement(mob/living/captain)
	return "Due to severe staffing shortages, Nanotrasen Consultant [captain.real_name] will act as Acting Captain until a real suitor arrives!"

/obj/effect/landmark/start/nanotrasen_consultant
	name = "Nanotrasen Consultant"
	icon_state = "Nanotrasen Consultant"
	icon = 'modular_zzplurt/icons/mob/effects/landmarks.dmi'

/obj/structure/closet/secure_closet/nanotrasen_consultant
	name = "nanotrasen consultant's locker"
	req_access = list(ACCESS_CENT_CAPTAIN)
	req_one_access = list()
	icon_state = "nt"
	icon = 'modular_zzplurt/icons/obj/closet.dmi'

/obj/structure/closet/secure_closet/nanotrasen_consultant/PopulateContents()
	..()
	new /obj/item/dog_bone(src)
	new /obj/item/storage/bag/garment/nanotrasen_consultant(src)
	new /obj/item/disk/computer/command/consultant(src)
	new /obj/item/radio/headset/heads/ntc(src)
	new /obj/item/radio/headset/heads/ntc/alt(src)
	new /obj/item/megaphone/command(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/pet_carrier(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/storage/photo_album/ntc(src)
	new /obj/item/storage/lockbox/medal/ntc(src)
	new /obj/item/bedsheet/ntc(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/storage/briefcase/central_command(src)
	new /obj/item/camera_film(src)
	new /obj/item/camera_film(src)
	new /obj/item/camera(src)
	new /obj/item/tape(src)
	new /obj/item/tape(src)
	new /obj/item/taperecorder(src)
	new /obj/item/hand_labeler(src)
	new /obj/item/inspector(src)
	new /obj/item/laser_pointer/blue(src)

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
	new /obj/item/clothing/neck/large_scarf/nanotrasen(src)
	new /obj/item/clothing/under/rank/nanotrasen/commander(src)
	new /obj/item/clothing/under/rank/nanotrasen/commander/skirt(src)
	new /obj/item/clothing/under/rank/nanotrasen/commander/turtleneck(src)
	new /obj/item/clothing/under/rank/nanotrasen/commander/turtleneck/skirt(src)
	new /obj/item/clothing/under/rank/nanotrasen/tactical/gold(src)
	new /obj/item/clothing/under/rank/nanotrasen/tactical/gold/skirt(src)
	new /obj/item/clothing/under/rank/nanotrasen/classic(src)
	new /obj/item/clothing/under/rank/nanotrasen/classic/skirt(src)
	new /obj/item/clothing/head/beret/nanotrasen_formal/gold(src)
	new /obj/item/clothing/head/hats/nanotrasenhat(src)
	new /obj/item/clothing/head/hats/nanotrasen_cap(src)
	new /obj/item/clothing/head/hats/warden/drill/nanotrasen/nt(src)
	new /obj/item/clothing/head/hats/nanotrasen_cap/classic(src)
	new /obj/item/clothing/suit/hooded/wintercoat/nanotrasen/gold(src)
	new /obj/item/clothing/suit/armor/nanotrasen_formal(src)
	new /obj/item/clothing/suit/armor/nanotrasen_winter(src)
	new /obj/item/clothing/suit/armor/vest/capcarapace/nanotrasen(src)
	new /obj/item/clothing/suit/armor/nanotrasen_trenchcoat(src)
	new /obj/item/clothing/suit/armor/nanotrasen_furred_greatcoat(src)
	new /obj/item/clothing/suit/armor/nanotrasen_greatcoat
	new /obj/item/clothing/suit/armor/nanotrasen_overcoat(src)
	new /obj/item/clothing/suit/armor/vest/classic_jacket(src)
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
	desc = "It's an extremely expensive blue fountain pen. The nib is quite sharp. The case is made by a , but that gold is real!"
	icon = 'modular_zzplurt/icons/obj/service/bureaucracy.dmi'
	icon_state = "pen-fountain-nt"
	colour = "#0d5374"
	custom_materials = list(/datum/material/gold = SMALL_MATERIAL_AMOUNT*7.5)

/obj/structure/bed/dogbed/luxury
	name = "luxury dog bed"
	desc = "A extremely luxurious imported mahogany wooden dog bed with a very soft comfy-looking cloth pillow. You can even strap your pet in, in case the gravity turns off."
	icon = 'modular_zzplurt/icons/obj/bed.dmi'
	icon_state = "luxury_dogbed"
	anchored = TRUE

/mob/living/basic/pet/dog/corgi/lisa
	icon = 'modular_zzplurt/icons/mob/pets.dmi'

/mob/living/basic/pet/syndifox/centfox
	name = "Cent-Fox"
	real_name = "Cent-Fox"
	gold_core_spawnable = NO_SPAWN
	ai_controller = /datum/ai_controller/basic_controller/fox
	desc = "It's a Nanotrasen Robotics Division (TM) AuriFox robotic model made out of pure gold wearing a microsized Corporate MODsuit and a cute little cap. How fancy! \
		Don't tell anyone, but this was the result of Nanotrasen wanting the same kinda robotic buddy Syndicate had, so they just copied them, a cheap method."
	icon = 'modular_zzplurt/icons/mob/pets.dmi'
	icon_state = "centfox"
	icon_living = "centfox"
	icon_dead = "centfox_dead"
	faction = list(FACTION_NEUTRAL)
	unique_pet = TRUE
	///list of our pet commands we follow
	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/move,
		/datum/pet_command/free,
		/datum/pet_command/follow/start_active,
		/datum/pet_command/attack,
		/datum/pet_command/perform_trick_sequence,
	)

/mob/living/basic/pet/syndifox/centfox/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/obeys_commands, pet_commands)
	AddElement(/datum/element/wears_collar)
	AddElement(/datum/element/pet_bonus, "yap")
	AddElement(/datum/element/footstep, footstep_type = FOOTSTEP_MOB_CLAW)
	AddElement(/datum/element/tiny_mob_hunter, MOB_SIZE_SMALL)
	AddElement(/datum/element/ai_retaliate)

/obj/effect/spawner/random/ntc_pet
	name = "NT Consultant pet spawner"
	desc = "D'awww!"
	loot = list(
		/mob/living/basic/pet/syndifox/centfox = 1,
		/mob/living/basic/pet/dog/corgi/lisa = 1,
	)

/obj/item/clothing/accessory/bubber/acc_medal/neckpin/nanotrasen
	name = "\improper Nanotrasen Executive neckpin"
	icon_state = "/obj/item/clothing/accessory/bubber/acc_medal/neckpin"
	post_init_icon_state = "ntpin"
	greyscale_colors = "#FFD351#E09100"

/obj/item/modular_computer/pda/heads/nanotrasen_consultant
	name = "nanotrasen executive PDA"
	icon_state = "/obj/item/modular_computer/pda/heads/nanotrasen_consultant"
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick/head
	greyscale_colors = "#42B5A6#0C9900#FAFAFA"
	inserted_disk = /obj/item/disk/computer/command/consultant
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
	gloves = /obj/item/clothing/gloves/captain/centcom //Too iconic to be replaced with a plasma version
	head = /obj/item/clothing/head/helmet/space/plasmaman/centcom_official

/datum/outfit/job/nanotrasen_consultant
	name = "Nanotrasen Consultant"
	jobtype = /datum/job/nanotrasen_consultant

	glasses = /obj/item/clothing/glasses/hud/civilian/sunglasses
	ears = /obj/item/radio/headset/heads/ntc
	gloves = /obj/item/clothing/gloves/combat
	uniform =  /obj/item/clothing/under/rank/nanotrasen/commander
	suit = /obj/item/clothing/suit/armor/nanotrasen_greatcoat
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/hats/nanotrasen_cap
	belt = /obj/item/modular_computer/pda/heads/nanotrasen_consultant
	backpack_contents = list(
		/obj/item/melee/baton/telescopic/silver = 1,
		/obj/item/folder/biscuit/confidential/ntc_safe_code = 1,
		/obj/item/choice_beacon/nanotrasen_consultant = 1,
		)

	pda_slot = ITEM_SLOT_BELT
	skillchips = list(/obj/item/skillchip/disk_verifier)

	backpack = /obj/item/storage/backpack/nanotrasen
	satchel = /obj/item/storage/backpack/satchel/nanotrasen
	duffelbag = /obj/item/storage/backpack/duffelbag/nanotrasen
	messenger = /obj/item/storage/backpack/messenger/nanotrasen

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/bubber/acc_medal/neckpin/nanotrasen

	chameleon_extras = list(/obj/item/gun/energy/e_gun/asterion, /obj/item/stamp/head/ntc)

	id = /obj/item/card/id/advanced/platinum
	id_trim = /datum/id_trim/job/nanotrasen_consultant

/area/station/command/heads_quarters/nt_rep
	name = "Nanotrasen Internal Affairs Office"

/obj/item/storage/lockbox/medal/ntc
	name = "Nanotrasen Consultant medal box"
	desc = "A locked box used to store medals to be given to those exhibiting excellence in affairs."
	req_access = list(ACCESS_CENT_CAPTAIN)
	icon = 'modular_zzplurt/icons/obj/case.dmi'
	icon_state = "ntcbox+l"
	icon_locked = "ntcbox+l"
	icon_closed = "ntcbox"

/obj/item/storage/lockbox/medal/ntc/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/silver/bureaucracy(src)
	new /obj/item/clothing/accessory/medal/gold/heroism(src)
	new /obj/item/clothing/accessory/medal/gold/nanotrasen_consultant(src)
	new /obj/item/clothing/accessory/medal/gold/ordom(src)

/obj/item/disk/computer/command/consultant
	name = "consultant data disk"
	desc = "Removable disk used to download essential Consultant tablet apps."
	icon_state = "datadisk8"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/job_management,
	)

/obj/item/bedsheet/ntc
	name = "nanotrasen consultant's bedsheet"
	desc = "Woven with advanced nanothread for warmth as well as being very decorated, essential for one of Nanotrasen's finest."
	icon = 'modular_zzplurt/icons/obj/bedsheets.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/misc/bedsheet_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/misc/bedsheet_righthand.dmi'
	slot_flags = null // I CAN'T FIX THE MOB SPRITE, HELP.
	icon_state = "sheetntc"
	inhand_icon_state = "sheetntc"
	dream_messages = list("HoS abusing his powers", "reprimanding an assistant", "expensive champagne", "a golden N", "ultimate power", "the nanotrasen consultant")

/obj/item/bedsheet/ntc/double
	icon_state = "double_sheetntc"
	worn_icon_state = "sheetntc"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/folder/nanotrasen
	name = "folder"
	icon = 'modular_zzplurt/icons/obj/service/bureaucracy.dmi'
	icon_state = "folder_nanotrasen"

/obj/structure/safe/floor/ntc
	name = "Nanotrasen-brand gold-plated floor safe"
	desc = "A huge chunk of metal with a dial embedded in it, this time plated in gold.. Or is it just yellow paint? There's some red text on the front of the door, \"ANY NON-NANOTRASEN INTERNAL AFFAIRS TAMPERING WILL BE MET WITH SEVERE PUNISHMENT.\", how threatening. Fine print on the dial reads \"Nanotrasen Corporation - 2 tumbler safe, guaranteed thermite resistant, explosion resistant, and assistant resistant.\""
	icon = 'modular_zzplurt/icons/obj/structures.dmi'
	icon_state = "floorsafe_ntc"

/obj/structure/safe/floor/ntc/Initialize(mapload)
	. = ..()

	tumblers = list()
	for(var/v in GLOB.ntc_safe_combo)
		tumblers += v
	current_tumbler_index = 1
	dial = 0

	return

/obj/item/folder/biscuit/confidential/ntc_safe_code
	name = "Nanotrasen internal affairs safe combination biscuit card"
	contained_slip = /obj/item/paper/paperslip/corporate/fluff/ntc_safe_code

/obj/item/paper/paperslip/corporate/fluff/ntc_safe_code
	name = "Nanotrasen-Issued Internal Affairs Safe Combination"
	desc = "A small corporate plastic card with the Consultant's safe combination."

/obj/item/paper/paperslip/corporate/fluff/ntc_safe_code/Initialize(mapload)

	var/ntc_code = jointext(GLOB.ntc_safe_combo, "-")

	default_raw_text = "<b><h1>Welcome to your new position upon one of our state-of-the-art research stations.<h2></b><br><br>You have been issued \
		this card to defend some important dossier files.<br><br><b>Do NOT</b> forget this code, and <b>do NOT</b> let it get into enemy hands.<br><br>The \
		combination is <i>[ntc_code]</i>.<br><br>The safe is located behind your desk next to your chair underneath the carpet. Good luck, \
		Consultant, do not let us down."
	icon_state = "corppaperslip_words"
	return ..()
