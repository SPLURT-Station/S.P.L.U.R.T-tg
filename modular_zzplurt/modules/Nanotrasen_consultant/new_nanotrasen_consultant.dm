/obj/item/storage/bag/garment/nanotrasen_consultant_real
	name = "nanotrasen consultant's garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the Nanotrasen Consultant."

/obj/item/storage/bag/garment/nanotrasen_consultant_real/PopulateContents()
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/glasses/sunglasses/gar/giga(src)
	new /obj/item/clothing/gloves/combat(src)
	new /obj/item/clothing/gloves/captain/centcom(src)
	new /obj/item/clothing/suit/hooded/wintercoat/centcom/nt_consultant(src)
	new /obj/item/clothing/under/rank/nanotrasen_consultant(src)
	new /obj/item/clothing/under/rank/nanotrasen_consultant/skirt(src)
	new /obj/item/clothing/under/rank/centcom/consultant(src)
	new /obj/item/clothing/under/rank/centcom/consultant/skirt(src)
	new /obj/item/clothing/under/rank/centcom/officer(src)
	new /obj/item/clothing/under/rank/centcom/officer_skirt(src)
	new /obj/item/clothing/under/rank/centcom/official(src)
	new /obj/item/clothing/under/rank/centcom/official/turtleneck(src)
	new /obj/item/clothing/head/nanotrasen_consultant(src)
	new /obj/item/clothing/head/nanotrasen_consultant/beret(src)
	new /obj/item/clothing/head/beret/centcom_formal/nt_consultant(src)
	new /obj/item/clothing/head/hats/centhat(src)
	new /obj/item/clothing/head/hats/consultant_cap(src)
	new /obj/item/clothing/suit/armor/centcom_formal/nt_consultant(src)
	new /obj/item/clothing/suit/armor/vest/officerfake(src)
	new /obj/item/clothing/under/rank/centcom/intern(src)
	new /obj/item/clothing/head/hats/intern(src)

//Splurt Edit Start// changed the locker icon as the NT Rep is not CC but NT like the name suggests.
/obj/structure/closet/secure_closet/nanotrasen_consultant
	name = "nanotrasen consultant's locker"
	req_access = list()
	req_one_access = list(ACCESS_CENT_GENERAL)
	icon_state = "nt"
	icon = 'modular_zzplurt/icons/obj/closet.dmi'
//Splurt Edit End

/obj/structure/closet/secure_closet/nanotrasen_consultant/PopulateContents()
	..()
	new /obj/item/storage/backpack/satchel/leather(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/pet_carrier(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/computer_disk/command/captain(src)
	new /obj/item/radio/headset/heads/nanotrasen_consultant/alt(src)
	new /obj/item/radio/headset/heads/nanotrasen_consultant(src)
	new /obj/item/storage/photo_album/personal(src)
	new /obj/item/bedsheet/centcom(src)
	new /obj/item/storage/bag/garment/nanotrasen_consultant(src)

/obj/item/pen/fountain/nanotrasen
	name = "nanotrasen fountain pen"
	desc = "It's an expensive blue fountain pen. The case may be plastic, but that gold is real!"
	icon = 'modular_zzplurt/icons/obj/service/bureaucracy.dmi'
	icon_state = "pen-fountain-nt"
	colour = "#11516e"
	custom_materials = list(/datum/material/gold = SMALL_MATERIAL_AMOUNT*7.5)
