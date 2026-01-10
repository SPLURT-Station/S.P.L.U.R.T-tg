// heretic handling for holy water. its not good, but it works
// refactor when tg adds comsigs for can_cast_spell
/datum/action/cooldown/spell/can_cast_spell(feedback = TRUE)
	var/mob/living/carbon/owner = src.owner
	if(!istype(owner) || !owner.has_reagent(/datum/reagent/water/holywater))
		return ..()

	var/list/false_negatives = list(
		/datum/action/cooldown/spell/touch/mansus_grasp,
		/datum/action/cooldown/spell/aoe/wave_of_desperation
	)
	var/list/false_positives = list(
		/datum/action/cooldown/spell/timestop,
		/datum/action/cooldown/spell/chuuni_invocations,
	)

	if(type in false_positives)
		return ..()

	if(school == SCHOOL_FORBIDDEN || (type in false_negatives))
		if(feedback)
			to_chat(owner, span_boldwarning("The false god's poison scours your veins, separating your sight from the Mansus, and your spells fail you!"))
		return FALSE
	return ..()
