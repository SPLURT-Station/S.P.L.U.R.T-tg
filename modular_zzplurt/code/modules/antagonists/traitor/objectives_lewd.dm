/*
	LEWD ANTAGONIST OBJECTIVES
	You gotta be a bit considerate when coming up with some of these
	People WILL complain


	Since the implementation of objectives is ancient and
	really fucking dumb a lot of shitcode had to be written to make this work
*/

/datum/objective/lewd
	name = "lewd"
	explanation_text = "Do something lewd."

	/// list of BLACKLISTED preferences to check
	/// list /datum/preference = list(acceptedvalue1, acceptedvalue2)
	var/list/pref_check

/datum/objective/lewd/is_valid_target(datum/mind/possible_target)
	if(pref_check)
		// Go through the preferences and see if any of our blacklisted values
		for(var/pref_type as anything in pref_check)
			var/list/value_list = pref_check[pref_type]
			for(var/value as anything in value_list)
				// FOUND SOMETHING WE DONT LIKE!!!!!!!!
				if(possible_target.current.client?.prefs.read_preference(pref_type) == value)
					return FALSE

	return ..()

/// Used by the OBSESSED antagonist
/// Also by traitor if you want
/datum/objective/lewd/climax_in_or_on
	name = "climax in or on"
	explanation_text = "Unload your fat load onto somebody."

	pref_check = list(
		/datum/preference/choiced/erp_status_nc = list("No","Check OOC Notes"),
		/datum/preference/choiced/erp_status = list("No"),
		)
	var/mob/living/target_mob

/datum/objective/lewd/climax_in_or_on/find_target(dupe_search_range, list/blacklist)
	. = ..()

	if(!isnull(.))
		set_target(.)

/datum/objective/lewd/climax_in_or_on/update_explanation_text()
	..()
	// yeah fucking bullshit
	if(target?.current)
		explanation_text = "Ejaculate in or onto [target.name], the [target.assigned_role.title] at least once."
	else
		explanation_text = "Free objective."

/datum/objective/lewd/climax_in_or_on/proc/set_owner(datum/mind)
	owner = mind

	RegisterSignal(owner.current, COMSIG_MOB_CUM_IN, PROC_REF(on_owner_cum))
	RegisterSignal(owner.current, COMSIG_MOB_CUM_ON, PROC_REF(on_owner_cum))

/datum/objective/lewd/climax_in_or_on/proc/set_target(datum/mind/nu_target)
	target = nu_target
	target_mob = target.current
	// HOLY shitcode.
	update_explanation_text()

/datum/objective/lewd/climax_in_or_on/proc/set_target_mob_test(mob/living/mobtrgt)
	// HOLY shitcode.
	target = mobtrgt.mind
	target_mob = mobtrgt
	update_explanation_text()

// reigstered to both because it doesnt matter if its cummed in or cummed on bro
/datum/objective/lewd/climax_in_or_on/proc/on_owner_cum(mob/living/climaxing, mob/living/partner)
	SIGNAL_HANDLER
	// we already won so lets leave
	if(completed)
		return

	// Not who we are looking for.
	if(partner != target_mob)
		return

	completed = TRUE

// yeah its the same. yeah to be done
/datum/objective/lewd/climax_in_or_on/check_completion()
	return completed


/datum/objective/lewd/organ
	name = "organ related"
	explanation_text = "something with organ"
	var/target_organ
	var/list/possible_organs = list(ORGAN_SLOT_VAGINA, ORGAN_SLOT_PENIS, ORGAN_SLOT_BREASTS, ORGAN_SLOT_ANUS, ORGAN_SLOT_TESTICLES)

/datum/objective/lewd/organ/is_valid_target(datum/mind/possible_target)
	// target IS valid so far now we get the uhh penis
	if(!..())
		return FALSE

	// check for possible organs
	var/list/possible = possible_organs.Copy()
	for(var/organ_key in possible)
		if(possible_target.current.get_organ_slot(organ_key))
			return TRUE

	return FALSE

/datum/objective/lewd/organ/find_target(dupe_search_range, list/blacklist)
	. = ..()

	if(!.)
		update_explanation_text()
		return

	// pick a possible organ
	var/list/possible = possible_organs.Copy()
	for(var/organ_key in possible)
		if(!target.current.get_organ_slot(organ_key))
			possible -= organ_key

	target_organ = pick(possible)
	update_explanation_text()

	return target

/datum/objective/lewd/organ/castrate
	name = "castrate"
	explanation_text = "Castrate your target."

/datum/objective/lewd/organ/castrate/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Steal [target.name], the [target.assigned_role.title]'s [target_organ]. Make sure the target doesn't have a [target_organ] until the end of the shift."
	else
		explanation_text = "Free objective."

