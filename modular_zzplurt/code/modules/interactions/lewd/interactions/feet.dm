/datum/interaction/lewd/grindface
	command = "grindface"
	description = "Feet grind their face."
	interaction_sound = null
	require_target_mouth = TRUE
	require_user_num_feet = 1
	require_user_feet = REQUIRE_ANY
	max_distance = 1

/datum/interaction/lewd/grindface/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()
	var/t_His = partner.p_their()

	var/shoes = user.get_shoes()

	if(user.is_fucking(partner, GRINDING_FACE_WITH_FEET))
		if(shoes)
			message = "[pick(list("grinds [u_His] [shoes] into <b>[partner]</b>'s face.",
				"presses [u_His] footwear down hard on <b>[partner]</b>'s face.",
				"rubs off the dirt from [u_His] [shoes] onto <b>[partner]</b>'s face."))]</span>"
		else
			message = "[pick(list("grinds [u_His] bare feet into <b>[partner]</b>'s face.",
				"deviously covers <b>[partner]</b>'s mouth and nose with [u_His] bare feet.",
				"runs the soles of [u_His] bare feet against <b>[partner]</b>'s lips."))]</span>"

	else if(user.is_fucking(partner, GRINDING_MOUTH_WITH_FEET))
		if(shoes)
			message = "[pick(list("pulls [u_His] [shoes] out of <b>[partner]</b>'s mouth and puts them on [t_His] face.",
				"slowly retracts [u_His] [shoes] from <b>[partner]</b>'s mouth, putting them on [t_His] face instead."))]</span>"
		else
			message = "[pick(list("pulls [u_His] bare feet out of <b>[partner]</b>'s mouth and rests them on [t_His] face instead.",
				"retracts [u_His] bare feet from <b>[partner]</b>'s mouth and grinds them into [t_His] face instead."))]</span>"

		user.set_is_fucking(partner, GRINDING_FACE_WITH_FEET, null)

	else
		if(shoes)
			message = "[pick(list("plants [u_His] [shoes] ontop of <b>[partner]</b>'s face.",
				"rests [u_His] [shoes] on <b>[partner]</b>'s face and presses down hard.",
				"harshly places [u_His] [shoes] atop <b>[partner]</b>'s face."))]</span>"
		else
			message = "[pick(list("plants [u_His] bare feet ontop of <b>[partner]</b>'s face.",
				"rests [u_His] feet on <b>[partner]</b>'s face, smothering them.",
				"positions [u_His] bare feet atop <b>[partner]</b>'s face."))]</span>"

		user.set_is_fucking(partner, GRINDING_FACE_WITH_FEET, null)

	playlewdinteractionsound(get_turf(user), pick('modular_sand/sound/interactions/foot_dry1.ogg',
						'modular_sand/sound/interactions/foot_dry2.ogg',
						'modular_sand/sound/interactions/foot_dry3.ogg',
						'modular_sand/sound/interactions/foot_dry4.ogg'), 70, 1, -1)
	user.visible_message(message = "<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	partner.handle_post_sex(LOW_LUST, null, user)

/datum/interaction/lewd/grindmouth
	command = "grindmouth"
	description = "Feet grind their mouth."
	interaction_sound = null
	require_target_mouth = TRUE
	require_user_num_feet = 1
	require_user_feet = REQUIRE_ANY
	max_distance = 1

/datum/interaction/lewd/grindmouth/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()
	var/t_His = partner.p_their()
	var/t_Him = partner.p_them()
	var/t_He = partner.p_they()
	var/t_S = partner.p_s()

	var/shoes = user.get_shoes()

	if(user.is_fucking(partner, GRINDING_MOUTH_WITH_FEET))
		if(shoes)
			message = "[pick(list("roughly shoves [u_His] [shoes] deeper into <b>[partner]</b>'s mouth.",
				"harshly forces another inch of [u_His] [shoes] into <b>[partner]</b>'s mouth.",
				"presses [u_His] weight down, [u_His] [shoes] prying deeper into <b>[partner]</b>'s mouth."))]</span>"
		else
			message = "[pick(list("wiggles [u_His] toes deep inside <b>[partner]</b>'s mouth.",
				"crams [u_His] barefeet down deeper into <b>[partner]</b>'s mouth, making [t_Him] gag.",
				"roughly grinds [u_His] feet on <b>[partner]</b>'s tongue."))]</span>"

	else if(user.is_fucking(partner, GRINDING_FACE_WITH_FEET))
		if(shoes)
			message = "[pick(list("decides to force [u_His] [shoes] deep into <b>[partner]</b>'s mouth.",
				"pressed the tip of [u_His] [shoes] against <b>[partner]</b>'s lips and shoves inwards."))]</span>"
		else
			message = "[pick(list("pries open <b>[partner]</b>'s mouth with [u_His] toes and shoves [u_His] bare foot in.",
				"presses down [u_His] foot even harder, cramming [u_His] foot into <b>[partner]</b>'s mouth."))]</span>"

		user.set_is_fucking(partner, GRINDING_MOUTH_WITH_FEET, null)

	else
		if(shoes)
			message = "[pick(list("readies themselves and in one swift motion, shoves [u_His] [shoes] into <b>[partner]</b>'s mouth.",
				"grinds the tip of [u_His] [shoes] against <b>[partner]</b>'s mouth before pushing themselves in."))]</span>"
		else
			message = "[pick(list("rubs [u_His] dirty bare feet across <b>[partner]</b>'s face before prying them into [t_His] muzzle.",
				"forces [u_His] barefeet into <b>[partner]</b>'s mouth.",
				"covers <b>[partner]</b>'s mouth and nose with [u_His] foot until [t_He] gasp[t_S] for breath, then shoves both feet inside before [t_He] can react."))]</span>"
		user.set_is_fucking(partner, GRINDING_MOUTH_WITH_FEET, null)

	playlewdinteractionsound(get_turf(user), pick('modular_sand/sound/interactions/foot_wet1.ogg',
						'modular_sand/sound/interactions/foot_wet2.ogg',
						'modular_sand/sound/interactions/foot_wet3.ogg'), 70, 1, -1)
	user.visible_message(message = "<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	partner.handle_post_sex(LOW_LUST, null, user)

/datum/interaction/lewd/footjob
	command = "footjob"
	description = "Jerk them off with your foot."
	interaction_sound = null
	require_user_num_feet = 1
	require_user_feet = REQUIRE_ANY
	require_target_penis = REQUIRE_EXPOSED
	max_distance = 1

/datum/interaction/lewd/footjob/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()

	var/shoes = user.get_shoes(TRUE)

	if(partner.is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("jerks \the <b>[partner]</b> off with [u_His] [shoes ? shoes : pick("foot", "sole")].",
			"rubs [u_His] [shoes ? shoes : pick("foot", "sole", "toes")] on \the <b>[partner]</b>'s shaft.",
			"works [u_His] [shoes ? shoes : pick("foot", "sole")] up and down on \the <b>[partner]</b>'s cock.")]"
	else
		message = "[pick("[shoes ? "positions [u_His] [shoes] on" :"positions [u_His] foot on"] \the <b>[partner]</b>'s cock.",
			"starts playing around with \the <b>[partner]</b>'s cock, using [u_His] [shoes ? shoes :"foot"].")]"
		partner.set_is_fucking(user, CUM_TARGET_FEET, partner.get_organ_slot(ORGAN_SLOT_PENIS))

	playlewdinteractionsound(get_turf(user), pick('modular_sand/sound/interactions/foot_dry1.ogg',
						'modular_sand/sound/interactions/foot_dry3.ogg',
						'modular_sand/sound/interactions/foot_wet1.ogg',
						'modular_sand/sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	user.visible_message(message = "<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, user)

/datum/interaction/lewd/footjob/double
	command = "footjob_double"
	description = "Jerk them off with both of your feet."
	require_user_num_feet = 2

/datum/interaction/lewd/footjob/double/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()

	var/shoes = user.get_shoes()

	if(partner.is_fucking(user, CUM_TARGET_FEET))
		message = "[pick("jerks \the <b>[partner]</b> off with [u_His] [shoes ? shoes : pick("feet", "soles")].",
			"rubs [u_His] [shoes ? shoes : pick("feet", "soles")] on \the <b>[partner]</b>'s shaft.",
			"rubs [shoes ? "[u_His] [shoes]" : "all of [u_His] toes"] on \the <b>[partner]</b>'s cock.",
			"works [u_His] [shoes ? shoes : pick("feet", "soles")] up and down on \the <b>[partner]</b>'s cock.")]"
	else
		message = "[pick("[shoes ? "wraps [u_His] [shoes] around" : "wraps [u_His] [pick("feet", "soles")] around"] \the <b>[partner]</b>'s cock.",
			"starts playing around with \the <b>[partner]</b>'s cock, using [u_His] [shoes ? shoes : "feet"].")]"
		partner.set_is_fucking(user, CUM_TARGET_FEET, partner.get_organ_slot(ORGAN_SLOT_PENIS))

	playlewdinteractionsound(get_turf(user), pick('modular_sand/sound/interactions/foot_dry1.ogg',
						'modular_sand/sound/interactions/foot_dry3.ogg',
						'modular_sand/sound/interactions/foot_wet1.ogg',
						'modular_sand/sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	user.visible_message(message = "<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, user)

/datum/interaction/lewd/footjob/vagina
	command = "footjob_vaginal"
	description = "Rub their vagina with your foot."
	require_target_vagina = REQUIRE_EXPOSED
	require_target_penis = null

/datum/interaction/lewd/footjob/vagina/display_interaction(mob/living/user, mob/living/partner)
	var/message

	var/u_His = user.p_their()

	var/shoes = partner.get_shoes(TRUE)

	if(partner.is_fucking(user, CUM_TARGET_FEET))
		message = "[pick("rubs \the <b>[partner]</b> clit with [u_His] [shoes ? shoes : pick("foot", "sole")].",
			"rubs [u_His] [shoes ? shoes : pick("foot", "sole", "toes")] on \the <b>[partner]</b>'s coochie.",
			"rubs [u_His] [shoes ? shoes : pick("foot", "sole", "toes")] on \the <b>[partner]</b>'s vagina.",
			"rubs [u_His] foot up and down on \the <b>[partner]</b>'s pussy.")]"
	else
		message = "[pick("[shoes ? "positions [u_His] [shoes] on" : "positions [u_His] foot on"] \the <b>[partner]</b>'s pussy.",
			"starts playing around with \the <b>[partner]</b>'s pussy, using [u_His] [shoes ? shoes : "foot"].")]"
		partner.set_is_fucking(user, CUM_TARGET_FEET, partner.get_organ_slot(ORGAN_SLOT_VAGINA))

	playlewdinteractionsound(get_turf(user), pick('modular_sand/sound/interactions/foot_dry1.ogg',
						'modular_sand/sound/interactions/foot_dry3.ogg',
						'modular_sand/sound/interactions/foot_wet1.ogg',
						'modular_sand/sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	user.visible_message(message = "<span class='lewd'><b>\The [user]</b> [message]</span>", ignored_mobs = user.get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, user)
