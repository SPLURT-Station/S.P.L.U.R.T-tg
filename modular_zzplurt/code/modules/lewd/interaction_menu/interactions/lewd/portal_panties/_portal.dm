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

/datum/interaction/lewd/portal/allow_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/clothing/sextoy/portal_fleshlight/fleshlight = user.get_active_held_item()
	var/obj/item/clothing/sextoy/portal_panties/panties = istype(fleshlight) ? fleshlight.linked_panties : null

	if(!istype(fleshlight) || !istype(panties))
		return FALSE

	. = ..()

/datum/interaction/lewd/portal/act(mob/living/user, mob/living/target)
	var/list/original_message = message.Copy()
	var/list/original_user_messages = user_messages?.Copy()
	var/list/original_target_messages = target_messages?.Copy()

	var/obj/item/clothing/sextoy/portal_fleshlight/fleshlight = user.get_active_held_item()
	var/obj/item/clothing/sextoy/portal_panties/panties = istype(fleshlight) ? fleshlight.linked_panties : null

	if(fleshlight.anonymous && length(hidden_target_messages))
		target_messages = hidden_target_messages.Copy()

	if(panties.anonymous && length(hidden_user_messages))
		user_messages = hidden_user_messages.Copy()

	if((fleshlight.anonymous || panties.anonymous) && length(hidden_message))
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

	var/obj/item/clothing/sextoy/portal_fleshlight/fleshlight = cumming.get_active_held_item()
	if(!istype(fleshlight))
		fleshlight = came_in.get_active_held_item()
	var/obj/item/clothing/sextoy/portal_panties/panties = istype(fleshlight) ? fleshlight.linked_panties : null

	// Replace with anonymous messages if needed
	if((istype(fleshlight) && fleshlight.anonymous && position == CLIMAX_POSITION_TARGET) || (istype(panties) && panties.anonymous && position == CLIMAX_POSITION_USER))
		if(length(hidden_cum_message_text_overrides[position]))
			cum_message_text_overrides[position] = hidden_cum_message_text_overrides[position]
			cum_self_text_overrides[position] = hidden_cum_self_text_overrides[position]
			cum_partner_text_overrides[position] = hidden_cum_partner_text_overrides[position]

	. = ..()

	// Restore original climax messages
	cum_message_text_overrides[position] = original_cum_message[position]
	cum_self_text_overrides[position] = original_cum_self[position]
	cum_partner_text_overrides[position] = original_cum_partner[position]
