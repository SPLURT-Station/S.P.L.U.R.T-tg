/// Attempts to open the tgui menu
/mob/verb/interact_with()
	set name = "Interact With"
	set desc = "Perform an interaction with someone."
	set category = "IC"
	set src in view()

	var/datum/component/interaction_menu_granter/menu = usr.GetComponent(/datum/component/interaction_menu_granter)
	if(!menu)
		to_chat(usr, span_warning("You must have done something really bad to not have an interaction component."))
		return

	if(!src)
		to_chat(usr, span_warning("Your interaction target is gone!"))
		return
	menu.open_menu(usr, src)

#define INTERACTION_NORMAL 0
#define INTERACTION_LEWD 1
#define INTERACTION_EXTREME 2

/// The menu itself, only var is target which is the mob you are interacting with
/datum/component/interaction_menu_granter
	var/mob/living/target

/datum/component/interaction_menu_granter/Initialize(...)
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/parent_mob = parent
	if(!parent_mob.client)
		return COMPONENT_INCOMPATIBLE
	. = ..()

/datum/component/interaction_menu_granter/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOB_CTRL_SHIFT_CLICKED, .proc/open_menu)

/datum/component/interaction_menu_granter/Destroy(force, ...)
	target = null
	. = ..()

/datum/component/interaction_menu_granter/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_CTRL_SHIFT_CLICKED)
	if(target)
		UnregisterSignal(target, COMSIG_QDELETING)
	. = ..()

/// The one interacting is clicker, the interacted is clicked.
/datum/component/interaction_menu_granter/proc/open_menu(mob/clicker, mob/clicked)
	// COMSIG_MOB_CTRL_SHIFT_CLICKED accepts `atom`s, prevent it
	if(!istype(clicked))
		return FALSE
	// Don't cancel admin quick spawn
	if(isobserver(clicked) && check_rights_for(clicker.client, R_SPAWN))
		return FALSE
	// Changing targets!!
	if(target)
		UnregisterSignal(target, COMSIG_QDELETING)
	target = clicked
	RegisterSignal(target, COMSIG_QDELETING, .proc/on_target_deleted)
	ui_interact(clicker)
	return COMSIG_MOB_CANCEL_CLICKON

/// Such a shame
/datum/component/interaction_menu_granter/proc/on_target_deleted(datum/source, ...)
	UnregisterSignal(target, COMSIG_QDELETING)
	target = null
	SStgui.close_user_uis(parent, src)

/datum/component/interaction_menu_granter/ui_state(mob/user)
	// Funny admin, don't you dare be the extra funny now.
	if(user.client.holder && !user.client.holder.deadmined)
		return GLOB.always_state
	if(user == parent)
		return GLOB.conscious_state
	return GLOB.never_state

/datum/component/interaction_menu_granter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MobInteraction", "Interactions")
		ui.open()

/proc/pref_to_num(pref)
	switch(pref)
		if("Yes")
			return 1
		if("Ask")
			return 2
		else
			return 0

