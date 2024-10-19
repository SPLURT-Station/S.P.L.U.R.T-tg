//help
/datum/interaction/lewd
	var/require_user_legs
	var/require_user_num_legs

	var/require_target_legs
	var/require_target_num_legs

/datum/interaction/lewd/evaluate_user(mob/living/user, silent = TRUE, action_check = TRUE)

	var/user_require_belly_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_BELLY)
	var/user_require_belly_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_BELLY)
	if(user_require_belly_exposed || user_require_belly_unexposed)
		var/has_belly = user.has_belly()
		if(!has_belly)
			if(!silent)
				to_chat(user, span_warning("You don't have a belly."))
			return FALSE

		if(!(has_belly == TRUE) || !(user_require_belly_exposed && user_require_belly_unexposed))
			if(user_require_belly_exposed && has_belly == HAS_UNEXPOSED_GENITAL)
				if(!silent)
					to_chat(user, span_warning("Your belly needs to be exposed."))
				return FALSE
			if(user_require_belly_unexposed && has_belly == HAS_EXPOSED_GENITAL)
				if(!silent)
					to_chat(user, span_warning("Your belly need to be unexposed."))
				return FALSE

	if(require_user_legs)
		switch(require_user_legs)
			if(REQUIRE_EXPOSED)
				if(!user.has_legs(REQUIRE_EXPOSED))
					if(!silent)
						to_chat(user, span_warning("Your legs need to be exposed."))
					return FALSE
			if(REQUIRE_UNEXPOSED)
				if(!user.has_legs(REQUIRE_UNEXPOSED))
					if(!silent)
						to_chat(user, span_warning("Your legs need to be unexposed."))
					return FALSE
			if(REQUIRE_ANY)
				if(!user.has_legs(REQUIRE_ANY))
					if(!silent)
						to_chat(user, span_warning("You don't have enough legs."))
					return FALSE

	if(require_user_num_legs && (user.has_legs() < require_user_num_legs))
		if(!silent)
			to_chat(user, span_warning("Your don't have enough legs."))
		return FALSE


	if(interaction_flags & INTERACTION_FLAG_UNHOLY_CONTENT)
		var/client/cli = user.client
		if(cli)
			if(cli.prefs.unholypref == "No")
				if(!silent)
					to_chat(user, "<span class='warning'>That's way too much for you.</span>")
				return FALSE

	var/user_require_penis_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_PENIS)
	var/user_require_penis_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_PENIS)
	if(user_require_penis_exposed || user_require_penis_unexposed)
		var/obj/item/organ/genital/penis/penor = user.getorganslot(ORGAN_SLOT_PENIS)
		if(CHECK_BITFIELD(penor?.genital_flags, GENITAL_CHASTENED))
			if(!silent)
				to_chat(user, "<span class='warning>You can't do anything with your [pick(GLOB.dick_nouns)] like this!")
			return FALSE

	var/user_require_vagina_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_VAGINA)
	var/user_require_vagina_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_VAGINA)
	if(user_require_vagina_exposed || user_require_vagina_unexposed)
		var/obj/item/organ/genital/vagina/puss = user.getorganslot(ORGAN_SLOT_VAGINA)
		if(CHECK_BITFIELD(puss?.genital_flags, GENITAL_CHASTENED))
			if(!silent)
				to_chat(user, "<span class='warning>You can't do anything with your vagina like this!")
			return FALSE

	var/user_require_anus_exposed = !!(required_from_user_exposed & INTERACTION_REQUIRE_ANUS)
	var/user_require_anus_unexposed = !!(required_from_user_unexposed & INTERACTION_REQUIRE_ANUS)
	if(user_require_anus_exposed || user_require_anus_unexposed)
		var/obj/item/organ/genital/anus/holi = user.getorganslot(ORGAN_SLOT_ANUS)
		if(holi)
			if(CHECK_BITFIELD(holi?.genital_flags, GENITAL_CHASTENED))
				if(!silent)
					to_chat(user, "<span class='warning>You can't do anything with your [pick(GLOB.butt_nouns)] like this!")
				return FALSE
		else
			if(HAS_TRAIT(user, TRAIT_CHASTENED_ANUS))
				if(!silent)
					to_chat(user, "<span class='warning>You can't do anything with your [pick(GLOB.butt_nouns)] like this!")
				return FALSE
	. = ..()

