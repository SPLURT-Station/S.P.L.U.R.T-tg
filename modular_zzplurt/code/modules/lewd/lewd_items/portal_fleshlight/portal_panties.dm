/obj/item/clothing/sextoy/portal_panties
	name = "portal panties"
	desc = "A pair of panties with bluespace tech allowing lovers to hump at a distance. Needs to be paired with a portal fleshlight before use."
	icon = 'modular_zzplurt/icons/obj/lewd/fleshlight.dmi'
	icon_state = "portal_panties"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/underwear.dmi' //TODO: Add a worn icon for this item
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_MASK
	extra_slot_flags = ITEM_SLOT_UNDERWEAR
	lewd_slot_flags = LEWD_SLOT_PENIS | LEWD_SLOT_VAGINA | LEWD_SLOT_ANUS
	var/obj/item/clothing/sextoy/portal_fleshlight/linked_fleshlight = null
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
		context[SCREENTIP_CONTEXT_ALT_LMB] = linked_fleshlight ? "Unlink fleshlight" : "No fleshlight linked"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/clothing/sextoy/portal_fleshlight))
		context[SCREENTIP_CONTEXT_LMB] = "Link fleshlight"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/clothing/sextoy/portal_panties/examine(mob/user)
	. = ..()
	if(!linked_fleshlight)
		. += span_notice("The status light is off. The device needs to be paired with a portal fleshlight.")
		return

	. += span_notice("The status light is [equipped_slot ? "on" : "off"]. The portal is [equipped_slot ? "open" : "closed"].")
	if(equipped_slot)
		. += span_notice("The current target is: [current_target]")

	. += span_notice("Use it as underwear to autodetect genitals")
	. += span_notice("Use as mask to connect to the mouth")
	. += span_notice("Use in genital slots to connect to specific genitals")

/obj/item/clothing/sextoy/portal_panties/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	var/obj/item/clothing/sextoy/portal_fleshlight/portal_toy = W
	if(!istype(portal_toy))
		return
	portal_toy.link_panties(src, user)

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
	else if(slot in list(ITEM_SLOT_UNDERWEAR, ITEM_SLOT_MASK, ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS))
		audible_message("[icon2html(src, hearers(src))] *beep* *beep* *beep*")
		playsound(src, 'sound/machines/beep/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
		to_chat(user, span_notice("The panties are not linked to a portal fleshlight."))

/obj/item/clothing/sextoy/portal_panties/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return .

	anonymous = !anonymous
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	balloon_alert(user, "anonymous mode: [anonymous ? "ON" : "OFF"]")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/sextoy/portal_panties/click_alt(mob/user)
	if(!linked_fleshlight)
		to_chat(user, span_warning("[src] isn't linked to any portal fleshlight!"))
		return CLICK_ACTION_BLOCKING

	var/choice = tgui_alert(user, "Are you sure you want to unlink the portal fleshlight?", "Unlink Portal Fleshlight", list("Yes", "No"))
	if(choice != "Yes")
		return CLICK_ACTION_BLOCKING

	to_chat(user, span_notice("You unlink the portal fleshlight from [src]."))
	linked_fleshlight.unlink_panties()

/obj/item/clothing/sextoy/portal_panties/Destroy()
	if(linked_fleshlight)
		linked_fleshlight.unlink_panties()
		linked_fleshlight = null
	return ..()
