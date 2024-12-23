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
	RegisterSignal(parent, COMSIG_MOB_CTRLSHIFTCLICKON, .proc/open_menu)

/datum/component/interaction_menu_granter/Destroy(force, ...)
	var/mob/parent_mob = parent
	remove_verb(parent_mob, /mob/proc/interact_with)
	target = null
	UnregisterSignal(parent_mob, COMSIG_MOB_CLICKON)
	. = ..()

/datum/component/interaction_menu_granter/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_CTRLSHIFTCLICKON)
	. = ..()
/// The one interacting is clicker, the interacted is clicked.
/datum/component/interaction_menu_granter/proc/open_menu(mob/clicker, mob/clicked)
	// Don't cancel admin quick spawn
	if(isobserver(clicked) && check_rights_for(clicker, R_SPAWN))
		return FALSE
	// COMSIG_MOB_CTRLSHIFTCLICKON accepts `atom`s, prevent it
	if(!istype(clicked))
		return FALSE
	target = clicked
	ui_interact(clicker)
	return COMSIG_MOB_CANCEL_CLICKON

/datum/component/interaction_menu_granter/ui_state(mob/user)
	// Funny admin, don't you dare be the extra funny now.
	if(user.client.holder)
		return GLOB.always_state
	if(user == parent)
		return GLOB.conscious_state
	return GLOB.never_state

/datum/component/interaction_menu_granter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MobInteraction", "Interactions")
		ui.open()

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
	if(target != self)
		.["theirAttributes"] = target.list_interaction_attributes(self)
		// Trait not exists
		/*
		if(HAS_TRAIT(user, TRAIT_ESTROUS_DETECT))
			.["theirLust"] = target.get_lust()
			.["theirMaxLust"] = target.get_lust_tolerance() * 3
		else
			.["theirLust"] = null
			.["theirMaxLust"] = null
		*/
		.["theirLust"] = null
		.["theirMaxLust"] = null

	//Getting interactions
	var/list/sent_interactions = list()
	for(var/interaction_key in SSinteractions.interactions)
		var/datum/interaction/I = SSinteractions.interactions[interaction_key]
		if(I.evaluate_user(self, action_check = FALSE) && I.evaluate_target(self, target))
			if(I.user_is_target && target != self)
				continue
			var/list/interaction = list()
			interaction["key"] = I.type
			interaction["desc"] = I.description
			if(istype(I, /datum/interaction/lewd))
				var/datum/interaction/lewd/O = I
				if(O.extreme)
					interaction["type"] = INTERACTION_EXTREME
				else
					interaction["type"] = INTERACTION_LEWD
			else
				interaction["type"] = INTERACTION_NORMAL
			sent_interactions += list(interaction)
	.["interactions"] = sent_interactions
/*
	//Get their genitals
	var/list/genitals = list()
	var/mob/living/carbon/get_genitals = self
	if(istype(get_genitals))
		for(var/obj/item/organ/genital/genital in get_genitals.internal_organs)	//Only get the genitals
			if(CHECK_BITFIELD(genital.genital_flags, GENITAL_INTERNAL))			//Not those though
				continue
			var/list/genital_entry = list()
			genital_entry["name"] = "[genital.name]" //Prevents code from adding a prefix
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
			genitals += list(genital_entry)

		var/simulated_ass = list()
		simulated_ass["name"] = "anus"
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
		simulated_ass["possible_choices"] = GLOB.genitals_visibility_toggles - GEN_VISIBLE_NO_CLOTHES
		genitals += list(simulated_ass)
	.["genitals"] = genitals

	var/datum/preferences/prefs = usr?.client.prefs
	if(prefs)
	//Getting char prefs
		.["erp_pref"] = 			pref_to_num(prefs.erppref)
		.["noncon_pref"] = 		pref_to_num(prefs.nonconpref)
		.["vore_pref"] = 		pref_to_num(prefs.vorepref)
		.["extreme_pref"] = 		pref_to_num(prefs.extremepref)
		.["extreme_harm"] = 		pref_to_num(prefs.extremeharm)

	//Getting preferences
		.["verb_consent"] = 		CHECK_BITFIELD(prefs.toggles, VERB_CONSENT)
		.["lewd_verb_sounds"] = 	!CHECK_BITFIELD(prefs.toggles, LEWD_VERB_SOUNDS)
		.["arousable"] = 			prefs.arousable
		.["genital_examine"] = 		CHECK_BITFIELD(prefs.cit_toggles, GENITAL_EXAMINE)
		.["vore_examine"] = 		CHECK_BITFIELD(prefs.cit_toggles, VORE_EXAMINE)
		.["medihound_sleeper"] =	CHECK_BITFIELD(prefs.cit_toggles, MEDIHOUND_SLEEPER)
		.["eating_noises"] = 		CHECK_BITFIELD(prefs.cit_toggles, EATING_NOISES)
		.["digestion_noises"] =		CHECK_BITFIELD(prefs.cit_toggles, DIGESTION_NOISES)
		.["trash_forcefeed"] = 		CHECK_BITFIELD(prefs.cit_toggles, TRASH_FORCEFEED)
		.["forced_fem"] = 			CHECK_BITFIELD(prefs.cit_toggles, FORCED_FEM)
		.["forced_masc"] = 			CHECK_BITFIELD(prefs.cit_toggles, FORCED_MASC)
		.["hypno"] = 				CHECK_BITFIELD(prefs.cit_toggles, HYPNO)
		.["bimbofication"] = 		CHECK_BITFIELD(prefs.cit_toggles, BIMBOFICATION)
		.["breast_enlargement"] = 	CHECK_BITFIELD(prefs.cit_toggles, BREAST_ENLARGEMENT)
		.["penis_enlargement"] =	CHECK_BITFIELD(prefs.cit_toggles, PENIS_ENLARGEMENT)
		.["butt_enlargement"] =		CHECK_BITFIELD(prefs.cit_toggles, BUTT_ENLARGEMENT)
		.["never_hypno"] = 			!CHECK_BITFIELD(prefs.cit_toggles, NEVER_HYPNO)
		.["no_aphro"] = 			!CHECK_BITFIELD(prefs.cit_toggles, NO_APHRO)
		.["no_ass_slap"] = 			!CHECK_BITFIELD(prefs.cit_toggles, NO_ASS_SLAP)
		.["no_auto_wag"] = 			!CHECK_BITFIELD(prefs.cit_toggles, NO_AUTO_WAG)
*/
// TODO
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

#undef INTERACTION_NORMAL
#undef INTERACTION_LEWD
#undef INTERACTION_EXTREME
