/datum/sex_controller/proc/knot_penis_type()
	var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)
	if(!penis)
		return FALSE
	if(!penis.functional)
		return FALSE
	switch(penis.penis_type)
		if(PENIS_TYPE_KNOTTED,PENIS_TYPE_TAPERED_KNOTTED,PENIS_TYPE_TAPERED_DOUBLE_KNOTTED,PENIS_TYPE_BARBED_KNOTTED)
			return TRUE
	return FALSE

/datum/sex_controller/proc/double_penis_type()
	var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)
	if(!penis)
		return FALSE
	if(!penis.functional)
		return FALSE
	switch(penis.penis_type)
		if(PENIS_TYPE_TAPERED_DOUBLE,PENIS_TYPE_TAPERED_DOUBLE_KNOTTED)
			return TRUE
	return FALSE

/datum/sex_controller/proc/knot_check_remove(var/action_path)
	if(!user.sexcon.knotted_status && !target.sexcon.knotted_status)
		return
	var/datum/sex_action/action = SEX_ACTION(action_path)
	if(action.user_sex_part & user.sexcon.knotted_part) // check if the knot is not blocking these actions, and thus requires a forceful removal
		var/forced_insertion = force >= SEX_FORCE_EXTREME && speed >= SEX_SPEED_EXTREME
		user.sexcon.knot_remove(forceful_removal = forced_insertion)
	if(action.target_sex_part & target.sexcon.knotted_part)
		target.sexcon.knot_remove()

