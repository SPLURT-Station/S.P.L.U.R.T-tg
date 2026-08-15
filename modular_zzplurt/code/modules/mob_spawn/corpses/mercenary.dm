/obj/effect/mob_spawn/corpse/human/mercenary
	name = "Mercenary"
	outfit = /datum/outfit/mercenary

/datum/outfit/mercenary
	name = "Mercenary Corpse"

	uniform = /obj/item/clothing/under/rank/security/splurt/mercenary
	suit = /obj/item/clothing/suit/armor/vest/mercenary
	shoes = /obj/item/clothing/shoes/combat/mercenary
	gloves = /obj/item/clothing/gloves/combat/mercenary/fingerless
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/mercenary
	mask = /obj/item/clothing/mask/gas
	head = /obj/item/clothing/head/helmet/mercenary
	back = /obj/item/storage/backpack/satchel/mercenary
	ears = /obj/item/radio/headset
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/away/mercenary

/datum/id_trim/away/mercenary
	assignment = "Mercenary"
	trim_icon = 'modular_zzplurt/icons/obj/card.dmi'
	trim_state = "trim_mercenary"
	department_color = "#60603E"
	subdepartment_color = "#60603E"
	sechud_icon_state = SECHUD_MERCENARY
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_WEAPONS)
	big_pointer = FALSE
	honorifics = list("Merc.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE
	pointer_color = "#353518"
