/mob/living
	var/has_belly = FALSE

/mob/living/has_anus()
	if(getorganslot(ORGAN_SLOT_ANUS))
		return has_genital(ORGAN_SLOT_ANUS)
	. = ..()

/mob/living/add_lust(add)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MOB_LUST_UPDATED)

/mob/living/set_lust(num)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MOB_LUST_UPDATED)

/mob/living/toggle_anus_always_accessible(accessibility)
	var/obj/item/organ/genital/anus/donut = getorganslot(ORGAN_SLOT_ANUS)
	if(donut)
		return donut.toggle_accessibility(accessibility)
	. = ..()

/mob/living/moan()
	var/moaned = lastmoan
	var/miming = mind ? mind?.miming : FALSE
	. = ..()
	if((moaned == lastmoan) || is_muzzled() || miming || !prob(50))
		return
	var/list/moans
	if(isalien(src))
		moans = list('sound/voice/hiss6.ogg')
	else if(gender == FEMALE)
		moans = list('modular_splurt/sound/voice/moan_f1.ogg', 'modular_splurt/sound/voice/moan_f2.ogg', 'modular_splurt/sound/voice/moan_f3.ogg', 'modular_splurt/sound/voice/moan_f4.ogg', 'modular_splurt/sound/voice/moan_f5.ogg', 'modular_splurt/sound/voice/moan_f6.ogg', 'modular_splurt/sound/voice/moan_f7.ogg')
	else
		moans = list('modular_splurt/sound/voice/moan_m1.ogg', 'modular_splurt/sound/voice/moan_m2.ogg', 'modular_splurt/sound/voice/moan_m3.ogg')
	playlewdinteractionsound(src, pick(moans), 50, 1, 4, 1.2, ignored_mobs = get_unconsenting())

/mob/living/proc/get_refraction_dif() //Got snapped in upstream, may delete later when I figure something out
	var/dif = (refractory_period - world.time)
	if(dif < 0)
		return 0
	else
		return dif

/mob/living/proc/has_belly()
	var/mob/living/carbon/C = src
	if(has_belly || !istype(C))
		return TRUE
	return has_genital(ORGAN_SLOT_BELLY)

/mob/living/cum(mob/living/partner, target_orifice)
	var/message //if this doesn't exist it calls ..()
	//var/u_His = p_their()
	//var/u_He = p_they()
	//var/u_S = p_s()
	//var/t_His = partner?.p_their()
	var/cumin = FALSE
	var/obj/item/organ/genital/target_gen
	var/mob/living/carbon/c_partner
	//Carbon checks
	if(iscarbon(partner))
		c_partner = partner

	if(src != partner)
		if(!last_genital)
			if(has_penis())
				if(!istype(partner))
					target_orifice = null
				switch(target_orifice)
					if(CUM_TARGET_NIPPLE)
						cumin = TRUE
						if(partner.has_breasts())
							message = "cums inside \the <b>[partner]</b>'s nipple!."
							target_gen = partner.getorganslot(ORGAN_SLOT_BREASTS)
						else
							message = "cums on \the <b>[partner]</b>'s chest and neck."
							if((partner.client?.prefs.cit_toggles & BREAST_ENLARGEMENT) && c_partner)
								target_gen = new /obj/item/organ/genital/breasts
								target_gen.Insert(c_partner)
						if(target_gen)
							target_gen.climax_modify_size(src, getorganslot(ORGAN_SLOT_PENIS))
					if(CUM_TARGET_URETHRA)
						cumin = TRUE
						message = "cums down \the <b>[partner]</b>'s [pick(GLOB.dick_nouns + list("[pick("cock", "dick")]hole", "urethra"))]!"
						if(c_partner)
							target_gen = partner.getorganslot(ORGAN_SLOT_PENIS)
							target_gen.climax_modify_size(src, getorganslot(ORGAN_SLOT_PENIS))
					if(CUM_TARGET_THIGHS)
						if(partner.has_legs() >= 2)
							message = "cums right into \the <b>[partner]</b>'s thighs!"
						else
							message = "cums... somehow..."
					if(CUM_TARGET_BELLY)
						cumin = TRUE
						if(partner.has_belly() == HAS_EXPOSED_GENITAL)
							message = "cums into the <b>[partner]</b>'s navel, [pick(list("making it into a massive pond of jizz", "[p_their()] spunk drooling out of it"))]."
							if(c_partner)
								target_gen = c_partner.getorganslot(ORGAN_SLOT_BELLY)
						else
							message = "cums on the <b>[partner]</b>'s midsection."
						if(c_partner)
							if(partner.client?.prefs.cit_toggles & BELLY_INFLATION)
								var/obj/item/organ/genital/belly/gut = partner.getorganslot(ORGAN_SLOT_BELLY)
								if(!gut)
									gut = new
									gut.Insert(partner)
								gut.climax_modify_size(src, getorganslot(ORGAN_SLOT_PENIS), target_orifice)

					if(CUM_TARGET_ARMPIT)
						message = "cums under \the <b>[partner]</b>'s armpit!"

					if(CUM_TARGET_MOUTH, CUM_TARGET_THROAT, CUM_TARGET_VAGINA, CUM_TARGET_ANUS)
						if(c_partner)
							if(partner.client?.prefs.cit_toggles & BELLY_INFLATION)
								var/obj/item/organ/genital/belly/gut = partner.getorganslot(ORGAN_SLOT_BELLY)
								if(!gut)
									gut = new
									gut.Insert(partner)
								gut.climax_modify_size(src, getorganslot(ORGAN_SLOT_PENIS), target_orifice)
							else if((partner.client?.prefs.cit_toggles & BUTT_ENLARGEMENT) && target_orifice == CUM_TARGET_ANUS)
								var/obj/item/organ/genital/butt/ass = partner.getorganslot(ORGAN_SLOT_BUTT)
								if(!ass)
									ass = new
									ass.Insert(partner)
								ass.climax_modify_size(src, getorganslot(ORGAN_SLOT_PENIS))

		else
			switch(last_genital.type)
				if(/obj/item/organ/genital/penis)
					if(!istype(partner))
						target_orifice = null
					switch(target_orifice)
						if(CUM_TARGET_NIPPLE)
							cumin = TRUE
							if(partner.has_breasts())
								message = "cums inside \the <b>[partner]</b>'s nipple!."
								target_gen = partner.getorganslot(ORGAN_SLOT_BREASTS)
							else
								message = "cums on \the <b>[partner]</b>'s chest and neck."
								if((partner.client?.prefs.cit_toggles & BREAST_ENLARGEMENT) && c_partner)
									target_gen = new /obj/item/organ/genital/breasts
									target_gen.Insert(partner)

							if(target_gen)
								target_gen.climax_modify_size(src, last_genital)
						if(CUM_TARGET_URETHRA)
							cumin = TRUE
							message = "cums down \the <b>[partner]</b>'s [pick(GLOB.dick_nouns + list("[pick("cock", "dick")]hole", "urethra"))]!"
							if(c_partner)
								target_gen = partner.getorganslot(ORGAN_SLOT_PENIS)
								target_gen.climax_modify_size(src, last_genital)
						if(CUM_TARGET_THIGHS)
							if(partner.has_legs() >= 2)
								message = "cums right into \the <b>[partner]</b>'s thighs!"
							else
								message = "cums... somehow..."
						if(CUM_TARGET_BELLY)
							cumin = TRUE
							if(partner.has_belly() == HAS_EXPOSED_GENITAL)
								message = "cums into the <b>[partner]</b>'s navel, [pick(list("making it into a massive pond of jizz", "[p_their()] spunk drooling out of it"))]."
								if(c_partner)
									target_gen = c_partner.getorganslot(ORGAN_SLOT_BELLY)
							else
								message = "cums on the <b>[partner]</b>'s midsection."
							if(c_partner)
								if(partner.client?.prefs.cit_toggles & BELLY_INFLATION)
									var/obj/item/organ/genital/belly/gut = partner.getorganslot(ORGAN_SLOT_BELLY)
									if(!gut)
										gut = new
										gut.Insert(partner)
									gut.climax_modify_size(src, last_genital, target_orifice)
								else if((partner.client?.prefs.cit_toggles & BUTT_ENLARGEMENT) && target_orifice == CUM_TARGET_ANUS)
									var/obj/item/organ/genital/butt/ass = partner.getorganslot(ORGAN_SLOT_BUTT)
									if(!ass)
										ass = new
										ass.Insert(partner)
									ass.climax_modify_size(src, last_genital)

						if(CUM_TARGET_MOUTH, CUM_TARGET_THROAT, CUM_TARGET_VAGINA, CUM_TARGET_ANUS)
							if(c_partner)
								if(partner.client?.prefs.cit_toggles & BELLY_INFLATION)
									var/obj/item/organ/genital/belly/gut = partner.getorganslot(ORGAN_SLOT_BELLY)
									if(!gut)
										gut = new
										gut.Insert(partner)
									gut.climax_modify_size(src, last_genital, target_orifice)
								else if((partner.client?.prefs.cit_toggles & BUTT_ENLARGEMENT) && target_orifice == CUM_TARGET_ANUS)
									var/obj/item/organ/genital/butt/ass = partner.getorganslot(ORGAN_SLOT_BUTT)
									if(!ass)
										ass = new
										ass.Insert(partner)
									ass.climax_modify_size(src, last_genital)
		if(iswendigo(partner) && partner.pulling == src)
			var/mob/living/carbon/wendigo/W = partner
			W.slaves |= src
			to_chat(src, "<font color='red'> You are now [W]'s slave! Serve your master properly! </font>")
	if(!message)
		return ..()
	if(gender == MALE)
		playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/final_m1.ogg',
							'modular_sand/sound/interactions/final_m2.ogg',
							'modular_sand/sound/interactions/final_m3.ogg',
							'modular_sand/sound/interactions/final_m4.ogg',
							'modular_sand/sound/interactions/final_m5.ogg'), 70, 1, 0)
	else if(gender == FEMALE)
		playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/final_f1.ogg',
							'modular_sand/sound/interactions/final_f2.ogg',
							'modular_sand/sound/interactions/final_f3.ogg'), 70, 1, 0)
	else
		playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/final_f1.ogg',
							'modular_sand/sound/interactions/final_f2.ogg',
							'modular_sand/sound/interactions/final_f3.ogg'), 70, 1, 0)
	visible_message(message = span_userlove("<b>\The [src]</b> [message]"), ignored_mobs = get_unconsenting())
	multiorgasms += 1

	if(get_sexual_potency() == -1 || multiorgasms > (get_sexual_potency() * 0.34)) //AAAAA, WE DONT WANT NEGATIVES HERE, RE
		refractory_period = world.time + rand(300, 900) //sex cooldown
		// set_drugginess(rand(20, 30))
	else
		refractory_period = world.time + rand(300, 900) - get_sexual_potency()
		// set_drugginess(rand(5, 10))
	if(get_sexual_potency() == -1 || multiorgasms < get_sexual_potency()) // Climax limit | SPLURT EDIT: -1 sexual potency = no limit
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			if(!partner)
				H.mob_climax(TRUE, "masturbation", "none")
			else
				H.mob_climax(TRUE, "sex", partner, !cumin, target_gen)
	set_lust(0)

	SEND_SIGNAL(src, COMSIG_MOB_POST_CAME, target_orifice, partner, cumin, last_genital)

	return TRUE

