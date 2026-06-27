// Basic Uniforms / NON-ERT, FROM INTERN TO COMMANDER.
/datum/outfit/centcom
	name = "CentCom Base"

	id = /obj/item/card/id/advanced/centcom
	uniform = /obj/item/clothing/under/rank/centcom/officer
	box = /obj/item/storage/box/survival/centcom
	ears = /obj/item/radio/headset/headset_cent
	shoes = /obj/item/clothing/shoes/sneakers/black

/datum/outfit/centcom/post_equip(mob/living/carbon/human/centcom_member, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/implant/mindshield/mindshield = new /obj/item/implant/mindshield(centcom_member)//hmm lets have centcom officials become revs
	mindshield.implant(centcom_member, null, silent = TRUE)

	var/obj/item/card/id/W = centcom_member.wear_id
	W.registered_name = centcom_member.real_name
	W.update_label()
	W.update_icon()
	centcom_member.add_faction(ROLE_DEATHSQUAD) // Can't exactly let the NT mobs and whatnot kill CentCom right?
	centcom_member.update_icons()

/datum/outfit/centcom/commander
	name = "CentCom Commander"

	id_trim = /datum/id_trim/centcom/commander
	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/armor/centcom_formal
	suit_store = /obj/item/gun/ballistic/revolver/mateba
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
		/obj/item/stamp/centcom/commander = 1,
		/obj/item/ammo_box/speedloader/c357 = 2,
	)
	belt = /obj/item/storage/belt/sheath/sabre
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	head = /obj/item/clothing/head/hats/centcom_cap
	shoes = /obj/item/clothing/shoes/combat/swat
	l_pocket = /obj/item/melee/baton/telescopic/gold
	r_pocket = /obj/item/modular_computer/pda/heads/centcom

/datum/outfit/centcom/commander/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/modular_computer/pda/heads/pda = H.r_store
	pda.imprint_id(H.real_name, "CentCom Commander")

/datum/outfit/centcom/commander/mod
	name = "CentCom Commander (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	suit = null
	head = null
	mask = /obj/item/clothing/mask/gas/sechailer
	back = /obj/item/mod/control/pre_equipped/corporate
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/outfit/centcom/centcom_official
	name = "CentCom Official"

	id_trim = /datum/id_trim/centcom/official
	uniform = /obj/item/clothing/under/rank/centcom/official
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/stamp/centcom = 1,
		/obj/item/pen/fountain/centcom/silver = 1,
	)
	belt = /obj/item/gun/energy/e_gun
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/black
	l_pocket = /obj/item/melee/baton/telescopic/silver
	r_pocket = /obj/item/modular_computer/pda/heads/centcom
	l_hand = /obj/item/clipboard/centcom

/datum/outfit/centcom/centcom_official/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/modular_computer/pda/heads/pda = H.r_store
	pda.imprint_id(H.real_name, "CentCom Official")

/datum/outfit/centcom/centcom_official/turtleneck
	name = "CentCom Official - Turtleneck"

	uniform = /obj/item/clothing/under/rank/centcom/official/turtleneck

/datum/outfit/centcom/centcom_intern
	name = "CentCom Intern"

	id_trim = /datum/id_trim/centcom/intern
	uniform = /obj/item/clothing/under/rank/centcom/intern
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/melee/baton
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/black
	l_pocket = /obj/item/ammo_box/speedloader/strilka310
	r_pocket = /obj/item/ammo_box/speedloader/strilka310
	l_hand = /obj/item/gun/ballistic/rifle/boltaction

/datum/outfit/centcom/centcom_intern/unarmed
	name = "CentCom Intern (Unarmed)"

	belt = null
	l_pocket = null
	r_pocket = null
	l_hand = null

/datum/outfit/centcom/centcom_intern/leader
	name = "CentCom Head Intern"

	suit = /obj/item/clothing/suit/armor/vest
	suit_store = /obj/item/gun/ballistic/rifle/boltaction
	belt = /obj/item/melee/baton/security/loaded
	head = /obj/item/clothing/head/hats/intern
	l_hand = /obj/item/megaphone

