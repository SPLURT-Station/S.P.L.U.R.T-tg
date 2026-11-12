/obj/item/organ/heart/lycan
	name = "lupine heart"
	desc = "A large heart that beats powerfully. The veins on it are far larger than normal."

/obj/item/organ/heart/lycan/on_mob_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	var/mob/living/carbon/human/human_owner = organ_owner

	if(islycan(organ_owner))
		// SPLURT EDIT CHANGE
		MODIFY_PHYSIOLOGY(human_owner, BRUTE, 0.8) // was 0.5
		MODIFY_PHYSIOLOGY(human_owner, BURN, 1.2) // was 0.8
		// SPLURT EDIT CHANGE END

/obj/item/organ/heart/lycan/on_mob_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	var/mob/living/carbon/human/human_owner = organ_owner

	if(human_owner.physiology)
		// SPLURT EDIT CHANGE
		MODIFY_PHYSIOLOGY(human_owner, BRUTE, 0.8) // was 0.5
		MODIFY_PHYSIOLOGY(human_owner, BURN, 1.2) // was 0.8
		// SPLURT EDIT CHANGE END
