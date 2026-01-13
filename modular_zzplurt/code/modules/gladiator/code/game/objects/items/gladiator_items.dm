/obj/item/claymore/dragonslayer
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE //Can be worn on the back or in suit storage like other large mining weapons
	w_class = WEIGHT_CLASS_BULKY //Reduce from HUGE to BULKY so it fits in suit storage
	worn_icon_state = "claymore" //Use regular claymore sprite when worn on back
	block_chance = 25 //Restore original skyrat behavior by way of override

/obj/item/clothing/suit/hooded/berserker/gatsu/Initialize(mapload)
	. = ..()
	allowed += /obj/item/claymore/dragonslayer //Allow dragonslayer in suit storage
