
/datum/interaction/lewd // Additional variables to be used by interactions that can knot
	// Can this interaction knot?
	var/knotting_supported = FALSE
	// Should this interaction knot on every thrust?
	var/knotfucking = FALSE
	// borgs that can knot
	var/list/knotty_borgs = list( // ADD EVERY BORG MODEL THAT SHOULD HAVE A KNOTTED PENIS
			"k69", "k50", "borgi-serv", "valeserv", "valeservdark",
			"valemine", "cargohound", "cargohounddark", "otiec",
			"borgi-eng", "otiee", "pupdozer", "valeeng", "engihound", "engihounddark",
			"borgi-jani", "scrubpup", "J9", "otiej",
			"borgi-medi", "medihound", "medihounddark", "valemed",
			"borgi", "valepeace", "borgi-sec", "k9", "k9dark", "oties", "valesec",
			"borgi-cargo", "valecargo"
			)
	// these are because some interactions don't specify a cum_target for the person with a penis
	// Additional parts user requires for knotting
	var/list/user_knotting_require = list() // Very limited usage, if user fucks target's penis with their eye for example
	// Additional parts target requires for knotting
	var/list/target_knotting_require = list() // More common, if user fucks target's eye
	// And a variable for the custom_slot to knot, usually the same as user or target knotting_require
	var/custom_slot = null

/mob/living // Additional variables for tracking knots
	// ORGAN_SLOT - mob/living pairs, stores the partner occupying our organ slot
	var/list/knotted_parts = list(
		ORGAN_SLOT_PENIS = null,
		ORGAN_SLOT_ANUS = null,
		ORGAN_SLOT_VAGINA = null,
		"mouth" = null, // ORGAN_SLOT_MOUTH dosen't exist, and might break things if it did
		ORGAN_SLOT_SLIT = null, // Currently unused
		ORGAN_SLOT_EARS = null, // used via custom_slot
		ORGAN_SLOT_EYES = null, // used via custom_slot
		ORGAN_SLOT_NIPPLES = null // used via custom_slot
	)
	// Boolean for checking if we are knotted at all, faster than checking the list
	var/knotted_status = FALSE

/// Returns how many times we are knotted
/datum/interaction/lewd/proc/knotted_orifices(mob/living/target)
	var/count = 0
	for(var/part in target.knotted_parts)
		if(part == ORGAN_SLOT_PENIS)
			continue
		if(target.knotted_parts[part])
			count++
	return count

/// Checks if the user has a penis with a knot
/datum/interaction/lewd/proc/knot_penis_type(mob/living/user)
	if(!user.has_penis(REQUIRE_GENITAL_ANY))
		return FALSE
	if(iscarbon(user))
		var/obj/item/organ/genital/penis/penis = user.get_organ_slot(ORGAN_SLOT_PENIS)
		if(penis.knotted)
			return TRUE
		return FALSE
	// Cyborgs still don't have an easy way to check for a knot so we have to list every SKIN_ICON_STATE we want to have a knot...
	if(iscyborg(user))
		var/mob/living/silicon/robot/borg = user
		if(borg.icon_state in knotty_borgs)
			return TRUE
		return FALSE
	// Need a way to see if a non-carbon/non-cyborg mob's penis has a knot
	// For now, the only non-carbon/non-cyborg mobs with a penis are funclaws and werewolves so return true for just werewolves
	if(istype(user, /mob/living/basic/werewolf))
		return TRUE
	return FALSE

/// Seperate knot_check_remove if two users are supposed to stay knotted
/datum/interaction/lewd/proc/knotfucking_check_remove(mob/living/user, mob/living/target)
	// check if the knot is blocking these actions, and thus requires removal
	// combine the requirements lists...
	var/list/user_combined_required_parts = list()
	var/list/target_combined_required_parts = list()
	if(interaction_requires.len)
		for(var/requirement in interaction_requires)
			switch(requirement)
				if(INTERACTION_REQUIRE_SELF_MOUTH)
					user_combined_required_parts.Add("mouth")
				if(INTERACTION_REQUIRE_TARGET_MOUTH)
					target_combined_required_parts.Add("mouth")
	if(user_required_parts.len)
		for(var/part in user_required_parts)
			user_combined_required_parts.Add(part)
	if(target_required_parts.len)
		for(var/part in target_required_parts)
			target_combined_required_parts.Add(part)
	if(user_knotting_require.len)
		for(var/part in user_knotting_require)
			user_combined_required_parts.Add(part)
	if(target_knotting_require.len)
		for(var/part in target_knotting_require)
			target_combined_required_parts.Add(part)
	// check blocked by a third party
	if(user_combined_required_parts.len)
		for(var/part in user_combined_required_parts)
			if(user.knotted_parts[part] && user.knotted_parts[part] != target)
				knot_exit(user, slot = part)
	if(target_combined_required_parts.len)
		for(var/part in target_combined_required_parts)
			if(target.knotted_parts[part] && target.knotted_parts[part] != user)
				knot_exit(target, slot = part)
	// remove each other from parts not required by this interaction (so a user can't knot the same target multiple times)
	for(var/part in user.knotted_parts)
		if(user.knotted_parts[part] == target)
			if(!(part in user_combined_required_parts))
				knot_exit(user, target)
	for(var/part in target.knotted_parts)
		if(target.knotted_parts[part] == user)
			if(!(part in target_combined_required_parts))
				knot_exit(user, target)

