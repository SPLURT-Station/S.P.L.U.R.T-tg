/datum/interaction/lewd/jack
	description = "Jerk yourself off."
	interaction_sound = null
	required_from_user = INTERACTION_REQUIRE_HANDS
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS
	interaction_flags = INTERACTION_FLAG_OOC_CONSENT | INTERACTION_FLAG_USER_IS_TARGET
	max_distance = 0
	write_log_user = "jerked off"
	write_log_target = null
	additional_details = list(
		INTERACTION_FILLS_CONTAINERS
	)

/datum/interaction/lewd/jack/display_interaction(mob/living/user)
	var/message
	var/t_His = user.p_their()
	var/t_Him = user.p_them()

	if(user.is_fucking(user, CUM_TARGET_HAND))
		message = "[pick("jerks [t_Him]self off.",
			"works [t_His] shaft.",
			"strokes [t_His] penis.",
			"wanks [t_His] cock hard.")]"
	else
		message = "[pick("wraps [t_His] hand around [t_His] cock.",
			"starts to stroke [t_His] cock.",
			"starts playing with [t_His] cock.")]"
		user.set_is_fucking(user, CUM_TARGET_HAND, user.get_organ_slot(ORGAN_SLOT_PENIS))

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg'), 70, 1, -1)
	user.visible_message(message = span_lewd("<b>\The [user]</b> [message]"), ignored_mobs = user.get_unconsenting())
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, user)
