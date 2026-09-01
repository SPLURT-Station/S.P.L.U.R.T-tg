/obj/structure/closet/secure_closet/centcom
	name = "CentCom locker"
	desc = "It's a very sturdy card-locked storage unit."
	req_access = list(ACCESS_CENT_GENERAL)
	icon = 'modular_zzplurt/icons/obj/closet.dmi'
	icon_state = "cc"
	max_integrity = 500

/obj/structure/closet/secure_closet/centcom/commander
	name = "CentCom commander's locker"
	desc = "It's a very sturdy card-locked storage unit containing equipment for a CentCom Commander."
	req_access = list(ACCESS_CENT_CAPTAIN)

/obj/structure/closet/secure_closet/centcom/commander/PopulateContents()
	..()
	new /obj/item/clothing/shoes/combat/swat(src)
	new /obj/item/clothing/gloves/tackler/combat/insulated(src)
	new /obj/item/clothing/gloves/captain/centcom(src)
	new /obj/item/clothing/head/hats/centcom_cap(src)
	new /obj/item/clothing/head/hats/centhat(src)
	new /obj/item/clothing/under/rank/centcom/commander(src)
	new /obj/item/clothing/under/rank/centcom/commander/skirt(src)
	new /obj/item/clothing/suit/armor/vest/capcarapace/centcom(src)
	new /obj/item/clothing/suit/hooded/wintercoat/centcom(src)
	new /obj/item/clothing/suit/armor/centcom_commander(src)
	new /obj/item/radio/headset/headset_cent/commander(src)
	new /obj/item/storage/belt/sheath/sabre/centcom(src)
	new /obj/item/clothing/glasses/thermal/eyepatch(src)
	new /obj/item/door_remote/omni(src)
	new /obj/item/ammo_box/speedloader/c357(src)
	new /obj/item/ammo_box/speedloader/c357(src)
	new /obj/item/gun/ballistic/revolver/mateba(src)

/obj/structure/closet/secure_closet/centcom/officer
	name = "CentCom officer's locker"
	desc = "It's a very sturdy card-locked storage unit containing equipment for a CentCom Officer."
	req_access = list(ACCESS_CENT_OFFICER)
	icon_state = "cco"

/obj/structure/closet/secure_closet/centcom/officer/PopulateContents()
	..()
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/gloves/tackler/combat(src)
	new /obj/item/clothing/head/helmet/space/beret(src)
	new /obj/item/clothing/under/rank/centcom/officer(src)
	new /obj/item/clothing/under/rank/centcom/officer/skirt(src)
	new /obj/item/clothing/suit/space/officer(src)
	new /obj/item/radio/headset/headset_cent/alt(src)
	new /obj/item/storage/belt/sheath/sabre(src)
	new /obj/item/clothing/glasses/thermal/eyepatch(src)
	new /obj/item/storage/toolbox/guncase/skyrat/pistol/opfor/m1911(src)

/obj/structure/closet/secure_closet/centcom/ert
	name = "CentCom ERT security officer's locker"
	desc = "It's a very sturdy card-locked storage unit containing equipment for a Emergency Response Team Security Officer."
	req_access = list(ACCESS_CENT_SECURITY)
	icon_state = "ccsec"