/// Removes the knot if it is required by a new interaction
/datum/interaction/lewd/proc/knot_check_remove(mob/living/user, mob/living/target, knotfucking)
	if(!isliving(user) || !isliving(target))
		return // bail if either of us aren't living
	if(!user.knotted_status && !target.knotted_status)
		return // bail if neither of us are knotted
	if(knotfucking)
		knotfucking_check_remove(user, target)
		return // bitch and a half... the other function was fine, this just did random shit because I forgot to return

	// check if the knot is blocking these actions, and thus requires removal
	// combine the requirements lists...
	var/list/user_combined_required_parts = list()
	var/list/target_combined_required_parts = list()
	if(interaction_requires.len)
		for(var/requirement in interaction_requires)
			switch(requirement)
				if(INTERACTION_REQUIRE_SELF_MOUTH)
					user_combined_required_parts.Add("mouth")
				if(INTERACTION_REQUIRE_TARGET_MOUTH)
					target_combined_required_parts.Add("mouth")
	if(user_required_parts.len)
		for(var/part in user_required_parts)
			user_combined_required_parts.Add(part)
	if(target_required_parts.len)
		for(var/part in target_required_parts)
			target_combined_required_parts.Add(part)
	if(user_knotting_require.len)
		for(var/part in user_knotting_require)
			user_combined_required_parts.Add(part)
	if(target_knotting_require.len)
		for(var/part in target_knotting_require)
			target_combined_required_parts.Add(part)
	// check blocked
	if(user_combined_required_parts.len)
		for(var/part in user_combined_required_parts)
			if(user.knotted_parts[part])
				knot_exit(user, slot = part)
	if(target_combined_required_parts.len)
		for(var/part in target_combined_required_parts)
			if(target.knotted_parts[part])
				knot_exit(target, slot = part)

/// Attempts to knot the user and target. custom_slot is used as a backup if cum_target[CLIMAX_POSITION_USER] is undefined
/datum/interaction/lewd/proc/knot_try(mob/living/user, mob/living/target, position, knotfucking)
	if(!knotting_supported) // the current interaction does not support knot climaxing, abort
		return
	if(user == target)
		log_game("Interaction [src] tried to make [user] knot themselves")
		message_admins("Interaction [src] tried to make [user] knot themselves")
		return
	if(!knot_penis_type(user)) // don't have that dog in 'em
		return
	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp/knotting) && !(!ishuman(user) && !user.client && !SSinteractions.is_blacklisted(user)))
		return
	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp/knots_partners) && !(!ishuman(user) && !user.client && !SSinteractions.is_blacklisted(user)))
		return
	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/knotting)  && !(!ishuman(target) && !target.client && !SSinteractions.is_blacklisted(target)))
		return

	// match up the cum_target
	var/target_slot
	switch(cum_target[position])
		if(ORGAN_SLOT_VAGINA) target_slot = ORGAN_SLOT_VAGINA
		if(ORGAN_SLOT_ANUS) target_slot = ORGAN_SLOT_ANUS
		if(CLIMAX_TARGET_MOUTH) target_slot = "mouth"
		if(CLIMAX_TARGET_SHEATH) target_slot = ORGAN_SLOT_SLIT

	if(!target_slot && custom_slot)
		if(custom_slot in target.knotted_parts)
			target_slot = custom_slot

	// bail if we don't know what slot to use
	if(!target_slot)
		log_game("Interaction '[src]' called knot_try but target_slot could not be set. Data: cum_target = [cum_target], position = [position], custom_slot = [custom_slot]")
		message_admins("Interaction '[src]' called knot_try but target_slot could not be set (missing or bad data, check game.log)")
		return

	if(knotfucking)
		if(target.knotted_parts[target_slot] == user) // Our 'slot' is already occupied by user, we don't need to do anything else
			return

	var/knot = "knot"
	var/tie = "tie"
	if(iscarbon(user)) // get text overrides, mostly for a horse cock's flare
		var/obj/item/organ/genital/penis/penis = user.get_organ_slot(ORGAN_SLOT_PENIS)
		knot = penis.override_string_knot
		tie = penis.override_string_tie

	/* Renable tops being bottoms too now that we only allow one partner to be pulled again, solving the circular dependency
	if(knotted_orifices(user) > 0) // Bottoms can't be tops silly
		user.visible_message(span_notice("[user] fails to [tie] their [knot] in [target] while already knotted!"), span_notice("I fail to [tie] my [knot] in [target] while already knotted"))
		return

	if(target.knotted_parts[ORGAN_SLOT_PENIS]) // You're a bottom now
		var/mob/living/target_partner = target.knotted_parts[ORGAN_SLOT_PENIS]
		knot_remove(target, target_partner)
		target.visible_message(span_lewd("[target]'s [knot] slips out of [target_partner] as they are knotted by [user]!"), span_lewd("My [knot] slips out from [target_partner] as I'm knotted by [user]."))
	*/

	if(target.knotted_status) // Only check if we are knotted
		if(knotted_orifices(target) > 0) // Only if we are a bottom
			if(!target.has_status_effect(/datum/status_effect/knot_fucked_stupid)) // if the target is getting double teamed,
				target.apply_status_effect(/datum/status_effect/knot_fucked_stupid) // give them the fucked stupid status

	// Knot user and target
	user.knotted_status = TRUE
	user.knotted_parts[ORGAN_SLOT_PENIS] = target
	target.knotted_status = TRUE
	target.knotted_parts[target_slot] = user
	log_combat(user, target, "Started knot tugging")

	if(user.combat_mode || user.combat_mode == INTENT_GRAB) // if more than playful
		if(user.combat_mode) // damage if harmful
			if(user.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No" || target.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")
				var/damage = user == target.knotted_parts["mouth"] ? 6 : 18 // base damage value
				var/body_zone = user == target.knotted_parts["mouth"] ? BODY_ZONE_HEAD : BODY_ZONE_CHEST
				var/obj/item/bodypart/affecting = target.get_bodypart(body_zone)
				if(affecting && affecting.brute_dam < 90-damage) // cap damage applied, can still kill if you hatefuck their mouth and any other orifice
					target.apply_damage(damage, BRUTE, body_zone)
				target.adjust_pain(10, user, src, position)
			else
				target.adjust_pain(4, user, src, position) // if harm pref fails still apply some pain
		else
			target.adjust_pain(4, user, src, position)
		target.Stun(80) // stun for dramatic effect
	user.visible_message(span_lewd("[user] [tie]s their [knot] inside of [target]!"), span_lewd("I [tie] my [knot] inside of [target]."))

	if(target.stat != DEAD)
		switch(knotted_orifices(target))
			if(1)
				to_chat(target, span_userdanger("You have been knotted!"))
			if(2)
				to_chat(target, span_userdanger("You have been double-knotted!"))
			if(3)
				to_chat(target, span_userdanger("You have been triple-knotted!"))
			if(4)
				to_chat(target, span_userdanger("You have been quad-knotted!"))
			if(5 to 9)
				to_chat(target, span_userdanger("Knotting Spree!"))
			else
				to_chat(target, span_userdanger("Knotting Frenzy!"))

	if(!target.has_status_effect(/datum/status_effect/knotted)) // only apply status if we don't have it already
		target.apply_status_effect(/datum/status_effect/knotted)
	if(!user.has_status_effect(/datum/status_effect/knotted)) // only apply status if we don't have it already
		user.apply_status_effect(/datum/status_effect/knotted)
	target.remove_status_effect(/datum/status_effect/knot_gaped) // Can't be gaped while knotted?
	RegisterSignal(user, COMSIG_MOVABLE_ATTEMPTED_MOVE, PROC_REF(knot_movement), TRUE)
	RegisterSignal(target, COMSIG_MOVABLE_ATTEMPTED_MOVE, PROC_REF(knot_movement), TRUE)
	RegisterSignal(user, COMSIG_LIVING_DISARM_HIT, PROC_REF(knotted_shoved), TRUE)
	RegisterSignal(target, COMSIG_LIVING_DISARM_HIT, PROC_REF(knotted_shoved), TRUE)
	RegisterSignal(user, COMSIG_MOVABLE_PRE_THROW, PROC_REF(knotted_thrown), TRUE)
	RegisterSignal(target, COMSIG_MOVABLE_PRE_THROW, PROC_REF(knotted_thrown), TRUE)

