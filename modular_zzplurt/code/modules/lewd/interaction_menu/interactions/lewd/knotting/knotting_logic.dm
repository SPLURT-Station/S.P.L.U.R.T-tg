
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
		ORGAN_SLOT_VAGINA = null,
		ORGAN_SLOT_ANUS = null,
		"mouth" = null, // ORGAN_SLOT_MOUTH dosen't exist, and might break things if it did
		ORGAN_SLOT_SLIT = null, // Currently unused by any interactions, also not part of the simulated genitals of simple mobs
		ORGAN_SLOT_EARS = null, // Currently unused, not even by earfuck
		ORGAN_SLOT_EYES = null, // Currently unused, not even by eyefuck
		ORGAN_SLOT_NIPPLES = null // Currently unused, not even by nipplefuck
	)
	// Boolean for checking if we are knotted at all, faster than checking the list
	var/knotted_status = FALSE
	// Who is moving us by the knot or null, used to not attempt moving the person that moved us when leashed by a knot
	var/knotted_moved_by = null

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
		var/obj/item/organ/genital/penis = user.get_organ_slot(ORGAN_SLOT_PENIS)
		switch(penis.genital_type)
			if("knotted", "barbknot", "hemiknot")
				return TRUE
		return FALSE
	// Cyborgs still don't have an easy way to check for a knot so we have to list every SKIN_ICON_STATE we want to have a knot...
	if(iscyborg(user))
		var/mob/living/silicon/robot/borg = user
		if(borg.icon_state in knotty_borgs)
			return TRUE
		return FALSE
	// Need a way to see if a non-carbon/non-cyborg mob's penis has a knot
	// For now, the only non-carbon/non-cyborg mobs with a penis are funclaws and werewolves so return true
	if(isliving(user))
		if(user.simulated_genitals[ORGAN_SLOT_PENIS])
			return TRUE
	return FALSE

/* SPLURT EDIT - KNOTTING
		this is for double penetration interactions that aren't implemented yet
		those are split accross a dozen files in Scarlet Reach
		we should move those and this into one file, seperate from the knotting code
		Ask the suggester

/// Checks if the user has a hemipenis variant
/datum/interaction/lewd/proc/double_penis_type() // Do we have TWO penises?
	var/obj/item/organ/genital/penis = user.get_organ_slot(ORGAN_SLOT_PENIS)
	if(!penis)
		return FALSE
	switch(penis.genital_type)
		if("hemi","hemiknot")
			return TRUE
	return FALSE
*/ //END SPLURT EDIT

/// Seperate knot_check_remove if two users are supposed to stay knotted
/datum/interaction/lewd/proc/knotfucking_check_remove(mob/living/user, mob/living/target)
	// check if the knot is blocking these actions, and thus requires removal
	// Mouth, because it needs to be diffrent I guess...
	if(interaction_requires.len)
		for(var/requirement in interaction_requires)
			switch(requirement)
				if(INTERACTION_REQUIRE_SELF_MOUTH)
					if(user.knotted_parts["mouth"] != target)
						knot_exit(user, slot = "mouth")
				if(INTERACTION_REQUIRE_TARGET_MOUTH)
					if(target.knotted_parts["mouth"] != user)
						knot_exit(target, slot = "mouth")
	// person that initiated this interaction
	if(user_required_parts.len)
		for(var/part in user_required_parts)
			if(user.knotted_parts[part] != target)
				knot_exit(user, slot = part)
	// person that is the target of this interaction
	if(target_required_parts.len)
		for(var/part in target_required_parts)
			if(target.knotted_parts[part] != user)
				knot_exit(target, slot = part)
	// user parts that are not in the user_required_parts list for some reason
	if(user_knotting_require.len)
		for(var/part in user_required_parts)
			if(user.knotted_parts[part] != target)
				knot_exit(user, slot = part)
	// target parts that are not in the target_require_parts list for some reason
	if(target_knotting_require.len)
		for(var/part in target_required_parts)
			if(target.knotted_parts[part] != user)
				knot_exit(target, slot = part)

