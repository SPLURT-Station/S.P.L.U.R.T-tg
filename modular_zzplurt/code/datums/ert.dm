// PRIVATE SECURITY ERT - MORE BALLISTIC THAN LASER
/datum/ert/private_security
	code = "Security Red"
	roles = list(/datum/antagonist/ert/private_security/operative, /datum/antagonist/ert/private_security/medic, /datum/antagonist/ert/private_security/sergeant)
	leader_role = /datum/antagonist/ert/private_security/leader
	teamsize = 7
	opendoors = FALSE
	notify_players = FALSE
	rename_team = "Squad of Private Security"
	mission = "Assist the station."
	polldesc = "a Nanotrasen Private Security Team"
	random_names = FALSE

/datum/antagonist/ert/private_security/operative
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
	name = "NT Private Security Captain"
	outfit = /datum/outfit/centcom/private_security/captain
	random_names = FALSE
	role = "Captain"

// ERT OUTFITS
/datum/outfit/centcom/private_security
	name = "NT Private Security Base - ERT"

	var/rank_name

	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/intern/privatesecurity
	uniform = /obj/item/clothing/under/rank/security/splurt/ntps
	suit = /obj/item/clothing/suit/armor/vest
	back = /obj/item/storage/backpack/satchel/sec/redsec
	belt = /obj/item/storage/belt/security/redsec/full
	ears = /obj/item/radio/headset/headset_cent/alt/privsec
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/redsec
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	gloves = /obj/item/clothing/gloves/tackler/combat/black
	shoes = /obj/item/clothing/shoes/combat
	l_pocket = /obj/item/storage/pouch/ammo
	r_pocket = /obj/item/flashlight/seclite

	skillchips = list(/obj/item/skillchip/disk_verifier)

/datum/id_trim/centcom/intern/privatesecurity
	assignment = "Nanotrasen Private Security Operative"
	trim_state = "trim_centcom"
	sechud_icon_state = SECHUD_CENTCOM
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_SECURITY_RED
	honorifics = null

/datum/outfit/centcom/private_security/operative
	name = "NT Private Security Operative - ERT"

	id_trim = /datum/id_trim/centcom/intern/privatesecurity
	l_pocket = /obj/item/storage/pouch/ammo
	r_pocket = /obj/item/flashlight/seclite

	skillchips = list(/obj/item/skillchip/disk_verifier)

/datum/outfit/centcom/private_security/operative/pre_equip(mob/living/carbon/human/H)
	. = ..()

	var/list/gun_loadouts = list(
		list(
			"gun" = /obj/item/gun/ballistic/automatic/wt550/loyalpin,
			"mag" = /obj/item/ammo_box/magazine/wt550m9
		),
		list(
			"gun" = /obj/item/gun/ballistic/automatic/mps5/loyalpin,
			"mag" = /obj/item/ammo_box/magazine/mps5
		),
		list(
			"gun" = /obj/item/gun/ballistic/automatic/mps5/loyalpin,
			"mag" = /obj/item/ammo_box/magazine/mps5
		)
	)

	var/list/chosen = pick(gun_loadouts)

	l_hand = chosen["gun"]

	backpack_contents = list(
		/obj/item/storage/box/survival/security = 1,
		/obj/item/storage/box/handcuffs = 1,
		/obj/item/gun/energy/e_gun/advtaser = 1
	)

	backpack_contents[chosen["mag"]] = 3

	src.rank_name = pick(list(
		"Private",
		"Private",
		"Corporal"
	))

	// --- Uniform selection ---
	if(src.rank_name == "Corporal")
		uniform = pick(list(
			/obj/item/clothing/under/rank/security/splurt/ntps/corporal,
			/obj/item/clothing/under/rank/security/splurt/ntps/corporal/turtleneck
		))
	else
		uniform = pick(list(
			/obj/item/clothing/under/rank/security/splurt/ntps,
			/obj/item/clothing/under/rank/security/splurt/ntps/turtleneck,
			/obj/item/clothing/under/rank/security/splurt/ntps/fatigues
		))

	head = pick(list(
		/obj/item/clothing/head/security_garrison/ntps,
		/obj/item/clothing/head/soft/sec/ntps,
		/obj/item/clothing/head/beret/sec/ntps
	))

