/datum/component/wearertargeting/earprotection/Initialize(valid_slots, reduce_amount)
	if(LAZYFIND(src.valid_slots, ITEM_SLOT_EARS))
		LAZYADD(src.valid_slots, list(ITEM_SLOT_EARS_LEFT, ITEM_SLOT_EARS_RIGHT))
	. = ..()
