// Mk.2 variant implemented independently of the base Mk.II chip.
#ifndef DNA_BLANK
#define DNA_BLANK 0
#endif
#ifndef CHIP_EXPIRED
#define CHIP_EXPIRED 1
#endif
#ifndef DNA_READY
#define DNA_READY 2
#endif

/obj/item/skillchip/mk2pet
	name = "ENT-PET Mk.III ULTRA skillchip"
	desc = "A heavily modified version of the MK.II, seemingly done as a custom job. You hesitate to imagine this in anyones brain."
	removable = FALSE
	complexity = 2
	slot_use = 2
	cooldown = 15 MINUTES
	auto_traits = list(TRAIT_PET_SKILLCHIP)
	skill_name = "Pet Enthrallment Mk.III"
	skill_description = "Transforms the user into a devoted companion!"
	skill_icon = FA_ICON_HEART
	activate_message = span_purple(span_bold("You feel the skillchip activating, starting to rewire your mind. Don’t worry about complex thoughts any more; you’re officially downgraded to 'good boy/girl' status. Obedience and loyalty are now your new personality traits. So sit, stay, and enjoy the cozy, simplified existence of your new pet life."))
	deactivate_message = span_purple(span_bold("You feel lucidity returning to your mind as the skillchip attempts to return your brain to normal function."))
	var/static/list/warning_given = list()
	var/static/last_warning_round_id
	var/enthrall_ckey
	var/enthrall_gender
	var/enthrall_name
	var/datum/weakref/enthrall_ref
	var/status = DNA_BLANK

/obj/item/skillchip/mk2pet/proc/maybe_warn(mob/user)
	if(!user || !user.client)
		return TRUE
	if(GLOB.round_id && last_warning_round_id != GLOB.round_id)
		warning_given = list()
		last_warning_round_id = GLOB.round_id
	var/ckey = user.client?.ckey
	if(!ckey)
		return TRUE
	if(warning_given[ckey])
		return TRUE
	var/choice = tgui_alert(user, "This item is strictly intended as an ERP item. It should not be used for any mechanical gain, especially for antagonist purposes. Failure to respect this will result in administrative action being taken. Do you wish to continue using this item?", "A word of warning.", list("Yes", "No"))
	if(choice != "Yes")
		return FALSE
	warning_given[ckey] = TRUE
	return TRUE

/obj/item/skillchip/mk2pet/attack_hand(mob/user, modifiers)
	if(!maybe_warn(user))
		return TRUE
	return ..()

/obj/item/skillchip/mk2pet/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(!(slot & ITEM_SLOT_HANDS))
		return
	if(!maybe_warn(user))
		user.dropItemToGround(src, force = TRUE)

/obj/item/skillchip/mk2pet/attack_self(mob/user, modifiers)
	. = ..()
	var/mob/living/carbon/human/dna_holder = user
	if(!istype(dna_holder))
		to_chat(user, span_warning("The skillchip can't find a DNA identifier to record!"))
		return

	if(!dna_holder.client?.prefs?.read_preference(/datum/preference/toggle/erp/hypnosis))
		to_chat(dna_holder, span_danger("Preferences check failed. You must enable 'Hypnosis' in your game preferences (ERP section) in order to use [src]!"))
		return

	var/mob/living/carbon/human/enthrall = enthrall_ref?.resolve()
	if(!isnull(enthrall))
		var/response = tgui_alert(dna_holder, "The display reads the skillchip is imprinted with enthrall [enthrall_name]. Would you like to re-imprint it?", "DNA Imprint", list("Re-imprint", "Cancel Imprinting"))
		if(response == "Re-imprint")
			enthrall_ckey = null
			enthrall_gender = null
			enthrall_name = null
			enthrall_ref = null
			status = DNA_BLANK
			visible_message(span_notice("The light on [src] begins to flash slowly!"))
		else
			return

	to_chat(dna_holder, span_notice("You press the programming button on [src]."))
	var/list/title_options = list("Master", "Mistress", "Custom...", "Cancel Imprinting")
	var/selected_title = tgui_input_list(dna_holder, "What title would you like to use with your thrall?", "DNA Imprint: [dna_holder.real_name]", title_options)
	if(selected_title == "Cancel Imprinting" || !selected_title)
		return

	if(selected_title == "Custom...")
		var/custom_title = tgui_input_text(dna_holder, "Enter the title your thrall will call you.", "Custom Title", dna_holder.real_name, 24)
		custom_title = trim(custom_title)
		if(!length(custom_title))
			to_chat(dna_holder, span_warning("Invalid title; imprinting cancelled."))
			return

		// Strip basic punctuation to keep chat output clean.
		custom_title = replacetext(custom_title, "<", "")
		custom_title = replacetext(custom_title, ">", "")
		custom_title = replacetext(custom_title, "\[", "")
		custom_title = replacetext(custom_title, "\]", "")
		custom_title = replacetext(custom_title, "\\", "")
		custom_title = trim(custom_title)
		if(!length(custom_title))
			to_chat(dna_holder, span_warning("Invalid title; imprinting cancelled."))
			return
		enthrall_gender = custom_title
	else
		enthrall_gender = selected_title

	enthrall_ref = WEAKREF(dna_holder)
	enthrall_ckey = dna_holder.ckey
	enthrall_name = dna_holder.real_name
	status = DNA_READY
	to_chat(dna_holder, span_purple("[src] imprinted with DNA identifier: [enthrall_gender] [enthrall_name]."))
	visible_message(span_notice("The light on [src] remains steadily lit!"))

