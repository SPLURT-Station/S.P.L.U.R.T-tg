// PRIVATE SECURITY ERT - MORE BALLISTIC THAN LASER
/datum/ert/private_security
	code = "Security Red"
	roles = list(/datum/antagonist/ert/private_security, /datum/antagonist/ert/private_security/medic, /datum/antagonist/ert/private_security/sergeant)
	leader_role = /datum/antagonist/ert/private_security/leader
	teamsize = 6
	opendoors = FALSE
	rename_team = "Squad of Private Security"
	mission = "Assist the station."
	polldesc = "an Nanotrasen Private Security Team"
	random_names = FALSE

/datum/antagonist/ert/private_security
	name = "NT Private Security Operative"
	outfit = /datum/outfit/centcom/private_security
	plasmaman_outfit = /datum/outfit/plasmaman/centcom_intern
	random_names = FALSE
	role = "Operative"

/datum/antagonist/ert/private_security/medic
	name = "NT Private Security Specialist"
	outfit = /datum/outfit/centcom/private_security/medic
	random_names = FALSE
	role = "Specialist"

/datum/antagonist/ert/private_security/sergeant
	name = "NT Private Security Sergeant"
	outfit = /datum/outfit/centcom/private_security/sergeant
	random_names = FALSE
	role = "Sergeant"

/datum/antagonist/ert/private_security/leader
	name = "NT Private Security Commander"
	outfit = /datum/outfit/centcom/private_security/commander
	random_names = FALSE
	role = "Commander"

// ERT OUTFITS
/datum/outfit/centcom/private_security
	name = "NT Private Security Operative - ERT"

	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/corpse/private_security/lr
	uniform = /obj/item/clothing/under/rank/security/nanotrasen
	suit = /obj/item/clothing/suit/armor/vest
	back = /obj/item/storage/backpack/satchel/sec/redsec
	belt = /obj/item/storage/belt/security/redsec/full
	ears = /obj/item/radio/headset/headset_cent/alt/privsec
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/redsec
	head = /obj/item/clothing/head/helmet/swat/nanotrasen
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	gloves = /obj/item/clothing/gloves/tackler/combat/black
	shoes = /obj/item/clothing/shoes/combat
	l_pocket = /obj/item/storage/pouch/ammo
	r_pocket = /obj/item/flashlight/seclite
	l_hand = /obj/item/gun/ballistic/automatic/pistol/m1911/loyalpin
	accessory = /obj/item/clothing/accessory/rank

	skillchips = list(/obj/item/skillchip/disk_verifier)

	backpack_contents = list(/obj/item/storage/box/survival/security = 1,\
		/obj/item/storage/box/handcuffs = 1,\
		/obj/item/gun/energy/e_gun/advtaser = 1,\
		/obj/item/ammo_box/magazine/m45 = 3,
		)

/datum/outfit/centcom/private_security/medic
	name = "NT Private Security Specialist - ERT"

	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/corpse/private_security/med
	uniform = /obj/item/clothing/under/rank/security/nanotrasen/mr
	belt = /obj/item/storage/belt/medical/privsec/full
	ears = /obj/item/radio/headset/headset_cent/alt/privsec/medic
	glasses = /obj/item/clothing/glasses/hud/medsechud/sunglasses
	gloves = /obj/item/clothing/gloves/tackler/combat/nitrile
	l_pocket = /obj/item/storage/pouch/medical/loaded
	l_hand = /obj/item/gun/ballistic/shotgun/lethal/loyalpin
	r_hand = /obj/item/storage/medkit/advanced
	accessory = /obj/item/clothing/accessory/rank/corporal

	backpack_contents = list(/obj/item/storage/box/survival/security = 1,\
		/obj/item/storage/medkit/tactical/ntrauma = 1,\
		/obj/item/gun/energy/e_gun/advtaser = 1,\
		/obj/item/storage/box/lethalshot = 2,\
		/obj/item/storage/box/slugs = 1,
		)

/datum/outfit/centcom/private_security/sergeant
	name = "NT Private Security Sergeant - ERT"

	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/centcom/corpse/private_security/mr
	uniform = /obj/item/clothing/under/rank/security/nanotrasen/hr
	head = /obj/item/clothing/head/helmet/swat/nanotrasen/hr
	l_hand = /obj/item/gun/ballistic/automatic/wt550/loyalpin
	accessory = /obj/item/clothing/accessory/rank/sergeant

	backpack_contents = list(/obj/item/storage/box/survival/security = 1,\
		/obj/item/storage/box/handcuffs = 1,\
		/obj/item/gun/energy/e_gun/advtaser = 1,\
		/obj/item/ammo_box/magazine/wt550m9 = 3,
		)

/datum/outfit/centcom/private_security/commander
	name = "NT Private Security Commander - ERT"

	id = /obj/item/card/id/advanced/platinum
	id_trim = /datum/id_trim/centcom/corpse/private_security/hr
	uniform = /obj/item/clothing/under/rank/security/nanotrasen/hr
	belt = /obj/item/storage/belt/security/webbing/peacekeeper/armadyne/privsec/full
	ears = /obj/item/radio/headset/headset_cent/alt/privsec/leader
	head = /obj/item/clothing/head/helmet/swat/nanotrasen/commander
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	l_hand = /obj/item/gun/ballistic/automatic/proto/loyalpin
	accessory = /obj/item/clothing/accessory/rank/officer/captain

	backpack_contents = list(/obj/item/storage/box/survival/security = 1,\
		/obj/item/storage/box/handcuffs = 1,\
		/obj/item/gun/energy/e_gun/advtaser = 1,\
		/obj/item/ammo_box/magazine/smgm9mm = 3,\
		/obj/item/shield/riot/tele = 1,
		)

