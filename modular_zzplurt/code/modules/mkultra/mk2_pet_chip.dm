// Mk.2 variant: keeps the original mkiiultra intact while offering a mindshield-ignoring pet chip.
/datum/status_effect/chem/enthrall
	var/distance_mood_enabled = TRUE
	var/ignore_mindshield = FALSE

#ifndef DNA_BLANK
#define DNA_BLANK 0
#endif
#ifndef DNA_READY
#define DNA_READY 2
#endif

/obj/item/skillchip/mkiiultra/mk2
	name = "ENT-PET Mk.III ULTRA skillchip"
	desc = "A heavily modified version of the MK.II, seemingly done as a custom job. You hesitate to imagine this in anyones brain."
	skill_name = "Pet Enthrallment Mk.2"
	skill_description = "Transforms the user into a devoted companion!"

/obj/item/skillchip/mkiiultra/mk2/attack_self(mob/user, modifiers)
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

/obj/item/skillchip/mkiiultra/mk2/on_activate(mob/living/carbon/user, silent = FALSE)
	// Mirror base behaviour but apply the Mk.2 enthrall status that ignores mindshields.
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

/obj/item/skillchip/mkiiultra/mk2/on_deactivate(mob/living/carbon/user, silent = FALSE)
	user.remove_status_effect(/datum/status_effect/chem/enthrall/pet_chip/mk2)
	return ..()

/datum/status_effect/chem/enthrall/pet_chip/mk2
	ignore_mindshield = TRUE
	distance_mood_enabled = FALSE

#ifndef FULLY_ENTHRALLED
#define FULLY_ENTHRALLED 3
#endif

/datum/status_effect/chem/enthrall/pet_chip/mk2/on_apply()
	. = ..()
	if(!owner)
		return
	phase = FULLY_ENTHRALLED
	withdrawl_active = FALSE
	withdrawl_progress = 0
	mental_capacity = max(mental_capacity, 500)
	distance_mood_enabled = FALSE

/datum/status_effect/chem/enthrall/pet_chip/mk2/tick(seconds_between_ticks)
	phase = FULLY_ENTHRALLED
	withdrawl_active = FALSE
	withdrawl_progress = 0
	. = ..()
	phase = FULLY_ENTHRALLED
	withdrawl_active = FALSE

/datum/mood_event/enthrall_sissy
	description = "Your owner wants you dressed differently."
	mood_change = -4
	timeout = 2 MINUTES