/datum/sex_controller/proc/knot_try()
	if(!user.sexcon.current_action)
		return
	var/datum/sex_action/action = SEX_ACTION(user.sexcon.current_action)
	if(!action.knot_on_finish) // the current action does not support knot climaxing, abort
		return
	if(!user.sexcon.knot_penis_type()) // don't have that dog in 'em
		return
	if(!target.client?.prefs?.sexable)
		return
	if(user.sexcon.considered_limp())
		if(!user.sexcon.knotted_status)
			to_chat(user, span_notice("My knot was too soft to tie."))
		if(!target.sexcon.knotted_status)
			to_chat(target, span_notice("I feel their deflated knot slip out."))
		return

	var/target_knotted_part = SEX_PART_NULL
	if(target.sexcon.knotted_status) // only one knot at a time, you slut
		var/repeated_customer = target.sexcon.knotted_owner == user ? TRUE : FALSE // we're knotting the same character we were already knotted to, don't remove the status effects (this fixes a weird perma stat debuff if we try to remove/apply the same effect in the same tick)
		var/target_is_a_bottom = target.sexcon.knotted_status == KNOTTED_AS_BTM // keep the same status effect in place, they're still getting topped
		if(target_is_a_bottom)
			target_knotted_part = target.sexcon.knotted_part // store so we can combine with the new action occupied part flags
		target.sexcon.knot_remove(notify = FALSE, keep_btm_status = target_is_a_bottom, keep_top_status = repeated_customer)
		if(target_is_a_bottom && !target.has_status_effect(/datum/status_effect/knot_fucked_stupid)) // if the target is getting double teamed, give them the fucked stupid status
			target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)
	if(user.sexcon.knotted_status)
		var/top_still_topping = user.sexcon.knotted_status == KNOTTED_AS_TOP // top just reknotted a different character, don't retrigger the same status (this fixes a weird perma stat debuff if we try to remove/apply the same effect in the same tick)
		user.sexcon.knot_remove(keep_top_status = top_still_topping)
	var/we_got_baothad = user.patron && istype(user.patron, /datum/patron/inhumen/baotha)
	if(we_got_baothad && !target.has_status_effect(/datum/status_effect/knot_fucked_stupid)) // as requested, if the top is of the baotha faith
		target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)

	user.sexcon.knotted_owner = user
	user.sexcon.knotted_recipient = target
	user.sexcon.knotted_status = KNOTTED_AS_TOP
	user.sexcon.tugging_knot_blocked = FALSE
	user.sexcon.knotted_part = action.user_sex_part
	user.sexcon.knotted_part_partner = action.target_sex_part // we store the action bitflags so we can later apply damage based on area, and exclusive status unique to each orifice
	target.sexcon.knotted_owner = user
	target.sexcon.knotted_recipient = target
	target.sexcon.knotted_status = KNOTTED_AS_BTM
	target.sexcon.knotted_part = action.target_sex_part|target_knotted_part // add existing knotted parts flags to new knotted orifice flags
	target.sexcon.knotted_part_partner = action.target_sex_part // since user_sex_part is always set to SEX_PART_COCK, we'll save a copy of target_sex_part to use as a check for muffled speech
	log_combat(user, target, "Started knot tugging")

	if(force > SEX_FORCE_MID) // if using force above default
		if(force >= SEX_FORCE_EXTREME) // damage if set to max force
			var/damage = action.target_sex_part&SEX_PART_JAWS ? 10 : 30 // base damage value
			var/body_zone = action.target_sex_part&SEX_PART_JAWS ? BODY_ZONE_HEAD : BODY_ZONE_CHEST
			var/obj/item/bodypart/affecting = target.get_bodypart(body_zone)
			if(affecting && affecting.brute_dam < 150-damage) // cap damage applied
				target.apply_damage(damage, BRUTE, body_zone)
			target.sexcon.try_do_pain_effect(PAIN_HIGH_EFFECT, FALSE)
		else
			target.sexcon.try_do_pain_effect(PAIN_MILD_EFFECT, FALSE)
		target.Stun(80) // stun for dramatic effect
	user.visible_message(span_notice("[user] ties their knot inside of [target]!"), span_notice("I tie my knot inside of [target]."))
	if(target.stat != DEAD)
		switch(target.sexcon.knotted_part) // this is not a smart way to do this in hindsight, but it is fast at least
			if(SEX_PART_CUNT,SEX_PART_ANUS,SEX_PART_JAWS,SEX_PART_SLIT_SHEATH)
				to_chat(target, span_userdanger("You have been knotted!"))
			if(SEX_PART_CUNT|SEX_PART_ANUS|SEX_PART_JAWS|SEX_PART_SLIT_SHEATH)
				to_chat(target, span_userdanger("You have been quad-knotted!"))
			if(SEX_PART_CUNT|SEX_PART_ANUS,SEX_PART_CUNT|SEX_PART_JAWS,SEX_PART_CUNT|SEX_PART_SLIT_SHEATH,SEX_PART_ANUS|SEX_PART_SLIT_SHEATH,SEX_PART_ANUS|SEX_PART_JAWS,SEX_PART_JAWS|SEX_PART_SLIT_SHEATH)
				to_chat(target, span_userdanger("You have been double-knotted!"))
			else
				to_chat(target, span_userdanger("You have been triple-knotted!"))
		if(we_got_baothad)
			to_chat(target, span_userdanger("Baotha magick infuses within, you can't think straight!"))
	if(!target.has_status_effect(/datum/status_effect/knot_tied)) // only apply status if we don't have it already
		target.apply_status_effect(/datum/status_effect/knot_tied)
	if(!user.has_status_effect(/datum/status_effect/knotted)) // only apply status if we don't have it already
		user.apply_status_effect(/datum/status_effect/knotted)
	target.remove_status_effect(/datum/status_effect/knot_gaped)
	RegisterSignal(user.sexcon.knotted_owner, COMSIG_MOVABLE_MOVED, PROC_REF(knot_movement), TRUE)
	RegisterSignal(user.sexcon.knotted_recipient, COMSIG_MOVABLE_MOVED, PROC_REF(knot_movement), TRUE)
	GLOB.scarlet_round_stats[STATS_KNOTTED]++
	if(!islupian(user)) // only add to counter if top isn't a Lupian (for lore reasons)
		GLOB.scarlet_round_stats[STATS_KNOTTED_NOT_LUPIANS]++

