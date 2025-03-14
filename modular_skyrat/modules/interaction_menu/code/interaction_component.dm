//SPLURT EDIT ADDITION BEGIN - INTERACTION MENU PREFERENCES - Adding global list of interaction menu preferences
GLOBAL_LIST_INIT(interaction_menu_preferences, typecacheof(list(
	/datum/preference/toggle/master_erp_preferences,
	/datum/preference/toggle/erp,
	/datum/preference/choiced/erp_status,
	/datum/preference/choiced/erp_status_nc,
	/datum/preference/choiced/erp_status_v,
	/datum/preference/choiced/erp_status_extm,
	/datum/preference/choiced/erp_status_unholy,
	/datum/preference/choiced/erp_status_extmharm,
)))
//SPLURT EDIT ADDITION END

/datum/component/interactable
	/// A hard reference to the parent
	var/mob/living/self = null 	// SPLURT EDIT - INTERACTIONS - All mobs should be interactable
	/// A list of interactions that the user can engage in.
	var/list/datum/interaction/interactions
	var/interact_last = 0
	var/interact_next = 0
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
	// SPLURT EDIT START - INTERACTIONS - A list of mobs that should be genderized
	// A list of mobs that should be genderized.
	var/static/list/should_be_genderized = typecacheof(list(
		// /mob/living/basic/pet/cat // anuything soes here
	))
	// SPLURT EDIT END

/datum/component/interactable/Initialize(...)
	if(QDELETED(parent))
		qdel(src)
		return

	if(!isliving(parent)) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable
		return COMPONENT_INCOMPATIBLE

	self = parent

	add_verb(self, /mob/living/proc/interact_with) 	// SPLURT EDIT - INTERACTIONS - All mobs should be interactable

	build_interactions_list()

	// SPLURT EDIT START - INTERACTIONS - Genderize mobs
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
	// SPLURT EDIT END

/datum/component/interactable/proc/build_interactions_list()
	interactions = list()
	//SPLURT EDIT CHANGE BEGIN - INTERACTIONS SUBSYSTEM - Changed to use SSinteractions
	if(!SSinteractions)
		return // Can't continue, no subsystem
	for(var/iterating_interaction_id in SSinteractions.interactions)
		var/datum/interaction/interaction = SSinteractions.interactions[iterating_interaction_id]
	//SPLURT EDIT CHANGE END
		if(interaction.lewd)
			if(!self.client?.prefs?.read_preference(/datum/preference/toggle/erp) && !(!ishuman(self) && !self.client && !SSinteractions.is_blacklisted(self))) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable
				continue
			/*
			SPLURT EDIT REMOVAL - Interactions
			if(interaction.sexuality != "" && interaction.sexuality != self.client?.prefs?.read_preference(/datum/preference/choiced/erp_sexuality))
				continue
			*/
		interactions.Add(interaction)

/datum/component/interactable/RegisterWithParent()
	RegisterSignal(parent, COMSIG_CLICK_CTRL_SHIFT, PROC_REF(open_interaction_menu))

/datum/component/interactable/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_CLICK_CTRL_SHIFT)

/datum/component/interactable/Destroy(force, silent)
	self = null
	interactions = null
	return ..()

/datum/component/interactable/proc/open_interaction_menu(datum/source, mob/user)
	if(!isliving(user)) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable
		return
	build_interactions_list()
	ui_interact(user)

/datum/component/interactable/proc/can_interact(datum/interaction/interaction, mob/living/target) 	// SPLURT EDIT - INTERACTIONS - All mobs should be interactable
	if(!interaction.allow_act(target, self))
		return FALSE
	if(interaction.lewd && !target.client?.prefs?.read_preference(/datum/preference/toggle/erp) && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target))) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable
		return FALSE
	if(!interaction.distance_allowed && !target.Adjacent(self))
		return FALSE
	if(interaction.category == INTERACTION_CAT_HIDE)
		return FALSE
	if(self == target && interaction.usage == INTERACTION_OTHER)
		return FALSE
	return TRUE

