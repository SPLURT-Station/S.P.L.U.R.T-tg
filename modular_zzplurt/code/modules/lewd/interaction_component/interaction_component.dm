/datum/component/interactable
	/// List of preferences that have been modified and need to be saved
	var/list/modified_preferences = list()
	/// List of preference paths mapped to their toggle types
	var/static/list/preference_paths = list(
		"master_erp_pref" = /datum/preference/toggle/master_erp_preferences,
		"base_erp_pref" = /datum/preference/toggle/erp,
		// Core ERP prefs
		"erp_sounds_pref" = /datum/preference/toggle/erp/sounds,
		"sextoy_pref" = /datum/preference/toggle/erp/sex_toy,
		"sextoy_sounds_pref" = /datum/preference/toggle/erp/sex_toy_sounds,
		"bimbofication_pref" = /datum/preference/toggle/erp/bimbofication,
		"aphro_pref" = /datum/preference/toggle/erp/aphro,
		"breast_enlargement_pref" = /datum/preference/toggle/erp/breast_enlargement,
		"breast_shrinkage_pref" = /datum/preference/toggle/erp/breast_shrinkage,
		"penis_enlargement_pref" = /datum/preference/toggle/erp/penis_enlargement,
		"penis_shrinkage_pref" = /datum/preference/toggle/erp/penis_shrinkage,
		"gender_change_pref" = /datum/preference/toggle/erp/gender_change,
		"autocum_pref" = /datum/preference/toggle/erp/autocum,
		"autoemote_pref" = /datum/preference/toggle/erp/autoemote,
		"genitalia_removal_pref" = /datum/preference/toggle/erp/genitalia_removal,
		"new_genitalia_growth_pref" = /datum/preference/toggle/erp/new_genitalia_growth,
		// SPLURT additions
		"butt_enlargement_pref" = /datum/preference/toggle/erp/butt_enlargement,
		"butt_shrinkage_pref" = /datum/preference/toggle/erp/butt_shrinkage,
		"belly_enlargement_pref" = /datum/preference/toggle/erp/belly_enlargement,
		"belly_shrinkage_pref" = /datum/preference/toggle/erp/belly_shrinkage,
		"forced_neverboner_pref" = /datum/preference/toggle/erp/forced_neverboner,
		"custom_genital_fluids_pref" = /datum/preference/toggle/erp/custom_genital_fluids,
		"cumflation_pref" = /datum/preference/toggle/erp/cumflation,
		"cumflates_partners_pref" = /datum/preference/toggle/erp/cumflates_partners,
		"favorite_interactions" = /datum/preference/blob/favorite_interactions, // Not a toggle but it shouldn't cause any issues
		// Vore prefs
		"vore_enable_pref" = /datum/preference/toggle/erp/vore_enable,
		"vore_overlays" = /datum/preference/toggle/erp/vore_overlays,
		"vore_overlay_options" = /datum/preference/toggle/erp/vore_overlay_options
	)
	/// List of character preference paths mapped to their types
	var/static/list/character_preference_paths = list(
		"erp_pref" = /datum/preference/choiced/erp_status,
		"noncon_pref" = /datum/preference/choiced/erp_status_nc,
		"vore_pref" = /datum/preference/choiced/erp_status_v,
		"extreme_pref" = /datum/preference/choiced/erp_status_extm,
		"extreme_harm" = /datum/preference/choiced/erp_status_extmharm,
		"unholy_pref" = /datum/preference/choiced/erp_status_unholy
	)
	/// Cache of the user's preferences, used to avoid re-reading them from the client
	var/list/cached_preferences = list()

	/// A list of mobs that should be genderized.
	var/static/list/should_be_genderized = typecacheof(list(
		// /mob/living/basic/pet/cat // anuything soes here
	))

	/**
	 * A list of auto interaction data
	 *
	 * interaction_text - The ID of the interaction and target
	 * * speed - The speed of the interaction
	 * * target - The target of the interaction
	 * * target_name - The name of the target
	 * * next_interaction - The next time the interaction should be performed
	 */
	var/auto_interaction_info = list()

