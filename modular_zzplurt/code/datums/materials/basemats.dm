// Silver banes lycans and cursekin.
// Bubber already applies a lycan silver bane on the same type path; this override replaces it
// (zzplurt loads later) and adds the cursekin-specific weaker bane.

/datum/material/silver/on_applied(atom/source, mat_amount, multiplier, from_slot)
	. = ..()
	if (!isitem(source))
		return

	source.AddComponent( \
		/datum/component/bane, \
		should_bane_callback = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(is_viable_for_lycan_bane)), \
		damage_multiplier = 1.25, \
		label_text = "lycans", \
	)
	source.AddComponent( \
		/datum/component/bane, \
		should_bane_callback = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(is_viable_for_cursekin_bane)), \
		damage_multiplier = 0.35, \
		label_text = "cursekin", \
	)

/datum/material/silver/on_removed(atom/source, mat_amount, material_flags, from_slot)
	. = ..()
	if (!isitem(source))
		return

	for (var/datum/component/bane/bane_comp as anything in source.GetComponents(/datum/component/bane))
		var/datum/callback/cb = bane_comp.should_bane_callback
		if (!cb || cb.object != GLOBAL_PROC)
			continue
		if (cb.delegate == GLOBAL_PROC_REF(is_viable_for_lycan_bane) || cb.delegate == GLOBAL_PROC_REF(is_viable_for_cursekin_bane))
			qdel(bane_comp)

/proc/is_viable_for_cursekin_bane(atom/target)
	return iscursekin(target)
