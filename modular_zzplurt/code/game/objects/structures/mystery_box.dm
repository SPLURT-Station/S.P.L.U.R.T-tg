// Definition of the fishing mystery box subtype
/obj/structure/mystery_box/fishing
	// When adding new jobs to the blacklist, follow this formate and use a "," . (e.g. JOB_PRISONER, JOB_MIME)
	var/list/blacklisted_jobs = list(JOB_PRISONER)

// Override of the attack_hand method for the fishing mystery box
/obj/structure/mystery_box/fishing/attack_hand(mob/living/user, list/modifiers)
	if(user.mind?.assigned_role.title in blacklisted_jobs)
		to_chat(user, span_warning("As a [user.mind.assigned_role.title], you are not worthy to open this treasure chest."))
		return

	// Call the parent attack_hand method if the user's job is not blacklisted
	return ..()