/datum/component/interaction_menu_granter/ui_data(mob/user)
	. = ..()
	//Getting player
	var/mob/living/self = parent
	//Getting info
	.["isTargetSelf"] = target == self
	.["interactingWith"] = target != self ? "Interacting with \the [target]..." : "Interacting with yourself..."
	.["selfAttributes"] = self.list_interaction_attributes(self)
	.["lust"] = self.get_lust()
	.["maxLust"] = self.get_lust_tolerance() * 3

	.["max_distance"] = 0
	var/required_from_user = NONE
	if(self.has_mouth())
		required_from_user |= INTERACTION_REQUIRE_MOUTH
	if(self.has_hands())
		required_from_user |= INTERACTION_REQUIRE_HANDS
	if(self.is_topless())
		required_from_user |= INTERACTION_REQUIRE_TOPLESS
	if(self.is_bottomless())
		required_from_user |= INTERACTION_REQUIRE_BOTTOMLESS
	.["required_from_user"] = required_from_user

	var/required_from_user_exposed = NONE
	var/required_from_user_unexposed = NONE

	var/user_has_penis = self.has_penis()
	switch(user_has_penis)
		if(HAS_EXPOSED_GENITAL)
			required_from_user_exposed |= INTERACTION_REQUIRE_PENIS
		if(HAS_UNEXPOSED_GENITAL)
			required_from_user_unexposed |= INTERACTION_REQUIRE_PENIS
		if(1)
			required_from_user_exposed |= INTERACTION_REQUIRE_PENIS
			required_from_user_unexposed |= INTERACTION_REQUIRE_PENIS

	var/user_has_anus = self.has_anus()
	switch(user_has_anus)
		if(HAS_EXPOSED_GENITAL)
			required_from_user_exposed |= INTERACTION_REQUIRE_ANUS
		if(HAS_UNEXPOSED_GENITAL)
			required_from_user_unexposed |= INTERACTION_REQUIRE_ANUS
		if(1)
			required_from_user_exposed |= INTERACTION_REQUIRE_ANUS
			required_from_user_unexposed |= INTERACTION_REQUIRE_ANUS

	var/user_has_vagina = self.has_vagina()
	switch(user_has_vagina)
		if(HAS_EXPOSED_GENITAL)
			required_from_user_exposed |= INTERACTION_REQUIRE_VAGINA
		if(HAS_UNEXPOSED_GENITAL)
			required_from_user_unexposed |= INTERACTION_REQUIRE_VAGINA
		if(1)
			required_from_user_exposed |= INTERACTION_REQUIRE_VAGINA
			required_from_user_unexposed |= INTERACTION_REQUIRE_VAGINA

	var/user_has_breasts = self.has_breasts()
	switch(user_has_breasts)
		if(HAS_EXPOSED_GENITAL)
			required_from_user_exposed |= INTERACTION_REQUIRE_BREASTS
		if(HAS_UNEXPOSED_GENITAL)
			required_from_user_unexposed |= INTERACTION_REQUIRE_BREASTS
		if(1)
			required_from_user_exposed |= INTERACTION_REQUIRE_BREASTS
			required_from_user_unexposed |= INTERACTION_REQUIRE_BREASTS

	var/user_has_feet = self.has_feet()
	switch(user_has_feet)
		if(HAS_EXPOSED_GENITAL)
			required_from_user_exposed |= INTERACTION_REQUIRE_FEET
		if(HAS_UNEXPOSED_GENITAL)
			required_from_user_unexposed |= INTERACTION_REQUIRE_FEET
		if(1)
			required_from_user_exposed |= INTERACTION_REQUIRE_FEET
			required_from_user_unexposed |= INTERACTION_REQUIRE_FEET

	var/user_has_balls = self.has_balls()
	switch(user_has_balls)
		if(HAS_EXPOSED_GENITAL)
			required_from_user_exposed |= INTERACTION_REQUIRE_BALLS
		if(HAS_UNEXPOSED_GENITAL)
			required_from_user_unexposed |= INTERACTION_REQUIRE_BALLS
		if(1)
			required_from_user_exposed |= INTERACTION_REQUIRE_BALLS
			required_from_user_unexposed |= INTERACTION_REQUIRE_BALLS

	var/user_has_ears = self.has_ears()
	switch(user_has_ears)
		if(HAS_EXPOSED_GENITAL)
			required_from_user_exposed |= INTERACTION_REQUIRE_EARS
		if(HAS_UNEXPOSED_GENITAL)
			required_from_user_unexposed |= INTERACTION_REQUIRE_EARS
		if(FALSE)
			required_from_user_exposed |= INTERACTION_REQUIRE_EARSOCKETS

	var/user_has_eyes = self.has_eyes()
	switch(user_has_eyes)
		if(HAS_EXPOSED_GENITAL)
			required_from_user_exposed |= INTERACTION_REQUIRE_EYES
		if(HAS_UNEXPOSED_GENITAL)
			required_from_user_unexposed |= INTERACTION_REQUIRE_EYES
		if(FALSE)
			required_from_user_exposed |= INTERACTION_REQUIRE_EYESOCKETS

	.["required_from_user_exposed"] = required_from_user_exposed
	.["required_from_user_unexposed"] = required_from_user_unexposed
	.["user_num_feet"] = self.get_num_feet()

	// Let's clear it in case the user goes directly from interacting with someone to themself
	.["theirAttributes"] = null
	.["target_has_active_player"] = null
	.["max_distance"] = null
	.["required_from_target"] = null
	.["required_from_target_exposed"] = null
	.["required_from_target_unexposed"] = null
	.["target_num_feet"] = null
	.["theirPrefs"] = null
	.["theirLust"] = null
	.["theyAllowLewd"] = null
	.["theyAllowExtreme"] = null
	if(target != self)
		.["theirAttributes"] = target.list_interaction_attributes(self)

		// Always TRUE if has key, 2 if cliented, FALSE if nobody owns it
		.["target_has_active_player"] = target.ckey ? (target.client ? 2 : TRUE) : FALSE
		.["max_distance"] = get_dist(self, target)
		var/required_from_target = NONE
		if(target.has_mouth())
			required_from_target |= INTERACTION_REQUIRE_MOUTH
		if(target.has_hands())
			required_from_target |= INTERACTION_REQUIRE_HANDS
		if(target.is_topless())
			required_from_target |= INTERACTION_REQUIRE_TOPLESS
		if(target.is_bottomless())
			required_from_target |= INTERACTION_REQUIRE_BOTTOMLESS
		.["required_from_target"] = required_from_target

		var/required_from_target_exposed = NONE
		var/required_from_target_unexposed = NONE

		var/target_has_penis = target.has_penis()
		switch(target_has_penis)
			if(HAS_EXPOSED_GENITAL)
				required_from_target_exposed |= INTERACTION_REQUIRE_PENIS
			if(HAS_UNEXPOSED_GENITAL)
				required_from_target_unexposed |= INTERACTION_REQUIRE_PENIS
			if(1)
				required_from_target_exposed |= INTERACTION_REQUIRE_PENIS
				required_from_target_unexposed |= INTERACTION_REQUIRE_PENIS

		var/target_has_anus = target.has_anus()
		switch(target_has_anus)
			if(HAS_EXPOSED_GENITAL)
				required_from_target_exposed |= INTERACTION_REQUIRE_ANUS
			if(HAS_UNEXPOSED_GENITAL)
				required_from_target_unexposed |= INTERACTION_REQUIRE_ANUS
			if(1)
				required_from_target_exposed |= INTERACTION_REQUIRE_ANUS
				required_from_target_unexposed |= INTERACTION_REQUIRE_ANUS

		var/target_has_vagina = target.has_vagina()
		switch(target_has_vagina)
			if(HAS_EXPOSED_GENITAL)
				required_from_target_exposed |= INTERACTION_REQUIRE_VAGINA
			if(HAS_UNEXPOSED_GENITAL)
				required_from_target_unexposed |= INTERACTION_REQUIRE_VAGINA
			if(1)
				required_from_target_exposed |= INTERACTION_REQUIRE_VAGINA
				required_from_target_unexposed |= INTERACTION_REQUIRE_VAGINA

		var/target_has_breasts = target.has_breasts()
		switch(target_has_breasts)
			if(HAS_EXPOSED_GENITAL)
				required_from_target_exposed |= INTERACTION_REQUIRE_BREASTS
			if(HAS_UNEXPOSED_GENITAL)
				required_from_target_unexposed |= INTERACTION_REQUIRE_BREASTS
			if(1)
				required_from_target_exposed |= INTERACTION_REQUIRE_BREASTS
				required_from_target_unexposed |= INTERACTION_REQUIRE_BREASTS

		var/target_has_feet = target.has_feet()
		switch(target_has_feet)
			if(HAS_EXPOSED_GENITAL)
				required_from_target_exposed |= INTERACTION_REQUIRE_FEET
			if(HAS_UNEXPOSED_GENITAL)
				required_from_target_unexposed |= INTERACTION_REQUIRE_FEET
			if(1)
				required_from_target_exposed |= INTERACTION_REQUIRE_FEET
				required_from_target_unexposed |= INTERACTION_REQUIRE_FEET

		var/target_has_balls = target.has_balls()
		switch(target_has_balls)
			if(HAS_EXPOSED_GENITAL)
				required_from_target_exposed |= INTERACTION_REQUIRE_BALLS
			if(HAS_UNEXPOSED_GENITAL)
				required_from_target_unexposed |= INTERACTION_REQUIRE_BALLS
			if(1)
				required_from_target_exposed |= INTERACTION_REQUIRE_BALLS
				required_from_target_unexposed |= INTERACTION_REQUIRE_BALLS

		var/target_has_eyes = target.has_eyes()
		switch(target_has_eyes)
			if(HAS_EXPOSED_GENITAL)
				required_from_target_exposed |= INTERACTION_REQUIRE_EYES
			if(HAS_UNEXPOSED_GENITAL)
				required_from_target_unexposed |= INTERACTION_REQUIRE_EYES
			if(FALSE)
				required_from_target_exposed |= INTERACTION_REQUIRE_EYESOCKETS

		var/target_has_ears = target.has_ears()
		switch(target_has_ears)
			if(HAS_EXPOSED_GENITAL)
				required_from_target_exposed |= INTERACTION_REQUIRE_EARS
			if(HAS_UNEXPOSED_GENITAL)
				required_from_target_unexposed |= INTERACTION_REQUIRE_EARS
			if(FALSE)
				required_from_target_exposed |= INTERACTION_REQUIRE_EARSOCKETS

		.["required_from_target_exposed"] = required_from_target_exposed
		.["required_from_target_unexposed"] = required_from_target_unexposed
		.["target_num_feet"] = target.get_num_feet()
		/*
		if(target?.client?.prefs)
			.["theyAllowLewd"] = !!(target.client.prefs.toggles & VERB_CONSENT)
			.["theyAllowExtreme"] = !!pref_to_num(target.client.prefs.extremepref)
		if(HAS_TRAIT(user, TRAIT_ESTROUS_DETECT))
			.["theirLust"] = target.get_lust()
			.["theirMaxLust"] = target.get_lust_tolerance() * 3
			*/
