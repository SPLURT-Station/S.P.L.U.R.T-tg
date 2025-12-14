/datum/job/clown/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/obj/item/organ/bladder/bladder = spawned.get_organ_slot(ORGAN_SLOT_BLADDER)
	if(bladder)
		bladder.Remove(spawned, TRUE)
		QDEL_NULL(bladder)
		bladder = new/obj/item/organ/bladder/clown
		bladder.Insert(spawned)
