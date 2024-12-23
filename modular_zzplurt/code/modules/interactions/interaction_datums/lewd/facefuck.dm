/datum/interaction/lewd/facefuck
	description = "Fuck their mouth using your penis"
	interaction_sound = null
	require_target_mouth = TRUE
	require_user_penis = REQUIRE_EXPOSED
	max_distance = 1
	var/fucktarget = "penis"

/datum/interaction/lewd/facefuck/vag
	description = "Fuck their mouth using your vagina"
	require_user_penis = null
	require_user_vagina = REQUIRE_EXPOSED
	fucktarget = "vagina"

/datum/interaction/lewd/facefuck/display_interaction(mob/living/user, mob/living/partner)
	var/message
	var/obj/item/organ/external/genital/genital = null
	var/retaliation_message = FALSE

	var/u_His = user.p_their()
	var/t_Him = partner.p_them()
	var/t_Hes = partner.p_theyre()

	if(user.is_fucking(partner, CUM_TARGET_MOUTH))
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(user.has_vagina())
					message = pick(
						"grinds [u_His] pussy into \the <b>[partner]</b>'s face.",
						"grips the back of \the <b>[partner]</b>'s head, forcing [t_Him] onto [u_His] pussy.",
						"rolls [u_His] pussy against \the <b>[partner]</b>'s tongue.",
						"slides \the <b>[partner]</b>'s mouth between [u_His] legs.",
						"looks \the <b>[partner]</b>'s in the eyes as [u_His] pussy presses into a waiting tongue.",
						"sways [u_His] hips, pushing [u_His] sex into \the <b>[partner]</b>'s face.",
						)
					if(partner.combat_mode == INTENT_HARM)
						// adjustBruteLoss(5)
						retaliation_message = pick(
							"looks deeply displeased to be there.",
							"struggles to escape from between \the [user]'s thighs.",
						)
				else
					improv = TRUE
			if("penis")
				if(user.has_penis())
					message = pick(
						"roughly fucks \the <b>[partner]</b>'s mouth.",
						"forces [u_His] cock down \the <b>[partner]</b>'s throat.",
						"pushes in against \the <b>[partner]</b>'s tongue until a tight gagging sound comes.",
						"grips \the <b>[partner]</b>'s hair and draws [t_Him] to the base of the cock.",
						"looks \the <b>[partner]</b>'s in the eyes as [u_His] cock presses into a waiting tongue.",
						"rolls [u_His] hips hard, sinking into \the <b>[partner]</b>'s mouth.",
						)
					if(partner.combat_mode == INTENT_HARM)
						// adjustBruteLoss(5)
						retaliation_message = pick(
							"stares up from between \the [user]'s knees, trying to squirm away.",
							"struggles to escape from between \the [user]'s legs.",
						)
				else
					improv = TRUE
		if(improv)
			message = pick(
				"grinds against \the <b>[partner]</b>'s face.",
				"feels \the <b>[partner]</b>'s face between bare legs.",
				"pushes in against \the <b>[partner]</b>'s tongue.",
				"grips \the <b>[partner]</b>'s hair, drawing [t_Him] into the strangely sexless spot between [u_His] legs.",
				"looks \the <b>[partner]</b>'s in the eyes as [t_Hes] caught beneath two thighs.",
				"rolls [u_His] hips hard against \the <b>[partner]</b>'s face.",
				)
			if(partner.combat_mode == INTENT_HARM)
				// adjustBruteLoss(5)
				retaliation_message = pick(
					"stares up from between \the [user]'s knees, trying to squirm away.",
					"struggles to escape from between \the [user]'s legs.",
				)
	else
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(user.has_vagina())
					message = "forces \the <b>[partner]</b>'s face into [u_His] pussy."
				else
					improv = TRUE
			if("penis")
				if(user.has_penis())
					if(user.is_fucking(partner, CUM_TARGET_THROAT))
						message = "retracts [u_His] cock from \the <b>[partner]</b>'s throat"
					else
						message = "shoves [u_His] cock into \the <b>[partner]</b>'s mouth"
				else
					improv = TRUE
		if(improv)
			message = "shoves [u_His] crotch into \the <b>[partner]</b>'s face."
		else
			switch(fucktarget)
				if("vagina")
					genital = partner.get_organ_slot(ORGAN_SLOT_VAGINA)
				if("penis")
					genital = partner.get_organ_slot(ORGAN_SLOT_PENIS)
		user.set_is_fucking(partner, CUM_TARGET_MOUTH, genital)

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/oral1.ogg',
						'modular_zzplurt/sound/interactions/oral2.ogg'), 70, 1, -1)
	user.visible_message("<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	if(retaliation_message)
		user.visible_message("<font color=red><b>\The <b>[partner]</b></b> [retaliation_message]</span>", ignored_mobs = user.get_unconsenting())
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_MOUTH, partner)

/datum/interaction/lewd/throatfuck
	description = "Fuck their throat. | Does oxy damage."
	interaction_sound = null
	require_user_penis = REQUIRE_EXPOSED
	require_target_mouth = TRUE
	max_distance = 1

/datum/interaction/lewd/throatfuck/display_interaction(mob/living/user, mob/living/partner)
	var/message
	var/obj/item/organ/external/genital/genital = null
	var/retaliation_message = FALSE

	var/u_His = user.p_their()
	var/t_His = partner.p_their()
	var/t_Him = partner.p_them()

	if(user.is_fucking(partner, CUM_TARGET_THROAT))
		message = "[pick(
			"brutally shoves [u_His] cock into \the <b>[partner]</b>'s throat to make [t_Him] gag.",
			"chokes \the <b>[partner]</b> on [u_His] dick, going in balls deep.",
			"slams in and out of \the <b>[partner]</b>'s mouth, [u_His] balls slapping off [t_His] face.")]"
		if(rand(3))
			partner.emote("chokes on \the [user]")
			if(prob(1) && istype(partner))
				partner.adjustOxyLoss(5)
		if(partner.combat_mode == INTENT_HARM)
			// adjustBruteLoss(5)
			retaliation_message = pick(
				"stares up from between \the [user]'s knees, trying to squirm away.",
				"struggles to escape from between \the [user]'s legs.",
			)
	else if(user.is_fucking(partner, CUM_TARGET_MOUTH))
		message = "thrusts deeper into \the <b>[partner]</b>'s mouth and down [t_His] throat."
		var/check = user.get_organ_slot(ORGAN_SLOT_PENIS)
		if(check)
			genital = check
		user.set_is_fucking(partner, CUM_TARGET_THROAT, genital)
	else
		message = "forces [u_His] dick deep down \the <b>[partner]</b>'s throat"
		var/check = user.get_organ_slot(ORGAN_SLOT_PENIS)
		if(check)
			genital = check
		user.set_is_fucking(partner, CUM_TARGET_THROAT, genital)

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/oral1.ogg',
						'modular_zzplurt/sound/interactions/oral2.ogg'), 70, 1, -1)
	user.visible_message(message = "<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	if(retaliation_message)
		user.visible_message(message = "<font color=red><b>\The <b>[partner]</b></b> [retaliation_message]</span>", ignored_mobs = user.get_unconsenting())
	user.handle_post_sex(NORMAL_LUST, CUM_TARGET_THROAT, partner)