/datum/component/interactable/Initialize(...)
	. = ..()
	if(.) //Incompatible or redundant
		return

	add_verb(self, /mob/living/proc/interact_with)

	if(is_type_in_typecache(parent, should_be_genderized))
		var/mob/living/mob = parent
		switch(mob.gender)
			if(MALE)
				mob.simulated_genitals[ORGAN_SLOT_PENIS] = TRUE
			if(FEMALE)
				mob.simulated_genitals[ORGAN_SLOT_VAGINA] = TRUE
				mob.simulated_genitals[ORGAN_SLOT_BREASTS] = TRUE
			if(PLURAL)
				mob.simulated_genitals[ORGAN_SLOT_PENIS] = TRUE
				mob.simulated_genitals[ORGAN_SLOT_VAGINA] = TRUE
				mob.simulated_genitals[ORGAN_SLOT_BREASTS] = TRUE

/datum/component/interactable/Destroy(force, silent)
	STOP_PROCESSING(SSinteractions, src)
	. = ..()

/datum/component/interactable/process(seconds_per_tick)
	if(!LAZYLEN(auto_interaction_info))
		return PROCESS_KILL

	for(var/interaction_text in auto_interaction_info)
		var/datum/interaction/interaction = SSinteractions.interactions[splittext(interaction_text, "_target_")[1]]
		var/interaction_speed = auto_interaction_info[interaction_text]["speed"] SECONDS
		var/mob/living/target = locate(auto_interaction_info[interaction_text]["target"])
		var/datum/component/interactable/target_interaction_component = target?.GetComponent(/datum/component/interactable)

		if(!interaction || QDELETED(target) || !target_interaction_component?.can_interact(interaction, self))
			auto_interaction_info -= interaction_text
			continue

		if(!(world.time >= auto_interaction_info[interaction_text]["next_interaction"]))
			continue

		interaction.act(self, target)
		auto_interaction_info[interaction_text]["next_interaction"] = world.time + interaction_speed

/datum/component/interactable/ui_data(mob/living/user)
	. = ..()

	if(!LAZYLEN(cached_preferences))
		update_cached_preferences(user)


	var/mob/living/carbon/human/human_user = user
	var/mob/living/carbon/human/human_self = self

	var/datum/component/interactable/user_interaction_component = user.GetComponent(/datum/component/interactable)

	// Character info - Reoriented to show from user's perspective
	.["isTargetSelf"] = (user == self)
	.["interactingWith"] = user == self ? "Interacting with yourself..." : "Interacting with \the [self]..."

	// Primary attributes (user's stats)
	if(user)
		.["pleasure"] = user.pleasure || 0
		.["maxPleasure"] = AROUSAL_LIMIT * (istype(human_user) ? human_user.dna.features["lust_tolerance"] || 1 : 1)
		.["arousal"] = user.arousal || 0
		.["maxArousal"] = AROUSAL_LIMIT
		.["pain"] = user.pain || 0
		.["maxPain"] = AROUSAL_LIMIT
		.["selfAttributes"] = get_interaction_attributes(user)
	else
		.["pleasure"] = 0
		.["maxPleasure"] = AROUSAL_LIMIT
		.["arousal"] = 0
		.["maxArousal"] = AROUSAL_LIMIT
		.["pain"] = 0
		.["maxPain"] = AROUSAL_LIMIT
		.["selfAttributes"] = list()

	// Target attributes (self's stats) only if not self-targeting
	if(user != self)
		.["theirAttributes"] = get_interaction_attributes(self)
		.["theirPleasure"] = self.pleasure || 0
		.["theirMaxPleasure"] = AROUSAL_LIMIT * (istype(human_self) ? human_self.dna.features["lust_tolerance"] || 1 : 1)
		.["theirArousal"] = self.arousal || 0
		.["theirMaxArousal"] = AROUSAL_LIMIT
		.["theirPain"] = self.pain || 0
		.["theirMaxPain"] = AROUSAL_LIMIT
	else
		.["theirAttributes"] = list()
		.["theirPleasure"] = null
		.["theirMaxPleasure"] = null
		.["theirArousal"] = null
		.["theirMaxArousal"] = null
		.["theirPain"] = null
		.["theirMaxPain"] = null

	// Content preferences - Always use user's preferences
	if(user.client?.prefs)

		// Character ERP prefs (status prefs)
		for(var/entry in character_preference_paths)
			var/datum/preference/choiced/pref = GLOB.preference_entries[character_preference_paths[entry]]
			.[entry] = cached_preferences[entry]
			.["[entry]_values"] = pref.get_choices()

		// Content toggle prefs
		for(var/entry in preference_paths)
			.[entry] = cached_preferences[entry]

	// Genital data - Only if user is human
	var/list/genital_list = list()
	if(ishuman(user))
		for(var/obj/item/organ/genital/genital in human_user.organs)
			if(!genital.visibility_preference == GENITAL_SKIP_VISIBILITY)
				var/list/genital_data = list(
					"name" = genital.name,
					"slot" = genital.slot,
					"visibility" = genital.visibility_preference,
					"aroused" = genital.aroused,
					"can_arouse" = (genital.aroused != AROUSAL_CANT),
					"always_accessible" = genital.always_accessible
				)
				genital_list += list(genital_data)
	else
		for(var/organ in user.simulated_genitals)
			var/list/genital_data = list(
				"name" = organ,
				"active" = user.simulated_genitals[organ],
				"is_simple" = TRUE  // New flag to indicate simple active/inactive display
			)
			genital_list += list(genital_data)
	.["genitals"] = genital_list

	// Auto interaction stuff
	.["auto_interaction_speed_values"] = list(
		INTERACTION_SPEED_MIN * (1 / (1 SECONDS)),
		INTERACTION_SPEED_MAX * (1 / (1 SECONDS))
	)
	.["auto_interaction_info"] = user_interaction_component.auto_interaction_info

