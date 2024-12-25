/datum/interaction/lewd/titgrope_self
	description = "Grope your own breasts."
	required_from_user = INTERACTION_REQUIRE_HANDS
	required_from_user_exposed = INTERACTION_REQUIRE_BREASTS
	required_from_user_unexposed = INTERACTION_REQUIRE_BREASTS
	interaction_flags = INTERACTION_FLAG_OOC_CONSENT | INTERACTION_FLAG_USER_IS_TARGET
	interaction_sound = null
	max_distance = 0
	write_log_user = "groped own breasts"
	write_log_target = null

/datum/interaction/lewd/titgrope_self/display_interaction(mob/living/user)
	var/message
	var/t_His = user.p_their()

	if(user.combat_mode == INTENT_HARM)
		message = "[pick("aggressively gropes [t_His] breast.",
					"grabs [t_His] breasts.",
					"tightly squeezes [t_His] breasts.",
					"slaps at [t_His] breasts.",
					"gropes [t_His] breasts roughly.")]"
	else
		message = "[pick("gently gropes [t_His] breast.",
					"softly squeezes [t_His] breasts.",
					"grips [t_His] breasts.",
					"runs a few fingers over [t_His] breast.",
					"delicately teases [t_His] nipple.",
					"traces a touch across [t_His] breast.")]"
	if(prob(5 + user.get_lust()))
		user.visible_message("<span class='lewd'><b>\The [user]</b> [pick("shivers in arousal.",
				"moans quietly.",
				"breathes out a soft moan.",
				"gasps.",
				"shudders softly.",
				"trembles as [t_His] hands run across bare skin.")]</span>")
	user.visible_message(message = "<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	playlewdinteractionsound(get_turf(user), 'modular_zzplurt/sound/interactions/squelch1.ogg', 50, 1, -1)
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, user)


/datum/interaction/lewd/self_nipsuck
	description = "Suck your own nips."
	required_from_user = INTERACTION_REQUIRE_MOUTH
	required_from_user_exposed = INTERACTION_REQUIRE_BREASTS
	interaction_flags = INTERACTION_FLAG_OOC_CONSENT | INTERACTION_FLAG_USER_IS_TARGET
	interaction_sound = null
	max_distance = 0
	write_log_user = "sucked their own nips"
	write_log_target = null

/datum/interaction/lewd/self_nipsuck/display_interaction(mob/living/user, mob/living/target)
	var/message
	var/u_His = user.p_their()
	var/obj/item/organ/external/genital/breasts/milkers = user.get_organ_slot(ORGAN_SLOT_BREASTS)
	var/datum/reagent/consumable/milktype = milkers?.internal_fluid_datum
	var/modifier
	var/list/lines

	if(!milkers || !milktype)
		return

	var/milktext = initial(milktype.name)

	lines = list(
		"brings [u_His] own milk tanks to [u_His] mouth and sucks deeply into them",
		"takes a big sip of [u_His] own fresh [lowertext(milktext)]",
		"fills [u_His] own mouth with a big gulp of [u_His] warm [lowertext(milktext)]"
	)

	message = "<span class='lewd'>\The <b>[user]</b> [pick(lines)]</span>"
	user.visible_message(message, ignored_mobs = user.get_unconsenting())
	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/oral1.ogg',
						'modular_zzplurt/sound/interactions/oral2.ogg'), 70, 1, -1)

	switch(GLOB.breast_size_translation["[milkers.genital_size]"])
		if(BREAST_SIZE_C, BREAST_SIZE_D, BREAST_SIZE_E)
			modifier = 2
		if(BREAST_SIZE_F, BREAST_SIZE_G, BREAST_SIZE_H)
			modifier = 3
		if(BREAST_SIZE_I)
			modifier = 4
		if(BREAST_SIZE_J)
			modifier = 5
		else
			modifier = 1

	user.reagents.add_reagent(milktype, rand(1,3 * modifier))