/datum/outfit/centcom/private_security/operative/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	if(src.rank_name == "Corporal")
		if(!istype(H.head, /obj/item/clothing/head/helmet))
			if(H.head)
				qdel(H.head)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/swat/nanotrasen/ntps(H), ITEM_SLOT_HEAD)

	apply_rank(H, src.rank_name)

	return ..()

/datum/outfit/centcom/private_security/medic
	name = "NT Private Security Specialist - ERT"

	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/ert/medical/privatesecurity
	belt = /obj/item/storage/belt/medical/privsec/full
	ears = /obj/item/radio/headset/headset_cent/alt/privsec/medic
	head = /obj/item/clothing/head/helmet/swat/nanotrasen/ntps
	glasses = /obj/item/clothing/glasses/hud/medsechud/sunglasses
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	l_pocket = /obj/item/storage/pouch/medical/loaded
	l_hand = /obj/item/gun/ballistic/shotgun/automatic/combat/lethal/loyalpin
	r_hand = /obj/item/storage/medkit/advanced

	backpack_contents = list(/obj/item/storage/box/survival/security = 1,\
		/obj/item/storage/medkit/tactical/ntrauma = 1,\
		/obj/item/gun/energy/e_gun/advtaser = 1,\
		/obj/item/storage/box/lethalshot = 2,\
		/obj/item/storage/box/slugs = 1,
		)

/datum/id_trim/centcom/ert/medical/privatesecurity
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_SPECIALIST
	trim_state = "trim_centcom"
	sechud_icon_state = SECHUD_CENTCOM
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_MEDICAL_BLUE
	big_pointer = FALSE
	honorifics = null

/datum/outfit/centcom/private_security/medic/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	apply_rank(H, "Specialist")

	return ..()

/datum/outfit/centcom/private_security/medic/pre_equip(mob/living/carbon/human/H)
	. = ..()

	uniform = pick(list(
		/obj/item/clothing/under/rank/security/splurt/ntps,
		/obj/item/clothing/under/rank/security/splurt/ntps/turtleneck,
		/obj/item/clothing/under/rank/security/splurt/ntps/fatigues
	))

	return ..()

/datum/outfit/centcom/private_security/sergeant
	name = "NT Private Security Sergeant - ERT"

	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/centcom/ert/security/privatesecurity
	uniform = /obj/item/clothing/under/rank/security/splurt/ntps/sergeant
	head = /obj/item/clothing/head/helmet/swat/nanotrasen/ntps/sergeant
	l_hand = /obj/item/gun/ballistic/automatic/proto/loyalpin

	backpack_contents = list(/obj/item/storage/box/survival/security = 1,\
		/obj/item/storage/box/handcuffs = 1,\
		/obj/item/gun/energy/e_gun/advtaser = 1,\
		/obj/item/ammo_box/magazine/smgm9mm = 3,\
		/obj/item/melee/baton/telescopic/silver = 1,
		)

/datum/id_trim/centcom/ert/security/privatesecurity
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_SERGEANT
	trim_state = "trim_centcom"
	sechud_icon_state = SECHUD_CENTCOM
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_SECURITY_RED
	big_pointer = TRUE
	honorifics = null

/datum/outfit/centcom/private_security/sergeant/pre_equip(mob/living/carbon/human/H)
	. = ..()

	uniform = pick(list(
		/obj/item/clothing/under/rank/security/splurt/ntps/sergeant,
		/obj/item/clothing/under/rank/security/splurt/ntps/sergeant/turtleneck
	))

	return ..()

/datum/outfit/centcom/private_security/sergeant/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/rank_name = pick(list(
		"Sergeant",
		"Sergeant",
		"Second Lieutenant"
	))

	apply_rank(H, rank_name)

	return ..()

/datum/outfit/centcom/private_security/captain
	name = "NT Private Security Captain - ERT"

	id = /obj/item/card/id/advanced/platinum
	id_trim = /datum/id_trim/centcom/ert/commander/privatesecurity
	uniform = /obj/item/clothing/under/rank/security/splurt/ntps/captain
	belt = /obj/item/storage/belt/security/webbing/peacekeeper/armadyne/privsec/full
	ears = /obj/item/radio/headset/headset_cent/alt/privsec/leader
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated

	backpack_contents = list(/obj/item/storage/box/survival/security = 1,\
		/obj/item/storage/box/handcuffs = 1,\
		/obj/item/gun/energy/e_gun/advtaser = 1,\
		/obj/item/ammo_box/magazine/c68 = 3,\
		/obj/item/shield/riot/tele = 1,\
		/obj/item/melee/baton/telescopic/gold = 1,
		)

