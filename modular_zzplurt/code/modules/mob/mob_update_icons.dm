/mob/update_clothing(slot_flags)
	. = ..()
	if((slot_flags & ITEM_SLOT_WRISTS) && (slot_flags & ITEM_SLOT_EXTRA))
		update_worn_wrists()
	if((slot_flags & ITEM_SLOT_SOCKS) && (slot_flags & ITEM_SLOT_EXTRA))
		update_worn_socks()
	if((slot_flags & ITEM_SLOT_UNDERWEAR) && (slot_flags & ITEM_SLOT_EXTRA))
		update_worn_underwear()
	if((slot_flags & ITEM_SLOT_SHIRT) && (slot_flags & ITEM_SLOT_EXTRA))
		update_worn_shirt()
	if((slot_flags & ITEM_SLOT_BRA) && (slot_flags & ITEM_SLOT_EXTRA))
		update_worn_bra()
	if((slot_flags & ITEM_SLOT_EARS_RIGHT))
		update_worn_ears_extra()

/mob/update_obscured_slots(obscured_flags)
	. = ..()
	if(obscured_flags & HIDEWRISTS)
		update_worn_wrists(update_obscured = FALSE)
	if(obscured_flags & HIDEUNDERWEAR)
		update_worn_underwear(update_obscured = FALSE)
		update_worn_shirt(update_obscured = FALSE)
		update_worn_socks(update_obscured = FALSE)

///Updates the underwear overlay & HUD element.
/mob/proc/update_worn_underwear(update_obscured = FALSE)
	return

///Updates the shirt overlay & HUD element.
/mob/proc/update_worn_shirt(update_obscured = FALSE)
	return

///Updates the bra overlay & HUD element.
/mob/proc/update_worn_bra(update_obscured = FALSE)
	return

///Updates the socks overlay & HUD element.
/mob/proc/update_worn_socks(update_obscured = FALSE)
	return

///Updates the wrists overlay & HUD element.
/mob/proc/update_worn_wrists(update_obscured = FALSE)
	return

///Updates the headset on the other side overlay & HUD element.
/mob/proc/update_worn_ears_extra(update_obscured = FALSE)
	return
