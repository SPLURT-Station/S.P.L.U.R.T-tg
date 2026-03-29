/obj/item/clothing/sextoy/portal_panties
	name = "portal panties"
	desc = "A pair of panties with bluespace tech allowing lovers to hump at a distance. Can be paired with a portal fleshlight OR directly with another pair of portal panties."
	icon = 'modular_zzplurt/icons/obj/lewd/fleshlight.dmi'
	icon_state = "portal_panties"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/underwear.dmi' //TODO: Add a worn icon for this item
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_MASK
	extra_slot_flags = ITEM_SLOT_UNDERWEAR
	lewd_slot_flags = LEWD_SLOT_PENIS | LEWD_SLOT_VAGINA | LEWD_SLOT_ANUS
	var/obj/item/clothing/sextoy/portal_fleshlight/linked_fleshlight = null
	/// Directly linked portal panties for panty-to-panty connection
	var/obj/item/clothing/sextoy/portal_panties/linked_panties = null
	var/current_target = null
	var/equipped_slot = null
	/// Whether the panties' wearer is anonymous
	var/anonymous = FALSE

/obj/item/clothing/sextoy/portal_panties/Initialize(mapload)
	. = ..()
	register_context()

/obj/item/clothing/sextoy/portal_panties/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_LMB] = "Pick up"
		context[SCREENTIP_CONTEXT_RMB] = "Toggle anonymous mode"
		if(linked_fleshlight)
			context[SCREENTIP_CONTEXT_ALT_LMB] = "Unlink fleshlight"
		else if(linked_panties)
			context[SCREENTIP_CONTEXT_ALT_LMB] = "Unlink panties"
		else
			context[SCREENTIP_CONTEXT_ALT_LMB] = "No device linked"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/clothing/sextoy/portal_fleshlight))
		context[SCREENTIP_CONTEXT_LMB] = "Link fleshlight"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/clothing/sextoy/portal_panties) && held_item != src)
		var/obj/item/clothing/sextoy/portal_panties/other_panties = held_item
		if(other_panties.linked_panties || other_panties.linked_fleshlight)
			context[SCREENTIP_CONTEXT_LMB] = "Already linked"
		else
			context[SCREENTIP_CONTEXT_LMB] = "Link panties"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/clothing/sextoy/portal_panties/examine(mob/user)
	. = ..()
	if(!linked_fleshlight && !linked_panties)
		. += span_notice("The status light is off. The device needs to be paired with a portal fleshlight or another pair of portal panties.")
		return

	. += span_notice("The status light is [equipped_slot ? "on" : "off"]. The portal is [equipped_slot ? "open" : "closed"].")
	if(equipped_slot)
		. += span_notice("The current target is: [current_target]")

	if(linked_panties)
		. += span_notice("Directly linked to another pair of portal panties.")

	. += span_notice("Use it as underwear to autodetect genitals")
	. += span_notice("Use as mask to connect to the mouth")
	. += span_notice("Use in genital slots to connect to specific genitals")

/obj/item/clothing/sextoy/portal_panties/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()

	if(istype(W, /obj/item/clothing/sextoy/portal_fleshlight))
		var/obj/item/clothing/sextoy/portal_fleshlight/portal_toy = W
		portal_toy.link_panties(src, user)
		return

	if(istype(W, /obj/item/clothing/sextoy/portal_panties) && W != src)
		var/obj/item/clothing/sextoy/portal_panties/other_panties = W

		// Check if we want to link the panties together
		if(!linked_panties && !linked_fleshlight && !other_panties.linked_panties && !other_panties.linked_fleshlight)
			// Neither is linked, so link them together
			link_panties(other_panties, user)
			return

		// Both are linked to each other - perform direct panty-to-panty interaction
		if(other_panties == linked_panties || src == other_panties.linked_panties)
			// Check if both panties are being worn
			var/mob/living/carbon/human/user_wearer
			var/mob/living/carbon/human/target_wearer

			if(isliving(loc) && ishuman(loc))
				user_wearer = loc
			if(isliving(other_panties.loc) && ishuman(other_panties.loc))
				target_wearer = other_panties.loc

			if(!istype(user_wearer) || !istype(target_wearer))
				to_chat(user, span_warning("Both pairs of portal panties need to be worn!"))
				return

			// Determine organ targets based on equipped slot
			var/user_organ = equipped_slot in list(ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS) ? equipped_slot : null
			var/target_organ = other_panties.equipped_slot in list(ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS) ? other_panties.equipped_slot : null

			if(!user_organ || !target_organ)
				to_chat(user, span_warning("Both partners need to have their genital slots configured!"))
				return

			// Perform the interaction
			perform_panty_interaction(user, target_wearer, user_organ, target_organ)
			return

		// Already linked to something else
		to_chat(user, span_warning("[other_panties] is already linked to another device!"))
		return

