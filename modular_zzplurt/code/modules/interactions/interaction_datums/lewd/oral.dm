/datum/interaction/lewd/oral
	description = "Go down on them."
	require_user_mouth = TRUE
	require_target_vagina = REQUIRE_EXPOSED
	write_log_user = "gave head to"
	write_log_target = "was given head by"
	interaction_sound = null
	max_distance = 1
	var/fucktarget = "vagina"

/datum/interaction/lewd/oral/blowjob
	description = "Suck them off."
	require_target_vagina = null
	require_target_penis = REQUIRE_EXPOSED
	fucktarget = "penis"

/datum/interaction/lewd/oral/display_interaction(mob/living/user, mob/living/partner)
	var/message
	var/obj/item/organ/external/genital/genital = null
	var/lust_increase = NORMAL_LUST
	var/u_His = user.p_their()
	var/u_He = user.p_they()
	var/u_Were = user.p_theyre()

	if(partner.is_fucking(user, CUM_TARGET_MOUTH))
		if(prob(partner.get_sexual_potency()))
			user.adjustOxyLoss(3)
			message = "goes in deep on \the <b>[partner]</b>."
			lust_increase += 5
		else
			var/improv = FALSE
			switch(fucktarget)
				if("vagina")
					if(partner.has_vagina())
						message = pick(
							"licks \the <b>[partner]</b>'s pussy.",
							"runs [u_His] tongue up the shape of \the <b>[partner]</b>'s pussy.",
							"traces \the <b>[partner]</b>'s slit with [u_His] tongue.",
							"darts the tip of [u_His] tongue around \the <b>[partner]</b>'s clit.",
							"laps slowly at \the <b>[partner]</b>.",
							"kisses \the <b>[partner]</b>'s delicate folds.",
							"tastes \the <b>[partner]</b>.",
						)
					else
						improv = TRUE
				if("penis")
					if(partner.has_penis())
						message = pick(
							"sucks \the <b>[partner]</b>'s off.",
							"runs [u_His] tongue up the shape of \the <b>[partner]</b>'s cock.",
							"traces \the <b>[partner]</b>'s cock with [u_His] tongue.",
							"darts the tip of [u_His] tongue around tip of \the <b>[partner]</b>'s cock.",
							"laps slowly at \the <b>[partner]</b>'s shaft.",
							"kisses the base of \the <b>[partner]</b>'s shaft.",
							"takes \the <b>[partner]</b> deeper into [u_His] mouth.",
						)
					else
						improv = TRUE
			if(improv)
				// get confused about how to do the sex
				message = pick(
					"licks \the <b>[partner]</b>.",
					"looks a little unsure of where to lick \the <b>[partner]</b>.",
					"runs [u_His] tongue between \the <b>[partner]</b>'s legs.",
					"kisses \the <b>[partner]</b>'s thigh.",
					"tries [u_His] best with \the <b>[partner]</b>.",
				)
	else
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(partner.has_vagina())
					message = pick(
						"buries [u_His] face in \the <b>[partner]</b>'s pussy.",
						"nuzzles \the <b>[partner]</b>'s wet sex.",
						"finds [u_His] face caught between \the <b>[partner]</b>'s thighs.",
						"kneels down between \the <b>[partner]</b>'s legs.",
						"grips \the <b>[partner]</b>'s legs, pushing them apart.",
						"sinks [u_His] face in between \the <b>[partner]</b>'s thighs.",
					)
				else
					improv = TRUE
			if("penis")
				if(partner.has_penis())
					message = pick(
						"takes \the <b>[partner]</b>'s cock into [u_His] mouth.",
						"wraps [u_His] lips around \the <b>[partner]</b>'s cock.",
						"finds [u_His] face between \the <b>[partner]</b>'s thighs.",
						"kneels down between \the <b>[partner]</b>'s legs.",
						"grips \the <b>[partner]</b>'s legs, kissing at the tip of [u_His] cock.",
						"goes down on \the <b>[partner]</b>.",
					)
				else
					improv = TRUE
		if(improv)
			message = pick(
				"begins to lick \the <b>[partner]</b>.",
				"starts kissing \the <b>[partner]</b>'s thigh.",
				"sinks down between \the <b>[partner]</b>'s thighs.",
				"briefly flashes a puzzled look from between \the <b>[partner]</b>'s legs.",
				"looks unsure of how to handle \the <b>[partner]</b>'s lack of genitalia.",
				"seems like [u_He] [u_Were] expecting \the <b>[partner]</b> to have a cock or a pussy or ... something.",
			)
			genital = null
		else
			switch(fucktarget)
				if("vagina")
					genital = partner.get_organ_slot(ORGAN_SLOT_VAGINA)
				if("penis")
					genital = partner.get_organ_slot(ORGAN_SLOT_PENIS)
		partner.set_is_fucking(user, CUM_TARGET_MOUTH, genital)

	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/bj1.ogg',
									'modular_zzplurt/sound/interactions/bj2.ogg',
									'modular_zzplurt/sound/interactions/bj3.ogg',
									'modular_zzplurt/sound/interactions/bj4.ogg',
									'modular_zzplurt/sound/interactions/bj5.ogg',
									'modular_zzplurt/sound/interactions/bj6.ogg',
									'modular_zzplurt/sound/interactions/bj7.ogg',
									'modular_zzplurt/sound/interactions/bj8.ogg',
									'modular_zzplurt/sound/interactions/bj9.ogg',
									'modular_zzplurt/sound/interactions/bj10.ogg',
									'modular_zzplurt/sound/interactions/bj11.ogg'), 50, 1, -1)
	user.visible_message("<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	partner.handle_post_sex(lust_increase, CUM_TARGET_MOUTH, user)
