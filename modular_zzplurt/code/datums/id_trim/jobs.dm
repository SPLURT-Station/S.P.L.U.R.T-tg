// Reverts tgs paramedic access
/datum/id_trim/job/paramedic
	minimal_access = list(
		ACCESS_BIT_DEN,
		ACCESS_CARGO,
		ACCESS_CONSTRUCTION,
		ACCESS_HYDROPONICS,
		ACCESS_MAINT_TUNNELS,
		ACCESS_MECH_MEDICAL,
		ACCESS_MEDICAL,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_MINING,
		ACCESS_MINING_STATION,
		ACCESS_MORGUE,
		ACCESS_SCIENCE,
		ACCESS_SERVICE,
		ACCESS_PARAMEDIC,
		)

	extra_access = list(
		ACCESS_SURGERY,
		ACCESS_VIROLOGY,
		ACCESS_PHARMACY,
		)

/datum/id_trim/job/nanotrasen_consultant
	assignment = JOB_NT_REP
	intern_alt_name = "Junior Nanotrasen Consultant"
	trim_state = "trim_centcom"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_TEAL
	department_state = "departmenthead"
	sechud_icon_state = SECHUD_NT_CONSULTANT
	extra_wildcard_access = list()
	minimal_access = list(
		ACCESS_CENT_CAPTAIN, // ACCESS_CENT_CAPTAIN is for ease of use, so we don't have to rely on Command AND Cent General access to get into their stuff. Only usable at CC anyway.
		ACCESS_CENT_OFFICER, // I mean, yeah. They're technically speaking higher than Blueshield.
		ACCESS_CENT_GENERAL,
		ACCESS_CENT_LIVING, // Even CC Interns get this.
		ACCESS_BRIG_ENTRANCE,
		ACCESS_COMMAND,
		ACCESS_KEYCARD_AUTH,
		ACCESS_CHANGE_IDS, // To give the NTCT's access to help who they need.
		ACCESS_EVA,
		ACCESS_MAINT_TUNNELS,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_COURT,
		ACCESS_GATEWAY,
		ACCESS_LAWYER,
		ACCESS_SECURITY,
		ACCESS_RC_ANNOUNCE,
		ACCESS_WEAPONS,
		ACCESS_SERVICE,
		)
	extra_access = list()
	template_access = list(
		ACCESS_CENT_GENERAL,
		)
	job = /datum/job/nanotrasen_consultant
	big_pointer = TRUE
	pointer_color = COLOR_CENTCOM_BLUE
	honorifics = list("Representative", "Consultant", "Rep.")
	honorific_positions = HONORIFIC_POSITION_FIRST | HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_FIRST_FULL | HONORIFIC_POSITION_NONE

/datum/id_trim/job/nanotrasen_crew_trainer
	assignment = JOB_NT_TRN
	trim_state = "trim_centcom"
	department_color = COLOR_TEAL
	subdepartment_color = COLOR_TEAL
	sechud_icon_state = SECHUD_NT_CREWTRAINER
	minimal_access = list(
		ACCESS_CENT_GENERAL,
		ACCESS_CENT_LIVING, // Even CC Interns get this.
		ACCESS_EVA,
		ACCESS_GATEWAY,
		ACCESS_MAINT_TUNNELS,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_WEAPONS,
		ACCESS_SERVICE, // Need extra service access since most new players are usually service/assistant.
		ACCESS_KITCHEN,
		ACCESS_HYDROPONICS,
		ACCESS_BAR,
		)
	extra_access = list()
	template_access = list(
		ACCESS_CENT_GENERAL,
		)
	job = /datum/job/nanotrasen_crew_trainer

/datum/id_trim/job/blueshield
	assignment = JOB_BLUESHIELD
	intern_alt_name = "Junior Blueshield"
	trim_icon = 'modular_skyrat/master_files/icons/obj/card.dmi'
	trim_state = "trim_blueshield"
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_COMMAND_BLUE
	sechud_icon_state = SECHUD_BLUESHIELD
	extra_wildcard_access = list()
	minimal_access = list(
		ACCESS_CAPTAIN,
		ACCESS_HOP,
		ACCESS_CENT_OFFICER, // Basic access to Blueshield's shit I guess, for now at least.
		ACCESS_CENT_GENERAL, // ACCESS_CENT_GENERAL is because Blueshield is still staff alongside NTC and NTCT, and this is the way to avoid Captains promoting assistants to NT External Staff.
		ACCESS_CENT_LIVING, // Even CC Interns get this.
		ACCESS_BRIG_ENTRANCE,
		ACCESS_COMMAND,
		ACCESS_ENGINEERING,
		ACCESS_MEDICAL,
		ACCESS_SCIENCE,
		ACCESS_CARGO,
		ACCESS_EVA,
		ACCESS_MAINT_TUNNELS,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_COURT,
		ACCESS_GATEWAY,
		ACCESS_SECURITY,
		ACCESS_WEAPONS,
		ACCESS_BRIG,
		)
	extra_access = list()
	template_access = list(
		ACCESS_CENT_GENERAL,
		)
	job = /datum/job/blueshield
	pointer_color = COLOR_CENTCOM_BLUE
	honorifics = list("Guardsman", "Gdsm.")
	honorific_positions = HONORIFIC_POSITION_FIRST | HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_FIRST_FULL | HONORIFIC_POSITION_NONE
