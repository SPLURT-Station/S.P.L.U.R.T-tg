/**
 * MKUltra pet chip tweaks: mindshields do not influence pet-chip enthrallment.
 * This lives in modular_zzplurt to avoid touching upstream mkultra code.
 */

#ifndef FULLY_ENTHRALLED
#define FULLY_ENTHRALLED 3
#endif

/obj/item/skillchip/mkiiultra/on_activate(mob/living/carbon/user, silent = FALSE)
	// Keep base activation behaviour, but swap in the pet-chip specific enthrall effect.
	. = ..()
	var/mob/living/carbon/human/enthrall = enthrall_ref?.resolve()
	if(!isnull(enthrall))
		mkultra_debug("pet chip activation: swapping cords on [enthrall]")
		var/obj/item/organ/vocal_cords/vocal_cords = enthrall.get_organ_slot(ORGAN_SLOT_VOICE)
		var/obj/item/organ/vocal_cords/new_vocal_cords = new /obj/item/organ/vocal_cords/velvet
		if(vocal_cords)
			vocal_cords.Remove(enthrall)
		new_vocal_cords.Insert(enthrall)
		qdel(vocal_cords)
		to_chat(enthrall, span_purple("<i>You feel your vocal cords tingle you speak in a more charasmatic and sultry tone.</i>"))
	// Apply a pet-chip variant of enthrall that ignores mindshields.
	user.apply_status_effect(/datum/status_effect/chem/enthrall/pet_chip)
	mkultra_debug("pet chip applied enthrall/pet_chip to [user]")

/datum/status_effect/chem/enthrall/pet_chip
	ignore_mindshield = TRUE
	distance_mood_enabled = FALSE

/datum/status_effect/chem/enthrall/pet_chip/on_apply()
	. = ..()
	if(!owner)
		return
	phase = FULLY_ENTHRALLED
	withdrawl_active = FALSE
	withdrawl_progress = 0
	mental_capacity = max(mental_capacity, 500)
	distance_mood_enabled = FALSE

/datum/status_effect/chem/enthrall/pet_chip/tick(seconds_between_ticks)
	phase = FULLY_ENTHRALLED
	withdrawl_active = FALSE
	withdrawl_progress = 0
	. = ..()
	phase = FULLY_ENTHRALLED
	withdrawl_active = FALSE
