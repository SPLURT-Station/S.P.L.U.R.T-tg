/obj/item/clothing/bellyriding_harness
	name = "taur harness"
	icon = 'icons/obj/bed.dmi'
	icon = 'modular_skyrat/master_files/icons/obj/clothing/under/misc.dmi'
	icon_state = "gear_harness"
	slot_flags = ITEM_SLOT_OCLOTHING

/obj/item/clothing/bellyriding_harness/equipped(mob/user, slot, initial)
	. = ..()
	if(ishuman(user) && slot == ITEM_SLOT_OCLOTHING)
		user.AddComponent(/datum/component/bellyriding, src)
	else
		qdel(user.GetComponent(/datum/component/bellyriding)) // qdel accepts null and this is easier than wondering if dropped() actually works

/obj/item/clothing/bellyriding_harness/can_mob_unequip(mob/user)
	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer))
		return ..()

	if(wearer.get_slot_by_item(src) == ITEM_SLOT_OCLOTHING)
		var/datum/component/bellyriding/rider_comp = wearer.GetComponent(/datum/component/bellyriding)
		if(rider_comp && rider_comp.current_victim)
			to_chat(user, span_warning("Someone is currently riding [wearer == user ? "you" : wearer], untie them first!"))
			return FALSE

	return ..()

/obj/item/clothing/bellyriding_harness/dropped(mob/user, silent)
	. = ..()
	qdel(user.GetComponent(/datum/component/bellyriding)) // qdel accepts null
