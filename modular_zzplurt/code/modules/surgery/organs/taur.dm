/obj/item/organ/taur_body/fishlike
	left_leg_name = "upper body"
	right_leg_name = "lower body"
	/// Action to toggle on/off mermaid form
	var/datum/action/cooldown/spell/mermaid_toggle/mermaid_toggle

/obj/item/organ/taur_body/fishlike/on_mob_insert(mob/living/carbon/receiver, special, movement_flags)
	. = ..()
	if(isnull(mermaid_toggle))
		mermaid_toggle = new
	if(!(mermaid_toggle in receiver.actions))
		mermaid_toggle.Grant(receiver)

	if (special)
		spawn(1)
			mermaid_toggle.cast(receiver) // visual bug fix dumb
			mermaid_toggle.cast(receiver) // fuck

/obj/item/organ/taur_body/fishlike/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	if(mermaid_toggle && !mermaid_toggle.in_mermaid_form) // Somehow we lost our taur part while in human form--this shouldn't happen.
		mermaid_toggle.transform_to_mermaid(organ_owner)
		mermaid_toggle.Remove(organ_owner)

/obj/item/organ/taur_body/fishlike/Destroy(force)
	if(mermaid_toggle)
		QDEL_NULL(mermaid_toggle)
	return ..()

/datum/action/cooldown/spell/mermaid_toggle
	name = "Grow Legs"
	desc = "Grow legs and walk on land."
	button_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "deactivate_wash"

	cooldown_time = 5 SECONDS
	spell_requirements = NONE

	/// Weakref to the stored mermaid body (when legs are active)
	var/datum/weakref/stored_mermaid_body
	/// Are we currently in mermaid form?
	var/in_mermaid_form = TRUE

/datum/action/cooldown/spell/mermaid_toggle/update_button_name(atom/movable/screen/movable/action_button/button, force)
	if(in_mermaid_form)
		name = initial(name)
		desc = initial(desc)
	else
		name = "Mermaid Transform"
		desc = "Return to your mermaid form."
	return ..()

/datum/action/cooldown/spell/mermaid_toggle/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(in_mermaid_form)
		button_icon_state = initial(button_icon_state)
	else
		button_icon_state = "activate_wash"

	return ..()

/obj/effect/temp_visual/mermaid_transform
	name = "mermaidbubbles"
	icon_state = "bubbles"

/obj/effect/temp_visual/mermaid_transform/Initialize(mapload)
	pixel_z -= 8
	alpha = 128
	return ..()

/datum/action/cooldown/spell/mermaid_toggle/cast(mob/living/carbon/human/user = usr)
	. = ..()

	if(in_mermaid_form)
		transform_to_legs(user)
	else
		transform_to_mermaid(user)
		new /obj/effect/temp_visual/mermaid_transform(get_turf(user))

	in_mermaid_form = !in_mermaid_form
	build_all_button_icons(UPDATE_BUTTON_NAME|UPDATE_BUTTON_ICON)

/datum/action/cooldown/spell/mermaid_toggle/proc/transform_to_legs(mob/living/carbon/human/user)
	var/obj/item/organ/taur_body/fishlike/mermaid_body = user.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAUR)

	if(!mermaid_body)
		return

	var/obj/item/shoes = user.get_item_by_slot(ITEM_SLOT_FEET)
	// Store body and remove it
	stored_mermaid_body = WEAKREF(mermaid_body)
	mermaid_body.Remove(user, special = TRUE)
	mermaid_body.moveToNullspace()
	spawn(1)
		user.equip_to_slot(shoes, ITEM_SLOT_FEET)
		user.update_clothing(ITEM_SLOT_ICLOTHING|ITEM_SLOT_OCLOTHING|ITEM_SLOT_FEET|ITEM_SLOT_SUITSTORE)

/datum/action/cooldown/spell/mermaid_toggle/proc/transform_to_mermaid(mob/living/carbon/human/user)
	var/obj/item/organ/taur_body/fishlike/mermaid_body = stored_mermaid_body?.resolve()

	if(isnull(mermaid_body))
		// Body is gone; reset state so we don't soft-lock
		stored_mermaid_body = null
		in_mermaid_form = TRUE
		return

	mermaid_body.Insert(user)
	spawn(0)
		user.update_clothing(ITEM_SLOT_ICLOTHING|ITEM_SLOT_OCLOTHING|ITEM_SLOT_FEET|ITEM_SLOT_SUITSTORE)

