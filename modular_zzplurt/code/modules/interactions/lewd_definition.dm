
/*--------------------------------------------------
-------------------MOB STUFF----------------------
--------------------------------------------------
*/
//I'm sorry, lewd should not have mob procs such as life() and such in it. //NO SHIT IT SHOULDNT I REMOVED THEM

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
	var/has_balls = FALSE
	var/has_vagina = FALSE
	var/has_anus = TRUE
	var/has_butt = FALSE
	var/anus_always_accessible = FALSE
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
	COOLDOWN_DECLARE(refractory_period)
	COOLDOWN_DECLARE(last_interaction_time)
	var/datum/interaction/lewd/last_lewd_datum	//Recording our last lewd datum allows us to do stuff like custom cum messages.
												//Yes i feel like an idiot writing this.
	var/cleartimer //Timer for clearing the "last_lewd_datum". This prevents some oddities.

/mob/living/proc/clear_lewd_datum()
	last_partner = null
	last_orifice = null
	last_genital = null
	last_lewd_datum = null

/mob/living/Initialize(mapload)
	. = ..()
	sexual_potency = rand(10,25)
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

/mob/living/proc/toggle_anus_always_accessible(accessibility)
	anus_always_accessible = isnull(accessibility) ? !anus_always_accessible : accessibility

/mob/living/proc/has_genital(slot)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/genital/genital = C.getorganslot(slot)
		if(genital)
			if(genital.is_exposed() || genital.always_accessible)
				return HAS_EXPOSED_GENITAL
			else
				return HAS_UNEXPOSED_GENITAL
	return FALSE

/mob/living/proc/has_penis()
	var/mob/living/carbon/C = src
	if(has_penis && !istype(C))
		return TRUE
	return has_genital(ORGAN_SLOT_PENIS)

/mob/living/proc/has_balls()
	var/mob/living/carbon/C = src
	if(has_balls && !istype(C))
		return TRUE
	return has_genital(ORGAN_SLOT_TESTICLES)

/mob/living/proc/has_vagina()
	var/mob/living/carbon/C = src
	if(has_vagina && !istype(C))
		return TRUE
	return has_genital(ORGAN_SLOT_VAGINA)

/mob/living/proc/has_breasts()
	var/mob/living/carbon/C = src
	if(has_breasts && !istype(C))
		return TRUE
	return has_genital(ORGAN_SLOT_BREASTS)

/mob/living/proc/has_butt()
	var/mob/living/carbon/C = src
	if(has_butt && !istype(C))
		return TRUE
	return has_genital(ORGAN_SLOT_BUTT)

/mob/living/proc/has_anus()
	if(has_anus && !iscarbon(src))
		return TRUE
	if (has_anus && anus_always_accessible)
		return HAS_EXPOSED_GENITAL
	switch(anus_exposed)
		if(-1)
			return HAS_UNEXPOSED_GENITAL
		if(1)
			return HAS_EXPOSED_GENITAL
		else
			if(is_bottomless())
				return HAS_EXPOSED_GENITAL
			else
				return HAS_UNEXPOSED_GENITAL

/mob/living/proc/has_hand()
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/handcount = 0
		var/covered = 0
		for(var/obj/item/bodypart/l_arm/L in C.bodyparts)
			handcount++
		for(var/obj/item/bodypart/r_arm/R in C.bodyparts)
			handcount++
		if(!handcount)
			return FALSE
		if(C.get_item_by_slot(ITEM_SLOT_HANDS))
			var/obj/item/clothing/gloves/G = C.get_item_by_slot(ITEM_SLOT_HANDS)
			covered = G.body_parts_covered
		if(covered & HANDS)
			return HAS_UNEXPOSED_GENITAL
		else
			return HAS_EXPOSED_GENITAL
	return FALSE

/mob/living/proc/has_feet()
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/feetcount = 0
		var/covered = 0
		for(var/obj/item/bodypart/l_leg/L in C.bodyparts)
			feetcount++
		for(var/obj/item/bodypart/r_leg/R in C.bodyparts)
			feetcount++
		if(!feetcount)
			return FALSE
		if(!C.is_barefoot())
			covered = TRUE
		if(covered)
			return HAS_UNEXPOSED_GENITAL
		else
			return HAS_EXPOSED_GENITAL
	return FALSE

