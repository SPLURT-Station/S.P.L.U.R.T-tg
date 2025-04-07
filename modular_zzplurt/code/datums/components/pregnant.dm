/**
 * Once the pregnancy is done, eggs (or other objects) become ACTUALLY on GOD fr fr pregnant
 * AKA a ghost can click on it and become the fucking son/daughter/nonbinaryghter
 */
/datum/component/pregnant
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// The baby stored inside us
	var/mob/living/baby_boy

/datum/component/pregnant/Initialize(datum/component/pregnancy/gestater, mob/living/baby_boy)
	if(!isatom(parent) || isarea(parent))
		return COMPONENT_INCOMPATIBLE
