/obj/item/clothing/suit/toggle/jacket/corrections_officer
	body_parts_covered = CHEST|GROIN|ARMS
	armor_type = /datum/armor/armor_secjacket

/obj/item/clothing/suit/toggle/jacket/corrections_officer/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	// Reuse secjacket emissive without changing this item's normal co_coat icon state.
	var/old_icon_state = icon_state
	icon_state = "secjacket"
	. = ..(standing, isinhands, 'icons/mob/clothing/suits/armor.dmi')
	icon_state = old_icon_state

/obj/item/clothing/suit/armor/vest/secjacket/corrections_officer
	parent_type = /obj/item/clothing/suit/toggle/jacket/corrections_officer
