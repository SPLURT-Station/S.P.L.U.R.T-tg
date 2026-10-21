/datum/action/item_action/use_portal_panties
	name = "Use Portal Panties"
	desc = "Use your worn portal panties with the linked pair."
	check_flags = AB_CHECK_CONSCIOUS

/obj/item/clothing/sextoy/portal_panties
	name = "portal panties"
	desc = "A pair of panties with bluespace tech allowing lovers to hump at a distance. Needs to be paired with a portal fleshlight or another pair of portal panties before use."
	icon = 'modular_zzplurt/icons/obj/lewd/fleshlight.dmi'
	icon_state = "portal_panties"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/underwear.dmi' //TODO: Add a worn icon for this item
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_MASK
	extra_slot_flags = ITEM_SLOT_UNDERWEAR
	lewd_slot_flags = LEWD_SLOT_PENIS | LEWD_SLOT_VAGINA | LEWD_SLOT_ANUS
	clothing_flags = INEDIBLE_CLOTHING
	actions_types = list(/datum/action/item_action/use_portal_panties)
	var/obj/item/clothing/sextoy/portal_fleshlight/linked_fleshlight = null
	var/obj/item/clothing/sextoy/portal_panties/linked_panties = null
	var/current_target = null
	var/equipped_slot = null
	/// Whether the panties' wearer is anonymous
	var/anonymous = FALSE
	COOLDOWN_DECLARE(portal_cooldown)

	/// Dictionary mapping target panties organ and user panties organ to interaction names
	var/static/list/interaction_map = list(
		ORGAN_SLOT_VAGINA = list(
			ORGAN_SLOT_PENIS = /datum/interaction/lewd/portal/fuck_vagina::name,
			ORGAN_SLOT_VAGINA = /datum/interaction/lewd/portal/tribadism::name,
			ORGAN_SLOT_ANUS = null,
			BODY_ZONE_PRECISE_MOUTH = /datum/interaction/lewd/portal/oral_vagina::name,
		),
		ORGAN_SLOT_ANUS = list(
			ORGAN_SLOT_PENIS = /datum/interaction/lewd/portal/fuck_anus::name,
			ORGAN_SLOT_VAGINA = null,
			ORGAN_SLOT_ANUS = null,
			BODY_ZONE_PRECISE_MOUTH = /datum/interaction/lewd/portal/oral_anus::name,
		),
		ORGAN_SLOT_PENIS = list(
			ORGAN_SLOT_PENIS = /datum/interaction/lewd/portal/frotting::name,
			ORGAN_SLOT_VAGINA = /datum/interaction/lewd/portal/vaginal_ride::name,
			ORGAN_SLOT_ANUS = /datum/interaction/lewd/portal/anal_ride::name,
			BODY_ZONE_PRECISE_MOUTH = /datum/interaction/lewd/portal/oral_penis::name,
		),
		BODY_ZONE_PRECISE_MOUTH = list(
			ORGAN_SLOT_PENIS = /datum/interaction/lewd/portal/fuck_mouth::name,
			ORGAN_SLOT_VAGINA = null,
			ORGAN_SLOT_ANUS = null,
			BODY_ZONE_PRECISE_MOUTH = /datum/interaction/lewd/portal/oral_mouth::name,
		),
	)

/obj/item/clothing/sextoy/portal_panties/Initialize(mapload)
	. = ..()
	register_context()

/obj/item/clothing/sextoy/portal_panties/item_action_slot_check(slot, mob/user, datum/action/action)
	return (slot in list(ITEM_SLOT_UNDERWEAR, ITEM_SLOT_MASK, ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS))

/obj/item/clothing/sextoy/portal_panties/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_LMB] = equipped_slot ? "Use portal panties" : "Pick up"
		context[SCREENTIP_CONTEXT_RMB] = "Toggle anonymous mode"
		if(linked_fleshlight)
			context[SCREENTIP_CONTEXT_ALT_LMB] = "Unlink fleshlight"
		else if(linked_panties)
			context[SCREENTIP_CONTEXT_ALT_LMB] = "Unlink panties"
		else
			context[SCREENTIP_CONTEXT_ALT_LMB] = "No portal device linked"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/clothing/sextoy/portal_fleshlight))
		context[SCREENTIP_CONTEXT_LMB] = "Link fleshlight"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/clothing/sextoy/portal_panties))
		context[SCREENTIP_CONTEXT_LMB] = "Link panties"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/clothing/sextoy/portal_panties/examine(mob/user)
	. = ..()
	if(!linked_fleshlight && !linked_panties)
		. += span_notice("The status light is off. The device needs to be paired with a portal fleshlight or another pair of portal panties.")
		return

	var/portal_open = equipped_slot && (linked_fleshlight || (linked_panties?.equipped_slot && ishuman(linked_panties.loc)))
	. += span_notice("The status light is [equipped_slot ? "on" : "off"]. The portal is [portal_open ? "open" : "closed"].")
	if(equipped_slot)
		. += span_notice("The current target is: [current_target]")

	. += span_notice("Use it as underwear to autodetect genitals")
	. += span_notice("Use as mask to connect to the mouth")
	. += span_notice("Use in genital slots to connect to specific genitals")

