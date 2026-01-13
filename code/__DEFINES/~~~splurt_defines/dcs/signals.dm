/*
 * # COMSIG_MICRO_PICKUP_FEET
 * From /datum/element/mob_holder/micro
 * Used by signals for determining whether you can pick up someone with your feet, kinky.
*/
#define COMSIG_MICRO_PICKUP_FEET "micro_force_grabbed"

/*
 * # COMSIG_MOB_RESIZED
 * From /mob/living
 * Used by signals for whenever a mob has changed sizes.
*/
#define COMSIG_MOB_RESIZED "mob_resized"

/*
 * # COMSIG_HUMAN_PERFORM_CLIMAX
 * From /datum/status_effect/climax
 * Used by signals for when a mob has climaxed.
*/
#define COMSIG_HUMAN_PERFORM_CLIMAX "human_perform_climax"

/*
 * # COMSIG_MOB_CUM_IN
 * From /mob/living
 * Used by signals for whenever a mob came into sombody
*/
/// From /mob/living/climax(): (mob/source, mob/living/partner)
#define COMSIG_MOB_CUM_IN "mob_cum_in"

/*
 * # COMSIG_MOB_CUM_ON
 * From /mob/living
 * Used by signals for whenever a mob came onto somebody
*/
/// From /mob/living/climax(): (mob/source, mob/living/partner)
#define COMSIG_MOB_CUM_ON "mob_cum_on"
