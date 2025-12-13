/datum/id_trim/syndicom/interdyne_research
	assignment = "Interdyne Operative"
	trim_state = "trim_unknown"
	department_color = COLOR_ASSEMBLY_BLACK
	subdepartment_color = COLOR_SYNDIE_RED

/datum/id_trim/syndicom/interdyne_research/engineer
	trim_icon = 'modular_skyrat/master_files/icons/obj/card.dmi'
	assignment = "Interdyne Technician"
	trim_state = "trim_ds2enginetech"
	sechud_icon_state = SECHUD_DS2_ENGINETECH
	access = list(ACCESS_SYNDICATE, ACCESS_ROBOTICS, ACCESS_MEDICAL, ACCESS_ENGINE_EQUIP)

/datum/id_trim/syndicom/interdyne_research/cargo
	trim_icon = 'modular_zzplurt/icons/obj/card.dmi'
	assignment = "Interdyne Deliveries Officer"
	trim_state = "trim_interdynecargo"
	sechud_icon_state = SECHUD_INTERDYNE_CARGO
	access = list(ACCESS_SYNDICATE, ACCESS_ROBOTICS, ACCESS_MEDICAL, ACCESS_CARGO)

/datum/id_trim/syndicom/interdyne_research/geneticist
	trim_icon = 'modular_zzplurt/icons/obj/card.dmi'
	assignment = "Interdyne Genetic Researcher"
	trim_state = "trim_interdynegeneticist"
	sechud_icon_state = SECHUD_INTERDYNE_GENETICIST
	access = list(ACCESS_SYNDICATE, ACCESS_ROBOTICS, ACCESS_MEDICAL, ACCESS_GENETICS)

/datum/id_trim/syndicom/interdyne_research/chemist
	trim_icon = 'modular_zzplurt/icons/obj/card.dmi'
	assignment = "Interdyne Chemist"
	trim_state = "trim_interdynechemist"
	sechud_icon_state = SECHUD_INTERDYNE_CHEMIST
	access = list(ACCESS_SYNDICATE, ACCESS_ROBOTICS, ACCESS_MEDICAL, ACCESS_PHARMACY)

/datum/id_trim/syndicom/interdyne_research/doctor
	trim_icon = 'modular_skyrat/master_files/icons/obj/card.dmi'
	assignment = "Interdyne Medical Officer"
	trim_state = "trim_ds2medicalofficer"
	sechud_icon_state = SECHUD_DS2_DOCTOR
	access = list(ACCESS_SYNDICATE, ACCESS_ROBOTICS, ACCESS_MEDICAL, ACCESS_SURGERY)

/datum/id_trim/syndicom/interdyne_research/medicaldirector
	trim_icon = 'modular_zzplurt/icons/obj/card.dmi'
	assignment = "Interdyne Medical Director"
	trim_state = "trim_interdynecmo"
	sechud_icon_state = SECHUD_INTERDYNE_CMO
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER, ACCESS_ROBOTICS, ACCESS_MEDICAL, ACCESS_SURGERY, ACCESS_GENETICS, ACCESS_PHARMACY, ACCESS_CARGO, ACCESS_ENGINE_EQUIP)
	big_pointer = TRUE
	pointer_color = COLOR_SYNDIE_RED_HEAD
