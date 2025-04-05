#define CONCUBUS_FLUIDS list(/datum/reagent/consumable/cum,\
							/datum/reagent/consumable/femcum,\
							/datum/reagent/consumable/milk)

// Reagent process: Salt
/datum/reagent/consumable/salt/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()

	SEND_SIGNAL(affected_mob, COMSIG_REAGENT_PROCESS_SALT, src, seconds_per_tick, times_fired)

// Reagent expose: Salt
/datum/reagent/consumable/salt/expose_mob(mob/living/affected_mob, methods, reac_volume)
	. = ..()

	SEND_SIGNAL(affected_mob, COMSIG_REAGENT_EXPOSE_SALT, src, methods, reac_volume)

/datum/reagent/consumable/alienhoney
	name = "Honey (Safe)"
	description = "Sweet, sweet honey that does not decay into sugar."
	color = "#d3a308"
	nutriment_factor = 5 * REAGENTS_METABOLISM
	metabolization_rate = 1 * REAGENTS_METABOLISM
	taste_description = "sweetness"

/datum/reagent/consumable/get_nutriment_factor(mob/living/carbon/eater)
	var/nutriment_factor = 8
	if (eater.has_quirk(/datum/quirk/concubus))
		return (src.type in CONCUBUS_FLUIDS) ? (nutriment_factor * REAGENTS_METABOLISM * purity * 2) : 0
	return ..()

/datum/reagent/consumable/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	if(exposed_mob.has_quirk(/datum/quirk/concubus))
		return
	return ..()

#undef CONCUBUS_FLUIDS
