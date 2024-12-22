
/*--------------------------------------------------
-------------------MOB STUFF----------------------
--------------------------------------------------
*/
//I'm sorry, lewd should not have mob procs such as life() and such in it. //NO SHIT IT SHOULDNT I REMOVED THEM

/*
 * Lewd interactions have a blacklist for certain mobs. When we evalute the user and target, both of
 * their requirements must be satisfied, and the mob must not be of a blacklisted type.
*/
/datum/interaction/lewd
	var/list/blacklisted_mobs = list(/mob/living/simple_animal/pet,
									/mob/living/simple_animal/cockroach,
									/mob/living/simple_animal/babyKiwi,
									/mob/living/simple_animal/butterfly,
									/mob/living/simple_animal/chick,
									/mob/living/simple_animal/chicken,
									/mob/living/simple_animal/cow,
									/mob/living/simple_animal/crab,
									/mob/living/simple_animal/kiwi,
									/mob/living/simple_animal/parrot,
									/mob/living/simple_animal/sloth,
									/mob/living/simple_animal/pickle,
									/mob/living/simple_animal/hostile/retaliate/goat)


/// This should not be too weighty on the server, as the check is only run to generate the menu options.
/datum/interaction/lewd/evaluate_user(mob/living/user, silent, action_check)
	. = ..()
	if(.)
		if((user.stat == DEAD))
			return FALSE
		for(var/check in blacklisted_mobs)
			if(istype(user, check))
				return FALSE

/datum/interaction/lewd/evaluate_target(mob/living/user, mob/living/target, silent = TRUE)
	. = ..()
	if(.)
		if((target.stat == DEAD))
			return FALSE
		for(var/check in blacklisted_mobs)
			if(istype(target, check))
				return FALSE

/proc/playlewdinteractionsound(turf/turf_source, soundin, vol as num, vary, extrarange as num, frequency, falloff, channel = 0, pressure_affected = TRUE, sound/S, envwet = -10000, envdry = 0, manual_x, manual_y, list/ignored_mobs)
	var/list/hearing_mobs
	for(var/mob/H in get_hearers_in_view(4, turf_source))
		if(!H.client || (H.client.prefs.toggles & LEWD_VERB_SOUNDS))
			continue
		LAZYADD(hearing_mobs, H)
	if(ignored_mobs?.len)
		LAZYREMOVE(hearing_mobs, ignored_mobs)
	for(var/mob/H in hearing_mobs)
		H.playsound_local(turf_source, soundin, vol, vary, frequency, falloff)

/mob/living
	var/has_penis = FALSE
	var/has_vagina = FALSE
	var/has_anus = TRUE
	var/has_breasts = FALSE
	var/anus_exposed = FALSE
	var/last_partner
	var/last_orifice
	var/obj/item/organ/last_genital
	var/lastmoan
	var/sexual_potency = 15
	var/lust_tolerance = 100
	var/lastlusttime = 0
	var/lust = 0
	var/multiorgasms = 1
	var/refractory_period = 0
	var/last_interaction_time = 0
	var/datum/interaction/lewd/last_lewd_datum	//Recording our last lewd datum allows us to do stuff like custom cum messages.
												//Yes i feel like an idiot writing this.
	var/cleartimer //Timer for clearing the "last_lewd_datum". This prevents some oddities.

/mob/living/proc/clear_lewd_datum()
	last_lewd_datum = null
	last_genital = null

/mob/living/Initialize()
	. = ..()
	sexual_potency =rand(10,25)
	lust_tolerance = rand(75,200)

/mob/living/proc/get_lust_tolerance()
	. = lust_tolerance
	if(has_dna())
		var/mob/living/carbon/user = src
		if(user.dna.features["lust_tolerance"])
			. = user.dna.features["lust_tolerance"]

/mob/living/proc/get_sexual_potency()
	. = sexual_potency
	if(has_dna())
		var/mob/living/carbon/user = src
		if(user.dna.features["sexual_potency"])
			. = user.dna.features["sexual_potency"]

