// Mk.2 pet-chip specific enthrall setup; keeps upstream enthrall untouched.

// Provide modular vars used by mkultra commands.
/datum/status_effect/chem/enthrall
	var/distance_mood_enabled = TRUE
	var/ignore_mindshield = FALSE

/datum/status_effect/chem/enthrall/pet_chip/mk2/on_apply()
	// Resolve imprint data from the Mk.2 chip before running base enthrall setup.
	var/mob/living/carbon/enthrall_victim = owner
	var/obj/item/organ/brain/neopet_brain = enthrall_victim?.get_organ_slot(ORGAN_SLOT_BRAIN)
	var/obj/item/skillchip/mk2pet/mk2_chip
	for(var/obj/item/skillchip/mk2pet/chip in neopet_brain?.skillchips)
		if(istype(chip) && chip.active)
			mk2_chip = chip
			break

	if(mk2_chip)
		enthrall_ckey = mk2_chip.enthrall_ckey
		enthrall_gender = mk2_chip.enthrall_gender
		enthrall_mob = mk2_chip.enthrall_ref?.resolve() || get_mob_by_key(enthrall_ckey)
		lewd = TRUE

		if(isnull(enthrall_mob))
			stack_trace("Mk.2 pet chip enthrall has no linked enthrall mob. Removing status.")
			owner.remove_status_effect(src)
			return FALSE

		return ..()
	else
		// Fallback to base chip if somehow a Mk.2 status was applied without the Mk.2 item.
		for(var/obj/item/skillchip/mkiiultra/base_chip in neopet_brain?.skillchips)
			if(istype(base_chip) && base_chip.active)
				enthrall_ckey = base_chip.enthrall_ckey
				enthrall_gender = base_chip.enthrall_gender
				enthrall_mob = get_mob_by_key(enthrall_ckey)
				lewd = TRUE
				return ..()

	if(isnull(enthrall_mob))
		stack_trace("Mk.2 pet chip enthrall has no linked enthrall mob. Removing status.")
		owner.remove_status_effect(src)
		return FALSE

	return ..()