/datum/objective/lewd/organ/castrate/check_completion()
	// Yes they don't have genital YOU WIN
	if(!target.current.get_organ_slot(target_organ))
		return TRUE

	return FALSE

/datum/objective/lewd/organ/change_size
	name = "inflate"
	explanation_text = "Make your target have huge genitalia."
	var/target_size

	possible_organs = list(ORGAN_SLOT_TESTICLES, ORGAN_SLOT_PENIS, ORGAN_SLOT_BREASTS)

/datum/objective/lewd/organ/change_size/update_explanation_text()
	..()
	if(target?.current)
		if(target_organ == ORGAN_SLOT_BREASTS)
			explanation_text = "Change [target.name], the [target.assigned_role.title]'s breast size to [GLOB.breast_size_translation["[target_size]"]]."
		else
			explanation_text = "Change [target.name], the [target.assigned_role.title]'s [target_organ] size to [target_size]."

		explanation_text += "The target MUST!!! Have the genitals at the end of the shift!"
	else
		explanation_text = "Free objective."

/datum/objective/lewd/organ/change_size/find_target(dupe_search_range, list/blacklist)
	. = ..()

	if(!.)
		update_explanation_text()
		return

	var/obj/item/organ/genital/genital = target.current.get_organ_slot(target_organ)
	var/max_size = 0
	var/min_size = 0

	// why is max organ size not stored in the organ????
	switch(target_organ)
		if(ORGAN_SLOT_TESTICLES)
			max_size = TESTICLES_MAX_SIZE
			min_size = TESTICLES_MIN_SIZE
		if(ORGAN_SLOT_PENIS)
			max_size = PENIS_MAX_LENGTH
			min_size = PENIS_MIN_LENGTH
		if(ORGAN_SLOT_BREASTS)
			max_size = GLOB.breast_size_to_number[BREAST_SIZE_T]
			min_size = GLOB.breast_size_to_number[BREAST_SIZE_FLATCHESTED]

	target_size = rand(min_size, max_size)

	if(target_size == genital.genital_size)
		if(genital.genital_size == max_size)
			target_size = min_size
		else if(genital.genital_size == min_size)
			target_size = max_size
		else
			// ok we are somewhere in the middle just
			// go up or down one
			if(rand(0,1) == 0)
				target_size += 1
			else
				target_size -= 1

	update_explanation_text()

/datum/objective/lewd/organ/change_size/check_completion()
	// Yes they don't have genital YOU WIN
	var/obj/item/organ/genital/genital = target.current.get_organ_slot(target_organ)
	if(genital)
		if(genital == target_size)
			return TRUE
		return FALSE
	// NO GENITAL means you failed dumbass
	return FALSE

/datum/objective/lewd/sex_change
	name = "sex change"
	explanation_text = "Change the sex of your target."
	// the organs we would like to have
	var/list/target_organs
	// the organs we DONT want
	var/list/blacklisted_organs

/datum/objective/lewd/sex_change/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Give [target.name], the [target.assigned_role.title] a sex change operation."
	else
		explanation_text = "Free objective."

/datum/objective/lewd/sex_change/is_valid_target(datum/mind/possible_target)
	if(!..())
		return FALSE

	if(!iscarbon(possible_target.current))
		return FALSE
	var/mob/living/carbon/mob = possible_target.current
	switch(mob.gender)
		if(MALE)
			if(!mob.get_organ_slot(ORGAN_SLOT_VAGINA))
				return FALSE

			target_organs = list(ORGAN_SLOT_VAGINA, ORGAN_SLOT_BREASTS)
			blacklisted_organs = list(ORGAN_SLOT_PENIS)
		if(FEMALE)
			if(!mob.get_organ_slot(ORGAN_SLOT_PENIS))
				return FALSE

			target_organs = list(ORGAN_SLOT_PENIS)
			blacklisted_organs = list(ORGAN_SLOT_VAGINA, ORGAN_SLOT_BREASTS)
		if(PLURAL)
			blacklisted_organs = list(ORGAN_SLOT_VAGINA, ORGAN_SLOT_BREASTS, ORGAN_SLOT_PENIS, ORGAN_SLOT_TESTICLES)

			for(var/organ_key in blacklisted_organs)
				var/obj/item/organ/genital/genital = mob.get_organ_slot(organ_key)
				if(genital)
					return TRUE

	return TRUE

/datum/objective/lewd/sex_change/check_completion()
	// Yes they don't have genital YOU WIN

	for(var/organ_tag in blacklisted_organs)
		if(target.current.get_organ_slot(organ_tag))
			return FALSE

	var/wanted_organs = length(target_organs)
	for(var/organ_tag in target_organs)
		if(target.current.get_organ_slot(organ_tag))
			wanted_organs--

	// yeah we got all our organs WE WIN
	if(!wanted_organs)
		return TRUE
	return FALSE

