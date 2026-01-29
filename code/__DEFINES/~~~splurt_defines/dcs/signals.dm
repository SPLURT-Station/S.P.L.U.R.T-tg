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
 * # COMSIG_MOB_POST_CLIMAX
 * From /mob/living
 * Used by signals for whenever a mob has ejaculated
*/
/// From /mob/living/climax(): (mob/source, mob/living/partner, interaction_position, manual)
#define COMSIG_MOB_POST_CLIMAX "mob_post_climax"

/*
 * # COMSIG_HUMAN_PERFORM_CLIMAX
 * From /datum/status_effect/climax
 * Used by signals for when a mob has climaxed.
*/
#define COMSIG_HUMAN_PERFORM_CLIMAX "human_perform_climax"
