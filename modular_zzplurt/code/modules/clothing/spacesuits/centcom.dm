/obj/item/clothing/head/helmet/space/centcom
	name = "CentCom space helmet"
	desc = "A compact, uniquely designed space helmet, it has a golden-esc visor on the helmet, it's impressively strong, it's even weld-proof!"
	icon = 'modular_zzplurt/icons/obj/clothing/head.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/head.dmi'
	icon_state = "centcom_spacehelmet"
	inhand_icon_state = "syndicate-helm-green"
	armor_type = /datum/armor/space_centcom

/obj/item/clothing/suit/space/centcom
	name = "CentCom space suit"
	desc = "A heavy, uniquely designed space suit colored in CentCom emerald green, and heavy boots and gloves, it's comfortable, and rather flexible, unlike most space suits this isn't too heavy."
	icon = 'modular_zzplurt/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/suit.dmi'
	icon_state = "centcom_spacesuit"
	inhand_icon_state = "syndicate-green"
	w_class = WEIGHT_CLASS_NORMAL
	slowdown = 0
	armor_type = /datum/armor/space_centcom
	cell = /obj/item/stock_parts/power_store/cell/hyper
	var/helmet_type = /obj/item/clothing/head/helmet/space/centcom

/obj/item/clothing/suit/space/centcom/Initialize(mapload)
	. = ..()
	if(!allowed)
		allowed = GLOB.security_vest_allowed

/datum/armor/space_centcom
	melee = 30
	bullet = 40
	laser = 40
	energy = 50
	bomb = 30
	bio = 40
	fire = 80
	acid = 85

/obj/item/clothing/head/helmet/space/centcom/surplus
	name = "CentCom surplus space helmet"
	desc = "A compact, uniquely designed dusty space helmet, it has a golden-esc visor on the helmet with cracks and tape covering it, it's impressive how useful tape is, it's still weld-proof!"
	icon_state = "centcom_surplus_spacehelmet"
	armor_type = /datum/armor/space_surplus_centcom

/obj/item/clothing/suit/space/centcom/surplus
	name = "CentCom surplus space suit"
	desc = "A heavy, uniquely designed dusty space suit colored in.. A very aged CentCom emerald green that has seen better days, and heavy boots and gloves that MAY not be airtight, it's still comfortable at least, and rather flexible, it's covered in tape, suggesting past damages. Is this safe to use..?"
	icon_state = "centcom_surplus_spacesuit"
	slowdown = 1
	armor_type = /datum/armor/space_surplus_centcom
	cell = /obj/item/stock_parts/power_store/cell/high
	var/helmet_type = /obj/item/clothing/head/helmet/space/centcom/surplus

/datum/armor/space_surplus_centcom
	melee = 20
	bullet = 30
	laser = 30
	energy = 30
	bomb = 20
	bio = 30
	fire = 80
	acid = 85

/obj/item/clothing/head/helmet/space/centcom/combat
	name = "CentCom combat space helmet"
	desc = "A compact, uniquely designed space helmet with additional plating and padding, it has a golden-esc visor on the helmet with two CentCom emerald green stripes, it's even moreso-impressively strong, it's even weld-proof!"
	icon_state = "centcom_combat_spacehelmet"
	armor_type = /datum/armor/space_combat_centcom

/obj/item/clothing/suit/space/centcom/combat
	name = "CentCom combat space suit"
	desc = "A heavy, uniquely designed space suit colored in CentCom emerald green with an additional vest and thigh armor. Additional plating and padding adding more defense, and heavy boots and gloves, it's comfortable, and rather flexible, unlike the unarmored one, this one is kinda heavy."
	icon_state = "centcom_combat_spacesuit"
	slowdown = 1
	armor_type = /datum/armor/space_combat_centcom
	var/helmet_type = /obj/item/clothing/head/helmet/space/centcom/combat

/datum/armor/space_combat_centcom
	melee = 40
	bullet = 50
	laser = 60
	energy = 60
	bomb = 40
	bio = 40
	fire = 80
	acid = 85

/obj/item/clothing/head/helmet/space/centcom/command
	name = "CentCom command space helmet"
	desc = "A compact, uniquely designed space helmet with additional plating and padding, it has a golden-esc visor on the helmet with two CentCom emerald green stripes, the antennas are gold this time! It's even moreso-impressively strong, it's even weld-proof!"
	icon_state = "centcom_command_spacehelmet"
	armor_type = /datum/armor/space_combat_centcom

/obj/item/clothing/suit/space/centcom/command
	name = "CentCom command space suit"
	desc = "A heavy, uniquely designed space suit colored in CentCom emerald green with an additional vest and thigh armor with golden stripes and insignia on it. Additional plating and padding adding more defense, and heavy boots and gloves, it's comfortable, and rather flexible, unlike the unarmored one, this one is kinda heavy."
	icon_state = "centcom_command_spacesuit"
	armor_type = /datum/armor/space_combat_centcom
	cell = /obj/item/stock_parts/power_store/cell/bluespace
	var/helmet_type = /obj/item/clothing/head/helmet/space/centcom/combat
