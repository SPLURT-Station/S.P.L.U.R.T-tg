#define CUM_TARGET_MOUTH "mouth"
#define CUM_TARGET_THROAT "throat"
#define CUM_TARGET_VAGINA "vagina"
#define CUM_TARGET_ANUS "anus"
#define CUM_TARGET_HAND "hand"
#define CUM_TARGET_BREASTS "breasts"
#define CUM_TARGET_FEET "feet"
#define CUM_TARGET_PENIS "penis"
//Weird defines go here
#define CUM_TARGET_EARS "ears"
#define CUM_TARGET_EYES "eyes"
//
#define GRINDING_FACE_WITH_ANUS "faceanus"
#define GRINDING_FACE_WITH_FEET "facefeet"
#define GRINDING_MOUTH_WITH_FEET "mouthfeet"
#define THIGH_SMOTHERING "thigh_smother"
#define NUTS_TO_FACE "nut_face"

#define NORMAL_LUST 10
#define LOW_LUST 1

#define REQUIRE_NONE 0
#define REQUIRE_EXPOSED 1
#define REQUIRE_UNEXPOSED 2
#define REQUIRE_ANY 3

/*--------------------------------------------------
  -------------------MOB STUFF----------------------
  --------------------------------------------------
*/
//I'm sorry, lewd should not have mob procs such as life() and such in it. //NO SHIT IT SHOULDNT I REMOVED THEM

// Lewd interactions have a blacklist for certain mobs. When we evalute the user and target, both of
// their requirements must be satisfied, and the mob must not be of a blacklisted type.
// This should not be too weighty on the server, as the check is only run to generate the menu options.
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

/proc/playlewdinteractionsound(turf/turf_source, soundin, vol as num, vary, extrarange as num, frequency, falloff, channel = 0, pressure_affected = TRUE, sound/S, envwet = -10000, envdry = 0, manual_x, manual_y)
	var/list/hearing_mobs
	for(var/mob/H in get_hearers_in_view(4, turf_source))
		if(!H.client || READ_PREFS(H, toggle/erp/sounds))
			continue
		LAZYADD(hearing_mobs, H)
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
	var/sexual_potency =  15
	var/lust_tolerance = 100
	var/lastlusttime = 0
	var/lust = 0
	var/multiorgasms = 1
	var/datum/interaction/lewd/last_lewd_datum //Recording our last lewd datum allows us to do stuff like custom cum messages.
											   //Yes i feel like an idiot writing this.
	var/cleartimer //Timer for clearing the "last_lewd_datum". This prevents some oddities.

/mob/living/proc/clear_lewd_datum()
	last_lewd_datum = null
	last_genital = null

/mob/living/Initialize()
	. = ..()
	sexual_potency =  rand(10,25)
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

