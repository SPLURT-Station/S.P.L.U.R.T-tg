// This file adds knotting support to existing interactions

// /datum/interaction/lewd/fuck/anal inherits from fuck

/datum/interaction/lewd/fuck // vaginal and anal initiated by the penis haver
	knotting_supported = TRUE

/datum/interaction/lewd/fuck/post_climax(mob/living/carbon/human/cumming, mob/living/carbon/human/came_in, position)
	if(position == CLIMAX_POSITION_USER)
		knot_try(cumming, came_in)
	. = ..()

// allow_act dosen't work, can_interact calls it causing ties to be imediately untied when the ui updates
/datum/interaction/lewd/fuck/act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	knot_check_remove(user, target)
	..()

// This is not all of the interactions that should have knotting support
// I just haven't added the others yet
