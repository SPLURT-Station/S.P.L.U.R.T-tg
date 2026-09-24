/datum/manifest
	/// Silicons
	var/list/silicon = list()
	/// Ashwalkers
	var/list/ashwalker = list()

/datum/record/silicon

/datum/record/silicon/New(
	age = 18,
	chrono_age = 18,
	blood_type = "?",
	character_appearance,
	dna_string = "Unknown",
	fingerprint = "?????",
	gender = "Other",
	initial_rank = "Unassigned",
	name = "Unknown",
	rank = "Unassigned",
	species = "Human",
	trim = "Unassigned",
	voice = "?????",
)
	. = ..()
	GLOB.manifest.silicon += src

/datum/record/silicon/Destroy()
	GLOB.manifest.silicon -= src
	return ..()

/datum/record/ashwalker

/datum/record/ashwalker/New(
	age = 18,
	chrono_age = 18,
	blood_type = "?",
	character_appearance,
	dna_string = "Unknown",
	fingerprint = "?????",
	gender = "Other",
	initial_rank = "Unassigned",
	name = "Unknown",
	rank = "Unassigned",
	species = "Human",
	trim = "Unassigned",
	voice = "?????",
)
	. = ..()
	GLOB.manifest.ashwalker += src

/datum/record/ashwalker/Destroy()
	GLOB.manifest.ashwalker -= src
	return ..()

/datum/manifest/get_manifest()
	var/list/manifest_out = ..()

	manifest_out["Silicon"] = list()
	manifest_out["Lavaland"] = list()

	var/list/silicon_dept = manifest_out["Silicon"]
	for(var/datum/record/silicon/target as anything in GLOB.manifest.silicon)
		silicon_dept[++silicon_dept.len] = list(
			"name" = target.name,
			"rank" = target.rank,
			"trim" = target.trim,
		)

	var/list/lavaland_dept = manifest_out["Lavaland"]
	for(var/datum/record/ashwalker/target as anything in GLOB.manifest.ashwalker)
		lavaland_dept[++lavaland_dept.len] = list(
			"name" = target.name,
			"rank" = target.rank,
			"trim" = target.trim,
		)

	return manifest_out

/datum/manifest/inject(mob/living/user, atom/appearance_proxy, client/person_client)
	set waitfor = FALSE

	// Attempt to get assignment from ID, otherwise default to mind.
	var/obj/item/card/id/id_card = user.get_idcard(hand_first = FALSE)
	var/assignment = id_card?.get_trim_assignment() || user.mind?.assigned_role.title

	var/mutable_appearance/character_appearance = new(appearance_proxy?.appearance || user.appearance)
	var/person_gender = "Other"
	if(user.gender == "male")
		person_gender = "Male"
	if(user.gender == "female")
		person_gender = "Female"

	// SKYRAT EDIT ADDITION BEGIN - ALTERNATIVE_JOB_TITLES
	// The alt job title, if user picked one, or the default
	var/chosen_assignment = id_card?.get_job_title() || assignment //BUBBER EDIT: Intern Job Tags
	// SKYRAT EDIT ADDITION END - ALTERNATIVE_JOB_TITLES

	if(user.mind?.assigned_role.job_flags & JOB_CREW_MANIFEST)
		var/mob/living/carbon/human/person = user

		var/datum/dna/stored/record_dna = new()
		person.dna.copy_dna(record_dna)

		var/datum/record/locked/lockfile = new(
			age = person.age,
			chrono_age = person.chrono_age, // SKYRAT EDIT ADDITION - Chronological age
			blood_type = person.get_bloodtype()?.name || "UNKNOWN",
			character_appearance = character_appearance,
			dna_string = record_dna.unique_enzymes,
			fingerprint = md5(record_dna.unique_identity),
			gender = person.gender,
			initial_rank = assignment,
			name = person.real_name,
			rank = chosen_assignment, // SKYRAT EDIT - Alt job titles - ORIGINAL: rank = assignment,
			species = record_dna.species.name,
			trim = assignment,
			// Locked specifics
			locked_dna = record_dna,
			mind_ref = person.mind,
			// BUBBER EDIT ADDITION BEGIN - Records
			exploitable_information = person_client?.prefs.read_preference(/datum/preference/text/exploitable) || "",
			background_information = person_client?.prefs.read_preference(/datum/preference/text/background) || "",
			// BUBBER EDIT END
		)

		new /datum/record/crew(
			age = person.age,
			chrono_age = person.chrono_age, // SKYRAT EDIT ADDITION - Chronological age
			blood_type = person.get_bloodtype()?.name || "UNKNOWN",
			character_appearance = character_appearance,
			dna_string = record_dna.unique_enzymes,
			fingerprint = md5(record_dna.unique_identity),
			gender = person_gender,
			initial_rank = assignment,
			name = person.real_name,
			rank = chosen_assignment, // SKYRAT EDIT - Alt job titles - ORIGINAL: rank = assignment,
			species = record_dna.species.name,
			trim = assignment,
			// Crew specific
			lock_ref = REF(lockfile),
			major_disabilities = person.get_quirk_string(FALSE, CAT_QUIRK_MAJOR_DISABILITY, from_scan = TRUE),
			major_disabilities_desc = person.get_quirk_string(TRUE, CAT_QUIRK_MAJOR_DISABILITY),
			minor_disabilities = person.get_quirk_string(FALSE, CAT_QUIRK_MINOR_DISABILITY, from_scan = TRUE),
			minor_disabilities_desc = person.get_quirk_string(TRUE, CAT_QUIRK_MINOR_DISABILITY),
			quirk_notes = person.get_quirk_string(TRUE, CAT_QUIRK_NOTES),
			// SKYRAT EDIT START - RP Records
			past_general_records = person_client?.prefs.read_preference(/datum/preference/text/general) || "",
			past_medical_records = person_client?.prefs.read_preference(/datum/preference/text/medical) || "",
			past_security_records = person_client?.prefs.read_preference(/datum/preference/text/security) || "",
			// SKYRAT EDIT END
		)
	else if(issilicon(user) || isAI(user))
		var/mob/living/silicon/person = user
		new /datum/record/silicon(
			character_appearance = character_appearance,
			gender = person_gender,
			initial_rank = assignment,
			name = person.real_name,
			rank = chosen_assignment, // SKYRAT EDIT - Alt job titles - ORIGINAL: rank = assignment,
			trim = assignment)

	else if(isashwalker(user))
		var/mob/living/carbon/human/person = user
		new /datum/record/ashwalker(
			age = person.age,
			chrono_age = person.chrono_age, // SKYRAT EDIT ADDITION - Chronological age
			character_appearance = character_appearance,
			gender = person_gender,
			name = person.real_name,
			species = "Ashwalker",
			rank = "Ashwalker",
			trim = "Ashwalker")

/datum/manifest/ui_data(mob/user)
	var/list/data = ..()
	data["positions"]["Lavaland"] = list("exceptions" = list("Ashwalker"), "open" = -1, "color" = "#d7722a")
	return data

/obj/effect/mob_spawn/ghost_role/human/ash_walker/create_from_ghost(mob/dead/observer/user, apply_prefs, subtract_uses)
	var/mob/created = ..()
	GLOB.manifest.inject(created, null, created.client)
	return created