/datum/outfit/centcom/centcom_intern/leader/unarmed // i'll be nice and let the leader keep their baton and vest
	name = "CentCom Head Intern (Unarmed)"

	suit_store = null
	l_pocket = null
	r_pocket = null

/datum/outfit/centcom/ert
	name = "ERT Common"

	uniform = /obj/item/clothing/under/rank/centcom/officer
	ears = /obj/item/radio/headset/headset_cent/alt
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/sechailer
	shoes = /obj/item/clothing/shoes/combat/swat
	var/additional_radio

/datum/outfit/centcom/ert/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/radio/headset/R = H.ears
	R.set_frequency(FREQ_CENTCOM)
	R.freqlock = RADIO_FREQENCY_LOCKED
	if(additional_radio)
		R.keyslot2 = new additional_radio()
		R.recalculateChannels()

	var/obj/item/card/id/W = H.wear_id
	if(W)
		W.registered_name = H.real_name
		W.update_label()
		W.update_icon()
	return ..()

/datum/outfit/centcom/ert/commander
	name = "ERT Commander"

	id = /obj/item/card/id/advanced/centcom/ert/commander
	back = /obj/item/mod/control/pre_equipped/responsory/commander
	l_hand = /obj/item/gun/energy/e_gun
	box = /obj/item/storage/box/survival/centcom
	backpack_contents = list(
		/obj/item/melee/baton/security/loaded = 1,
	)
	belt = /obj/item/storage/belt/security/full
	ears = /obj/item/radio/headset/headset_cent/alt/leader
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	l_pocket = /obj/item/switchblade
	additional_radio = /obj/item/encryptionkey/heads/captain

/datum/outfit/centcom/ert/commander/alert
	name = "ERT Commander - High Alert"

	l_hand = /obj/item/gun/energy/disabler/smg
	backpack_contents = list(
		/obj/item/gun/energy/e_gun/blueshield, // /obj/item/gun/energy/pulse/pistol/loyalpin = 1, BUBBER EDIT
		/obj/item/melee/baton/security/loaded = 1,
	)
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	l_pocket = /obj/item/melee/energy/sword/saber
	suit_store = /obj/item/gun/energy/laser/assault

/datum/outfit/centcom/ert/security
	name = "ERT Security"

	id = /obj/item/card/id/advanced/centcom/ert/security
	back = /obj/item/mod/control/pre_equipped/responsory/security
	l_hand = /obj/item/gun/energy/e_gun/stun
	box = /obj/item/storage/box/survival/centcom
	backpack_contents = list(
		/obj/item/melee/baton/security/loaded = 1,
		/obj/item/storage/box/handcuffs = 1,
	)
	belt = /obj/item/storage/belt/security/full
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	additional_radio = /obj/item/encryptionkey/heads/hos

/datum/outfit/centcom/ert/security/alert
	name = "ERT Security - High Alert"

	l_hand = /obj/item/gun/energy/pulse/carbine/loyalpin
	backpack_contents = list(
		/obj/item/melee/baton/security/loaded = 1,
		/obj/item/storage/box/handcuffs = 1,
	)

/datum/outfit/centcom/ert/medic
	name = "ERT Medic"

	id = /obj/item/card/id/advanced/centcom/ert/medical
	back = /obj/item/mod/control/pre_equipped/responsory/medic
	box = /obj/item/storage/box/survival/centcom
	backpack_contents = list(
		/obj/item/gun/medbeam = 1,
		/obj/item/melee/baton/security/loaded = 1,
		/obj/item/reagent_containers/hypospray/combat = 1,
		/obj/item/storage/box/hug/plushes = 1,
	)
	belt = /obj/item/storage/belt/medical/ert
	glasses = /obj/item/clothing/glasses/hud/health
	l_hand = /obj/item/storage/medkit/regular
	r_hand = /obj/item/gun/energy/e_gun
	l_pocket = /obj/item/healthanalyzer/advanced
	additional_radio = /obj/item/encryptionkey/heads/cmo

	skillchips = list(/obj/item/skillchip/entrails_reader)