/obj/item/clothing/sextoy/portal_panties/proc/perform_panty_interaction(mob/living/user, mob/living/target_wearer, user_organ, target_organ)
	// Get the interaction name from the map (mirrors portal_fleshlight.interaction_map)
	var/static/list/interaction_map = list(
		ORGAN_SLOT_VAGINA = list(
			ORGAN_SLOT_PENIS = "Portal Fuck (Vagina)",
			ORGAN_SLOT_VAGINA = "Portal Tribadism",
			ORGAN_SLOT_ANUS = null,
			BODY_ZONE_PRECISE_MOUTH = "Portal Oral (Vagina)",
		),
		ORGAN_SLOT_ANUS = list(
			ORGAN_SLOT_PENIS = "Portal Fuck (Anus)",
			ORGAN_SLOT_VAGINA = null,
			ORGAN_SLOT_ANUS = null,
			BODY_ZONE_PRECISE_MOUTH = "Portal Oral (Anus)",
		),
		ORGAN_SLOT_PENIS = list(
			ORGAN_SLOT_PENIS = "Portal Frotting",
			ORGAN_SLOT_VAGINA = "Portal Vaginal Ride",
			ORGAN_SLOT_ANUS = "Portal Anal Ride",
			BODY_ZONE_PRECISE_MOUTH = "Portal Fuck (Mouth)",
		),
		BODY_ZONE_PRECISE_MOUTH = list(
			ORGAN_SLOT_PENIS = "Portal Fuck (Mouth)",
			ORGAN_SLOT_VAGINA = null,
			ORGAN_SLOT_ANUS = null,
			BODY_ZONE_PRECISE_MOUTH = "Portal Kiss",
		)
	)

	var/interaction_name = interaction_map[user_organ]?[target_organ]
	if(!interaction_name)
		to_chat(user, span_warning("You can't use the portal panties like this!"))
		return

	var/datum/interaction/lewd/portal/interaction_to_try = SSinteractions.interactions[interaction_name]

	if(!interaction_to_try)
		to_chat(user, span_warning("Interaction not found!"))
		return

	var/mob/living/carbon/human/human_user = user
	var/mob/living/carbon/human/human_target = target_wearer

	if(!interaction_to_try?.allow_act(human_target, human_user))
		to_chat(user, span_warning("You can't use the portal panties like this!"))
		return

	interaction_to_try.act(human_target, human_user)
	target_wearer.do_jitter_animation()

/obj/item/clothing/sextoy/portal_panties/lewd_equipped(mob/living/carbon/human/user, slot, initial)
	. = ..()
	update_target(user, slot)

/obj/item/clothing/sextoy/portal_panties/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	update_target(user, slot)

/obj/item/clothing/sextoy/portal_panties/dropped(mob/living/carbon/human/user)
	. = ..()
	update_target(user)

