/datum/job/assistant/stowaway
	allow_bureaucratic_error = FALSE

// Remove stowaway from occupations entirely, regardless of map or config
/datum/job/assistant/stowaway/map_check()
	return FALSE