/mob/living/proc/get_refraction_dif()
	var/dif = (refractory_period - world.time)
	if(dif < 0)
		return 0
	else
		return dif

/mob/living/proc/add_lust(add)
	var/cur = get_lust() //GetLust handles per-time lust loss
	if((cur + add) < 0) //in case we retract lust
		lust = 0
	else
		lust = cur + add


/mob/living/proc/get_lust()
	var/curtime = world.time
	var/dif = (curtime - lastlusttime) / 10 //how much lust would we lose over time
	if((lust - dif) < 0)
		lust = 0
	else
		lust = lust - dif

	lastlusttime = world.time
	return lust

/mob/living/proc/set_lust(num)
	lust = num
	lastlusttime = world.time

/mob/living/proc/has_penis(visibility = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(has_penis && !istype(C))
		return TRUE
	if(istype(C))
		var/obj/item/organ/external/genital/peepee = C.get_organ_slot(ORGAN_SLOT_PENIS)
		if(peepee)
			switch(visibility)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(peepee.is_exposed())
						return TRUE
					else
						return FALSE
				if(REQUIRE_UNEXPOSED)
					if(!peepee.is_exposed())
						return TRUE
					else
						return FALSE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_balls(visibility = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/external/genital/peepee = C.get_organ_slot(ORGAN_SLOT_TESTICLES)
		if(peepee)
			switch(visibility)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(peepee.is_exposed())
						return TRUE
					else
						return FALSE
				if(REQUIRE_UNEXPOSED)
					if(!peepee.is_exposed())
						return TRUE
					else
						return FALSE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_vagina(visibility = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(has_vagina && !istype(C))
		return TRUE
	if(istype(C))
		var/obj/item/organ/external/genital/peepee = C.get_organ_slot(ORGAN_SLOT_VAGINA)
		if(peepee)
			switch(visibility)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(peepee.is_exposed())
						return TRUE
					else
						return FALSE
				if(REQUIRE_UNEXPOSED)
					if(!peepee.is_exposed())
						return TRUE
					else
						return FALSE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_breasts(visibility = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(has_breasts && !istype(C))
		return TRUE
	if(istype(C))
		var/obj/item/organ/external/genital/peepee = C.get_organ_slot(ORGAN_SLOT_BREASTS)
		if(peepee)
			switch(visibility)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(peepee.is_exposed())
						return TRUE
					else
						return FALSE
				if(REQUIRE_UNEXPOSED)
					if(!peepee.is_exposed())
						return TRUE
					else
						return FALSE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_anus(visibility = REQUIRE_ANY)
	if(has_anus && !iscarbon(src))
		return TRUE
	switch(visibility)
		if(REQUIRE_ANY)
			return TRUE
		if(REQUIRE_EXPOSED)
			switch(anus_exposed)
				if(-1)
					return FALSE
				if(1)
					return TRUE
				else
					if(is_bottomless())
						return TRUE
					else
						return FALSE
		if(REQUIRE_UNEXPOSED)
			if(anus_exposed == -1)
				if(!anus_exposed)
					if(!is_bottomless())
						return TRUE
					else
						return FALSE
				else
					return FALSE
			else
				return TRUE
		else
			return TRUE

/mob/living/proc/has_hand(visibility = REQUIRE_ANY)
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/handcount = 0
		var/covered = 0
		var/iscovered = FALSE
		for(var/obj/item/bodypart/l_arm/L in C.bodyparts)
			handcount++
		for(var/obj/item/bodypart/r_arm/R in C.bodyparts)
			handcount++
		if(C.get_item_by_slot(ITEM_SLOT_HANDS))
			var/obj/item/clothing/gloves/G = C.get_item_by_slot(ITEM_SLOT_HANDS)
			covered = G.body_parts_covered
		if(covered & HANDS)
			iscovered = TRUE
		switch(visibility)
			if(REQUIRE_ANY)
				return handcount
			if(REQUIRE_EXPOSED)
				if(iscovered)
					return FALSE
				else
					return handcount
			if(REQUIRE_UNEXPOSED)
				if(!iscovered)
					return FALSE
				else
					return handcount
			else
				return handcount
	return FALSE

/mob/living/proc/has_feet(visibility = REQUIRE_ANY)
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/feetcount = 0
		var/covered = 0
		var/iscovered = FALSE
		for(var/obj/item/bodypart/l_leg/L in C.bodyparts)
			feetcount++
		for(var/obj/item/bodypart/r_leg/R in C.bodyparts)
			feetcount++
		if(!C.is_barefoot())
			covered = TRUE
		if(covered)
			iscovered = TRUE
		switch(visibility)
			if(REQUIRE_ANY)
				return feetcount
			if(REQUIRE_EXPOSED)
				if(iscovered)
					return FALSE
				else
					return feetcount
			if(REQUIRE_UNEXPOSED)
				if(!iscovered)
					return FALSE
				else
					return feetcount
			else
				return feetcount
	return FALSE

/mob/living/proc/get_num_feet()
	return has_feet(REQUIRE_ANY)

//weird procs go here
/mob/living/proc/has_ears(visibility = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.get_organ_slot(ORGAN_SLOT_EARS)
		if(peepee)
			switch(visibility)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(C.get_item_by_slot(ITEM_SLOT_EARS_LEFT) || C.get_item_by_slot(ITEM_SLOT_EARS_RIGHT))
						return FALSE
					else
						return TRUE
				if(REQUIRE_UNEXPOSED)
					if(!C.get_item_by_slot(ITEM_SLOT_EARS_LEFT || C.get_item_by_slot(ITEM_SLOT_EARS_RIGHT)))
						return FALSE
					else
						return TRUE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_earsockets(visibility = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.get_organ_slot(ORGAN_SLOT_EARS)
		if(!peepee)
			switch(visibility)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(C.get_item_by_slot(ITEM_SLOT_EARS_LEFT) || C.get_item_by_slot(ITEM_SLOT_EARS_RIGHT))
						return FALSE
					else
						return TRUE
				if(REQUIRE_UNEXPOSED)
					if(!C.get_item_by_slot(ITEM_SLOT_EARS_LEFT) || !C.get_item_by_slot(ITEM_SLOT_EARS_RIGHT))
						return FALSE
					else
						return TRUE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_eyes(visibility = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.get_organ_slot(ORGAN_SLOT_EYES)
		if(peepee)
			switch(visibility)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(C.get_item_by_slot(ITEM_SLOT_EYES))
						return FALSE
					else
						return TRUE
				if(REQUIRE_UNEXPOSED)
					if(!C.get_item_by_slot(ITEM_SLOT_EYES))
						return FALSE
					else
						return TRUE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_eyesockets(visibility = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.get_organ_slot(ORGAN_SLOT_EYES)
		if(!peepee)
			switch(visibility)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(get_item_by_slot(ITEM_SLOT_EYES))
						return FALSE
					else
						return TRUE
				if(REQUIRE_UNEXPOSED)
					if(!get_item_by_slot(ITEM_SLOT_EYES))
						return FALSE
					else
						return TRUE
				else
					return TRUE
	return FALSE

///Are we wearing something that covers our chest?
/mob/living/proc/is_topless()
	for(var/slot in GLOB.slots)
		var/obj/item/clothing = vars[slot]
		if(clothing)
			if(clothing.body_parts_covered & CHEST)
				return FALSE
	// If didn't stop before, then we're topless
	return TRUE

///Are we wearing something that covers our groin?
/mob/living/proc/is_bottomless()
	for(var/slot in GLOB.slots)
		var/obj/item/clothing = vars[slot]
		if(clothing)
			if(clothing.body_parts_covered & GROIN)
				return FALSE
	// If didn't stop before, then we're bottomless
	return TRUE

///Are we wearing something that covers our shoes?
/mob/living/proc/is_barefoot()
	for(var/slot in GLOB.slots)
		var/obj/item/clothing = vars[slot]
		if(clothing)
			if(clothing.body_parts_covered & FEET)
				return FALSE
	// If didn't stop before, then we're barefoot
	return TRUE

/mob/living/proc/moan()
	if(!(prob(get_lust() / get_lust_tolerance() * 65)))
		return
	var/moan = rand(1, 7)
	if(moan == lastmoan)
		moan--
	if(!is_muzzled())
		visible_message(message = "<span class='lewd'><B>\The [src]</B> [pick("moans", "moans in pleasure")].</span>", ignored_mobs = get_unconsenting())
	if(is_muzzled())//immursion
		audible_message("<span class='lewd'><B>[src]</B> [pick("mimes a pleasured moan","moans in silence")].</span>")
	lastmoan = moan

/mob/living/proc/cum(mob/living/partner, target_orifice)
	var/message
	var/u_His = p_their()
	var/u_He = p_they()
	var/u_S = p_s()
	var/t_His = partner?.p_their()
	var/cumin = FALSE
	var/partner_carbon_check = FALSE
	var/obj/item/organ/external/genital/target_gen = null
	var/mob/living/carbon/c_partner = null
	//Carbon checks
	if(iscarbon(partner))
		c_partner = partner
		partner_carbon_check = TRUE

	if(src != partner)
		if(!last_genital)
			if(has_penis())
				if(!istype(partner))
					target_orifice = null
				switch(target_orifice)
					if(CUM_TARGET_MOUTH)
						if(partner.has_mouth() && partner.mouth_is_free())
							message = "cums right in \the <b>[partner]</b>'s mouth."
							cumin = TRUE
						else
							message = "cums on \the <b>[partner]</b>'s face."
					if(CUM_TARGET_THROAT)
						if(partner.has_mouth() && partner.mouth_is_free())
							message = "shoves deep into \the <b>[partner]</b>'s throat and cums."
							cumin = TRUE
						else
							message = "cums on \the <b>[partner]</b>'s face."
					if(CUM_TARGET_VAGINA)
						if(partner.has_vagina(REQUIRE_EXPOSED))
							if(partner_carbon_check)
								target_gen = c_partner.get_organ_slot(ORGAN_SLOT_VAGINA)
							message = "cums in \the <b>[partner]</b>'s pussy."
							cumin = TRUE
						else
							message = "cums on \the <b>[partner]</b>'s belly."
					if(CUM_TARGET_ANUS)
						if(partner.has_anus(REQUIRE_EXPOSED))
							message = "cums in \the <b>[partner]</b>'s asshole."
							cumin = TRUE
						else
							message = "cums on \the <b>[partner]</b>'s backside."
					if(CUM_TARGET_HAND)
						if(partner.has_hand(REQUIRE_ANY))
							message = "cums in \the <b>[partner]</b>'s hand."
						else
							message = "cums on \the <b>[partner]</b>."
					if(CUM_TARGET_BREASTS)
						if(partner.has_breasts(REQUIRE_EXPOSED))
							message = "cums onto \the <b>[partner]</b>'s breasts."
						else
							message = "cums on \the <b>[partner]</b>'s chest and neck."
					if(NUTS_TO_FACE)
						if(partner.has_mouth() && partner.mouth_is_free())
							message = "vigorously ruts [u_His] nutsack into \the <b>[partner]</b>'s mouth before shooting [u_His] thick, sticky jizz all over [t_His] eyes and hair."
					if(THIGH_SMOTHERING)
						if(has_penis(REQUIRE_EXPOSED)) //it already checks for the cock before, why the hell would you do this redundant shit
							message = "keeps \the <b>[partner]</b> locked in [u_His] thighs as [u_His] cock throbs, dumping its heavy load all over [t_His] face."
						else
							message = "reaches [u_His] peak, locking [u_His] legs around \the <b>[partner]</b>'s head extra hard as [u_He] cum[u_S] straight onto the head stuck between [u_His] thighs"
						cumin = TRUE
					if(CUM_TARGET_FEET)
						if(!last_lewd_datum.require_target_num_feet)
							if(partner.has_feet())
								message = "cums on \the <b>[partner]</b>'s [partner.has_feet() == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
							else
								message = "cums on the floor!"
						else
							if(partner.has_feet())
								message = "cums on \the <b>[partner]</b>'s [last_lewd_datum.require_target_feet == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
							else
								message = "cums on the floor!"
					//weird shit goes here
					if(CUM_TARGET_EARS)
						if(partner.has_ears())
							message = "cums inside \the <b>[partner]</b>'s ear."
						else
							message = "cums inside \the <b>[partner]</b>'s earsocket."
						cumin = TRUE
					if(CUM_TARGET_EYES)
						if(partner.has_eyes())
							message = "cums on \the <b>[partner]</b>'s eyeball."
						else
							message = "cums inside \the <b>[partner]</b>'s eyesocket."
						cumin = TRUE
					//
					if(CUM_TARGET_PENIS)
						if(partner.has_penis(REQUIRE_EXPOSED))
							message = "cums on \the <b>[partner]</b>."
						else
							message = "cums on the floor!"
					else
						message = "cums on the floor!"
			else if(has_vagina())
				if(!istype(partner))
					target_orifice = null

				switch(target_orifice)
					if(CUM_TARGET_MOUTH)
						if(partner.has_mouth() && partner.mouth_is_free())
							message = "squirts right in \the <b>[partner]</b>'s mouth."
							cumin = TRUE
						else
							message = "squirts on \the <b>[partner]</b>'s face."
					if(CUM_TARGET_THROAT)
						if(partner.has_mouth() && partner.mouth_is_free())
							message = "rubs [u_His] vagina against \the <b>[partner]</b>'s mouth and cums."
							cumin = TRUE
						else
							message = "squirts on \the <b>[partner]</b>'s face."
					if(CUM_TARGET_VAGINA)
						if(partner.has_vagina(REQUIRE_EXPOSED))
							message = "squirts on \the <b>[partner]</b>'s pussy."
							cumin = TRUE
						else
							message = "squirts on \the <b>[partner]</b>'s belly."
					if(CUM_TARGET_ANUS)
						if(partner.has_anus(REQUIRE_EXPOSED))
							message = "squirts on \the <b>[partner]</b>'s asshole."
							cumin = TRUE
						else
							message = "squirts on \the <b>[partner]</b>'s backside."
					if(CUM_TARGET_HAND)
						if(partner.has_hand(REQUIRE_ANY))
							message = "squirts on \the <b>[partner]</b>'s hand."
						else
							message = "squirts on \the <b>[partner]</b>."
					if(CUM_TARGET_BREASTS)
						if(partner.has_breasts(REQUIRE_EXPOSED))
							message = "squirts onto \the <b>[partner]</b>'s breasts."
						else
							message = "squirts on \the <b>[partner]</b>'s chest and neck."
					if(NUTS_TO_FACE)
						if(partner.has_mouth() && partner.mouth_is_free())
							message = "vigorously ruts [u_His] clit into \the <b>[partner]</b>'s mouth before shooting [u_His] femcum all over [t_His] eyes and hair."
					if(THIGH_SMOTHERING)
						message = "keeps \the <b>[partner]</b> locked in [u_His] thighs as [u_He] orgasm[u_S], squirting over [t_His] face."
						cumin = TRUE
					if(CUM_TARGET_FEET)
						if(!last_lewd_datum.require_target_num_feet)
							if(partner.has_feet())
								message = "squirts on \the <b>[partner]</b>'s [partner.has_feet() == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
							else
								message = "squirts on the floor!"
						else
							if(partner.has_feet())
								message = "squirts on \the <b>[partner]</b>'s [last_lewd_datum.require_target_feet == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
							else
								message = "squirts on the floor!"
					//weird shit goes here
					if(CUM_TARGET_EARS)
						if(partner.has_ears())
							message = "squirts on \the <b>[partner]</b>'s ear."
						else
							message = "squirts on \the <b>[partner]</b>'s earsocket."
						cumin = TRUE
					if(CUM_TARGET_EYES)
						if(partner.has_eyes())
							message = "squirts on \the <b>[partner]</b>'s eyeball."
						else
							message = "squirts on \the <b>[partner]</b>'s eyesocket."
						cumin = TRUE
					//
					if(CUM_TARGET_PENIS)
						if(partner.has_penis(REQUIRE_EXPOSED))
							message = "squirts on \the <b>[partner]</b>'s penis"
						else
							message = "squirts on the floor!"
					else
						message = "squirts on the floor!"

			else
				message = pick("orgasms violently!", "twists in orgasm.")
		else
			switch(last_genital.type)
				if(/obj/item/organ/external/genital/penis)
					if(!istype(partner))
						target_orifice = null

					switch(target_orifice)
						if(CUM_TARGET_MOUTH)
							if(partner.has_mouth() && partner.mouth_is_free())
								message = "cums right in \the <b>[partner]</b>'s mouth."
								cumin = TRUE
							else
								message = "cums on \the <b>[partner]</b>'s face."
						if(CUM_TARGET_THROAT)
							if(partner.has_mouth() && partner.mouth_is_free())
								message = "shoves deep into \the <b>[partner]</b>'s throat and cums."
								cumin = TRUE
							else
								message = "cums on \the <b>[partner]</b>'s face."
						if(CUM_TARGET_VAGINA)
							if(partner.has_vagina(REQUIRE_EXPOSED))
								if(partner_carbon_check)
									target_gen = c_partner.get_organ_slot(ORGAN_SLOT_VAGINA)
								message = "cums in \the <b>[partner]</b>'s pussy."
								cumin = TRUE
							else
								message = "cums on \the <b>[partner]</b>'s belly."
						if(CUM_TARGET_ANUS)
							if(partner.has_anus(REQUIRE_EXPOSED))
								message = "cums in \the <b>[partner]</b>'s asshole."
								cumin = TRUE
							else
								message = "cums on \the <b>[partner]</b>'s backside."
						if(CUM_TARGET_HAND)
							if(partner.has_hand())
								message = "cums in \the <b>[partner]</b>'s hand."
							else
								message = "cums on \the <b>[partner]</b>."
						if(CUM_TARGET_BREASTS)
							if(partner.is_topless() && partner.has_breasts())
								message = "cums onto \the <b>[partner]</b>'s breasts."
							else
								message = "cums on \the <b>[partner]</b>'s chest and neck."
						if(NUTS_TO_FACE)
							if(partner.has_mouth() && partner.mouth_is_free())
								message = "vigorously ruts [u_His] nutsack into \the <b>[partner]</b>'s mouth before shooting [u_His] thick, sticky jizz all over [t_His] eyes and hair."
						if(THIGH_SMOTHERING)
							if(has_penis()) //it already checks for the cock before, why the hell would you do this redundant shit
								message = "keeps \the <b>[partner]</b> locked in [u_His] thighs as [u_His] cock throbs, dumping its heavy load all over [t_His] face."
							else
								message = "reaches [u_His] peak, locking [u_His] legs around \the <b>[partner]</b>'s head extra hard as [u_He] cum[u_S] straight onto the head stuck between [u_His] thighs"
							cumin = TRUE
						if(CUM_TARGET_FEET)
							if(!last_lewd_datum || !last_lewd_datum.require_target_num_feet)
								if(partner.has_feet())
									message = "cums on \the <b>[partner]</b>'s [partner.has_feet() == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
								else
									message = "cums on the floor!"
							else
								if(partner.has_feet())
									message = "cums on \the <b>[partner]</b>'s [last_lewd_datum.require_target_feet == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
								else
									message = "cums on the floor!"
						//weird shit goes here
						if(CUM_TARGET_EARS)
							if(partner.has_ears())
								message = "cums inside \the <b>[partner]</b>'s ear."
							else
								message = "cums inside \the <b>[partner]</b>'s earsocket."
							cumin = TRUE
						if(CUM_TARGET_EYES)
							if(partner.has_eyes())
								message = "cums on \the <b>[partner]</b>'s eyeball."
							else
								message = "cums inside \the <b>[partner]</b>'s eyesocket."
							cumin = TRUE
						//
						if(CUM_TARGET_PENIS)
							if(partner.has_penis(REQUIRE_EXPOSED))
								message = "cums on \the <b>[partner]</b>."
							else
								message = "cums on the floor!"
						else
							message = "cums on the floor!"
				if(/obj/item/organ/external/genital/vagina)
					if(!istype(partner))
						target_orifice = null

					switch(target_orifice)
						if(CUM_TARGET_MOUTH)
							if(partner.has_mouth() && partner.mouth_is_free())
								message = "squirts right in \the <b>[partner]</b>'s mouth."
								cumin = TRUE
							else
								message = "squirts on \the <b>[partner]</b>'s face."
						if(CUM_TARGET_THROAT)
							if(partner.has_mouth() && partner.mouth_is_free())
								message = "rubs [u_His] vagina against \the <b>[partner]</b>'s mouth and cums."
								cumin = TRUE
							else
								message = "squirts on \the <b>[partner]</b>'s face."
						if(CUM_TARGET_VAGINA)
							if(partner.has_vagina(REQUIRE_EXPOSED))
								message = "squirts on \the <b>[partner]</b>'s pussy."
								cumin = TRUE
							else
								message = "squirts on \the <b>[partner]</b>'s belly."
						if(CUM_TARGET_ANUS)
							if(partner.has_anus(REQUIRE_EXPOSED))
								message = "squirts on \the <b>[partner]</b>'s asshole."
								cumin = TRUE
							else
								message = "squirts on \the <b>[partner]</b>'s backside."
						if(CUM_TARGET_HAND)
							if(partner.has_hand())
								message = "squirts on \the <b>[partner]</b>'s hand."
							else
								message = "squirts on \the <b>[partner]</b>."
						if(CUM_TARGET_BREASTS)
							if(partner.has_breasts(REQUIRE_EXPOSED))
								message = "squirts onto \the <b>[partner]</b>'s breasts."
							else
								message = "squirts on \the <b>[partner]</b>'s chest and neck."
						if(NUTS_TO_FACE)
							if(partner.has_mouth() && partner.mouth_is_free())
								message = "vigorously ruts [u_His] clit into \the <b>[partner]</b>'s mouth before shooting [u_His] femcum all over [t_His] eyes and hair."

						if(THIGH_SMOTHERING)
							message = "keeps \the <b>[partner]</b> locked in [u_His] thighs as [u_He] orgasm[u_S], squirting over [t_His] face."

						if(CUM_TARGET_FEET)
							if(!last_lewd_datum || !last_lewd_datum.require_target_num_feet)
								if(partner.has_feet())
									message = "squirts on \the <b>[partner]</b>'s [partner.has_feet() == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
								else
									message = "squirts on the floor!"
							else
								if(partner.has_feet())
									message = "squirts on \the <b>[partner]</b>'s [last_lewd_datum.require_target_feet == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
								else
									message = "squirts on the floor!"
						//weird shit goes here
						if(CUM_TARGET_EARS)
							if(partner.has_ears())
								message = "squirts on \the <b>[partner]</b>'s ear."
							else
								message = "squirts on \the <b>[partner]</b>'s earsocket."
							cumin = TRUE
						if(CUM_TARGET_EYES)
							if(partner.has_eyes())
								message = "squirts on \the <b>[partner]</b>'s eyeball."
							else
								message = "squirts on \the <b>[partner]</b>'s eyesocket."
							cumin = TRUE
						//
						if(CUM_TARGET_PENIS)
							if(partner.has_penis(REQUIRE_EXPOSED))
								message = "squirts on \the <b>[partner]</b>'s penis"
							else
								message = "squirts on the floor!"
						else
							message = "squirts on the floor!"
				else
					message = pick("orgasms violently!", "twists in orgasm.")
	else //todo: better self cum messages
		message = "cums all over themselves!"
	if(gender == MALE)
		playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/final_m1.ogg',
							'modular_sand/sound/interactions/final_m2.ogg',
							'modular_sand/sound/interactions/final_m3.ogg',
							'modular_sand/sound/interactions/final_m4.ogg',
							'modular_sand/sound/interactions/final_m5.ogg'), 90, 1, 0)
	else if(gender == FEMALE)
		playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/final_f1.ogg',
							'modular_sand/sound/interactions/final_f2.ogg',
							'modular_sand/sound/interactions/final_f3.ogg'), 70, 1, 0)
	else
		playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/final_f1.ogg',
							'modular_sand/sound/interactions/final_f2.ogg',
							'modular_sand/sound/interactions/final_f3.ogg'), 70, 1, 0)
	visible_message(message = "<span class='userlove'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	multiorgasms += 1

	if(multiorgasms > (get_sexual_potency() * 0.34)) //AAAAA, WE DONT WANT NEGATIVES HERE, RE
		refractory_period = world.time + rand(300, 900) - get_sexual_potency()//sex cooldown
		// set_drugginess(rand(20, 30))
	else
		refractory_period = world.time + rand(300, 900) - get_sexual_potency()
		// set_drugginess(rand(5, 10))
	if(multiorgasms < get_sexual_potency())
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			if(!partner)
				H.mob_climax(TRUE, "masturbation", "none")
			else
				H.mob_climax(TRUE, "sex", partner, !cumin, target_gen)
	set_lust(0)

/mob/living/proc/is_fucking(mob/living/partner, orifice)
	if(partner == last_partner && orifice == last_orifice)
		return TRUE
	return FALSE

/mob/living/proc/set_is_fucking(mob/living/partner, orifice, obj/item/organ/external/genital/genepool)
	last_partner = partner
	last_orifice = orifice
	last_genital = genepool

/mob/living/proc/get_shoes(singular = FALSE)
	var/obj/A = get_item_by_slot(ITEM_SLOT_FEET)
	if(A)
		var/txt = A.name
		if(findtext (A.name,"the"))
			txt = copytext(A.name, 5, length(A.name)+1)
			if(singular)
				txt = copytext(A.name, 5, length(A.name))
			return txt
		else
			if(singular)
				txt = copytext(A.name, 1, length(A.name))
			return txt

/// Handles the sex, if cumming returns true.
/mob/living/proc/handle_post_sex(amount, orifice, mob/living/partner)
	if(stat != CONSCIOUS)
		return FALSE

	if(amount)
		add_lust(amount)
	if(get_lust() >= get_lust_tolerance())
		if(prob(10))
			to_chat(src, "<b>You struggle to not orgasm!</b>")
			return FALSE
		if(lust >= get_lust_tolerance()*3)
			cum(partner, orifice)
			return TRUE
	else
		moan()
	return FALSE

/mob/living/proc/get_unconsenting(extreme = FALSE, list/ignored_mobs)
	var/list/nope = list()
	nope += ignored_mobs
	for(var/mob/M in range(7, src))
		if(M.client)
			var/client/cli = M.client
			if(!(cli.prefs.toggles & VERB_CONSENT)) //Note: This probably could do with a specific preference
				nope += M
			else if(extreme && (cli.prefs.extremepref == "No"))
				nope += M
		else
			nope += M
	return nope