/obj/item/clothing/sextoy/portal_panties/attack_self(mob/user)
	. = ..()
	if(!equipped_slot)
		if(linked_panties)
			to_chat(user, span_warning("You need to wear [src] before you can use it!"))
		return

	if(!COOLDOWN_FINISHED(src, portal_cooldown))
		return

	if(!linked_panties)
		to_chat(user, span_warning("[src] isn't linked to another pair of portal panties!"))
		return

	if(!istype(loc, /mob/living/carbon/human) || !istype(linked_panties.loc, /mob/living/carbon/human) || !linked_panties.equipped_slot)
		to_chat(user, span_warning("Both portal panties need to be worn by someone!"))
		return

	var/mob/living/carbon/human/wearer = loc
	var/mob/living/carbon/human/target_wearer = linked_panties.loc
	var/panty_target = linked_panties.current_target
	var/user_target = current_target

	var/interaction_name = interaction_map[panty_target]?[user_target]
	var/mob/living/carbon/human/act_user = wearer
	var/mob/living/carbon/human/act_target = target_wearer

	if(!interaction_name)
		interaction_name = interaction_map[user_target]?[panty_target]
		if(interaction_name)
			act_user = target_wearer
			act_target = wearer

	if(!interaction_name)
		to_chat(user, span_warning("You can't use [src] like this!"))
		return

	var/datum/interaction/lewd/portal/interaction_to_try = SSinteractions.interactions[interaction_name]
	if(!interaction_to_try?.allow_act(act_user, act_target))
		to_chat(user, span_warning("You can't use [src] like this!"))
		return

	COOLDOWN_START(src, portal_cooldown, CLICK_CD_MELEE)
	interaction_to_try.act(act_user, act_target)
	wearer.do_jitter_animation()
	if(target_wearer != wearer)
		target_wearer.do_jitter_animation()

/obj/item/clothing/sextoy/portal_panties/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(istype(W, /obj/item/clothing/sextoy/portal_fleshlight))
		var/obj/item/clothing/sextoy/portal_fleshlight/portal_toy = W
		portal_toy.link_panties(src, user)
		return
	if(istype(W, /obj/item/clothing/sextoy/portal_panties))
		link_panties(W, user)
		return

/obj/item/clothing/sextoy/portal_panties/proc/link_panties(obj/item/clothing/sextoy/portal_panties/other_panties, mob/living/user)
	if(!istype(other_panties) || other_panties == src)
		return FALSE

	if(linked_fleshlight)
		to_chat(user, span_warning("[src] is already linked to a portal fleshlight!"))
		return FALSE

	if(linked_panties)
		to_chat(user, span_warning("[src] is already linked to another pair of portal panties!"))
		return FALSE

	if(other_panties.linked_fleshlight)
		to_chat(user, span_warning("[other_panties] is already linked to a portal fleshlight!"))
		return FALSE

	if(other_panties.linked_panties)
		to_chat(user, span_warning("[other_panties] is already linked to another pair of portal panties!"))
		return FALSE

	linked_panties = other_panties
	other_panties.linked_panties = src

	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	to_chat(user, span_notice("You link [src] to [other_panties]."))
	return TRUE

/obj/item/clothing/sextoy/portal_panties/proc/unlink_panties()
	if(!linked_panties)
		return

	var/obj/item/clothing/sextoy/portal_panties/other_panties = linked_panties

	if(isliving(loc))
		audible_message("[icon2html(src, hearers(src))] *beep* *beep* *beep*")
		playsound(src, 'sound/machines/beep/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
		to_chat(loc, span_notice("The panties beep as the link to the [other_panties] is lost."))

	if(isliving(other_panties.loc))
		other_panties.audible_message("[icon2html(other_panties, hearers(other_panties))] *beep* *beep* *beep*")
		playsound(other_panties, 'sound/machines/beep/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
		to_chat(other_panties.loc, span_notice("The panties beep as the link to the [src] is lost."))

	other_panties.linked_panties = null
	linked_panties = null

/obj/item/clothing/sextoy/portal_panties/lewd_equipped(mob/living/carbon/human/user, slot, initial)
	. = ..()
	item_flags |= IN_INVENTORY
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
			equipped_slot = null

	if(linked_fleshlight)
		linked_fleshlight.update_appearance()
	else if(!linked_panties && (slot in list(ITEM_SLOT_UNDERWEAR, ITEM_SLOT_MASK, ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS)))
		audible_message("[icon2html(src, hearers(src))] *beep* *beep* *beep*")
		playsound(src, 'sound/machines/beep/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
		to_chat(user, span_notice("The panties are not linked to a portal fleshlight or portal panties."))

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
		to_chat(user, span_warning("[src] isn't linked to any portal device!"))
		return CLICK_ACTION_BLOCKING

	var/linked_name = linked_fleshlight ? "portal fleshlight" : "portal panties"
	var/choice = tgui_alert(user, "Are you sure you want to unlink the [linked_name]?", "Unlink Portal Device", list("Yes", "No"))
	if(choice != "Yes")
		return CLICK_ACTION_BLOCKING

	if(linked_fleshlight)
		to_chat(user, span_notice("You unlink the portal fleshlight from [src]."))
		linked_fleshlight.unlink_panties()
	else if(linked_panties)
		to_chat(user, span_notice("You unlink the portal panties from [src]."))
		unlink_panties()
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/sextoy/portal_panties/Destroy()
	if(linked_fleshlight)
		linked_fleshlight.unlink_panties()
		linked_fleshlight = null
	if(linked_panties)
		unlink_panties()
	return ..()
