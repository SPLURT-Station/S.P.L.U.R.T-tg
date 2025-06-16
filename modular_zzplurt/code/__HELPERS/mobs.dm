///Checks if a human mob is a prisoner
/proc/isprisoner(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	return H.mind?.assigned_role.title == "Prisoner"
