/datum/objective_item/steal/ntc_documents
	name = "the Internal Affairs Department's information dossiers"
	valid_containers = list(/obj/item/folder)
	targetitem = /obj/item/documents/nanotrasen_consultant
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "These dossiers can be found in the Internal Affairs' \
		office, usually behind the Consultant's desk underneath the carpet. \
		Or found on the Nanotrasen Consultant themself. They are usually \
		as armored as a Captain so be wary and careful. Do what you must. \
		Unfortunately a photocopy does not suffice this time."

/obj/item/documents/nanotrasen_consultant/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/documents/nanotrasen_consultant)
