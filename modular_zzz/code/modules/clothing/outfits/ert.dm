/datum/outfit/centcom
	cybernetic_implants = list(
		/obj/item/organ/cyberimp/eyes/hud/security,
		/obj/item/organ/eyes/robotic/shield,
		/obj/item/organ/cyberimp/chest/nutriment/plus,
	)

	implants = list(/obj/item/implant/deathrattle)

/// ERT_COMM START ///

/datum/outfit/centcom/ert/commander
	l_hand = null
	suit_store = /obj/item/gun/energy/modular_laser_rifle
	backpack_contents = list(
		/obj/item/storage/medkit/advanced = 1,
		/obj/item/melee/baton/security/loaded = 1,
	)
	belt = /obj/item/storage/belt/military/ert_min
	ears = /obj/item/radio/headset/headset_cent/alt/leader
	l_pocket = /obj/item/gun/energy/e_gun/mini
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	glasses = /obj/item/clothing/glasses/night
	box = /obj/item/storage/box/centcom

/datum/outfit/centcom/ert/commander/alert
	l_hand = null
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	suit_store = /obj/item/gun/ballistic/automatic/ar
	backpack_contents = list(
		/obj/item/storage/box/m223_ammo = 1,
		/obj/item/storage/medkit/tactical/premium/ert = 1,
		/obj/item/melee/baton/security/loaded = 1,
	)
	belt = /obj/item/storage/belt/military/ert_max
	ears = /obj/item/radio/headset/headset_cent/alt/leader
	l_pocket = /obj/item/gun/energy/pulse/pistol/loyalpin
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	cybernetic_implants = list(
		/obj/item/organ/cyberimp/eyes/hud/security,
		/obj/item/organ/eyes/robotic/shield,
		/obj/item/organ/cyberimp/chest/nutriment/plus,
		/obj/item/organ/cyberimp/brain/anti_stun,
		/obj/item/organ/cyberimp/chest/reviver,
		/obj/item/organ/cyberimp/brain/anti_drop,
	)
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	box = /obj/item/storage/box/centcom

/// ERT_COMM END ///

/// ERT_SECU START ///

/datum/outfit/centcom/ert/security
	l_hand = null
	suit_store = /obj/item/gun/energy/modular_laser_rifle/carbine
	backpack_contents = list(
		/obj/item/storage/medkit/advanced = 1,
		/obj/item/melee/baton/security/loaded = 1,
	)
	belt = /obj/item/storage/belt/military/ert_min
	l_pocket = /obj/item/gun/energy/e_gun/mini
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	glasses = /obj/item/clothing/glasses/night
	box = /obj/item/storage/box/centcom

/datum/outfit/centcom/ert/security/alert
	l_hand = null
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	suit_store = /obj/item/gun/ballistic/automatic/ar
	backpack_contents = list(
		/obj/item/storage/box/m223_ammo = 1,
		/obj/item/storage/medkit/tactical/premium/ert = 1,
		/obj/item/ammo_box/magazine/smartgun_drum = 2,
		/obj/item/melee/baton/security/loaded = 1,
	)
	belt = /obj/item/storage/belt/military/ert_max
	l_pocket = /obj/item/gun/energy/pulse/pistol/loyalpin
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	box = /obj/item/storage/box/centcom
	cybernetic_implants = list(
		/obj/item/organ/cyberimp/eyes/hud/security,
		/obj/item/organ/eyes/robotic/shield,
		/obj/item/organ/cyberimp/chest/nutriment/plus,
		/obj/item/organ/cyberimp/chest/reviver,
		/obj/item/organ/cyberimp/brain/anti_stun,
		/obj/item/organ/cyberimp/brain/anti_drop,
	)

/// ERT_SECU END ///

/// ERT_MEDI START ///

/datum/outfit/centcom/ert/medic
	l_hand = null
	suit_store = /obj/item/gun/energy/modular_laser_rifle/carbine
	backpack_contents = list(
		/obj/item/storage/medkit/advanced = 1,
		/obj/item/reagent_containers/hypospray/combat = 1,
		/obj/item/gun/medbeam = 1,
		/obj/item/melee/baton/security/loaded = 1,
	)
	belt = /obj/item/storage/belt/military/ert_min
	l_pocket = /obj/item/gun/energy/e_gun/mini
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	glasses = /obj/item/clothing/glasses/hud/health/night
	box = /obj/item/storage/box/centcom

