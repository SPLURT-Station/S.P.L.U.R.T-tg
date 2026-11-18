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

	var/list/silicon_dept = list()
	for(var/datum/record/silicon/target as anything in GLOB.manifest.silicon)
		silicon_dept[++silicon_dept.len] = list(
			"name" = target.name,
			"rank" = target.rank,
			"trim" = target.trim,
		)
	if(length(silicon_dept))
		manifest_out["Silicon"] = silicon_dept

	var/list/lavaland_dept = list()
	for(var/datum/record/ashwalker/target as anything in GLOB.manifest.ashwalker)
		lavaland_dept[++lavaland_dept.len] = list(
			"name" = target.name,
			"rank" = target.rank,
			"trim" = target.trim,
		)
	if(length(lavaland_dept))
		manifest_out["Lavaland"] = lavaland_dept

	return manifest_out

/datum/manifest/inject(mob/living/user, atom/appearance_proxy, client/person_client)
	set waitfor = FALSE

	var/person_gender = "Other"
	if(user.gender == "male")
		person_gender = "Male"
	if(user.gender == "female")
		person_gender = "Female"

	if(issilicon(user) || isAI(user))
		var/mob/living/silicon/person = user

		// Attempt to get assignment from ID, otherwise default to mind.
		var/mutable_appearance/character_appearance = new(appearance_proxy?.appearance || user.appearance)
		var/obj/item/card/id/id_card = user.get_idcard(hand_first = FALSE)
		var/assignment = id_card?.get_trim_assignment() || user.mind?.assigned_role.title
		var/chosen_assignment = id_card?.get_job_title() || assignment

		new /datum/record/silicon(
			character_appearance = character_appearance,
			gender = person_gender,
			initial_rank = assignment,
			name = person.real_name,
			rank = chosen_assignment, // SKYRAT EDIT - Alt job titles - ORIGINAL: rank = assignment,
			trim = assignment)

	else if(isashwalker(user))
		var/mob/living/carbon/human/person = user
		var/mutable_appearance/character_appearance = new(appearance_proxy?.appearance || user.appearance)

		new /datum/record/ashwalker(
			age = person.age,
			chrono_age = person.chrono_age, // SKYRAT EDIT ADDITION - Chronological age
			character_appearance = character_appearance,
			gender = person_gender,
			name = person.real_name,
			species = "Ashwalker",
			rank = "Ashwalker",
			trim = "Ashwalker")
	else
		..()

/datum/manifest/ui_data(mob/user)
	var/list/data = ..()
	data["positions"]["Lavaland"] = list("exceptions" = list("Ashwalker"), "open" = -1, "color" = "#d7722a")
	return data

/obj/effect/mob_spawn/ghost_role/human/ash_walker/create_from_ghost(mob/dead/observer/user, apply_prefs, subtract_uses)
	var/mob/created = ..()
	GLOB.manifest.inject(created, null, created.client)
	return created