/// Main proc for leashing caracters together by the knot, calls the appropriate proc based on who moved
/datum/interaction/lewd/proc/knot_movement(atom/movable/mover, atom/newloc, direction)
	SIGNAL_HANDLER
	if(QDELETED(mover))
		return
	if(!isliving(mover)) // this should never hit, but if it does remove callback
		UnregisterSignal(mover, COMSIG_MOVABLE_ATTEMPTED_MOVE)
		return
	var/mob/living/user = mover
	if(user.knotted_status == FALSE) // this should never hit, but if it does remove callback
		UnregisterSignal(user, COMSIG_MOVABLE_ATTEMPTED_MOVE)
		return
	var/found_first_partner = FALSE
	var/partner_pulling = FALSE
	var/list/partners_to_remove = list()
	for(var/part in user.knotted_parts) // These first two loops feel dirty and slow but we can't use `in` with list associations
		if(user.moving_from_pull && (user.moving_from_pull == user.knotted_parts[part])) // we are being pulled by a partner, don't pull another partner
			knot_pulling(user, user.moving_from_pull)
			found_first_partner = TRUE
			partner_pulling = TRUE
	if(!partner_pulling) // at least we can skip this one if the first loop finds a partner
		for(var/part in user.knotted_parts)
			if(user.pulling && (user.pulling == user.knotted_parts[part])) // Allow the player to choose the knot to maintain if they can
				found_first_partner = TRUE
	for(var/part in user.knotted_parts)
		if(user.knotted_parts[part])
			if(user.moving_from_pull && (user.moving_from_pull == user.knotted_parts[part]))
				continue // This partner is pulling us, skip them
			if(!partner_pulling && user.pulling && (user.pulling == user.knotted_parts[part]))
				continue // We are pulling this partner and are not being pulled by a partner, skip them
			if(found_first_partner) // Untie partners byond the first to prevent abuse, blocking, and strangeness
				partners_to_remove.Add(user.knotted_parts[part])
				continue
			if(user.pulling != user.knotted_parts[part]) // If we aren't already pulling them
				if(knot_pulling(user, user.knotted_parts[part]))
					found_first_partner = TRUE
					if(part == ORGAN_SLOT_PENIS) // handle additional pleasure, ect, caused by the movement
						addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/interaction/lewd, knot_movement_top), user, user.knotted_parts[part]), 1) // if we are the top
					else
						addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/interaction/lewd, knot_movement_btm), user.knotted_parts[part], user), 1) // if we are the bottom
	if(partners_to_remove.len)
		to_chat(user, span_alert("The force of moving with multiple ties is too much, you feel some of your partner's knots come out."))
		for(var/mob/living/partner in partners_to_remove)
			var/knot = "knot"
			if(partner == user.knotted_parts[ORGAN_SLOT_PENIS])
				if(iscarbon(user)) // get text overrides, mostly for a horse cock's flare
					var/obj/item/organ/genital/penis/penis = partner.get_organ_slot(ORGAN_SLOT_PENIS)
					knot = penis
				to_chat(partner, span_alert("[user]'s [knot] comes out of you while they are already pulling someone"))
				knot_exit_strict(user, partner)
			else
				if(iscarbon(partner)) // get text overrides, mostly for a horse cock's flare
					var/obj/item/organ/genital/penis/penis = partner.get_organ_slot(ORGAN_SLOT_PENIS)
					knot = penis.override_string_knot
				to_chat(partner, span_alert("Your [knot] comes out of [user] while they are already pulling someone"))
				knot_exit_strict(partner, user)

