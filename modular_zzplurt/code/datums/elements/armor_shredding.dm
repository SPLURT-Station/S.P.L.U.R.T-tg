/datum/element/armorshredding
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	// Amount of armor shredding.
	var/shred_strength
	// Duration of the armor shredding effect.
	var/shred_duration

/datum/element/armorshredding/Attach(datum/target, shred_strength = 10, shred_duration = 6 SECONDS, thrown_effect = FALSE)
	. = ..()
	src.shred_strength = shred_strength
	src.shred_duration = shred_duration
	target.AddComponent(\
		/datum/component/on_hit_effect,\
		on_hit_callback = CALLBACK(src, PROC_REF(do_shredding)),\
		thrown_effect = thrown_effect,\
	)
/datum/element/armorshredding/Detach(datum/target)
	qdel(target.GetComponent(/datum/component/on_hit_effect))
	return ..()

/datum/element/armorshredding/proc/do_shredding(datum/element_owner, mob/living/owner, mob/living/target)
	if(!istype(target))
		return
	if(target.stat == DEAD)
		return
	if(stun_on_hit)
		target.electrocute_act(shock_damage, owner, 1, SHOCK_NOGLOVES)
		return
	target.electrocute_act(shock_damage, owner, 1, SHOCK_NOSTUN | SHOCK_NOGLOVES)