/*
	//Get their genitals
	var/list/genitals = list()
	var/mob/living/carbon/get_genitals = self
	if(istype(get_genitals))
		for(var/obj/item/organ/external/genital/genital in get_genitals.internal_organs)	//Only get the genitals
			if(CHECK_BITFIELD(genital.genital_flags, GENITAL_INTERNAL))			//Not those though
				continue
			var/list/genital_entry = list()
			genital_entry["name"] = "[capitalize(genital.name)]" //Prevents code from adding a prefix
			genital_entry["key"] = REF(genital) //The key is the reference to the object
			var/visibility = "Invalid"
			if(CHECK_BITFIELD(genital.genital_flags, GENITAL_THROUGH_CLOTHES))
				visibility = "Always visible"
			else if(CHECK_BITFIELD(genital.genital_flags, GENITAL_UNDIES_HIDDEN))
				visibility = "Hidden by underwear"
			else if(CHECK_BITFIELD(genital.genital_flags, GENITAL_HIDDEN))
				visibility = "Always hidden"
			else
				visibility = "Hidden by clothes"
			genital_entry["visibility"] = visibility
			genital_entry["possible_choices"] = GLOB.genitals_visibility_toggles
			genital_entry["can_arouse"] = (
				!!CHECK_BITFIELD(genital.genital_flags, GENITAL_CAN_AROUSE) \
				&& !(HAS_TRAIT(get_genitals, TRAIT_PERMABONER) \
				|| HAS_TRAIT(get_genitals, TRAIT_NEVERBONER)))
			genital_entry["arousal_state"] = genital.aroused_state
			genital_entry["always_accessible"] = genital.always_accessible
			genitals += list(genital_entry)

		var/simulated_ass = list()
		simulated_ass["name"] = "Anus"
		simulated_ass["key"] = "anus"
		var/visibility = "Invalid"
		switch(get_genitals.anus_exposed)
			if(1)
				visibility = "Always visible"
			if(0)
				visibility = "Hidden by underwear"
			else
				visibility = "Always hidden"
		simulated_ass["visibility"] = visibility
		//simulated_ass["possible_choices"] = GLOB.genitals_visibility_toggles - GEN_VISIBLE_NO_CLOTHES
		simulated_ass["always_accessible"] = get_genitals.anus_always_accessible
		genitals += list(simulated_ass)
	.["genitals"] = genitals
*/

	var/datum/preferences/prefs = self?.client.prefs
	if(prefs)

	//Getting char prefs
		// .["erp_pref"] = 			pref_to_num(prefs.erppref)
		// .["noncon_pref"] = 			pref_to_num(prefs.nonconpref)
		.["vore_pref"] = 	pref_to_num(prefs.read_preference(/datum/preference/toggle/erp/vore_enable))
		.["extreme_pref"] = pref_to_num(prefs.read_preference(/datum/preference/choiced/erp_status_extmharm))
		.["extreme_harm"] = pref_to_num(prefs.read_preference(/datum/preference/choiced/erp_status_extm))

	//Getting preferences
		.["verb_consent"] = 		pref_to_num(prefs.read_preference(/datum/preference/toggle/erp))
		.["lewd_verb_sounds"] = 	pref_to_num(prefs.read_preference(/datum/preference/toggle/erp_status_extm))
		// .["arousable"] = 			prefs.arousable
		// .["genital_examine"] = 		!!CHECK_BITFIELD(prefs.cit_toggles, GENITAL_EXAMINE)
		// .["vore_examine"] = 		!!CHECK_BITFIELD(prefs.cit_toggles, VORE_EXAMINE)
		// .["medihound_sleeper"] =	!!CHECK_BITFIELD(prefs.cit_toggles, MEDIHOUND_SLEEPER)
		// .["eating_noises"] = 		!!CHECK_BITFIELD(prefs.cit_toggles, EATING_NOISES)
		// .["digestion_noises"] =		!!CHECK_BITFIELD(prefs.cit_toggles, DIGESTION_NOISES)
		// .["trash_forcefeed"] = 		!!CHECK_BITFIELD(prefs.cit_toggles, TRASH_FORCEFEED)
		// .["forced_fem"] = 			!!CHECK_BITFIELD(prefs.cit_toggles, FORCED_FEM)
		// .["forced_masc"] = 			!!CHECK_BITFIELD(prefs.cit_toggles, FORCED_MASC)
		// .["hypno"] = 				!!CHECK_BITFIELD(prefs.cit_toggles, HYPNO)
		// .["bimbofication"] = 		!!CHECK_BITFIELD(prefs.cit_toggles, BIMBOFICATION)
		// .["breast_enlargement"] = 	!!CHECK_BITFIELD(prefs.cit_toggles, BREAST_ENLARGEMENT)
		// .["penis_enlargement"] =	!!CHECK_BITFIELD(prefs.cit_toggles, PENIS_ENLARGEMENT)
		// .["butt_enlargement"] =		!!CHECK_BITFIELD(prefs.cit_toggles, BUTT_ENLARGEMENT)
		// .["never_hypno"] = 			!CHECK_BITFIELD(prefs.cit_toggles, NEVER_HYPNO)
		// .["no_aphro"] = 			!CHECK_BITFIELD(prefs.cit_toggles, NO_APHRO)
		// .["no_ass_slap"] = 			!CHECK_BITFIELD(prefs.cit_toggles, NO_ASS_SLAP)
		// .["no_auto_wag"] = 			!CHECK_BITFIELD(prefs.cit_toggles, NO_AUTO_WAG)