// almost identical to /mob/living/start_pulling(atom/movable/AM, state, force = pull_force, supress_message = FALSE)
/// Snowflake pulling that dosen't call the grippedby, grabbedby and whatever other nonsense that wasn't safe to use in a signal
/datum/interaction/lewd/proc/knot_pulling(mob/living/user, atom/movable/target)
	if(!target || !user)
		return FALSE
	if(!(target.can_be_pulled(user, user.pull_force)))
		return FALSE
	if(user.throwing || !(user.mobility_flags & MOBILITY_PULL))
		return FALSE
	if(SEND_SIGNAL(user, COMSIG_LIVING_TRY_PULL, target, user.pull_force) & COMSIG_LIVING_CANCEL_PULL)
		return FALSE
	if(SEND_SIGNAL(target, COMSIG_LIVING_TRYING_TO_PULL, user, user.pull_force) & COMSIG_LIVING_CANCEL_PULL)
		return FALSE

	target.add_fingerprint(user)

	// If we're pulling something then drop what we're currently pulling and pull this instead.
	if(user.pulling)
		// Are we trying to pull something we are already pulling? Then just stop here, no need to continue.
		if(target == user.pulling)
			return FALSE
		user.stop_pulling()

	user.changeNext_move(CLICK_CD_GRABBING)

	if(target.pulledby)
		log_combat(target, target.pulledby, "pulled from", user)
		target.pulledby.stop_pulling() //an object can't be pulled by two mobs at once.

	user.pulling = target
	target.set_pulledby(user)

	SEND_SIGNAL(user, COMSIG_LIVING_START_PULL, target, GRAB_PASSIVE, user.pull_force)

	user.update_pull_hud_icon()

	if(ismob(target))
		var/mob/M = target

		log_combat(user, M, "grabbed", addition="knotting snowflake")

		if(isliving(M))
			var/mob/living/L = M

			SEND_SIGNAL(M, COMSIG_LIVING_GET_PULLED, user)
			//Share diseases that are spread by touch
			for(var/thing in user.diseases)
				var/datum/disease/D = thing
				if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
					L.ContactContractDisease(D)

			for(var/thing in L.diseases)
				var/datum/disease/D = thing
				if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
					user.ContactContractDisease(D)

			user.update_pull_movespeed()

		user.set_pull_offsets(M, GRAB_PASSIVE)
		return TRUE