/mob/living/proc/get_num_feet()
	return 0

/mob/living/carbon/get_num_feet()
	. = ..()
	for(var/obj/item/bodypart/l_leg/L in bodyparts)
		.++
	for(var/obj/item/bodypart/r_leg/R in bodyparts)
		.++

//weird procs go here
//please check for existance separately
/mob/living/proc/has_ears()
	var/mob/living/carbon/C = src
	if(istype(C))
		if(C.get_item_by_slot(ITEM_SLOT_EARS_LEFT) || C.get_item_by_slot(ITEM_SLOT_EARS_RIGHT))
			return HAS_UNEXPOSED_GENITAL
		else
			return HAS_EXPOSED_GENITAL
	return FALSE

/mob/living/proc/has_eyes()
	var/mob/living/carbon/C = src
	if(istype(C))
		if(C.get_item_by_slot(ITEM_SLOT_EYES))
			return HAS_UNEXPOSED_GENITAL
		else
			return HAS_EXPOSED_GENITAL
	return FALSE

///Are we wearing something that covers our chest?
/mob/living/proc/is_topless()
	for(var/slot in GLOB.slots)
		var/item_slot = GLOB.slot2slot[slot]
		if(!item_slot) // Safety
			continue
		var/obj/item/clothing = get_item_by_slot(item_slot)
		if(!clothing) // Don't have this slot or not wearing anything in it
			continue
		if(clothing.body_parts_covered & CHEST)
			return FALSE
	// If didn't stop before, then we're topless
	return TRUE

///Are we wearing something that covers our groin?
/mob/living/proc/is_bottomless()
	for(var/slot in GLOB.slots)
		var/item_slot = GLOB.slot2slot[slot]
		if(!item_slot) // Safety
			continue
		var/obj/item/clothing = get_item_by_slot(item_slot)
		if(!clothing) // Don't have this slot or not wearing anything in it
			continue
		if(clothing.body_parts_covered & GROIN)
			return FALSE
	// If didn't stop before, then we're bottomless
	return TRUE

///Are we wearing something that covers our shoes?
/mob/living/proc/is_barefoot()
	for(var/slot in GLOB.slots)
		var/item_slot = GLOB.slot2slot[slot]
		if(!item_slot) // Safety
			continue
		var/obj/item/clothing = get_item_by_slot(item_slot)
		if(!clothing) // Don't have this slot or not wearing anything in it
			continue
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
		visible_message(message = span_lewd("<B>\The [src]</B> [pick("moans", "moans in pleasure")]."), ignored_mobs = get_unconsenting())
	if(is_muzzled())//immursion
		audible_message(span_lewd("<B>[src]</B> [pick("mimes a pleasured moan","moans in silence")]."))
	lastmoan = moan

