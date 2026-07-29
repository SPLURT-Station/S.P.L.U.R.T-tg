// Right-click a sink with anything that holds liquid to tip it out down the drain.
// Left-click still fills/wets, so the two halves of the interaction mirror each other.

/// How long emptying a container into a sink takes, per unit of reagent held.
#define SINK_EMPTY_TIME_PER_UNIT (0.02 SECONDS)
/// Emptying a container into a sink never takes longer than this, no matter how full it is.
#define SINK_EMPTY_TIME_MAX (3 SECONDS)

/**
 * Returns TRUE if [tool] is holding liquid that can be tipped out into us.
 *
 * Anything you can normally pour or draw liquid out of qualifies. Absorbent janitorial
 * items are allowed on top of that, since they hold reagents without any container flags
 * but wringing them out into a sink is exactly what you'd expect to be able to do.
 */
/obj/structure/sink/proc/can_empty_into_drain(obj/item/tool)
	if(isnull(tool?.reagents))
		return FALSE
	if(tool.is_drawable()) // Covers both DRAWABLE and DRAINABLE holders.
		return TRUE
	return istype(tool, /obj/item/mop) || istype(tool, /obj/item/towel)

/obj/structure/sink/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if(!can_empty_into_drain(held_item))
		return .

	context[SCREENTIP_CONTEXT_RMB] = "Empty into drain"
	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/sink/examine(mob/user)
	. = ..()
	. += span_notice("You could [EXAMINE_HINT("right-click")] it with a container to empty it down the drain.")

/obj/structure/sink/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(!can_empty_into_drain(tool))
		return ..()

	if(busy)
		to_chat(user, span_warning("Someone's already washing here!"))
		return ITEM_INTERACT_BLOCKING

	if(!tool.reagents.total_volume)
		balloon_alert(user, "already empty!")
		return ITEM_INTERACT_BLOCKING

	var/empty_time = min(tool.reagents.total_volume * SINK_EMPTY_TIME_PER_UNIT, SINK_EMPTY_TIME_MAX)

	user.visible_message(
		span_notice("[user] starts emptying [tool] into [src]."),
		span_notice("You start emptying [tool] into [src]..."),
	)
	playsound(src, 'sound/effects/slosh.ogg', 25, TRUE)

	busy = TRUE
	if(!do_after(user, empty_time, target = src))
		busy = FALSE
		return ITEM_INTERACT_BLOCKING
	busy = FALSE

	// The container could have been emptied, swapped or dropped while we were pouring.
	if(QDELETED(tool) || !user.is_holding(tool))
		return ITEM_INTERACT_BLOCKING
	if(!tool.reagents.total_volume)
		balloon_alert(user, "already empty!")
		return ITEM_INTERACT_BLOCKING

	user.log_message("emptied [tool] ([tool.reagents.get_reagent_log_string()]) into [src] at [AREACOORD(src)].", LOG_GAME)
	tool.reagents.clear_reagents()
	playsound(src, 'sound/machines/sink-faucet.ogg', 50)

	user.visible_message(
		span_notice("[user] empties [tool] into [src]."),
		span_notice("You empty [tool] into [src], washing its contents down the drain."),
	)
	return ITEM_INTERACT_SUCCESS

#undef SINK_EMPTY_TIME_PER_UNIT
#undef SINK_EMPTY_TIME_MAX