/mob/living/proc/has_penis(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(has_penis && !istype(C))
		return TRUE
	if(istype(C))
		var/obj/item/organ/external/genital/peepee = C.get_organ_slot(ORGAN_SLOT_PENIS)
		if(peepee)
			switch(nintendo)
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

/mob/living/proc/has_balls(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/external/genital/peepee = C.get_organ_slot(ORGAN_SLOT_TESTICLES)
		if(peepee)
			switch(nintendo)
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

/mob/living/proc/has_vagina(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(has_vagina && !istype(C))
		return TRUE
	if(istype(C))
		var/obj/item/organ/external/genital/peepee = C.get_organ_slot(ORGAN_SLOT_VAGINA)
		if(peepee)
			switch(nintendo)
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

/mob/living/proc/has_breasts(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(has_breasts && !istype(C))
		return TRUE
	if(istype(C))
		var/obj/item/organ/external/genital/peepee = C.get_organ_slot(ORGAN_SLOT_BREASTS)
		if(peepee)
			switch(nintendo)
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

/mob/living/proc/has_anus(var/nintendo = REQUIRE_ANY)
	if(has_anus && !iscarbon(src))
		return TRUE
	switch(nintendo)
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

/mob/living/proc/has_hand(var/nintendo = REQUIRE_ANY)
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/handcount = 0
		var/covered = 0
		var/iscovered = FALSE
		for(var/obj/item/bodypart/arm/left/L in C.bodyparts)
			handcount++
		for(var/obj/item/bodypart/arm/right/R in C.bodyparts)
			handcount++
		if(C.get_item_by_slot(ITEM_SLOT_HANDS))
			var/obj/item/clothing/gloves/G = C.get_item_by_slot(ITEM_SLOT_HANDS)
			covered = G.body_parts_covered
		if(covered & HANDS)
			iscovered = TRUE
		switch(nintendo)
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

/mob/living/proc/has_feet(var/nintendo = REQUIRE_ANY)
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/feetcount = 0
		var/covered = 0
		var/iscovered = FALSE
		for(var/obj/item/bodypart/leg/left/L in C.bodyparts)
			feetcount++
		for(var/obj/item/bodypart/leg/right/R in C.bodyparts)
			feetcount++
		if(!C.is_barefoot())
			covered = TRUE
		if(covered)
			iscovered = TRUE
		switch(nintendo)
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
/mob/living/proc/has_ears(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.get_organ_slot(ORGAN_SLOT_EARS)
		if(peepee)
			switch(nintendo)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(C.get_item_by_slot(ITEM_SLOT_EARS))
						return FALSE
					else
						return TRUE
				if(REQUIRE_UNEXPOSED)
					if(!C.get_item_by_slot(ITEM_SLOT_EARS))
						return FALSE
					else
						return TRUE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_earsockets(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.get_organ_slot(ORGAN_SLOT_EARS)
		if(!peepee)
			switch(nintendo)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(C.get_item_by_slot(ITEM_SLOT_EARS))
						return FALSE
					else
						return TRUE
				if(REQUIRE_UNEXPOSED)
					if(!C.get_item_by_slot(ITEM_SLOT_EARS))
						return FALSE
					else
						return TRUE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_eyes(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.get_organ_slot(ORGAN_SLOT_EYES)
		if(peepee)
			switch(nintendo)
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

/mob/living/proc/has_eyesockets(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.get_organ_slot(ORGAN_SLOT_EYES)
		if(!peepee)
			switch(nintendo)
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
	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		if((!(H.wear_suit) || !(H.wear_suit.body_parts_covered & CHEST)) && (!(H.w_uniform) || !(H.w_uniform.body_parts_covered & CHEST)) && (!(H.w_shirt) || !(H.w_shirt.body_parts_covered & CHEST)))
			return TRUE
	else
		return TRUE

///Are we wearing something that covers our groin?
/mob/living/proc/is_bottomless()
	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		if((!(H.wear_suit) || !(H.wear_suit.body_parts_covered & GROIN)) && (!(H.w_uniform) || !(H.w_uniform.body_parts_covered & GROIN)) && (!(H.w_underwear) || !(H.w_underwear.body_parts_covered & GROIN)))
			return TRUE
	else
		return TRUE

///Are we wearing something that covers our shoes?
/mob/living/proc/is_barefoot()
	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		if((!(H.wear_suit) || !(H.wear_suit.body_parts_covered & GROIN)) && (!(H.w_socks) || !(H.w_socks.body_parts_covered & FEET)))
			return TRUE
	else
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
	var/t_His = partner.p_their()
	var/cumin = FALSE
	var/partner_carbon_check = FALSE
	var/obj/item/organ/genital/target_gen = null
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
		playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/final_m1.ogg',
							'modular_zzplurt/sound/interactions/final_m2.ogg',
							'modular_zzplurt/sound/interactions/final_m3.ogg',
							'modular_zzplurt/sound/interactions/final_m4.ogg',
							'modular_zzplurt/sound/interactions/final_m5.ogg'), 90, 1, 0)
	else if(gender == FEMALE)
		playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/final_f1.ogg',
							'modular_zzplurt/sound/interactions/final_f2.ogg',
							'modular_zzplurt/sound/interactions/final_f3.ogg'), 70, 1, 0)
	else
		playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/final_f1.ogg',
							'modular_zzplurt/sound/interactions/final_f2.ogg',
							'modular_zzplurt/sound/interactions/final_f3.ogg'), 70, 1, 0)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
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
			/*
			if(!partner)
				H.mob_climax(TRUE, "masturbation", "none")
			else
				H.mob_climax(TRUE, "sex", partner, !cumin)
			*/
			// SPLURT START
			if(!partner)
				H.climax(FALSE)
			else
				H.climax(FALSE)
			// SPLURT END
	set_lust(0)

/mob/living/proc/is_fucking(mob/living/partner, orifice)
	if(partner == last_partner && orifice == last_orifice)
		return TRUE
	return FALSE

/mob/living/proc/set_is_fucking(mob/living/partner, orifice, var/obj/item/organ/external/genital/genepool)
	last_partner = partner
	last_orifice = orifice
	last_genital = genepool

/*
	--------------------------------------------------
	---------------LEWD PROCESS DATUM-----------------
	--------------------------------------------------
*/

/mob/living/proc/do_oral(mob/living/partner, var/fucktarget = "penis")
	var/message
	var/obj/item/organ/external/genital/peepee = null
	var/lust_increase = NORMAL_LUST
	var/u_His = p_their()
	var/u_He = p_they()
	var/u_Were = p_theyre()

	if(partner.is_fucking(src, CUM_TARGET_MOUTH))
		if(prob(partner.get_sexual_potency()))
			if(istype(src, /mob/living)) // Argh.
				var/mob/living/H = src
				H.adjustOxyLoss(3)
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
			peepee = null
		else
			if(ishuman(partner))
				var/mob/living/carbon/human/pardner = partner
				switch(fucktarget)
					if("vagina")
						peepee = pardner.get_organ_slot(ORGAN_SLOT_VAGINA)
					if("penis")
						peepee = pardner.get_organ_slot(ORGAN_SLOT_PENIS)
		partner.set_is_fucking(src, CUM_TARGET_MOUTH, peepee)

	playlewdinteractionsound(get_turf(src), pick('modular_zzplurt/sound/interactions/bj1.ogg',
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
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(lust_increase, CUM_TARGET_MOUTH, src)
	lust_increase = NORMAL_LUST //RESET IT REE

/mob/living/proc/do_facefuck(mob/living/partner, var/fucktarget = "penis")
	var/message
	var/obj/item/organ/external/genital/peepee = null
	var/retaliation_message = FALSE

	var/u_His = p_their()
	var/t_Him = partner.p_them()
	var/t_Hes = partner.p_theyre()

	if(is_fucking(partner, CUM_TARGET_MOUTH))
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(has_vagina())
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
							"struggles to escape from between \the [src]'s thighs.",
						)
				else
					improv = TRUE
			if("penis")
				if(has_penis())
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
							"stares up from between \the [src]'s knees, trying to squirm away.",
							"struggles to escape from between \the [src]'s legs.",
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
					"stares up from between \the [src]'s knees, trying to squirm away.",
					"struggles to escape from between \the [src]'s legs.",
				)
	else
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(has_vagina())
					message = "forces \the <b>[partner]</b>'s face into [u_His] pussy."
				else
					improv = TRUE
			if("penis")
				if(has_penis())
					if(is_fucking(partner, CUM_TARGET_THROAT))
						message = "retracts [u_His] cock from \the <b>[partner]</b>'s throat"
					else
						message = "shoves [u_His] cock into \the <b>[partner]</b>'s mouth"
				else
					improv = TRUE
		if(improv)
			message = "shoves [u_His] crotch into \the <b>[partner]</b>'s face."
		else
			if(ishuman(partner))
				var/mob/living/carbon/human/pardner = partner
				switch(fucktarget)
					if("vagina")
						peepee = pardner.get_organ_slot(ORGAN_SLOT_VAGINA)
					if("penis")
						peepee = pardner.get_organ_slot(ORGAN_SLOT_PENIS)
		set_is_fucking(partner , CUM_TARGET_MOUTH, peepee)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/oral1.ogg',
						'modular_zzplurt/sound/interactions/oral2.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	if(retaliation_message)
		visible_message(message = "<font color=red><b>\The <b>[partner]</b></b> [retaliation_message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_MOUTH, partner)

/mob/living/proc/thigh_smother(mob/living/partner, var/fucktarget = "penis")
	var/message
	var/obj/item/organ/external/genital/peepee = null
	var/lust_increase = 1

	var/u_His = p_their()
	var/t_His = partner.p_their()
	var/t_Him = partner.p_them()
	var/t_Hes = partner.p_theyre()

	if(is_fucking(partner, THIGH_SMOTHERING))
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(has_vagina())
					message = pick(list(
						"presses [u_His] weight down onto \the <b>[partner]</b>'s face, blocking [t_His] vision completely.",
						"rides \the <b>[partner]</b>'s face, grinding [u_His] wet pussy all over it."))
				else
					improv = TRUE
			if("penis")
				if(has_penis())
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
				if(has_vagina())
					message = pick(list(
						"clambers over \the <b>[partner]</b>'s face and pins [t_Him] down with [u_His] thighs, [u_His] moist slit rubbing all over \the <b>[partner]</b>'s mouth and nose.",
						"locks [u_His] legs around \the <b>[partner]</b>'s head before pulling it into [u_His] mound."))
				else
					improv = TRUE
			if("penis")
				if(has_penis())
					message = pick(list(
						"clambers over \the <b>[partner]</b>'s face and pins [t_Him] down with [u_His] thighs, then slowly inching closer and covering [t_His] eyes and nose with [u_His] leaking erection.",
						"locks [u_His] legs around \the <b>[partner]</b>'s head before pulling it into [u_His] fat package, smothering [t_Him]."))
				else
					improv = TRUE
		if(improv)
			message = "deviously locks [u_His] legs around \the <b>[partner]</b>'s head and smothers it in [u_His] thighs."
		else
			if(ishuman(partner))
				var/mob/living/carbon/human/pardner = partner
				switch(fucktarget)
					if("vagina")
						peepee = pardner.get_organ_slot(ORGAN_SLOT_VAGINA)
					if("penis")
						peepee = pardner.get_organ_slot(ORGAN_SLOT_PENIS)
		set_is_fucking(partner , THIGH_SMOTHERING, peepee)

	var/file = pick('modular_zzplurt/sound/interactions/bj10.ogg',
					'modular_zzplurt/sound/interactions/bj3.ogg',
					'modular_zzplurt/sound/interactions/foot_wet1.ogg',
					'modular_zzplurt/sound/interactions/foot_dry3.ogg')
	playlewdinteractionsound(loc, file, 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	handle_post_sex(lust_increase, THIGH_SMOTHERING, partner)
	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/oral1.ogg',
						'modular_zzplurt/sound/interactions/oral2.ogg'), 70, 1, -1)
	handle_post_sex(NORMAL_LUST, CUM_TARGET_MOUTH, partner)

/mob/living/proc/do_throatfuck(mob/living/partner)
	var/message
	var/obj/item/organ/external/genital/peepee = null
	var/retaliation_message = FALSE

	var/u_His = p_their()
	var/t_His = partner.p_their()
	var/t_Him = partner.p_them()

	if(is_fucking(partner, CUM_TARGET_THROAT))
		message = "[pick(
			"brutally shoves [u_His] cock into  \the <b>[partner]</b>'s throat to make [t_Him] gag.",
			"chokes \the <b>[partner]</b> on [u_His] dick, going in balls deep.",
			"slams in and out of \the <b>[partner]</b>'s mouth, [u_His] balls slapping off [t_His] face.")]"
		if(rand(3))
			partner.emote("chokes on \The [src]")
			if(prob(1) && istype(partner, /mob/living))
				var/mob/living/H = partner
				H.adjustOxyLoss(5)
		if(partner.combat_mode == INTENT_HARM)
			// adjustBruteLoss(5)
			retaliation_message = pick(
				"stares up from between \the [src]'s knees, trying to squirm away.",
				"struggles to escape from between \the [src]'s legs.",
			)
	else if(is_fucking(partner, CUM_TARGET_MOUTH))
		message = "thrusts deeper into \the <b>[partner]</b>'s mouth and down [t_His] throat."
		if(ishuman(src))
			var/mob/living/carbon/human/coomer = partner
			peepee = coomer.get_organ_slot(ORGAN_SLOT_PENIS)
		set_is_fucking(partner , CUM_TARGET_THROAT, peepee)
	else
		message = "forces [u_His] dick deep down \the <b>[partner]</b>'s throat"
		if(ishuman(src))
			var/mob/living/carbon/human/coomer = partner
			peepee = coomer.get_organ_slot(ORGAN_SLOT_PENIS)
		set_is_fucking(partner , CUM_TARGET_THROAT, peepee)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/oral1.ogg',
						'modular_zzplurt/sound/interactions/oral2.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	if(retaliation_message)
		visible_message(message = "<font color=red><b>\The <b>[partner]</b></b> [retaliation_message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_THROAT, partner)

/mob/living/proc/nut_face(var/mob/living/partner)

	var/message

	var/u_His = p_their()
	var/t_His = partner.p_their()

	var/lust_increase = 1

	if(is_fucking(partner, NUTS_TO_FACE))
		message = pick(list(
			"grabs the back of <b>[partner]</b>'s head and pulls it into [u_His] crotch.",
			"jams [u_His] nutsack right into <b>[partner]</b>'s face.",
			"roughly grinds [u_His] fat nutsack into <b>[partner]</b>'s mouth.",
			"pulls out [u_His] saliva-covered nuts from <b>[partner]</b>'s violated mouth and then wipes off the slime onto [t_His] face."))
	else
		message = pick(list("wedges a digit into the side of <b>[partner]</b>'s jaw and pries it open before using [u_His] other hand to shove [u_His] whole nutsack inside!", "stands with [u_His] groin inches away from [partner]'s face, then thrusting [u_His] hips forward and smothering [partner]'s whole face with [u_His] heavy ballsack."))
		set_is_fucking(partner , NUTS_TO_FACE, get_organ_slot(ORGAN_SLOT_PENIS) ? get_organ_slot(ORGAN_SLOT_PENIS) : null)

	/*playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/nuts1.ogg',
						'modular_zzplurt/sound/interactions/nuts2.ogg',
						'modular_zzplurt/sound/interactions/nuts3.ogg',
						'modular_zzplurt/sound/interactions/nuts4.ogg'), 70, 1, -1)*/ //These files don't even exist but nobody noticed because double-quotes were used instead of single.
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	handle_post_sex(lust_increase, CUM_TARGET_MOUTH, partner)

/mob/living/proc/do_anal(mob/living/partner)
	var/message

	var/u_His = p_their()
	var/t_His = partner.p_their()

	if(is_fucking(partner, CUM_TARGET_ANUS))
		message = "[pick(
			"thrusts in and out of \the <b>[partner]</b>'s ass.",
			"pounds \the <b>[partner]</b>'s ass.",
			"slams [u_His] hips up against \the <b>[partner]</b>'s ass hard.",
			"goes balls deep into \the <b>[partner]</b>'s ass over and over again.")]"
	else
		message = "[pick(
			"works [u_His] cock into \the <b>[partner]</b>'s asshole.",
			"grabs the base of [u_His] twitching cock and presses the tip into \the <b>[partner]</b>'s asshole.",
			"shoves [u_His] dick deep inside of \the <b>[partner]</b>'s ass, making [t_His] rear jiggle.")]"
		set_is_fucking(partner, CUM_TARGET_ANUS, get_organ_slot(ORGAN_SLOT_PENIS) ? get_organ_slot(ORGAN_SLOT_PENIS) : null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_ANUS, partner)
	partner.handle_post_sex(NORMAL_LUST, null, src)

