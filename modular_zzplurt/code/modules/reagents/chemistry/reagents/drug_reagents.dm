/datum/reagent/drug/copium
	name = "Copium"
	description = "Cope and sssethe"
	taste_description = "coping"
	color = "#0f0"
	trippy = FALSE
	overdose_threshold = 30

/datum/reagent/drug/copium/on_mob_life(mob/living/carbon/affected_mob)
	. = ..()

	if (!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	if (prob(10))
		to_chat(H, "<span class='notice'>You feel like you can cope!</span>")
		H.adjust_disgust(-10)
		affected_mob.add_mood_event("opium", /datum/mood_event/cope, name)

/datum/reagent/drug/copium/overdose_start(mob/living/carbon/affected_mob)
	to_chat(affected_mob, "<span class='userdanger'>What the fuck.</span>")
	affected_mob.add_mood_event("[type]_overdose", /datum/mood_event/overdose, name)

/datum/reagent/drug/copium/overdose_process(mob/living/carbon/affected_mob)
	var/mob/living/carbon/human/H = affected_mob
	if (prob(5))
		H.adjust_disgust(20)
		to_chat(H, "<span class='warning'>I can't stand it anymore!</span>")
	. = ..()

// Buff tirizene
/datum/reagent/toxin/staminatoxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	SHOULD_CALL_PARENT(FALSE)
	var/stam_damage = 0.5 * data * metabolization_ratio * seconds_per_tick
	if(affected_mob.adjust_stamina_loss(stam_damage, updating_stamina = FALSE))
		. = UPDATE_MOB_HEALTH
	affected_mob.received_stamina_damage(affected_mob.staminaloss, stam_damage) // Keeps the target in stamcrit as long as it's present
	data = max(data - 1, 3)
