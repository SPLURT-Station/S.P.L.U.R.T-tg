/// New Trims for CentCom Personnel, to fix accesses and make new jobs.
/datum/id_trim/centcom
	access = list(ACCESS_CENT_GENERAL)
	assignment = JOB_CENTCOM
	trim_state = "trim_centcom"
	sechud_icon_state = SECHUD_CENTCOM
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_CENTCOM_BLUE
	threat_modifier = -10 // Centcom are legally allowed to do whatever they want
	big_pointer = TRUE
	pointer_color = COLOR_CENTCOM_BLUE

/// Trim for Centcom VIPs
/datum/id_trim/centcom/vip
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING)
	assignment = JOB_CENTCOM_VIP

/// Trim for Centcom Thunderdome Overseers.
/datum/id_trim/centcom/thunderdome_overseer
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_THUNDER, ACCESS_WEAPONS)
	assignment = JOB_CENTCOM_THUNDERDOME_OVERSEER

/// Trim for Centcom Interns.
/datum/id_trim/centcom/intern
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_WEAPONS)
	assignment = "CentCom Intern"
	big_pointer = FALSE
	honorifics = list("Intern")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/// Trim for Centcom Head Interns. Different assignment, common station access added on.
/datum/id_trim/centcom/intern/head
	assignment = "CentCom Head Intern"
	big_pointer = TRUE
	honorifics = list("Head Intern")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/intern/head/New()
	. = ..()

	access |= SSid_access.get_flag_access_list(ACCESS_FLAG_COMMON)

/// Trim for Centcom Officials.
/datum/id_trim/centcom/official
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_OFFICER, ACCESS_WEAPONS)
	assignment = JOB_CENTCOM_OFFICIAL

// If Head Interns get this, at least let Officials get it too, since they're quite literally higher in rank.
/datum/id_trim/centcom/official/New()
	. = ..()

	access |= SSid_access.get_flag_access_list(ACCESS_FLAG_COMMON)

/// Trim for Bounty Hunters hired by centcom.
/datum/id_trim/centcom/bounty_hunter
	access = list(ACCESS_CENT_GENERAL)
	assignment = "Bounty Hunter"
	big_pointer = FALSE

/// Trim for Centcom Bartenders.
/datum/id_trim/centcom/bartender
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_BAR, ACCESS_BAR, ACCESS_SERVICE, ACCESS_WEAPONS)
	assignment = JOB_CENTCOM_BARTENDER
	trim_state = "trim_bartender"
	subdepartment_color = COLOR_SERVICE_LIME
	big_pointer = FALSE

/// Trim for Centcom Medical Officers.
/datum/id_trim/centcom/medical_officer
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_MEDICAL, ACCESS_MEDICAL)
	assignment = JOB_CENTCOM_MEDICAL_DOCTOR
	trim_state = "trim_medicaldoctor"
	subdepartment_color = COLOR_MEDICAL_BLUE
	big_pointer = FALSE
	honorifics = list("Doctor", "Dr.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/technical_officer
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE, ACCESS_ENGINE_EQUIP, ACCESS_ENGINEERING, ACCESS_ATMOSPHERICS)
	assignment = "Technical Officer"
	trim_state = "trim_stationengineer"
	subdepartment_color = COLOR_ENGINEERING_ORANGE
	big_pointer = FALSE
	honorifics = list("Technician", "Tech.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/// Trim for Centcom Medical Officers.
/datum/id_trim/centcom/supply_officer
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_LOGISTICS, ACCESS_CARGO, ACCESS_SHIPPING)
	assignment = "Supply Officer"
	trim_state = "trim_cargotechnician"
	subdepartment_color = COLOR_CARGO_BROWN
	big_pointer = FALSE
	honorifics = list("Specialist", "Spec.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/// Trim for Centcom Research Officers.
/datum/id_trim/centcom/research_officer
	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_MEDICAL, ACCESS_CENT_STORAGE, ACCESS_RESEARCH, ACCESS_ORDNANCE, ACCESS_ROBOTICS)
	assignment = JOB_CENTCOM_RESEARCH_OFFICER
	trim_state = "trim_scientist"
	subdepartment_color = COLOR_SCIENCE_PINK
	big_pointer = FALSE
	honorifics = list("Doctor", "Dr.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/// Trim for Centcom Specops Officers. All Centcom and Station Access.
/datum/id_trim/centcom/specops_officer
	assignment = JOB_CENTCOM_SPECIAL_OFFICER
	honorifics = list("Officer", "Off.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/specops_officer/New()
	. = ..()

	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/// Trim for Centcom Commanders. All Centcom and Station Access.
/datum/id_trim/centcom/commander
	assignment = JOB_CENTCOM_COMMANDER
	honorifics = list("Commander", "Cmdr.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/commander/New()
	. = ..()

	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/// Trim for NSRA Inspectors. All Centcom and Station Access. No high centcom access.
/datum/id_trim/centcom/safetyinspector
	assignment = "CentCom Safety Inspector"
	trim_state = "trim_stationengineer"
	subdepartment_color = COLOR_GREEN
	sechud_icon_state = SECHUD_ENGINEERING_RESPONSE_OFFICER
	honorifics = list("Inspector")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/safetyinspector/New()
	. = ..()

	access = (SSid_access.get_region_access_list(list(REGION_CENTCOM)) - ACCESS_CENT_CAPTAIN) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)))

