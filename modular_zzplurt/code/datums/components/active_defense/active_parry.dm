/// This component handles active blocking. And parrying too I guess.
/datum/component/active_parry
	var/datum/active_block_data/block_data

/datum/component/active_parry/Initialize(datum/active_block_data/block_data)
	if(!istype(parent, /mob/living))
		return COMPONENT_INCOMPATIBLE

	if(!ispath(block_data, /datum/active_block_data))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))