/datum/outfit/centcom/ert/medic/alert
	name = "ERT Medic - High Alert"

	backpack_contents = list(
		/obj/item/gun/energy/e_gun/mini, // /obj/item/gun/energy/pulse/pistol/loyalpin = 1, - BUBBER EDIT
		/obj/item/gun/medbeam = 1,
		/obj/item/melee/baton/security/loaded = 1,
		/obj/item/reagent_containers/hypospray/combat/nanites = 1,
		/obj/item/storage/box/hug/plushes = 1,
	)
	mask = /obj/item/clothing/mask/gas/sechailer/swat

/datum/outfit/centcom/ert/engineer
	name = "ERT Engineer"

	id = /obj/item/card/id/advanced/centcom/ert/engineer
	back = /obj/item/mod/control/pre_equipped/responsory/engineer
	l_hand = /obj/item/gun/energy/e_gun
	box = /obj/item/storage/box/survival/centcom
	backpack_contents = list(
		/obj/item/construction/rcd/loaded/upgraded = 1,
		/obj/item/melee/baton/security/loaded = 1,
		/obj/item/pipe_dispenser = 1,
	)
	belt = /obj/item/storage/belt/utility/full/powertools
	glasses = /obj/item/clothing/glasses/meson/engine
	l_pocket = /obj/item/rcd_ammo/large
	additional_radio = /obj/item/encryptionkey/heads/ce


	skillchips = list(/obj/item/skillchip/job/engineer)

/datum/outfit/centcom/ert/engineer/alert
	name = "ERT Engineer - High Alert"

	backpack_contents = list(
		/obj/item/construction/rcd/combat = 1,
		/obj/item/gun/energy/e_gun/mini, // /obj/item/gun/energy/pulse/pistol/loyalpin = 1, - BUBBER EDIT
		/obj/item/melee/baton/security/loaded = 1,
		/obj/item/pipe_dispenser = 1,
	)

/datum/outfit/centcom/ert/commander/inquisitor
	name = "Inquisition Commander"

	back = /obj/item/mod/control/pre_equipped/responsory/inquisitory/commander
	r_hand = /obj/item/nullrod/claymore/talking/chainsword
	backpack_contents = null

/datum/outfit/centcom/ert/security/inquisitor
	name = "Inquisition Security"

	back = /obj/item/mod/control/pre_equipped/responsory/inquisitory/security
	backpack_contents = list(
		/obj/item/construction/rcd/loaded = 1,
		/obj/item/melee/baton/security/loaded = 1,
		/obj/item/storage/box/handcuffs = 1,
	)

/datum/outfit/centcom/ert/medic/inquisitor
	name = "Inquisition Medic"

	back = /obj/item/mod/control/pre_equipped/responsory/inquisitory/medic
	backpack_contents = list(
		/obj/item/gun/medbeam = 1,
		/obj/item/melee/baton/security/loaded = 1,
		/obj/item/reagent_containers/hypospray/combat = 1,
		/obj/item/reagent_containers/hypospray/combat/heresypurge = 1,
	)

/datum/outfit/centcom/ert/chaplain
	name = "ERT Chaplain"

	id = /obj/item/card/id/advanced/centcom/ert/chaplain
	back = /obj/item/mod/control/pre_equipped/responsory/chaplain
	l_hand = /obj/item/gun/energy/e_gun
	belt = /obj/item/storage/belt/soulstone
	glasses = /obj/item/clothing/glasses/hud/health
	box = /obj/item/storage/box/survival/centcom
	backpack_contents = list(
		/obj/item/nullrod = 1,
	)
	additional_radio = /obj/item/encryptionkey/heads/hop

/datum/outfit/centcom/ert/chaplain/inquisitor
	name = "Inquisition Chaplain"

	back = /obj/item/mod/control/pre_equipped/responsory/inquisitory/chaplain
	backpack_contents = list(
		/obj/item/grenade/chem_grenade/holy = 1,
		/obj/item/nullrod = 1,
	)
	belt = /obj/item/storage/belt/soulstone/full/chappy

