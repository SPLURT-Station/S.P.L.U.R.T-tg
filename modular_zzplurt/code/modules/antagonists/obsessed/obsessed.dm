// Blegh it only added the trauma if we used 'admin_add()'

/datum/antagonist/obsessed/on_gain()
	. = ..()
	var/mob/living/carbon/C = owner.current
	C.gain_trauma(/datum/brain_trauma/special/obsessed)