/mob/living/get_unconsenting(extreme, list/ignored_mobs, var/unholy)
	for(var/mob/M in range(7, src))
		if(M.client)
			var/client/cli = M.client
			if(unholy && (cli.prefs.unholypref == "No"))
				LAZYADD(ignored_mobs, M)
	. = ..()

/mob/living/proc/has_legs(nintendo = REQUIRE_ANY)
	var/legs = has_left_leg() + has_right_leg()
	if(legs)
		switch(nintendo)
			if(REQUIRE_EXPOSED)
				if(is_bottomless())
					return legs
			if(REQUIRE_UNEXPOSED)
				if(!is_bottomless())
					return legs
			if(REQUIRE_ANY)
				return legs
	return FALSE

// Interaction Procs

/mob/living/proc/do_oral_self(mob/living/user, var/fucktarget = "penis")
	var/message
	var/obj/item/organ/genital/peepee = null
	var/lust_increase = NORMAL_LUST
	var/t_His = p_their()
	var/t_Him = p_them()

	if(user.is_fucking(src, CUM_TARGET_MOUTH))
		if(prob(user.get_sexual_potency()))
			if(istype(src, /mob/living)) // Argh.
				var/mob/living/H = src
				H.adjustOxyLoss(3)
			message = "sucks [t_Him]self off."
			lust_increase += 5
		else
			var/improv = FALSE
			switch(fucktarget)
				if("vagina")
					if(user.has_vagina())
						message = pick(
							"licks [t_His] pussy.",
							"runs [t_His] tongue up the shape of [t_His] pussy.",
							"traces [t_His] slit with [t_His] tongue.",
							"darts the tip of [t_His] tongue around [t_His] clit.",
							"laps slowly at [t_Him].",
							"kisses [t_His] delicate folds.",
							"tastes [t_Him].",
						)
					else
						improv = TRUE
				if("penis")
					if(user.has_penis() || user.has_strapon())
						var/genital_name = user.get_penetrating_genital_name()
						message = pick(
							"sucks [t_Him] off.",
							"runs [t_His] tongue up the shape of [t_His] [genital_name].",
							"traces [t_His] [genital_name] with [t_His] tongue.",
							"darts the tip of [t_His] tongue around tip of [t_His] [genital_name].",
							"laps slowly at [t_His] shaft.",
							"kisses the base of [t_His] shaft.",
							"takes [t_Him] deeper into [t_His] mouth.",
						)
					else
						improv = TRUE
			if(improv)
				// get confused about how to do the sex
				message = pick(
					"licks [t_Him].",
					"looks a little unsure of where to lick [t_Him].",
					"runs [t_His] tongue between [t_His] legs.",
					"kisses [t_His] thigh.",
					"tries [t_His] best with [t_Him].",
				)
	else
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(user.has_vagina())
					message = pick(
						"buries [t_His] face in [t_His] pussy.",
						"nuzzles [t_His] wet sex.",
						"finds [t_His] face caught between [t_His] thighs.",
						"kneels down between [t_His] legs.",
						"grips [t_His] legs, pushing them apart.",
						"sinks [t_His] face in between [t_His] thighs.",
					)
				else
					improv = TRUE
			if("penis")
				if(user.has_penis() || user.has_strapon())
					var/genital_name = user.get_penetrating_genital_name()
					message = pick(
						"takes [t_His] [genital_name] into [t_His] mouth.",
						"wraps [t_His] lips around [t_His] [genital_name].",
						"finds [t_His] face between [t_His] thighs.",
						"kneels down between [t_His] legs.",
						"grips [t_His] legs, kissing at the tip of [t_His] [genital_name].",
						"goes down on [t_Him].",
					)
				else
					improv = TRUE
		if(improv)
			message = pick(
				"begins to lick [t_His].",
				"starts kissing [t_His] thigh.",
				"sinks down between [t_His] thighs.",
				"briefly flashes a puzzled look from between [t_His] legs.",
				"looks unsure of how to handle [t_His] lack of genitalia.",
				"seems like they were expecting [t_His] to have a cock or a pussy or ... something.",
			)
			peepee = null
		else
			if(ishuman(user))
				var/mob/living/carbon/human/pardner = user
				switch(fucktarget)
					if("vagina")
						peepee = pardner.getorganslot(ORGAN_SLOT_VAGINA)
					if("penis")
						peepee = pardner.getorganslot(ORGAN_SLOT_PENIS)
		user.set_is_fucking(src, CUM_TARGET_MOUTH, peepee)

	playlewdinteractionsound(get_turf(src), pick('modular_sand/sound/interactions/bj1.ogg',
									'modular_sand/sound/interactions/bj2.ogg',
									'modular_sand/sound/interactions/bj3.ogg',
									'modular_sand/sound/interactions/bj4.ogg',
									'modular_sand/sound/interactions/bj5.ogg',
									'modular_sand/sound/interactions/bj6.ogg',
									'modular_sand/sound/interactions/bj7.ogg',
									'modular_sand/sound/interactions/bj8.ogg',
									'modular_sand/sound/interactions/bj9.ogg',
									'modular_sand/sound/interactions/bj10.ogg',
									'modular_sand/sound/interactions/bj11.ogg'), 50, 1, -1)
	visible_message(message = span_lewd("<b>\The [src]</b> [message]"), ignored_mobs = get_unconsenting())
	if(fucktarget != "penis" || user.can_penetrating_genital_cum())
		user.handle_post_sex(lust_increase, CUM_TARGET_MOUTH, src, fucktarget)
	lust_increase = NORMAL_LUST //RESET IT REE