/datum/outfit/centcom/ert/janitor
	name = "ERT Janitor"

	id = /obj/item/card/id/advanced/centcom/ert/janitor
	back = /obj/item/mod/control/pre_equipped/responsory/janitor
	box = /obj/item/storage/box/survival/centcom
	backpack_contents = list(
		/obj/item/grenade/clusterbuster/cleaner = 1,
		/obj/item/melee/baton/security/loaded = 1,
		/obj/item/mop/advanced = 1,
		/obj/item/reagent_containers/cup/bucket = 1,
		/obj/item/storage/box/lights/mixed = 1,
	)
	belt = /obj/item/storage/belt/janitor/full
	glasses = /obj/item/clothing/glasses/night
	l_pocket = /obj/item/grenade/chem_grenade/cleaner
	r_pocket = /obj/item/grenade/chem_grenade/cleaner
	l_hand = /obj/item/storage/bag/trash/bluespace
	additional_radio = /obj/item/encryptionkey/heads/hop

/datum/outfit/centcom/ert/janitor/heavy
	name = "ERT Janitor - Heavy Duty"

	backpack_contents = list(
		/obj/item/grenade/clusterbuster/cleaner = 3,
		/obj/item/melee/baton/security/loaded = 1,
		/obj/item/storage/box/lights/mixed = 1,
	)
	ears = /obj/item/radio/headset/headset_cent/alt/leader
	r_hand = /obj/item/reagent_containers/spray/chemsprayer/janitor

/datum/outfit/centcom/ert/clown
	name = "ERT Clown"

	id = /obj/item/card/id/advanced/centcom/ert/clown
	back = /obj/item/mod/control/pre_equipped/responsory/clown
	box = /obj/item/storage/box/survival/centcom
	backpack_contents = list(
		/obj/item/gun/ballistic/revolver/reverse = 1,
		/obj/item/melee/energy/sword/bananium = 1,
		/obj/item/shield/energy/bananium = 1,
	)
	belt = /obj/item/storage/belt/champion
	glasses = /obj/item/clothing/glasses/trickblindfold
	mask = /obj/item/clothing/mask/gas/clown_hat
	shoes = /obj/item/clothing/shoes/clown_shoes/combat
	l_pocket = /obj/item/food/grown/banana
	r_pocket = /obj/item/bikehorn/golden
	additional_radio = /obj/item/encryptionkey/heads/hop

/datum/outfit/centcom/ert/clown/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	..()
	if(visuals_only)
		return
	ADD_TRAIT(H.mind, TRAIT_NAIVE, INNATE_TRAIT)
	H.dna.add_mutation(/datum/mutation/clumsy, MUTATION_SOURCE_CLOWN_CLUMSINESS)

/datum/outfit/centcom/ert/janitor/party
	name = "ERP Cleaning Service"

	uniform = /obj/item/clothing/under/misc/overalls
	suit = /obj/item/clothing/suit/apron
	suit_store = null
	back = /obj/item/storage/backpack/ert/janitor
	backpack_contents = list(
		/obj/item/mop/advanced = 1,
		/obj/item/reagent_containers/cup/bucket = 1,
		/obj/item/storage/box/lights/mixed = 1,
	)
	belt = /obj/item/storage/belt/janitor/full
	glasses = /obj/item/clothing/glasses/meson
	mask = /obj/item/clothing/mask/bandana/blue
	l_pocket = /obj/item/grenade/chem_grenade/cleaner
	r_pocket = /obj/item/grenade/chem_grenade/cleaner
	l_hand = /obj/item/storage/bag/trash

/datum/outfit/centcom/ert/security/party
	name = "ERP Bouncer"

	uniform = /obj/item/clothing/under/misc/bouncer
	suit = /obj/item/clothing/suit/armor/vest
	suit_store = null
	back = /obj/item/storage/backpack/ert/security
	backpack_contents = list(
		/obj/item/clothing/head/hats/warden/police = 1,
		/obj/item/storage/box/handcuffs = 1,
	)
	belt = /obj/item/melee/baton/telescopic
	l_pocket = /obj/item/assembly/flash
	r_pocket = /obj/item/storage/wallet

/datum/outfit/centcom/ert/engineer/party
	name = "ERP Constructor"

	uniform = /obj/item/clothing/under/rank/engineering/engineer/hazard
	suit = /obj/item/clothing/suit/hazardvest
	suit_store = null
	back = /obj/item/storage/backpack/ert/engineer
	backpack_contents = list(
		/obj/item/construction/rcd/loaded = 1,
		/obj/item/etherealballdeployer = 1,
		/obj/item/stack/light_w = 30,
		/obj/item/stack/sheet/glass/fifty = 1,
		/obj/item/stack/sheet/iron/fifty = 1,
		/obj/item/stack/sheet/plasteel/twenty = 1,
	)
	head = /obj/item/clothing/head/utility/hardhat/welding
	mask = /obj/item/clothing/mask/gas/atmos
	l_hand = /obj/item/blueprints

