/obj/item/clothing/head/helmet/brodie
	name = "Brodie"
	desc = "The Brodie helmet is a steel combat helmet also known as the battle bowler. A World War 1 and 2 era British and commonwealth helmet."
	icon = 'modular_zzplurt/icons/obj/clothing/hats.dmi'
	icon_state = "brodie"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/hats.dmi'
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	flags_cover = null

/obj/item/clothing/head/helmet/brodie/medic
	name = "Medical Brodie"
	desc = "The Brodie helmet is a steel combat helmet also known as the battle bowler. A World War 1 and 2 era British and commonwealth helmet\n\
		This one has a cross indicating the wearer is a doctor."
	icon_state = "brodie_medic"

/obj/item/clothing/head/helmet/brodie/irish
	name = "Irish Brodie"
	desc = "The Brodie helmet is a steel combat helmet also known as the battle bowler. A World War 1 and 2 era British and commonwealth helmet\n\
		This one has a cross indicating the wearer is an Irishman."
	icon_state = "brodie_irish"

/obj/item/clothing/head/helmet/brodie/nettan
	name = "Netted Brodie"
	desc = "The Brodie helmet is a steel combat helmet also known as the battle bowler. A World War 1 and 2 era British and commonwealth helmet\n\
		This one has netting over it."
	icon_state = "brodie_nettan"

/obj/item/clothing/head/helmet/brodie/nettanf
	name = "Brodie with a net and leaves"
	desc = "The Brodie helmet is a steel combat helmet also known as the battle bowler. A World War 1 and 2 era British and commonwealth helmet\n\
		This one has netting and leaves over it."
	icon_state = "brodie_nettanf"

/obj/item/clothing/head/helmet/brodie/netgreen
	name = "Green netted Brodie"
	desc = "The Brodie helmet is a steel combat helmet also known as the battle bowler. A World War 1 and 2 era British and commonwealth helmet\n\
		This one has green netting over it."
	icon_state = "brodie_netgreen"

/obj/item/clothing/head/helmet/brodie/netgreenf
	name = "Green netted Brodie with leaves"
	desc = "The Brodie helmet is a steel combat helmet also known as the battle bowler. A World War 1 and 2 era British and commonwealth helmet\n\
		This one has green netting and leaves over it."
	icon_state = "brodie_netgreenf"

/obj/item/clothing/head/helmet/chaplain/bland/hospitaller
	icon = 'modular_skyrat/master_files/icons/obj/clothing/head/chaplain.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/head/chaplain.dmi'
	name = "crusader helmet"
	desc = "Helfen, Wehren, Heilen."
	icon_state = "knight_horned"

/obj/item/clothing/head/helmet/chaplain/bland/hospitaller/Initialize(mapload)
	. = ..()
	var/list/reskin_components = GetComponents(/datum/component/reskinable_item)
	for(var/datum/component/reskinable_item/reskin_component as anything in reskin_components)
		qdel(reskin_component)

/obj/item/clothing/head/helmet/chaplain/bland/hospitaller/no_armor
	armor_type = /datum/armor/none

/// Original
/obj/item/clothing/head/helmet/goner
	name = "trencher helmet"
	desc = "A No Man's Land-type helmet with purple paint applied."
	icon = 'modular_zzplurt/icons/obj/clothing/head.dmi'
	worn_icon = 'modular_zzplurt/icons/mob/clothing/head.dmi'
	icon_state = "goner_helmet"
	flags_inv = HIDEHAIR
	armor_type = /datum/armor/helmet_alt/goner

/datum/armor/helmet_alt/goner
	melee = 40
	bullet = 30
	laser = 30
	energy = 10
	bomb = 25
	bio = 5
	fire = 50
	acid = 50

/obj/item/clothing/head/helmet/goner/fake
	name = "trencher helmet replica"
	desc = "A plastic helmet with purple paint applied. Protects as best as cardboard box labeled 'Bomb Shelter'."
	armor_type = /datum/armor/none

/obj/item/clothing/head/helmet/goner/fake/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/goner_helmet)

/datum/atom_skin/goner_helmet
	abstract_type = /datum/atom_skin/goner_helmet

/datum/atom_skin/goner_helmet/default
	preview_name = "Default (Purple)"
	new_icon_state = "goner_helmet"

/datum/atom_skin/goner_helmet/red
	preview_name = "Red"
	new_icon_state = "goner_helmet_r"

/datum/atom_skin/goner_helmet/green
	preview_name = "Green"
	new_icon_state = "goner_helmet_g"

/datum/atom_skin/goner_helmet/blue
	preview_name = "Blue"
	new_icon_state = "goner_helmet_b"

/datum/atom_skin/goner_helmet/yellow
	preview_name = "Yellow"
	new_icon_state = "goner_helmet_y"

/// Original Colors
/obj/item/clothing/head/helmet/goner/red
	name = "red trencher helmet"
	desc = "A No Man's Land-type helmet with red paint applied."
	icon_state = "goner_helmet_r"

/obj/item/clothing/head/helmet/goner/green
	name = "green trencher helmet"
	desc = "A No Man's Land-type helmet with green paint applied."
	icon_state = "goner_helmet_g"

/obj/item/clothing/head/helmet/goner/blue
	name = "blue trencher helmet"
	desc = "A No Man's Land-type helmet with blue paint applied."
	icon_state = "goner_helmet_b"

/obj/item/clothing/head/helmet/goner/yellow
	name = "yellow trencher helmet"
	desc = "A No Man's Land-type helmet with yellow paint applied."
	icon_state = "goner_helmet_y"

/// Officer
/obj/item/clothing/head/helmet/goner/officer
	name = "trencher officer cap"
	desc = "An army officer cap with purple pin."
	icon_state = "goner_offcap"
	flags_inv = 0

/obj/item/clothing/head/helmet/goner/officer/fake
	name = "trencher officer cap replica"
	desc = "A cheap officer cap. Great for people with Napoleon complex."
	armor_type = /datum/armor/none

/obj/item/clothing/head/helmet/goner/officer/fake/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/goner_officer_cap)

/datum/atom_skin/goner_officer_cap
	abstract_type = /datum/atom_skin/goner_officer_cap

/datum/atom_skin/goner_officer_cap/default
	preview_name = "Default (Purple)"
	new_icon_state = "goner_offcap"

/datum/atom_skin/goner_officer_cap/red
	preview_name = "Red"
	new_icon_state = "goner_offcap_r"

/datum/atom_skin/goner_officer_cap/green
	preview_name = "Green"
	new_icon_state = "goner_offcap_g"

/datum/atom_skin/goner_officer_cap/blue
	preview_name = "Blue"
	new_icon_state = "goner_offcap_b"

/datum/atom_skin/goner_officer_cap/yellow
	preview_name = "Yellow"
	new_icon_state = "goner_offcap_y"

/// Officer Colors
/obj/item/clothing/head/helmet/goner/officer/red
	name = "red trencher officer cap"
	desc = "An army officer cap with red pin."
	icon_state = "goner_offcap_r"

/obj/item/clothing/head/helmet/goner/officer/green
	name = "green trencher officer cap"
	desc = "An army officer cap with green pin."
	icon_state = "goner_offcap_g"

/obj/item/clothing/head/helmet/goner/officer/blue
	name = "blue trencher officer cap"
	desc = "An army officer cap with blue pin."
	icon_state = "goner_offcap_b"

/obj/item/clothing/head/helmet/goner/officer/yellow
	name = "yellow trencher officer cap"
	desc = "An army officer cap with yellow pin."
	icon_state = "goner_offcap_y"