/mob/living/proc/do_vaginal(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(is_fucking(partner, CUM_TARGET_VAGINA))
		message = "[pick(
			"pounds \the <b>[partner]</b>'s pussy.",
			"shoves [u_His] dick deep into \the <b>[partner]</b>'s pussy",
			"thrusts in and out of \the <b>[partner]</b>'s cunt.",
			"goes balls deep into \the <b>[partner]</b>'s pussy over and over again.")]"
	else
		message = "slides [u_His] cock into \the <b>[partner]</b>'s pussy."
		set_is_fucking(partner, CUM_TARGET_VAGINA, get_organ_slot(ORGAN_SLOT_PENIS) ? get_organ_slot(ORGAN_SLOT_PENIS) : null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/champ1.ogg',
						'modular_zzplurt/sound/interactions/champ2.ogg'), 50, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_VAGINA, partner)
	partner.handle_post_sex(NORMAL_LUST, null, src)

/mob/living/proc/do_mount(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(partner.is_fucking(src, CUM_TARGET_VAGINA))
		message = "[pick("rides \the <b>[partner]</b>'s dick.",
			"forces <b>[partner]</b>'s cock on [u_His] pussy")]"
	else
		message = "slides [u_His] pussy onto \the <b>[partner]</b>'s cock."
		partner.set_is_fucking(src, CUM_TARGET_VAGINA, partner.get_organ_slot(ORGAN_SLOT_PENIS) ? partner.get_organ_slot(ORGAN_SLOT_PENIS) : null)
	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_VAGINA, src)
	handle_post_sex(NORMAL_LUST, null, partner)

