/obj/structure/closet/secure_closet/nanotrasen_consultant_new
	name = "nanotrasen consultant's locker"
	req_access = list()
	req_one_access = list(ACCESS_CENT_GENERAL, ACCESS_COMMAND)
	icon_state = "nt"
	icon = 'modular_zzplurt/icons/obj/closet.dmi'

/obj/structure/closet/secure_closet/nanotrasen_consultant_new/PopulateContents()
	..()
	new /obj/item/storage/backpack/satchel/leather(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/pet_carrier(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/computer_disk/command/captain(src)
	new /obj/item/radio/headset/heads/nanotrasen(src)
	new /obj/item/storage/photo_album/ntc(src)
	new /obj/item/bedsheet/centcom(src)
	new /obj/item/storage/bag/garment/nanotrasen_consultant_new(src)

/obj/item/storage/bag/garment/nanotrasen_consultant_new
	name = "nanotrasen consultant's garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the Nanotrasen Consultant."

/obj/item/storage/bag/garment/nanotrasen_consultant_new/PopulateContents()
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/gloves/combat(src)
	new /obj/item/clothing/gloves/captain/nanotrasen(src)
	new /obj/item/clothing/under/rank/nanotrasen/commander(src)
	new /obj/item/clothing/under/rank/nanotrasen/commander/skirt(src)
	new /obj/item/clothing/under/rank/nanotrasen/official(src)
	new /obj/item/clothing/under/rank/nanotrasen/official/turtleneck(src)
	new /obj/item/clothing/under/rank/nanotrasen/tactical(src)
	new /obj/item/clothing/under/rank/nanotrasen/tactical/skirt(src)
	new /obj/item/clothing/suit/hooded/wintercoat/nanotrasen(src)
	new /obj/item/clothing/head/beret/nanotrasen_formal(src)
	new /obj/item/clothing/head/hats/nanotrasenhat(src)
	new /obj/item/clothing/head/hats/nanotrasen_cap(src)
	new /obj/item/clothing/suit/armor/nanotrasen_formal(src)
	new /obj/item/clothing/suit/armor/nanotrasen_greatcoat(src)
	new /obj/item/clothing/suit/armor/vest/capcarapace/nanotrasen(src)
	new /obj/item/clothing/suit/armor/vest/nt_officerfake(src)

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

/datum/loadout_item/accessory/medal/nt_pin/executive
	name = "Neckpin - Nanotrasen Executive"
	item_path = /obj/item/clothing/accessory/bubber/acc_medal/neckpin/nanotrasen
	restricted_roles = list(JOB_NT_REP, JOB_NT_TRN, JOB_BLUESHIELD)

/obj/item/clothing/accessory/bubber/acc_medal/neckpin/nanotrasen
	name = "\improper Nanotrasen Executive neckpin"
	icon_state = "/obj/item/clothing/accessory/bubber/acc_medal/neckpin"
	post_init_icon_state = "ntpin"
	greyscale_colors = "#FFD351#E09100"

/obj/item/modular_computer/pda/nanotrasen_consultant_new
	name = "nanotrasen executive PDA"
	icon_state = "/obj/item/modular_computer/pda/nanotrasen_consultant_new"
	inserted_disk = /obj/item/computer_disk/command/captain
	inserted_item = /obj/item/pen/fountain/nanotrasen
	greyscale_config = /datum/greyscale_config/tablet/stripe_thick/head
	greyscale_colors = "#227291#B4B9C6#B4B9C6"

/datum/outfit/job/nanotrasen_consultant_new
	name = "Nanotrasen Consultant - NEW"
	jobtype = /datum/job/nanotrasen_consultant

	belt = /obj/item/modular_computer/pda/nanotrasen_consultant
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/heads/nanotrasen
	gloves = /obj/item/clothing/gloves/combat
	uniform =  /obj/item/clothing/under/rank/nanotrasen/commander
	suit = /obj/item/clothing/suit/armor/nanotrasen_greatcoat
	suit_store = /obj/item/gun/energy/e_gun
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/hats/nanotrasen_cap
	backpack_contents = list(
		/obj/item/melee/baton/telescopic/silver = 1,
		)

	skillchips = list(/obj/item/skillchip/disk_verifier)

	backpack = /obj/item/storage/backpack/blueshield
	satchel = /obj/item/storage/backpack/satchel/blueshield
	duffelbag = /obj/item/storage/backpack/duffelbag/blueshield
	messenger = /obj/item/storage/backpack/messenger/blueshield

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/bubber/acc_medal/neckpin/nanotrasen

	chameleon_extras = list(/obj/item/gun/energy/e_gun, /obj/item/stamp/nanotrasen)

	id = /obj/item/card/id/advanced/platinum
	id_trim = /datum/id_trim/job/nanotrasen_consultant

/area/station/command/heads_quarters/nt_rep
	name = "Nanotrasen Internal Affairs Office"