/mob/living/proc/cum(mob/living/partner, target_orifice)
	if(HAS_TRAIT(src, TRAIT_NEVERBONER))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_MOB_PRE_CAME, target_orifice, partner))
		return FALSE
	var/message
	var/u_His = p_their()
	var/u_He = p_they()
	var/u_S = p_s()
	var/t_His = partner?.p_their()
	var/cumin = FALSE
	var/partner_carbon_check = FALSE
	var/obj/item/organ/genital/target_gen = null
	var/mob/living/carbon/c_partner = null

	// Do not display to those people as well
	var/list/mob/obscure_to

	//Carbon checks
	if(iscarbon(partner))
		c_partner = partner
		partner_carbon_check = TRUE

	if(src != partner)
		if(ismob(partner))
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
							var/has_vagina = partner.has_vagina()
							if(has_vagina == TRUE || has_vagina == HAS_EXPOSED_GENITAL)
								if(partner_carbon_check)
									target_gen = c_partner.getorganslot(ORGAN_SLOT_VAGINA)
								message = "cums in \the <b>[partner]</b>'s pussy."
								cumin = TRUE
							else
								message = "cums on \the <b>[partner]</b>'s belly."
						if(CUM_TARGET_ANUS)
							var/has_anus = partner.has_anus()
							if(has_anus == TRUE || has_anus == HAS_EXPOSED_GENITAL)
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
							var/has_breasts = partner.has_breasts()
							if(has_breasts == TRUE || has_breasts == HAS_EXPOSED_GENITAL)
								message = "cums onto \the <b>[partner]</b>'s breasts."
							else
								message = "cums on \the <b>[partner]</b>'s chest and neck."
						if(NUTS_TO_FACE)
							if(partner.has_mouth() && partner.mouth_is_free())
								message = "vigorously ruts [u_His] nutsack into \the <b>[partner]</b>'s mouth before shooting [u_His] thick, sticky jizz all over [t_His] eyes and hair."
						if(THIGH_SMOTHERING)
							var/has_penis = has_penis()
							if(has_penis == TRUE || has_penis == HAS_EXPOSED_GENITAL) //it already checks for the cock before, why the hell would you do this redundant shit
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
									message = "cums on \the <b>[partner]</b>'s [last_lewd_datum.require_target_num_feet == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
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
							var/has_penis = partner.has_penis()
							if(has_penis == TRUE || has_penis == HAS_EXPOSED_GENITAL)
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
							var/has_vagina = partner.has_vagina()
							if(has_vagina == TRUE || has_vagina == HAS_EXPOSED_GENITAL)
								message = "squirts on \the <b>[partner]</b>'s pussy."
								cumin = TRUE
							else
								message = "squirts on \the <b>[partner]</b>'s belly."
						if(CUM_TARGET_ANUS)
							var/has_anus = partner.has_anus()
							if(has_anus == TRUE || has_anus == HAS_EXPOSED_GENITAL)
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
							var/has_breasts = partner.has_breasts()
							if(has_breasts == TRUE || has_breasts == HAS_EXPOSED_GENITAL)
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
									message = "squirts on \the <b>[partner]</b>'s [last_lewd_datum.require_target_num_feet == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
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
							var/has_penis = partner.has_penis()
							if(has_penis == TRUE || has_penis == HAS_EXPOSED_GENITAL)
								message = "squirts on \the <b>[partner]</b>'s penis"
							else
								message = "squirts on the floor!"
						else
							message = "squirts on the floor!"

				else
					message = pick("orgasms violently!", "twists in orgasm.")
			else
				switch(last_genital.type)
					if(/obj/item/organ/genital/penis)
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
								var/has_vagina = partner.has_vagina()
								if(has_vagina == TRUE || has_vagina == HAS_EXPOSED_GENITAL)
									if(partner_carbon_check)
										target_gen = c_partner.getorganslot(ORGAN_SLOT_VAGINA)
									message = "cums in \the <b>[partner]</b>'s pussy."
									cumin = TRUE
								else
									message = "cums on \the <b>[partner]</b>'s belly."
							if(CUM_TARGET_ANUS)
								var/has_anus = partner.has_anus()
								if(has_anus == TRUE || has_anus == HAS_EXPOSED_GENITAL)
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
										message = "cums on \the <b>[partner]</b>'s [last_lewd_datum.require_target_num_feet == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
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
								var/has_penis = partner.has_penis()
								if(has_penis == TRUE || has_penis == HAS_EXPOSED_GENITAL)
									message = "cums on \the <b>[partner]</b>."
								else
									message = "cums on the floor!"
							else
								message = "cums on the floor!"
					if(/obj/item/organ/genital/vagina)
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
								var/has_vagina = partner.has_vagina()
								if(has_vagina == TRUE || has_vagina == HAS_EXPOSED_GENITAL)
									message = "squirts on \the <b>[partner]</b>'s pussy."
									cumin = TRUE
								else
									message = "squirts on \the <b>[partner]</b>'s belly."
							if(CUM_TARGET_ANUS)
								var/has_anus = partner.has_anus()
								if(has_anus == TRUE || has_anus == HAS_EXPOSED_GENITAL)
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
								var/has_breasts = partner.has_breasts()
								if(has_breasts == TRUE || has_breasts == HAS_EXPOSED_GENITAL)
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
										message = "squirts on \the <b>[partner]</b>'s [last_lewd_datum.require_target_num_feet == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
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
								var/has_penis = partner.has_penis()
								if(has_penis == TRUE || has_penis == HAS_EXPOSED_GENITAL)
									message = "squirts on \the <b>[partner]</b>'s penis"
								else
									message = "squirts on the floor!"
							else
								message = "squirts on the floor!"
					else
						message = pick("orgasms violently!", "twists in orgasm.")
		else if(istype(partner, /obj/item/reagent_containers))
			var/did_anything = TRUE
			switch(last_genital.type)
				if(/obj/item/organ/genital/penis)
					message = "cums into \the <b>[partner]</b>!"
				if(/obj/item/organ/genital/vagina)
					message = "squirts into \the <b>[partner]</b>!"
				else
					did_anything = FALSE
			if(did_anything)
				LAZYADD(obscure_to, src)
	if(!message) //todo: better self cum messages
		message = "cums all over themselves!"
	if(gender == MALE)
		playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/final_m1.ogg',
							'modular_sand/sound/interactions/final_m2.ogg',
							'modular_sand/sound/interactions/final_m3.ogg',
							'modular_sand/sound/interactions/final_m4.ogg',
							'modular_sand/sound/interactions/final_m5.ogg'), 90, 1, 0)
	else
		playlewdinteractionsound(loc, pick('modular_sand/sound/interactions/final_f1.ogg',
							'modular_sand/sound/interactions/final_f2.ogg',
							'modular_sand/sound/interactions/final_f3.ogg'), 70, 1, 0)
	visible_message(message = span_userlove("<b>\The [src]</b> [message]"), ignored_mobs = get_unconsenting(ignored_mobs = obscure_to))
	multiorgasms += 1

	COOLDOWN_START(src, refractory_period, (rand(300, 900) - get_sexual_potency()))//sex cooldown
	if(multiorgasms < get_sexual_potency())
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			if(!partner)
				H.mob_climax(TRUE, "masturbation", "none")
			else if(istype(partner, /obj/item/reagent_containers))
				H.mob_fill_container(last_genital, partner, 0)
			else
				H.mob_climax(TRUE, "sex", partner, !cumin, target_gen)
	set_lust(0)

	SEND_SIGNAL(src, COMSIG_MOB_POST_CAME, target_orifice, partner)

	return TRUE

