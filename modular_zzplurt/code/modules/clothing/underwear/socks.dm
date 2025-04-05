/obj/item/clothing/underwear/socks
	name = "socks"
	desc = "A pair of socks."
	icon_state = "white_norm"
	body_parts_covered = FEET
	extra_slot_flags = ITEM_SLOT_SOCKS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/underwear/socks/equipped(mob/living/user, slot)
	. = ..()
	var/slot_noextra = slot & ~ITEM_SLOT_EXTRA
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/human = user
	if(slot & ITEM_SLOT_EXTRA && slot_noextra & ITEM_SLOT_SOCKS)
		human.socks = name
		// Force an update when equipping to ensure visibility is properly set
		human.update_worn_socks()
	else
		human.socks = "Nude"

/obj/item/clothing/underwear/socks/dropped(mob/living/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/human = user
	human.socks = "Nude"
	// Force an update when dropping socks
	human.update_worn_socks()

/**
 * Do not declare new shirt or bra objects directly through typepaths, use SHIRT_OBJECT(class)/BRA_OBJECT(class) instead
 * Example:
 *
SOCKS_OBJECT(test)
	name = "test socks"
	icon_state = "test"
	flags_1 = IS_PLAYER_COLORABLE_1
	gender = MALE
	...
*/