/mob/living/proc/do_mountass(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(partner.is_fucking(src, CUM_TARGET_ANUS))
		message = "[pick("rides \the <b>[partner]</b>'s dick.",
			"forces <b>[partner]</b>'s cock on [u_His] ass")]"
	else
		message = "lowers [u_His] ass onto \the <b>[partner]</b>'s cock."
		partner.set_is_fucking(src, CUM_TARGET_ANUS, partner.get_organ_slot(ORGAN_SLOT_PENIS) ? partner.get_organ_slot(ORGAN_SLOT_PENIS) : null)
	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_ANUS, src)
	handle_post_sex(NORMAL_LUST, null, partner)

/mob/living/proc/do_tribadism(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(partner.is_fucking(src, CUM_TARGET_VAGINA))
		message = "[pick("grinds [u_His] pussy against \the <b>[partner]</b>'s cunt.",
			"rubs [u_His] cunt against \the <b>[partner]</b>'s pussy.",
			"thrusts against \the <b>[partner]</b>'s pussy.",
			"humps \the <b>[partner]</b>, [u_His] pussies grinding against each other.")]"
	else
		message = "presses [u_His] pussy into \the <b>[partner]</b>'s own."
		partner.set_is_fucking(src, CUM_TARGET_VAGINA, partner.get_organ_slot(ORGAN_SLOT_VAGINA) ? partner.get_organ_slot(ORGAN_SLOT_VAGINA) : null)
	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/squelch1.ogg',
						'modular_zzplurt/sound/interactions/squelch2.ogg',
						'modular_zzplurt/sound/interactions/squelch3.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_VAGINA, src)
	handle_post_sex(NORMAL_LUST, null, partner)

