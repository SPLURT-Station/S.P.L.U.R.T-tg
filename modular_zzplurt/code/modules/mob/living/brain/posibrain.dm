
// circuit board brain fix.
/obj/item/mmi/posibrain/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.tool_behaviour != TOOL_WELDER)
		return ITEM_INTERACT_BLOCKING

	var/brain_damaged = brain && (brain.damage > 0 || (brain.organ_flags & ORGAN_FAILING))
	var/mob_dead = (brainmob?.mind || brainmob?.key) && brainmob.stat == DEAD

	if(!brain_damaged && !mob_dead)
		to_chat(user, span_notice("[src] doesn't need any repairs."))
		return ITEM_INTERACT_BLOCKING

	if(brain?.suicided || (brainmob && HAS_TRAIT(brainmob, TRAIT_SUICIDED)))
		to_chat(user, span_warning("[src] is beyond repair."))
		return ITEM_INTERACT_BLOCKING

	if(!tool.tool_start_check(user, amount = 1))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(
		span_notice("[user] starts repairing [src] with [tool]..."),
		span_notice("You start repairing [src] with [tool]..."),
	)

	if(!tool.use_tool(src, user, 2 SECONDS, amount = 1, volume = 50))
		return ITEM_INTERACT_BLOCKING

	if(brain)
		brain.set_organ_damage(0)
		brain.organ_flags &= ~ORGAN_FAILING
	if((brainmob?.mind || brainmob?.key) && brainmob.stat == DEAD)
		brainmob.set_stat(STABLE)
