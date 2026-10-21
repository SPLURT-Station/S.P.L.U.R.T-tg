// Alters nicotine withdrawal. Addiction datums are shared, so notice timing belongs to the mind.
/datum/mind
	/// Shared by nicotine cravings and symptom notices; follows the player between bodies.
	var/nicotine_next_withdrawal_notice = 0

/datum/addiction/nicotine
	name = "nicotine"
	withdrawal_stage_messages = list("Feel like having a smoke...", "I really need a smoke now...", "I can't take it, I really need a smoke now!")

	addiction_relief_treshold = MIN_NICOTINE_ADDICTION_REAGENT_AMOUNT
	medium_withdrawal_moodlet = /datum/mood_event/nicotine_withdrawal_moderate
	severe_withdrawal_moodlet = /datum/mood_event/nicotine_withdrawal_severe

// The base processor caches the old stage before relief. Do not run that stage after nicotine satisfies it.
/datum/addiction/nicotine/process_addiction(mob/living/carbon/affected_carbon, seconds_per_tick)
	if(!affected_carbon?.mind)
		return FALSE
	for(var/datum/reagent/possible_drug as anything in affected_carbon.reagents.reagent_list)
		if((type in possible_drug.addiction_types) && possible_drug.volume >= addiction_relief_treshold)
			if(LAZYACCESS(affected_carbon.mind.active_addictions, type))
				end_withdrawal(affected_carbon)
			return FALSE
	return ..()

/// Keep withdrawal noticeable without clustered entry, craving and symptom messages.
/datum/addiction/nicotine/proc/send_withdrawal_notice(mob/living/carbon/affected_carbon, message)
	var/datum/mind/affected_mind = affected_carbon?.mind
	if(!affected_mind || LAZYACCESS(affected_mind.active_addictions, type) < WITHDRAWAL_STAGE1_START_CYCLE || world.time < affected_mind.nicotine_next_withdrawal_notice)
		return FALSE
	affected_mind.nicotine_next_withdrawal_notice = world.time + 2 MINUTES
	to_chat(affected_carbon, message)
	return TRUE

/datum/addiction/nicotine/end_withdrawal(mob/living/carbon/affected_carbon)
	if(!affected_carbon?.mind)
		return
	affected_carbon.mind.nicotine_next_withdrawal_notice = 0
	return ..()

// Mood penalties carry the gameplay cost; symptoms must not cause stamina critical or other incapacitation.
/datum/addiction/nicotine/proc/trigger_random_side_effect(mob/living/carbon/affected_carbon, seconds_per_tick, strength = 1, side_effect = rand(1, 4))
	switch(side_effect)
		if(1)
			if(!HAS_TRAIT(affected_carbon, TRAIT_NOHUNGER))
				return send_withdrawal_notice(affected_carbon, span_warning("You feel a little hungry."))
		if(2)
			return send_withdrawal_notice(affected_carbon, span_warning("Your head hurts."))
		if(3)
			if(strength >= 2)
				return send_withdrawal_notice(affected_carbon, span_warning("You feel a little dizzy."))
		if(4)
			if(strength >= 2)
				return send_withdrawal_notice(affected_carbon, span_warning("You feel tired."))
	return FALSE

/datum/addiction/nicotine/withdrawal_enters_stage_1(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	send_withdrawal_notice(affected_carbon, span_danger("[withdrawal_stage_messages[1]]"))

/datum/addiction/nicotine/withdrawal_enters_stage_2(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	send_withdrawal_notice(affected_carbon, span_danger("[withdrawal_stage_messages[2]]"))

/datum/addiction/nicotine/withdrawal_enters_stage_3(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	send_withdrawal_notice(affected_carbon, span_danger("[withdrawal_stage_messages[3]]"))

/datum/addiction/nicotine/withdrawal_stage_1_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	if(SPT_PROB(0.3, seconds_per_tick))
		send_withdrawal_notice(affected_carbon, span_danger("[withdrawal_stage_messages[1]]"))

/datum/addiction/nicotine/withdrawal_stage_2_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	if(SPT_PROB(0.5, seconds_per_tick))
		trigger_random_side_effect(affected_carbon, seconds_per_tick, 1)
	if(SPT_PROB(0.5, seconds_per_tick))
		send_withdrawal_notice(affected_carbon, span_danger("[withdrawal_stage_messages[2]]"))

/datum/addiction/nicotine/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	if(SPT_PROB(0.7, seconds_per_tick))
		trigger_random_side_effect(affected_carbon, seconds_per_tick, 2)
	if(SPT_PROB(0.7, seconds_per_tick))
		send_withdrawal_notice(affected_carbon, span_danger("[withdrawal_stage_messages[3]]"))
