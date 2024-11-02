//Own stuff
/datum/interaction/lewd/oral/selfsuck
	description = "Suck yourself off."
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS
	required_from_user_unexposed = NONE
	interaction_flags = INTERACTION_FLAG_ADJACENT | INTERACTION_FLAG_OOC_CONSENT | INTERACTION_FLAG_USER_IS_TARGET
	max_distance = 0
	write_log_user = "sucked off"
	write_log_target = null

/datum/interaction/lewd/oral/suckvagself
	description = "Lick your own pussy."
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_VAGINA
	required_from_user_unexposed = NONE
	interaction_flags = INTERACTION_FLAG_ADJACENT | INTERACTION_FLAG_OOC_CONSENT | INTERACTION_FLAG_USER_IS_TARGET
	max_distance = 0
	write_log_user = "Сunni off"
	write_log_target = null

/datum/interaction/lewd/oral/suckvagself/display_interaction(mob/living/carbon/human/user)
	user.do_oral_self(user, "vagina")

/datum/interaction/lewd/breastfuckself
	description = "Fuck your breasts."
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS | INTERACTION_REQUIRE_BREASTS
	required_from_user_unexposed = NONE
	interaction_flags = INTERACTION_FLAG_ADJACENT | INTERACTION_FLAG_OOC_CONSENT | INTERACTION_FLAG_USER_IS_TARGET
	max_distance = 0
	write_log_user = "Breastfucked"
	write_log_target = null

/datum/interaction/lewd/fuck/belly
	description = "Fuck their belly."
	required_from_target_exposed = INTERACTION_REQUIRE_BELLY
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS
	required_from_user_unexposed = NONE
	write_log_user = "belly fucked"
	write_log_target = "was belly fucked by"

/datum/interaction/lewd/deflate_belly
	description = "Deflate belly."
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_BELLY
	required_from_user_unexposed = NONE
	max_distance = 0
	interaction_flags = INTERACTION_FLAG_ADJACENT | INTERACTION_FLAG_OOC_CONSENT | INTERACTION_FLAG_USER_IS_TARGET
	write_log_user = "deflated their belly"
	write_log_target = null

/datum/interaction/lewd/deflate_belly/display_interaction(mob/living/carbon/user)
	var/obj/item/organ/genital/belly/gut = user.getorganslot(ORGAN_SLOT_BELLY)
	if(gut)
		gut.modify_size(-1)

/datum/interaction/lewd/inflate_belly
	description = "Inflate belly"
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_BELLY
	required_from_user_unexposed = NONE
	max_distance = 0
	interaction_flags = INTERACTION_FLAG_ADJACENT | INTERACTION_FLAG_OOC_CONSENT | INTERACTION_FLAG_USER_IS_TARGET
	write_log_user = "inflated their belly"
	write_log_target = null

/datum/interaction/lewd/inflate_belly/display_interaction(mob/living/carbon/user)
	var/obj/item/organ/genital/belly/gut = user.getorganslot(ORGAN_SLOT_BELLY)
	if(gut)
		gut.modify_size(1)

/datum/interaction/lewd/nuzzle_belly
	description = "Nuzzle their belly."
	required_from_target_exposed = INTERACTION_REQUIRE_BELLY
	required_from_target_unexposed = NONE
	required_from_user_exposed = NONE
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "got their belly nuzzled by"
	write_log_user = null

/datum/interaction/lewd/nuzzle_belly/display_interaction(mob/living/user, mob/living/target)
	user.nuzzle_belly(target)

/datum/interaction/lewd/do_breastsmother
	description = "Smother them in your breasts."
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_BREASTS
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "got breast smothered by"
	write_log_user = "breast smothered"

/datum/interaction/lewd/lick_sweat
	description = "Lick their sweat."
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_MOUTH
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "got their sweat licked by"
	write_log_user = "licked the sweat of"

/datum/interaction/lewd/lick_sweat/display_interaction(mob/living/user, mob/living/target)
	user.lick_sweat(target)

/datum/interaction/lewd/smother_armpit
	description = "Press your armpit against their face."
	max_distance = 1
	write_log_target = "Got armpit smothered by"
	write_log_user = "Smothered in their armpit"

