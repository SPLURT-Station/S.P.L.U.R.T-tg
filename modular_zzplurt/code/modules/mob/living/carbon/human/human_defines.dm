/mob/living/carbon/human
	//Extra inventory
	var/obj/item/clothing/underwear/briefs/w_underwear = null
	var/obj/item/clothing/underwear/socks/w_socks = null
	var/obj/item/clothing/underwear/shirt/w_shirt = null
	var/obj/item/clothing/underwear/shirt/bra/w_bra = null
	var/obj/item/ears_extra = null
	var/obj/item/wrists = null
	//

/// Called when preferences are applied to the character at spawn or character creation
/mob/living/carbon/human/proc/on_preference_applied()
	// SPLURT EDIT START: Fix underwear color not applying correctly on spawn
	if(w_underwear && (w_underwear.flags_1 & IS_PLAYER_COLORABLE_1))
		w_underwear.color = underwear_color

	if(w_socks && (w_socks.flags_1 & IS_PLAYER_COLORABLE_1))
		w_socks.color = socks_color

	if(w_shirt && (w_shirt.flags_1 & IS_PLAYER_COLORABLE_1))
		w_shirt.color = undershirt_color
	if(w_bra && (w_bra.flags_1 & IS_PLAYER_COLORABLE_1))
		w_bra.color = bra_color

	// Force update visual representations
	update_underwear_on_bodytype_change()
	// SPLURT EDIT END

