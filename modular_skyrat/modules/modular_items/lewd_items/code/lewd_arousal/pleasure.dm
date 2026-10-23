/mob/living/proc/adjust_pleasure(pleas = 0, mob/living/partner, datum/interaction/interaction, position) // SPLURT EDIT - mobs interactable
	#ifndef TESTING
	if(stat >= DEAD || !(client?.prefs?.read_preference(/datum/preference/toggle/erp) || (!ishuman(src) && !src.client && !SSinteractions.is_blacklisted(src)))) // SPLURT EDIT - mobs interactable
		return
	#endif

	// SPLURT EDIT - Lust tolerance
	var/lust_tolerance = 1
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		lust_tolerance = H.dna.features["lust_tolerance"] || 1
	// SPLURT EDIT END

	pleasure = clamp(pleasure + pleas, AROUSAL_MINIMUM, AROUSAL_LIMIT * lust_tolerance) // SPLURT EDIT - Lust tolerance

	if((pleasure >= AROUSAL_AUTO_CLIMAX_THRESHOLD * lust_tolerance) && (pleas > 0)) // lets cum // SPLURT EDIT - Lust tolerance
		climax(manual = FALSE, partner = partner, climax_interaction = interaction, interaction_position = position)