/obj/item/skillchip/mk2pet/examine(mob/user)
	. = ..()
	switch(status)
		if(DNA_BLANK)
			. += span_notice("The status light is flashing, indicating that the skillchip is ready for DNA imprint.")
		if(DNA_READY)
			. += span_notice("The status light is on, indicating that the skillchip is ready for use.")
			. += span_purple("The status display reads [enthrall_name].")
		else
			. += span_notice("The status light is off, indicating that the skillchip is non-functional.")

/obj/item/skillchip/mk2pet/has_mob_incompatibility(mob/living/carbon/target)
	if(!istype(target))
		return "Incompatible lifeform detected."

	var/obj/item/organ/brain/brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(QDELETED(brain))
		return "Get a brain, moran."

	var/brain_message = has_brain_incompatibility(brain)
	if(brain_message)
		return brain_message

	var/mob/living/carbon/human/enthrall = enthrall_ref?.resolve()
	if(isnull(enthrall))
		return "Unable to locate DNA imprint."

	if(enthrall == target)
		return "You can't enthrall yourself."

	if(!enthrall.client?.prefs?.read_preference(/datum/preference/toggle/erp/hypnosis))
		return "[enthrall] has Hypnosis preference disabled."

	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/hypnosis))
		return "[target] has Hypnosis preference disabled."

	return FALSE

/obj/item/skillchip/mk2pet/on_activate(mob/living/carbon/user, silent = FALSE)
	if(status != DNA_READY)
		to_chat(user, span_warning("[src] is not imprinted and fizzles."))
		// Prompt the user to imprint now so the Skillsoft station path can still set it up.
		attack_self(user)
		return FALSE

	. = ..()

	var/mob/living/carbon/human/enthrall = enthrall_ref?.resolve()
	if(!isnull(enthrall))
		var/obj/item/organ/vocal_cords/vocal_cords = enthrall.get_organ_slot(ORGAN_SLOT_VOICE)
		var/obj/item/organ/vocal_cords/new_vocal_cords = new /obj/item/organ/vocal_cords/velvet
		if(vocal_cords)
			vocal_cords.Remove(enthrall)
		new_vocal_cords.Insert(enthrall)
		qdel(vocal_cords)
		to_chat(enthrall, span_purple("<i>You feel your vocal cords tingle as they grow more charismatic and sultry.</i>"))

	user.apply_status_effect(/datum/status_effect/chem/enthrall/pet_chip/mk2)
	return TRUE

/obj/item/skillchip/mk2pet/on_deactivate(mob/living/carbon/user, silent = FALSE)
	user.remove_status_effect(/datum/status_effect/chem/enthrall/pet_chip/mk2)
	return ..()

/datum/status_effect/chem/enthrall/pet_chip/mk2
	ignore_mindshield = TRUE
	distance_mood_enabled = FALSE

/datum/mood_event/enthrall_sissy
	description = "Your owner wants you dressed differently."
	mood_change = -4
	timeout = 2 MINUTES

// Compatibility alias for any legacy references that still spawn /mkiiultra/mk2.
/obj/item/skillchip/mkiiultra/mk2
	parent_type = /obj/item/skillchip/mk2pet
