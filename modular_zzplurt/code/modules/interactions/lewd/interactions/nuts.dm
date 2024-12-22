/datum/interaction/lewd/nuts
	command = "nut_face"
	description = "Nuts to face."
	interaction_sound = null
	require_user_balls = REQUIRE_EXPOSED
	require_target_mouth = TRUE
	max_distance = 1
	write_log_user = "make-them-suck-their-nuts"
	write_log_target = "was made to suck nuts by"

/datum/interaction/lewd/nuts/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()
	var/t_His = partner.p_their()

	var/lust_increase = 1

	if(user.is_fucking(partner, NUTS_TO_FACE))
		message = pick(list(
			"grabs the back of <b>[partner]</b>'s head and pulls it into [u_His] crotch.",
			"jams [u_His] nutsack right into <b>[partner]</b>'s face.",
			"roughly grinds [u_His] fat nutsack into <b>[partner]</b>'s mouth.",
			"pulls out [u_His] saliva-covered nuts from <b>[partner]</b>'s violated mouth and then wipes off the slime onto [t_His] face."))
	else
		message = pick(list("wedges a digit into the side of <b>[partner]</b>'s jaw and pries it open before using [u_His] other hand to shove [u_His] whole nutsack inside!", "stands with [u_His] groin inches away from [partner]'s face, then thrusting [u_His] hips forward and smothering [partner]'s whole face with [u_His] heavy ballsack."))
		user.set_is_fucking(partner, NUTS_TO_FACE, user.get_organ_slot(ORGAN_SLOT_PENIS))

	/*playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/nuts1.ogg',
						'modular_zzplurt/sound/interactions/nuts2.ogg',
						'modular_zzplurt/sound/interactions/nuts3.ogg',
						'modular_zzplurt/sound/interactions/nuts4.ogg'), 70, 1, -1)*/ //These files don't even exist but nobody noticed because double-quotes were used instead of single.
	user.visible_message("<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	user.handle_post_sex(lust_increase, CUM_TARGET_MOUTH, partner)

/datum/interaction/lewd/nut_smack
	command = "smack_nuts"
	description = "Smack their nuts."
	interaction_sound = 'modular_zzplurt/sound/interactions/slap.ogg'
	simple_message = "USER slaps TARGET's nuts!"
	require_target_balls = REQUIRE_EXPOSED
	needs_physical_contact = TRUE
	max_distance = 1
	write_log_user = "slapped-nuts"
	write_log_target = "had their nuts slapped by"
