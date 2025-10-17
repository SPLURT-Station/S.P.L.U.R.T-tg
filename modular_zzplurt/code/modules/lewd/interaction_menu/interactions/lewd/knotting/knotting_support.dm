// This file adds knotting support to existing interactions

// called on all lewd acts to ensure the knot is removed if the slot is needed by another interaction
// even if that interaction can't knot
// allow_act dosen't work, can_interact calls it causing ties to be imediately untied when the ui updates
/datum/interaction/lewd/act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	knot_check_remove(user, target, knotfucking)
	..()

// Calls knot_try for actions with knotting support when the user with a penis cums
/datum/interaction/lewd/post_climax(mob/living/carbon/human/cumming, mob/living/carbon/human/came_in, position)
	if(!knotting_supported)
		return ..()
	if(cum_genital[position] == CLIMAX_PENIS)
		knot_try(cumming, came_in, position, knotfucking)
	..()

/* HOW TO ADD KNOTTING SUPPORT TO YOUR INTERACTION
	The majority of interactions just need knotting_supported = TRUE

	knotfucking interactions should extend /datum/interaction/lewd/knotting/knotfucking
	this will set the knotfucking and knotting_supported vars to TRUE
	and call knot_try in that interaction's act proc with automatic top detection

	if your interaction is abnormal you may need to define the additional variables
	nipplefuck is a good example

	parts that will require these additional values
		ORGAN_SLOT_EYES
		ORGAN_SLOT_EARS
		ORGAN_SLOT_NIPPLES

	user_knotting_require: list of additional parts required by the user
	target_knotting_require: list of additional parts required by the target
	custom_slot: the slot that will be knotted
*/

// fuck/anal inherits this
/datum/interaction/lewd/fuck
	knotting_supported = TRUE

/datum/interaction/lewd/facefuck_penis
	knotting_supported = TRUE

/datum/interaction/lewd/throatfuck
	knotting_supported = TRUE

/datum/interaction/lewd/mount_vagina
	knotting_supported = TRUE

/datum/interaction/lewd/mount_anus
	knotting_supported = TRUE

/datum/interaction/lewd/oral_penis
	knotting_supported = TRUE

/datum/interaction/lewd/nipplefuck
	knotting_supported = TRUE
	target_knotting_require = list(ORGAN_SLOT_NIPPLES)
	custom_slot = ORGAN_SLOT_NIPPLES

/datum/interaction/lewd/extreme/earfuck
	knotting_supported = TRUE
	target_knotting_require = list(ORGAN_SLOT_EARS)
	custom_slot = ORGAN_SLOT_EARS

/datum/interaction/lewd/extreme/earsocketfuck
	knotting_supported = TRUE
	target_knotting_require = list(ORGAN_SLOT_EARS)
	custom_slot = ORGAN_SLOT_EARS

/datum/interaction/lewd/extreme/eyefuck
	knotting_supported = TRUE
	target_knotting_require = list(ORGAN_SLOT_EYES)
	custom_slot = ORGAN_SLOT_EYES

/datum/interaction/lewd/extreme/eyesocketfuck
	knotting_supported = TRUE
	target_knotting_require = list(ORGAN_SLOT_EYES)
	custom_slot = ORGAN_SLOT_EYES
