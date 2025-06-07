/datum/element/armorbreaking
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	// Amount of armor breaking. (1 = chip, 2 = crack, 3 = break, 4 = shatter)
	var/breaking_strength
	// Does this weapon apply the effect when thrown?
	var/thrown_effect

/datum/element/armorbreaking/Attach(datum/target, breaking_strength = 1, thrown_effect = FALSE)
	. = ..()
	src.breaking_strength = breaking_strength
	src.thrown_effect = thrown_effect
	target.AddElementTrait(TRAIT_ON_HIT_EFFECT, REF(src), /datum/element/on_hit_effect)
	RegisterSignal(target, COMSIG_ON_HIT_EFFECT, PROC_REF(do_breaking))

/datum/element/armorbreaking/Detach(datum/source)
	UnregisterSignal(source, COMSIG_ON_HIT_EFFECT)
	REMOVE_TRAIT(source, TRAIT_ON_HIT_EFFECT, REF(src))
	return ..()

/datum/element/armorbreaking/proc/do_breaking(datum/element_owner, mob/living/owner, mob/living/target, throw_hit)
	if(!istype(target))
		return
	if(target.stat == DEAD)
		return
	if((throw_hit && !thrown_effect))
		return
	switch(breaking_strength)
		if(1)
			target.apply_status_effect(/datum/status_effect/armorbreak)
		if(2)
			target.apply_status_effect(/datum/status_effect/armorbreak/crack)
		if(3)
			target.apply_status_effect(/datum/status_effect/armorbreak/bbreak)
		if(4)
			target.apply_status_effect(/datum/status_effect/armorbreak/shatter)
