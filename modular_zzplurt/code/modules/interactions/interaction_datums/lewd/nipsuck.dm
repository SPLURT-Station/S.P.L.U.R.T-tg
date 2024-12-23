/datum/interaction/lewd/nipsuck
	description = "Suck their nipples."
	required_from_user = INTERACTION_REQUIRE_MOUTH
	required_from_target_exposed = INTERACTION_REQUIRE_BREASTS
	write_log_user = "sucked nipples"
	write_log_target = "had their nipples sucked by"
	interaction_sound = null
	max_distance = 1

/datum/interaction/lewd/nipsuck/display_interaction(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if((user.combat_mode == INTENT_HELP) || (user.combat_mode == INTENT_DISARM))
		user.visible_message(
				pick("<span class='lewd'>\The <b>[user]</b> gently sucks on \the <b>[target]</b>'s [pick("nipple", "nipples")].</span>",
					"<span class='lewd'>\The <b>[user]</b> gently nibs \the <b>[target]</b>'s [pick("nipple", "nipples")].</span>",
					"<span class='lewd'>\The <b>[user]</b> licks \the <b>[target]</b>'s [pick("nipple", "nipples")].</span>"))
		var/has_breasts = target.has_breasts()
		if(has_breasts == TRUE || has_breasts == HAS_EXPOSED_GENITAL)
			var/modifier = 1
			var/obj/item/organ/external/genital/breasts/B = target.get_organ_slot(ORGAN_SLOT_BREASTS)
			switch(GLOB.breast_size_translation["[B.genital_size]"])
				if(BREAST_SIZE_C, BREAST_SIZE_D, BREAST_SIZE_E)
					modifier = 2
				if(BREAST_SIZE_F, BREAST_SIZE_G, BREAST_SIZE_H)
					modifier = 3
				if(BREAST_SIZE_I)
					modifier = 4
				if(BREAST_SIZE_J)
					modifier = 5
				else
					modifier = 1
			/*
			if(B.fluid_id)
				user.reagents.add_reagent(B.fluid_id, rand(1,2 * modifier))
			*/

	if(user.combat_mode == INTENT_HARM)
		user.visible_message(
				pick("<span class='lewd'>\The <b>[user]</b> bites \the <b>[target]</b>'s [pick("nipple", "nipples")].</span>",
					"<span class='lewd'>\The <b>[user]</b> aggressively sucks \the <b>[target]</b>'s [pick("nipple", "nipples")].</span>"))
		var/has_breasts = target.has_breasts()
		if(has_breasts == TRUE || has_breasts == HAS_EXPOSED_GENITAL)
			var/modifier = 1
			var/obj/item/organ/external/genital/breasts/B = target.get_organ_slot(ORGAN_SLOT_BREASTS)
			switch(GLOB.breast_size_translation["[B.genital_size]"])
				if(BREAST_SIZE_C, BREAST_SIZE_D, BREAST_SIZE_E)
					modifier = 2
				if(BREAST_SIZE_F, BREAST_SIZE_G, BREAST_SIZE_H)
					modifier = 3
				if(BREAST_SIZE_I)
					modifier = 4
				if(BREAST_SIZE_J)
					modifier = 5
				else
					modifier = 1
			/*
			if(B.fluid_id)
				user.reagents.add_reagent(B.fluid_id, rand(1,3 * modifier)) //aggressive sucking leads to high rewards
			*/

	if(user.combat_mode == INTENT_GRAB)
		user.visible_message(
				pick("<span class='lewd'>\The <b>[user]</b> sucks \the <b>[target]</b>'s [pick("nipple", "nipples")] intently.</span>",
					"<span class='lewd'>\The <b>[user]</b> feasts \the <b>[target]</b>'s [pick("nipple", "nipples")].</span>",
					"<span class='lewd'>\The <b>[user]</b> glomps \the <b>[target]</b>'s [pick("nipple", "nipples")].</span>"))
		var/has_breasts = target.has_breasts()
		if(has_breasts == TRUE || has_breasts == HAS_EXPOSED_GENITAL)
			var/modifier = 1
			var/obj/item/organ/external/genital/breasts/B = target.get_organ_slot(ORGAN_SLOT_BREASTS)
			switch(GLOB.breast_size_translation["[B.genital_size]"])
				if(BREAST_SIZE_C, BREAST_SIZE_D, BREAST_SIZE_E)
					modifier = 2
				if(BREAST_SIZE_F, BREAST_SIZE_G, BREAST_SIZE_H)
					modifier = 3
				if(BREAST_SIZE_I)
					modifier = 4
				if(BREAST_SIZE_J)
					modifier = 5
				else
					modifier = 1
			/*
			if(B.fluid_id)
				user.reagents.add_reagent(B.fluid_id, rand(1,3 * modifier)) //aggressive sucking leads to high rewards
			*/
	if(prob(5 + target.get_lust()))
		if(target.combat_mode == INTENT_HELP)
			if(!target.has_breasts())
				user.visible_message(
					pick("<span class='lewd'>\The <b>[target]</b> shivers in arousal.</span>",
						"<span class='lewd'>\The <b>[target]</b> moans quietly.</span>",
						"<span class='lewd'>\The <b>[target]</b> breathes out a soft moan.</span>",
						"<span class='lewd'>\The <b>[target]</b> gasps.</span>",
						"<span class='lewd'>\The <b>[target]</b> shudders softly.</span>",
						"<span class='lewd'>\The <b>[target]</b> trembles as their chest gets molested.</span>"))
			else
				user.visible_message(
					pick("<span class='lewd'>\The <b>[target]</b> shivers in arousal.</span>",
						"<span class='lewd'>\The <b>[target]</b> moans quietly.</span>",
						"<span class='lewd'>\The <b>[target]</b> breathes out a soft moan.</span>",
						"<span class='lewd'>\The <b>[target]</b> gasps.</span>",
						"<span class='lewd'>\The <b>[target]</b> shudders softly.</span>",
						"<span class='lewd'>\The <b>[target]</b> trembles as their breasts get molested.</span>",
						"<span class='lewd'>\The <b>[target]</b> quivers in arousal as \the <b>[user]</b> delights themselves on their milk.</span>"))
			if(target.get_lust() < 5)
				target.set_lust(5)
		if(target.combat_mode == INTENT_DISARM)
			if (target.restrained())
				if(!target.has_breasts())
					user.visible_message(
						pick("<span class='lewd'>\The <b>[target]</b> twists playfully against the restraints.</span>",
							"<span class='lewd'>\The <b>[target]</b> squirms away from \the <b>[user]</b>'s mouth.</span>",
							"<span class='lewd'>\The <b>[target]</b> slides back from \the <b>[user]</b>'s mouth.</span>",
							"<span class='lewd'>\The <b>[target]</b> thrusts their bare chest forward into \the <b>[user]</b>'s mouth.</span>"))
				else
					user.visible_message(
						pick("<span class='lewd'>\The <b>[target]</b> twists playfully against the restraints.</span>",
							"<span class='lewd'>\The <b>[target]</b> squirms away from \the <b>[user]</b>'s mouth.</span>",
							"<span class='lewd'>\The <b>[target]</b> slides back from \the <b>[user]</b>'s mouth.</span>",
							"<span class='lewd'>\The <b>[target]</b> thrust their bare breasts forward into \the <b>[user]</b>'s mouth.</span>"))
			else
				if(!target.has_breasts())
					user.visible_message(
						pick("<span class='lewd'>\The <b>[target]</b> playfully shoos away \the <b>[user]</b>'s head.</span>",
							"<span class='lewd'>\The <b>[target]</b> squirms away from \the <b>[user]</b>'s mouth.</span>",
							"<span class='lewd'>\The <b>[target]</b> holds \the <b>[user]</b>'s head against their chest.</span>",
							"<span class='lewd'>\The <b>[target]</b> teasingly caresses \the <b>[user]</b>'s neck.</span>"))
				else
					user.visible_message(
						pick("<span class='lewd'>\The <b>[target]</b> playfully shoos away \the <b>[user]</b>'s head.</span>",
							"<span class='lewd'>\The <b>[target]</b> squirms away from \the <b>[user]</b>'s mouth.</span>",
							"<span class='lewd'>\The <b>[target]</b> holds \the <b>[user]</b>'s head against their breast.</span>",
							"<span class='lewd'>\The <b>[target]</b> teasingly caresses \the <b>[user]</b>'s neck.</span>",
							"<span class='lewd'>\The <b>[target]</b> rubs their breasts against \the <b>[user]</b>'s head.</span>"))
			if(target.get_lust() < 10)
				target.add_lust(1)
	if(target.combat_mode == INTENT_GRAB)
		user.visible_message(
				pick("<span class='lewd'>\The <b>[target]</b> grips \the <b>[user]</b>'s head tight.</span>",
				 "<span class='lewd'>\The <b>[target]</b> digs nails into \the <b>[user]</b>'s scalp.</span>",
				 "<span class='lewd'>\The <b>[target]</b> grabs and shoves \the <b>[user]</b>'s head away.</span>"))
	if(target.combat_mode == INTENT_HARM)
		user.adjustBruteLoss(1)
		user.visible_message(
				pick("<span class='lewd'>\The <b>[target]</b> slaps \the <b>[user]</b> away.</span>",
				 "<span class='lewd'>\The <b>[target]</b> scratches <b>[user]</b>'s face.</span>",
				 "<span class='lewd'>\The <b>[target]</b> fiercely struggles against <b>[user]</b>.</span>",
				 "<span class='lewd'>\The <b>[target]</b> claws <b>[user]</b>'s face, drawing blood.</span>",
				 "<span class='lewd'>\The <b>[target]</b> elbows <b>[user]</b>'s mouth away.</span>"))
	target.dir = get_dir(target, user)
	user.dir = get_dir(user, target)
	playlewdinteractionsound(get_turf(user), pick('modular_zzplurt/sound/interactions/oral1.ogg',
						'modular_zzplurt/sound/interactions/oral2.ogg'), 70, 1, -1)
	return