/datum/interaction/lewd/smother_armpit/display_interaction(mob/living/user, mob/living/target)
	user.smother_armpit(target)

/datum/interaction/lewd/lick_armpit
	description = "Lick their armpit."
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_MOUTH
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "Got dem armpit ate by"
	write_log_user = "ate the armpit of"

/datum/interaction/lewd/lick_armpit/display_interaction(mob/living/user, mob/living/target)
	user.lick_armpit(target)

/datum/interaction/lewd/fuck_armpit
	description = "Fuck their armpit."
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS
	required_from_user_unexposed = NONE
	write_log_target = "got their armpit fucked by"
	write_log_user = "fucked the armpit of"

/datum/interaction/lewd/do_pitjob
	description = "Jerk them off with your armpit."
	required_from_target_exposed = INTERACTION_REQUIRE_PENIS
	required_from_target_unexposed = NONE
	required_from_user_exposed = NONE
	required_from_user_unexposed = NONE
	write_log_target = "gave a pitjob to"
	write_log_user = "got a pitjob from"

/datum/interaction/lewd/do_boobjob
	description = "Give them a boobjob."
	required_from_target_exposed = INTERACTION_REQUIRE_PENIS
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_BREASTS
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "Got a boobjob from"
	write_log_user = "gave a boobjob to"

/datum/interaction/lewd/lick_nuts
	description = "Lick their balls."
	required_from_target_exposed = INTERACTION_REQUIRE_BALLS
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_MOUTH
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "Got their nuts sucked by"
	write_log_user = "sucked the nuts of"

/datum/interaction/lewd/lick_nuts/display_interaction(mob/living/user, mob/living/target)
	user.lick_nuts(target)

/datum/interaction/lewd/grope_ass
	description = "Grope their ass."
	simple_message = "USER gropes TARGET's ass!"
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_HANDS
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "Got their ass groped by"
	write_log_target = "ass-groped"

/datum/interaction/lewd/fuck_cock
	description = "Penetrate their cock."
	required_from_target_exposed = INTERACTION_REQUIRE_PENIS
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "Got their cock fucked by"
	write_log_user = "Fucked the cock of"

/datum/interaction/lewd/nipple_fuck
	description = "Fuck their nipple."
	required_from_target = INTERACTION_REQUIRE_TOPLESS
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS
	required_from_user_unexposed = NONE
	write_log_user = "fucked nipples"
	write_log_target = "got their nipples fucked by"
	max_distance = 1

/datum/interaction/lewd/fuck_thighs
	description = "Fuck their thighs."
	require_target_legs = REQUIRE_ANY
	require_target_num_legs = 2
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS
	required_from_user_unexposed = NONE
	write_log_user = "fucked thighs"
	write_log_target = "got their thighs fucked by"
	max_distance = 1

/datum/interaction/lewd/do_thighjob
	description = "Give them a thighjob."
	require_user_legs = REQUIRE_ANY
	require_user_num_legs = 2
	required_from_target_exposed = INTERACTION_REQUIRE_PENIS
	required_from_target_unexposed = NONE
	required_from_user_exposed = NONE
	required_from_user_unexposed = NONE
	write_log_user = "Gave a thighjob"
	write_log_target = "Got a thighjob from"
	max_distance = 1

/datum/interaction/lewd/clothesplosion
	description = "Explode out of your clothes"
	interaction_flags = INTERACTION_FLAG_ADJACENT | INTERACTION_FLAG_OOC_CONSENT | INTERACTION_FLAG_USER_IS_TARGET
	max_distance = 0
	write_log_user = "Exploded out of their clothes"

/datum/interaction/lewd/clothesplosion/display_interaction(mob/living/carbon/user, mob/living/carbon/target)
	if(!istype(user))
		return

	user.clothing_burst(FALSE)

////////////////////////////////////////////////////////////////////////////////////////////////////////
///////// 									U N H O L Y										   /////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/interaction/lewd/unholy
	description = null