/mob/living/proc/do_fingering(mob/living/partner)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [pick("fingers \the <b>[partner]</b>.",
		"fingers \the <b>[partner]</b>'s pussy.",
		"fingers \the <b>[partner]</b> hard.")]</span>", ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, 'modular_zzplurt/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	partner.handle_post_sex(NORMAL_LUST, null, src)

/mob/living/proc/do_fingerass(mob/living/partner)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [pick("fingers \the <b>[partner]</b>.",
		"fingers \the <b>[partner]</b>'s asshole.",
		"fingers \the <b>[partner]</b> hard.")]</span>", ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, 'modular_zzplurt/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	partner.handle_post_sex(NORMAL_LUST, null, src)

/mob/living/proc/do_rimjob(mob/living/partner)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> licks \the <b>[partner]</b>'s asshole.</span>", ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, 'modular_zzplurt/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	partner.handle_post_sex(NORMAL_LUST, null, src)

/mob/living/proc/do_handjob(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(partner.is_fucking(src, CUM_TARGET_HAND))
		message = "[pick("jerks \the <b>[partner]</b> off.",
			"works \the <b>[partner]</b>'s shaft.",
			"wanks \the <b>[partner]</b>'s cock hard.")]"
	else
		message = "[pick("wraps [u_His] hand around \the <b>[partner]</b>'s cock.",
			"starts playing with \the <b>[partner]</b>'s cock")]"
		partner.set_is_fucking(src, CUM_TARGET_HAND, partner.get_organ_slot(ORGAN_SLOT_PENIS) ? partner.get_organ_slot(ORGAN_SLOT_PENIS) : null)

	playlewdinteractionsound(src, pick('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, src)

/mob/living/proc/do_breastfuck(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(is_fucking(partner, CUM_TARGET_BREASTS))
		message = "[pick("fucks \the <b>[partner]</b>'s' breasts.",
			"grinds [u_His] cock between \the <b>[partner]</b>'s boobs.",
			"thrusts into \the <b>[partner]</b>'s tits.",
			"grabs \the <b>[partner]</b>'s breasts together and presses [u_His] dick between them.")]"
	else
		message = "pushes \the <b>[partner]</b>'s breasts together and presses [u_His] dick between them."
		set_is_fucking(partner , CUM_TARGET_BREASTS, get_organ_slot(ORGAN_SLOT_PENIS) ? get_organ_slot(ORGAN_SLOT_PENIS) : null)


	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/bang1.ogg',
						'modular_zzplurt/sound/interactions/bang2.ogg',
						'modular_zzplurt/sound/interactions/bang3.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_BREASTS, partner)

/mob/living/proc/do_mountface(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(is_fucking(partner, GRINDING_FACE_WITH_ANUS))
		message = "[pick("grinds [u_His] ass into \the <b>[partner]</b>'s face.",
			"shoves [u_His] ass into \the <b>[partner]</b>'s face.")]"
	else
		message = "[pick(
			"grabs the back of \the <b>[partner]</b>'s head and forces it into [u_His] asscheeks.",
			"squats down and plants [u_His] ass right on \the <b>[partner]</b>'s face")]"
		set_is_fucking(partner , GRINDING_FACE_WITH_ANUS, null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/squelch1.ogg',
						'modular_zzplurt/sound/interactions/squelch2.ogg',
						'modular_zzplurt/sound/interactions/squelch3.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	handle_post_sex(LOW_LUST, null, src)

/mob/living/proc/do_lickfeet(mob/living/partner)
	var/message

	if(partner.get_item_by_slot(ITEM_SLOT_FEET) != null)
		message = "licks \the <b>[partner]</b>'s [partner.get_shoes()]."
	else
		message = "licks \the <b>[partner]</b>'s [partner.has_feet() == 1 ? "foot" : "feet"]."

	playlewdinteractionsound(loc, 'modular_zzplurt/sound/interactions/champ_fingering.ogg', 50, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	handle_post_sex(LOW_LUST, null, src)

/*Grinding YOUR feet in TARGET's face*/
/mob/living/proc/do_grindface(mob/living/partner)
	var/message

	var/u_His = p_their()
	var/t_His = partner.p_their()

	if(is_fucking(partner, GRINDING_FACE_WITH_FEET))
		if(get_item_by_slot(ITEM_SLOT_FEET) != null)
			message = "[pick(list("grinds [u_His] [get_shoes()] into <b>[partner]</b>'s face.",
				"presses [u_His] footwear down hard on <b>[partner]</b>'s face.",
				"rubs off the dirt from [u_His] [get_shoes()] onto <b>[partner]</b>'s face."))]</span>"
		else
			message = "[pick(list("grinds [u_His] bare feet into <b>[partner]</b>'s face.",
				"deviously covers <b>[partner]</b>'s mouth and nose with [u_His] bare feet.",
				"runs the soles of [u_His] bare feet against <b>[partner]</b>'s lips."))]</span>"

	else if(is_fucking(partner, GRINDING_MOUTH_WITH_FEET))
		if(get_item_by_slot(ITEM_SLOT_FEET) != null)
			message = "[pick(list("pulls [u_His] [get_shoes()] out of <b>[partner]</b>'s mouth and puts them on [t_His] face.",
				"slowly retracts [u_His] [get_shoes()] from <b>[partner]</b>'s mouth, putting them on [t_His] face instead."))]</span>"
		else
			message = "[pick(list("pulls [u_His] bare feet out of <b>[partner]</b>'s mouth and rests them on [t_His] face instead.",
				"retracts [u_His] bare feet from <b>[partner]</b>'s mouth and grinds them into [t_His] face instead."))]</span>"

		set_is_fucking(partner , GRINDING_FACE_WITH_FEET, null)

	else
		if(get_item_by_slot(ITEM_SLOT_FEET) != null)
			message = "[pick(list("plants [u_His] [get_shoes()] ontop of <b>[partner]</b>'s face.",
				"rests [u_His] [get_shoes()] on <b>[partner]</b>'s face and presses down hard.",
				"harshly places [u_His] [get_shoes()] atop <b>[partner]</b>'s face."))]</span>"
		else
			message = "[pick(list("plants [u_His] bare feet ontop of <b>[partner]</b>'s face.",
				"rests [u_His] feet on <b>[partner]</b>'s face, smothering them.",
				"positions [u_His] bare feet atop <b>[partner]</b>'s face."))]</span>"

		set_is_fucking(partner, GRINDING_FACE_WITH_FEET, null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/foot_dry1.ogg',
						'modular_zzplurt/sound/interactions/foot_dry2.ogg',
						'modular_zzplurt/sound/interactions/foot_dry3.ogg',
						'modular_zzplurt/sound/interactions/foot_dry4.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(LOW_LUST, null, src)

/*Grinding YOUR feet in TARGET's mouth*/
/mob/living/proc/do_grindmouth(mob/living/partner)
	var/message

	var/u_His = p_their()
	var/t_His = partner.p_their()
	var/t_Him = partner.p_them()
	var/t_He = partner.p_they()
	var/t_S = partner.p_s()

	if(is_fucking(partner, GRINDING_MOUTH_WITH_FEET))
		if(get_item_by_slot(ITEM_SLOT_FEET) != null)
			message = "[pick(list("roughly shoves [u_His] [get_shoes()] deeper into <b>[partner]</b>'s mouth.",
				"harshly forces another inch of [u_His] [get_shoes()] into <b>[partner]</b>'s mouth.",
				"presses [u_His] weight down, [u_His] [get_shoes()] prying deeper into <b>[partner]</b>'s mouth."))]</span>"
		else
			message = "[pick(list("wiggles [u_His] toes deep inside <b>[partner]</b>'s mouth.",
				"crams [u_His] barefeet down deeper into <b>[partner]</b>'s mouth, making [t_Him] gag.",
				"roughly grinds [u_His] feet on <b>[partner]</b>'s tongue."))]</span>"

	else if(is_fucking(partner, GRINDING_FACE_WITH_FEET))
		if(get_item_by_slot(ITEM_SLOT_FEET) != null)
			message = "[pick(list("decides to force [u_His] [get_shoes()] deep into <b>[partner]</b>'s mouth.",
				"pressed the tip of [u_His] [get_shoes()] against <b>[partner]</b>'s lips and shoves inwards."))]</span>"
		else
			message = "[pick(list("pries open <b>[partner]</b>'s mouth with [u_His] toes and shoves [u_His] bare foot in.",
				"presses down [u_His] foot even harder, cramming [u_His] foot into <b>[partner]</b>'s mouth."))]</span>"

		set_is_fucking(partner , GRINDING_MOUTH_WITH_FEET, null)

	else
		if(get_item_by_slot(ITEM_SLOT_FEET) != null)
			message = "[pick(list("readies themselves and in one swift motion, shoves [u_His] [get_shoes()] into <b>[partner]</b>'s mouth.",
				"grinds the tip of [u_His] [get_shoes()] against <b>[partner]</b>'s mouth before pushing themselves in."))]</span>"
		else
			message = "[pick(list("rubs [u_His] dirty bare feet across <b>[partner]</b>'s face before prying them into [t_His] muzzle.",
				"forces [u_His] barefeet into <b>[partner]</b>'s mouth.",
				"covers <b>[partner]</b>'s mouth and nose with [u_His] foot until [t_He] gasp[t_S] for breath, then shoves both feet inside before [t_He] can react."))]</span>"
		set_is_fucking(partner , GRINDING_MOUTH_WITH_FEET, null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/foot_wet1.ogg',
						'modular_zzplurt/sound/interactions/foot_wet2.ogg',
						'modular_zzplurt/sound/interactions/foot_wet3.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(LOW_LUST, null, src)

/mob/living/proc/do_footfuck(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("fucks \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].",
			"rubs [u_His] dick on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].",
			"grinds [u_His] cock on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].")]"
	else
		message = "[pick("positions [u_His] cock on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].",
			"positions [u_His] cock on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot","sole")].",
			"starts grinding [u_His] cock against \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].")]"
		set_is_fucking(src, CUM_TARGET_FEET, get_organ_slot(ORGAN_SLOT_PENIS) ? get_organ_slot(ORGAN_SLOT_PENIS) : null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/foot_dry1.ogg',
						'modular_zzplurt/sound/interactions/foot_dry3.ogg',
						'modular_zzplurt/sound/interactions/foot_wet1.ogg',
						'modular_zzplurt/sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, src)

/mob/living/proc/do_dfootfuck(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("fucks \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes() : pick("feet", "soles")].",
			"rubs [u_His] dick between \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes() : pick("feet", "soles")].",
			"thrusts [u_His] cock between \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes() : pick("feet", "soles")].")]"
	else
		message = "[pick("positions [u_His] cock between \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes() : pick("feet", "soles")].",
			"starts grinding [u_His] cock against \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes() : pick("feet", "soles")].",
			"starts grinding [u_His] cock between \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes() : pick("feet", "soles")].")]"
		set_is_fucking(src, CUM_TARGET_FEET, get_organ_slot(ORGAN_SLOT_PENIS) ? get_organ_slot(ORGAN_SLOT_PENIS) : null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/foot_dry1.ogg',
						'modular_zzplurt/sound/interactions/foot_dry3.ogg',
						'modular_zzplurt/sound/interactions/foot_wet1.ogg',
						'modular_zzplurt/sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, src)

/mob/living/proc/do_vfootfuck(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("grinds [u_His] pussy against \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].",
			"rubs [u_His] clit on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].",
			"ruts on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].")]"
	else
		message = "[pick("positions [u_His] vagina on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].",
			"positions [u_His] clit on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot","sole")].",
			"starts grinding [u_His] pussy against \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].")]"
		set_is_fucking(src, CUM_TARGET_FEET, get_organ_slot(ORGAN_SLOT_VAGINA) ? get_organ_slot(ORGAN_SLOT_VAGINA) : null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/foot_dry1.ogg',
						'modular_zzplurt/sound/interactions/foot_dry3.ogg',
						'modular_zzplurt/sound/interactions/foot_wet1.ogg',
						'modular_zzplurt/sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, src)

/mob/living/proc/do_footjob(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(partner.is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("jerks \the <b>[partner]</b> off with [u_His] [get_shoes() ? get_shoes(TRUE) : pick("foot", "sole")].",
			"rubs [u_His] [get_shoes() ? get_shoes(TRUE) : pick("foot", "sole", "toes")] on \the <b>[partner]</b>'s shaft.",
			"works [u_His] [get_shoes() ? get_shoes(TRUE) : pick("foot", "sole")] up and down on \the <b>[partner]</b>'s cock.")]"
	else
		message = "[pick("[get_shoes() ? "positions [u_His] [get_shoes(TRUE)] on" :"positions [u_His] foot on"] \the <b>[partner]</b>'s cock.",
			"starts playing around with \the <b>[partner]</b>'s cock, using [u_His] [get_shoes() ? get_shoes(TRUE) :"foot"].")]"
		partner.set_is_fucking(src, CUM_TARGET_FEET, partner.get_organ_slot(ORGAN_SLOT_PENIS) ? partner.get_organ_slot(ORGAN_SLOT_PENIS) : null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/foot_dry1.ogg',
						'modular_zzplurt/sound/interactions/foot_dry3.ogg',
						'modular_zzplurt/sound/interactions/foot_wet1.ogg',
						'modular_zzplurt/sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, src)

/mob/living/proc/do_dfootjob(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(partner.is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("jerks \the <b>[partner]</b> off with [u_His] [get_shoes() ? get_shoes() : pick("feet", "soles")].",
			"rubs [u_His] [get_shoes() ? get_shoes() : pick("feet", "soles")] on \the <b>[partner]</b>'s shaft.",
			"rubs [get_shoes() ? "[u_His] [get_shoes()]" : "all of [u_His] toes"] on \the <b>[partner]</b>'s cock.",
			"works [u_His] [get_shoes() ? get_shoes() : pick("feet", "soles")] up and down on \the <b>[partner]</b>'s cock.")]"
	else
		message = "[pick("[get_shoes() ? "wraps [u_His] [get_shoes()] around" : "wraps [u_His] [pick("feet", "soles")] around"] \the <b>[partner]</b>'s cock.",
			"starts playing around with \the <b>[partner]</b>'s cock, using [u_His] [get_shoes() ? get_shoes() : "feet"].")]"
		partner.set_is_fucking(src, CUM_TARGET_FEET, partner.get_organ_slot(ORGAN_SLOT_PENIS) ? partner.get_organ_slot(ORGAN_SLOT_PENIS) : null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/foot_dry1.ogg',
						'modular_zzplurt/sound/interactions/foot_dry3.ogg',
						'modular_zzplurt/sound/interactions/foot_wet1.ogg',
						'modular_zzplurt/sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, src)

/mob/living/proc/do_footjob_v(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(partner.is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("rubs \the <b>[partner]</b> clit with [u_His] [get_shoes() ? get_shoes(TRUE) : pick("foot", "sole")].",
			"rubs [u_His] [get_shoes() ? get_shoes(TRUE) : pick("foot", "sole", "toes")] on \the <b>[partner]</b>'s coochie.",
			"rubs [u_His] [get_shoes() ? get_shoes(TRUE) : pick("foot", "sole", "toes")] on \the <b>[partner]</b>'s vagina.",
			"rubs [u_His] foot up and down on \the <b>[partner]</b>'s pussy.")]"
	else
		message = "[pick("[get_shoes() ? "positions [u_His] [get_shoes(TRUE)] on" : "positions [u_His] foot on"] \the <b>[partner]</b>'s pussy.",
			"starts playing around with \the <b>[partner]</b>'s pussy, using [u_His] [get_shoes() ? get_shoes(TRUE) : "foot"].")]"
		partner.set_is_fucking(src, CUM_TARGET_FEET, partner.get_organ_slot(ORGAN_SLOT_VAGINA) ? partner.get_organ_slot(ORGAN_SLOT_VAGINA) : null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/foot_dry1.ogg',
						'modular_zzplurt/sound/interactions/foot_dry3.ogg',
						'modular_zzplurt/sound/interactions/foot_wet1.ogg',
						'modular_zzplurt/sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, src)

/mob/living/proc/get_shoes(var/singular = FALSE)
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

/mob/living/proc/get_unconsenting(var/extreme = FALSE, var/list/ignored_mobs)
	var/list/nope = list()
	nope += ignored_mobs
	for(var/mob/M in range(7, src))
		if(M.client)
			var/client/cli = M.client

			if(!READ_PREFS(M, toggle/erp)) //Note: This probably could do with a specific preference
				nope += M
			else if(extreme && (READ_PREFS(M, choiced/erp_status_extm) == "No"))
				nope += M
		else
			nope += M
	return nope

//Yep, weird shit goes down here.
/mob/living/proc/do_eyefuck(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(is_fucking(partner, CUM_TARGET_EYES))
		message = "[pick(
			"pounds into \the <b>[partner]</b>'s [has_eyes() ? "eye":"eyesocket"].",
			"shoves [u_His] dick deep into \the <b>[partner]</b>'s skull",
			"thrusts in and out of \the <b>[partner]</b>'s [has_eyes() ? "eye":"eyesocket"].",
			"goes balls deep into \the <b>[partner]</b>'s cranium over and over again.")]"
		var/client/cli = partner.client
		var/mob/living/carbon/C = partner
		if(cli && istype(C))
			if(READ_PREFS(partner, choiced/erp_status_extmharm) != "No")
				if(prob(15))
					C.bleed(2)
				if(prob(25))
					C.adjustOrganLoss(ORGAN_SLOT_EYES,rand(3,7))
					C.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(3,7))
	else
		message = "forcefully slides [u_His] cock inbetween \the <b>[partner]</b>'s [has_eyes() ? "eyelid":"eyesocket"]."
		set_is_fucking(partner, CUM_TARGET_EYES, get_organ_slot(ORGAN_SLOT_PENIS) ? get_organ_slot(ORGAN_SLOT_PENIS) : null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/champ1.ogg',
						'modular_zzplurt/sound/interactions/champ2.ogg'), 50, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting(TRUE))
	handle_post_sex(NORMAL_LUST, CUM_TARGET_EYES, partner)
	partner.handle_post_sex(LOW_LUST, null, src)

