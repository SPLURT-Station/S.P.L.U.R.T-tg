/datum/unit_test/nicotine_withdrawal
	abstract_type = /datum/unit_test/nicotine_withdrawal
	var/datum/addiction/nicotine/addiction
	var/mob/living/carbon/human/consistent/smoker

/datum/unit_test/nicotine_withdrawal/New()
	. = ..()
	addiction = GLOB.addictions[/datum/addiction/nicotine]
	smoker = allocate(__IMPLIED_TYPE__)
	smoker.mind_initialize()
	allocated += smoker.mind
	smoker.mind.add_addiction_points(/datum/addiction/nicotine, 1000)
	ADD_TRAIT(smoker, TRAIT_SMOKER, TRAIT_SOURCE_UNIT_TESTS)

/datum/unit_test/nicotine_withdrawal/stages_and_mood/Run()
	var/list/stages = list(WITHDRAWAL_STAGE1_START_CYCLE, WITHDRAWAL_STAGE2_START_CYCLE, WITHDRAWAL_STAGE3_START_CYCLE)
	var/list/moods = list(addiction.light_withdrawal_moodlet, addiction.medium_withdrawal_moodlet, addiction.severe_withdrawal_moodlet)
	var/first_notice_deadline
	for(var/stage in 1 to 3)
		smoker.mind.active_addictions[/datum/addiction/nicotine] = stages[stage]
		addiction.process_addiction(smoker, 1)
		var/datum/mood_event/withdrawal = smoker.mob_mood.mood_events["/datum/addiction/nicotine_addiction"]
		TEST_ASSERT(istype(withdrawal, moods[stage]), "Real processing must retain stage [stage]'s mood penalty.")
		TEST_ASSERT(smoker.mind.active_addictions[/datum/addiction/nicotine] == stages[stage] + 1, "Real addiction processing must still advance stage [stage].")
		if(stage == 1)
			first_notice_deadline = smoker.mind.nicotine_next_withdrawal_notice
			TEST_ASSERT(first_notice_deadline == world.time + 2 MINUTES, "First stage must start the proposed two-minute notice limit.")
		else
			TEST_ASSERT(smoker.mind.nicotine_next_withdrawal_notice == first_notice_deadline, "Stage transitions inside the cooldown must not restart or bypass it.")
		TEST_ASSERT(smoker.get_stamina_loss() == 0 && !IS_UNCONSCIOUS_OR_CRIT(smoker) && !HAS_TRAIT(smoker, TRAIT_INCAPACITATED), "Stage [stage] must not incapacitate the smoker.")
	TEST_ASSERT(HAS_TRAIT(smoker, TRAIT_SMOKER), "Processing must preserve the Smoker trait.")