/mob/living/proc/do_breastfuck_self(mob/living/user)
	var/message
	var/t_His = p_their()
	var/genital_name = get_penetrating_genital_name()

	if(is_fucking(user, CUM_TARGET_BREASTS))
		message = "[pick("fucks [t_His] breasts.",
			"grinds [t_His] [genital_name] between [t_His] boobs.",
			"thrusts into [t_His] tits.",
			"grabs [t_His] breasts together and presses [t_His] [genital_name] between them.")]"
	else
		message = "pushes [t_His] breasts together and presses [t_His] [genital_name] between them."
		set_is_fucking(user, CUM_TARGET_BREASTS, getorganslot(ORGAN_SLOT_PENIS) ? getorganslot(ORGAN_SLOT_PENIS) : null)

	playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/bang1.ogg',
						'modular_sand/sound/interactions/bang2.ogg',
						'modular_sand/sound/interactions/bang3.ogg'), 70, 1, -1)
	visible_message(message = span_lewd("<b>\The [src]</b> [message]"), ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_BREASTS, user, ORGAN_SLOT_PENIS)

/*

/mob/living/proc/remove_equipment(mob/living/carbon/target)
	var/obj/item/organ/genital/holder = pick_receiving_organ(target, HAS_EQUIPMENT, "Remove equipment", "What genital?")
	if(!holder)
		to_chat(src, "<span class='warning'> You need exposed genitals!</b>")
		return
	if(!LAZYLEN(holder.equipment))
		to_chat(src, span_warning("You'll have to put something in it first, since it seems to be clean"))
		return

	var/obj/item/gimme = input(src, "What do you want to remove?", "Remove equipment", null) as null|anything in holder.equipment
	if(gimme)
		holder.remove_equipment(src, gimme)

*/

/mob/living/proc/nuzzle_belly(mob/living/target)
	var/message
	var/u_His = p_their()
	var/list/belly_names = list("stomach", "belly", "gut", "midsection", "rolls")
	var/list/nuzzles = list(
		"rubs [u_His] face all across [target]'s [pick(belly_names)]",
		"nuzzles [target]'s [pick(belly_names)][pick(list(" lovingly", ""))]",
		"shoves [u_His] face into [target]'s [pick(belly_names)] and gives it kisses all over",
		"licks right into [target]'s [pick(list("belly button", "navel"))]"
		)

	message = span_lewd("<b>\The [src]</b> [pick(nuzzles)]. ")
	visible_message(message, ignored_mobs = get_unconsenting())

/mob/living/proc/do_bellyfuck(mob/living/partner)
	var/message
	var/genital_name = get_penetrating_genital_name()
	var/u_His = p_their()

	if(is_fucking(partner, CUM_TARGET_BELLY))
		message = "[pick(
			"pounds \the <b>[partner]</b>'s belly.",
			"shoves [u_His] [genital_name] deep into \the <b>[partner]</b>'s soft tummy.",
			"thrusts in and out of \the <b>[partner]</b>'s navel.",
			"goes balls deep into \the <b>[partner]</b>'s gut over and over again.")]"
	else
		message = "pulls his [genital_name] up and slides it into \the <b>[partner]</b>'s receiving navel."
		set_is_fucking(partner, CUM_TARGET_BELLY, getorganslot(ORGAN_SLOT_PENIS))

	playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/champ1.ogg',
						'modular_sand/sound/interactions/champ2.ogg'), 50, 1, -1)
	visible_message(message = span_lewd("<b>\The [src]</b> [message]"), ignored_mobs = get_unconsenting())
	if(can_penetrating_genital_cum())
		handle_post_sex(NORMAL_LUST, CUM_TARGET_BELLY, partner, ORGAN_SLOT_PENIS)
	//partner.handle_post_sex(NORMAL_LUST, null, src) //don't think we need it for this one

/mob/living/proc/do_breastsmother(mob/living/target)
	var/message
	var/u_His = p_their()
	var/list/lines = list(
		"squishes <b>[target]</b>'s face [pick(list("in between", "with"))] [u_His] [pick(GLOB.breast_nouns)].",
		"presses [u_His] [pick(GLOB.breast_nouns)] into \the <b>[target]</b>'s face.",
		"shoves \the <b>[target]</b>'s whole head into [u_His] cleavage."
		)

	message = span_lewd("\The <b>[src]</b> [pick(lines)]")
	visible_message(message, ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/bang1.ogg',
						'modular_sand/sound/interactions/bang2.ogg',
						'modular_sand/sound/interactions/bang3.ogg'), 70, 1, -1)

/mob/living/proc/lick_sweat(mob/living/target)
	var/message
	var/t_His = target.p_their()
	var/list/lines = list("licks \the <b>[target]</b>'s sweat off [t_His] body.",
							"slurps the salty sweat running through <b>[target]</b>'s skin.",
							"has a nice taste of \the <b>[target]</b>'s drenched body.",
							"takes a whiff of \the <b>[target]</b>'s musk and drinks [t_His] warm sweat.")

	message = span_lewd("\The <b>[src]</b> [pick(lines)]")
	visible_message(message, ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, 'modular_sand/sound/interactions/champ_fingering.ogg', 50, 1, -1)

/mob/living/proc/smother_armpit(mob/living/target)
	var/message
	var/u_His = p_their()
	var/list/musk = list("musky ", "sweaty ", "damp ", "smelly ", "")
	var/list/lines = list(
		"shoves \the <b>[target]</b>'s face in [u_His] [pick(musk)] armpit.",
		"squeezes \the <b>[target]</b>'s nose under [u_His] [pick(musk)] pit.",
		"makes sure to squeeze \the <b>[target]</b>'s face well under [u_His] [pick(musk)] armpit and let them take a whiff."
		)

	message = span_lewd("\The <b>[src]</b> [pick(lines)]")
	visible_message(message, ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, pick(
		'modular_sand/sound/interactions/squelch1.ogg',
		'modular_sand/sound/interactions/squelch2.ogg',
		'modular_sand/sound/interactions/squelch3.ogg'), 50, 1, -1)

/mob/living/proc/lick_armpit(mob/living/target)
	var/message
	var/u_His = p_their()
	var/list/musk = list("musky ", "sweaty ", "damp ", "smelly ", "")
	var/list/lines = list(
		"shoves [u_His] nose deep into \the <b>[target]</b>'s armpit, giving it a big [pick(list("whiff", "lick", "nuzzle"))].",
		"presses [u_His] face under \the <b>[target]</b>'s [pick(musk)] pit, [pick(list("tasting and lapping it all over", "sniffing its scent"))].",
		"goes face deep into \the <b>[target]</b> [pick(musk)] armpit, worshipping it with [u_His] tongue and nose."
	)

	message = span_lewd("\The <b>[src]</b> [pick(lines)]")
	visible_message(message, ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, pick(
		'modular_sand/sound/interactions/squelch1.ogg',
		'modular_sand/sound/interactions/squelch2.ogg',
		'modular_sand/sound/interactions/squelch3.ogg'), 50, 1, -1)

