// Mk.2 pet-chip specific enthrall setup; keeps upstream enthrall untouched.

// Provide modular vars used by mkultra commands.
/datum/status_effect/chem/enthrall
	var/distance_mood_enabled = TRUE
	var/ignore_mindshield = FALSE

#ifndef FULLY_ENTHRALLED
#define FULLY_ENTHRALLED 3
#endif

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

		. = ..()
	else
		// Fallback to base chip if somehow a Mk.2 status was applied without the Mk.2 item.
		for(var/obj/item/skillchip/mkiiultra/base_chip in neopet_brain?.skillchips)
			if(istype(base_chip) && base_chip.active)
				enthrall_ckey = base_chip.enthrall_ckey
				enthrall_gender = base_chip.enthrall_gender
				enthrall_mob = get_mob_by_key(enthrall_ckey)
				lewd = TRUE
				. = ..()
				break

	if(isnull(enthrall_mob))
		stack_trace("Mk.2 pet chip enthrall has no linked enthrall mob. Removing status.")
		owner.remove_status_effect(src)
		return FALSE

	if(!.)
		return
	if(!owner)
		return

	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)
	RegisterSignal(owner, COMSIG_MOVABLE_HEAR, PROC_REF(owner_hear))

	phase = FULLY_ENTHRALLED
	withdrawl_active = FALSE
	withdrawl_progress = 0
	mental_capacity = max(mental_capacity, 500)
	distance_mood_enabled = FALSE
	RegisterSignal(owner, COMSIG_OOC_ESCAPE, PROC_REF(ooc_escape))

/datum/status_effect/chem/enthrall/pet_chip/mk2/on_remove()
	UnregisterSignal(owner, COMSIG_OOC_ESCAPE)
	return ..()

/datum/status_effect/chem/enthrall/pet_chip/mk2/proc/clear_distance_mood()
	if(!owner)
		return
	if(withdrawl_active || withdrawl_progress)
		REMOVE_TRAIT(owner, TRAIT_PACIFISM, "MKUltra")
	owner.clear_mood_event("EnthMissing1")
	owner.clear_mood_event("EnthMissing2")
	owner.clear_mood_event("EnthMissing3")
	owner.clear_mood_event("EnthMissing4")
	withdrawl_active = FALSE
	withdrawl_progress = 0
	distance_apart = 0

/datum/status_effect/chem/enthrall/pet_chip/mk2/tick(seconds_between_ticks)
	phase = FULLY_ENTHRALLED
	if(!distance_mood_enabled)
		clear_distance_mood()
	. = ..()
	phase = FULLY_ENTHRALLED
	if(!distance_mood_enabled)
		clear_distance_mood()
	if(cooldown > 10)
		cooldown = 10

/datum/status_effect/chem/enthrall/pet_chip/mk2/proc/ooc_escape(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/humanoid = owner
	if(istype(humanoid))
		mkultra_clear_all_commands(humanoid)
		mkultra_deactivate_pet_chips(humanoid)
		if(humanoid.has_status_effect(/datum/status_effect/chem/enthrall))
			humanoid.remove_status_effect(/datum/status_effect/chem/enthrall)

/datum/status_effect/chem/enthrall/pet_chip/mk2/owner_hear(datum/source, list/hearing_args)
	if(lewd == FALSE)
		return
	if(trigger_cached > 0)
		return
	var/mob/living/carbon/enthralled_mob = owner
	var/raw_message = LOWER_TEXT(hearing_args[HEARING_RAW_MESSAGE])
	for(var/trigger in custom_triggers)
		var/cached_trigger = LOWER_TEXT(trigger)
		if(findtext(raw_message, cached_trigger))
			var/trigger_entry = custom_triggers[trigger]
			if(islist(trigger_entry) && islist(trigger_entry["commands"]))
				trigger_cached = 5 //Stops triggerparties and as a result, stops servercrashes.
				mkultra_run_custom_trigger_sequence(enthralled_mob, trigger_entry["commands"])
				return
			break

	return ..()
