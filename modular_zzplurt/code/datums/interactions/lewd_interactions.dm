// If I could have gotten away with using a tilde in the type path, I would have.
/datum/interaction/lewd
	description = null
	simple_style = "lewd"
	interaction_flags = INTERACTION_FLAG_ADJACENT | INTERACTION_FLAG_OOC_CONSENT

	/// Use the number of required feet.
	var/require_user_num_feet
	var/require_target_num_feet

	/// Time before actions can be done again
	var/user_refractory_cost
	var/target_refractory_cost

/datum/interaction/lewd/evaluate_user(mob/living/user, silent = TRUE, action_check = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if((interaction_flags & INTERACTION_FLAG_USER_NOT_TIRED) && !COOLDOWN_FINISHED(user, refractory_period))
		if(!silent) //bye spam
			to_chat(user, span_warning("You're still exhausted from the last time. You need to wait [DisplayTimeText(COOLDOWN_TIMELEFT(user, refractory_period), 1)] until you can do that!"))
		return FALSE

	if((required_from_user & INTERACTION_REQUIRE_BOTTOMLESS) && !user.is_bottomless())
		if(!silent)
			to_chat(user, span_warning("Your pants are in the way."))
		return FALSE

	if((required_from_user & INTERACTION_REQUIRE_TOPLESS) && !user.is_topless())
		if(!silent)
			to_chat(user, span_warning("Your top is in the way."))
		return FALSE

	var/user_require_penis_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_PENIS)
	var/user_require_penis_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_PENIS)
	if(user_require_penis_exposed || user_require_penis_unexposed)
		var/has_penis = user.has_penis() || user.has_strapon()
		if(!has_penis)
			if(!silent)
				to_chat(user, span_warning("You don't have a penis."))
			return FALSE

		// Special behavior for things like non-humans and if both sides are allowed
		if(!(user_require_penis_exposed && user_require_penis_unexposed))
			if(!(has_penis == TRUE))
				if((user_require_penis_exposed) && has_penis == HAS_UNEXPOSED_GENITAL)
					if(!silent)
						to_chat(user, span_warning("Your penis need to be exposed."))
					return FALSE
				if((user_require_penis_unexposed) && has_penis == HAS_EXPOSED_GENITAL)
					if(!silent)
						to_chat(user, span_warning("Your penis need to be unexposed."))
					return FALSE

	var/user_require_balls_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_BALLS)
	var/user_require_balls_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_BALLS)
	if(user_require_balls_exposed || user_require_balls_unexposed)
		var/has_balls = user.has_balls()
		if(!has_balls)
			if(!silent)
				to_chat(user, span_warning("You don't have balls."))
			return FALSE

		if(!(user_require_balls_exposed && user_require_balls_unexposed))
			if(!(has_balls == TRUE))
				if((user_require_balls_exposed) && has_balls == HAS_UNEXPOSED_GENITAL)
					if(!silent)
						to_chat(user, span_warning("Your balls need to be exposed."))
					return FALSE
				if((user_require_balls_unexposed) && has_balls == HAS_EXPOSED_GENITAL)
					if(!silent)
						to_chat(user, span_warning("Your balls need to be unexposed."))
					return FALSE

	var/user_require_anus_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_ANUS)
	var/user_require_anus_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_ANUS)
	if(user_require_anus_exposed || user_require_anus_unexposed)
		var/has_anus = user.has_anus()
		if(!has_anus)
			if(!silent)
				to_chat(user, span_warning("You don't have an anus."))
			return FALSE

		if(!(user_require_anus_exposed && user_require_anus_unexposed))
			if(!(has_anus == TRUE))
				if(user_require_anus_exposed && has_anus == HAS_UNEXPOSED_GENITAL)
					if(!silent)
						to_chat(user, span_warning("Your anus needs to be exposed."))
					return FALSE
				if(user_require_anus_unexposed && has_anus == HAS_EXPOSED_GENITAL)
					if(!silent)
						to_chat(user, span_warning("Your anus needs to be unexposed."))
					return FALSE

	var/user_require_vagina_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_VAGINA)
	var/user_require_vagina_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_VAGINA)
	if(user_require_vagina_exposed || user_require_vagina_unexposed)
		var/has_vagina = user.has_vagina()
		if(!has_vagina)
			if(!silent)
				to_chat(user, span_warning("You don't have a vagina."))
			return FALSE

		if(!(user_require_vagina_exposed && user_require_vagina_unexposed))
			if(!(has_vagina == TRUE))
				if(user_require_vagina_exposed && has_vagina == HAS_UNEXPOSED_GENITAL)
					if(!silent)
						to_chat(user, span_warning("Your vagina needs to be exposed."))
					return FALSE
				if(user_require_vagina_unexposed && has_vagina == HAS_EXPOSED_GENITAL)
					if(!silent)
						to_chat(user, span_warning("Your vagina needs to be unexposed."))
					return FALSE

	var/user_require_breasts_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_BREASTS)
	var/user_require_breasts_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_BREASTS)
	if(user_require_breasts_exposed || user_require_breasts_unexposed)
		var/has_breasts = user.has_breasts()
		if(!has_breasts)
			if(!silent)
				to_chat(user, span_warning("You don't have breasts."))
			return FALSE

		if(!(user_require_breasts_exposed && user_require_breasts_unexposed))
			if(!(has_breasts == TRUE))
				if(user_require_breasts_exposed && has_breasts == HAS_UNEXPOSED_GENITAL)
					if(!silent)
						to_chat(user, span_warning("Your breasts need to be exposed."))
					return FALSE
				if(user_require_breasts_unexposed && has_breasts == HAS_EXPOSED_GENITAL)
					if(!silent)
						to_chat(user, span_warning("Your breasts need to be unexposed."))
					return FALSE

	var/user_require_feet_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_FEET)
	var/user_require_feet_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_FEET)
	if(user_require_feet_exposed || user_require_feet_unexposed)
		var/has_feet = user.has_feet()
		if(!has_feet)
			if(!silent)
				to_chat(user, span_warning("You don't have feet."))
			return FALSE

		if(!(user_require_feet_exposed && user_require_feet_unexposed))
			if(user_require_feet_exposed && has_feet == HAS_UNEXPOSED_GENITAL)
				if(!silent)
					to_chat(user, span_warning("Your feet need to be exposed."))
				return FALSE
			if(user_require_feet_unexposed && has_feet == HAS_EXPOSED_GENITAL)
				if(!silent)
					to_chat(user, span_warning("Your feet need to be unexposed."))
				return FALSE

	if(require_user_num_feet && (user.get_num_feet() < require_user_num_feet))
		if(!silent)
			to_chat(user, span_warning("You don't have enough feet."))
		return FALSE

	var/user_require_eyes_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_EYES)
	var/user_require_eyes_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_EYES)
	if(user_require_eyes_exposed || user_require_eyes_unexposed)
		var/has_eyes = user.has_eyes()
		if(!user.getorganslot(ORGAN_SLOT_EYES))
			if(!silent)
				to_chat(user, span_warning("You don't have eyes."))
			return FALSE

		if(!(user_require_eyes_exposed && user_require_eyes_unexposed))
			if(user_require_eyes_exposed && has_eyes == HAS_UNEXPOSED_GENITAL)
				if(!silent)
					to_chat(user, span_warning("Your eyes need to be exposed."))
				return FALSE
			if(user_require_eyes_unexposed && has_eyes == HAS_EXPOSED_GENITAL)
				if(!silent)
					to_chat(user, span_warning("Your eyes need to be unexposed."))
				return FALSE

	var/user_require_eyesockets_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_EYESOCKETS)
	var/user_require_eyesockets_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_EYESOCKETS)
	if(user_require_eyesockets_exposed || user_require_eyesockets_unexposed)
		var/has_eyes = user.has_eyes()
		if(user.getorganslot(ORGAN_SLOT_EYES))
			if(!silent)
				to_chat(user, span_warning("You have eyes!"))
			return FALSE

		if(!(user_require_eyesockets_exposed && user_require_eyesockets_unexposed))
			if(user_require_eyesockets_exposed && has_eyes == HAS_UNEXPOSED_GENITAL)
				if(!silent)
					to_chat(user, span_warning("Your eyesockets need to be exposed."))
				return FALSE
			if(user_require_eyesockets_unexposed && has_eyes == HAS_EXPOSED_GENITAL)
				if(!silent)
					to_chat(user, span_warning("Your eyesockets need to be unexposed."))
				return FALSE

	var/user_require_ear_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_EARS)
	var/user_require_ear_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_EARS)
	if(user_require_ear_exposed || user_require_ear_unexposed)
		var/has_ears = user.has_ears()
		if(!user.getorganslot(ORGAN_SLOT_EARS))
			if(!silent)
				to_chat(user, span_warning("You don't have ears."))
			return FALSE

		if(!(user_require_ear_exposed && user_require_ear_unexposed))
			if(user_require_ear_exposed && has_ears == HAS_UNEXPOSED_GENITAL)
				if(!silent)
					to_chat(user, span_warning("Your ears need to be exposed."))
				return FALSE
			if(user_require_ear_unexposed && has_ears == HAS_EXPOSED_GENITAL)
				if(!silent)
					to_chat(user, span_warning("Your ears need to be unexposed."))
				return FALSE

	var/user_require_earsockets_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_EARSOCKETS)
	var/user_require_earsockets_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_EARSOCKETS)
	if(user_require_earsockets_exposed || user_require_earsockets_unexposed)
		var/has_ears = user.has_ears()
		if(user.getorganslot(ORGAN_SLOT_EARS))
			if(!silent)
				to_chat(user, span_warning("You have ears!"))
			return FALSE

		if(!(user_require_earsockets_exposed && user_require_earsockets_unexposed))
			if(user_require_earsockets_exposed && has_ears == HAS_UNEXPOSED_GENITAL)
				if(!silent)
					to_chat(user, span_warning("Your earsockets need to be exposed."))
				return FALSE
			if(user_require_earsockets_unexposed && has_ears == HAS_EXPOSED_GENITAL)
				if(!silent)
					to_chat(user, span_warning("Your earsockets need to be unexposed."))
				return FALSE

	if(interaction_flags & INTERACTION_FLAG_EXTREME_CONTENT)
		var/client/cli = user.client
		if(cli)
			if(cli.prefs.extremepref == "No")
				if(!silent)
					to_chat(user, span_warning("That's way too much for you."))
				return FALSE

	if(interaction_flags & INTERACTION_FLAG_OOC_CONSENT)
		if((!user.ckey) || (user.client && user.client.prefs.toggles & VERB_CONSENT))
			return TRUE
		if(action_check)
			return FALSE
	return FALSE

