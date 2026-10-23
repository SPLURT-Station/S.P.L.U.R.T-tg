/// Maximum stamina loss that nicotine withdrawal side effects can build up to, preventing stamina crit knockdown
#define NICOTINE_WITHDRAWAL_MAX_STAMINA_LOSS 35

/datum/quirk/item_quirk/addict/smoker
	process_interval = 5 MINUTES

/datum/addiction/nicotine/proc/trigger_mild_side_effect(mob/living/carbon/affected_carbon, seconds_per_tick, strength = 1)
	switch(rand(1, 4))
		if(1)
			if(!HAS_TRAIT(affected_carbon, TRAIT_NOHUNGER))
				affected_carbon.adjust_nutrition(-5 * REM * seconds_per_tick)
		if(2)
			to_chat(affected_carbon, span_warning("Your head hurts."))
			var/current_stam = affected_carbon.get_stamina_loss()
			if(current_stam < NICOTINE_WITHDRAWAL_MAX_STAMINA_LOSS)
				affected_carbon.adjust_stamina_loss(min(NICOTINE_WITHDRAWAL_MAX_STAMINA_LOSS - current_stam, 10 * REM * seconds_per_tick))
		if(3)
			if(strength >= 2)
				to_chat(affected_carbon, span_warning("You feel a little dizzy."))
				affected_carbon.set_dizzy(strength * 3 SECONDS)
		if(4)
			if(strength >= 2)
				to_chat(affected_carbon, span_warning("You feel tired."))
				var/current_stam = affected_carbon.get_stamina_loss()
				if(current_stam < NICOTINE_WITHDRAWAL_MAX_STAMINA_LOSS)
					affected_carbon.adjust_stamina_loss(min(NICOTINE_WITHDRAWAL_MAX_STAMINA_LOSS - current_stam, 15 * REM * seconds_per_tick))

/datum/addiction/nicotine/process_addiction(mob/living/carbon/affected_carbon, seconds_per_tick)
	if(HAS_TRAIT(affected_carbon, TRAIT_NO_WITHDRAWALS))
		end_withdrawal(affected_carbon)
		return FALSE

	var/current_addiction_cycle = LAZYACCESS(affected_carbon.mind.active_addictions, type)
	var/on_drug_of_this_addiction = FALSE
	for(var/datum/reagent/possible_drug as anything in affected_carbon.reagents.reagent_list)
		for(var/addiction in possible_drug.addiction_types)
			if(addiction == type && possible_drug.volume >= addiction_relief_treshold)
				if(current_addiction_cycle)
					end_withdrawal(affected_carbon)
				on_drug_of_this_addiction = TRUE
				break

	var/withdrawal_stage
	switch(current_addiction_cycle)
		if(WITHDRAWAL_STAGE1_START_CYCLE to WITHDRAWAL_STAGE1_END_CYCLE)
			withdrawal_stage = 1
		if(WITHDRAWAL_STAGE2_START_CYCLE to WITHDRAWAL_STAGE2_END_CYCLE)
			withdrawal_stage = 2
		if(WITHDRAWAL_STAGE3_START_CYCLE to INFINITY)
			withdrawal_stage = 3
		else
			withdrawal_stage = 0

	if(!on_drug_of_this_addiction && !HAS_TRAIT(affected_carbon, TRAIT_HOPELESSLY_ADDICTED))
		if(affected_carbon.mind.remove_addiction_points(type, addiction_loss_per_stage[withdrawal_stage + 1] * seconds_per_tick))
			return

	if(!on_drug_of_this_addiction && HAS_TRAIT(affected_carbon, TRAIT_ADDICTIONRESILIENT) && affected_carbon.mind.remove_addiction_points(type, addiction_loss_per_stage[withdrawal_stage + 2] * seconds_per_tick))
		return

	if(!current_addiction_cycle || on_drug_of_this_addiction)
		return FALSE

	switch(current_addiction_cycle)
		if(WITHDRAWAL_STAGE1_START_CYCLE)
			withdrawal_enters_stage_1(affected_carbon)
		if(WITHDRAWAL_STAGE2_START_CYCLE)
			withdrawal_enters_stage_2(affected_carbon)
		if(WITHDRAWAL_STAGE3_START_CYCLE)
			withdrawal_enters_stage_3(affected_carbon)

	switch(withdrawal_stage)
		if(1)
			if(SPT_PROB(0.1, seconds_per_tick))
				to_chat(affected_carbon, span_danger("[withdrawal_stage_messages[1]]"))
		if(2)
			if(SPT_PROB(0.15, seconds_per_tick))
				trigger_mild_side_effect(affected_carbon, seconds_per_tick, 1)
			if(SPT_PROB(0.15, seconds_per_tick))
				to_chat(affected_carbon, span_danger("[withdrawal_stage_messages[2]]"))
		if(3)
			if(SPT_PROB(0.2, seconds_per_tick))
				trigger_mild_side_effect(affected_carbon, seconds_per_tick, 2)
			if(SPT_PROB(0.2, seconds_per_tick))
				to_chat(affected_carbon, span_danger("[withdrawal_stage_messages[3]]"))

	LAZYADDASSOC(affected_carbon.mind.active_addictions, type, 1 * seconds_per_tick)

#undef NICOTINE_WITHDRAWAL_MAX_STAMINA_LOSS