/datum/sex_controller/proc/knot_movement_mods_remove_his_knot_ty(var/mob/living/carbon/human/top, var/mob/living/carbon/human/btm)
	var/obj/item/organ/penis/penor = top.getorganslot(ORGAN_SLOT_PENIS)
	if(!penor)
		return FALSE
	penor.Remove(top)
	penor.forceMove(top.drop_location())
	penor.add_mob_blood(top)
	playsound(get_turf(top), 'sound/combat/dismemberment/dismem (5).ogg', 80, TRUE)
	playsound(get_turf(top), 'sound/vo/male/tomscream.ogg', 80, TRUE)
	to_chat(top, span_userdanger("You feel a sharp pain as your knot is torn asunder!"))
	to_chat(btm, span_userdanger("You feel their knot withdraw faster than you can process!"))
	knot_remove(forceful_removal = TRUE, notify = FALSE)
	log_combat(btm, top, "Top had their cock ripped off (knot tugged too far)")
	return TRUE

/datum/sex_controller/proc/knot_movement(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER
	if(QDELETED(mover))
		return
	if(!ishuman(mover)) // this should never hit, but if it does remove callback
		UnregisterSignal(mover, COMSIG_MOVABLE_MOVED)
		return
	var/mob/living/carbon/human/user = mover
	switch(user.sexcon.knotted_status)
		if(KNOTTED_AS_TOP)
			addtimer(CALLBACK(user.sexcon, PROC_REF(knot_movement_top)), 1)
		if(KNOTTED_AS_BTM)
			if(user.sexcon.tugging_knot) // we're currently moving the bottom back to the top, don't run proc until we've finished
				return
			addtimer(CALLBACK(user.sexcon, PROC_REF(knot_movement_btm)), 1)
		if(KNOTTED_NULL) // this should never hit, but if it does remove callback
			UnregisterSignal(user.sexcon.user, COMSIG_MOVABLE_MOVED)

/datum/sex_controller/proc/knot_movement_top()
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient
	if(!ishuman(btm) || QDELETED(btm) || !ishuman(top) || QDELETED(top))
		knot_exit()
		return
	if(isnull(top.client) || !top.client?.prefs.sexable || isnull(btm.client) || !btm.client?.prefs.sexable) // we respect safewords here, let the players untie themselves
		knot_remove()
		return
	if(prob(10) && top.m_intent == MOVE_INTENT_WALK && (btm in top.buckled_mobs)) // if the two characters are being held in a fireman carry, let them muturally get pleasure from it
		var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)
		top.sexcon.perform_sex_action(btm, penis?.penis_size > DEFAULT_PENIS_SIZE ? 6.0 : 3.0, 2, FALSE)
		btm.sexcon.handle_passive_ejaculation()
		if(prob(50))
			to_chat(top, span_love("I feel [btm] tightening over my knot."))
			to_chat(btm, span_love("I feel [top] rubbing inside."))
		return
	if(top.pulling == btm || btm.pulling == top)
		return
	if(top.sexcon.considered_limp())
		knot_remove()
		return
	if(top.sexcon.tugging_knot_check == 0) // check clothes layer connection every 5 steps and update tugging_knot_blocked
		top.sexcon.tugging_knot_blocked = !get_location_accessible(top, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE)
		top.sexcon.tugging_knot_check = 5
	else
		top.sexcon.tugging_knot_check--
	var/lupineisop = top.STASTR > (btm.STACON + 3) // if the stat difference is too great, don't attempt to disconnect on run
	if(!lupineisop && top.m_intent == MOVE_INTENT_RUN && (top.mobility_flags & MOBILITY_STAND)) // pop it
		knot_remove(forceful_removal = TRUE)
		return
	var/dist = get_dist(top, btm)
	if(dist > 1 &&  dist < 6) // attempt to move the knot recipient to a minimum of 1 tiles away from the knot owner, so they trail behind
		btm.sexcon.tugging_knot = TRUE
		for(var/i in 1 to 3) // try moving three times
			step_towards(btm, top)
			dist = get_dist(top, btm)
			if(dist <= 1)
				break
		btm.sexcon.tugging_knot = FALSE
	if(dist > 1) // if we couldn't move them closer, force the knot out
		if(dist > 10 && knot_movement_mods_remove_his_knot_ty(top, btm)) // teleported or something else
			return
		knot_remove(forceful_removal = TRUE)
		return
	if(top.loc.z != btm.loc.z) // we're not on the same sector
		var/diff_in_z = top.loc.z - btm.loc.z
		var/turf/T
		switch(diff_in_z)
			if(1) // bottom is below top, check above bottom
				T = get_step_multiz(btm, UP)
				if(btm.mobility_flags & MOBILITY_STAND) // the bottom is hanging by the knot, knock them down
					btm.Knockdown(10)
			if(-1) // bottom is above top, check above top
				T = get_step_multiz(top, UP)
			else // sector difference is too great, force a disconnect
				T = null
		if(!T || !istype(T, /turf/open/transparent/openspace))
			knot_remove(forceful_removal = TRUE)
			return
	btm.face_atom(top)
	top.set_pull_offsets(btm, GRAB_AGGRESSIVE)
	if(!top.IsStun()) // randomly stun our top so they cannot simply drag without any penality (combat mode doubles the chances)
		if(prob(!top.cmode && !top.sexcon.tugging_knot_blocked ? 7 : 20))
			top.sexcon.try_do_pain_effect(PAIN_MILD_EFFECT, FALSE)
			if(top.sexcon.tugging_knot_blocked && (top.mobility_flags & MOBILITY_STAND)) // only knock down if standing and knot area is blocked
				top.Knockdown(10)
				to_chat(top, span_warning("I trip trying to move while my knot is covered."))
				top.sexcon.tugging_knot_blocked = FALSE // reset blocked state in the case either character stip off again
				top.sexcon.tugging_knot_check = 0 // check clothes again on the next step
			top.Stun(15)
	if(!btm.IsStun())
		if(prob(5))
			btm.emote("groan")
			btm.sexcon.try_do_pain_effect(PAIN_MED_EFFECT, FALSE)
			btm.Stun(15)
		else if(prob(3))
			btm.emote("painmoan")
		else if(top.sexcon.knotted_part_partner&SEX_PART_JAWS && btm.getOxyLoss() < 50) // if the current top knotted them orally
			btm.adjustOxyLoss(1)