// MISC ERT CODE
/datum/outfit/centcom/private_security/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	W.update_icon()
	return ..()

/obj/item/storage/belt/security/redsec/full/PopulateContents()
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/melee/baton/security/loaded(src)
	update_appearance()

/obj/item/storage/belt/security/webbing/peacekeeper/armadyne/privsec
	name = "private security webbing"
	desc = "A tactical chest rig issued to fit security equipment, the added holster seems to help fit sidearms too."
	storage_type = /datum/storage/security_belt/webbing/holster

/datum/storage/security_belt/webbing/holster/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing/shotgun,
		/obj/item/assembly/flash/handheld,
		/obj/item/clothing/glasses,
		/obj/item/clothing/gloves,
		/obj/item/flashlight/seclite,
		/obj/item/food/donut,
		/obj/item/grenade,
		/obj/item/holosign_creator/security,
		/obj/item/knife/combat,
		/obj/item/melee/baton,
		/obj/item/radio,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/restraints/handcuffs,
		/obj/item/restraints/legcuffs/bola,
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/energy/taser,
		/obj/item/gun/energy/e_gun/mini,
		/obj/item/gun/energy/e_gun/advtaser,
		/obj/item/gun/energy/disabler,
	))

/obj/item/storage/belt/security/webbing/peacekeeper/armadyne/privsec/full/PopulateContents()
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/melee/baton/security/loaded(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)
	update_appearance()

/obj/item/storage/belt/medical/privsec
	name = "medical private security webbing"
	desc = "A tactical chest rig issued to fit medical supplies, a lack of a holster makes it less than easy to hold security equipment or sidearms."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/belt.dmi'
	icon_state = "peacekeeper_webbing"
	worn_icon_state = "peacekeeper_webbing"
	storage_type = /datum/storage/medical_belt/webbing

/datum/storage/medical_belt/webbing
	max_slots = 8
	open_sound = 'sound/items/handling/holster_open.ogg'
	open_sound_vary = TRUE
	rustle_sound = null

/obj/item/storage/belt/medical/privsec/full/PopulateContents()
	new /obj/item/sensor_device(src)
	new /obj/item/pinpointer/crew(src)
	new /obj/item/scalpel/advanced(src)
	new /obj/item/retractor/advanced(src)
	new /obj/item/blood_filter/advanced(src)
	new /obj/item/stack/medical/bone_gel(src)
	new /obj/item/cautery/advanced(src)
	new /obj/item/surgical_drapes(src)
	update_appearance()

/obj/item/radio/headset/headset_cent/alt/privsec
	keyslot2 = /obj/item/encryptionkey/headset_sec

/obj/item/radio/headset/headset_cent/alt/privsec/medic
	keyslot2 = /obj/item/encryptionkey/headset_medsec

/obj/item/radio/headset/headset_cent/alt/privsec/leader
	keyslot2 = /obj/item/encryptionkey/heads/hos
	command = TRUE

/obj/item/gun/ballistic/automatic/proto/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/ballistic/automatic/wt550/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/ballistic/automatic/pistol/m1911/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/ballistic/shotgun/lethal/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/clothing/accessory/rank
	name = "Private rank patch"
	desc = "A standard rank patch to designate what rank you are, this one is a singular Chevron, which indicates the rank of Private."
	icon = 'modular_zzplurt/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/accessories.dmi'
	icon_state = "chevron"
	attachment_slot = NONE

/obj/item/clothing/gloves/tackler/combat/nitrile
	name = "apex gloves"
	desc = "Premium quality combative sterile gloves, heavily reinforced to give the user an edge in close combat tackles, though they are more taxing to use than normal gripper gloves. As well as the benefit of being sterile gloves to swiftly assist with medical assistance."
	icon = 'modular_zzplurt/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/gloves.dmi'
	icon_state = "sterilecombat_gloves"
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH,TRAIT_FAST_CUFFING, TRAIT_QUICKER_CARRY, TRAIT_FASTMED)

/obj/item/clothing/gloves/tackler/combat/black
	icon = 'modular_skyrat/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/hands.dmi'
	icon_state = "combat"

/obj/item/clothing/accessory/rank/corporal
	name = "Corporal rank patch"
	desc = "A standard rank patch to designate what rank you are, this one is two Chevrons, which indicates the rank of Corporal."
	icon_state = "chevron_2"

/obj/item/clothing/accessory/rank/sergeant
	name = "Sergeant rank patch"
	desc = "A standard rank patch to designate what rank you are, this one is three Chevrons, which indicates the rank of Sergeant."
	icon_state = "chevron_3"

/obj/item/clothing/accessory/rank/officer
	name = "Second Lieutenant rank pin"
	desc = "A golden rank pin to designate what rank you are, this one is a singular golden bar, which indicates the rank of Second Lieutenant."
	icon_state = "one_bar_gold"

/obj/item/clothing/accessory/rank/officer/first
	name = "First Lieutenant rank pin"
	desc = "A silver rank pin to designate what rank you are, this one is a singular silver bar, which indicates the rank of First Lieutenant."
	icon_state = "one_bar_silver"

/obj/item/clothing/accessory/rank/officer/captain
	name = "Captain rank pin"
	desc = "A silver rank pin to designate what rank you are, this one is two silver bars, which indicates the rank of Captain."
	icon_state = "two_bar_silver"

