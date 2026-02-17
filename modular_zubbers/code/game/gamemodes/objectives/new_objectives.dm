/datum/objective_item/steal/ntc_documents
	name = "the Internal Affairs Department's secret documents"
	valid_containers = list(/obj/item/folder)
	targetitem = /obj/item/documents/nanotrasen_consultant
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "These documents can be found in the Internal Affairs' office, usually behind the NTC's desk underneath the floor. \
		A photocopy may also suffice."

/obj/item/documents/nanotrasen_consultant/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/documents/nanotrasen_consultant)
