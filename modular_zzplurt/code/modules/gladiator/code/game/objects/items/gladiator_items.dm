/obj/item/claymore/dragonslayer
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE //Can be worn on back, or in suit storage with berserker armor
	w_class = WEIGHT_CLASS_BULKY //Allows it to fit in suit storage slot on berserker armor
	worn_icon_state = "claymore" //Use regular claymore sprite when worn
	block_chance = 25 //Restore original skyrat behavior by way of override

/obj/item/claymore/dragonslayer/mob_can_equip(mob/living/user, slot, disable_warning, bypass_equip_delay_self, ignore_equipped)
	. = ..()
	if(!. || slot != ITEM_SLOT_SUITSTORE)
		return
	var/obj/item/clothing/suit/hooded/berserker/gatsu/armor = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(armor))
		if(!disable_warning)
			to_chat(user, span_warning("[src] can only be carried by the berserker armor!"))
		return FALSE

/obj/item/clothing/suit/hooded/berserker/gatsu/Initialize(mapload)
	. = ..()
	allowed += /obj/item/claymore/dragonslayer //Allow dragonslayer in suit storage
