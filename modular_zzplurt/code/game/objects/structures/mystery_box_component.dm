/datum/component/prisoner_mystery_box_check
	var/allow_prisoners = FALSE

/datum/component/prisoner_mystery_box_check/Initialize(allow_prisoners = FALSE)
	. = ..()
	src.allow_prisoners = allow_prisoners
	RegisterSignal(parent, COMSIG_FISHING_MYSTERY_BOX_ACTIVATE, .proc/on_activate)

/datum/component/prisoner_mystery_box_check/proc/on_activate(datum/source, mob/living/user)
	SIGNAL_HANDLER

	if(!allow_prisoners && isprisoner(user))
		to_chat(user, span_warning("As a prisoner, you are not allowed to open this treasure chest."))
		return COMPONENT_CANCEL_MYSTERY_BOX
