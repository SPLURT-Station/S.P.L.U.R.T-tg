// Allow sunwalker to spawn as a 1/100 chance
/datum/dynamic_ruleset/midround/from_ghosts/voidwalker/create_ruleset_body()

	if(prob(1))
		return new /mob/living/basic/voidwalker/sunwalker
	return new /mob/living/basic/voidwalker