/// Removes the knot if it is required by a new interaction
/datum/interaction/lewd/proc/knot_check_remove(mob/living/user, mob/living/target, knotfucking)
	if(!isliving(user) || !isliving(target))
		return // bail if either of us aren't living
	if(!user.knotted_status && !target.knotted_status)
		return // bail if neither of us are knotted
	if(knotfucking)
		knotfucking_check_remove(user, target)

	// check if the knot is blocking these actions, and thus requires removal
	// Mouth, because it needs to be diffrent I guess...
	if(interaction_requires.len)
		for(var/requirement in interaction_requires)
			switch(requirement)
				if(INTERACTION_REQUIRE_SELF_MOUTH)
					if(user.knotted_parts["mouth"])
						knot_exit(user, slot = "mouth")
				if(INTERACTION_REQUIRE_TARGET_MOUTH)
					if(target.knotted_parts["mouth"])
						knot_exit(target, slot = "mouth")
	// person that initiated this interaction
	if(user_required_parts.len)
		for(var/part in user_required_parts)
			if(user.knotted_parts[part])
				knot_exit(user, slot = part)
	// person that is the target of this interaction
	if(target_required_parts.len)
		for(var/part in target_required_parts)
			if(target.knotted_parts[part])
				knot_exit(target, slot = part)
	// user parts that are not in the user_required_parts list for some reason
	if(user_knotting_require.len)
		for(var/part in user_required_parts)
			if(user.knotted_parts[part])
				knot_exit(user, slot = part)
	// target parts that are not in the target_require_parts list for some reason
	if(target_knotting_require.len)
		for(var/part in target_required_parts)
			if(target.knotted_parts[part])
				knot_exit(target, slot = part)

/// Attempts to knot the user and target. custom_slot is used as a backup if cum_target[CLIMAX_POSITION_USER] is undefined
/datum/interaction/lewd/proc/knot_try(mob/living/user, mob/living/target, position, knotfucking) // NOTE - This is only called by cum_into and only when do_knot_action is true and never on selfcest
	if(!knotting_supported) // the current interaction does not support knot climaxing, abort
		return
	if(user == target)
		log_game("Interaction [src] tried to make [user] knot themselves")
		message_admins("Interaction [src] tried to make [user] knot themselves")
		return
	if(!knot_penis_type(user)) // don't have that dog in 'em
		return
	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp) || !target.client?.prefs?.read_preference(/datum/preference/toggle/erp))
		return
	if(!user.client?.prefs?.read_preference(/datum/preference/toggle/erp/knotting) || !target.client?.prefs?.read_preference(/datum/preference/toggle/erp/knotting))
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

	// bail if we don't knot what slot to use
	if(!target_slot)
		message_admins("Interaction '[src]' called knot_try but target_slot could not be set (missing or bad data)")
		return

	if(knotfucking)
		if(target.knotted_parts[target_slot] == user) // Our 'slot' is already occupied by user, we don't need to do anything else
			return
		/* Still feels terrible in testing
		else if(iscarbon(user)) // Otherwise, check their arousal
			var/obj/item/organ/genital/penis = user.get_organ_slot(ORGAN_SLOT_PENIS)
			if(penis.aroused != AROUSAL_FULL)
				if(!user.knotted_status)
					to_chat(user, span_notice("My knot was too soft to tie."))
				if(!target.knotted_status)
					to_chat(target, span_notice("I feel their deflated knot slip out."))
				return
		*/

	if(knotted_orifices(user) > 0) // Bottoms can't be tops silly
		user.visible_message(span_notice("[user] fails to knot [target] while already knotted!"), span_notice("I fail to knot [target] while already knotted"))
		return

	if(target.knotted_parts[ORGAN_SLOT_PENIS]) // You're a bottom now
		var/mob/living/target_partner = target.knotted_parts[ORGAN_SLOT_PENIS]
		knot_remove(target, target_partner)
		target.visible_message(span_lewd("[target]'s knot slips out of [target_partner] as they are knotted by [user]!"), span_lewd("My knot slips out from [target_partner] as I'm knotted by [user]."))

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
				var/damage = user == target.knotted_parts["mouth"] ? 10 : 30 // base damage value
				var/body_zone = user == target.knotted_parts["mouth"] ? BODY_ZONE_HEAD : BODY_ZONE_CHEST
				var/obj/item/bodypart/affecting = target.get_bodypart(body_zone)
				if(affecting && affecting.brute_dam < 80-damage) // cap damage applied, can still kill if you hatefuck their mouth and any other orifice
					target.apply_damage(damage, BRUTE, body_zone)
				target.adjust_pain(10, user)
			else
				target.adjust_pain(4, user) // if harm pref fails still apply some pain
		else
			target.adjust_pain(4, user)
		target.Stun(80) // stun for dramatic effect
	user.visible_message(span_lewd("[user] ties their knot inside of [target]!"), span_lewd("I tie my knot inside of [target]."))

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
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(knot_movement))
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(knot_movement))
	RegisterSignal(user, COMSIG_LIVING_DISARM_HIT, PROC_REF(knotted_shoved))
	RegisterSignal(target, COMSIG_LIVING_DISARM_HIT, PROC_REF(knotted_shoved))

