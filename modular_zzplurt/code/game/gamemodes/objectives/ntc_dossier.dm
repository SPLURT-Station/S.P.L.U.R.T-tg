/datum/objective_item/steal/ntc_documents
	name = "the Internal Affairs Department's dossier documents"
	valid_containers = list(/obj/item/folder)
	targetitem = /obj/item/documents/nanotrasen_consultant
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "These dossiers can be found in the Internal Affairs' \
		office, usually behind the Consultant's desk underneath the carpet. \
		Or found on the Nanotrasen Consultant themself, they usually also \
		are known for being issued a paper with the safe code on it. You \
		could attempt to get access to it to make this easier. They are \
		usually armed, and has armor built to defend them. Do what you \
		must. Unfortunately a photocopy does not suffice this time."

/obj/item/documents/nanotrasen_consultant/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/documents/nanotrasen_consultant)

/obj/item/folder/ntc_documents
	name = "folder - 'TOP SECRET'"
	desc = "A folder stamped \"Top Secret - Property of Nanotrasen Corporation Internal Affairs. Unauthorized distribution is punishable by death.\""
	icon = 'modular_zzplurt/icons/obj/service/bureaucracy.dmi'
	icon_state = "folder_ntgold"

/obj/item/folder/ntc_documents/Initialize(mapload)
	. = ..()
	new /obj/item/documents/nanotrasen_consultant(src)
	update_appearance()

/obj/item/documents/nanotrasen_consultant
	name = "NT Affairs employee dossier documents"
	desc = "\"Top Secret\" Nanotrasen Internal Affairs documents, stamped by a Nanotrasen stamp and signed with a Nanotrasen pen that is still freshly on the set of documents, filled with lists upon lists of names, dates and events, this seems to be documentation on specific NT employees and high command officers, this one has very specific details and high interest employees marked."
	icon = 'modular_zzplurt/icons/obj/service/bureaucracy.dmi'
	icon_state = "ntc_dossier"