/// Trim for Deathsquad officers. All Centcom and Station Access. No high centcom access.
/datum/id_trim/centcom/deathsquad
	assignment = JOB_ERT_DEATHSQUAD
	trim_state = "trim_deathcommando"
	sechud_icon_state = SECHUD_DEATH_COMMANDO
	honorifics = list("Commando")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/deathsquad/New()
	. = ..()

	access = (SSid_access.get_region_access_list(list(REGION_CENTCOM)) - ACCESS_CENT_CAPTAIN) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)))

/// Trim for generic ERT interns. No universal ID card changing access.
/datum/id_trim/centcom/ert
	assignment = "Emergency Response Team Intern"
	honorifics = list("Intern")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/ert/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// Trim for ERT Commanders. All station and centcom access. No centcom officer's access
/datum/id_trim/centcom/ert/commander
	assignment = JOB_ERT_COMMANDER
	trim_state = "trim_ert_commander"
	sechud_icon_state = SECHUD_EMERGENCY_RESPONSE_TEAM_COMMANDER

/datum/id_trim/centcom/ert/commander/New()
	. = ..()

	access = (SSid_access.get_region_access_list(list(REGION_CENTCOM)) - ACCESS_CENT_OFFICER) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)))

/// Trim for generic ERT seccies. No universal ID card changing access.
/datum/id_trim/centcom/ert/security
	assignment = JOB_ERT_OFFICER
	trim_state = "trim_securityofficer"
	subdepartment_color = COLOR_SECURITY_RED
	sechud_icon_state = SECHUD_SECURITY_RESPONSE_OFFICER
	big_pointer = FALSE
	honorifics = list("Officer")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE

/datum/id_trim/centcom/ert/security/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// Trim for generic ERT engineers. No universal ID card changing access.
/datum/id_trim/centcom/ert/engineer
	assignment = JOB_ERT_ENGINEER
	trim_state = "trim_stationengineer"
	subdepartment_color = COLOR_ENGINEERING_ORANGE
	sechud_icon_state = SECHUD_ENGINEERING_RESPONSE_OFFICER
	big_pointer = FALSE

/datum/id_trim/centcom/ert/engineer/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// Trim for generic ERT medics. No universal ID card changing access.
/datum/id_trim/centcom/ert/medical
	assignment = JOB_ERT_MEDICAL_DOCTOR
	trim_state = "trim_medicaldoctor"
	subdepartment_color = COLOR_MEDICAL_BLUE
	sechud_icon_state = SECHUD_MEDICAL_RESPONSE_OFFICER
	big_pointer = FALSE
	honorifics = list("Doctor", "Dr.")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE


/datum/id_trim/centcom/ert/medical/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_LIVING) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// Trim for generic ERT chaplains. No universal ID card changing access.
/datum/id_trim/centcom/ert/chaplain
	assignment = JOB_ERT_CHAPLAIN
	trim_state = "trim_chaplain"
	subdepartment_color = COLOR_SERVICE_LIME
	sechud_icon_state = SECHUD_RELIGIOUS_RESPONSE_OFFICER
	big_pointer = FALSE
	honorifics = list("Chaplain")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE


/datum/id_trim/centcom/ert/chaplain/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// Trim for generic ERT janitors. No universal ID card changing access.
/datum/id_trim/centcom/ert/janitor
	assignment = JOB_ERT_JANITOR
	trim_state = "trim_ert_janitor"
	subdepartment_color = COLOR_SERVICE_LIME
	sechud_icon_state = SECHUD_JANITORIAL_RESPONSE_OFFICER
	big_pointer = FALSE
	honorifics = list("Custodian")
	honorific_positions = HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_NONE


/datum/id_trim/centcom/ert/janitor/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)

/// Trim for generic ERT clowns. No universal ID card changing access.
/datum/id_trim/centcom/ert/clown
	assignment = JOB_ERT_CLOWN
	trim_state = "trim_clown"
	subdepartment_color = COLOR_MAGENTA
	sechud_icon_state = SECHUD_ENTERTAINMENT_RESPONSE_OFFICER
	big_pointer = FALSE

/datum/id_trim/centcom/ert/clown/New()
	. = ..()

	access = list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_CHANGE_IDS)
