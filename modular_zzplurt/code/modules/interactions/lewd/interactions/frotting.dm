/datum/interaction/lewd/frotting
	command = "frotting"
	description = "Rub your penis against theirs"
	require_user_penis = REQUIRE_EXPOSED
	require_target_penis = REQUIRE_EXPOSED
	max_distance = 1
	write_log_user = "frotted"
	write_log_target = "was frotted by"
	interaction_sound = null

/datum/interaction/lewd/frotting/display_interaction(mob/living/user, mob/living/partner)
	var/message
	var/t_His = user.p_their()

	message = "rubs [t_His] penis against [partner]'s."
	user.set_is_fucking(partner, CUM_TARGET_PENIS, user.get_organ_slot(ORGAN_SLOT_PENIS))
	user.visible_message("<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_PENIS, partner)
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_PENIS, user)

/datum/interaction/lewd/tribadism
	command = "tribadism"
	description = "Grind your pussy against theirs."
	interaction_sound = null
	require_target_vagina = REQUIRE_EXPOSED
	require_user_vagina = REQUIRE_EXPOSED
	max_distance = 1

/datum/interaction/lewd/tribadism/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()

	if(partner.is_fucking(user, CUM_TARGET_VAGINA))
		message = "[pick("grinds [u_His] pussy against \the <b>[partner]</b>'s cunt.",
			"rubs [u_His] cunt against \the <b>[partner]</b>'s pussy.",
			"thrusts against \the <b>[partner]</b>'s pussy.",
			"humps \the <b>[partner]</b>, [u_His] pussies grinding against each other.")]"
	else
		message = "presses [u_His] pussy into \the <b>[partner]</b>'s own."
		partner.set_is_fucking(user, CUM_TARGET_VAGINA, partner.get_organ_slot(ORGAN_SLOT_VAGINA))
	playlewdinteractionsound(get_turf(user), pick('modular_sand/sound/interactions/squelch1.ogg',
						'modular_sand/sound/interactions/squelch2.ogg',
						'modular_sand/sound/interactions/squelch3.ogg'), 70, 1, -1)
	user.visible_message("<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_VAGINA, user)
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_VAGINA, partner)
