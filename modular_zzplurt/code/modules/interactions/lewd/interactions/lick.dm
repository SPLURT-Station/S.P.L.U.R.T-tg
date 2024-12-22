/datum/interaction/lewd/rimjob
	command = "rimjob"
	description = "Lick their ass."
	interaction_sound = null
	require_user_mouth = TRUE
	require_target_anus = REQUIRE_EXPOSED
	max_distance = 1

/datum/interaction/lewd/rimjob/display_interaction(mob/living/user, mob/living/partner)
	user.visible_message("<span class='lewd'><b>\The [user]</b> licks \the <b>[partner]</b>'s asshole.</span>", ignored_mobs = user.get_unconsenting())
	playlewdinteractionsound(get_turf(user), 'modular_zzplurt/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	partner.handle_post_sex(NORMAL_LUST, null, user)

/datum/interaction/lewd/lickfeet
	command = "lickfeet"
	description = "Lick their feet."
	interaction_sound = null
	require_user_mouth = TRUE
	require_target_feet = REQUIRE_ANY
	require_target_num_feet = 1
	max_distance = 1

/datum/interaction/lewd/lickfeet/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/shoes = partner.get_shoes()

	if(shoes)
		message = "licks \the <b>[partner]</b>'s [shoes]."
	else
		message = "licks \the <b>[partner]</b>'s [partner.has_feet() == 1 ? "foot" : "feet"]."

	playlewdinteractionsound(get_turf(user), 'modular_zzplurt/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	user.visible_message("<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	user.handle_post_sex(LOW_LUST, null, user)
