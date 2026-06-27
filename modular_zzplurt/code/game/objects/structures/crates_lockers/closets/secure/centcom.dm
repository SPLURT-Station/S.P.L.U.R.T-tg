/obj/structure/closet/secure_closet/centcom_commander
	name = "CentCom commander's locker"
	desc = "A storage unit containing equipment for a CentCom Commander."
	req_access = list(ACCESS_CENT_CAPTAIN)
	icon = 'modular_skyrat/master_files/icons/obj/closet.dmi'
	icon_state = "cc"

/obj/structure/closet/secure_closet/centcom_commander/PopulateContents()
	..()
	new /obj/item/clothing/shoes/combat/swat(src)
	new /obj/item/clothing/gloves/tackler/combat/insulated(src)
	new /obj/item/clothing/gloves/captain/centcom(src)
	new /obj/item/clothing/head/hats/centcom_cap(src)
	new /obj/item/clothing/head/hats/centhat(src)
	new /obj/item/clothing/under/rank/centcom/commander(src)
	new /obj/item/clothing/under/rank/centcom/centcom_skirt(src)
	new /obj/item/clothing/suit/armor/vest/capcarapace/centcom(src)
	new /obj/item/clothing/suit/hooded/wintercoat/centcom(src)
	new /obj/item/clothing/suit/armor/centcom_formal(src)
	new /obj/item/radio/headset/headset_cent/commander(src)
	new /obj/item/storage/belt/sheath/sabre(src)
	new /obj/item/clothing/glasses/thermal/eyepatch(src)
	new /obj/item/door_remote/omni(src)
	new /obj/item/ammo_box/speedloader/c357(src)
	new /obj/item/ammo_box/speedloader/c357(src)
	new /obj/item/gun/ballistic/revolver/mateba(src)

/obj/structure/closet/secure_closet/centcom_officer
	name = "CentCom officer's locker"
	desc = "A storage unit containing equipment for a CentCom Officer."
	req_access = list(ACCESS_CENT_OFFICER)
	icon = 'modular_skyrat/master_files/icons/obj/closet.dmi'
	icon_state = "cc"

/obj/structure/closet/secure_closet/centcom_officer/PopulateContents()
	..()
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/gloves/tackler/combat(src)
	new /obj/item/clothing/head/helmet/space/beret(src)
	new /obj/item/clothing/under/rank/centcom/officer(src)
	new /obj/item/clothing/under/rank/centcom/officer_skirt(src)
	new /obj/item/clothing/suit/space/officer(src)
	new /obj/item/radio/headset/headset_cent/alt(src)
	new /obj/item/storage/belt/sheath/sabre(src)
	new /obj/item/clothing/glasses/thermal/eyepatch(src)
	new /obj/item/gun/energy/pulse/pistol/m1911(src)
