//Own
/datum/reagent/consumable/wockyslush
	name = "Wocky Slush"
	description = "That thang bleedin' to the-... ya know I mean?"
	color = "#7b60c4" // rgb(123, 96, 196)
	quality = DRINK_VERYGOOD
	taste_description = "cold rainbows"

/datum/reagent/consumable/wockyslush/on_mob_life(mob/living/carbon/M)
	M.emote(pick("twitch","giggle","stare"))
	M.set_drugginess(75)
	M.apply_status_effect(/datum/status_effect/throat_soothed)
	..()

/datum/reagent/consumable/orange_creamsicle
	name = "Orange Creamsicle"
	description = "A Summer time drink that can be frozen and eaten or drunk from a glass!"
	color = "#ffb46e" // rgb(255, 180, 110)
	taste_description = "ice cream and orange soda"

// Donator drink

/datum/reagent/consumable/honeystones_love
	name = "Honeystone's Love"
	description = "A dash of a mother's desire in every silken-drop!~"
	color = "#7b60c4" // rgb(123, 96, 196)
	quality = DRINK_FANTASTIC
	taste_description = "vivid memories, love, and lucid dirty dreams!~"

/datum/reagent/consumable/honeystones_love/on_mob_life(mob/living/carbon/M)
	if((prob(min(current_cycle/2,5))))
		M.emote(pick("giggle","grin"))
	M.apply_status_effect(/datum/status_effect/throat_soothed)
	// healing
	M.adjustBruteLoss(-1.2, 0)
	M.adjustFireLoss(-1.2, 0)
	M.adjustToxLoss(-1.2, 0, TRUE)
	M.adjustOxyLoss(-1.2, 0)
	//checks for mindbreaker
	if(holder.has_reagent(/datum/reagent/toxin/mindbreaker))
		holder.remove_reagent(/datum/reagent/toxin/mindbreaker, 5)
	//applies horny effect
	var/mob/living/carbon/human/H = M
	H.adjust_arousal(35)
	/* Not supported yet
	for(var/g in genits)
		var/obj/item/organ/genital/G = g
		to_chat(M, span_userlove("[G.arousal_verb]!"))*/

	..()

// Reagent add: Breast Milk
/datum/reagent/consumable/breast_milk/on_mob_add(mob/living/affected_mob, amount)
	. = ..()

	// Send signal for adding reagent
	SEND_SIGNAL(affected_mob, COMSIG_REAGENT_ADD_BREASTMILK, src, amount)

// Reagent metabolize: Nuka Cola
/datum/reagent/consumable/nuka_cola/on_mob_metabolize(mob/living/affected_mob)
	. = ..()

	// Send signal for adding reagent
	SEND_SIGNAL(affected_mob, COMSIG_REAGENT_METABOLIZE_NUKACOLA)
