/datum/species/protean/New()
	var/list/extra_inherent_traits = list(
		TRAIT_NOTHIRST
	)

	LAZYADD(inherent_traits, extra_inherent_traits)
	. = ..()

// Proteans unable to antag (bubber already has this restriction for bloodsucker and changling)
/datum/round_event_control/antagonist
	restricted_species = list(SPECIES_PROTEAN)

/datum/job/security_officer
	species_blacklist = list(SPECIES_PROTEAN)

/datum/job/corrections_officer
	species_blacklist = list(SPECIES_PROTEAN)

/datum/job/security_medic
	species_blacklist = list(SPECIES_PROTEAN)

/datum/job/warden
	species_blacklist = list(SPECIES_PROTEAN)

/datum/job/head_of_security
	species_blacklist = list(SPECIES_PROTEAN)

/datum/job/detective
	species_blacklist = list(SPECIES_PROTEAN)

/datum/job/science_guard
	species_blacklist = list(SPECIES_PROTEAN)

/datum/job/orderly
	species_blacklist = list(SPECIES_PROTEAN)

/datum/job/engineering_guard
	species_blacklist = list(SPECIES_PROTEAN)

/datum/job/customs_agent
	species_blacklist = list(SPECIES_PROTEAN)

/datum/job/bouncer
	species_blacklist = list(SPECIES_PROTEAN)

/datum/job/captain
	species_blacklist = list(SPECIES_PROTEAN)

/datum/job/blueshield
	species_blacklist = list(SPECIES_PROTEAN)