/* SPLURT EDIT - KNOTTING - This can be considered a pref break for everyone nearby, not just the doctor that would reattatch it...
	still carbon dependant but that can be fixed
	Ask the suggester

/// Dismemberment caused by moving too far away while knotted
/datum/interaction/lewd/proc/knot_movement_mods_remove_his_knot_ty(var/mob/living/top, var/mob/living/btm) // NOTE - This is only used internally for dragging the partner by the knot
	var/obj/item/organ/genital/penis = top.get_organ_slot(ORGAN_SLOT_PENIS)
	if(!penis)
		return FALSE
	penis.Remove(top)
	penis.forceMove(top.drop_location())
	penis.add_mob_blood(top)
	conditional_pref_sound(get_turf(top), 'sound/combat/dismemberment/dismem (5).ogg', 80, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
	conditional_pref_sound(get_turf(top), 'sound/vo/male/tomscream.ogg', 80, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
	to_chat(top, span_userdanger("You feel a sharp pain as your knot is torn asunder!"))
	to_chat(btm, span_userdanger("You feel their knot withdraw faster than you can process!"))
	top.adjust_pain(15) // Considering pain caps at 60 this might be high, but you had your cock ripped off sooo...
	btm.adjust_pain(15)
	knot_remove(top, btm, forceful_removal = TRUE, notify = FALSE)
	log_combat(btm, top, "Top had their cock ripped off (knot tugged too far)")
	return TRUE
*/ // SPLURT EDIT END

/// Main proc for leashing caracters together by the knot, calls the appropriate proc based on who moved
/datum/interaction/lewd/proc/knot_movement(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER
	if(QDELETED(mover))
		return
	if(!isliving(mover)) // this should never hit, but if it does remove callback
		UnregisterSignal(mover, COMSIG_MOVABLE_MOVED)
		return
	var/mob/living/user = mover
	if(user.knotted_status == FALSE) // this should never hit, but if it does remove callback
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	for(var/part in user.knotted_parts)
		if(user.knotted_parts[part])
			if(user.knotted_parts[part] == user.knotted_moved_by) // The bottom is currently moving us, don't try to move them
				return
			if(part == ORGAN_SLOT_PENIS)
				addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/interaction/lewd, knot_movement_top), user, user.knotted_parts[part]), 1) // if we are the top
			else
				addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/interaction/lewd, knot_movement_btm), user.knotted_parts[part], user), 1) // if we are the bottom