/datum/id_trim/centcom/ert/commander/privatesecurity
	assignment = JOB_CENTCOM_PRIVATE_SECURITY_CAPTAIN
	trim_state = "trim_centcom"
	sechud_icon_state = SECHUD_CENTCOM
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_SECURITY_RED
	big_pointer = TRUE
	honorifics = null

/datum/outfit/centcom/private_security/captain/pre_equip(mob/living/carbon/human/H)
	. = ..()

	l_hand = pick(list(
		/obj/item/gun/ballistic/automatic/bulwark/loyalpin,
		/obj/item/gun/ballistic/automatic/bulwark/loyalpin,
		/obj/item/gun/ballistic/automatic/bulwark/suppressed/loyalpin,
		/obj/item/gun/ballistic/automatic/bulwark/taser/loyalpin
	))

	head = pick(list(
		/obj/item/clothing/head/beret/sec/ntps/captain,
		/obj/item/clothing/head/hats/hos/cap/captain
	))

	return ..()

/datum/outfit/centcom/private_security/captain/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	apply_rank(H, "Captain")

	var/has_taser_bulwark = FALSE

	// Check both hands
	for(var/obj/item/I in H.get_equipped_items())
		if(istype(I, /obj/item/gun/ballistic/automatic/bulwark/taser))
			has_taser_bulwark = TRUE
			break

	if(has_taser_bulwark)
		for(var/obj/item/gun/energy/e_gun/advtaser/T in H.contents)
			qdel(T)

	return ..()

// MISC ERT CODE
/datum/outfit/centcom/private_security/proc/apply_rank(mob/living/carbon/human/H, rank_name)
	if(!H)
		return

	var/list/rank_abbrev = list(
		"Private" = "Pvt.",
		"Specialist" = "Spc.",
		"Corporal" = "Cpl.",
		"Sergeant" = "Sgt.",
		"Second Lieutenant" = "2nd Lt.",
		"Captain" = "Cpt."
	)

	var/list/rank_paths = list(
		"Private" = /obj/item/clothing/accessory/rank/private,
		"Specialist" = /obj/item/clothing/accessory/rank/specialist,
		"Corporal" = /obj/item/clothing/accessory/rank/corporal,
		"Sergeant" = /obj/item/clothing/accessory/rank/sergeant,
		"Second Lieutenant" = /obj/item/clothing/accessory/rank/officer,
		"Captain" = /obj/item/clothing/accessory/rank/officer/captain
	)

	// --- Attach rank patch ---
	var/rank_path = rank_paths[rank_name]
	var/obj/item/clothing/under/U = H.w_uniform
	if(U && rank_path)
		var/obj/item/clothing/accessory/A = SSwardrobe.provide_type(rank_path, H)
		U.attach_accessory(A)

	// --- Name handling ---
	var/abbr = rank_abbrev[rank_name]
	var/original_name = H.real_name
	var/new_name = original_name

	if(abbr)
		new_name = "[abbr] [original_name]"
		if(findtext(original_name, abbr) != 1)
			H.fully_replace_character_name(original_name, new_name)

	// --- Update ID ---
	var/obj/item/card/id/W = H.wear_id
	if(W)
		W.registered_name = new_name

		W.assignment = "Private Security [rank_name]"

		W.update_label()
		W.update_icon()

	// --- Update antagonist role ---
	if(H.mind && H.mind.antag_datums)
		for(var/datum/antagonist/A in H.mind.antag_datums)
			if(istype(A, /datum/antagonist/ert/private_security))
				var/datum/antagonist/ert/private_security/PS = A
				PS.role = rank_name
				PS.name = "NT Private Security [rank_name]"
				break

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

/obj/item/gun/ballistic/automatic/proto/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/ballistic/automatic/wt550/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/ballistic/automatic/mps5/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/ammo_box/magazine/internal/shot/com/lethal
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot

/obj/item/gun/ballistic/shotgun/automatic/combat/lethal
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/com/lethal

/obj/item/gun/ballistic/shotgun/automatic/combat/lethal/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/ballistic/automatic/bulwark/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/ballistic/automatic/bulwark/suppressed/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/S = new(src)
	install_suppressor(S)

/obj/item/gun/ballistic/automatic/bulwark/suppressed/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/ballistic/automatic/bulwark/taser/loyalpin
	pin = /obj/item/firing_pin/implant/mindshield
