/datum/interaction/lewd/nipsuck
	description = "Suck their nipples."
	required_from_user = INTERACTION_REQUIRE_MOUTH
	required_from_target_exposed = INTERACTION_REQUIRE_BREASTS
	write_log_user = "sucked nipples"
	write_log_target = "had their nipples sucked by"
	interaction_sound = null

/datum/interaction/lewd/nipsuck/display_interaction(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/user_message
	var/amount_high = 2
	switch(user.a_intent)
		if(INTENT_HELP, INTENT_DISARM)
			user_message = pick(span_lewd("\The <b>[user]</b> gently sucks on \the <b>[target]</b>'s [pick("nipple", "nipples")]."),
							span_lewd("\The <b>[user]</b> gently nibs \the <b>[target]</b>'s [pick("nipple", "nipples")]."),
							span_lewd("\The <b>[user]</b> licks \the <b>[target]</b>'s [pick("nipple", "nipples")]."))
		if(INTENT_HARM)
			amount_high = 3 // aggressive sucking has higher rewards
			user_message = pick(span_lewd("\The <b>[user]</b> bites \the <b>[target]</b>'s [pick("nipple", "nipples")]."),
							span_lewd("\The <b>[user]</b> aggressively sucks \the <b>[target]</b>'s [pick("nipple", "nipples")]."))
		if(INTENT_GRAB)
			amount_high = 3 // aggressive sucking has higher rewards
			user_message = pick(span_lewd("\The <b>[user]</b> sucks \the <b>[target]</b>'s [pick("nipple", "nipples")] intently."),
							span_lewd("\The <b>[user]</b> feasts \the <b>[target]</b>'s [pick("nipple", "nipples")]."),
							span_lewd("\The <b>[user]</b> glomps \the <b>[target]</b>'s [pick("nipple", "nipples")]."))
	user.visible_message(user_message)
	var/has_breasts = target.has_breasts()
	if(has_breasts == TRUE || has_breasts == HAS_EXPOSED_GENITAL)
		var/obj/item/organ/genital/breasts/B = target.getorganslot(ORGAN_SLOT_BREASTS)
		var/modifier = B?.get_lactation_amount_modifier() || 1
		if(B.fluid_id)
			user.reagents.add_reagent(B.fluid_id, rand(1,amount_high * modifier) * user.get_fluid_mod(B))

	if(prob(5 + target.get_lust()))
		switch(target.a_intent)
			if(INTENT_HELP)
				if(!target.has_breasts())
					user.visible_message(
						pick(span_lewd("\The <b>[target]</b> shivers in arousal."),
							span_lewd("\The <b>[target]</b> moans quietly."),
							span_lewd("\The <b>[target]</b> breathes out a soft moan."),
							span_lewd("\The <b>[target]</b> gasps."),
							span_lewd("\The <b>[target]</b> shudders softly."),
							span_lewd("\The <b>[target]</b> trembles as their chest gets molested.")))
				else
					user.visible_message(
						pick(span_lewd("\The <b>[target]</b> shivers in arousal."),
							span_lewd("\The <b>[target]</b> moans quietly."),
							span_lewd("\The <b>[target]</b> breathes out a soft moan."),
							span_lewd("\The <b>[target]</b> gasps."),
							span_lewd("\The <b>[target]</b> shudders softly."),
							span_lewd("\The <b>[target]</b> trembles as their breasts get molested."),
							span_lewd("\The <b>[target]</b> quivers in arousal as \the <b>[user]</b> delights themselves on their milk.")))
				if(target.get_lust() < 5)
					target.handle_post_sex(5, CUM_TARGET_MOUTH, user, ORGAN_SLOT_BREASTS) //SPLURT edit
			if(INTENT_DISARM)
				if (target.restrained())
					if(!target.has_breasts())
						user.visible_message(
							pick(span_lewd("\The <b>[target]</b> twists playfully against the restraints."),
								span_lewd("\The <b>[target]</b> squirms away from \the <b>[user]</b>'s mouth."),
								span_lewd("\The <b>[target]</b> slides back from \the <b>[user]</b>'s mouth."),
								span_lewd("\The <b>[target]</b> thrusts their bare chest forward into \the <b>[user]</b>'s mouth.")))
					else
						user.visible_message(
							pick(span_lewd("\The <b>[target]</b> twists playfully against the restraints."),
								span_lewd("\The <b>[target]</b> squirms away from \the <b>[user]</b>'s mouth."),
								span_lewd("\The <b>[target]</b> slides back from \the <b>[user]</b>'s mouth."),
								span_lewd("\The <b>[target]</b> thrust their bare breasts forward into \the <b>[user]</b>'s mouth.")))
				else
					if(!target.has_breasts())
						user.visible_message(
							pick(span_lewd("\The <b>[target]</b> playfully shoos away \the <b>[user]</b>'s head."),
								span_lewd("\The <b>[target]</b> squirms away from \the <b>[user]</b>'s mouth."),
								span_lewd("\The <b>[target]</b> holds \the <b>[user]</b>'s head against their chest."),
								span_lewd("\The <b>[target]</b> teasingly caresses \the <b>[user]</b>'s neck.")))
					else
						user.visible_message(
							pick(span_lewd("\The <b>[target]</b> playfully shoos away \the <b>[user]</b>'s head."),
								span_lewd("\The <b>[target]</b> squirms away from \the <b>[user]</b>'s mouth."),
								span_lewd("\The <b>[target]</b> holds \the <b>[user]</b>'s head against their breast."),
								span_lewd("\The <b>[target]</b> teasingly caresses \the <b>[user]</b>'s neck."),
								span_lewd("\The <b>[target]</b> rubs their breasts against \the <b>[user]</b>'s head.")))
				if(target.get_lust() < 10)
					target.handle_post_sex(NORMAL_LUST, CUM_TARGET_MOUTH, user, ORGAN_SLOT_BREASTS) //SPLURT edit
			if(INTENT_GRAB)
				user.visible_message(
						pick(span_lewd("\The <b>[target]</b> grips \the <b>[user]</b>'s head tight."),
						span_lewd("\The <b>[target]</b> digs nails into \the <b>[user]</b>'s scalp."),
						span_lewd("\The <b>[target]</b> grabs and shoves \the <b>[user]</b>'s head away.")))
			if(INTENT_HARM)
				user.adjustBruteLoss(1)
				user.visible_message(
						pick(span_lewd("\The <b>[target]</b> slaps \the <b>[user]</b> away."),
						span_lewd("\The <b>[target]</b> scratches <b>[user]</b>'s face."),
						span_lewd("\The <b>[target]</b> fiercely struggles against <b>[user]</b>."),
						span_lewd("\The <b>[target]</b> claws <b>[user]</b>'s face, drawing blood."),
						span_lewd("\The <b>[target]</b> elbows <b>[user]</b>'s mouth away.")))
	target.dir = get_dir(target, user)
	user.dir = get_dir(user, target)
	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/oral1.ogg',
						'modular_zzplurt/sound/interactions/oral2.ogg'), 70, 1, -1)
	return
