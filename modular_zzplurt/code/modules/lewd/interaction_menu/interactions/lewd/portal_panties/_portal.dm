/datum/interaction/lewd/portal
	category = INTERACTION_CAT_HIDE
	distance_allowed = TRUE
	usage = INTERACTION_BOTH

	/// Messages used when the interaction is anonymous
	var/list/hidden_message = list()
	/// User messages used when the portal panties are anonymous
	var/list/hidden_user_messages = list()
	/// Target messages used when the portal fleshlight is anonymous
	var/list/hidden_target_messages = list()

	/// Hidden climax message overrides for anonymous interactions
	var/list/hidden_cum_message_text_overrides = list(CLIMAX_POSITION_USER = list(), CLIMAX_POSITION_TARGET = list())
	/// Hidden climax self message overrides for anonymous interactions
	var/list/hidden_cum_self_text_overrides = list(CLIMAX_POSITION_USER = list(), CLIMAX_POSITION_TARGET = list())
	/// Hidden climax partner message overrides for anonymous interactions
	var/list/hidden_cum_partner_text_overrides = list(CLIMAX_POSITION_USER = list(), CLIMAX_POSITION_TARGET = list())

/datum/interaction/lewd/portal/proc/get_held_fleshlight(mob/living/carbon/human/user)
	if(!istype(user))
		return null
	var/obj/item/activeItem = user.get_active_held_item()
	var/obj/item/clothing/sextoy/portal_fleshlight/fleshlight = activeItem

	if(!istype(fleshlight))
		// Check if it's in a plush we're holding
		fleshlight = locate(/obj/item/clothing/sextoy/portal_fleshlight) in activeItem
		if(!istype(fleshlight))
			return null

	return fleshlight

/datum/interaction/lewd/portal/proc/get_worn_portal_panties(mob/living/user, mob/living/target)
	if(!istype(user))
		return null
	for(var/obj/item/clothing/sextoy/portal_panties/panties in user.contents)
		if(!panties.equipped_slot || !panties.current_target)
			continue
		if(!target)
			return panties
		if(istype(panties.linked_panties) && panties.linked_panties.loc == target && panties.linked_panties.equipped_slot)
			return panties
		if(istype(panties.linked_fleshlight) && istype(target))
			for(var/obj/item/clothing/sextoy/portal_panties/target_panties in target.contents)
				if(target_panties.equipped_slot && istype(target_panties.linked_fleshlight))
					return panties
	return null

/datum/interaction/lewd/portal/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/clothing/sextoy/portal_fleshlight/fleshlight = get_held_fleshlight(user)
	if(istype(fleshlight) && istype(fleshlight.linked_panties))
		return ..()

	var/obj/item/clothing/sextoy/portal_panties/user_panties = get_worn_portal_panties(user, target)
	if(!istype(user_panties))
		return FALSE

	var/list/original_user_parts
	if(length(user_required_parts))
		original_user_parts = user_required_parts.Copy()
		for(var/slot in user_required_parts)
			user_required_parts[slot] = REQUIRE_GENITAL_ANY

	. = ..()

	if(original_user_parts)
		user_required_parts = original_user_parts

/datum/interaction/lewd/portal/act(mob/living/user, mob/living/target)
	var/list/original_message = message.Copy()
	var/list/original_user_messages = user_messages?.Copy()
	var/list/original_target_messages = target_messages?.Copy()

	var/obj/item/clothing/sextoy/portal_fleshlight/fleshlight = get_held_fleshlight(user)
	var/obj/item/clothing/sextoy/portal_panties/user_panties = istype(fleshlight) ? null : get_worn_portal_panties(user, target)
	var/obj/item/clothing/sextoy/portal_panties/panties = istype(fleshlight) ? fleshlight.linked_panties : (user_panties?.linked_panties || get_worn_portal_panties(target, user))

	var/user_anonymous = fleshlight?.anonymous || user_panties?.anonymous || user_panties?.linked_fleshlight?.anonymous
	var/target_anonymous = panties?.anonymous || panties?.linked_fleshlight?.anonymous

	if(user_anonymous && length(hidden_target_messages))
		target_messages = hidden_target_messages.Copy()

	if(target_anonymous && length(hidden_user_messages))
		user_messages = hidden_user_messages.Copy()

	if((user_anonymous || target_anonymous) && length(hidden_message))
		message = hidden_message.Copy()

	. = ..()

	// Restore original messages
	message = original_message
	if(length(original_user_messages))
		user_messages = original_user_messages
	if(length(original_target_messages))
		target_messages = original_target_messages

/datum/interaction/lewd/portal/show_climax(mob/living/cumming, mob/living/came_in, position)
	// Store original climax messages
	var/list/original_cum_message = cum_message_text_overrides.Copy()
	var/list/original_cum_self = cum_self_text_overrides.Copy()
	var/list/original_cum_partner = cum_partner_text_overrides.Copy()

	var/mob/living/portal_user = (position == CLIMAX_POSITION_USER) ? cumming : came_in
	var/mob/living/portal_target = (position == CLIMAX_POSITION_USER) ? came_in : cumming

	var/obj/item/clothing/sextoy/portal_fleshlight/fleshlight = get_held_fleshlight(portal_user)
	var/obj/item/clothing/sextoy/portal_panties/user_panties = istype(fleshlight) ? null : get_worn_portal_panties(portal_user, portal_target)
	var/obj/item/clothing/sextoy/portal_panties/panties = istype(fleshlight) ? fleshlight.linked_panties : (user_panties?.linked_panties || get_worn_portal_panties(portal_target, portal_user))

	var/user_anonymous = fleshlight?.anonymous || user_panties?.anonymous || user_panties?.linked_fleshlight?.anonymous
	var/target_anonymous = panties?.anonymous || panties?.linked_fleshlight?.anonymous

	// Replace with anonymous messages if needed
	if((user_anonymous && position == CLIMAX_POSITION_TARGET) || (target_anonymous && position == CLIMAX_POSITION_USER))
		if(length(hidden_cum_message_text_overrides[position]))
			cum_message_text_overrides[position] = hidden_cum_message_text_overrides[position]
			cum_self_text_overrides[position] = hidden_cum_self_text_overrides[position]
			cum_partner_text_overrides[position] = hidden_cum_partner_text_overrides[position]

	. = ..()

	// Restore original climax messages
	cum_message_text_overrides[position] = original_cum_message[position]
	cum_self_text_overrides[position] = original_cum_self[position]
	cum_partner_text_overrides[position] = original_cum_partner[position]
