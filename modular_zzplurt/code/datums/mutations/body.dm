/datum/mutation/human/gigantism/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return

	owner.update_size(get_size(owner) * 1.25)

/datum/mutation/human/gigantism/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.update_size(get_size(owner) * 0.8)
