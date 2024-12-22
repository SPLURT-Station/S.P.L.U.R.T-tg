/datum/interaction/lewd/finger
	command = "finger"
	description = "Finger their pussy."
	require_user_hands = TRUE
	require_target_vagina = REQUIRE_EXPOSED
	interaction_sound = null
	max_distance = 1

/datum/interaction/lewd/finger/display_interaction(mob/living/user, mob/living/partner)
	user.visible_message(message = "<span class='lewd'><b>\The [user]</b> [pick("fingers \the <b>[partner]</b>.",
		"fingers \the <b>[partner]</b>'s pussy.",
		"fingers \the <b>[partner]</b> hard.")]</span>", ignored_mobs = user.get_unconsenting())
	playlewdinteractionsound(get_turf(user), 'modular_sand/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	partner.handle_post_sex(NORMAL_LUST, null, user)

/datum/interaction/lewd/fingerass
	command = "fingerm"
	description = "Finger their ass."
	interaction_sound = null
	require_user_hands = TRUE
	require_target_anus = REQUIRE_EXPOSED
	max_distance = 1

/datum/interaction/lewd/fingerass/display_interaction(mob/living/user, mob/living/partner)
	user.visible_message("<span class='lewd'><b>\The [user]</b> [pick("fingers \the <b>[partner]</b>.",
		"fingers \the <b>[partner]</b>'s asshole.",
		"fingers \the <b>[partner]</b> hard.")]</span>", ignored_mobs = user.get_unconsenting())
	playlewdinteractionsound(get_turf(user), 'modular_sand/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	partner.handle_post_sex(NORMAL_LUST, null, user)
