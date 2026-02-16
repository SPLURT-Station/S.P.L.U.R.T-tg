// Advanced brainwash disk
/obj/item/disk/nifsoft_uploader/dorms/hypnosis/brainwashing
	name = "mesmer eye"
	loaded_nifsoft = /datum/nifsoft/action_granter/hypnosis/brainwashing

// More advanced variant for full brainwashing
/datum/nifsoft/action_granter/hypnosis/brainwashing
	name = "Mesmer Eye"
	program_desc = "Based on illegal abductor technology, the Mesmer Eye NIFSoft allows programming new directives into a target. Victims may still resist being given an order without proper persuasion. ((This is not the intended tool for ERP hypnosis. Use Libidine Eye instead.))"

	// Has a cost
	active_cost = 0.1
	activation_cost = 1

	// Cannot be kept
	able_to_keep = FALSE

	// Grants different action
	action_to_grant = /datum/action/cooldown/hypnotize/brainwash

// Performed when installing the NIF
/obj/item/disk/nifsoft_uploader/dorms/hypnosis/brainwashing/attempt_software_install(mob/living/carbon/human/target)
	. = ..()

	// Check parent return
	if(. == FALSE)
		// Do nothing
		return

	// Provide warning text
	to_chat(target, span_doyourjobidiot("Do not use the Mesmer Eye to convert other crew members into antagonists.\
		Neither you nor the target are exempt from normal server standards. Act accordingly."))