/datum/interaction/lewd/evaluate_target(mob/living/user, mob/living/target, silent = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if((required_from_target & INTERACTION_FLAG_TARGET_NOT_TIRED) && !COOLDOWN_FINISHED(target, refractory_period))
		if(!silent) //same with this
			to_chat(user, span_warning("They're still exhausted from the last time. They need to wait [DisplayTimeText(COOLDOWN_TIMELEFT(target, refractory_period), 1)] until you can do that!"))
		return FALSE

	if((required_from_target & INTERACTION_REQUIRE_BOTTOMLESS) && !target.is_bottomless())
		if(!silent)
			to_chat(user, span_warning("Their pants are in the way."))
		return FALSE

	if((required_from_target & INTERACTION_REQUIRE_TOPLESS) && !target.is_bottomless())
		if(!silent)
			to_chat(user, span_warning("Their clothes are in the way."))
		return FALSE

	var/target_require_penis_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_PENIS)
	var/target_require_penis_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_PENIS)
	if(target_require_penis_exposed || target_require_penis_unexposed)
		var/has_penis = target.has_penis() || target.has_strapon()
		if(!has_penis)
			if(!silent)
				to_chat(target, span_warning("They don't have a penis."))
			return FALSE

		if(!(target_require_penis_exposed && target_require_penis_unexposed))
			if(!(has_penis == TRUE))
				if(target_require_penis_exposed && has_penis == HAS_UNEXPOSED_GENITAL)
					if(!silent)
						to_chat(target, span_warning("Their penis needs to be exposed."))
					return FALSE
				if(target_require_penis_unexposed && has_penis == HAS_EXPOSED_GENITAL)
					if(!silent)
						to_chat(target, span_warning("Their penis needs to be unexposed."))
					return FALSE

	var/target_require_balls_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_BALLS)
	var/target_require_balls_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_BALLS)
	if(target_require_balls_exposed || target_require_balls_unexposed)
		var/has_balls = target.has_balls()
		if(!has_balls)
			if(!silent)
				to_chat(target, span_warning("They don't have balls."))
			return FALSE

		if(!(target_require_balls_exposed && target_require_balls_unexposed))
			if(!(has_balls == TRUE))
				if(target_require_balls_exposed && has_balls == HAS_UNEXPOSED_GENITAL)
					if(!silent)
						to_chat(target, span_warning("Their balls need to be exposed."))
					return FALSE
				if(target_require_balls_unexposed && has_balls == HAS_EXPOSED_GENITAL)
					if(!silent)
						to_chat(target, span_warning("Their balls need to be unexposed."))
					return FALSE

	var/target_require_anus_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_ANUS)
	var/target_require_anus_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_ANUS)
	if(target_require_anus_exposed || target_require_anus_unexposed)
		var/has_anus = target.has_anus()
		if(!has_anus)
			if(!silent)
				to_chat(target, span_warning("They don't have an anus."))
			return FALSE

		if(!(target_require_anus_exposed && target_require_anus_unexposed))
			if(!(has_anus == TRUE))
				if(target_require_anus_exposed && has_anus == HAS_UNEXPOSED_GENITAL)
					if(!silent)
						to_chat(target, span_warning("Their anus needs to be exposed."))
					return FALSE
				if(target_require_anus_unexposed && has_anus == HAS_EXPOSED_GENITAL)
					if(!silent)
						to_chat(target, span_warning("Their anus needs to be unexposed."))
					return FALSE

	var/target_require_vagina_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_VAGINA)
	var/target_require_vagina_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_VAGINA)
	if(target_require_vagina_exposed || target_require_vagina_unexposed)
		var/has_vagina = target.has_vagina()
		if(!has_vagina)
			if(!silent)
				to_chat(target, span_warning("They don't have a vagina."))
			return FALSE

		if(!(target_require_vagina_exposed && target_require_vagina_unexposed))
			if(!(has_vagina == TRUE))
				if(target_require_vagina_exposed && has_vagina == HAS_UNEXPOSED_GENITAL)
					if(!silent)
						to_chat(target, span_warning("Their vagina needs to be exposed."))
					return FALSE
				if(target_require_vagina_unexposed && has_vagina == HAS_EXPOSED_GENITAL)
					if(!silent)
						to_chat(target, span_warning("Their vagina needs to be unexposed."))
					return FALSE

	var/target_require_breasts_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_BREASTS)
	var/target_require_breasts_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_BREASTS)
	if(target_require_breasts_exposed || target_require_breasts_unexposed)
		var/has_breasts = target.has_breasts()
		if(!has_breasts)
			if(!silent)
				to_chat(target, span_warning("They don't have breasts."))
			return FALSE

		if(!(target_require_breasts_exposed && target_require_breasts_unexposed))
			if(!(has_breasts == TRUE))
				if(target_require_breasts_exposed && has_breasts == HAS_UNEXPOSED_GENITAL)
					if(!silent)
						to_chat(target, span_warning("Their breasts need to be exposed."))
					return FALSE
				if(target_require_breasts_unexposed && has_breasts == HAS_EXPOSED_GENITAL)
					if(!silent)
						to_chat(target, span_warning("Their breasts need to be unexposed."))
					return FALSE

	var/target_require_feet_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_FEET)
	var/target_require_feet_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_FEET)
	if(target_require_feet_exposed || target_require_feet_unexposed)
		var/has_feet = target.has_feet()
		if(!has_feet)
			if(!silent)
				to_chat(target, span_warning("They don't have feet."))
			return FALSE

		if(!(target_require_feet_exposed && target_require_feet_unexposed))
			if(target_require_feet_exposed && has_feet == HAS_UNEXPOSED_GENITAL)
				if(!silent)
					to_chat(target, span_warning("Their feet need to be exposed."))
				return FALSE
			if(target_require_feet_unexposed && has_feet == HAS_EXPOSED_GENITAL)
				if(!silent)
					to_chat(target, span_warning("Their feet need to be unexposed."))
				return FALSE

	if(require_target_num_feet && (target.get_num_feet() < require_target_num_feet))
		if(!silent)
			to_chat(target, span_warning("They don't have enough feet."))
		return FALSE

	var/target_require_eyes_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_EYES)
	var/target_require_eyes_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_EYES)
	if(target_require_eyes_exposed || target_require_eyes_unexposed)
		var/has_eyes = target.has_eyes()
		if(!target.getorganslot(ORGAN_SLOT_EYES))
			if(!silent)
				to_chat(target, span_warning("They don't have eyes."))
			return FALSE

		if(!(target_require_eyes_exposed && target_require_eyes_unexposed))
			if(target_require_eyes_exposed && has_eyes == HAS_UNEXPOSED_GENITAL)
				if(!silent)
					to_chat(target, span_warning("Their eyes need to be exposed."))
				return FALSE
			if(target_require_eyes_unexposed && has_eyes == HAS_EXPOSED_GENITAL)
				if(!silent)
					to_chat(target, span_warning("Their eyes need to be unexposed."))
				return FALSE

	var/target_require_eyesockets_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_EYESOCKETS)
	var/target_require_eyesockets_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_EYESOCKETS)
	if(target_require_eyesockets_exposed || target_require_eyesockets_unexposed)
		var/has_eyes = target.has_eyes()
		if(target.getorganslot(ORGAN_SLOT_EYES))
			if(!silent)
				to_chat(target, span_warning("They have eyes!"))
			return FALSE

		if(!(target_require_eyesockets_exposed && target_require_eyesockets_unexposed))
			if(target_require_eyesockets_exposed && has_eyes == HAS_UNEXPOSED_GENITAL)
				if(!silent)
					to_chat(target, span_warning("Their eyesockets need to be exposed."))
				return FALSE
			if(target_require_eyesockets_unexposed && has_eyes == HAS_EXPOSED_GENITAL)
				if(!silent)
					to_chat(target, span_warning("Their eyesockets need to be unexposed."))
				return FALSE

	var/target_require_ears_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_EARS)
	var/target_require_ears_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_EARS)
	if(target_require_ears_exposed || target_require_ears_unexposed)
		var/has_ears = target.has_ears()
		if(!target.getorganslot(ORGAN_SLOT_EARS))
			if(!silent)
				to_chat(target, span_warning("They don't have ears."))
			return FALSE

		if(!(target_require_ears_exposed && target_require_ears_unexposed))
			if(target_require_ears_exposed && has_ears == HAS_UNEXPOSED_GENITAL)
				if(!silent)
					to_chat(target, span_warning("Their ears need to be exposed."))
				return FALSE
			if(target_require_ears_unexposed && has_ears == HAS_EXPOSED_GENITAL)
				if(!silent)
					to_chat(target, span_warning("Their ears need to be unexposed."))
				return FALSE

	var/target_require_earsockets_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_EARSOCKETS)
	var/target_require_earsockets_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_EARSOCKETS)
	if(target_require_earsockets_exposed || target_require_earsockets_unexposed)
		var/has_ears = target.has_ears()
		if(target.getorganslot(ORGAN_SLOT_EARS))
			if(!silent)
				to_chat(target, span_warning("They have ears!"))
			return FALSE

		if(!(target_require_earsockets_exposed && target_require_earsockets_unexposed))
			if(target_require_earsockets_exposed && has_ears == HAS_UNEXPOSED_GENITAL)
				if(!silent)
					to_chat(target, span_warning("Their earsockets need to be exposed."))
				return FALSE
			if(target_require_earsockets_unexposed && has_ears == HAS_EXPOSED_GENITAL)
				if(!silent)
					to_chat(target, span_warning("Their earsockets need to be unexposed."))
				return FALSE

	if(interaction_flags & INTERACTION_FLAG_EXTREME_CONTENT)
		var/client/cli = target.client
		if(cli)
			if(target.client.prefs.extremepref == "No")
				if(!silent)
					to_chat(user, span_warning("For some reason, you don't want to do this to [target]."))
				return FALSE

	if(interaction_flags & INTERACTION_FLAG_OOC_CONSENT)
		if((!target.ckey) || (target.client && target.client.prefs.toggles & VERB_CONSENT))
			return TRUE
	return FALSE