/mob/living/proc/is_fucking(mob/living/partner, orifice, obj/item/organ/genital/genepool, datum/interaction/lewd/lewd_datum)
	var/failed = FALSE
	if(partner)
		if(partner != last_partner)
			failed++
	if(orifice)
		if(orifice != last_orifice)
			failed++
	if(genepool)
		if(genepool != last_genital)
			failed++
	if(lewd_datum)
		if(lewd_datum != last_lewd_datum)
			failed++
	if(failed)
		return FALSE
	return TRUE

/mob/living/proc/set_is_fucking(mob/living/partner, orifice, obj/item/organ/genital/genepool)
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
	var/lust = get_lust()
	var/lust_tolerance = get_lust_tolerance()
	if(lust >= lust_tolerance)
		if(prob(10))
			to_chat(src, "<b>You struggle to not orgasm!</b>")
			moan()
			return FALSE
		if(lust >= (lust_tolerance * 3))
			if(cum(partner, orifice))
				return TRUE
	return FALSE

/mob/living/proc/get_unconsenting(interaction_flags, list/ignored_mobs)
	var/list/nope = list()
	nope += ignored_mobs
	for(var/mob/M in range(7, src))
		if(M.client)
			var/client/cli = M.client
			if(!(cli.prefs.toggles & VERB_CONSENT)) //Note: This probably could do with a specific preference
				nope += M
			else if(interaction_flags & INTERACTION_FLAG_EXTREME_CONTENT && (cli.prefs.extremepref == "No"))
				nope += M
		else
			nope += M
	return nope