/datum/sex_controller/proc/knot_movement_btm()
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient
	if(!ishuman(btm) || QDELETED(btm) || !ishuman(top) || QDELETED(top))
		knot_exit()
		return
	if(isnull(top.client) || !top.client?.prefs.sexable || isnull(btm.client) || !btm.client?.prefs.sexable) // we respect safewords here, let the players untie themselves
		knot_remove()
		return
	if(top.stat >= SOFT_CRIT) // only removed if the knot owner is injured/asleep/dead
		knot_remove()
		return
	if(btm.pulling == top || top.pulling == btm)
		return
	if(top.sexcon.considered_limp())
		knot_remove()
		return
	var/dist = get_dist(top, btm)
	if(dist > 1 &&  dist < 6) // attempt to move the knot recipient to a minimum of 1 tiles away from the knot owner, so they trail behind
		btm.sexcon.tugging_knot = TRUE
		for(var/i in 1 to 3)
			step_towards(btm, top)
			dist = get_dist(top, btm)
			if(dist <= 1)
				break
		btm.sexcon.tugging_knot = FALSE
	if(dist > 2)
		if(dist > 10 && knot_movement_mods_remove_his_knot_ty(top, btm)) // teleported or something else
			return
		knot_remove(forceful_removal = TRUE)
		return
	if(top.loc.z != btm.loc.z) // we're not on the same sector
		var/diff_in_z = top.loc.z - btm.loc.z
		var/turf/T
		switch(diff_in_z)
			if(1) // bottom is below top, check above bottom
				T = get_step_multiz(btm, UP)
				if(btm.mobility_flags & MOBILITY_STAND) // the bottom is hanging by the knot, knock them down
					btm.Knockdown(10)
			if(-1) // bottom is above top, check above top
				T = get_step_multiz(top, UP)
			else // sector difference is too great, force a disconnect
				T = null
		if(!T || !istype(T, /turf/open/transparent/openspace))
			knot_remove(forceful_removal = TRUE)
			return
	top.set_pull_offsets(btm, GRAB_AGGRESSIVE)
	if(btm.mobility_flags & MOBILITY_STAND)
		if(btm.m_intent == MOVE_INTENT_RUN) // running only makes this worse, darling
			btm.Knockdown(10)
			btm.Stun(30)
			btm.emote("groan", forced = TRUE)
			return
	if(!btm.IsStun())
		if(prob(10))
			btm.emote("groan")
			btm.sexcon.try_do_pain_effect(PAIN_MED_EFFECT, FALSE)
			btm.Stun(15)
			if(top.sexcon.knotted_part_partner&SEX_PART_JAWS && btm.getOxyLoss() < 50) // if the current top knotted them orally
				btm.adjustOxyLoss(3)
		else if(prob(4))
			btm.emote("painmoan")
	addtimer(CALLBACK(src, PROC_REF(knot_movement_btm_after)), 0.1 SECONDS)

