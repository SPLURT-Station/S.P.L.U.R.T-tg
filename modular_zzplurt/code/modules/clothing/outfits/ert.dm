/datum/outfit/centcom/ert/clown/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	var/obj/item/organ/bladder/bladder = H.get_organ_slot(ORGAN_SLOT_BLADDER)
	if(bladder)
		bladder.Remove(H, TRUE)
		QDEL_NULL(bladder)
		bladder = new /obj/item/organ/bladder/clown
		bladder.Insert(H)
