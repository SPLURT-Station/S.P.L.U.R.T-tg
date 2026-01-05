#define TRAIT_PSYONIC_USER "psyonicuser"
#define TRAIT_NO_PSYONICS "no_psyonics"
#define TRAIT_PRO_PSYONICS "pro_psyonics"

#define LATENT_PSYONIC 0
#define OPERANT_PSYONIC 1
#define MASTER_PSYONIC 2
#define GRANDMASTER_PSYONIC 3
#define PARAMOUNT_PSYONIC 4
#define GREATEST_PSYONIC 5

GLOBAL_LIST_INIT(psyonic_schools, list(
	"Redaction",
	"Coercion",
	"Psychokinesis",
	"Energistics",
))

/datum/quirk/psyonic // Shoutout to Mikrovolnovka19, aka caesar_name, for being the beautiful person they are <3
	name = "Psyonic Abilities"
	desc = "Either you were born like this or gained powers through implants/training or other events - you are a psycaster. \
			Your mind can access the metaphysical world of the outer realms. One day, voices from within had pierced your skull \
			like a tide wave turns a sailboat over in open sea, yet you withstood them and were able to gain control over them. \
			From now on, a special type of energy is stored in your mind, body and soul, for you to channel. \
			Every psycaster is a follower of a certain school: \
			Redaction - school of mending and curing bodies and souls; \
			Coercion - school of trickery and controlling others; \
			Psychokinesis - school of object manipulation; \
			Energistics - school of elecricity, fire and light; \
			You can select the school, yet its power will be randomised every round."
	value = 16 // It's a powerful quirk and you'll have to slave your ass for it
	medical_record_text = "Patient possesses connection to an another plain of reality."
	quirk_flags = QUIRK_HIDE_FROM_SCAN|QUIRK_HUMAN_ONLY|QUIRK_PROCESSES // Scanners can't see psycasters, only a coercion psycaster may detect other psycasters
	gain_text = span_cyan("You mind reels of psyonic power.")
	lose_text = span_warning("Your psyonic connection to the outer realms got severed.")
	icon = "fa-star"
	mob_trait = TRAIT_PSYONIC_USER
	// Current mana level
	var/mana_level = 0
	// Maximum mana level that one can gain
	var/max_mana = 10
	// Psyonic Level
	var/psyonic_level = 0
	// Psyonic level power description
	var/psyonic_level_string = "Latent"
	// Primary psyonics school
	var/school
	// Secondary psyonics school
	var/secondary_school
	// Two vars copied over from item_quirk to give licence
	var/list/where_items_spawned
	var/open_backpack = FALSE

/datum/quirk/psyonic/add(client/client_source)
	school = client_source?.prefs?.read_preference(/datum/preference/choiced/psyonic_school)
	if(!school)
		school = pick(GLOB.psyonic_schools)
	secondary_school = client_source?.prefs?.read_preference(/datum/preference/choiced/psyonic_school_secondary)
	if(!secondary_school)
		secondary_school = pick(GLOB.psyonic_schools)
	var/mob/living/carbon/human/whom_to_give = quirk_holder
	var/fluff_1 = rand(0,1)
	var/fluff_2 = rand(0,1)
	var/fluff_3 = rand(0,1)
	var/fluff_4 = rand(0,1)
	psyonic_level = fluff_1 + fluff_2 + fluff_3 + fluff_4
	if(HAS_MIND_TRAIT(whom_to_give, TRAIT_MADNESS_IMMUNE)) // grant extra point to madness immune people, aka psychologists
		psyonic_level += rand(0,1) // chance to get the extra point
	switch(psyonic_level)
		if(LATENT_PSYONIC)
			psyonic_level_string = "Pi"
		if(OPERANT_PSYONIC)
			psyonic_level_string = "Omicron"
		if(MASTER_PSYONIC)
			psyonic_level_string = "Kappa"
		if(GRANDMASTER_PSYONIC)
			psyonic_level_string = "Lambda"
		if(PARAMOUNT_PSYONIC)
			psyonic_level_string = "Theta"
		if(GREATEST_PSYONIC) // Only avaliable to extremely lucky psychologists who managed to roll all previous 5 randoms on 1
			psyonic_level_string = "Epsilon"
	max_mana = (psyonic_level + 1) * 20 // min 20, max 100
	RegisterSignal(quirk_holder, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(get_status_tab_item))
	if(school == secondary_school)
		psyonic_level += 1 // If secondary matches the primary, add a level, but don't change the desc
	switch(school)
		if("Redaction")
			whom_to_give.try_add_redaction_school(psyonic_level, secondary_school)
		if("Coercion")
			whom_to_give.try_add_coercion_school(psyonic_level, secondary_school)
		if("Psychokinesis")
			whom_to_give.try_add_psychokinesis_school(psyonic_level, secondary_school)
		if("Energistics")
			whom_to_give.try_add_energistics_school(psyonic_level, secondary_school)

	if(secondary_school != school) // If schools are different, add 0 level ability of the secondary school
		switch(secondary_school)
			if("Redaction")
				whom_to_give.try_add_redaction_school(0, 0)
			if("Coercion")
				whom_to_give.try_add_coercion_school(0, 0)
			if("Psychokinesis")
				whom_to_give.try_add_psychokinesis_school(0, 0)
			if("Energistics")
				whom_to_give.try_add_energistics_school(0, 0)

	var/fluff_text = span_cyan("Current psionic factors:") + "<br>" + \
					 "[fluff_1 ? "Current star position is aligned to your soul." : "The stars do not precede luck to you."]" + "<br>" + \
					 "[fluff_2 ? "Other realms are unusually active this shift." : "Other realms are quiet today."]" + "<br>" + \
					 "[fluff_3 ? "Time-bluespace continuum seems to be stable today." : "Time-bluespace continuum is not giving you energy today."]" + "<br>" + \
					 "[fluff_4 ? "Your mind is clearly open to otherwordly energy." : "Something clouds your connection to otherworld energy."]"
	to_chat(quirk_holder, boxed_message(span_infoplain(jointext(fluff_text, "\n&bull; "))))
	psyonic_level -= 1 // Necessary, else grants spells that you can't cast

	var/obj/item/card/psyonic_license/new_license = new(whom_to_give)

	give_item_to_holder(new_license, list(LOCATION_BACKPACK = ITEM_SLOT_BACK, LOCATION_HANDS = ITEM_SLOT_HANDS), flavour_text = "Make sure not to lose it. You can not remake this on the station.")