/datum/unit_test/nicotine_withdrawal/all_side_effects/Run()
	smoker.mind.active_addictions[/datum/addiction/nicotine] = WITHDRAWAL_STAGE3_START_CYCLE
	smoker.adjust_stamina_loss(smoker.maxHealth - 1)
	var/original_stamina = smoker.get_stamina_loss()
	var/original_nutrition = smoker.nutrition
	for(var/strength in 1 to 3)
		for(var/effect in 1 to 4)
			for(var/repetition in 1 to 3)
				smoker.mind.nicotine_next_withdrawal_notice = 0
				var/notified = addiction.trigger_random_side_effect(smoker, 10, strength, effect)
				TEST_ASSERT(notified == (strength >= 2 || effect <= 2), "Forced real symptom [effect] must retain severity gating at strength [strength].")
				TEST_ASSERT(smoker.get_stamina_loss() == original_stamina, "Symptom [effect] must not add stamina damage, even near critical.")
				TEST_ASSERT(smoker.nutrition == original_nutrition, "Withdrawal symptoms must not accumulate starvation damage.")
				TEST_ASSERT(!smoker.has_status_effect(/datum/status_effect/incapacitating/stamcrit), "Repeated symptoms must never trigger stamina critical.")
				TEST_ASSERT(!smoker.has_status_effect(/datum/status_effect/dizziness), "The dizziness description must not apply a physical dizziness effect.")
				TEST_ASSERT(!IS_UNCONSCIOUS_OR_CRIT(smoker) && !HAS_TRAIT(smoker, TRAIT_INCAPACITATED) && smoker.body_position == STANDING_UP, "Withdrawal must not knock down or disable the smoker.")
	smoker.mind.nicotine_next_withdrawal_notice = 0
	ADD_TRAIT(smoker, TRAIT_NOHUNGER, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(!addiction.trigger_random_side_effect(smoker, 2, 2, 1), "No-hunger bodies must not receive hunger symptoms.")

/datum/unit_test/nicotine_withdrawal/shared_notice_limit/Run()
	smoker.mind.active_addictions[/datum/addiction/nicotine] = WITHDRAWAL_STAGE3_START_CYCLE
	TEST_ASSERT(addiction.send_withdrawal_notice(smoker, "Test craving"), "First eligible notice must be delivered.")
	var/deadline = smoker.mind.nicotine_next_withdrawal_notice
	TEST_ASSERT(!addiction.send_withdrawal_notice(smoker, "Test craving"), "A second craving must be suppressed.")
	for(var/effect in 1 to 4)
		TEST_ASSERT(!addiction.trigger_random_side_effect(smoker, 2, 2, effect), "Side-effect messages must share the craving cooldown.")
	addiction.withdrawal_enters_stage_1(smoker, 2)
	addiction.withdrawal_enters_stage_2(smoker, 2)
	addiction.withdrawal_enters_stage_3(smoker, 2)
	TEST_ASSERT(smoker.mind.nicotine_next_withdrawal_notice == deadline, "Stage-entry messages must share the same deadline.")
	// Force each periodic probability to 100% while the existing notice remains on cooldown.
	addiction.withdrawal_stage_1_process(smoker, 100000)
	TEST_ASSERT(smoker.mind.nicotine_next_withdrawal_notice == deadline, "Periodic stage one must not bypass or extend the shared deadline.")
	addiction.withdrawal_stage_2_process(smoker, 100000)
	TEST_ASSERT(smoker.mind.nicotine_next_withdrawal_notice == deadline, "Periodic stage two symptoms and cravings must share the deadline.")
	addiction.withdrawal_stage_3_process(smoker, 100000)
	TEST_ASSERT(smoker.mind.nicotine_next_withdrawal_notice == deadline, "Periodic stage three symptoms and cravings must share the deadline.")
	// Advance only this fixture's eligibility boundary; never alter world time or sleep for minutes.
	smoker.mind.nicotine_next_withdrawal_notice = world.time
	TEST_ASSERT(addiction.trigger_random_side_effect(smoker, 2, 2, 2), "A symptom at the cooldown boundary must become eligible again.")
	TEST_ASSERT(smoker.mind.nicotine_next_withdrawal_notice == world.time + 2 MINUTES, "Accepted symptom must start the next cooldown.")

/datum/unit_test/nicotine_withdrawal/relief_and_recovery/Run()
	smoker.mind.active_addictions[/datum/addiction/nicotine] = WITHDRAWAL_STAGE3_START_CYCLE
	addiction.process_addiction(smoker, 1)
	TEST_ASSERT(smoker.mob_mood.mood_events["/datum/addiction/nicotine_addiction"], "Fixture must first be in real severe withdrawal.")
	var/original_points = smoker.mind.addiction_points[/datum/addiction/nicotine]
	smoker.reagents.add_reagent(/datum/reagent/drug/nicotine, MIN_NICOTINE_ADDICTION_REAGENT_AMOUNT)
	// Large elapsed time would make the old cached-stage processor produce another craving after relief.
	addiction.process_addiction(smoker, 100000)
	TEST_ASSERT(smoker.mind.active_addictions[/datum/addiction/nicotine] == 1, "Adequate nicotine must reset withdrawal without processing the cached severe stage.")
	TEST_ASSERT(!smoker.mob_mood.mood_events["/datum/addiction/nicotine_addiction"], "Real reagent relief must remove withdrawal mood.")
	TEST_ASSERT(smoker.mind.nicotine_next_withdrawal_notice == 0, "Relief must clear the old notice cooldown without immediately issuing another notice.")
	TEST_ASSERT(smoker.mind.addiction_points[/datum/addiction/nicotine] == original_points, "Relief must preserve addiction points.")
	TEST_ASSERT(!addiction.trigger_random_side_effect(smoker, 2, 2, 2), "A relieved mind must not receive withdrawal notices through a stale callback.")
	smoker.reagents.remove_reagent(/datum/reagent/drug/nicotine, 100)
	smoker.mind.active_addictions[/datum/addiction/nicotine] = WITHDRAWAL_STAGE2_START_CYCLE
	addiction.process_addiction(smoker, 1)
	TEST_ASSERT(smoker.mind.nicotine_next_withdrawal_notice > world.time, "Withdrawal after nicotine wears off must be eligible again.")
	smoker.mind.remove_addiction_points(/datum/addiction/nicotine, MAX_ADDICTION_POINTS)
	TEST_ASSERT(!LAZYACCESS(smoker.mind.active_addictions, /datum/addiction/nicotine), "Real addiction recovery must remove the active addiction.")
	TEST_ASSERT(smoker.mind.nicotine_next_withdrawal_notice == 0 && !smoker.mob_mood.mood_events["/datum/addiction/nicotine_addiction"], "Recovery must clear only this smoker's withdrawal state.")
	TEST_ASSERT(HAS_TRAIT(smoker, TRAIT_SMOKER), "Relief and recovery must not remove the Smoker trait.")
	smoker.reagents.add_reagent(/datum/reagent/drug/nicotine, MIN_NICOTINE_ADDICTION_REAGENT_AMOUNT)
	addiction.process_addiction(smoker, 2)
	TEST_ASSERT(!LAZYACCESS(smoker.mind.active_addictions, /datum/addiction/nicotine), "Nicotine relief must not create an addiction in a recovered mind.")

/datum/unit_test/nicotine_withdrawal/independent_minds_and_transfer/Run()
	var/mob/living/carbon/human/consistent/other = allocate(__IMPLIED_TYPE__)
	other.mind_initialize()
	allocated += other.mind
	other.mind.add_addiction_points(/datum/addiction/nicotine, 1000)
	smoker.mind.active_addictions[/datum/addiction/nicotine] = WITHDRAWAL_STAGE1_START_CYCLE
	other.mind.active_addictions[/datum/addiction/nicotine] = WITHDRAWAL_STAGE1_START_CYCLE
	TEST_ASSERT(addiction.send_withdrawal_notice(smoker, "First player"), "First player must be eligible.")
	TEST_ASSERT(addiction.send_withdrawal_notice(other, "Second player"), "Shared global addiction must not suppress another player's notice.")
	var/other_deadline = other.mind.nicotine_next_withdrawal_notice
	var/datum/mind/transferred = smoker.mind
	var/original_deadline = transferred.nicotine_next_withdrawal_notice
	var/mob/living/carbon/human/consistent/new_body = allocate(__IMPLIED_TYPE__)
	transferred.transfer_to(new_body)
	TEST_ASSERT(new_body.mind == transferred && transferred.nicotine_next_withdrawal_notice == original_deadline, "Actual mind transfer must preserve notice state.")
	TEST_ASSERT(!addiction.send_withdrawal_notice(new_body, "Duplicate after transfer"), "Changing body must not bypass the cooldown.")
	addiction.end_withdrawal(new_body)
	TEST_ASSERT(transferred.nicotine_next_withdrawal_notice == 0, "End withdrawal must reset the transferred mind.")
	TEST_ASSERT(other.mind.nicotine_next_withdrawal_notice == other_deadline, "One mind's recovery must not change another's state.")

/datum/unit_test/nicotine_withdrawal/no_withdrawals_and_no_mind/Run()
	smoker.mind.active_addictions[/datum/addiction/nicotine] = WITHDRAWAL_STAGE3_START_CYCLE
	addiction.process_addiction(smoker, 1)
	ADD_TRAIT(smoker, TRAIT_NO_WITHDRAWALS, TRAIT_SOURCE_UNIT_TESTS)
	addiction.process_addiction(smoker, 2)
	TEST_ASSERT(smoker.mind.active_addictions[/datum/addiction/nicotine] == 1, "No-withdrawals trait must retain its real base-process reset.")
	TEST_ASSERT(smoker.mind.nicotine_next_withdrawal_notice == 0 && !smoker.mob_mood.mood_events["/datum/addiction/nicotine_addiction"], "No-withdrawals trait must clear mood and notice state.")
	var/mob/living/carbon/human/consistent/mindless = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(!mindless.mind, "Fixture must have no initialized mind.")
	TEST_ASSERT(!addiction.send_withdrawal_notice(mindless, "No mind"), "Mindless bodies must safely skip notices.")
	TEST_ASSERT(!addiction.process_addiction(mindless, 2), "Mindless bodies must safely skip nicotine processing.")