/datum/interaction/lewd/unholy/New()
	. = ..()
	interaction_flags |= INTERACTION_FLAG_UNHOLY_CONTENT

/datum/interaction/lewd/unholy/do_facefart
	description = "Fart on their face."
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_ANUS
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "got facefarted by"
	write_log_user = "farted on the face of"

/datum/interaction/lewd/unholy/do_facefart/display_interaction(mob/living/user, mob/living/target)
	user.do_facefart(target)

/datum/interaction/lewd/unholy/do_crotchfart
	description = "Fart on their crotch."
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_ANUS
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "got crotchfarted by"
	write_log_user = "farted on the crotch of"

/datum/interaction/lewd/unholy/do_crotchfart/display_interaction(mob/living/user, mob/living/target)
	user.do_crotchfart(target)

/datum/interaction/lewd/unholy/do_fartfuck
	description = "Fuck their ass + fart."
	required_from_target_exposed = INTERACTION_REQUIRE_ANUS
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "got fartfucked by"
	write_log_user = "fartfucked"

/datum/interaction/lewd/unholy/suck_fart
	description = "Suck the farts out of their asshole."
	required_from_target_exposed = INTERACTION_REQUIRE_ANUS
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_MOUTH
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "got their farts sucked out by"
	write_log_user = "sucked farts"

/datum/interaction/lewd/unholy/suck_fart/display_interaction(mob/living/user, mob/living/target)
	user.suck_fart(target)

/datum/interaction/lewd/unholy/do_faceshit
	description = "Shit on their face."
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_ANUS
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "got shat in the face by"
	write_log_user = "shat in the face of"

/datum/interaction/lewd/unholy/do_faceshit/display_interaction(mob/living/user, mob/living/target)
	user.do_faceshit(target)

/datum/interaction/lewd/unholy/do_crotchshit/
	description = "Shit on their crotch."
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_ANUS
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "got shat on the croch by"
	write_log_user = "shat on the crotch of"

/datum/interaction/lewd/unholy/do_crotchshit/display_interaction(mob/living/user, mob/living/target)
	user.do_crotchshit(target)

/datum/interaction/lewd/unholy/do_shitfuck
	description = "Fuck their ass + shit."
	required_from_target_exposed = INTERACTION_REQUIRE_ANUS
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_PENIS
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "got shitfucked by"
	write_log_user = "shitfucked"

/datum/interaction/lewd/unholy/suck_shit
	description = "Suck the shit out of their asshole."
	required_from_target_exposed = INTERACTION_REQUIRE_ANUS
	required_from_target_unexposed = NONE
	required_from_user_exposed = INTERACTION_REQUIRE_MOUTH
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "got their shit sucked out by"
	write_log_user = "sucked shit"

/datum/interaction/lewd/unholy/suck_shit/display_interaction(mob/living/user, mob/living/target)
	user.suck_shit(target)

/datum/interaction/lewd/unholy/piss_over
	description = "Piss all over them."
	required_from_user = INTERACTION_REQUIRE_BOTTOMLESS
	required_from_target_exposed = NONE
	required_from_target_unexposed = NONE
	required_from_user_exposed = NONE
	required_from_user_unexposed = NONE
	max_distance = 1
	write_log_target = "got pissed all over by"
	write_log_user = "pissed on"

/datum/interaction/lewd/unholy/piss_over/display_interaction(mob/living/user, mob/living/target)
	user.piss_over(target)

/datum/interaction/lewd/unholy/piss_mouth
	description = "Piss inside their mouth."
	max_distance = 1
	required_from_user = INTERACTION_REQUIRE_BOTTOMLESS
	required_from_target_exposed = INTERACTION_REQUIRE_MOUTH
	required_from_target_unexposed = NONE
	required_from_user_exposed = NONE
	required_from_user_unexposed = NONE
	write_log_user = "pissed in someone's mouth"
	write_log_target = "got their mouth filled with piss by"

/datum/interaction/lewd/unholy/piss_mouth/display_interaction(mob/living/carbon/user, mob/living/target)
	if(!istype(user))
		to_chat(user, span_warning("You're not a carbon entity."))
		return
	user.piss_mouth(target)