/mob/living/proc/do_earfuck(mob/living/partner)
	var/message

	var/u_His = p_their()

	if(is_fucking(partner, CUM_TARGET_EARS))
		message = "[pick(
			"pounds into \the <b>[partner]</b>'s [has_eyes() ? "ear":"earsocker"].",
			"shoves [u_His] dick deep into \the <b>[partner]</b>'s skull",
			"thrusts in and out of \the <b>[partner]</b>'s [has_eyes() ? "ear":"eyesocket"].",
			"goes balls deep into \the <b>[partner]</b>'s cranium over and over again.")]"
		var/client/cli = partner.client
		var/mob/living/carbon/C = partner
		if(cli && istype(C))
			if(READ_PREFS(partner, choiced/erp_status_extmharm) != "No")
				if(prob(15))
					C.bleed(2)
				if(prob(25))
					C.adjustOrganLoss(ORGAN_SLOT_EARS, rand(3,7))
					C.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(3,7))
	else
		message = "forcefully slides [u_His] cock inside \the <b>[partner]</b>'s [has_ears() ? "ear":"earsocket"]."
		set_is_fucking(partner, CUM_TARGET_EARS, get_organ_slot(ORGAN_SLOT_PENIS) ? get_organ_slot(ORGAN_SLOT_PENIS) : null)

	playlewdinteractionsound(loc, pick('modular_zzplurt/sound/interactions/champ1.ogg',
						'modular_zzplurt/sound/interactions/champ2.ogg'), 50, 1, -1)
	visible_message(message = "<span class='lewd'><b>\The [src]</b> [message]</span>", ignored_mobs = get_unconsenting(TRUE))
	handle_post_sex(NORMAL_LUST, CUM_TARGET_EARS, partner)
	partner.handle_post_sex(LOW_LUST, null, src)
