/datum/loadout_item/suit/noonar_jacket
	name = "Suspicious jacket"
	item_path = /obj/item/clothing/suit/toggle/noonar
	ckeywhitelist = list("noonar")

/datum/loadout_item/suit/noonar_longjacket
	name = "Long Suspicious jacket"
	item_path = /obj/item/clothing/suit/toggle/noonarlong
	ckeywhitelist = list("noonar")

/datum/loadout_item/suit/armor/mark45_armor
	name = "Mk. 45 Black Legionnaire Armor"
	item_path = /obj/item/clothing/suit/armor/mark45_armor
	restricted_roles = list(ALL_JOBS_SEC)

/datum/loadout_item/suit/armor/mark45_armor/desert
	name = "Mk. 45 Desert Hunter Armor"
	item_path = /obj/item/clothing/suit/armor/mark45_armor/desert
	restricted_roles = list(ALL_JOBS_SEC)

/datum/loadout_item/suit/armor/mark45_armor/snow
	name = "Mk. 45 Snow Cover Аrmor"
	item_path = /obj/item/clothing/suit/armor/mark45_armor/snow
	restricted_roles = list(ALL_JOBS_SEC)

/datum/loadout_item/suit/armor/mark45_armor/anomalist
	name = "Mk. 45 Anomalist Аrmor"
	item_path = /obj/item/clothing/suit/armor/mark45_armor/anomalist
	restricted_roles = list(ALL_JOBS_SEC)

/datum/loadout_item/suit/armor/mark45_armor/combatengineer
	name = "Mk. 45 Combat engineer Аrmor"
	item_path = /obj/item/clothing/suit/armor/mark45_armor/combatengineer
	restricted_roles = list(ALL_JOBS_SEC)

/datum/loadout_item/suit/armor/mark45_armor/support
	name = "Mk. 45 Support Аrmor"
	item_path = /obj/item/clothing/suit/armor/mark45_armor/support
	restricted_roles = list(ALL_JOBS_SEC)

/datum/loadout_item/suit/armor/hos/mark45_armor_officer
	name = "Mk. 45 Officer Аrmor"
	item_path = /obj/item/clothing/suit/armor/hos/mark45_armor_officer
	restricted_roles = list(
		JOB_HEAD_OF_SECURITY,
		JOB_BLUESHIELD,
		JOB_WARDEN,
	)

/datum/loadout_item/suit/armor/brigdoc/mark45_armor_medic_l
	name = "Mk. 45 medic's combat coat"
	item_path = /obj/item/clothing/suit/armor/brigdoc/mark45_armor_medic_l
	restricted_roles = list(JOB_SECURITY_MEDIC)

/datum/loadout_item/suit/armor/brigdoc/mark45_armor_medic_h
	name = "Mk. 45 heavy combat medic Аrmor"
	item_path = /obj/item/clothing/suit/armor/brigdoc/mark45_armor_medic_h
	restricted_roles = list(JOB_SECURITY_MEDIC)

/datum/loadout_item/suit/toggle/armor/hos/hos_formal/ac
	name = "AC Armored Coat"
	item_path = /obj/item/clothing/suit/toggle/armor/hos/hos_formal/ac
	restricted_roles = list(
		JOB_HEAD_OF_SECURITY,
		JOB_BLUESHIELD,
		JOB_WARDEN,
	)