/datum/objective/lewd/steal_cum
	name = "steal bodily fluid"
	explanation_text = "Bring a sample of a bodily fluid from a specific target."

	pref_check = list(
		/datum/preference/choiced/erp_status = list("No")
		)

	var/datum/reagent/target_internal_fluid_datum
	var/datum/dna/target_DNA

/datum/objective/lewd/steal_cum/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Steal a sample of [target.name], the [target.assigned_role.title]'s a [target_internal_fluid_datum::name]."
	else
		explanation_text = "Free objective."

/datum/objective/lewd/steal_cum/is_valid_target(datum/mind/possible_target)
	if(!..())
		return FALSE

	if(!iscarbon(possible_target.current))
		return FALSE
	var/mob/living/carbon/target_mob = possible_target.current

	for(var/obj/item/organ/genital/genital in target_mob.organs)
		if(genital.internal_fluid_datum)
			return TRUE

	return FALSE

/datum/objective/lewd/steal_cum/find_target(dupe_search_range, list/blacklist)
	. = ..()

	if(!.)
		update_explanation_text()
		return

	if(!iscarbon(target.current))
		return FALSE
	var/mob/living/carbon/target_mob = target.current

	var/list/possible_organs = list()
	for(var/obj/item/organ/genital/genital in target_mob.organs)
		if(genital.internal_fluid_datum)
			possible_organs += genital

	var/obj/item/organ/genital/target_genital = pick(possible_organs)
	target_internal_fluid_datum = target_genital.internal_fluid_datum
	target_DNA = target_mob.dna

/datum/objective/lewd/steal_cum/check_completion()
	. = ..()
	if(!isliving(owner.current))
		return FALSE

	var/list/all_items = owner.current.get_all_contents()
	for(var/obj/item/item in all_items)
		if(!istype(item, /obj/item/reagent_containers))
			continue

		var/obj/item/reagent_containers/container = item
		var/datum/reagent/stored_reagent = container.reagents.has_reagent(target_internal_fluid_datum)
		if(stored_reagent && stored_reagent.data["DNA"] == target_DNA)
			return TRUE

	return FALSE

/datum/objective/lewd/feed_cum
	name = "feed cum to somebody"
	explanation_text = "Bring a sample of a bodily fluid from a specific target."

	pref_check = list(
		/datum/preference/choiced/erp_status_nc = list("No")
		)

	// what datum we want
	var/datum/reagent/target_reagent_datum

/datum/objective/lewd/feed_cum/update_explanation_text()
	..()
	if(target?.current)
		explanation_text = "Feed [target.name], the [target.assigned_role.title] [target_reagent_datum::name]."
	else
		explanation_text = "Free objective."

/datum/objective/lewd/feed_cum/find_target(dupe_search_range, list/blacklist)
	. = ..()

	if(!.)
		update_explanation_text()
		return

	var/list/possible_reagents = list(
		/datum/reagent/consumable/cum,
		/datum/reagent/consumable/femcum
	)

	target_reagent_datum = pick(possible_reagents)

	RegisterSignal(target, COMSIG_MOB_REAGENT_TICK, PROC_REF(on_target_metabolize))

/datum/objective/lewd/feed_cum/proc/on_target_metabolize(mob/living/carbon/source, datum/reagent/chem, seconds_per_tick, times_fired)
	if(source.reagents.has_reagent(target_reagent_datum))
		completed = TRUE

/datum/objective/lewd/make_climax
	name = "climax in or on"
	explanation_text = "Unload your fat load onto somebody."

	pref_check = list(
		/datum/preference/choiced/erp_status = list("No"),
		)
	var/mob/living/target_mob
	var/climaxed_amount = 0
	var/wanted_amount = 5

/datum/objective/lewd/make_climax/find_target(dupe_search_range, list/blacklist)
	. = ..()

	if(!.)
		return

	target_mob = target.current
	//RegisterSignal(target_mob, COMSIG_MOB_POST_CLIMAX, PROC_REF(on_climax))

	wanted_amount = rand(3,10) // randomness is awesome

/datum/objective/lewd/make_climax/update_explanation_text()
	..()
	// yeah fucking bullshit
	if(target?.current)
		explanation_text = "Make [target.name], the [target.assigned_role.title] climax [wanted_amount] of times."
	else
		explanation_text = "Free objective."

/datum/objective/lewd/make_climax/proc/on_climax(mob/living/carbon/climaxing, mob/living/partner, interaction_position, manual)
	// YOU have to be the one making them climax
	if(partner != owner.current)
		return

	climaxed_amount++

/datum/objective/lewd/make_climax/check_completion()
	return climaxed_amount >= wanted_amount
