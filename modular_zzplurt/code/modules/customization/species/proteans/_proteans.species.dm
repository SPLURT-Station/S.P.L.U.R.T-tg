/datum/species/protean/New()
	var/list/extra_inherent_traits = list(
		TRAIT_NOTHIRST
	)

	LAZYADD(inherent_traits, extra_inherent_traits)
	. = ..()

// Proteans unable to antag (bubber already has this restriction for bloodsucker and changling)
/datum/round_event_control/antagonist/New()
	. = ..()
	restricted_species += SPECIES_PROTEAN

// Proteans unable to do security
/datum/job/security_officer/New()
	. = ..()
	species_blacklist += SPECIES_PROTEAN

/datum/job/security_medic/New()
	. = ..()
	species_blacklist += SPECIES_PROTEAN

/datum/job/warden/New()
	. = ..()
	species_blacklist += SPECIES_PROTEAN