/// Handles aditional pleasure, ect, caused by the top moving
/datum/interaction/lewd/proc/knot_movement_top(mob/living/top, mob/living/btm)
	if(!isliving(btm) || QDELETED(btm) || !isliving(top) || QDELETED(top))
		knot_exit(top, btm)
		return
	if(!top.client?.prefs?.read_preference(/datum/preference/toggle/erp/knotting) && !(!ishuman(top) && !top.client && !SSinteractions.is_blacklisted(top)))
		knot_exit(top, btm)
		return
	if(!btm.client?.prefs?.read_preference(/datum/preference/toggle/erp/knotting)  && !(!ishuman(btm) && !btm.client && !SSinteractions.is_blacklisted(btm)))
		knot_exit(top, btm)
		return
	if(top in btm.buckled_mobs)
		return
	if(get_dist(top, btm) > 1)
		knot_remove(top, btm, notify = FALSE)
		return

	// Figure out who is where in the interaction because we couldn't pass it through signals
	var/top_position
	var/btm_position
	if(cum_genital[CLIMAX_POSITION_USER] == CLIMAX_PENIS)
		top_position = CLIMAX_POSITION_USER
		btm_position = CLIMAX_POSITION_TARGET
	else if(cum_genital[CLIMAX_POSITION_TARGET] == CLIMAX_PENIS)
		top_position = CLIMAX_POSITION_TARGET
		btm_position = CLIMAX_POSITION_USER

	var/knot = "knot"
	if(iscarbon(top)) // get text overrides, mostly for a horse cock's flare
		var/obj/item/organ/genital/penis/penis = top.get_organ_slot(ORGAN_SLOT_PENIS)
		knot = penis.override_string_knot

	if(btm in top.buckled_mobs) // if the two characters are being held in a fireman carry, let them mutually get pleasure from it
		if(top.move_intent == MOVE_INTENT_WALK && prob(15))
			// values here were stolen from fleshlight.dm and not chosen with any kind of thought
			top.adjust_arousal(6)
			top.adjust_pleasure(9, btm, src, top_position) // Nice
			btm.adjust_arousal(6)
			btm.adjust_pleasure(9, top, src, btm_position) // Double Nice
			if(prob(50))
				to_chat(top, span_love("I feel [btm] tightening over my [knot]."))
				to_chat(btm, span_love("I feel [top] rubbing inside."))
		else if(top.move_intent == MOVE_INTENT_RUN && prob(5))
			top.adjust_arousal(3)
			top.adjust_pleasure(5, btm, src, top_position)
			top.adjust_pain(3, btm, src, top_position)
			btm.adjust_arousal(3)
			btm.adjust_pleasure(5, top, src, btm_position)
			btm.adjust_pain(3, top, src, btm_position)
			to_chat(top, span_alert("[btm] is being thrown around tugging on my [knot] as I run!"))
			to_chat(btm, span_alert("I'm being thrown around as [top] runs!"))
		return

	if(prob(5))
		if(top == btm.knotted_parts["mouth"] && btm.get_oxy_loss() < 80) // if the current top knotted them orally
			if(btm.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")
				to_chat(btm, span_warning("I struggle to breath with [top]'s [knot] in my mouth!"))
				btm.adjust_oxy_loss(2)

/// Handles aditional pleasure, ect, caused by the btm moving
/datum/interaction/lewd/proc/knot_movement_btm(mob/living/top, mob/living/btm)
	if(!isliving(btm) || QDELETED(btm) || !isliving(top) || QDELETED(top))
		knot_exit(top, btm)
		return
	if(!top.client?.prefs?.read_preference(/datum/preference/toggle/erp/knotting) && !(!ishuman(top) && !top.client && !SSinteractions.is_blacklisted(top)))
		knot_exit(top, btm)
		return
	if(!btm.client?.prefs?.read_preference(/datum/preference/toggle/erp/knotting)  && !(!ishuman(btm) && !btm.client && !SSinteractions.is_blacklisted(btm)))
		knot_exit(top, btm)
		return
	if(top.stat >= SOFT_CRIT) // only removed if the knot owner is injured/asleep/dead
		knot_remove(top, btm)
		return
	if(btm.pulling == top || top.pulling == btm)
		return
	if(btm in top.buckled_mobs)
		return
	if(get_dist(top, btm) > 1)
		knot_remove(top, btm, notify = FALSE)
		return

	// Figure out who is where in the interaction because we couldn't pass it through signals
	var/top_position
	var/btm_position
	if(cum_genital[CLIMAX_POSITION_USER] == CLIMAX_PENIS)
		top_position = CLIMAX_POSITION_USER
		btm_position = CLIMAX_POSITION_TARGET
	else if(cum_genital[CLIMAX_POSITION_TARGET] == CLIMAX_PENIS)
		top_position = CLIMAX_POSITION_TARGET
		btm_position = CLIMAX_POSITION_USER

	var/knot = "knot"
	if(iscarbon(top)) // get text overrides, mostly for a horse cock's flare
		var/obj/item/organ/genital/penis/penis = top.get_organ_slot(ORGAN_SLOT_PENIS)
		knot = penis.override_string_knot

	if(top in btm.buckled_mobs) // if the two characters are being held in a fireman carry, let them mutually get pleasure from it
		if(btm.move_intent == MOVE_INTENT_WALK && prob(15))
			// values here were stolen from fleshlight.dm and not chosen with any kind of thought
			top.adjust_arousal(6)
			top.adjust_pleasure(9, btm, src, top_position) // Nice
			btm.adjust_arousal(6)
			btm.adjust_pleasure(9, top, src, btm_position) // Double Nice
			to_chat(top, span_love("I feel [btm] tightening over my [knot]."))
			to_chat(btm, span_love("I feel [top] rubbing inside."))
		else if(btm.move_intent == MOVE_INTENT_RUN && prob(5))
			top.adjust_arousal(3)
			top.adjust_pleasure(5, btm, src, top_position)
			top.adjust_pain(3, btm, src, top_position)
			btm.adjust_arousal(3)
			btm.adjust_pleasure(5, top, src, btm_position)
			btm.adjust_pain(3, top, src, btm_position)
			to_chat(top, span_alert("I'm being thrown around by my [knot] as [btm] runs!"))
			to_chat(btm, span_alert("[top] is being thrown around by their [knot] as I run!"))
		return

	if(prob(5))
		if(top == btm.knotted_parts["mouth"] && btm.get_oxy_loss() < 80) // if the current top knotted them orally
			if(btm.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")
				to_chat(btm, span_warning("I can't catch my breath with [top]'s [knot] in my mouth!"))
				btm.adjust_oxy_loss(3)

/datum/interaction/lewd/proc/knot_remove(mob/living/top, mob/living/btm, forceful_removal = FALSE, notify = TRUE)
	if(isliving(btm) && !QDELETED(btm) && isliving(top) && !QDELETED(top))
		var/knot = "knot"
		if(iscarbon(top)) // get text overrides, mostly for a horse cock's flare
			var/obj/item/organ/genital/penis/penis = top.get_organ_slot(ORGAN_SLOT_PENIS)
			knot = penis.override_string_knot
		if(top.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No" || btm.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")

			// Figure out who is where in the interaction because we can't rely on it being passed to us (signals)
			var/btm_position
			if(cum_genital[CLIMAX_POSITION_USER] == CLIMAX_PENIS)
				btm_position = CLIMAX_POSITION_TARGET
			else if(cum_genital[CLIMAX_POSITION_TARGET] == CLIMAX_PENIS)
				btm_position = CLIMAX_POSITION_USER

			if(forceful_removal)
				var/damage = top == btm.knotted_parts["mouth"] ? 6 : 18 // base damage value
				if (top.arousal >= AROUSAL_LOW) // considered still hard, let it rip like a beyblade
					damage *= 2
					btm.Knockdown(10)
					if(notify && !btm.has_status_effect(/datum/status_effect/knot_gaped)) // apply gaped status if extra forceful pull
						btm.apply_status_effect(/datum/status_effect/knot_gaped)
				if(top.combat_mode)
					var/body_zone = top == btm.knotted_parts["mouth"] ? BODY_ZONE_HEAD : BODY_ZONE_CHEST
					var/obj/item/bodypart/affecting = btm.get_bodypart(body_zone)
					if(affecting && affecting.brute_dam < 90-damage) // cap damage applied, can still kill if you yank out of their mouth and any other orifice
						btm.apply_damage(damage, BRUTE, body_zone)
				btm.Stun(80)
				conditional_pref_sound(btm, 'modular_zzplurt/sound/Scarlet_Reach/pop.ogg', 100, TRUE, -2, ignore_walls = FALSE, pref_to_check = /datum/preference/toggle/erp/sounds)
				conditional_pref_sound(top, 'modular_zzplurt/sound/Scarlet_Reach/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE, pref_to_check = /datum/preference/toggle/erp/sounds)
				btm.adjust_pain(10, top, src, btm_position)
				if(notify)
					top.visible_message(span_notice("[top] yanks their [knot] out of [btm]!"), span_notice("I yank my [knot] out from [btm]."))
			else if(notify)
				conditional_pref_sound(btm, 'sound/misc/moist_impact.ogg', 50, TRUE, -2, ignore_walls = FALSE, pref_to_check = /datum/preference/toggle/erp/sounds)
				top.visible_message(span_lewd("[top] slips their [knot] out of [btm]!"), span_lewd("I slip my [knot] out from [btm]."))
				btm.adjust_pain(4, top, src, btm_position)
		else if(notify)
			conditional_pref_sound(btm, 'sound/misc/moist_impact.ogg', 50, TRUE, -2, ignore_walls = FALSE, pref_to_check = /datum/preference/toggle/erp/sounds)
			top.visible_message(span_lewd("[top] slips their [knot] out of [btm]!"), span_lewd("I slip my [knot] out from [btm]."))
		btm.add_cum_splatter_floor(get_turf(btm))
	knot_exit(top, btm)

/// Often called when top or bottom is no longer valid or not provided
/datum/interaction/lewd/proc/knot_exit(mob/living/top, mob/living/btm, slot)
	if(isliving(top) && isliving(btm)) // if we were given two valid users
		for(var/top_part in top.knotted_parts)
			if(btm == top.knotted_parts[top_part])
				top.knotted_parts[top_part] = null
				break
		for(var/btm_part in btm.knotted_parts)
			if(top == btm.knotted_parts[btm_part])
				btm.knotted_parts[btm_part] = null
				break
	if(isliving(top) && slot) // or if we were only given the slot to remove
		if(isliving(top.knotted_parts[slot]))
			var/mob/living/partner = top.knotted_parts[slot]
			knot_remove(top, partner, notify = FALSE)
		top.knotted_parts[slot] = null // We should have found a partner and already removed the knot, but just in case
	if(isliving(top)) // Revaluate top knotted_status
		var/top_count = 0
		for(var/top_part in top.knotted_parts)
			if(top.knotted_parts[top_part])
				if(!isliving(top.knotted_parts[top_part]))
					top.knotted_parts[top_part] = null
					continue
				top_count++
		if(!top_count) // no more ties, remove effects and set knotted_status
			top.remove_status_effect(/datum/status_effect/knotted)
			UnregisterSignal(top, COMSIG_MOVABLE_ATTEMPTED_MOVE)
			UnregisterSignal(top, COMSIG_LIVING_DISARM_HIT)
			UnregisterSignal(top, COMSIG_MOVABLE_PRE_THROW)
			top.knotted_status = FALSE
		log_combat(top, top, "Stopped knot tugging")
	if(isliving(btm)) // Revaluate btm knotted_status
		var/btm_count = 0
		for(var/btm_part in btm.knotted_parts)
			if(btm.knotted_parts[btm_part])
				if(!isliving(btm.knotted_parts[btm_part]))
					btm.knotted_parts[btm_part] = null
					continue
				btm_count++
		if(!btm_count) // no more ties, remove effects and set knotted_status
			btm.remove_status_effect(/datum/status_effect/knotted)
			UnregisterSignal(btm, COMSIG_MOVABLE_ATTEMPTED_MOVE)
			UnregisterSignal(btm, COMSIG_LIVING_DISARM_HIT)
			UnregisterSignal(btm, COMSIG_MOVABLE_PRE_THROW)
			btm.knotted_status = FALSE
		log_combat(btm, btm, "Stopped knot tugging")

/// Signal safe version of knot_exit, must have both users
/datum/interaction/lewd/proc/knot_exit_strict(mob/living/top, mob/living/btm)
	if(!isliving(top) || !isliving(btm)) // if we were not given two valid users
		return
	for(var/part in top.knotted_parts)
		if(btm == top.knotted_parts[part])
			top.knotted_parts[part] = null
			break
	for(var/part in btm.knotted_parts)
		if(top == btm.knotted_parts[part])
			btm.knotted_parts[part] = null
			btm.add_cum_splatter_floor(get_turf(btm))
			break
	var/top_count = 0
	for(var/part in top.knotted_parts)
		if(top.knotted_parts[part])
			if(!isliving(top.knotted_parts[part]))
				top.knotted_parts[part] = null
				continue
			top_count++
	if(!top_count) // no more ties, remove effects and set knotted_status
		top.remove_status_effect(/datum/status_effect/knotted)
		UnregisterSignal(top, COMSIG_MOVABLE_ATTEMPTED_MOVE)
		UnregisterSignal(top, COMSIG_LIVING_DISARM_HIT)
		UnregisterSignal(top, COMSIG_MOVABLE_PRE_THROW)
		top.knotted_status = FALSE
	log_combat(top, top, "Stopped knot tugging")
	var/btm_count = 0
	for(var/part in btm.knotted_parts)
		if(btm.knotted_parts[part])
			if(!isliving(btm.knotted_parts[part]))
				btm.knotted_parts[part] = null
				continue
			btm_count++
	if(!btm_count) // no more ties, remove effects and set knotted_status
		btm.remove_status_effect(/datum/status_effect/knotted)
		UnregisterSignal(btm, COMSIG_MOVABLE_ATTEMPTED_MOVE)
		UnregisterSignal(btm, COMSIG_LIVING_DISARM_HIT)
		UnregisterSignal(btm, COMSIG_MOVABLE_PRE_THROW)
		btm.knotted_status = FALSE
	log_combat(btm, btm, "Stopped knot tugging")

/// Untie all knots if we are thrown
/datum/interaction/lewd/proc/knotted_thrown(mob/living/thrown)
	SIGNAL_HANDLER
	if(!isliving(thrown))
		UnregisterSignal(thrown, COMSIG_MOVABLE_PRE_THROW)
		return
	knotted_remove_all(thrown)

/// Untie all knots if we are shoved (disarmed)
/datum/interaction/lewd/proc/knotted_shoved(mob/living/defender)
	SIGNAL_HANDLER
	if(!isliving(defender))
		UnregisterSignal(defender, COMSIG_LIVING_DISARM_HIT)
		return
	knotted_remove_all(defender)

/// Untie all knots
/datum/interaction/lewd/proc/knotted_remove_all(mob/living/user)
	var/mob/living/partner
	for(var/user_part in user.knotted_parts)
		if(!isliving(user.knotted_parts[user_part]))
			user.knotted_parts[user_part] = null
			continue
		partner = user.knotted_parts[user_part]
		user.knotted_parts[user_part] = null
		var/partner_ties = 0
		for(var/partner_part in partner.knotted_parts)
			if(!isliving(partner.knotted_parts[partner_part]))
				partner.knotted_parts[partner_part] = null
				continue
			partner_ties++
			if(user == partner.knotted_parts[partner_part])
				partner.knotted_parts[partner_part] = null
				partner_ties--
		if(partner_ties == 0)
			partner.knotted_status = FALSE
			UnregisterSignal(partner, COMSIG_MOVABLE_ATTEMPTED_MOVE)
			UnregisterSignal(partner, COMSIG_LIVING_DISARM_PRESHOVE)
			UnregisterSignal(partner, COMSIG_MOVABLE_PRE_THROW)
			partner.remove_status_effect(/datum/status_effect/knotted)
	user.knotted_status = FALSE
	UnregisterSignal(user, COMSIG_MOVABLE_ATTEMPTED_MOVE)
	UnregisterSignal(user, COMSIG_LIVING_DISARM_PRESHOVE)
	UnregisterSignal(user, COMSIG_MOVABLE_PRE_THROW)
	user.remove_status_effect(/datum/status_effect/knotted)

// Untested, not even sure how to test until werewolves come back
/datum/action/cooldown/werewolf/transform/Activate() // needed to ensure that we safely remove the tie before and after transitioning
	var/mob/living/user = owner
	if(!istype(user))
		return ..()
	var/mob/living/partner = null
	for(var/user_part in user.knotted_parts)
		if(!isliving(user.knotted_parts[user_part]))
			user.knotted_parts[user_part] = null
			continue
		partner = user.knotted_parts[user_part]
		user.knotted_parts[user_part] = null
		var/partner_ties = 0
		for(var/partner_part in partner.knotted_parts)
			if(!isliving(partner.knotted_parts[partner_part]))
				partner.knotted_parts[partner_part] = null
				continue
			partner_ties++
			if(user == partner.knotted_parts[partner_part])
				partner.knotted_parts[partner_part] = null
				partner_ties--
		if(partner_ties == 0)
			partner.knotted_status = FALSE
			UnregisterSignal(partner, COMSIG_MOVABLE_ATTEMPTED_MOVE)
			UnregisterSignal(partner, COMSIG_LIVING_DISARM_PRESHOVE)
			UnregisterSignal(partner, COMSIG_MOVABLE_PRE_THROW)
			partner.remove_status_effect(/datum/status_effect/knotted)
	user.knotted_status = FALSE
	UnregisterSignal(user, COMSIG_MOVABLE_ATTEMPTED_MOVE)
	UnregisterSignal(user, COMSIG_LIVING_DISARM_PRESHOVE)
	UnregisterSignal(user, COMSIG_MOVABLE_PRE_THROW)
	user.remove_status_effect(/datum/status_effect/knotted)
	return ..()

/obj/item/robot_model/be_transformed_to(obj/item/robot_model/old_model, forced = FALSE)
	. = ..()
	if(.)
		var/mob/living/silicon/robot/cyborg = loc
		if(cyborg.knotted_status)
			var/mob/living/partner = null
			for(var/user_part in cyborg.knotted_parts)
				if(!isliving(cyborg.knotted_parts[user_part]))
					cyborg.knotted_parts[user_part] = null
					continue
				partner = cyborg.knotted_parts[user_part]
				cyborg.knotted_parts[user_part] = null
				var/partner_ties = 0
				for(var/partner_part in partner.knotted_parts)
					if(!isliving(partner.knotted_parts[partner_part]))
						partner.knotted_parts[partner_part] = null
						continue
					partner_ties++
					if(cyborg == partner.knotted_parts[partner_part])
						partner.knotted_parts[partner_part] = null
						partner_ties--
				if(partner_ties == 0)
					partner.knotted_status = FALSE
					UnregisterSignal(partner, COMSIG_MOVABLE_ATTEMPTED_MOVE)
					UnregisterSignal(partner, COMSIG_LIVING_DISARM_PRESHOVE)
					UnregisterSignal(partner, COMSIG_MOVABLE_PRE_THROW)
					partner.remove_status_effect(/datum/status_effect/knotted)
			cyborg.knotted_status = FALSE
			UnregisterSignal(cyborg, COMSIG_MOVABLE_ATTEMPTED_MOVE)
			UnregisterSignal(cyborg, COMSIG_LIVING_DISARM_PRESHOVE)
			UnregisterSignal(cyborg, COMSIG_MOVABLE_PRE_THROW)
			cyborg.remove_status_effect(/datum/status_effect/knotted)
	return .

/mob/living/can_speak(allow_mimes = FALSE) // do not allow bottom to speak while knotted orally
	if(src.knotted_parts["mouth"])
		return FALSE
	return ..()

// Partial, still makes sound, probably shouldn't
// message_mime kinda works, but some messages assume the mouth is still visible and usable which is not the case here
/datum/emote/select_message_type(mob/user, intentional) // always use the muffled version of emotes while bottom is knotted orally
	. = ..()
	if(message_mime && isliving(user))
		var/mob/living/btm = user
		if(btm.knotted_parts["mouth"])
			. = message_mime

/datum/status_effect/knot_fucked_stupid
	id = "knot_fucked_stupid"
	duration = 2 MINUTES
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knot_fucked_stupid

/atom/movable/screen/alert/status_effect/knot_fucked_stupid
	name = "Fucked Stupid"
	desc = "Mmmph I can't think straight..."
	// need to steal this from Scarlet or get an artist to make it
	//icon_state = "knotted_stupid"

/datum/status_effect/knot_gaped
	id = "knot_gaped"
	duration = 60 SECONDS
	tick_interval = 50 // every 5 seconds
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knot_gaped
	var/last_loc

/datum/status_effect/knot_gaped/on_apply() // Gape the jaw if we have a head and our mouth was knotted
	if(!isliving(owner))
		return FALSE
	var/mob/living/user = owner
	last_loc = get_turf(user)
	if(user.stat == CONSCIOUS && user.knotted_parts["mouth"] && !user.has_status_effect(/datum/status_effect/jaw_gaped))
		var/obj/item/bodypart/head = user.get_bodypart(BODY_ZONE_HEAD)
		if(head) // only apply this effect if a head is found
			user.apply_status_effect(/datum/status_effect/jaw_gaped)
	return ..()

/datum/status_effect/knot_gaped/tick() // Spawns cum puddles
	var/cur_loc = get_turf(owner)
	if(get_dist(cur_loc, last_loc) <= 5) // too close, don't spawn a puddle
		return
	owner.add_cum_splatter_floor(get_turf(owner))
	conditional_pref_sound(owner, pick('modular_zzplurt/sound/Scarlet_Reach/bleed (1).ogg', 'modular_zzplurt/sound/Scarlet_Reach/bleed (2).ogg', 'modular_zzplurt/sound/Scarlet_Reach/bleed (3).ogg'), 50, TRUE, -2, ignore_walls = FALSE, pref_to_check = /datum/preference/toggle/erp/sounds)
	last_loc = cur_loc

/atom/movable/screen/alert/status_effect/knot_gaped
	name = "Gaped"
	desc = "You were forcefully withdrawn from. Warmth runs freely from your hole..."
	// Scarlet didn't have an icon for this but it probably should have one

/datum/status_effect/knotted
	id = "knotted"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knotted

/atom/movable/screen/alert/status_effect/knotted
	name = "Knotted"
	desc = "I have to be careful where I step... Click to remove all knots"
	// need to steal this from Scarlet or get an artist to make it
	//icon_state = "knotted"

/datum/status_effect/knotted/tick()
	if(!owner.knotted_parts["mouth"])
		return
	if(owner.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")
		owner.adjust_oxy_loss(2)

/atom/movable/screen/alert/status_effect/knotted/Click() // Silently remove all ties
	..()
	var/mob/living/user = usr
	if(!istype(user))
		return FALSE
	var/mob/living/partner = null
	for(var/user_part in user.knotted_parts)
		if(!isliving(user.knotted_parts[user_part]))
			user.knotted_parts[user_part] = null
			continue
		partner = user.knotted_parts[user_part]
		user.knotted_parts[user_part] = null
		var/partner_ties = 0
		for(var/partner_part in partner.knotted_parts)
			if(!isliving(partner.knotted_parts[partner_part]))
				partner.knotted_parts[partner_part] = null
				continue
			partner_ties++
			if(user == partner.knotted_parts[partner_part])
				partner.knotted_parts[partner_part] = null
				partner_ties--
		if(partner_ties == 0)
			partner.knotted_status = FALSE
			UnregisterSignal(partner, COMSIG_MOVABLE_ATTEMPTED_MOVE)
			UnregisterSignal(partner, COMSIG_LIVING_DISARM_PRESHOVE)
			UnregisterSignal(partner, COMSIG_MOVABLE_PRE_THROW)
			partner.remove_status_effect(/datum/status_effect/knotted)
	user.knotted_status = FALSE
	UnregisterSignal(user, COMSIG_MOVABLE_ATTEMPTED_MOVE)
	UnregisterSignal(user, COMSIG_LIVING_DISARM_PRESHOVE)
	UnregisterSignal(user, COMSIG_MOVABLE_PRE_THROW)
	user.remove_status_effect(/datum/status_effect/knotted)
	return FALSE

/datum/status_effect/jaw_gaped
	id = "jaw_gaped"
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = -1
	alert_type = null

/datum/status_effect/jaw_gaped/on_apply()
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, "jaw_gaped") // might want to make a new one to not risk interfering with an existing mutation
	to_chat(owner, span_warning("My jaw... It stings!"))
	return ..()

/datum/status_effect/jaw_gaped/on_remove()
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, "jaw_gaped") // might want to make a new one to not risk interfering with an existing mutation
	if(owner.stat == CONSCIOUS)
		to_chat(owner, span_warning("I finally feel my jaw again."))