/datum/outfit/centcom/ert/medic/alert
	l_hand = null
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	suit_store = /obj/item/gun/ballistic/automatic/ar
	backpack_contents = list(
		/obj/item/storage/box/m223_ammo = 1,
		/obj/item/storage/medkit/tactical/premium/ert = 1,
		/obj/item/gun/medbeam = 1,
		/obj/item/melee/baton/security/loaded = 1,
	)
	belt = /obj/item/storage/belt/military/ert_max
	l_pocket = /obj/item/gun/energy/pulse/pistol/loyalpin
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	box = /obj/item/storage/box/centcom
	cybernetic_implants = list(
		/obj/item/organ/cyberimp/eyes/hud/security,
		/obj/item/organ/eyes/robotic/shield,
		/obj/item/organ/cyberimp/chest/nutriment/plus,
		/obj/item/organ/cyberimp/chest/reviver,
		/obj/item/organ/cyberimp/brain/anti_stun,
		/obj/item/organ/cyberimp/brain/anti_drop,
	)

/// ERT_MEDI END ///

/// ERT_ENGI START ///

/datum/outfit/centcom/ert/engineer
	l_hand = null
	suit_store = /obj/item/gun/energy/modular_laser_rifle/carbine
	backpack_contents = list(
		/obj/item/storage/medkit/advanced = 1,
		/obj/item/construction/rcd/loaded/upgraded = 1,
		/obj/item/rcd_ammo/large = 2,
		/obj/item/pipe_dispenser = 1,
		/obj/item/melee/baton/security/loaded = 1,
	)
	belt = /obj/item/storage/belt/utility/full/powertools
	l_pocket = /obj/item/gun/energy/e_gun/mini
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	glasses = /obj/item/clothing/glasses/meson/night
	box = /obj/item/storage/box/centcom

/datum/outfit/centcom/ert/engineer/alert
	l_hand = null
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	suit_store = /obj/item/gun/ballistic/automatic/ar
	backpack_contents = list(
		/obj/item/storage/box/m223_ammo = 1,
		/obj/item/construction/rcd/combat = 1,
		/obj/item/rcd_ammo/large = 2,
		/obj/item/pipe_dispenser/bluespace = 1,
		/obj/item/storage/medkit/tactical/premium/ert = 1,
		/obj/item/melee/baton/security/loaded = 1,
	)
	belt = /obj/item/storage/belt/utility/full/powertools
	l_pocket = /obj/item/gun/energy/pulse/pistol/loyalpin
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	box = /obj/item/storage/box/centcom
	cybernetic_implants = list(
		/obj/item/organ/cyberimp/eyes/hud/security,
		/obj/item/organ/eyes/robotic/shield,
		/obj/item/organ/cyberimp/chest/nutriment/plus,
		/obj/item/organ/cyberimp/chest/reviver,
		/obj/item/organ/cyberimp/brain/anti_stun,
		/obj/item/organ/cyberimp/brain/anti_drop,
	)

/// ERT_ENGI END ///

/// DEATH_COMMANDO START ///

/datum/outfit/centcom/death_commando
	box = /obj/item/storage/box/centcom
	backpack_contents = list(
		/obj/item/gun/ballistic/revolver/mateba = 1,
		/obj/item/ammo_box/a357 = 2,
		/obj/item/grenade/clusterbuster/clf3 = 2,
		/obj/item/storage/medkit/tactical/premium/ert = 1,
		/obj/item/shield/energy/advanced = 1,
	)
	belt = /obj/item/storage/belt/grenade/full
	l_pocket = /obj/item/melee/energy/sword/ert
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	l_hand = null
	suit_store = /obj/item/gun/energy/pulse/loyalpin

	implants = list(/obj/item/implant/deathrattle, /obj/item/implant/explosive/macro)

	cybernetic_implants = list(
		/obj/item/organ/cyberimp/eyes/hud/security,
		/obj/item/organ/eyes/robotic/shield,
		/obj/item/organ/cyberimp/chest/nutriment/plus,
		/obj/item/organ/cyberimp/chest/reviver,
		/obj/item/organ/cyberimp/brain/anti_stun,
		/obj/item/organ/cyberimp/brain/anti_drop,
	)

