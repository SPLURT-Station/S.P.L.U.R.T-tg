/obj/item/clipboard/centcom
	name = "CentCom clipboard"
	desc = "A fashionable CentCom green clipboard, usually seen held by CentCom Officials, how regal!"
	icon = 'modular_zzplurt/icons/obj/service/bureaucracy.dmi'

/obj/item/clipboard/centcom/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/clipboard/centcom)

/datum/atom_skin/clipboard/centcom
	abstract_type = /datum/atom_skin/clipboard/centcom
	change_inhand_icon_state = TRUE

/datum/atom_skin/clipboard/centcom/default
	preview_name = "Default"
	new_icon_state = "clipboard"
