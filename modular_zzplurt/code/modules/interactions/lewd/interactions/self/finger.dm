/datum/interaction/lewd/fingerass_self
	command = "fingerm_self"
	description = "Finger yourself."
	interaction_sound = null
	require_user_hands = TRUE
	require_user_anus = REQUIRE_EXPOSED
	user_is_target = TRUE
	max_distance = 0
	write_log_user = "fingered self"
	write_log_target = null

/datum/interaction/lewd/fingerass_self/display_interaction(mob/living/user)
	var/t_His = user.p_their()
	var/t_Him = user.p_them()

	user.visible_message("<span class='lewd'><b>\The [user]</b> [pick("fingers [t_Him]self.",
		"fingers [t_His] asshole.",
		"fingers [t_Him]self hard.")]</span>", ignored_mobs = user.get_unconsenting())
	playlewdinteractionsound(get_turf(user), 'modular_zzplurt/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, user)

/datum/interaction/lewd/finger_self
	command = "finger_self"
	description = "Finger your own pussy."
	require_user_hands = TRUE
	require_user_vagina = REQUIRE_EXPOSED
	interaction_sound = null
	user_is_target = TRUE
	max_distance = 0
	write_log_user = "fingered own pussy"
	write_log_target = null

/datum/interaction/lewd/finger_self/display_interaction(mob/living/user)
	var/t_His = user.p_their()

	user.visible_message("<span class='lewd'><b>\The [user]</b> [pick("fingers [t_His] pussy deep.",
		"fingers [t_His] pussy.",
		"plays with [t_His] pussy.",
		"fingers [t_His] own pussy hard.")]</span>", ignored_mobs = user.get_unconsenting())
	playlewdinteractionsound(get_turf(user), 'modular_zzplurt/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, user)
