/// Adjusts the parent human's minimum arousal value based off the value assigned to `arous.` Returns the `overflow` that exceeds the cap
/mob/living/proc/adjust_minimum_arousal(arous)
	var/overflow = 0
	if((src.additional_minimum_arousal + arous) > AROUSAL_HIGH)
		overflow = (src.additional_minimum_arousal + arous) - AROUSAL_HIGH
	src.additional_minimum_arousal = clamp(src.additional_minimum_arousal + arous, AROUSAL_MINIMUM, AROUSAL_HIGH)
	src.adjust_arousal(arous)
	return overflow