/mob/living/proc/fuck_armpit(mob/living/target)
	var/message
	var/u_His = p_their()
	var/genital_name = get_penetrating_genital_name()
	var/t_His = target.p_their()
	var/list/musk = list("musky ", "sweaty ", "damp ", "smelly ", "")
	var/list/lines

	if(is_fucking(target, CUM_TARGET_ARMPIT))
		lines = list(
			" slides [u_His] [genital_name] back and forth under \the <b>[target]</b>'s [pick(musk)]armpit.",
			"'s [genital_name] drools pre all over \the <b>[target]</b>'s [pick(musk)]armpit, thoroughly fucking its warm embrace.",
			" shoves [u_His] [genital_name] under \the <b>[target]</b>'s arm, using [t_His] [pick(musk)]pit like a fleshlight."
		)
	else
		if(target.is_topless())
			lines = list(
				" presents [u_His] [genital_name] to \the <b>[target]</b>'s [pick(musk)]armpit, beginning to thrust its whole length right under [t_His] arm!"
			)
		else // https://cdn.discordapp.com/attachments/802990353883070474/962478553117622322/NoName-480p.mp4
			lines = list(
				" rips a hole through \the <b>[target]</b>'s clothes so [t_His] armpit is exposed. \The <b>[target]</b> can suddenly feel the warmth of \the <b>[src]</b>' throbbing [genital_name] sliding all the way into [t_His] [pick(musk)] pit!"
			)
		set_is_fucking(target, CUM_TARGET_ARMPIT, getorganslot(ORGAN_SLOT_PENIS))

	message = span_lewd("\The <b>[src]</b>[pick(lines)]")
	visible_message(message, ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/bang1.ogg',
						'modular_sand/sound/interactions/bang2.ogg',
						'modular_sand/sound/interactions/bang3.ogg'), 70, 1, -1)
	if(can_penetrating_genital_cum())
		handle_post_sex(NORMAL_LUST, CUM_TARGET_ARMPIT, target, ORGAN_SLOT_PENIS)

/mob/living/proc/do_pitjob(mob/living/target)
	var/message
	var/list/musk = list("musky ", "sweaty ", "damp ", "smelly ", "")
	var/u_His = p_their()
	var/genital_name = target.get_penetrating_genital_name()
	var/t_His = target.p_their()
	var/list/lines

	if(is_fucking(target, CUM_TARGET_ARMPIT))
		lines = list(
			"squeezes [u_His] armpit right into \the <b>[target]</b>'s throbbing [genital_name], massaging its length using [u_His] [pick(musk)]armpit!",
			"presses [u_His] arm down all over \the <b>[target]</b>'s leaking [genital_name], milking it with [u_His] [pick(musk)] pit!",
			"rubs and grinds [u_His] [pick(musk)] armpit back and forth through \the <b>[target]</b>'s [genital_name], deeply squeezing it to the base!"
		)
	else
		if(target.is_topless())
			lines = list(
				"presents [u_His] [pick(musk)] armpit to \the <b>[target]</b>, lifting [u_His] arm up before clamping it down into [t_His] [genital_name] with a deep squeeze!",
			)
		else // https://cdn.discordapp.com/attachments/802990353883070474/962478553117622322/NoName-480p.mp4
			lines = list(
				"softly tears a hole in the cloth on the back of [u_His] armpit, stuffing \the <b>[target]</b>'s whole rod right into it with a [pick(musk)] embrace!"
			)
		target.set_is_fucking(src, CUM_TARGET_ARMPIT, target.getorganslot(ORGAN_SLOT_PENIS))

	message = span_lewd("\The <b>[src]</b> [pick(lines)]")
	visible_message(message, ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/bang1.ogg',
						'modular_sand/sound/interactions/bang2.ogg',
						'modular_sand/sound/interactions/bang3.ogg'), 70, 1, -1)
	if(target.can_penetrating_genital_cum())
		target.handle_post_sex(NORMAL_LUST, CUM_TARGET_ARMPIT, src, ORGAN_SLOT_PENIS)

/mob/living/proc/do_boobjob(mob/living/target)
	var/message
	var/u_His = p_their()
	var/genital_name = target.get_penetrating_genital_name()
	var/list/lines

	if(target.is_fucking(src, CUM_TARGET_BREASTS))
		lines = list(
			"slides [u_His] [pick(GLOB.breast_nouns)], up and down through \the <b>[target]</b>'s throbbing [genital_name].",
			"squeezes [u_His] [pick(GLOB.breast_nouns)] through all of \the <b>[target]</b>'s length.",
			"jerks \the <b>[target]</b> off lustfully with [u_His] supple [pick(GLOB.breast_nouns)]."
		)
	else
		lines = list(
			"clamps [u_His] [pick(GLOB.breast_nouns)] around \the <b>[target]</b>'s throbbing [genital_name], wrapping it in their sheer warmth.",
			"envelops \the <b>[target]</b>'s hard member with [u_His] soft [pick(GLOB.breast_nouns)], giving it a tight and sloshing squeeze.",
			"lets [u_His] [pick(GLOB.breast_nouns)] fall into \the <b>[target]</b>'s fat [genital_name], smothering it in [u_His] cleavage."
		)
		target.set_is_fucking(src, CUM_TARGET_BREASTS, getorganslot(ORGAN_SLOT_PENIS))

	message = span_lewd("\The <b>[src]</b> [pick(lines)]")
	visible_message(message, ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/bang1.ogg',
						'modular_sand/sound/interactions/bang2.ogg',
						'modular_sand/sound/interactions/bang3.ogg'), 70, 1, -1)
	if(target.can_penetrating_genital_cum())
		target.handle_post_sex(NORMAL_LUST, CUM_TARGET_BREASTS, src, ORGAN_SLOT_PENIS)

/mob/living/proc/lick_nuts(mob/living/target)
	var/message
	var/u_His = p_their()
	var/t_His = target.p_their()
	var/lust_increase = 1
	var/list/balls = list("balls", "nuts", "[pick(list("cum", "spunk", "nut", "jizz", "seed"))] [pick(list("orbs", "spheres", "tanks", "holders", "churners"))]")
	var/list/lines

	if(target.is_fucking(src, NUTS_TO_FACE))
		lines = list(
			"worships \the <b>[target]</b>'s [pick(balls)] with [u_His] tongue.",
			"takes a huff of \the <b>[target]</b>'s heavy ball musk and proceeds to lap the sweat off [t_His] [pick(balls)].",
			"plants smooches all over \the <b>[target]</b>'s heavy [pick(balls)], tasting [t_His] nutsack and massaging it with [u_His] lips."
		)
	else
		lines = list(
			"opens [u_His] maw and proceeds to bring \the <b>[target]</b>'s [pick(balls)] right in.",
			"uses [u_His] tongue to fit \the <b>[target]</b>'s balls in [u_His] mouth, deeply huffing their scent.",
			"willingly lets \the <b>[target]</b>'s [pick(balls)] fall into and fill [u_His] mouth, lustfully sucking into them."
		)
		target.set_is_fucking(src, NUTS_TO_FACE, getorganslot(ORGAN_SLOT_PENIS))

	message = span_lewd("\The <b>[src]</b> [pick(lines)]")
	visible_message(message, ignored_mobs = get_unconsenting())
	target.handle_post_sex(lust_increase, CUM_TARGET_MOUTH, src, ORGAN_SLOT_TESTICLES)

/mob/living/proc/do_cockfuck(mob/living/target)
	var/message
	var/u_His = p_their()
	var/t_His = target.p_their()
	var/u_genital_name = get_penetrating_genital_name()
	var/t_genital_name = target.get_penetrating_genital_name()
	var/list/lines
	var/list/noises = list(
		'modular_sand/sound/interactions/bang1.ogg',
		'modular_sand/sound/interactions/bang2.ogg',
		'modular_sand/sound/interactions/bang3.ogg',
		'modular_sand/sound/interactions/bang4.ogg',
		'modular_sand/sound/interactions/bang5.ogg',
		'modular_sand/sound/interactions/bang6.ogg',
	)

	if(is_fucking(target, CUM_TARGET_URETHRA))
		lines = list(
			"humps right into \the <b>[target]</b>'s [t_genital_name], stretching it as their balls slam together!",
			"slides [u_His] [u_genital_name] all the way down \the <b>[target]</b>'s own throbbing [t_genital_name], [t_His] urethra is so tight!",
			"rams [u_His] [u_genital_name] back and forth through \the <b>[target]</b>'s urethra, giving it a very eager fucking!"
		)
	else
		lines = list(
			"'s tip gently smooches \the <b>[target]</b>'s, right before forcing its way right down [t_His] dickhole.",
			"grinds [u_His] tip against \the <b>[target]</b>'s [t_genital_name], only to slide [u_His] whole [u_genital_name] all the way down to [t_His] base.",
			"makes \the <b>[target]</b>'s fat [t_genital_name] stretch and throb as the size of [u_His] [u_genital_name] makes its way right in."
		)
		set_is_fucking(target, CUM_TARGET_URETHRA, getorganslot(ORGAN_SLOT_PENIS))

	message = span_lewd("\The <b>[src]</b> [pick(lines)]")
	visible_message(message, ignored_mobs = get_unconsenting())
	playlewdinteractionsound(src, pick(noises), 70, 1, -1)
	if(can_penetrating_genital_cum())
		handle_post_sex(NORMAL_LUST, CUM_TARGET_URETHRA, target, ORGAN_SLOT_PENIS)
	if(target.can_penetrating_genital_cum())
		target.handle_post_sex(NORMAL_LUST, CUM_TARGET_URETHRA, ORGAN_SLOT_PENIS)