/datum/interaction/lewd/proc/knot_movement_top(mob/living/top, mob/living/btm)
	if(!isliving(btm) || QDELETED(btm) || !isliving(top) || QDELETED(top))
		knot_exit(top, btm)
		return
	if(isnull(top.client) || !top.client?.prefs?.read_preference(/datum/preference/toggle/erp) || isnull(btm.client) || !btm.client?.prefs?.read_preference(/datum/preference/toggle/erp)) // we respect safewords here, let the players untie themselves // This is the worst way to respect safewords...
		knot_remove(top, btm)
		return
	if(top.pulling == btm || btm.pulling == top)
		return
	/* Arousal drops back to low RAPIDLY
	if(top.arousal < AROUSAL_LOW)
		knot_remove(top, btm)
		return
	*/
	if(prob(10) && top.move_intent == MOVE_INTENT_WALK && (btm in top.buckled_mobs)) // if the two characters are being held in a fireman carry, let them mutually get pleasure from it
		// values here were stolen from fleshlight.dm and not chosen with any kind of thought
		top.adjust_arousal(6)
		top.adjust_pleasure(9) // Nice
		btm.adjust_arousal(6)
		btm.adjust_pleasure(9) // Double Nice
		if(prob(50))
			to_chat(top, span_love("I feel [btm] tightening over my knot."))
			to_chat(btm, span_love("I feel [top] rubbing inside."))

	var/dist = get_dist(top, btm)
	if(dist > 1 &&  dist < 6) // attempt to move the knot recipient to a minimum of 1 tiles away from the knot owner, so they trail behind
		btm.knotted_moved_by = top
		for(var/i in 1 to 3) // try moving three times
			step_towards(btm, top)
			dist = get_dist(top, btm)
			if(dist <= 1)
				break
		btm.knotted_moved_by = null
	if(dist > 1) // if we couldn't move them closer, force the knot out
		/* SPLURT EDIT - KNOTTING - avoid pref breaking everyone nearby
		if(dist > 10 && knot_movement_mods_remove_his_knot_ty(top, btm)) // teleported or something else
			return
		*/ //SPLURT EDIT END
		knot_remove(top, btm, forceful_removal = TRUE)
		return
	if(top.loc.z != btm.loc.z) // we're not on the same sector
		var/diff_in_z = top.loc.z - btm.loc.z
		var/turf/T
		switch(diff_in_z)
			if(1) // bottom is below top, check above bottom
				T = get_step_multiz(btm, UP)
				if(btm.mobility_flags & MOBILITY_STAND) // the bottom is hanging by the knot, knock them down
					btm.Knockdown(10)
			if(-1) // bottom is above top, check above top
				T = get_step_multiz(top, UP)
			else // sector difference is too great, force a disconnect
				T = null
		if(!T || !isgroundlessturf(T))
			knot_remove(top, btm, forceful_removal = TRUE)
			return
	btm.face_atom(top)
	top.set_pull_offsets(btm, GRAB_AGGRESSIVE)
	if(!top.IsStun()) // randomly stun our top so they cannot simply drag without any penality (combat mode doubles the chances)
		if(prob(!top.combat_mode && !top.has_penis(REQUIRE_GENITAL_EXPOSED) ? 7 : 20))
			top.adjust_pain(4, btm)
			if(!top.has_penis(REQUIRE_GENITAL_EXPOSED) && (top.mobility_flags & MOBILITY_STAND)) // only knock down if standing and knot area is blocked
				top.Knockdown(10)
				to_chat(top, span_warning("I trip trying to move while my knot is covered."))
			top.Stun(15)
	if(!btm.IsStun())
		if(prob(5))
			btm.emote("groan")
			btm.adjust_pain(6, top)
			btm.Stun(15)
		else if(prob(3))
			btm.adjust_pain(1, top)
		else if(top == btm.knotted_parts["mouth"] && btm.getOxyLoss() < 50) // if the current top knotted them orally
			btm.adjustOxyLoss(1)

/datum/interaction/lewd/proc/knot_movement_btm(mob/living/top, mob/living/btm)
	if(!isliving(btm) || QDELETED(btm) || !isliving(top) || QDELETED(top))
		knot_exit(top, btm)
		return
	if(isnull(top.client) || !top.client?.prefs?.read_preference(/datum/preference/toggle/erp) || isnull(btm.client) || !btm.client?.prefs?.read_preference(/datum/preference/toggle/erp)) // we respect safewords here, let the players untie themselves // This is the worst way to respect safewords...
		knot_remove(top, btm)
		return
	if(top.stat >= SOFT_CRIT) // only removed if the knot owner is injured/asleep/dead
		knot_remove(top, btm)
		return
	if(btm.pulling == top || top.pulling == btm)
		return
	/* Arousal drops back to low RAPIDLY
	if(top.arousal < AROUSAL_LOW)
		knot_remove(top, btm)
		return
	*/
	var/dist = get_dist(top, btm)
	if(dist > 1 &&  dist < 6) // attempt to move the knot recipient to a minimum of 1 tiles away from the knot owner, so they trail behind
		top.knotted_moved_by = btm
		for(var/i in 1 to 3)
			step_towards(top, btm)
			dist = get_dist(top, btm)
			if(dist <= 1)
				break
		top.knotted_moved_by = null
	if(dist > 2)
		/* SPLURT EDIT - KNOTTING - avoid pref breaking everyone nearby
		if(dist > 10 && knot_movement_mods_remove_his_knot_ty(top, btm)) // teleported or something else
			return
		*/ // SPLURT EDIT END
		knot_remove(top, btm, forceful_removal = TRUE)
		return
	if(top.loc.z != btm.loc.z) // we're not on the same sector
		var/diff_in_z = top.loc.z - btm.loc.z
		var/turf/T
		switch(diff_in_z)
			if(1) // bottom is below top, check above bottom
				T = get_step_multiz(btm, UP)
				if(btm.mobility_flags & MOBILITY_STAND) // the bottom is hanging by the knot, knock them down
					btm.Knockdown(10)
			if(-1) // bottom is above top, check above top
				T = get_step_multiz(top, UP)
			else // sector difference is too great, force a disconnect
				T = null
		if(!T || !isgroundlessturf(T))
			knot_remove(top, btm, forceful_removal = TRUE)
			return
	top.set_pull_offsets(btm, GRAB_AGGRESSIVE)
	if(btm.mobility_flags & MOBILITY_STAND)
		if(btm.move_intent == MOVE_INTENT_RUN) // running only makes this worse, darling
			btm.Knockdown(10)
			btm.Stun(30)
			btm.emote("groan", forced = TRUE)
			return
	if(!btm.IsStun())
		if(prob(10))
			btm.emote("groan")
			btm.adjust_pain(6)
			btm.Stun(15)
			if(top == btm.knotted_parts["mouth"] && btm.getOxyLoss() < 50) // if the current top knotted them orally
				btm.adjustOxyLoss(3)
		else if(prob(4))
			btm.adjust_pain(1, top)
	// knot_movement_btm_after causes the btm to change direction back and forth rapidly which looks very strange
	//addtimer(CALLBACK(src, PROC_REF(knot_movement_btm_after), top, btm), 1)