/datum/outfit/centcom/ert/clown/party
	name = "ERP Comedian"

	uniform = /obj/item/clothing/under/rank/civilian/clown
	suit = /obj/item/clothing/suit/chameleon
	suit_store = null
	back = /obj/item/storage/backpack/ert/clown
	backpack_contents = list(
		/obj/item/instrument/piano_synth = 1,
		/obj/item/shield/energy/bananium = 1,
	)
	glasses = /obj/item/clothing/glasses/chameleon
	head = /obj/item/clothing/head/chameleon

/datum/outfit/centcom/ert/commander/party
	name = "ERP Coordinator"

	uniform = /obj/item/clothing/under/misc/coordinator
	suit = /obj/item/clothing/suit/coordinator
	suit_store = null
	back = /obj/item/storage/backpack/ert
	backpack_contents = list(
		/obj/item/food/cake/birthday = 1,
		/obj/item/storage/box/fireworks = 3,
	)
	belt = /obj/item/storage/belt/sheath/sabre
	head = /obj/item/clothing/head/hats/coordinator
	l_pocket = /obj/item/knife/kitchen
	l_hand = /obj/item/toy/balloon

/datum/outfit/centcom/death_commando
	name = "Death Commando"

	id = /obj/item/card/id/advanced/black/deathsquad
	id_trim = /datum/id_trim/centcom/deathsquad
	uniform = /obj/item/clothing/under/rank/centcom/commander
	back = /obj/item/mod/control/pre_equipped/apocryphal
	box = /obj/item/storage/box/survival/centcom
	backpack_contents = list(
		/obj/item/ammo_box/speedloader/c357 = 1,
		/obj/item/flashlight = 1,
		/obj/item/grenade/c4/x4 = 1,
		/obj/item/storage/box/flashbangs = 1,
		/obj/item/storage/medkit/regular = 1,
	)
	belt = /obj/item/gun/ballistic/revolver/mateba
	ears = /obj/item/radio/headset/headset_cent/alt
	glasses = /obj/item/clothing/glasses/hud/toggle/thermal
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	shoes = /obj/item/clothing/shoes/combat/swat
	l_pocket = /obj/item/melee/energy/sword/saber
	r_pocket = /obj/item/shield/energy/advanced
	l_hand = /obj/item/gun/energy/pulse/loyalpin

	skillchips = list(
		/obj/item/skillchip/disk_verifier,
	)

/datum/outfit/centcom/death_commando/post_equip(mob/living/carbon/human/squaddie, visuals_only = FALSE)
	if(visuals_only)
		return

	var/obj/item/radio/radio = squaddie.ears
	radio.set_frequency(FREQ_CENTCOM)
	radio.freqlock = RADIO_FREQENCY_LOCKED
	var/obj/item/card/id/id = squaddie.wear_id
	id.registered_name = squaddie.real_name
	id.update_label()
	id.update_icon()
	return ..()

/datum/outfit/centcom/death_commando/officer
	name = "Death Commando Officer"

	back = /obj/item/mod/control/pre_equipped/apocryphal/officer
	ears = /obj/item/radio/headset/headset_cent/alt/leader

/datum/outfit/centcom/death_commando/officer/post_equip(mob/living/carbon/human/squaddie, visuals_only = FALSE)
	. = ..()
	var/obj/item/mod/control/mod = squaddie.back
	if(!istype(mod))
		return
	var/obj/item/clothing/helmet = mod.get_part_from_slot(ITEM_SLOT_HEAD)
	var/obj/item/clothing/head/helmet/space/beret/beret = new(helmet)
	var/datum/component/hat_stabilizer/component = helmet.GetComponent(/datum/component/hat_stabilizer)
	component.attach_hat(beret)
	squaddie.update_clothing(helmet.slot_flags)