/datum/interaction/lewd/post_interaction(mob/living/user, mob/living/target)
	if(user_refractory_cost)
		COOLDOWN_START(user, refractory_period, user_refractory_cost*10)
	if(target_refractory_cost)
		COOLDOWN_START(target, refractory_period, target_refractory_cost*10)
	user.last_lewd_datum = src
	if(user.cleartimer)
		deltimer(user.cleartimer)
	user.cleartimer = addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, clear_lewd_datum)), 300, TIMER_STOPPABLE)
	return ..()

/mob/living/list_interaction_attributes(mob/living/LM)
	. = ..()
	if(!COOLDOWN_FINISHED(LM, refractory_period))
		. += "...are sexually exhausted for the time being."
	switch(a_intent)
		if(INTENT_HELP)
			. += "...are acting gentle."
		if(INTENT_DISARM)
			. += "...are acting playful."
		if(INTENT_GRAB)
			. += "...are acting rough."
		if(INTENT_HARM)
			. += "...are fighting anyone who comes near."
	//Here comes the fucking weird shit.
	if(client)
		var/client/cli = client
		var/client/ucli = LM.client
		if(cli.prefs.extremepref != "No")
			if(!ucli || (ucli.prefs.extremepref != "No"))
				if(!get_item_by_slot(ITEM_SLOT_EARS_LEFT) && !get_item_by_slot(ITEM_SLOT_EARS_RIGHT))
					if(has_ears())
						. += "...have unprotected ears."
					else
						. += "...have a hole where their ears should be."
				else
					. += "...have covered ears."
				if(!get_item_by_slot(ITEM_SLOT_EYES))
					if(has_eyes())
						. += "...have exposed eyes."
					else
						. += "...have exposed eyesockets."
				else
					. += "...have covered eyes."
	//
	// check those loops only once, thanks
	var/is_topless = is_topless()
	var/is_bottomless = is_bottomless()
	if(is_topless && is_bottomless)
		. += "...are naked."
	else
		if((is_topless && !is_bottomless) || (!is_topless && is_bottomless))
			. += "...are partially clothed."
		else
			. += "...are clothed."
	if(has_breasts() == HAS_EXPOSED_GENITAL)
		. += "...have breasts."
	if(has_penis() == HAS_EXPOSED_GENITAL)
		. += "...have a penis."
	if(has_strapon() == HAS_EXPOSED_GENITAL)
		. += "...have a strapon."
	if(has_balls() == HAS_EXPOSED_GENITAL)
		. += "...have a ballsack."
	if(has_vagina() == HAS_EXPOSED_GENITAL)
		. += "...have a vagina."
	if(has_anus() == HAS_EXPOSED_GENITAL)
		. += "...have an anus."
	if(has_feet() == HAS_EXPOSED_GENITAL)
		switch(get_num_feet())
			if(2)
				. += "...have a pair of feet."
			if(1)
				. += "...have a single foot."
