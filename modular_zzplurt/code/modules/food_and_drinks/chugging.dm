/**
 * Chugging behavior.
 *
 * Restores the citadel-style "chug" interaction: when a user targets their
 * OWN mouth zone with an open, fillable reagent cup (drinks, meds held in
 * beakers, bottles, bowls, etc.) and drinks from it, they down the ENTIRE
 * contents in a single gulp after a short delay, rather than taking a
 * normal sip.
 *
 * We override `try_drink()` (the current entry point for drinking from a
 * cup, replacing the old `attack()` path) so the behavior works everywhere
 * the new interaction pipeline is used.
 */

/// How long the chug do_after takes before the full-volume gulp happens.
#define CHUG_DELAY (3 SECONDS)

/obj/item/reagent_containers/cup
	/// Re-entrancy guard so a single chug can't be started multiple times at once.
	var/being_chugged = FALSE

/obj/item/reagent_containers/cup/try_drink(mob/living/target_mob, mob/living/user)
	if(!should_chug(target_mob, user))
		return ..()

	if(!canconsume(target_mob, user))
		return ITEM_INTERACT_BLOCKING

	being_chugged = TRUE
	user.visible_message(
		span_notice("[user] starts chugging [src]."),
		span_notice("You start chugging [src]."),
	)

	if(!do_after(user, CHUG_DELAY, target_mob))
		being_chugged = FALSE
		return ITEM_INTERACT_BLOCKING

	if(!reagents || !reagents.total_volume)
		being_chugged = FALSE
		return ITEM_INTERACT_BLOCKING

	// Chug everything in one gulp by temporarily bumping gulp_size to the
	// full remaining volume, then restoring it so we never leak state.
	var/original_gulp_size = gulp_size
	gulp_size = reagents.total_volume
	user.visible_message(
		span_notice("[user] chugs [src]!"),
		span_notice("You chug [src]!"),
	)

	. = ..()

	gulp_size = original_gulp_size
	being_chugged = FALSE

/**
 * Returns TRUE if this drink attempt should be treated as a chug:
 * the user is drinking from themselves, aiming at their mouth, the
 * container has something to chug, and we aren't already chugging it.
 */
/obj/item/reagent_containers/cup/proc/should_chug(mob/living/target_mob, mob/living/user)
	if(being_chugged)
		return FALSE
	if(target_mob != user)
		return FALSE
	if(user.zone_selected != BODY_ZONE_PRECISE_MOUTH)
		return FALSE
	if(!is_open_container())
		return FALSE
	if(!reagents || !reagents.total_volume)
		return FALSE
	return TRUE

#undef CHUG_DELAY