/datum/sex_controller/proc/knot_movement_btm_after()
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient
	if(!ishuman(btm) || QDELETED(btm) || !ishuman(top) || QDELETED(top))
		return
	btm.face_atom(top)

/datum/sex_controller/proc/knot_remove(forceful_removal = FALSE, notify = TRUE, keep_top_status = FALSE, keep_btm_status = FALSE)
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient
	if(ishuman(btm) && !QDELETED(btm) && ishuman(top) && !QDELETED(top))
		if(forceful_removal)
			var/damage = top.sexcon.knotted_part_partner&SEX_PART_JAWS ? 10 : 30 // base damage value
			if (top.sexcon.arousal > MAX_AROUSAL / 3) // considered still hard, let it rip like a beyblade
				damage *= 2
				btm.Knockdown(10)
				if(notify && !keep_btm_status && !btm.has_status_effect(/datum/status_effect/knot_gaped)) // apply gaped status if extra forceful pull (only if we're not reknotting target)
					btm.apply_status_effect(/datum/status_effect/knot_gaped)
			if(top.sexcon.force >= SEX_FORCE_EXTREME) // only apply damage if top force is set to max
				var/body_zone = top.sexcon.knotted_part_partner&SEX_PART_JAWS ? BODY_ZONE_HEAD : BODY_ZONE_CHEST
				var/obj/item/bodypart/affecting = btm.get_bodypart(body_zone)
				if(affecting && affecting.brute_dam < 150-damage) // cap damage applied
					btm.apply_damage(damage, BRUTE, body_zone)
			btm.Stun(80)
			playsound(btm, 'sound/misc/mat/pop.ogg', 100, TRUE, -2, ignore_walls = FALSE)
			playsound(top, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
			btm.emote("paincrit", forced = TRUE)
			if(notify)
				top.visible_message(span_notice("[top] yanks their knot out of [btm]!"), span_notice("I yank my knot out from [btm]."))
				btm.sexcon.try_do_pain_effect(PAIN_HIGH_EFFECT, FALSE)
		else if(notify)
			playsound(btm, 'sound/misc/mat/insert (1).ogg', 50, TRUE, -2, ignore_walls = FALSE)
			top.visible_message(span_notice("[top] slips their knot out of [btm]!"), span_notice("I slip my knot out from [btm]."))
			btm.emote("painmoan", forced = TRUE)
			btm.sexcon.try_do_pain_effect(PAIN_MILD_EFFECT, FALSE)
		add_cum_floor(get_turf(btm))
		if(top.sexcon.knotted_part_partner&(SEX_PART_CUNT|SEX_PART_ANUS)) // use top's knotted_part_partner var to check what effect we need to apply, as bottom may be double knotted or more
			var/datum/status_effect/facial/internal/creampie = btm.has_status_effect(/datum/status_effect/facial/internal)
			if(!creampie)
				btm.apply_status_effect(/datum/status_effect/facial/internal)
			else
				creampie.refresh_cum()
		if(top.sexcon.knotted_part_partner&SEX_PART_JAWS)
			var/datum/status_effect/facial/facial = btm.has_status_effect(/datum/status_effect/facial)
			if(!facial)
				btm.apply_status_effect(/datum/status_effect/facial)
			else
				facial.refresh_cum()
	knot_exit(keep_top_status, keep_btm_status)

/datum/sex_controller/proc/knot_exit(var/keep_top_status = FALSE, var/keep_btm_status = FALSE)
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient
	if(istype(top) && top.sexcon.knotted_status)
		if(!keep_top_status) // only keep the status if we're reapplying the knot
			top.remove_status_effect(/datum/status_effect/knotted)
		UnregisterSignal(top.sexcon.user, COMSIG_MOVABLE_MOVED)
		top.sexcon.knotted_owner = null
		top.sexcon.knotted_recipient = null
		top.sexcon.knotted_status = KNOTTED_NULL
		top.sexcon.knotted_part = SEX_PART_NULL
		top.sexcon.knotted_part_partner = SEX_PART_NULL
		log_combat(top, top, "Stopped knot tugging")
	if(istype(btm) && btm.sexcon.knotted_status)
		if(!keep_btm_status) // only keep the status if we're reapplying the knot
			btm.remove_status_effect(/datum/status_effect/knot_tied)
			btm.reset_pull_offsets(btm, GRAB_AGGRESSIVE)
		UnregisterSignal(btm.sexcon.user, COMSIG_MOVABLE_MOVED)
		btm.sexcon.knotted_owner = null
		btm.sexcon.knotted_recipient = null
		btm.sexcon.knotted_status = KNOTTED_NULL
		btm.sexcon.knotted_part = SEX_PART_NULL
		btm.sexcon.knotted_part_partner = SEX_PART_NULL
		log_combat(btm, btm, "Stopped knot tugging")
	if(knotted_status) // this should never trigger, but if it does clear up the invalid state
		if(src.user)
			src.user.remove_status_effect(/datum/status_effect/knot_tied)
			src.user.remove_status_effect(/datum/status_effect/knotted)
			UnregisterSignal(src.user, COMSIG_MOVABLE_MOVED)
		knotted_owner = null
		knotted_recipient = null
		knotted_status = KNOTTED_NULL
		knotted_part = SEX_PART_NULL
		knotted_part_partner = SEX_PART_NULL

/mob/living/carbon/human/werewolf_transform() // needed to ensure that we safely remove the tie before transitioning
	if(src.sexcon.knotted_status)
		src.sexcon.knot_remove()
	return ..()

/mob/living/carbon/human/werewolf_untransform(dead,gibbed) // needed to ensure that we safely remove the tie after transitioning
	if(src.sexcon.knotted_status)
		src.sexcon.knot_remove()
	return ..()

/mob/living/carbon/can_speak_vocal() // do not allow bottom to speak while knotted orally (at least until they're double knotted or it has been removed)
	. = ..()
	if(. && iscarbon(src))
		var/mob/living/carbon/H = src
		return !(H.sexcon.knotted_status == KNOTTED_AS_BTM && H.sexcon.knotted_part_partner&SEX_PART_JAWS)
	return .

/datum/emote/is_emote_muffled(mob/living/carbon/H) // do not allow bottom to emote while knotted orally (at least until they're double knotted or it has been removed)
	. = ..()
	if(!.)
		return FALSE
	return !(H.sexcon.knotted_status == KNOTTED_AS_BTM && H.sexcon.knotted_part_partner&SEX_PART_JAWS)

/datum/emote/select_message_type(mob/user, intentional) // always use the muffled message while bottom is knotted orally (at least until they're double knotted or it has been removed)
	. = ..()
	if(message_muffled && iscarbon(user))
		var/mob/living/carbon/H = user
		if(H.sexcon.knotted_status == KNOTTED_AS_BTM && H.sexcon.knotted_part_partner&SEX_PART_JAWS)
			. = message_muffled

/datum/status_effect/knot_tied
	id = "knot_tied"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knot_tied
	effectedstats = list("strength" = -1, "endurance" = -2, "speed" = -2, "intelligence" = -3)

/atom/movable/screen/alert/status_effect/knot_tied
	name = "Knotted"
	icon_state = "knotted"

/datum/status_effect/knot_fucked_stupid
	id = "knot_fucked_stupid"
	duration = 2 MINUTES
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knot_fucked_stupid
	effectedstats = list("intelligence" = -10)

/atom/movable/screen/alert/status_effect/knot_fucked_stupid
	name = "Fucked Stupid"
	desc = "Mmmph I can't think straight..."
	icon_state = "knotted_stupid"

/datum/status_effect/knot_gaped
	id = "knot_gaped"
	duration = 60 SECONDS
	tick_interval = 100 // every 10 seconds
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knot_gaped
	effectedstats = list("strength" = -1, "speed" = -2, "intelligence" = -1)
	var/last_loc

/datum/status_effect/knot_gaped/on_apply()
	last_loc = get_turf(owner)
	if(owner.stat == CONSCIOUS && owner.sexcon.knotted_part&SEX_PART_JAWS && !owner.has_status_effect(/datum/status_effect/jaw_gaped))
		var/obj/item/bodypart/head = owner.get_bodypart(BODY_ZONE_HEAD)
		if(head) // only apply this effect if a head is found
			owner.apply_status_effect(/datum/status_effect/jaw_gaped)
	return ..()

/datum/status_effect/knot_gaped/tick()
	var/cur_loc = get_turf(owner)
	if(get_dist(cur_loc, last_loc) <= 5) // too close, don't spawn a puddle
		return
	add_cum_floor(get_turf(owner))
	playsound(owner, pick('sound/misc/bleed (1).ogg', 'sound/misc/bleed (2).ogg', 'sound/misc/bleed (3).ogg'), 50, TRUE, -2, ignore_walls = FALSE)
	last_loc = cur_loc

/atom/movable/screen/alert/status_effect/knot_gaped
	name = "Gaped"
	desc = "You were forcefully withdrawn from. Warmth runs freely down your thighs..."

/datum/status_effect/knotted
	id = "knotted"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knotted

/atom/movable/screen/alert/status_effect/knotted
	name = "Knotted"
	desc = "I have to be careful where I step..."
	icon_state = "knotted"

/atom/movable/screen/alert/status_effect/knotted/Click()
	..()
	var/mob/living/L = usr
	if(!istype(L) || !L.sexcon)
		return FALSE
	if(L.sexcon.knotted_status == KNOTTED_AS_TOP)
		var/do_forceful_removal = L.sexcon.arousal > MAX_AROUSAL / 3 // considered still hard, let it rip like a beyblade
		L.sexcon.knot_remove(forceful_removal = do_forceful_removal)
	return FALSE

/datum/status_effect/jaw_gaped
	id = "jaw_gaped"
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = -1
	alert_type = null

/datum/status_effect/jaw_gaped/on_apply()
	ADD_TRAIT(owner, TRAIT_GARGLE_SPEECH, "jaw_gaped")
	to_chat(owner, span_warning("My jaw... It stings!"))
	return ..()

/datum/status_effect/jaw_gaped/on_remove()
	REMOVE_TRAIT(owner, TRAIT_GARGLE_SPEECH, "jaw_gaped")
	if(owner.stat == CONSCIOUS)
		to_chat(owner, span_warning("I finally feel my jaw again."))
