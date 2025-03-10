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