/mob/living/proc/do_nipfuck(mob/living/target)
	var/message
	var/list/lines
	var/u_His = p_their()
	var/genital_name = get_penetrating_genital_name()
	var/t_His = target.p_their()
	if(is_fucking(target, CUM_TARGET_NIPPLE) && target.has_breasts() == HAS_EXPOSED_GENITAL)
		lines = list(
			"slides [u_His] [genital_name] back and forth into \the <b>[target]</b>'s nipple",
			"thrusts in and out of \the <b>[target]</b>'s leaky and puffy nip, making [t_His] [pick(GLOB.breast_nouns)] slosh and leak",
			"'s balls slap loudly against \the <b>[target]</b>'s jostling [pick(GLOB.breast_nouns)] as [t_His] nipple swallows [u_His] [genital_name] whole"
		)
	else if(target.has_breasts() == HAS_EXPOSED_GENITAL)
		lines = list(
			"presses [u_His] throbbing tip against \the <b>[target]</b>'s puffy nipple, forcing the whole length all the way in with a wet smack",
		"stretches \the <b>[target]</b>'s nipple with [u_His] fingers, before forcing it open with the whole girth of [u_His] twitching [genital_name]"
		)
	else
		lines = list(
			"rubs [u_His] tip gently against \the <b>[target]</b>'s [pick("nipple", "chest")]",
			"slaps [u_His] snaky [genital_name] into \the <b>[target]</b>'s chest",
			"smooches \the <b>[target]</b>'s nipple with [u_His] dickhole"
		)

	if(!is_fucking(target, CUM_TARGET_NIPPLE))
		set_is_fucking(target, CUM_TARGET_NIPPLE, getorganslot(ORGAN_SLOT_PENIS))

	message = span_lewd("\The <b>[src]</b> [pick(lines)]!")
	visible_message(message, ignored_mobs = get_unconsenting())
	playlewdinteractionsound(src, pick('modular_sand/sound/interactions/bang1.ogg',
						'modular_sand/sound/interactions/bang2.ogg',
						'modular_sand/sound/interactions/bang3.ogg'), 70, 1, -1)
	if(can_penetrating_genital_cum())
		handle_post_sex(NORMAL_LUST, CUM_TARGET_NIPPLE, target, ORGAN_SLOT_PENIS)
	target.handle_post_sex(NORMAL_LUST, null, src, ORGAN_SLOT_BREASTS)

/mob/living/proc/do_thighfuck(mob/living/target)
	var/message
	var/list/lines
	var/u_His = p_their()
	var/genital_name = get_penetrating_genital_name()
	var/t_His = target.p_their()

	if(is_fucking(target, CUM_TARGET_THIGHS))
		lines = list(
			"thrusts in and out of \the <b>[target]</b>'s [pick("pudgy ", "soft ", "")]thighs, making them jiggle",
			"lustfully rolls [u_His] [genital_name] back and forth between \the <b>[target]</b>'s thighs",
			"vigorously fucks \the <b>[target]</b>'s legs, making [u_His] tip pop in and out of [t_His] supple thighs"
		)
	else
		lines = list(
			"presses [u_His] tip against \the <b>[target]</b>'s [pick("pudgy ", "soft ", "")]thighs, soon shoving [u_His] whole length right in between them",
			"presents [u_His] [genital_name] to \the <b>[target]</b>'s legs, ramming its full size right into [t_His] thigh lock",
			"smooches \the <b>[target]</b>'s crotch with [u_His] throbbing tip, right before piercing between [t_His] thighs with [u_His] full [genital_name]"
		)
		set_is_fucking(target, CUM_TARGET_THIGHS, getorganslot(ORGAN_SLOT_PENIS))

	message = span_lewd("\The <b>[src]</b> [pick(lines)]!")
	visible_message(message, ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/bang1.ogg',
						'modular_sand/sound/interactions/bang2.ogg',
						'modular_sand/sound/interactions/bang3.ogg'), 70, 1, -1)
	if(can_penetrating_genital_cum())
		handle_post_sex(NORMAL_LUST, CUM_TARGET_THIGHS, target, ORGAN_SLOT_PENIS)
	target.handle_post_sex(LOW_LUST, CUM_TARGET_PENIS, src)

/mob/living/proc/do_thighjob(mob/living/target)
	var/message
	var/list/lines
	var/u_His = p_their()
	var/genital_name = target.get_penetrating_genital_name()
	var/t_He = target.p_they()
	var/t_His = target.p_their()

	if(target.is_fucking(src, CUM_TARGET_THIGHS))
		lines = list(
			"grinds and presses [u_His] thighs [pick("deeply ", "")] against \the <b>[target]</b>'s [genital_name], massaging it all over with [u_His] thighs",
			"squeezes \the <b>[target]</b>'s [genital_name] between [u_His] supple thighs, smothering it deep under [u_His] crotch",
			"rides \the <b>[target]</b>'s [genital_name] with [u_His] [pick("pudgy ", "soft ", "")]thighs, [t_He] can feel [u_His] flesh smothering it down"
		)
	else
		lines = list(
			"presents [u_His] [pick("pudgy ", "soft ", "")] thighs to \the <b>[target]</b>'s [genital_name], slamming them right into it[pick(" with a [pick("wet ", "")]smack", "")]!",
			"grinds \the <b>[target]</b>'s tip against [u_His] supple thighs, before slamming them right down into [t_His] [genital_name]!",
			"forces \the <b>[target]</b>'s [genital_name] right into the tight hold of [u_His] thighs, giving it a deep and lewd squeeze!"
		)
		target.set_is_fucking(src, CUM_TARGET_THIGHS, target.getorganslot(ORGAN_SLOT_PENIS))

	message = span_lewd("\The <b>[src]</b> [pick(lines)]!")
	visible_message(message, ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/bang1.ogg',
						'modular_sand/sound/interactions/bang2.ogg',
						'modular_sand/sound/interactions/bang3.ogg'), 70, 1, -1)
	handle_post_sex(LOW_LUST, CUM_TARGET_PENIS, target)
	if(target.can_penetrating_genital_cum())
		target.handle_post_sex(NORMAL_LUST, CUM_TARGET_THIGHS, src, ORGAN_SLOT_PENIS)

