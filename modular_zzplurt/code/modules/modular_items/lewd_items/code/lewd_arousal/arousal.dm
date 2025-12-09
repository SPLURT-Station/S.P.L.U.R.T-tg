
/mob/living/adjust_arousal(arous = 0)
	. = ..()
	if(.)
		var/user_min_arousal = src.additional_minimum_arousal
		if(!user_min_arousal > 0)
			user_min_arousal = AROUSAL_MINIMUM
		arousal = clamp(arousal + arous, user_min_arousal, AROUSAL_LIMIT)
	return(.)

/// Adjusts the parent human's minimum arousal value based off the value assigned to `arous.` Returns the `overflow` that exceeds the cap
/mob/living/proc/adjust_minimum_arousal(arous)
	var/overflow = 0
	if((src.additional_minimum_arousal + arous) > AROUSAL_HIGH)
		overflow = (src.additional_minimum_arousal + arous) - AROUSAL_HIGH
	src.additional_minimum_arousal = clamp(src.additional_minimum_arousal + arous, AROUSAL_MINIMUM, AROUSAL_HIGH)
	src.adjust_arousal(arous)
	return overflow