/obj/structure/closet/secure_closet/centcom/ert/PopulateContents()
	..()
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/teargas(src)
	new /obj/item/storage/box/flashes(src)
	new /obj/item/storage/box/handcuffs(src)
	new /obj/item/shield/riot/tele(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/mod/control/pre_equipped/responsory/security(src)
	new /obj/item/storage/toolbox/guncase/skyrat/pistol/opfor/m1911(src)
	new /obj/item/storage/toolbox/ammobox/wt550m9(src)
	new /obj/item/gun/ballistic/automatic/wt550(src)
	new /obj/item/flashlight/seclite(src)

/obj/structure/closet/secure_closet/centcom/ert/medical
	name = "CentCom ERT medic's locker"
	desc = "It's a very sturdy card-locked storage unit containing equipment for a Emergency Response Team Medic."
	req_access = list(ACCESS_CENT_MEDICAL)
	icon_state = "ccmed"

/obj/structure/closet/secure_closet/centcom/ert/medical/PopulateContents()
	..()
	new /mob/living/basic/bot/medbot(src)
	new /obj/item/storage/medkit/o2(src)
	new /obj/item/storage/medkit/toxin(src)
	new /obj/item/storage/medkit/fire(src)
	new /obj/item/storage/medkit/brute(src)
	new /obj/item/storage/medkit/advanced(src)
	new /obj/item/storage/medkit/tactical_lite(src)
	new /obj/item/mod/control/pre_equipped/responsory/medic(src)
	new /obj/item/defibrillator/compact/combat/loaded/nanotrasen(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/storage/box/centcom_kit/advmeds(src)
	new /obj/item/storage/box/syringes(src)
	new /obj/item/gun/syringe/rapidsyringe(src)

/obj/structure/closet/secure_closet/centcom/ert/engineer
	name = "CentCom ERT engineer's locker"
	desc = "It's a very sturdy card-locked storage unit containing equipment for a Emergency Response Team Engineer."
	req_access = list(ACCESS_CENT_STORAGE)
	icon_state = "cceng"

/obj/structure/closet/secure_closet/centcom/ert/engineer/PopulateContents()
	..()
	new /obj/item/stack/sheet/plasteel(src, 50)
	new /obj/item/stack/sheet/iron(src, 50)
	new /obj/item/stack/sheet/glass(src, 50)
	new /obj/item/stack/sheet/mineral/sandbags(src, 30)
	new /obj/item/storage/box/smart_metal_foam(src)
	new /obj/item/storage/bag/construction(src)
	new /obj/item/clothing/shoes/magboots(src)
	new /obj/item/mod/control/pre_equipped/responsory/engineer(src)
	new /obj/item/storage/belt/utility/full/powertools(src)
	new /obj/item/construction/rcd/loaded/upgraded(src)
	new /obj/item/pipe_dispenser(src)
	for(var/i in 1 to 3)
		new /obj/item/rcd_ammo/large(src)

/obj/structure/closet/secure_closet/centcom/ert/commander
	name = "CentCom ERT commander's locker"
	desc = "It's a very sturdy card-locked storage unit containing equipment for a Emergency Response Team Commander."
	req_access = list(ACCESS_CENT_OFFICER)
	icon_state = "cccom"

/obj/structure/closet/secure_closet/centcom/ert/commander/PopulateContents()
	..()
	new /obj/item/storage/medkit/regular(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/handcuffs(src)
	new /obj/item/shield/riot/tele(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)
	new /obj/item/restraints/legcuffs/bola/energy(src)
	new /obj/item/mod/control/pre_equipped/responsory/commander(src)
	new /obj/item/storage/belt/security/full(src)
	if(prob(50))
		new /obj/item/ammo_box/magazine/m50(src)
		new /obj/item/ammo_box/magazine/m50(src)
		new /obj/item/gun/ballistic/automatic/pistol/deagle(src)
	else
		new /obj/item/ammo_box/speedloader/c357(src)
		new /obj/item/ammo_box/speedloader/c357(src)
		new /obj/item/gun/ballistic/revolver/mateba(src)

/obj/structure/closet/secure_closet/centcom/ert/commander/populate_contents_immediate()
	. = ..()

	// Traitor steal objective
	new /obj/item/aicard(src)

/obj/structure/closet/secure_closet/centcom/security
	name = "private security officer's locker"
	desc = "It's a card-locked storage unit containing equipment for a Nanotrasen Private Security Officer."
	req_access = list(ACCESS_CENT_SECURITY)
	icon_state = "ntsec"
	max_integrity = 350

/obj/structure/closet/secure_closet/centcom/security/PopulateContents()
	..()
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/under/rank/security/splurt/ntps(src)
	new /obj/item/clothing/head/soft/sec/ntps(src)
	new /obj/item/clothing/head/helmet/swat/nanotrasen/ntps(src)
	new /obj/item/radio/headset/headset_cent/alt/privsec(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/gloves/tackler/combat/black(src)
	new /obj/item/storage/backpack/satchel/sec(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/gun/energy/e_gun/advtaser(src)
	for(var/i in 1 to 2)
		new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/gun/ballistic/automatic/wt550(src)

/obj/structure/closet/secure_closet/centcom/security/captain
	name = "private security captain's locker"
	desc = "It's a card-locked storage unit containing equipment for a Nanotrasen Private Security Captain."
	req_access = list(ACCESS_CENT_CAPTAIN)
	icon_state = "ntscap"
	max_integrity = 350

/obj/structure/closet/secure_closet/centcom/security/captain/PopulateContents()
	..()
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/under/rank/security/splurt/ntps/captain(src)
	new /obj/item/clothing/head/beret/sec/ntps/captain(src)
	new /obj/item/radio/headset/headset_cent/alt/privsec/leader(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/gloves/tackler/combat/insulated(src)
	new /obj/item/storage/backpack/satchel/sec(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/storage/belt/security/webbing/privsec/full(src)
	new /obj/item/gun/energy/e_gun/advtaser(src)
	for(var/i in 1 to 2)
		new /obj/item/ammo_box/magazine/c68(src)
	new /obj/item/gun/ballistic/automatic/bulwark(src)