/datum/quirk/psyonic/proc/give_item_to_holder(obj/item/quirk_item, list/valid_slots, flavour_text = null, default_location = "at your feet", notify_player = TRUE)
	if(ispath(quirk_item))
		quirk_item = new quirk_item(get_turf(quirk_holder))

	var/mob/living/carbon/human/human_holder = quirk_holder

	var/where = human_holder.equip_in_one_of_slots(quirk_item, valid_slots, qdel_on_fail = FALSE, indirect_action = TRUE) || default_location

	if(where == LOCATION_BACKPACK)
		open_backpack = TRUE

	if(notify_player)
		LAZYADD(where_items_spawned, span_boldnotice("You have \a [quirk_item] [where]. [flavour_text]"))

/datum/quirk/psyonic/remove()
	UnregisterSignal(quirk_holder, COMSIG_MOB_GET_STATUS_TAB_ITEMS)

// Shows current levels of psyonics energy
/datum/quirk/psyonic/proc/get_status_tab_item(mob/living/source, list/items)
	SIGNAL_HANDLER

	items += "Psyonic School: [school]"
	items += "Secondary School: [secondary_school]"
	items += "Psyonic Tier: [psyonic_level_string]"
	items += "Current psyonic energy: [mana_level]/[max_mana]"

/datum/quirk/psyonic/process(seconds_per_tick)
	if(HAS_TRAIT(quirk_holder, TRAIT_NO_PSYONICS)) // Psyonics regen dampener implant
		return

	if(HAS_TRAIT(quirk_holder, TRAIT_MINDSHIELD)) // Womp womp
		return

	var/additional_mana = 1
	if(quirk_holder.has_status_effect(/datum/status_effect/drugginess)) // drugs buff psyonics regen
		additional_mana *= 1.5

	if(HAS_TRAIT(quirk_holder, TRAIT_PRO_PSYONICS)) // If a psyonics regen improving implant is present
		additional_mana *= 4

	if(mana_level <= max_mana)
		mana_level += seconds_per_tick * 0.5 * additional_mana
	mana_level = clamp(mana_level, 0, max_mana)

/datum/quirk_constant_data/psyonic_school
	associated_typepath = /datum/quirk/psyonic
	customization_options = list(/datum/preference/choiced/psyonic_school, /datum/preference/choiced/psyonic_school_secondary)

/datum/preference/choiced/psyonic_school
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "psyonic_school"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/psyonic_school/create_default_value()
	return "Redaction"

/datum/preference/choiced/psyonic_school/init_possible_values()
	return GLOB.psyonic_schools

/datum/preference/choiced/psyonic_school/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE

	return "Psyonic Abilities" in preferences.all_quirks

/datum/preference/choiced/psyonic_school/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/psyonic_school_secondary
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "psyonic_school_secondary"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/psyonic_school_secondary/create_default_value()
	return "Redaction"

/datum/preference/choiced/psyonic_school_secondary/init_possible_values()
	return GLOB.psyonic_schools

/datum/preference/choiced/psyonic_school_secondary/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE

	return "Psyonic Abilities" in preferences.all_quirks

/datum/preference/choiced/psyonic_school_secondary/apply_to_human(mob/living/carbon/human/target, value)
	return

#undef LATENT_PSYONIC
#undef OPERANT_PSYONIC
#undef MASTER_PSYONIC
#undef GRANDMASTER_PSYONIC
#undef PARAMOUNT_PSYONIC