////////////////////////////////////////////////////////////////////////////////////////////////////////
///////// 									U N H O L Y										   /////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
/mob/living/proc/do_facefart(mob/living/carbon/target)
	var/message
	var/t_His = target.p_their()
	var/u_His = p_their()
	var/u_He = p_they()

	var/list/asscheeks = list("asscheeks", "buttcheeks", "ass buns", "booty pillows", "dumptruck spheres", "[pick(list("jiggly", "bouncy", "wobbly"))] buttocks")
	var/list/ass = list("ass", "butt", "dumptruck", "tush", "badonk", "booty", "rump")
	var/jiggle = "[u_His] [pick(asscheeks)] [pick(list("jiggle", "bounce", "bounce around", "wobble"))] like crazy!"
	var/list/stank = list("greasy", "rancid", "pungent", "rotten", "boiling hot", "wet", "nose-burning", "heavy", "dense", "thick", "stinky", "stenchy", "warm")
	var/list/braps = list(
		"rips a [pick(list("massive", "fat", "engulfing", "breathtaking"))][pick(list(", [pick(stank)]", ""))] one",
		"[pick(list("", "wetly", "loudly"))] [pick(list("braps", "farts", "rips ass"))]",
		"lets out some of that [pick(stank)] [pick(list("gas", "flatulence", "anal hurricane"))]",
		"lets [u_His] shitter drop a [pick(list("large", "fat", "greasy"))] gas bomb",
		"allows [u_His] [pick(ass)] to rip an enormous, greasy gas cloud"
	)
	var/list/hell = list(
		"'s asshole squints as she shoves \the <b>[target]</b>'s face in between [u_His] sweaty [pick(asscheeks)], letting hell go loose!",
		" pushes [u_His] [pick(ass)] into \the <b>[target]</b>'s face, [pick(list("[t_His] nose shoved deep in [src]'s musky butthole", "[u_His] asshole squints"))] as [u_He] [pick(braps)][pick(list("", ", [jiggle]"))]",
		" smothers \the [target]'s whole head in between [u_His][pick(list(" sweaty", "", " musky"))] [pick(asscheeks)], pushing out gallons of pure braps. [pick(list("", "[jiggle]"))]",
		"'s [pick(ass)] claps against \the <b>[target]</b>'s nose, right before [u_He] [pick(braps)]"
	)

	message = span_lewd("\The <b>[src]</b>[pick(hell)]")
	visible_message(message, ignored_mobs = get_unconsenting(unholy = TRUE))
	playlewdinteractionsound(loc, pick(GLOB.brap_noises), 50, 1, -1, ignored_mobs = get_unconsenting(unholy = TRUE))
	if(!is_fucking(target, GRINDING_FACE_WITH_ANUS))
		set_is_fucking(target, GRINDING_FACE_WITH_ANUS, null)
	handle_post_sex(LOW_LUST, null, src)

/mob/living/proc/do_crotchfart(mob/living/carbon/target)
	var/message
	var/u_His = p_their()
	var/genital_name = "crotch"
	if(target.has_penis() == HAS_EXPOSED_GENITAL || target.has_strapon() == HAS_EXPOSED_GENITAL)
		genital_name = target.get_penetrating_genital_name()
	else if(target.has_vagina() == HAS_EXPOSED_GENITAL)
		var/obj/item/organ/genital/vagina/genital = target.getorganslot(ORGAN_SLOT_VAGINA)
		genital_name = genital.name

	var/list/asscheeks = list("asscheeks", "buttcheeks", "ass buns", "booty pillows", "dumptruck spheres", "[pick(list("jiggly", "bouncy", "wobbly"))] buttocks")
	var/list/ass = list("ass", "butt", "dumptruck", "tush", "badonk", "booty", "rump")
	var/jiggle = "[u_His] [pick(asscheeks)] [pick(list("jiggle", "bounce", "bounce around", "wobble"))] like crazy!"
	var/list/stank = list("greasy", "rancid", "pungent", "rotten", "boiling hot", "wet", "nose-burning", "heavy", "dense", "thick", "stinky", "stenchy", "warm")
	var/list/braps = list(
		"rips a [pick(list("massive", "fat", "engulfing", "breathtaking"))][pick(list(", [pick(stank)]", ""))] one",
		"[pick(list("", "wetly", "loudly"))] [pick(list("braps", "farts", "rips ass"))]",
		"lets out some of that [pick(stank)] [pick(list("gas", "flatulence", "anal hurricane"))]",
		"lets [u_His] shitter drop a [pick(list("large", "fat", "greasy"))] gas bomb",
		"allows [u_His] [pick(ass)] to rip an enormous, greasy gas cloud."
	)
	var/list/hell = list(
		" pushes [u_His] [pick(ass)] into \the <b>[target]</b>'s crotch, [pick(list("ripping a fat[pick(list("", " and [pick(stank)]"))] one", " and subsequently [pick(braps)]"))][pick(list("", ". [jiggle]"))]",
		" and \the <b>[target]</b> can smell the [prob(50) ? pick(stank) : "flatulent"] gas fill the room ass it seeps in between \the <b>[target]</b>'s thighs!",
		" [pick(braps)] into \the <b>[target]</b>'s [genital_name]"
	)

	message = span_lewd("\The <b>[src]</b>[pick(hell)]")
	visible_message(message, ignored_mobs = get_unconsenting(unholy = TRUE))
	playlewdinteractionsound(loc, pick(GLOB.brap_noises), 50, 1, -1, ignored_mobs = get_unconsenting(unholy = TRUE))
	if(!target.is_fucking(src, CUM_TARGET_ANUS))
		var/obj/item/organ/genital/genital = target.has_penis() == HAS_EXPOSED_GENITAL ? target.getorganslot(ORGAN_SLOT_PENIS) : (target.has_vagina() == HAS_EXPOSED_GENITAL ? target.getorganslot(ORGAN_SLOT_VAGINA) : null)
		target.set_is_fucking(src, CUM_TARGET_ANUS, genital)
	if(!target.has_strapon() == HAS_EXPOSED_GENITAL)
		target.handle_post_sex(NORMAL_LUST, CUM_TARGET_ANUS, src)
	handle_post_sex(NORMAL_LUST, null, target)

/mob/living/proc/do_fartfuck(mob/living/target)
	var/message
	var/list/hell
	var/t_He = target.p_they()
	var/t_His = target.p_their()
	var/u_His = p_their()
	var/u_He = p_they()
	var/genital_name = get_penetrating_genital_name()

	var/list/asscheeks = list("asscheeks", "buttcheeks", "ass buns", "booty pillows", "dumptruck spheres", "[pick(list("jiggly", "bouncy", "wobbly"))] buttocks")
	var/list/ass = list("ass", "butt", "dumptruck", "tush", "badonk", "booty", "rump")
	var/jiggle = "[t_His] [pick(asscheeks)] [pick(list("jiggle", "bounce", "bounce around", "wobble"))] like crazy!"
	var/list/stank = list("greasy", "rancid", "pungent", "rotten", "boiling hot", "wet", "nose-burning", "heavy", "dense", "thick", "stinky", "stenchy", "warm")
	var/list/stankhole = list("greasy", "stinky", "dirty", "gassy", "brapping", "noisy", "quaking", "musky")
	var/list/braps = list(
		"rips a [pick(list("massive", "fat", "engulfing", "breathtaking"))][pick(list(", [pick(stank)]", ""))] one",
		"[pick(list("", "wetly", "loudly"))] [pick(list("braps", "farts", "rips ass"))]",
		"lets out some of that [pick(stank)] [pick(list("gas", "flatulence", "anal hurricane"))]",
		"lets [u_His] shitter drop a [pick(list("large", "fat", "greasy"))] gas bomb",
		"allows [u_His] [pick(ass)] to rip an enormous, greasy gas cloud."
	)
	if(is_fucking(target, CUM_TARGET_ANUS))
		hell = list(
			"thrusts in and out of \the <b>[target]</b>'s [pick(stankhole)] pucker, making it [pick("fumigate <b>[src]</b>'s [genital_name] with farts", "push out an unholy amount of ass gas")].",
			"pounds \the <b>[target]</b>'s ass. [t_He] [pick(braps)]",
			"slams [u_His] hips up against \the <b>[target]</b>'s [pick(stankhole)] [pick(ass)] hard, causing a massive surge of [pick(list("farts", "butt methane", "brap", "ass gas", "shit winds", "thick flatulence"))] from [t_His] [pick(list("crack", "canyon"))][prob(50) ? ". [jiggle]" : ""]",
			"goes balls deep into \the <b>[target]</b>'s [pick(ass)] over and over again. [t_He] can't stop pumping out [pick("", "[pick(stank)] ")] [pick(list("farts", "butt methane", "brap", "ass gas", "shit winds", "thick flatulence"))] from his wobbling [pick(asscheeks)]")
	else
		hell = list(
			"can already smell the stench as [u_He] works [u_His] [genital_name] into \the <b>[target]</b>'s brap hole, being received by a long and warm backblast.",
			"grabs the base of [u_His] twitching [genital_name] and presses the tip into \the <b>[target]</b>'s asshole, acting like a valve that unearths impossible amounts of pure, [pick(stank)] flatulence.",
			"shoves [u_His] [genital_name] deep inside of \the <b>[target]</b>'s [pick(ass)], [t_He] [pick(braps)][pick("", ". [jiggle]")]")
		set_is_fucking(target, CUM_TARGET_ANUS, getorganslot(ORGAN_SLOT_PENIS))

	message = span_lewd("\The <b>[src]</b> [pick(hell)]")
	visible_message(message, ignored_mobs = get_unconsenting(unholy = TRUE))
	playlewdinteractionsound(target.loc, pick(GLOB.brap_noises), 50, 1, -1, ignored_mobs = get_unconsenting(unholy = TRUE))
	playlewdinteractionsound(target.loc, pick('modular_sand/sound/interactions/bang1.ogg',
						'modular_sand/sound/interactions/bang2.ogg',
						'modular_sand/sound/interactions/bang3.ogg',
						'modular_sand/sound/interactions/bang4.ogg',
						'modular_sand/sound/interactions/bang5.ogg',
						'modular_sand/sound/interactions/bang6.ogg'), 70, 1, -1)
	if(can_penetrating_genital_cum())
		handle_post_sex(NORMAL_LUST, CUM_TARGET_ANUS, target, ORGAN_SLOT_PENIS)
	target.handle_post_sex(NORMAL_LUST, null, src)