/datum/component/interaction_menu_granter/ui_static_data(mob/user)
	. = ..()
	//Getting interactions
	var/list/sent_interactions = list()
	for(var/interaction_key in SSinteractions.interactions)
		var/datum/interaction/I = SSinteractions.interactions[interaction_key]
		// THIS IS A BASETYPE, DO NOT SEND
		if(!I.description)
			continue
		var/list/interaction = list()
		interaction["key"] = I.type
		interaction["desc"] = I.description
		if(istype(I, /datum/interaction/lewd))
			var/datum/interaction/lewd/O = I
			if(O.interaction_flags & INTERACTION_FLAG_EXTREME_CONTENT)
				interaction["type"] = INTERACTION_EXTREME
			else
				interaction["type"] = INTERACTION_LEWD
			interaction["require_user_num_feet"] = O.require_user_num_feet
			interaction["require_target_num_feet"] = O.require_target_num_feet
		else
			interaction["type"] = INTERACTION_NORMAL
		interaction["maxDistance"] = I.max_distance

		interaction["interactionFlags"] = I.interaction_flags

		interaction["required_from_user"] = I.required_from_user
		interaction["required_from_user_exposed"] = I.required_from_user_exposed
		interaction["required_from_user_unexposed"] = I.required_from_user_unexposed

		interaction["required_from_target"] = I.required_from_target
		interaction["required_from_target_exposed"] = I.required_from_target_exposed
		interaction["required_from_target_unexposed"] = I.required_from_target_unexposed
		interaction["additionalDetails"] = I.additional_details
		sent_interactions += list(interaction)
	.["interactions"] = sent_interactions