/datum/component/interactable/generate_strip_entry(name, mob/living/carbon/human/target, mob/living/carbon/human/source, obj/item/clothing/sextoy/item)
	. = ..()
	.["item_name"] = item ? item.name : null

/datum/component/interactable/ui_close(mob/user)
	cached_preferences = list()
	if(length(modified_preferences) && self.client?.prefs)
		self.client.prefs.save_character()
		self.client.prefs.save_preferences()
		modified_preferences.Cut()

/**
 * Updates the cached preferences for the given user
 *
 * Created to avoid spamming the client for preferences since static data isn't the best option for this
 *
 * user - The user to update the cached preferences for
 */
/datum/component/interactable/proc/update_cached_preferences(mob/living/user, list/preferences)
	if(LAZYLEN(preferences))
		for(var/entry in preferences)
			cached_preferences[entry] = user.client?.prefs.read_preference(character_preference_paths[entry] || preference_paths[entry])
		return

	cached_preferences = list()
	for(var/entry in character_preference_paths)
		cached_preferences[entry] = user.client?.prefs.read_preference(character_preference_paths[entry])
	for(var/entry in preference_paths)
		cached_preferences[entry] = user.client?.prefs.read_preference(preference_paths[entry])

/// Returns a list of interaction-relevant attributes for the given mob
/datum/component/interactable/proc/get_interaction_attributes(mob/living/target)
	if(!istype(target))
		return list()

	var/list/attributes = list()

	// Basic attributes
	if(target.get_bodypart(BODY_ZONE_L_ARM) || target.get_bodypart(BODY_ZONE_R_ARM))
		attributes += "have hands"
	if(target.get_bodypart(BODY_ZONE_HEAD) || (!iscarbon(target) && target.simulated_interaction_requirements[INTERACTION_REQUIRE_SELF_MOUTH]))
		attributes += "have a mouth, which is [!target.is_mouth_covered() ? "covered" : "uncovered"]"

	// Sexual exhaustion
	if(!COOLDOWN_FINISHED(target, refractory_period))
		attributes += "are sexually exhausted for the time being"

	// Intent
	switch(resolve_intent_name(target.combat_mode))
		if(INTENT_HELP)
			attributes += "are acting gentle"
		if(INTENT_DISARM)
			attributes += "are acting playful"
		if(INTENT_GRAB)
			attributes += "are acting rough"
		if(INTENT_HARM)
			attributes += "are fighting anyone who comes near"

	// Clothing state
	var/is_topless = target.is_topless()
	var/is_bottomless = target.is_bottomless()
	if(is_topless && is_bottomless)
		attributes += "are naked"
	else if((is_topless && !is_bottomless) || (!is_topless && is_bottomless))
		attributes += "are partially clothed"
	else
		attributes += "are clothed"

	// Genital checks
	if(target.has_penis(REQUIRE_GENITAL_EXPOSED))
		attributes += "have a penis"
	/* Not implemented yet
	if(target.has_strapon(REQUIRE_GENITAL_EXPOSED))
		attributes += "have a strapon"
	*/
	if(target.has_balls(REQUIRE_GENITAL_EXPOSED))
		attributes += "have a ballsack"
	if(target.has_vagina(REQUIRE_GENITAL_EXPOSED))
		attributes += "have a vagina"
	if(target.has_breasts(REQUIRE_GENITAL_EXPOSED))
		attributes += "have breasts"
	if(target.has_anus(REQUIRE_GENITAL_EXPOSED))
		attributes += "have an anus"
	if(target.has_belly(REQUIRE_GENITAL_EXPOSED))
		attributes += "have a belly"

	// Feet
	if(target.has_feet(REQUIRE_GENITAL_EXPOSED))
		switch(target.get_num_feet())
			if(2)
				attributes += "have a pair of feet"
			if(1)
				attributes += "have a single foot"

	return attributes