/mob/living/proc/suck_fart(mob/living/target)
	var/message
	var/list/hell
	var/t_His = target.p_their()
	var/u_His = p_their()

	var/list/stank = list("greasy", "rancid", "pungent", "rotten", "boiling hot", "wet", "nose-burning", "heavy", "dense", "thick", "stinky", "stenchy", "warm")
	var/list/stankhole = list("greasy", "stinky", "dirty", "gassy", "brapping", "noisy", "quaking", "musky")

	if(is_fucking(target, GRINDING_FACE_WITH_ANUS))
		hell = list(
			"smooches and sucks \the <b>[target]</b>'s [pick(pick(stankhole) + " ", "")] pucker, gulping down a whole barrage of [pick(stank)] flatulence!",
			"pierces \the <b>[target]</b>'s [pick(pick(stankhole) + " ", "")] butthole with [u_His] tongue, making a [pick(stank)] burst out!",
			"sucks into \the <b>[target]</b>'s [pick(pick(stankhole) + " ", "")] asshole, gulping down [t_His] [pick(stank)] gas!"
		)
	else
		hell = list(
			"presses [u_His] face right into \the <b>[target]</b>'s [pick(list("musky ", "sweaty ", ""))] backside, spreading [t_His] butthole open to begin harvesting [t_His] [pick(stank) + " "] farts!",
			"uses [u_His] lips to spread \the <b>[target]</b>'s [pick(stankhole) + " "] butthole, starting to suck the flatulence out of it!"
		)
		set_is_fucking(target, GRINDING_FACE_WITH_ANUS, null)

	message = span_lewd("\The <b>[src]</b> [pick(hell)]")
	visible_message(message, ignored_mobs = get_unconsenting(unholy = TRUE))
	playlewdinteractionsound(target.loc, pick(GLOB.brap_noises), 50, 1, -1, ignored_mobs = get_unconsenting(unholy = TRUE))
	playlewdinteractionsound(target.loc, 'modular_sand/sound/interactions/champ_fingering.ogg', 50, 1, -1, ignored_mobs = get_unconsenting(unholy = TRUE))
	target.handle_post_sex(NORMAL_LUST, null, src)

/mob/living/proc/do_faceshit(mob/living/carbon/target)
	var/message
	var/u_His = p_their()
	var/t_His = target.p_their()

	var/list/asscheeks = list("asscheeks", "buttcheeks", "ass buns", "booty pillows", "dumptruck spheres", "[pick(list("jiggly", "bouncy", "wobbly"))] buttocks")
	var/list/ass = list("ass", "butt", "dumptruck", "tush", "badonk", "booty", "rump")
	var/jiggle = "[u_His] [pick(asscheeks)] [pick(list("jiggle", "bounce", "bounce around", "wobble"))] like crazy!"
	var/list/stank = list("greasy", "rancid", "pungent", "rotten", "boiling hot", "wet", "nose-burning", "heavy", "dense", "thick", "stinky", "stenchy", "warm")
	var/list/stankhole = list("greasy", "stinky", "dirty", "gassy", "shitting", "noisy", "quaking", "musky", "messy", "shitcaked", "nasty")

	var/list/hell = list(
		"presses [u_His] [pick(stankhole)] [pick(ass)] into \the <b>[target]</b>'s face, coating it in a [pick(stank)] layer of brown",
		"makes sure \the <b>[target]</b>'s mouth is wide open, letting out a greasy, [pick(stank)] log of manure right into it. [jiggle]",
		"smothers \the <b>[target]</b>'s face in between [u_His] musky, dirty asscheeks, [pick(list("", "letting out a [pick(stank)] fart and"))] sliding a monster turd right into [t_His] mouth"
	)

	message = span_lewd("\The <b>[src]</b> [pick(hell)]")
	visible_message(message, ignored_mobs = get_unconsenting(unholy = TRUE))
	playlewdinteractionsound(loc, pick(GLOB.brap_noises), 50, 1, -1, ignored_mobs = get_unconsenting(unholy = TRUE))
	if(!is_fucking(target, GRINDING_FACE_WITH_ANUS))
		set_is_fucking(target, GRINDING_FACE_WITH_ANUS, null)
	handle_post_sex(LOW_LUST, null, src)

/mob/living/proc/do_crotchshit(mob/living/carbon/target)
	var/message
	var/t_His = target.p_their()
	var/u_His = p_their()

	var/genital_name = "crotch"
	if(target.has_penis() == HAS_EXPOSED_GENITAL || target.has_strapon() == HAS_EXPOSED_GENITAL)
		genital_name = target.get_penetrating_genital_name()
	else if(target.has_vagina() == HAS_EXPOSED_GENITAL)
		var/obj/item/organ/genital/vagina/genital = target.getorganslot(ORGAN_SLOT_VAGINA)
		genital_name = genital.name

	var/list/asscheeks = list("asscheeks", "buttcheeks", "ass buns", "booty pillows", "dumptruck spheres", "[pick(list("jiggly", "bouncy", "wobbly"))] buttocks")
	var/list/ass = list("ass", "butt", "dumptruck", "tush", "badonk", "booty", "rump")
	var/jiggle = "[u_His] [pick(asscheeks)] [pick(list("jiggle", "bounce", "bounce around", "wobble"))] like crazy!"
	var/list/stank = list("greasy", "rancid", "pungent", "rotten", "boiling hot", "wet", "nose-burning", "heavy", "dense", "thick", "stinky", "stenchy", "warm")
	var/list/stankhole = list("greasy", "stinky", "dirty", "gassy", "shitting", "noisy", "quaking", "musky", "messy", "shitcaked", "nasty")

	var/list/hell = list(
		"presses [u_His] [pick(stankhole)] [pick(asscheeks)] right against \the <b>[target]</b>'s crotch, unleashing pounds of warm crap all over [t_His] [genital_name] [prob(50) ? ". [jiggle]" : ""]",
		"shoves [u_His][pick(list("", " [pick(stank)],"))] shitting [pick(ass)] into \the <b>[target]</b>'s thighs and coats everything in between them with [pick("", "gas and ")] slick slop",
		"shits uncontrollably all over \the <b>[target]</b>'s [genital_name][prob(50) ? "" : ". [jiggle]"]"
	)

	message = span_lewd("\The <b>[src]</b> [pick(hell)]")
	visible_message(message, ignored_mobs = get_unconsenting(unholy = TRUE))
	playlewdinteractionsound(loc, pick(GLOB.brap_noises), 50, 1, -1, ignored_mobs = get_unconsenting(unholy = TRUE))

	var/obj/item/organ/genital/G = target.has_penis() == HAS_EXPOSED_GENITAL ? target.getorganslot(ORGAN_SLOT_PENIS) : (target.has_vagina() == HAS_EXPOSED_GENITAL ? target.getorganslot(ORGAN_SLOT_VAGINA) : null)
	if(!target.is_fucking(src, CUM_TARGET_ANUS))
		target.set_is_fucking(src, CUM_TARGET_ANUS, G)
	if(!target.has_strapon() == HAS_EXPOSED_GENITAL)
		target.handle_post_sex(NORMAL_LUST, CUM_TARGET_ANUS, src, G)
	handle_post_sex(NORMAL_LUST, null, target)

