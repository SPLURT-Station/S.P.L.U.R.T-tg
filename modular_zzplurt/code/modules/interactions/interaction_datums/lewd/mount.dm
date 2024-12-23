/datum/interaction/lewd/mount
	description = "Mount with your pussy."
	interaction_sound = null
	require_user_vagina = REQUIRE_EXPOSED
	require_target_penis = REQUIRE_EXPOSED
	max_distance = 1

/datum/interaction/lewd/mount/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()

	if(partner.is_fucking(user, CUM_TARGET_VAGINA))
		message = "[pick("rides \the <b>[partner]</b>'s dick.",
			"forces <b>[partner]</b>'s cock on [u_His] pussy")]"
	else
		message = "slides [u_His] pussy onto \the <b>[partner]</b>'s cock."
		partner.set_is_fucking(user, CUM_TARGET_VAGINA, partner.get_organ_slot(ORGAN_SLOT_PENIS))
	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg'), 70, 1, -1)
	user.visible_message("<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_VAGINA, user)
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_PENIS, partner)

/datum/interaction/lewd/mountass
	description = "Mount with your ass."
	interaction_sound = null
	require_user_anus = REQUIRE_EXPOSED
	require_target_penis = REQUIRE_EXPOSED
	max_distance = 1

/datum/interaction/lewd/mountass/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()

	if(partner.is_fucking(user, CUM_TARGET_ANUS))
		message = "[pick("rides \the <b>[partner]</b>'s dick.",
			"forces <b>[partner]</b>'s cock on [u_His] ass")]"
	else
		message = "lowers [u_His] ass onto \the <b>[partner]</b>'s cock."
		partner.set_is_fucking(user, CUM_TARGET_ANUS, partner.get_organ_slot(ORGAN_SLOT_PENIS))
	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg'), 70, 1, -1)
	user.visible_message("<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_ANUS, user)
	user.handle_post_sex(NORMAL_LUST, null, partner)

/datum/interaction/lewd/mountface
	description = "Ass to face."
	interaction_sound = null
	require_target_mouth = TRUE
	require_user_anus = REQUIRE_EXPOSED
	max_distance = 1

/datum/interaction/lewd/mountface/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()

	if(user.is_fucking(partner, GRINDING_FACE_WITH_ANUS))
		message = "[pick("grinds [u_His] ass into \the <b>[partner]</b>'s face.",
			"shoves [u_His] ass into \the <b>[partner]</b>'s face.")]"
	else
		message = "[pick(
			"grabs the back of \the <b>[partner]</b>'s head and forces it into [u_His] asscheeks.",
			"squats down and plants [u_His] ass right on \the <b>[partner]</b>'s face")]"
		user.set_is_fucking(partner, GRINDING_FACE_WITH_ANUS, null)

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/squelch1.ogg',
						'modular_zzplurt/sound/interactions/squelch2.ogg',
						'modular_zzplurt/sound/interactions/squelch3.ogg'), 70, 1, -1)
	user.visible_message("<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	user.handle_post_sex(LOW_LUST, null, partner)

/datum/interaction/lewd/thighs
	description = "Smother them using your penis."
	max_distance = 1
	require_user_penis = REQUIRE_EXPOSED
	require_target_mouth = TRUE
	interaction_sound = null
	write_log_user = "thigh-trapped (penis)"
	write_log_target = "was smothered (penis) by"
	var/fucktarget = "penis"

/datum/interaction/lewd/thighs/vagina
	description = "Smother them using your vagina."
	require_user_penis = REQUIRE_NONE
	require_user_vagina = REQUIRE_EXPOSED
	write_log_user = "thigh-trapped (vagina)"
	write_log_target = "was smothered (vagina) by"
	fucktarget = "vagina"

/datum/interaction/lewd/thighs/display_interaction(mob/living/user, mob/living/partner)
	var/message
	var/obj/item/organ/external/genital/genital = null
	var/lust_increase = 1

	var/u_His = user.p_their()
	var/t_His = partner.p_their()
	var/t_Him = partner.p_them()
	var/t_Hes = partner.p_theyre()

	if(user.is_fucking(partner, THIGH_SMOTHERING))
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(user.has_vagina())
					message = pick(list(
						"presses [u_His] weight down onto \the <b>[partner]</b>'s face, blocking [t_His] vision completely.",
						"rides \the <b>[partner]</b>'s face, grinding [u_His] wet pussy all over it."))
				else
					improv = TRUE
			if("penis")
				if(user.has_penis())
					message = pick(list("presses [u_His] weight down onto \the <b>[partner]</b>'s face, blocking [t_His] vision completely.",
						"forces [u_His] dick and nutsack into \the <b>[partner]</b>'s face as [t_Hes] stuck locked in between [u_His] thighs.",
						"slips [u_His] cock into \the <b>[partner]</b>'s helpless mouth, keeping [u_His] shaft pressed hard into [t_His] face."))
				else
					improv = TRUE
		if(improv)
			message = "rubs [u_His] groin up and down \the <b>[partner]</b>'s face."
	else
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(user.has_vagina())
					message = pick(list(
						"clambers over \the <b>[partner]</b>'s face and pins [t_Him] down with [u_His] thighs, [u_His] moist slit rubbing all over \the <b>[partner]</b>'s mouth and nose.",
						"locks [u_His] legs around \the <b>[partner]</b>'s head before pulling it into [u_His] mound."))
				else
					improv = TRUE
			if("penis")
				if(user.has_penis())
					message = pick(list(
						"clambers over \the <b>[partner]</b>'s face and pins [t_Him] down with [u_His] thighs, then slowly inching closer and covering [t_His] eyes and nose with [u_His] leaking erection.",
						"locks [u_His] legs around \the <b>[partner]</b>'s head before pulling it into [u_His] fat package, smothering [t_Him]."))
				else
					improv = TRUE
		if(improv)
			message = "deviously locks [u_His] legs around \the <b>[partner]</b>'s head and smothers it in [u_His] thighs."
		else
			switch(fucktarget)
				if("vagina")
					genital = partner.get_organ_slot(ORGAN_SLOT_VAGINA)
				if("penis")
					genital = partner.get_organ_slot(ORGAN_SLOT_PENIS)
		user.set_is_fucking(partner, THIGH_SMOTHERING, genital)

	var/file = pick('modular_zzplurt/sound/interactions/bj10.ogg',
					'modular_zzplurt/sound/interactions/bj3.ogg',
					'modular_zzplurt/sound/interactions/foot_wet1.ogg',
					'modular_zzplurt/sound/interactions/foot_dry3.ogg')
	playlewdinteractionsound(get_turf(user), file, 70, 1, -1)
	user.visible_message("<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	user.handle_post_sex(lust_increase, THIGH_SMOTHERING, partner)
	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/oral1.ogg',
						'modular_zzplurt/sound/interactions/oral2.ogg'), 70, 1, -1)
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_MOUTH, partner)