/proc/num_to_pref(num)
	switch(num)
		if(1)
			return "Yes"
		if(2)
			return "Ask"
		else
			return "No"

/datum/component/interaction_menu_granter/ui_act(action, params)
	if(..())
		return
	var/mob/living/parent_mob = parent
	switch(action)
		if("interact")
			var/datum/interaction/o = SSinteractions.interactions[params["interaction"]]
			if(o)
				o.do_action(parent_mob, target)
				return TRUE
			return FALSE
			/*
		if("genital")
			var/mob/living/carbon/self = parent_mob
			if("visibility" in params)
				if(params["genital"] == "anus")
					self.anus_toggle_visibility(params["visibility"])
					return TRUE
				var/obj/item/organ/external/genital/genital = locate(params["genital"], self.internal_organs)
				if(genital && (genital in self.internal_organs))
					genital.toggle_visibility(params["visibility"])
					return TRUE
			if("set_arousal" in params)
				var/obj/item/organ/external/genital/genital = locate(params["genital"], self.internal_organs)
				if(!genital || (genital \
					&& (!CHECK_BITFIELD(genital.genital_flags, GENITAL_CAN_AROUSE) \
					|| HAS_TRAIT(self, TRAIT_PERMABONER) \
					|| HAS_TRAIT(self, TRAIT_NEVERBONER))))
					return FALSE
				var/original_state = genital.aroused_state
				genital.set_aroused_state(params["set_arousal"])// i'm not making it just `!aroused_state` because
				if(original_state != genital.aroused_state)		// someone just might port skyrat's new genitals
					to_chat(self, span_userlove("[genital.aroused_state ? genital.arousal_verb : genital.unarousal_verb]."))
					. = TRUE
				else
					to_chat(self, span_userlove("You can't make that genital [genital.aroused_state ? "unaroused" : "aroused"]!"))
					. = FALSE
				genital.update_appearance()
				if(ishuman(self))
					var/mob/living/carbon/human/human = self
					human.update_genitals()
				return
			if("set_accessibility" in params)
				if(params["genital"] == "anus")
					self.toggle_anus_always_accessible()
					return TRUE
				var/obj/item/organ/external/genital/genital = locate(params["genital"], self.internal_organs)
				if(!genital)
					return FALSE
				genital.toggle_accessibility()
				return TRUE
			else
				return FALSE
		if("char_pref")
			var/datum/preferences/prefs = parent_mob.client.prefs
			var/value = num_to_pref(params["value"])
			switch(params["char_pref"])
				if("erp_pref")
					if(prefs.erppref == value)
						return FALSE
					else
						prefs.erppref = value
				if("noncon_pref")
					if(prefs.nonconpref == value)
						return FALSE
					else
						prefs.nonconpref = value
				if("vore_pref")
					if(prefs.vorepref == value)
						return FALSE
					else
						prefs.vorepref = value
				if("extreme_pref")
					if(prefs.extremepref == value)
						return FALSE
					else
						prefs.extremepref = value
						if(prefs.extremepref == "No")
							prefs.extremeharm = "No"
				if("extreme_harm")
					if(prefs.extremeharm == value)
						return FALSE
					else
						prefs.extremeharm = value
				else
					return FALSE
			prefs.save_character()
			return TRUE
		if("pref")
			var/datum/preferences/prefs = parent_mob.client.prefs
			switch(params["pref"])
				if("verb_consent")
					TOGGLE_BITFIELD(prefs.toggles, VERB_CONSENT)
				if("lewd_verb_sounds")
					TOGGLE_BITFIELD(prefs.toggles, LEWD_VERB_SOUNDS)
				if("arousable")
					prefs.arousable = !prefs.arousable
				if("genital_examine")
					TOGGLE_BITFIELD(prefs.cit_toggles, GENITAL_EXAMINE)
				if("vore_examine")
					TOGGLE_BITFIELD(prefs.cit_toggles, VORE_EXAMINE)
				if("medihound_sleeper")
					TOGGLE_BITFIELD(prefs.cit_toggles, MEDIHOUND_SLEEPER)
				if("eating_noises")
					TOGGLE_BITFIELD(prefs.cit_toggles, EATING_NOISES)
				if("digestion_noises")
					TOGGLE_BITFIELD(prefs.cit_toggles, DIGESTION_NOISES)
				if("trash_forcefeed")
					TOGGLE_BITFIELD(prefs.cit_toggles, TRASH_FORCEFEED)
				if("forced_fem")
					TOGGLE_BITFIELD(prefs.cit_toggles, FORCED_FEM)
				if("forced_masc")
					TOGGLE_BITFIELD(prefs.cit_toggles, FORCED_MASC)
				if("hypno")
					TOGGLE_BITFIELD(prefs.cit_toggles, HYPNO)
				if("bimbofication")
					TOGGLE_BITFIELD(prefs.cit_toggles, BIMBOFICATION)
				if("breast_enlargement")
					TOGGLE_BITFIELD(prefs.cit_toggles, BREAST_ENLARGEMENT)
				if("penis_enlargement")
					TOGGLE_BITFIELD(prefs.cit_toggles, PENIS_ENLARGEMENT)
				if("butt_enlargement")
					TOGGLE_BITFIELD(prefs.cit_toggles, BUTT_ENLARGEMENT)
				if("never_hypno")
					TOGGLE_BITFIELD(prefs.cit_toggles, NEVER_HYPNO)
				if("no_aphro")
					TOGGLE_BITFIELD(prefs.cit_toggles, NO_APHRO)
				if("no_ass_slap")
					TOGGLE_BITFIELD(prefs.cit_toggles, NO_ASS_SLAP)
				if("no_auto_wag")
					TOGGLE_BITFIELD(prefs.cit_toggles, NO_AUTO_WAG)
				else
					return FALSE
			prefs.save_preferences()
			return TRUE
*/
#undef INTERACTION_NORMAL
#undef INTERACTION_LEWD
#undef INTERACTION_EXTREME
