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
