/obj/item/folder/centcom
	desc = "A emerald green folder."
	icon = 'modular_zzplurt/icons/obj/service/bureaucracy.dmi'
	icon_state = "folder_green"
	bg_color = "#1C8329"

/obj/item/folder/centcom/logo
	desc = "A emerald green folder with a golden Nanotrasen logo on the front."
	icon_state = "folder_centcom"

/obj/item/folder/centcom/gold
	name = "folder - 'TOP SECRET'"
	desc = "A emerald green folder stamped \"Top Secret - Property of Nanotrasen's Central Command Division.\""
	icon_state = "folder_centcomgold"

/obj/item/folder/centcom/gold/Initialize(mapload)
	. = ..()
	new /obj/item/documents/nanotrasen(src)
	update_appearance()

/obj/item/folder/centcom/supply
	desc = "A emerald green folder stamped \"Central Command's Supply Division\""
	icon_state = "folder_centcomcarg"

/obj/item/folder/centcom/medical
	desc = "A emerald green folder stamped \"Central Command's Medical Division\""
	icon_state = "folder_centcommed"

/obj/item/folder/centcom/engineering
	desc = "A emerald green folder stamped \"Central Command's Engineering Division\""
	icon_state = "folder_centcomeng"

/obj/item/folder/centcom/security
	desc = "A emerald green folder stamped \"Central Command's Security Division\""
	icon_state = "folder_centcomsec"

/obj/item/folder/centcom/command
	desc = "A emerald green folder stamped \"Central Command's Administration\""
	icon_state = "folder_centcomcom"