/// DEATH_COMMANDO END ///

/// ASSET_PROTECTION START ///

/datum/outfit/centcom/asset_protection
	box = /obj/item/storage/box/centcom
	glasses = /obj/item/clothing/glasses/hud/toggle/thermal
	l_pocket = /obj/item/melee/baton/telescopic/contractor_baton/upgraded
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	belt = /obj/item/storage/belt/military/ert_max
	l_hand = null
	suit_store = /obj/item/gun/energy/pulse/carbine/loyalpin

	backpack_contents = list(
		/obj/item/storage/medkit/tactical/premium/ert = 1,
		/obj/item/melee/baton/security/loaded = 1,
	)

	implants = list(/obj/item/implant/deathrattle)

/// ASSET_PROTECTION END ///

/// INTEQ_SQUAD START ///

/datum/outfit/centcom/inteq
	name = "PMC InteQ: ERT"

	uniform = /obj/item/clothing/under/syndicate/inteq_honorable_vanguard
	head = /obj/item/clothing/head/HoS/inteq_vanguard
	mask = /obj/item/clothing/mask/balaclava/breath/inteq
	gloves = /obj/item/clothing/gloves/combat
	suit = /obj/item/clothing/suit/armor/inteq
	shoes = /obj/item/clothing/shoes/combat

	box = /obj/item/storage/box/centcom
	back = /obj/item/mod/control/pre_equipped/inteqe
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/inteq
	ears = /obj/item/radio/headset/inteq/bowman/command
	l_pocket = /obj/item/gun/energy/pulse/pistol/loyalpin
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	id = /obj/item/card/id/advanced/centcom/ert/inteq
	belt = /obj/item/storage/belt/military/ert_max

	cybernetic_implants = list(
		/obj/item/organ/cyberimp/eyes/hud/medical,
		/obj/item/organ/eyes/robotic/shield,
		/obj/item/organ/cyberimp/chest/nutriment/plus,
	)

	implants = list(/obj/item/implant/deathrattle)

/datum/outfit/centcom/inteq/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(10))
		suit_store = /obj/item/gun/ballistic/automatic/ar/ak12/pink
		backpack_contents = list(
			/obj/item/storage/box/ak12_ammo/pink = 2,
			/obj/item/storage/medkit/tactical/premium/ert = 1,
			/obj/item/melee/baton/security/loaded = 1,
		)
	else
		suit_store = /obj/item/gun/ballistic/automatic/ar/ak12
		backpack_contents = list(
			/obj/item/storage/box/ak12_ammo = 2,
			/obj/item/storage/medkit/tactical/premium/ert = 1,
			/obj/item/melee/baton/security/loaded = 1,
		)

/datum/outfit/centcom/inteq/officer/pre_equip(mob/living/carbon/human/H, visualsOnly, client/preference_source)
	. = ..()
	var/list/extra_backpack_items = list(
		/obj/item/choice_beacon/inteq_mech = 1
	)
	LAZYADD(backpack_contents, extra_backpack_items)

/datum/outfit/centcom/inteq/officer
	name = "PMC InteQ: ERT Leader"
	id = /obj/item/card/id/advanced/centcom/ert/inteq/leader
	head = /obj/item/clothing/head/HoS/inteq_honorable_vanguard
	suit = /obj/item/clothing/suit/armor/inteq/honorable_vanguard

/datum/outfit/centcom/inteq/officer/post_equip(mob/living/carbon/human/squaddie, visuals_only = FALSE)
	. = ..()
	var/obj/item/mod/control/mod = squaddie.back
	if(!istype(mod))
		return
	var/obj/item/clothing/helmet = mod.get_part_from_slot(ITEM_SLOT_HEAD)
	var/obj/item/clothing/head/HoS/inteq_honorable_vanguard/beret = new(helmet)
	var/datum/component/hat_stabilizer/component = helmet.GetComponent(/datum/component/hat_stabilizer)
	component.attach_hat(beret)
	squaddie.update_clothing(helmet.slot_flags)

/// INTEQ_SQUAD END ///