/datum/interaction/lewd/proc/knot_movement_btm_after(mob/living/top, mob/living/btm)
	if(!isliving(btm) || QDELETED(btm) || !isliving(top) || QDELETED(top))
		return
	btm.face_atom(top) // This could use a change to make the bottom face backwards if anally dragged

/datum/interaction/lewd/proc/knot_remove(mob/living/top, mob/living/btm, forceful_removal = FALSE, notify = TRUE)
	if(isliving(btm) && !QDELETED(btm) && isliving(top) && !QDELETED(top))
		if(top.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No" || btm.client?.prefs?.read_preference(/datum/preference/choiced/erp_status_extmharm) != "No")
			if(forceful_removal)
				var/damage = top == btm.knotted_parts["mouth"] ? 10 : 30 // base damage value
				if (top.arousal >= AROUSAL_LOW) // considered still hard, let it rip like a beyblade
					damage *= 2
					btm.Knockdown(10)
					if(notify && !btm.has_status_effect(/datum/status_effect/knot_gaped)) // apply gaped status if extra forceful pull
						btm.apply_status_effect(/datum/status_effect/knot_gaped)
				if(top.combat_mode)
					var/body_zone = top == btm.knotted_parts["mouth"] ? BODY_ZONE_HEAD : BODY_ZONE_CHEST
					var/obj/item/bodypart/affecting = btm.get_bodypart(body_zone)
					if(affecting && affecting.brute_dam < 80-damage) // cap damage applied, can still kill if you yank out of their mouth and any other orifice
						btm.apply_damage(damage, BRUTE, body_zone)
				btm.Stun(80)
				conditional_pref_sound(btm, 'modular_zzplurt/sound/Scarlet_Reach/pop.ogg', 100, TRUE, -2, ignore_walls = FALSE, pref_to_check = /datum/preference/toggle/erp/sounds)
				conditional_pref_sound(top, 'modular_zzplurt/sound/Scarlet_Reach/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE, pref_to_check = /datum/preference/toggle/erp/sounds)
				btm.adjust_pain(10,top)
				if(notify)
					top.visible_message(span_notice("[top] yanks their knot out of [btm]!"), span_notice("I yank my knot out from [btm]."))
			else if(notify)
				conditional_pref_sound(btm, 'sound/misc/moist_impact.ogg', 50, TRUE, -2, ignore_walls = FALSE, pref_to_check = /datum/preference/toggle/erp/sounds)
				top.visible_message(span_lewd("[top] slips their knot out of [btm]!"), span_lewd("I slip my knot out from [btm]."))
				btm.adjust_pain(4, top)
		else if(notify)
			conditional_pref_sound(btm, 'sound/misc/moist_impact.ogg', 50, TRUE, -2, ignore_walls = FALSE, pref_to_check = /datum/preference/toggle/erp/sounds)
			top.visible_message(span_lewd("[top] slips their knot out of [btm]!"), span_lewd("I slip my knot out from [btm]."))
		btm.add_cum_splatter_floor(get_turf(btm))
/* Statuses - probably one of the last things to fix
	it would be weird if knotting is the only source for these, might want to add them to climax.dm
	ask the suggester

		var/obj/item/organ/genital/cur_part = top.knotted_parts[KNOTTED_PENIS] // use top to determine what status to apply, as bottom may be double knotted or more
		if(istype(cur_part, /obj/item/organ/genital/vagina) || istype(cur_part, /obj/item/organ/genital/anus))
			var/datum/status_effect/facial/internal/creampie = btm.has_status_effect(/datum/status_effect/facial/internal)
			if(!creampie)
				btm.apply_status_effect(/datum/status_effect/facial/internal)
			else
				creampie.refresh_cum()
		if(top == knotting_who_is(btm, KNOTTED_MOUTH))
			var/datum/status_effect/facial/facial = btm.has_status_effect(/datum/status_effect/facial)
			if(!facial)
				btm.apply_status_effect(/datum/status_effect/facial)
			else
				facial.refresh_cum()
*/
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
				if(!isliving(top.knotted_parts[slot]))
					top.knotted_parts[slot] = null
					continue
				top_count++
		if(!top_count) // no more ties, remove effects and set knotted_status
			top.remove_status_effect(/datum/status_effect/knotted)
			top.reset_pull_offsets(top, GRABBING_TRAIT)
			UnregisterSignal(top, COMSIG_MOVABLE_MOVED)
			UnregisterSignal(top, COMSIG_LIVING_DISARM_HIT)
			top.knotted_status = FALSE
		log_combat(top, top, "Stopped knot tugging")
	if(isliving(btm)) // Revaluate btm knotted_status
		var/btm_count = 0
		for(var/btm_part in btm.knotted_parts)
			if(btm.knotted_parts[btm_part])
				if(!isliving(btm.knotted_parts[slot]))
					btm.knotted_parts[slot] = null
					continue
				btm_count++
		if(!btm_count) // no more ties, remove effects and set knotted_status
			btm.remove_status_effect(/datum/status_effect/knotted)
			btm.reset_pull_offsets(btm, GRABBING_TRAIT)
			UnregisterSignal(btm, COMSIG_MOVABLE_MOVED)
			UnregisterSignal(btm, COMSIG_LIVING_DISARM_HIT)
			btm.knotted_status = FALSE
		log_combat(btm, btm, "Stopped knot tugging")

/// Untie all knots if we are shoved (disarmed)
/datum/interaction/lewd/proc/knotted_shoved(mob/living/defender)
	SIGNAL_HANDLER
	if(!isliving(defender))
		UnregisterSignal(defender, COMSIG_LIVING_DISARM_HIT)
		return
	var/mob/living/user = defender
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
			UnregisterSignal(partner, COMSIG_MOVABLE_MOVED)
			UnregisterSignal(partner, COMSIG_LIVING_DISARM_PRESHOVE)
			partner.remove_status_effect(/datum/status_effect/knotted)
	user.knotted_status = FALSE
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(user, COMSIG_LIVING_DISARM_PRESHOVE)
	user.remove_status_effect(/datum/status_effect/knotted)

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
			UnregisterSignal(partner, COMSIG_MOVABLE_MOVED)
			UnregisterSignal(partner, COMSIG_LIVING_DISARM_PRESHOVE)
			partner.remove_status_effect(/datum/status_effect/knotted)
	user.knotted_status = FALSE
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(user, COMSIG_LIVING_DISARM_PRESHOVE)
	user.remove_status_effect(/datum/status_effect/knotted)
	return ..()

/mob/living/can_speak(allow_mimes = FALSE) // do not allow bottom to speak while knotted orally
	if(src.knotted_parts["mouth"])
		return FALSE
	return ..()

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
	tick_interval = 100 // every 10 seconds
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
	// Might want a better description to show who you are tied to
	desc = "I have to be careful where I step... Click to remove all knots"
	// need to steal this from Scarlet or get an artist to make it
	//icon_state = "knotted"

/datum/status_effect/knotted/tick()
	if(!owner.knotted_parts["mouth"])
		return
	owner.adjustOxyLoss(1) // 120 health, -1 oxy per second, probably pretty close to a good value

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
			UnregisterSignal(partner, COMSIG_MOVABLE_MOVED)
			UnregisterSignal(partner, COMSIG_LIVING_DISARM_PRESHOVE)
			partner.remove_status_effect(/datum/status_effect/knotted)
	user.knotted_status = FALSE
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(user, COMSIG_LIVING_DISARM_PRESHOVE)
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
