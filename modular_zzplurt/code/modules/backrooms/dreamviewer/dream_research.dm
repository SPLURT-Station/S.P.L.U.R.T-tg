/datum/design/dreamviewer_prototype
	name = "Dreamviewer ptototype frame"
	desc = "The Dreamviewer prototype; to ensure the device functions properly, you must insert a Raw Dreamcrystal into it."
	id = "dv_frame"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 5,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 4,
	)
	build_path = /obj/item/clothing/head/dreamviewer/prototype
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE


/datum/design/dreamviewer
	name = "Somnium Dreamviewer"
	desc = "A fully functional version of Somnium Dreamviewer."
	id = "dv_full"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 5,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/clothing/head/dreamviewer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE


/datum/design/dreamreaper
	name = "Somnium dream reaper"
	desc = "A device that extracts dream crystals from a person is connected to the Dreamgate network."
	id = "dreamreaper"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 8,
		/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 4,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 1,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT * 1,
	)
	build_path = /obj/item/dream_reaper
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE


/datum/experiment/scanning/dreamcrystal_raw
	name = "Scanning raw dreamcrystal example"
	description = "Scan raw dreamcrystals"
	exp_tag = "Dreamcrystal Scanning"
	allowed_experimentors = list(/obj/item/experi_scanner, /obj/item/scanner_wand)
	required_atoms = list(/obj/item/stack/dreamcrystal = 1)

/datum/experiment/scanning/dreamcrystal_raw/serialize_progress_stage(atom/target, list/seen_instances)
	return EXPERIMENT_PROG_INT("Scan [required_atoms[target]] samples.", \
		seen_instances.len, required_atoms[target])


/datum/experiment/scanning/dreamcrystals
	name = "Scanning refined dreamcrystal example"
	description = "Scan refined dreamcrystals."
	exp_tag = "Dreamcrystal Scanning"
	allowed_experimentors = list(/obj/item/experi_scanner, /obj/item/scanner_wand)
	required_atoms = list(/obj/item/stack/dreamcrystal_refined = 10)

/datum/experiment/scanning/dreamcrystals/serialize_progress_stage(atom/target, list/seen_instances)
	return EXPERIMENT_PROG_INT("Scan [required_atoms[target]] samples.", \
		seen_instances.len, required_atoms[target])

/datum/experiment/scanning/dreamcrystals/second
	name = "Scanning refined dreamcrystal example II"
	required_atoms = list(/obj/item/stack/dreamcrystal_refined = 25)

/datum/experiment/scanning/dreamcrystals/third
	name = "Scanning refined dreamcrystal example III"
	required_atoms = list(/obj/item/stack/dreamcrystal_refined = 40)


/datum/techweb_node/dreamgate_basic
	id = "technode_dreamview_initial"
	display_name = "Dreamgate overview"
	description = "Information about the existence of the DreamGate network and how to use it."
	prereq_ids = list()
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 2)
	required_experiments = list()
	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY)

	experiments_to_unlock = list(/datum/experiment/scanning/dreamcrystal_raw)


/datum/techweb_node/dreamgate_visit
	id = "technode_dreamview_visit"
	display_name = "Dreamgate research"
	description = "Explore technologies for penetrating the DreamGate network."
	prereq_ids = list("technode_dreamview_initial")
	design_ids = list("dreamreaper", "dv_frame")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 5)
	required_experiments = list(/datum/experiment/scanning/dreamcrystal_raw)
	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY)

	experiments_to_unlock = list(/datum/experiment/scanning/dreamcrystals)


/datum/techweb_node/applied_dreamgate_research
	id = "technode_dreamview_applied"
	display_name = "Applied Dreamgate research"
	description = "Explore advanced technologies to gain a detailed understanding of the DreamGate."
	prereq_ids = list("technode_dreamview_visit")
	design_ids = list("dv_full")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS * 10)
	required_experiments = list(/datum/experiment/scanning/dreamcrystals)

	announce_channels = list(RADIO_CHANNEL_MEDICAL, RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SECURITY)


/obj/item/disk/tech_disk/basic_dreamgate
	name = "Dreamgate research disk"

/obj/item/disk/tech_disk/basic_dreamgate/Initialize(mapload)
	stored_research = locate(/datum/techweb/dreamgate) in SSresearch.techwebs
	if(!stored_research)
		stored_research = new /datum/techweb/dreamgate()
	. = ..()


/datum/techweb/dreamgate
	id = "DREAMGATE"
	organization = "Somnium dream research"

/datum/techweb/dreamgate/New()
	. = ..()
	var/datum/techweb_node/dreamgate_basic/TN = locate(/datum/techweb_node/dreamgate_basic) in SSresearch.techweb_nodes
	research_node(TN, TRUE, TRUE, FALSE)