/mob/living/proc/do_shitfuck(mob/living/carbon/target)
	var/message
	var/t_He = target.p_they()
	var/t_His = target.p_their()
	var/u_His = p_their()
	var/u_He = p_they()
	var/genital_name = get_penetrating_genital_name()

	var/list/hell
	var/list/asscheeks = list("asscheeks", "buttcheeks", "ass buns", "booty pillows", "dumptruck spheres", "[pick(list("jiggly", "bouncy", "wobbly"))] buttocks")
	var/list/ass = list("ass", "butt", "dumptruck", "tush", "badonk", "booty", "rump")
	var/jiggle = "[t_His] [pick(asscheeks)] [pick(list("jiggle", "bounce", "bounce around", "wobble"))] like crazy!"
	var/list/stank = list("greasy", "rancid", "pungent", "rotten", "boiling hot", "wet", "nose-burning", "heavy", "dense", "thick", "stinky", "stenchy", "warm")
	var/list/stankhole = list("greasy", "stinky", "dirty", "gassy", "shitting", "noisy", "quaking", "musky", "messy", "shitcaked", "nasty")

	if(is_fucking(target, CUM_TARGET_ANUS))
		hell = list(
			"thrusts in and out of \the <b>[target]</b>'s [pick(stank)] shit-lubed pucker, making it squeak and expulse heavy gases and waste.",
			"pounds \the <b>[target]</b>'s ass. [t_He] just can't stop pumping out slop!",
			"slams [u_His] hips up against \the <b>[target]</b>'s [pick(stankhole)] [pick(ass)] hard, causing a massive surge of manure from [t_His] [pick(list("crack", "canyon"))][prob(50) ? ". [jiggle]" : ""]",
			"goes balls deep into \the <b>[target]</b>'s dirty [pick(ass)] over and over again. [u_His] [genital_name] comes completely coated brown from in between the bouncing [pick(asscheeks)]")
	else
		hell = list(
			"can already smell the stench as [u_He] works [u_His] [genital_name] into \the <b>[target]</b>'s dung hole, being received by warm, wet and nasty feeling all over it.",
			"grabs the base of [u_His] twitching [genital_name] and presses the tip into \the <b>[target]</b>'s asshole, immediately shoving it right into a fat and moist log",
			"shoves [genital_name] deep inside of \the <b>[target]</b>'s [pick(ass)], [t_He] releases a massive amount of mush to greet the rod[pick("", ". [jiggle]")]")
		set_is_fucking(target, CUM_TARGET_ANUS, getorganslot(ORGAN_SLOT_PENIS))

	message = span_lewd("\The <b>[src]</b> [pick(hell)]")
	visible_message(message, ignored_mobs = get_unconsenting(unholy = TRUE), ignored_mobs = get_unconsenting(unholy = TRUE))
	playlewdinteractionsound(target.loc, pick(GLOB.brap_noises), 70, 1, -1)
	playlewdinteractionsound(target.loc, pick('modular_sand/sound/interactions/bang1.ogg',
						'modular_sand/sound/interactions/bang2.ogg',
						'modular_sand/sound/interactions/bang3.ogg',
						'modular_sand/sound/interactions/bang4.ogg',
						'modular_sand/sound/interactions/bang5.ogg',
						'modular_sand/sound/interactions/bang6.ogg'), 70, 1, -1)
	if(can_penetrating_genital_cum())
		handle_post_sex(NORMAL_LUST, CUM_TARGET_ANUS, target, ORGAN_SLOT_PENIS)
	target.handle_post_sex(NORMAL_LUST, null, src)

/mob/living/proc/suck_shit(mob/living/target)
	var/message
	var/list/hell
	var/t_His = target.p_their()
	var/u_His = p_their()

	var/list/stank = list("greasy", "rancid", "pungent", "rotten", "boiling hot", "wet", "nose-burning", "heavy", "dense", "thick", "stinky", "stenchy", "warm")
	var/list/stankhole = list("greasy", "stinky", "dirty", "gassy", "brapping", "noisy", "quaking", "musky")

	if(is_fucking(target, GRINDING_FACE_WITH_ANUS))
		hell = list(
			"smooches and sucks \the <b>[target]</b>'s [pick(pick(stankhole) + " ", "")] pucker, gulping down a whole log of [pick(stank)] shit!",
			"pierces \the <b>[target]</b>'s [pick(pick(stankhole) + " ", "")] butthole with [u_His] tongue, forcing them to evacuate a [pick(stank)] right down [u_His] throat!",
			"sucks into \the <b>[target]</b>'s [pick(pick(stankhole) + " ", "")] asshole, gulping down [t_His] [pick(stank)] scat!"
		)
	else
		hell = list(
			"presses [u_His] face right into \the <b>[target]</b>'s [pick(list("musky ", "sweaty ", ""))] backside, spreading [t_His] shithole open to begin harvesting [t_His] [pick(stank) + " "] manure!",
			"uses [u_His] lips to spread \the <b>[target]</b>'s [pick(stankhole) + " "] butthole, forcing him to take a massive dump on [u_His] mouth!"
		)
		set_is_fucking(target, GRINDING_FACE_WITH_ANUS, null)

	message = span_lewd("\The <b>[src]</b> [pick(hell)]")
	visible_message(message, ignored_mobs = get_unconsenting(unholy = TRUE))
	playlewdinteractionsound(target.loc, pick(GLOB.brap_noises), 50, 1, -1, ignored_mobs = get_unconsenting(unholy = TRUE))
	playlewdinteractionsound(target.loc, 'modular_sand/sound/interactions/champ_fingering.ogg', 50, 1, -1, ignored_mobs = get_unconsenting(unholy = TRUE))
	target.handle_post_sex(NORMAL_LUST, null, src, ORGAN_SLOT_ANUS)

/mob/living/proc/piss_over(mob/living/target)
	var/message
	var/u_His = p_their()
	var/list/hell = list(
		"relieves [u_His] bladder all over \the <b>[target]</b>[pick(list("", "'s body"))]",
		"starts coating all of \the <b>[target]</b>'s body in warm piss",
		"lets out a moan of relief as yellow rain starts pouring over \the <b>[target]</b>"
	)

	message = span_lewd("\The <b>[src]</b> [pick(hell)]")
	visible_message(message, ignored_mobs = get_unconsenting(unholy = TRUE))
	if(get_lust() < 10)
		add_lust(10)

/mob/living/carbon/proc/piss_mouth(mob/living/target)
	var/message
	var/pee_pee = (has_penis() == HAS_EXPOSED_GENITAL ? getorganslot(ORGAN_SLOT_PENIS) : (has_vagina() == HAS_EXPOSED_GENITAL ? getorganslot(ORGAN_SLOT_VAGINA) : null))
	var/u_His = p_their()
	var/t_Him = target.p_them()
	var/list/hell = list(
		"relieves [u_His] bladder inside \the <b>[target]</b>'s mouth [pick(list("filling it with [pick(list("warm", "salty"))] yellow goodness", "making [t_Him] taste all of that piss"))]",
		"coats the back of \the <b>[target]</b>'s throat with [u_His] golden treat",
		"lets out a moan of relief as yellow rain starts pouring in between \the <b>[target]</b>'s lips"
	)

	message = span_lewd("\The <b>[src]</b> [pick(hell)]")
	visible_message(message, ignored_mobs = get_unconsenting(unholy = TRUE))
	if(!is_fucking(target, CUM_TARGET_MOUTH))
		set_is_fucking(target, CUM_TARGET_MOUTH, pee_pee)
	handle_post_sex(NORMAL_LUST, CUM_TARGET_MOUTH, target, pee_pee)