/obj/item/clothing/sextoy/portal_panties/proc/update_target(mob/living/carbon/human/user, slot)
	if(!istype(user))
		return

	equipped_slot = slot

	switch(slot)
		if(ITEM_SLOT_UNDERWEAR)
			if(ismob(loc))
				var/mob/living/carbon/human/H = loc
				if(H.has_vagina())
					current_target = ORGAN_SLOT_VAGINA
				else if(H.has_penis())
					current_target = ORGAN_SLOT_PENIS
				else
					current_target = ORGAN_SLOT_ANUS
		if(ITEM_SLOT_MASK)
			current_target = BODY_ZONE_PRECISE_MOUTH
		if(ORGAN_SLOT_PENIS)
			current_target = ORGAN_SLOT_PENIS
		if(ORGAN_SLOT_VAGINA)
			current_target = ORGAN_SLOT_VAGINA
		if(ORGAN_SLOT_ANUS)
			current_target = ORGAN_SLOT_ANUS
		else
			current_target = null

	if(linked_fleshlight)
		linked_fleshlight.update_appearance()
	else if(linked_panties)
		linked_panties.update_appearance()
	else if(slot in list(ITEM_SLOT_UNDERWEAR, ITEM_SLOT_MASK, ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS))
		audible_message("[icon2html(src, hearers(src))] *beep* *beep* *beep*")
		playsound(src, 'sound/machines/beep/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
		to_chat(user, span_notice("The panties are not linked to a portal fleshlight or another pair of panties."))

/obj/item/clothing/sextoy/portal_panties/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return .

	anonymous = !anonymous
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	balloon_alert(user, "anonymous mode: [anonymous ? "ON" : "OFF"]")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/sextoy/portal_panties/click_alt(mob/user)
	if(!linked_fleshlight && !linked_panties)
		to_chat(user, span_warning("[src] isn't linked to any device!"))
		return CLICK_ACTION_BLOCKING

	if(linked_panties)
		var/choice = tgui_alert(user, "Are you sure you want to unlink the portal panties?", "Unlink Portal Panties", list("Yes", "No"))
		if(choice != "Yes")
			return CLICK_ACTION_BLOCKING
		to_chat(user, span_notice("You unlink the portal panties from [src]."))
		unlink_panties()
		return

	var/choice = tgui_alert(user, "Are you sure you want to unlink the portal fleshlight?", "Unlink Portal Fleshlight", list("Yes", "No"))
	if(choice != "Yes")
		return CLICK_ACTION_BLOCKING

	to_chat(user, span_notice("You unlink the portal fleshlight from [src]."))
	linked_fleshlight.unlink_panties()
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/sextoy/portal_panties/proc/link_panties(obj/item/clothing/sextoy/portal_panties/panties, mob/living/user)
	if(!istype(panties))
		return FALSE

	if(panties.linked_panties || panties.linked_fleshlight)
		to_chat(user, span_warning("[panties] is already linked to another device!"))
		return FALSE

	if(linked_panties || linked_fleshlight)
		to_chat(user, span_warning("[src] is already linked to another device!"))
		return FALSE

	linked_panties = panties
	panties.linked_panties = src
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	playsound(panties, 'sound/machines/ping.ogg', 50, FALSE)
	to_chat(user, span_notice("You link [src] to [panties] directly."))

	update_appearance()
	panties.update_appearance()
	return TRUE

/obj/item/clothing/sextoy/portal_panties/proc/unlink_panties()
	if(isliving(loc))
		audible_message("[icon2html(src, hearers(loc))] *beep* *beep* *beep*")
		playsound(src, 'sound/machines/beep/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
		to_chat(loc, span_notice("The link to the [linked_panties] is lost."))

	if(isliving(linked_panties?.loc))
		linked_panties.audible_message("[icon2html(linked_panties, hearers(linked_panties))] *beep* *beep* *beep*")
		playsound(linked_panties, 'sound/machines/beep/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
		to_chat(linked_panties.loc, span_notice("The link to the [src] is lost."))

	linked_panties.linked_panties = null
	linked_panties.update_appearance()
	linked_panties = null

	update_appearance()

/obj/item/clothing/sextoy/portal_panties/Destroy()
	if(linked_fleshlight)
		linked_fleshlight.unlink_panties()
		linked_fleshlight = null
	if(linked_panties)
		linked_panties.linked_panties = null
		linked_panties.update_appearance()
		linked_panties = null
	return ..()
