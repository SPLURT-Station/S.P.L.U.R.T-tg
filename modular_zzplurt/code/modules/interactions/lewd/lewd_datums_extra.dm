/datum/interaction/lewd/frotting
	command = "frotting"
	description = "Rub your penis against theirs"
	require_user_penis = REQUIRE_EXPOSED
	require_target_penis = REQUIRE_EXPOSED
	user_not_tired = TRUE
	max_distance = 1
	write_log_user = "frotted"
	write_log_target = "was frotted by"
	interaction_sound = null

/datum/interaction/lewd/frotting/display_interaction(mob/living/user, mob/living/target)
	user.do_frot(target)

/**
 * Self Interactions!
 */
/datum/interaction/lewd/jack
	command = "jack"
	description = "Jerk yourself off."
	interaction_sound = null
	require_user_hands = REQUIRE_ANY
	require_user_penis = REQUIRE_EXPOSED
	user_not_tired = TRUE
	user_is_target = TRUE
	max_distance = 0
	write_log_user = "jerked off"
	write_log_target = null

/datum/interaction/lewd/jack/display_interaction(mob/living/carbon/human/user)
	user.do_jackoff(user)

/datum/interaction/lewd/fingerass_self
	command = "fingerm_self"
	description = "Finger yourself."
	interaction_sound = null
	require_user_hands = TRUE
	require_user_anus = REQUIRE_EXPOSED
	user_not_tired = TRUE
	user_is_target = TRUE
	max_distance = 0
	write_log_user = "fingered self"
	write_log_target = null

/datum/interaction/lewd/fingerass_self/display_interaction(mob/living/carbon/human/user)
	user.do_fingerass_self(user)

/datum/interaction/lewd/finger_self
	command = "finger_self"
	description = "Finger your own pussy."
	require_user_hands = TRUE
	require_user_vagina = REQUIRE_EXPOSED
	interaction_sound = null
	user_not_tired = TRUE
	user_is_target = TRUE
	max_distance = 0
	write_log_user = "fingered own pussy"
	write_log_target = null

/datum/interaction/lewd/finger_self/display_interaction(mob/living/carbon/human/user)
	user.do_fingering_self(user)

/datum/interaction/lewd/titgrope_self
	command = "titgrope_self"
	description = "Grope your own breasts."
	require_user_hands = TRUE
	require_user_breasts = REQUIRE_ANY
	user_is_target = TRUE
	interaction_sound = null
	max_distance = 0
	write_log_user = "groped own breasts"
	write_log_target = null

/datum/interaction/lewd/titgrope_self/display_interaction(mob/living/carbon/human/user)
	user.do_titgrope_self(user)