/// UI Control
/datum/component/interactable/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		//SPLURT EDIT CHANGE BEGIN - UI INTERFACE - New interaction menu interface
		//ui = new(user, src, "Interactions") - SPLURT EDIT - ORIGINAL
		ui = new(user, src, "MobInteraction")
		//SPLURT EDIT CHANGE END
		ui.open()

/datum/component/interactable/ui_status(mob/user, datum/ui_state/state)
	if(!isliving(user)) 		// SPLURT EDIT - INTERACTIONS - All mobs should be interactable
		return UI_CLOSE

	return UI_INTERACTIVE // This UI is always interactive as we handle distance flags via can_interact

/// Returns a list of interaction-relevant attributes for the given mob
/datum/component/interactable/proc/get_interaction_attributes(mob/living/target) 	// SPLURT EDIT - INTERACTIONS - All mobs should be interactable
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

/datum/component/interactable/ui_data(mob/living/user)  	// SPLURT EDIT - INTERACTIONS - All mobs should be interactable
	var/list/data = list()
	var/list/descriptions = list()
	var/list/categories = list()
	var/list/display_categories = list()
	var/list/colors = list()
	var/list/additional_details = list()

	var/mob/living/carbon/human/human_user = user
	var/mob/living/carbon/human/human_self = self

	var/datum/component/interactable/user_interaction_component = user.GetComponent(/datum/component/interactable)

	for(var/datum/interaction/interaction in interactions)
		if(!can_interact(interaction, user))
			continue
		if(!categories[interaction.category])
			categories[interaction.category] = list(interaction.name)
		else
			categories[interaction.category] += interaction.name
			var/list/sorted_category = sort_list(categories[interaction.category])
			categories[interaction.category] = sorted_category
		descriptions[interaction.name] = interaction.description
		colors[interaction.name] = interaction.color
		if(length(interaction.additional_details))
			additional_details[interaction.name] = interaction.additional_details

	data["descriptions"] = descriptions
	data["colors"] = colors
	data["additional_details"] = additional_details
	for(var/category in categories)
		display_categories += category
	data["categories"] = sort_list(display_categories)
	data["interactions"] = categories
	data["block_interact"] = user_interaction_component?.interact_next >= world.time

	// User is always the one interacting, self is the target
	data["favorite_interactions"] = user.client?.prefs?.read_preference(/datum/preference/blob/favorite_interactions) || list()
	data["ref_user"] = REF(user)
	data["ref_self"] = REF(self)
	data["self"] = self.name

	// Character info - Reoriented to show from user's perspective
	data["isTargetSelf"] = (user == self)
	data["interactingWith"] = user == self ? "Interacting with yourself..." : "Interacting with \the [self]..."

	// SPLURT EDIT START - INTERACTIONS - Any living mob should be interactable
	// Primary attributes (user's stats)
	if(user)
		data["pleasure"] = user.pleasure || 0
		data["maxPleasure"] = AROUSAL_LIMIT * (istype(human_user) ? human_user.dna.features["lust_tolerance"] || 1 : 1)
		data["arousal"] = user.arousal || 0
		data["maxArousal"] = AROUSAL_LIMIT
		data["pain"] = user.pain || 0
		data["maxPain"] = AROUSAL_LIMIT
		data["selfAttributes"] = get_interaction_attributes(user)
	// SPLURT EDIT END
	else
		data["pleasure"] = 0
		data["maxPleasure"] = AROUSAL_LIMIT
		data["arousal"] = 0
		data["maxArousal"] = AROUSAL_LIMIT
		data["pain"] = 0
		data["maxPain"] = AROUSAL_LIMIT
		data["selfAttributes"] = list()

	// Target attributes (self's stats) only if not self-targeting
	if(user != self)
		data["theirAttributes"] = get_interaction_attributes(self)
		data["theirPleasure"] = self.pleasure || 0
		data["theirMaxPleasure"] = AROUSAL_LIMIT * (istype(human_self) ? human_self.dna.features["lust_tolerance"] || 1 : 1)
		data["theirArousal"] = self.arousal || 0
		data["theirMaxArousal"] = AROUSAL_LIMIT
		data["theirPain"] = self.pain || 0
		data["theirMaxPain"] = AROUSAL_LIMIT
	else
		data["theirAttributes"] = list()
		data["theirPleasure"] = null
		data["theirMaxPleasure"] = null
		data["theirArousal"] = null
		data["theirMaxArousal"] = null
		data["theirPain"] = null
		data["theirMaxPain"] = null

	// Content preferences - Always use user's preferences
	if(user.client?.prefs)
		// Master ERP pref
		data["master_erp_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/master_erp_preferences)
		// Base ERP toggle
		data["base_erp_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp)

		// Character ERP prefs (status prefs)
		var/datum/preference/choiced/erp_status/erp_pref = GLOB.preference_entries[/datum/preference/choiced/erp_status]
		var/datum/preference/choiced/erp_status_nc/noncon_pref = GLOB.preference_entries[/datum/preference/choiced/erp_status_nc]
		var/datum/preference/choiced/erp_status_v/vore_pref = GLOB.preference_entries[/datum/preference/choiced/erp_status_v]
		var/datum/preference/choiced/erp_status_extm/extreme_pref = GLOB.preference_entries[/datum/preference/choiced/erp_status_extm]
		var/datum/preference/choiced/erp_status_unholy/unholy_pref = GLOB.preference_entries[/datum/preference/choiced/erp_status_unholy]
		var/datum/preference/choiced/erp_status_extmharm/extreme_harm_pref = GLOB.preference_entries[/datum/preference/choiced/erp_status_extmharm]

		data["erp_pref"] = user.client.prefs.read_preference(erp_pref.type)
		data["erp_pref_values"] = erp_pref.init_possible_values()
		data["noncon_pref"] = user.client.prefs.read_preference(noncon_pref.type)
		data["noncon_pref_values"] = noncon_pref.init_possible_values()
		data["vore_pref"] = user.client.prefs.read_preference(vore_pref.type)
		data["vore_pref_values"] = vore_pref.init_possible_values()
		data["extreme_pref"] = user.client.prefs.read_preference(extreme_pref.type)
		data["extreme_pref_values"] = extreme_pref.init_possible_values()
		data["unholy_pref"] = user.client.prefs.read_preference(unholy_pref.type)
		data["unholy_pref_values"] = unholy_pref.init_possible_values()
		data["extreme_harm"] = user.client.prefs.read_preference(extreme_harm_pref.type)
		data["extreme_harm_values"] = extreme_harm_pref.init_possible_values()

		// Content toggle prefs
		data["erp_sounds_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/sounds)
		data["sextoy_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/sex_toy)
		data["sextoy_sounds_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/sex_toy_sounds)
		data["bimbofication_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/bimbofication)
		data["aphro_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/aphro)
		data["breast_enlargement_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/breast_enlargement)
		data["breast_shrinkage_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/breast_shrinkage)
		data["penis_enlargement_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/penis_enlargement)
		data["penis_shrinkage_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/penis_shrinkage)
		data["gender_change_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/gender_change)
		data["autocum_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/autocum)
		data["autoemote_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/autoemote)
		data["genitalia_removal_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/genitalia_removal)
		data["new_genitalia_growth_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/new_genitalia_growth)

		// SPLURT additions
		data["butt_enlargement_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/butt_enlargement)
		data["butt_shrinkage_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/butt_shrinkage)
		data["belly_enlargement_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/belly_enlargement)
		data["belly_shrinkage_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/belly_shrinkage)
		data["forced_neverboner_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/forced_neverboner)
		data["custom_genital_fluids_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/custom_genital_fluids)
		data["cumflation_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/cumflation)
		data["cumflates_partners_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/cumflates_partners)

		// Vore prefs
		data["vore_enable_pref"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/vore_enable)
		data["vore_overlays"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/vore_overlays)
		data["vore_overlay_options"] = user.client.prefs.read_preference(/datum/preference/toggle/erp/vore_overlay_options)

	// Genital data - Only if user is human
	var/list/genital_list = list()
	// SPLURT EDIT START - INTERACTIONS - Currently only humans may have genitalia
	if(ishuman(user))
	// SPLURT EDIT END
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
	data["genitals"] = genital_list

	// Lewd items - Show target's (self's) lewd slots for user to interact with
	var/list/parts = list()
	if(ishuman(user) && can_lewd_strip(user, self))
		if(self.client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy))
			if(self.has_vagina())
				parts += list(generate_strip_entry(ORGAN_SLOT_VAGINA, self, user, human_self.vagina))
			if(self.has_penis())
				parts += list(generate_strip_entry(ORGAN_SLOT_PENIS, self, user, human_self.penis))
			if(self.has_anus())
				parts += list(generate_strip_entry(ORGAN_SLOT_ANUS, self, user, human_self.anus))
			parts += list(generate_strip_entry(ORGAN_SLOT_NIPPLES, self, user, human_self.nipples))

	data["lewd_slots"] = parts

	return data

/**
 *  Takes the organ slot name, along with a target and source, along with the item on the target that the source can potentially interact with.
 *  If the source can't interact with said slot, or there is no item in the first place, it'll set the icon to null to indicate that TGUI should put a placeholder sprite.
 *
 * Arguments:
 * * name - The name of slot to check and return inside the generated list.
 * * target - The mob that's being interacted with.
 * * source - The mob that's interacting.
 * * item - The item that's currently inside said slot. Can be null.
 */
/datum/component/interactable/proc/generate_strip_entry(name, mob/living/carbon/human/target, mob/living/carbon/human/source, obj/item/clothing/sextoy/item)
	return list(
		"name" = name,
		"img" = (item && can_lewd_strip(source, target, name)) ? icon2base64(icon(item.icon, item.icon_state, SOUTH, 1)) : null,
		"item_name" = item ? item.name : null
		)

/datum/component/interactable/ui_close(mob/user)
	if(length(modified_preferences) && self.client?.prefs)
		self.client.prefs.save_character()
		self.client.prefs.save_preferences()
		modified_preferences.Cut()

/datum/component/interactable/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(!isliving(usr)) 		// SPLURT EDIT - INTERACTIONS - All mobs should be interactable
		return

	var/mob/living/user = usr 	// SPLURT EDIT - INTERACTIONS - All mobs should be interactable
	var/datum/preferences/prefs = user.client?.prefs

	switch(action)
		if("interact")
			var/interaction_id = params["interaction"]
			var/mob/living/source = locate(params["userref"]) 	// SPLURT EDIT - INTERACTIONS - All mobs should be interactable
			var/mob/living/target = locate(params["selfref"]) 	// SPLURT EDIT - INTERACTIONS - All mobs should be interactable
			if(!interaction_id || !source || !target)
				return FALSE

			// Find the interaction by name
			var/datum/interaction/selected_interaction
			for(var/datum/interaction/interaction in interactions)
				if(interaction.name == interaction_id)
					selected_interaction = interaction
					break

			if(!selected_interaction)
				return FALSE

			if(!can_interact(selected_interaction, source))
				return FALSE

			if(interact_next >= world.time)
				return FALSE

			selected_interaction.act(source, target)
			var/datum/component/interactable/interaction_component = source.GetComponent(/datum/component/interactable)
			interaction_component.interact_last = world.time
			interaction_component.interact_next = interaction_component.interact_last + INTERACTION_COOLDOWN
			return TRUE

		if("favorite")
			if(!prefs)
				return FALSE

			var/interaction_id = params["interaction"]
			if(!interaction_id)
				return FALSE

			var/list/favorite_interactions = prefs.read_preference(/datum/preference/blob/favorite_interactions) || list()
			if(interaction_id in favorite_interactions)
				favorite_interactions -= interaction_id
			else
				favorite_interactions += interaction_id
			prefs.update_preference(GLOB.preference_entries[/datum/preference/blob/favorite_interactions], favorite_interactions)
			modified_preferences |= "favorite_interactions"
			return TRUE

		if("pref")
			if(!prefs)
				return
			var/pref_path = LAZYACCESS(preference_paths, params["pref"])
			if(!pref_path)
				return

			if(params["amount"])
				prefs.update_preference(GLOB.preference_entries[pref_path], params["amount"])
			else
				prefs.update_preference(GLOB.preference_entries[pref_path], !prefs.read_preference(pref_path))
			modified_preferences |= pref_path
			return TRUE

		if("char_pref")
			if(!prefs)
				return
			var/pref_path = LAZYACCESS(character_preference_paths, params["char_pref"])
			if(!pref_path)
				return

			var/value = params["value"]
			var/datum/preference/choiced/pref_type = GLOB.preference_entries[pref_path]
			// Validate that the value is one of the allowed options
			var/list/valid_values = pref_type.init_possible_values()
			if(!(value in valid_values))
				return

			prefs.update_preference(pref_type, value)
			modified_preferences |= pref_path
			return TRUE

		if("item_slot")
			var/item_index = params["item_slot"]
			var/mob/living/carbon/human/source = locate(params["userref"])
			var/mob/living/carbon/human/target = locate(params["selfref"])
			if(!source || !istype(target))
				return FALSE

			var/obj/item/clothing/sextoy/new_item = source.get_active_held_item()
			var/obj/item/clothing/sextoy/existing_item = target.vars[item_index]

			if(!existing_item && !new_item)
				source.show_message(span_warning("No item to insert or remove!"))
				return

			if(!existing_item && !istype(new_item))
				source.show_message(span_warning("The item you're holding is not a toy!"))
				return

			if(can_lewd_strip(source, target, item_index) && is_toy_compatible(new_item, item_index))
				var/internal = (item_index in list(ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS))
				var/insert_or_attach = internal ? "insert" : "attach"
				var/into_or_onto = internal ? "into" : "onto"

				if(existing_item)
					source.visible_message(span_purple("[source.name] starts trying to remove something from [target.name]'s [item_index]."), span_purple("You start to remove [existing_item.name] from [target.name]'s [item_index]."), span_purple("You hear someone trying to remove something from someone nearby."), vision_distance = 1, ignored_mobs = list(target))
				else if (new_item)
					source.visible_message(span_purple("[source.name] starts trying to [insert_or_attach] the [new_item.name] [into_or_onto] [target.name]'s [item_index]."), span_purple("You start to [insert_or_attach] the [new_item.name] [into_or_onto] [target.name]'s [item_index]."), span_purple("You hear someone trying to [insert_or_attach] something [into_or_onto] someone nearby."), vision_distance = 1, ignored_mobs = list(target))
				if (source != target)
					target.show_message(span_warning("[source.name] is trying to [existing_item ? "remove the [existing_item.name] [internal ? "in" : "on"]" : new_item ? "is trying to [insert_or_attach] the [new_item.name] [into_or_onto]" : span_alert("What the fuck, impossible condition? interaction_component.dm!")] your [item_index]!"))
				if(do_after(
					source,
					5 SECONDS,
					target,
					interaction_key = "interaction_[item_index]"
					) && can_lewd_strip(source, target, item_index))

					if(existing_item)
						source.visible_message(span_purple("[source.name] removes [existing_item.name] from [target.name]'s [item_index]."), span_purple("You remove [existing_item.name] from [target.name]'s [item_index]."), span_purple("You hear someone remove something from someone nearby."), vision_distance = 1)
						target.dropItemToGround(existing_item, force = TRUE) // Force is true, cause nodrop shouldn't affect lewd items.
						source.put_in_hands(existing_item, forced = TRUE) // SPLURT EDIT - puts it in the source's hands, it still needs to be dropped for specific sextoy behavior
						target.vars[item_index] = null
					else if (new_item)
						source.visible_message(span_purple("[source.name] [internal ? "inserts" : "attaches"] the [new_item.name] [into_or_onto] [target.name]'s [item_index]."), span_purple("You [insert_or_attach] the [new_item.name] [into_or_onto] [target.name]'s [item_index]."), span_purple("You hear someone [insert_or_attach] something [into_or_onto] someone nearby."), vision_distance = 1)
						target.vars[item_index] = new_item
						new_item.forceMove(target)
						new_item.lewd_equipped(target, item_index)
					target.update_inv_lewd()

			else
				source.show_message(span_warning("Failed to adjust [target.name]'s toys!"))

			return TRUE

		if("toggle_genital_visibility")
			if(!ishuman(user))
				return FALSE
			var/obj/item/organ/genital/genital = user.get_organ_slot(params["genital"])
			if(!genital || !istype(genital))
				return FALSE

			var/visibility = params["visibility"]
			if(!(visibility in list(GENITAL_NEVER_SHOW, GENITAL_HIDDEN_BY_CLOTHES, GENITAL_ALWAYS_SHOW)))
				return FALSE

			genital.visibility_preference = visibility
			user.update_body()
			return TRUE

		if("toggle_genital_arousal")
			if(!ishuman(user))
				return FALSE
			var/obj/item/organ/genital/genital = user.get_organ_slot(params["genital"])
			if(!genital || !istype(genital) || genital.aroused == AROUSAL_CANT)
				return FALSE

			var/arousal = params["arousal"]
			if(!(arousal in list(AROUSAL_NONE, AROUSAL_PARTIAL, AROUSAL_FULL)))
				return FALSE

			genital.aroused = arousal
			genital.update_sprite_suffix()
			user.update_body()
			return TRUE

		if("toggle_genital_accessibility")
			if(!ishuman(user))
				return FALSE
			var/obj/item/organ/genital/genital = user.get_organ_slot(params["genital"])
			if(!genital || !istype(genital))
				return FALSE

			genital.always_accessible = !genital.always_accessible
			return TRUE

		if("toggle_genital_active")
			if(ishuman(user))
				return FALSE
			var/genital_name = params["genital"]
			if(!genital_name)
				return FALSE
			user.simulated_genitals[genital_name] = !user.simulated_genitals[genital_name]
			return TRUE

	message_admins("Unhandled interaction '[params["interaction"]]'. Inform coders.")

/// Checks if the target has ERP toys enabled, and can be logially reached by the user.
/datum/component/interactable/proc/can_lewd_strip(mob/living/carbon/human/source, mob/living/carbon/human/target, slot_index)
	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy))
		return FALSE
	if(!(source.loc == target.loc || source.Adjacent(target)))
		return FALSE
	if(!source.has_arms())
		return FALSE
	if(!slot_index) // This condition is for the UI to decide if the button is shown at all. Slot index should never be null otherwise.
		return TRUE

	switch(slot_index)
		if(ORGAN_SLOT_NIPPLES)
			var/chest_exposed = target.has_breasts(required_state = REQUIRE_GENITAL_EXPOSED)
			if(!chest_exposed)
				chest_exposed = target.is_topless() // for when we don't have breasts

			return chest_exposed

		if(ORGAN_SLOT_PENIS)
			return target.has_penis(required_state = REQUIRE_GENITAL_EXPOSED)
		if(ORGAN_SLOT_VAGINA)
			return target.has_vagina(required_state = REQUIRE_GENITAL_EXPOSED)
		if(ORGAN_SLOT_ANUS)
			return target.has_anus(required_state = REQUIRE_GENITAL_EXPOSED)

/// Decides if a player should be able to insert or remove an item from a provided lewd slot_index.
/datum/component/interactable/proc/is_toy_compatible(obj/item/clothing/sextoy/item, slot_index)
	if(!item) // Used for UI code, should never be actually null during actual logic code.
		return TRUE

	switch(slot_index)
		if(ORGAN_SLOT_VAGINA)
			return item.lewd_slot_flags & LEWD_SLOT_VAGINA
		if(ORGAN_SLOT_PENIS)
			return item.lewd_slot_flags & LEWD_SLOT_PENIS
		if(ORGAN_SLOT_ANUS)
			return item.lewd_slot_flags & LEWD_SLOT_ANUS
		if(ORGAN_SLOT_NIPPLES)
			return item.lewd_slot_flags & LEWD_SLOT_NIPPLES
		else
			return FALSE

/mob/living/proc/interact_with() 	// SPLURT EDIT - INTERACTIONS - All mobs should be interactable
	set name = "Interact With"
	set desc = "Perform an interaction with someone."
	set category = "IC"
	set src in view(usr.client)

	var/datum/component/interactable/menu = GetComponent(/datum/component/interactable)
	if(!menu)
		to_chat(src, span_warning("You must have done something really bad to not have an interaction component."))
		return

	menu.open_interaction_menu(src, usr)