/**
 * Handles the inflation of genitalia during climax
 *
 * partner - The partner who is cumming and providing the fluid source
 * source_genital - The slot name of the genitalia that is being used as fluid source (text)
 * slot - The slot of the genitalia being inflated on self
 */
/datum/component/interactable/proc/climax_inflate_genital(mob/living/carbon/human/partner, source_genital, slot)
	if(!ishuman(partner) || !ishuman(self))
		return

	if(!partner.client?.prefs.read_preference(/datum/preference/toggle/erp/cumflates_partners) || !self.client?.prefs.read_preference(/datum/preference/toggle/erp/cumflation))
		return

	var/mob/living/carbon/human/human_self = self // Necessary for the soon to be merged refactor
	var/list/obj/item/organ/genital/to_update = list()

	// Get fluid amount from source genital
	var/obj/item/organ/genital/fluid_source = partner.get_organ_slot(source_genital)
	if(!fluid_source || !fluid_source.internal_fluid_count)
		return

	// Calculate growth based on fluid amount relative to max capacity
	var/growth_amount = ROUND_UP(fluid_source.internal_fluid_count / (fluid_source.internal_fluid_maximum * GENITAL_INFLATION_THRESHOLD))
	if(!growth_amount)
		return

	// Handle belly inflation for oral, vaginal and anal
	if(slot in list("mouth", ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS, ORGAN_SLOT_BELLY))
		var/obj/item/organ/genital/belly/mob_belly = human_self.get_organ_slot(ORGAN_SLOT_BELLY)
		if(!mob_belly && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth))
			mob_belly = new
			mob_belly.build_from_dna(human_self.dna, ORGAN_SLOT_BELLY)
			mob_belly.Insert(human_self, 0, FALSE)
			mob_belly.genital_size = BELLY_MIN_SIZE

		if(mob_belly && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/belly_enlargement))
			var/prev_size = mob_belly.genital_size
			mob_belly.genital_size = min(mob_belly.genital_size + growth_amount, BELLY_MAX_SIZE)
			to_update += mob_belly
			if(mob_belly.genital_size > prev_size)
				human_self.visible_message(span_lewd("\The <b>[human_self]</b>'s belly bloats outwards as it gets pumped full of [LOWER_TEXT(initial(fluid_source.internal_fluid_datum:name))]!"))

		// Handle butt inflation when belly gets big enough from anal
		if(slot == ORGAN_SLOT_ANUS && mob_belly.genital_size >= 3)
			var/obj/item/organ/genital/butt/mob_butt = human_self.get_organ_slot(ORGAN_SLOT_BUTT)
			if(!mob_butt && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth))
				mob_butt = new
				mob_butt.build_from_dna(human_self.dna, ORGAN_SLOT_BUTT)
				mob_butt.Insert(human_self, 0, FALSE)
				mob_butt.genital_size = BUTT_MIN_SIZE

			if(mob_butt && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/butt_enlargement))
				var/prev_size = mob_butt.genital_size
				mob_butt.genital_size = min(mob_butt.genital_size + growth_amount, BUTT_MAX_SIZE)
				to_update += mob_butt
				if(mob_butt.genital_size > prev_size)
					human_self.visible_message(span_lewd("\The <b>[human_self]</b>'s ass swells outwards as it gets pumped full of [LOWER_TEXT(initial(fluid_source.internal_fluid_datum:name))]!"))

	// Handle penis and testicles inflation
	else if(slot == ORGAN_SLOT_PENIS)
		var/obj/item/organ/genital/penis/mob_penis = human_self.get_organ_slot(ORGAN_SLOT_PENIS)
		if(!mob_penis && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth))
			// If the user has not defined their own prefs for their penis type, try to assign a default based on their species
			var/list/species_to_penis = list(
				SPECIES_HUMAN = list(
					"sheath" = SHEATH_NONE,
					"mutant_index" = "Human",
					"balls" = "Pair"
				),
				SPECIES_LIZARD = list(
					"sheath" = SHEATH_SLIT,
					"color" = "#FFB6C1",
					"mutant_index" = "Flared",
					"balls" = "Internal"
				),
				SPECIES_LIZARD_ASH = list(
					"sheath" = SHEATH_SLIT,
					"color" = "#FFB6C1",
					"mutant_index" = "Flared",
					"balls" = "Internal"
				)
			)

			var/list/data = species_to_penis[human_self.dna.species.id]
			if(!data)
				data = species_to_penis[SPECIES_HUMAN]

			if(human_self.dna.features["penis_sheath"] == "None")
				human_self.dna.features["penis_sheath"] = data["sheath"]

			if(human_self.dna.mutant_bodyparts[ORGAN_SLOT_PENIS][MUTANT_INDEX_NAME] == "None")
				human_self.dna.mutant_bodyparts[ORGAN_SLOT_PENIS][MUTANT_INDEX_NAME] = data["mutant_index"]

			if(human_self.dna.mutant_bodyparts[ORGAN_SLOT_TESTICLES][MUTANT_INDEX_NAME] == "None")
				human_self.dna.mutant_bodyparts[ORGAN_SLOT_TESTICLES][MUTANT_INDEX_NAME] = data["balls"]

			var/colour = data["colour"]
			if(colour)
				human_self.dna.mutant_bodyparts[ORGAN_SLOT_PENIS][MUTANT_INDEX_COLOR_LIST] = list(colour)

			mob_penis = new
			mob_penis.build_from_dna(human_self.dna, ORGAN_SLOT_PENIS)
			mob_penis.Insert(human_self, 0, FALSE)
			mob_penis.genital_size = 4
			mob_penis.girth = 3
			human_self.visible_message(span_lewd("\The <b>[human_self]</b>'s crotch feels warm as something suddenly sprouts between their legs."))

		if(mob_penis && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/penis_enlargement))
			var/prev_size = mob_penis.genital_size
			var/prev_girth = mob_penis.girth
			mob_penis.genital_size = min(mob_penis.genital_size + growth_amount, PENIS_MAX_LENGTH)
			mob_penis.girth = min(mob_penis.girth + (growth_amount * 0.5), PENIS_MAX_GIRTH)
			to_update += mob_penis
			if(mob_penis.genital_size > prev_size || mob_penis.girth > prev_girth)
				human_self.visible_message(span_lewd("\The <b>[human_self]</b>'s penis swells larger as it gets pumped full of [LOWER_TEXT(initial(fluid_source.internal_fluid_datum:name))]!"))

		var/obj/item/organ/genital/testicles/mob_testicles = human_self.get_organ_slot(ORGAN_SLOT_TESTICLES)
		if(!mob_testicles && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth))
			mob_testicles = new
			mob_testicles.build_from_dna(human_self.dna, ORGAN_SLOT_TESTICLES)
			mob_testicles.Insert(human_self, 0, FALSE)
			mob_testicles.genital_size = TESTICLES_MIN_SIZE

		if(mob_testicles && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/penis_enlargement))
			var/prev_size = mob_testicles.genital_size
			mob_testicles.genital_size = min(mob_testicles.genital_size + (growth_amount * 0.5), TESTICLES_MAX_SIZE)
			to_update += mob_testicles
			if(mob_testicles.genital_size > prev_size)
				human_self.visible_message(span_lewd("\The <b>[human_self]</b>'s balls grow heavier as they get pumped full of [LOWER_TEXT(initial(fluid_source.internal_fluid_datum:name))]!"))

	// Handle breast inflation
	else if(slot == ORGAN_SLOT_BREASTS)
		var/obj/item/organ/genital/breasts/mob_breasts = human_self.get_organ_slot(ORGAN_SLOT_BREASTS)
		if(!mob_breasts && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth))
			// If the user has not defined their own prefs for their breast type, default to two breasts
			if (human_self.dna.mutant_bodyparts[ORGAN_SLOT_BREASTS][MUTANT_INDEX_NAME] == "None")
				human_self.dna.mutant_bodyparts[ORGAN_SLOT_BREASTS][MUTANT_INDEX_NAME] = "Pair"

			mob_breasts = new
			mob_breasts.build_from_dna(human_self.dna, ORGAN_SLOT_BREASTS)
			mob_breasts.Insert(human_self, 0, FALSE)
			mob_breasts.genital_size = BREASTS_MIN_SIZE

			if(mob_breasts.visibility_preference == GENITAL_ALWAYS_SHOW || human_self.is_topless())
				human_self.visible_message(span_notice("[human_self]'s bust suddenly expands!"))
				to_chat(human_self, span_purple("Your chest feels warm, tingling with sensitivity as it expands outward."))
			else
				human_self.visible_message(span_notice("The area around [human_self]'s chest suddenly bounces a bit."))
				to_chat(human_self, span_purple("Your chest feels warm, tingling with sensitivity as it strains against your clothes."))

		if(mob_breasts && human_self.client?.prefs.read_preference(/datum/preference/toggle/erp/breast_enlargement))
			var/prev_size = mob_breasts.genital_size
			mob_breasts.genital_size = min(mob_breasts.genital_size + growth_amount, BREASTS_MAX_SIZE)
			to_update += mob_breasts
			if(mob_breasts.genital_size > prev_size)
				if(mob_breasts.visibility_preference == GENITAL_ALWAYS_SHOW || human_self.is_topless())
					human_self.visible_message(span_lewd("\The <b>[human_self]</b>'s breasts swell larger as they get pumped full of [LOWER_TEXT(initial(fluid_source.internal_fluid_datum:name))]!"))
				else
					human_self.visible_message(span_lewd("\The area around [human_self]'s chest suddenly bounces a bit."))

	for(var/obj/item/organ/genital/genital in to_update)
		call(/datum/reagent/drug/aphrodisiac::update_appearance())(human_self, genital)

/mob/living/proc/interact_with()
	set name = "Interact With"
	set desc = "Perform an interaction with someone."
	set category = "IC"
	set src in view(usr.client)

	var/datum/component/interactable/menu = GetComponent(/datum/component/interactable)
	if(!menu)
		to_chat(src, span_warning("You must have done something really bad to not have an interaction component."))
		return

	menu.open_interaction_menu(src, usr)
