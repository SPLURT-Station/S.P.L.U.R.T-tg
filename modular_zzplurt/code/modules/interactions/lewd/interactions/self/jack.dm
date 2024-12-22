/datum/interaction/lewd/jack
	command = "jack"
	description = "Jerk yourself off."
	interaction_sound = null
	require_user_hands = TRUE
	require_user_penis = REQUIRE_EXPOSED
	user_is_target = TRUE
	max_distance = 0
	write_log_user = "jerked off"
	write_log_target = null

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

	playlewdinteractionsound(get_turf(user), pick('modular_sand/sound/interactions/bang1.ogg',
						'modular_sand/sound/interactions/bang2.ogg',
						'modular_sand/sound/interactions/bang3.ogg'), 70, 1, -1)
	user.visible_message(message = "<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, user)
