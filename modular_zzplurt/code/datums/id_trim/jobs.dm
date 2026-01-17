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
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_COMMAND_BLUE
	department_state = "departmenthead"
	sechud_icon_state = SECHUD_NT_CONSULTANT
	extra_wildcard_access = list()
	minimal_access = list(
		ACCESS_CENT_GENERAL,
		ACCESS_BRIG_ENTRANCE,
		ACCESS_COMMAND,
		ACCESS_KEYCARD_AUTH,
		ACCESS_CHANGE_IDS,
		ACCESS_EVA,
		ACCESS_MAINT_TUNNELS,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_COURT,
		ACCESS_GATEWAY,
		ACCESS_LAWYER,
		ACCESS_SECURITY,
		ACCESS_RC_ANNOUNCE,
		ACCESS_TELEPORTER,
		ACCESS_VAULT,
		ACCESS_WEAPONS,
		ACCESS_SERVICE,
		)
	extra_access = list()
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		)
	job = /datum/job/nanotrasen_consultant
	big_pointer = TRUE
	pointer_color = COLOR_CENTCOM_BLUE
	honorifics = list("Representative", "Consultant", "Rep.")
	honorific_positions = HONORIFIC_POSITION_FIRST | HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_FIRST_FULL | HONORIFIC_POSITION_NONE

/datum/id_trim/job/nanotrasen_crew_trainer
	assignment = JOB_NT_TRN
	trim_state = "trim_centcom"
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_TEAL
	sechud_icon_state = SECHUD_NT_CREWTRAINER
	minimal_access = list(
		ACCESS_CENT_GENERAL,
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
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		)
	job = /datum/job/nanotrasen_crew_trainer
