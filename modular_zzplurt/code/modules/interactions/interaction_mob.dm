/mob/living/proc/has_hands()
	return TRUE

/mob/living/proc/has_mouth()
	return TRUE

/mob/living/proc/mouth_is_free()
	return !is_mouth_covered()

/mob/living/proc/foot_is_free()
	return is_barefoot()

/mob/living/carbon/human/has_mouth()
	return get_bodypart(BODY_ZONE_HEAD)