/datum/interaction/lewd/evaluate_target(mob/living/user, mob/living/target, silent = TRUE)
	var/target_require_belly_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_BELLY)
	var/target_require_belly_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_BELLY)
	if(target_require_belly_exposed || target_require_belly_unexposed)
		var/has_belly = target.has_belly()
		if(!has_belly)
			if(!silent)
				to_chat(target, span_warning("They don't have a belly."))
			return FALSE

		if(!(has_belly == TRUE) || !(target_require_belly_exposed && target_require_belly_unexposed))
			if(target_require_belly_exposed && has_belly == HAS_UNEXPOSED_GENITAL)
				if(!silent)
					to_chat(target, span_warning("Their belly needs to be exposed."))
				return FALSE
			if(target_require_belly_unexposed && has_belly == HAS_EXPOSED_GENITAL)
				if(!silent)
					to_chat(target, span_warning("Their belly need to be unexposed."))
				return FALSE

	if(require_target_legs)
		switch(require_target_legs)
			if(REQUIRE_EXPOSED)
				if(!target.has_legs(REQUIRE_EXPOSED))
					if(!silent)
						to_chat(user, span_warning("[target.p_their()] legs need to be exposed."))
					return FALSE
			if(REQUIRE_UNEXPOSED)
				if(!target.has_legs(REQUIRE_UNEXPOSED))
					if(!silent)
						to_chat(user, span_warning("[target.p_their()] legs need to be unexposed."))
					return FALSE
			if(REQUIRE_ANY)
				if(!target.has_legs(REQUIRE_ANY))
					if(!silent)
						to_chat(user, span_warning("[target.p_they()] [target.p_do()]n't have enough legs."))
					return FALSE

	if(require_target_num_legs && (target.has_legs() < require_target_num_legs))
		if(!silent)
			to_chat(user, span_warning("[target.p_they()] [target.p_do()]n't have enough legs."))
		return FALSE

	if(interaction_flags & INTERACTION_FLAG_UNHOLY_CONTENT)
		var/client/cli = target.client
		if(cli)
			if(target.client.prefs.unholypref == "No")
				if(!silent)
					to_chat(user, "<span class='warning'>For some reason, you don't want to do this to [target].</span>")
				return FALSE

	var/target_require_penis_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_PENIS)
	var/target_require_penis_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_PENIS)
	if(target_require_penis_exposed || target_require_penis_unexposed)
		var/obj/item/organ/genital/penis/penor = target.getorganslot(ORGAN_SLOT_PENIS)
		if(CHECK_MULTIPLE_BITFIELDS(penor?.genital_flags, GENITAL_CHASTENED))
			if(!silent)
				to_chat(user, "<span class='warning>You can't do anything with their [pick(GLOB.dick_nouns)] like that!")
			return FALSE

	var/target_require_vagina_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_VAGINA)
	var/target_require_vagina_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_VAGINA)
	if(target_require_vagina_exposed || target_require_vagina_unexposed)
		var/obj/item/organ/genital/vagina/puss = target.getorganslot(ORGAN_SLOT_VAGINA)
		if(CHECK_BITFIELD(puss?.genital_flags, GENITAL_CHASTENED))
			if(!silent)
				to_chat(user, "<span class='warning>You can't do anything with their vagina like this!")
			return FALSE

	var/target_require_anus_exposed = !!(required_from_target_exposed & INTERACTION_REQUIRE_ANUS)
	var/target_require_anus_unexposed = !!(required_from_target_unexposed & INTERACTION_REQUIRE_ANUS)
	if(target_require_anus_exposed || target_require_anus_unexposed)
		if(HAS_TRAIT(target, TRAIT_CHASTENED_ANUS))
			if(!silent)
				to_chat(user, "<span class='warning>You can't do anything with their [pick(GLOB.butt_nouns)] like this!")
			return FALSE
	. = ..()

/mob/living/list_interaction_attributes(mob/living/LM)
	. = ..()
	if(has_belly() == HAS_EXPOSED_GENITAL)
		. += "...have a belly"
