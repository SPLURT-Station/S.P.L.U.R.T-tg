/datum/interaction/lewd/handjob
	command = "handjob"
	description = "Jerk them off."
	interaction_sound = null
	require_user_hands = TRUE
	require_target_penis = REQUIRE_EXPOSED
	max_distance = 1

/datum/interaction/lewd/handjob/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()

	if(partner.is_fucking(user, CUM_TARGET_HAND))
		message = "[pick("jerks \the <b>[partner]</b> off.",
			"works \the <b>[partner]</b>'s shaft.",
			"wanks \the <b>[partner]</b>'s cock hard.")]"
	else
		message = "[pick("wraps [u_His] hand around \the <b>[partner]</b>'s cock.",
			"starts playing with \the <b>[partner]</b>'s cock")]"
		partner.set_is_fucking(user, CUM_TARGET_HAND, partner.get_organ_slot(ORGAN_SLOT_PENIS))

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg'), 70, 1, -1)
	user.visible_message("<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, user)
